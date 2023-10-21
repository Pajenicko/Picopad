import struct

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


def create_uf2_block(data, address):
    # Fill remaining space with 0xFF
    data += b"\xFF" * (PAYLOAD_SIZE - len(data))

    block_header = struct.pack(
        "<IIIIIIII",
        UF2_MAGIC_START0,
        UF2_MAGIC_START1,
        0x00002000,  # flags
        address,
        len(data),
        0,  # block_no (not important here)
        0,  # num_blocks (not important here)
        BLOCK_SIZE  # total size of this block
    )

    return block_header + data + b"\x00" * (BLOCK_SIZE - len(block_header) - len(data))


def append_app_to_uf2(app_file_path, loader_file_path, uf2_file_path):
    # Read the existing UF2 blocks
    blocks = read_uf2_blocks(loader_file_path)

    # Read the data to append
    with open(app_file_path, "rb") as f:
        data_to_append = f.read()

    # Determine start address of the new data
    last_block = blocks[-1]
    _, _, _, last_block_address, last_block_payload_size, _, _, _ = struct.unpack("<IIIIIIII", last_block[:32])
    new_data_address = last_block_address + last_block_payload_size

    # Check if padding is needed // 0x10006E00
    if new_data_address < APPLICATION_START_ADDRESS:
        padding_size = APPLICATION_START_ADDRESS - new_data_address
        padding_blocks = padding_size // PAYLOAD_SIZE
        for _ in range(padding_blocks):
            block = create_uf2_block(b"", new_data_address)
            blocks.append(block)
            new_data_address += PAYLOAD_SIZE

    # Split data into 256-byte chunks and create UF2 blocks for each chunk
    for i in range(0, len(data_to_append), PAYLOAD_SIZE):
        chunk = data_to_append[i:i + PAYLOAD_SIZE]
        block = create_uf2_block(chunk, new_data_address + i)
        blocks.append(block)

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


app_file_path = "TODO.bin"
uf2_file_path = "TODO.UF2"
loader_file_path = "LOADER.UF2"
append_app_to_uf2(app_file_path, loader_file_path, uf2_file_path)
add_crc(app_file_path, uf2_file_path)
