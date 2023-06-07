// PLL system clock calculator for Raspberry Pico

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
	double	freq;
	int		fbdiv;
	int		vco;
	int		pd1;
	int		pd2;
} sPLL;

// list of frequencies
#define MAXFREQ	10000
sPLL PLLlist[MAXFREQ];
int PLLnum = 0;

int main(int argc, char* argv[])
{
	int input, minclk, maxclk, fbdiv, vco, pd1, pd2, i;
	double freq;
	sPLL* pll;

	// check syntax
	if (argc != 4)
	{
		printf("Syntax: PicoClock input min max\n");
		printf("    input ... quartz frekvency in kHz (usually 12000)\n");
		printf("    min ..... minimal system clock in kHz\n");
		printf("    max ..... maximal system clock in kHz\n");
		return 1;
	}

	// load parameters
	input = atoi(argv[1]);
	minclk = atoi(argv[2]);
	maxclk = atoi(argv[3]);

	// fbdiv loop
	for (fbdiv = 16; fbdiv <= 320; fbdiv++)
	{
		// get current vco
		vco = fbdiv * input;

		// check valid vco range (400 to 1600 MHz)
		if ((vco >= 400000) && (vco <= 1600000))
		{
			// pd1 loop
			for (pd1 = 7; pd1 >= 1; pd1--)
			{
				// pd2 loop
				for (pd2 = pd1; pd2 >= 1; pd2--)
				{
					// current output frequency
					freq = (double)vco / (pd1 * pd2);

					// check frequency range
					if ((freq >= minclk) && (freq <= maxclk))
					{
						// find position in table
						for (i = 0; i < PLLnum; i++)
						{
							if ((PLLlist[i].freq > freq) ||
								((PLLlist[i].freq == freq) && (PLLlist[i].vco > vco)))
								break;
						}
				
						// shift remaining frequencies
						pll = &PLLlist[i];
						if (i < PLLnum) memmove(pll+1, pll, sizeof(sPLL)*(PLLnum-i));

						// store new frequency
						pll->freq = freq;
						pll->fbdiv = fbdiv;
						pll->vco = vco;
						pll->pd1 = pd1;
						pll->pd2 = pd2;
						PLLnum++;;
					}
				}
			}
		}
	}

	// list frequencies
	pll = PLLlist;
	for (i = 0; i < PLLnum; i++)
	{
		printf("sysclk=%.6f MHz, vco=%g MHz, fbdiv=%d, pd1=%d, pd2=%d\n",
			pll->freq*0.001, pll->vco*0.001, pll->fbdiv, pll->pd1, pll->pd2);
		pll++;
	}
	return 0;
}
