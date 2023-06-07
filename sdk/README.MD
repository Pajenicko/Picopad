# Picopad SDK
------------------------------------------
Miroslav Nemecek, panda38.sweb.cz, Panda38@seznam.cz

**Note: Alpha Version - Work in Progress**

Please be aware that the content in this repository is an alpha version and is not fully completed. It is a work in progress, and there may be missing features, bugs, or incomplete sections. Use this content with caution and expect updates and improvements in the future.

Thank you for your understanding as we continue to develop and refine this project.

## How to install:
- Install compiler gcc-arm-none-eabi-10-2020 into folder C:\ARM10
- Unpack this package into some folder

If you have gcc compiler installed in another folder,
edit PATH in files _c1.bat and _boot2\c.bat

I recommend FAR Manager as a program editor - it contains very useful console output.

To compile the demo project, run c.bat (or c_all.bat to compile all).
To clear the demo project, run d.bat (or d_all.bat to clear all).
To write the demo project to the Pico board:
- Press and hold the BOOTSEL button on the Pico board.
- Connect the USB cable.
- Release the BOOTSEL button.
- Edit the destination drive (now there is r:) in the file _e1.bat, command:
    ```
    copy /b program.uf2 r:
    ```
  and then run e.bat 
  ... or drag and drop the file 'program.uf2' to the Pico drive.