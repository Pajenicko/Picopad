PC/DOS program samples are compiled with:

Turbo Assembler version 3.2
---------------------------
On 32-bit Windows, you can run it directly - use !COMP32.BAT.

On 64-bit Windows, you will need some DOS emulator, like DOSBox:

1) Download Turbo-Assembler from https://cspsyco.blogspot.com/p/tasm-download.html
2) Download DOSBox from https://sourceforge.net/projects/dosbox/postdownload
3) Install DOSBox (can use default setup)
4) Unpack TASM.ZIP into sub-folder TASM
5) Go to install folder of DOSBox (default "C:\Program Files (x86)\DOSBox-0.74-3")
   and run "DOSBox 0.74-3 Options.bat", this will open "dosbox-0.74-3.conf" configuration file.
6) Add following commands to end of file ([autoexec] group) - use full path to your
   directory with TASM program. Save and close.
mount c "your_full_path"
c:
call !comp32.bat
exit
7) Run DOSBox to compile - use icon on desktop, or use !COMP64.BAT


Digger is compiled with Lattice C V2.12
---------------------------------------


Games and programs in this directory
------------------------------------
ALPHABET ... Alphabet for little ones
CENTIPED ... Centiped
CHESS ...... Chess
CONTAX ..... Contax
DIGGER ..... Digger
EGGS ....... Eggs
FLOPBIRD ... Floppy Bird
GOODY ...... Goody
LINES ...... Lines Demo
MANDELB .... Mandelbrot generator
MINIMAZE ... Mini-Maze
MISION ..... Mision
PANGO ...... Pango
PATROL ..... Moon Patrol
PCMAN ...... PC-Man
SPACEWAR ... Space War
SPOTS ...... Spots Demo
TENNIS ..... Tennis
TETRIX ..... Tetrix
TOWER ...... Tower Toppler
TRAIN ...... Train
VEGAS ...... Vegas - Slot Machine
VLEAPER .... VGA Leaper
ZOOM ....... Buck Rogers-Planet of Zoom
