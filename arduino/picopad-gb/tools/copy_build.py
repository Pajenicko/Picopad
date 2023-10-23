Import("env")
import os
import shutil
import struct
from os.path import join

build_profile = env.subst("$PIOENV")

# Constants for UF2 format
UF2_MAGIC_START0 = 0x0A324655  # "UF2\n"
UF2_MAGIC_START1 = 0x9E5D5157  # Randomly selected
UF2_MAGIC_END = 0x0AB16F30  # Ditto
BLOCK_SIZE = 512
PAYLOAD_SIZE = 256
APPLICATION_START_ADDRESS = 0x10008000
LOADER_SIZE = 0x8000


def read_uf2_blocks(file_path):
    blocks = []
    with open(file_path, "rb") as f:
        while True:
            block = f.read(BLOCK_SIZE)
            if not block:
                break
            if len(block) != BLOCK_SIZE:
                raise ValueError("Incomplete UF2 block")
            blocks.append(block)
    return blocks


def create_uf2_block(data, address, block_no, num_blocks):
    # Fill remaining space with 0xFF
    data += b"\x00" * (PAYLOAD_SIZE - len(data))
    datapadding = b""
    while len(datapadding) < BLOCK_SIZE - PAYLOAD_SIZE - 32 - 4:
        datapadding += b"\x00\x00\x00\x00"

    block_header = struct.pack(
        "<IIIIIIII",
        UF2_MAGIC_START0,
        UF2_MAGIC_START1,
        0x00002000,  # flags
        address,
        len(data),
        block_no,  # block number
        num_blocks,  # total number of blocks
        BLOCK_SIZE  # total size of this block
    )

    block = block_header + data + datapadding + struct.pack(b"<I", UF2_MAGIC_END)
    assert len(block) == 512

    return block


def append_app_to_uf2(app_file_path, loader_file_path, uf2_file_path):
    # Read the existing UF2 blocks
    blocks = read_uf2_blocks(loader_file_path)

    # Read the data to append
    with open(app_file_path, "rb") as f:
        data_to_append = f.read()

    # Determine the total number of blocks
    total_data_size = len(data_to_append)
    num_blocks = (total_data_size + PAYLOAD_SIZE - 1) // PAYLOAD_SIZE  # rounding up

    # Determine start address of the new data
    last_block = blocks[-1]
    _, _, _, last_block_address, last_block_payload_size, _, _, _ = struct.unpack("<IIIIIIII", last_block[:32])
    new_data_address = last_block_address + last_block_payload_size

    existing_blocks_count = len(blocks)  # count of blocks that already exist

    # Check if padding is needed // 0x10006E00
    if new_data_address < APPLICATION_START_ADDRESS:
        padding_size = APPLICATION_START_ADDRESS - new_data_address
        padding_blocks = padding_size // PAYLOAD_SIZE
        for i in range(padding_blocks):
            block = create_uf2_block(b"", new_data_address, i, padding_blocks + num_blocks)
            blocks.append(block)
            existing_blocks_count += 1
            new_data_address += PAYLOAD_SIZE

    # Split data into 256-byte chunks and create UF2 blocks for each chunk
    for i in range(0, len(data_to_append), PAYLOAD_SIZE):
        chunk = data_to_append[i:i + PAYLOAD_SIZE]
        block = create_uf2_block(chunk, new_data_address, existing_blocks_count, num_blocks)
        blocks.append(block)
        existing_blocks_count += 1
        new_data_address += PAYLOAD_SIZE  # update the address for the next block

    for i in range(0, len(blocks)):
        header = list(struct.unpack("<IIIIIIII", blocks[i][:32]))
        header[5] = i
        header[6] = len(blocks)
        header[7] = 0xE48BFF56
        new_header = struct.pack("<IIIIIIII", *header)
        blocks[i] = new_header + blocks[i][32:]

    # Write all the blocks back to the UF2 file
    with open(uf2_file_path, "wb") as f:
        for block in blocks:
            f.write(block)


def rev(n):
    return ((n & 0xff) << 24) | ((n & 0xff00) << 8) | ((n & 0xff0000) >> 8) | ((n & 0xff000000) >> 24)


def crc32(data):
    r2 = 0xffffffff
    r5 = 0x04c11db7

    for byte in data:
        r4 = byte
        r3 = rev(r2)
        r4 ^= r3
        r4 <<= 24

        for _ in range(8):
            if (r4 & 0x80000000) != 0:
                r4 <<= 1
                r4 ^= r5
            else:
                r4 <<= 1

        r2 <<= 8
        r2 ^= r4
        r2 &= 0xffffffff  # Ensure it stays a 32-bit number

    return r2


def add_crc(bin_file_path, uf2_file_path):
    with open(bin_file_path, "rb") as f:
        buf = f.read()

    size = len(buf)
    if size <= 51 * 4:
        raise ValueError(f"Incorrect {bin_file_path} file size")

    header = struct.unpack("<III", buf[48 * 4:51 * 4])

    if (header[0] != 0x44415050 or  # magic "PPAD"
            header[1] != 0x01234567 or  # application length
            header[2] != 0x89ABCDEF):  # application CRC
        raise ValueError(f"Incorrect format of {bin_file_path}")

    size -= 51 * 4
    # calculate CRC
    app_crc = crc32(buf[51 * 4:])

    with open(uf2_file_path, "r+b") as f:
        f.seek(2 * LOADER_SIZE + 32 + 48 * 4)
        uf2_header = struct.unpack("<III", f.read(12))

        if (uf2_header[0] != 0x44415050 or  # magic "PPAD"
                uf2_header[1] != 0x01234567 or  # application length
                uf2_header[2] != 0x89ABCDEF):  # application CRC
            raise ValueError(f"Incorrect format of {uf2_file_path}")

        f.seek(2 * LOADER_SIZE + 32 + 49 * 4)
        f.write(struct.pack("<II", size, app_crc))


def post_program_action(source, target, env):
    build_dir = env.subst("$BUILD_DIR")
    prog_name = env.get("PROGNAME")

    if not os.path.exists(os.path.join("build")):
        # Create a new directory because it does not exist
        os.makedirs(os.path.join("build"))

    # Removes all files from the build.
    for filename in os.listdir(os.path.join("build")):
        file_path = os.path.join("build", filename)
        if os.path.isfile(file_path):
            os.remove(file_path)

    # Copies all files from the assets directory to the build directory.
    if build_profile == "picopad":
        for filename in os.listdir("assets"):
            source_path = os.path.join("assets", filename)
            destination_path = os.path.join("build", filename)
            if os.path.isfile(source_path):
                shutil.copy2(source_path, destination_path)

    # Copy build to build directory
    if build_profile == "picopad":
        app_file_path = os.path.join(build_dir, f"{prog_name}.bin")
        uf2_file_path = os.path.join(build_dir, f"2{prog_name}.uf2")
        loader_file_path = join("patches", "LOADER.UF2")
        append_app_to_uf2(app_file_path, loader_file_path, uf2_file_path)
        add_crc(app_file_path, uf2_file_path)
        source_path = uf2_file_path
        destination_path = os.path.join("build", f"{prog_name}.UF2")
    else:
        source_path = os.path.join(build_dir, f"{prog_name}.uf2")
        destination_path = os.path.join("build", f"{prog_name}.UF2")

    shutil.copy2(source_path, destination_path)


env.AddPostAction("$BUILD_DIR/${PROGNAME}.bin", post_program_action)
