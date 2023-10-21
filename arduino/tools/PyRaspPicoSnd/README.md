# PyRaspPicoSnd - Audio to C++ Array Converter

This Python script converts audio files into a C++ array format. The audio is processed to match a specific Picopad PWM
audio format: PCM, mono, 8-bit unsigned, with a sample rate of 22050Hz.

## Prerequisites

- Python 3
- `ffmpeg`: A tool used for audio format decoding. Ensure that `ffmpeg` is installed and is accessible in your system's
  PATH.

## Usage

1. Navigate to the directory containing the script.
2. Run the script using:

   ```bash
   python PyRaspPicoSnd.py <input_file> <output_file.c> <array_name>
   ```

   Replace `<input_file>` with your source audio file, `<output_file.c>` with the desired output file name,
   and `<array_name>` with the desired C++ array name.

   Example:
   ```bash
   python PyRaspPicoSnd.py sample.wav sample_output.c AudioArray
   ```

3. After execution, you'll have a `.c` file that contains the audio data in a C++ array format.

## Arguments

- `input_file`: Path to the source audio file. Supports any format that `ffmpeg` or `avconv` can decode (e.g., .mp3,
  .wav, .ogg).

- `output_file.c`: The desired name for the output `.c` file.

- `array_name`: The desired name for the C++ array.

## Help

You can display a detailed guide by running the script with `-h` or `--help` flag:

```bash
python PyRaspPicoSnd.py --help
```

## License

This script is freely available for any purpose, including commercial. You can modify or distribute it without
restriction.

## Author & Acknowledgments

- Original C code for WAV conversion by [Miroslav Nemecek](https://github.com/Panda381/PicoLibSDK)
