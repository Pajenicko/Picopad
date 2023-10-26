import subprocess
import os
import wave
import sys


def process_audio(input_file, output_file, array_name):
    """
    Convert an audio file to the desired format and then save its data to a C++ array in a .c file.

    Parameters:
        - input_file: Path to the audio file to convert.
        - output_file: Path to the output .c file.
        - array_name: Name of the C++ array that will hold the audio data.
    """

    # Name for the temporary audio file
    temporary_output = "temp_audio.wav"

    # Use ffmpeg to convert the audio file to the desired format (PCM, mono, 8-bit, 22050Hz)
    subprocess.run(["ffmpeg", "-i", input_file, "-acodec", "pcm_u8", "-ac", "1", "-ar", "22050",
                    "-fflags", "+bitexact", "-flags:v", "+bitexact", "-flags:a", "+bitexact", temporary_output])

    # Open the converted audio file to read its data
    with wave.open(temporary_output, 'rb') as wf:
        # Check if the converted audio file has the desired format
        if (wf.getnchannels() != 1 or wf.getframerate() != 22050 or
                wf.getsampwidth() != 1 or wf.getcomptype() != 'NONE'):
            print(f"Incorrect format of input file {input_file},")
            print("  must be PCM mono 8-bit 22050Hz.")
            # Delete the temporary audio file
            os.remove(temporary_output)
            return 1

        # Read the audio data from the converted file
        audio_bytes = wf.readframes(wf.getnframes())

    # Delete the temporary audio file
    os.remove(temporary_output)

    # Save the audio data to the output .c file
    with open(output_file, 'w') as out:
        out.write('#include "include.h"\n\n')
        out.write('// sound format: PCM mono 8-bit 22050Hz\n')
        out.write(f'const u8 {array_name}[{len(audio_bytes)}] __attribute__ ((aligned(4))) = {{')

        # Write each byte of the audio data to the .c file
        for index, byte in enumerate(audio_bytes):
            # Start a new line every 16 bytes for readability
            if index % 16 == 0:
                out.write("\n\t")
            out.write(f"0x{byte:02X}, ")

        out.write("\n};\n")


def print_help():
    """ Print the help message for this script. """
    help_message = """
    Audio to C++ Array Converter

    This script converts any supported audio file format to a Picopad audio format (PCM, mono, 8-bit unsigned, 22050Hz)
    and then outputs the audio data as a C++ array in a .c file.

    Usage:
        python script_name.py <input_file> <output_file.c> <array_name>

    Arguments:
        input_file:         Path to the audio input file (e.g. .mp3, .wav, .ogg, etc.)
        output_file.c:      Desired name for the output .c file.
        array_name:         Desired name for the array in the C++ file.

    Requirements:
        - Install pydub: pip install pydub
        - Ensure you have ffmpeg or avconv installed for audio decoding.
    """
    print(help_message)


if __name__ == "__main__":
    # Main entry point of the script
    # Check if the user is asking for help or if they didn't provide the necessary arguments
    if "--help" in sys.argv or "-h" in sys.argv or len(sys.argv) != 4:
        print_help()
        sys.exit(0)

    # Convert the audio file and save its data to the output .c file
    process_audio(sys.argv[1], sys.argv[2], sys.argv[3])
