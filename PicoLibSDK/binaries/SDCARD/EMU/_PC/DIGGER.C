
#define IBM	1	/* set up for IBM PC if equal to 1 */
/*#define HYP	1*/	/* set up for Hyperion if equal to 1 */


/* The following values produce a screen with 10 horizontal and 15 vertical positions 
   x_last = 280+x_offset 
   x_first= x_offset
   y_last = 162+y_offset
   y_first= y_offset	*/
#define		X_LAST		292
#define		X_FIRST		12
#define		Y_LAST		180
#define		Y_FIRST		18
#define		X_OFFSET	12
#define		Y_OFFSET	18
#define		H_MAX		10
#define		W_MAX		15

/* direction definitions */
#define	LEFT		4
#define	RIGHT		0
#define	UP		2
#define	DOWN		6
#define	STOP		(0-1)
#define	FALL_1	10
#define	FALL_2	11
#define	FALL_3	12
#define	FALL_4	13
#define	FALL_5	14
#define	FALL_9	15

/* mans starting position */
#define	M_X_START	7
#define	M_Y_START	9

/* screen color values */
#define BLACK		0
#define GREEN		1
#define	RED		2
#define	BROWN		3
#define	CYAN		1
#define	MAGENTA		2
#define	WHITE		3

/* death type definitions */
#define	MONEY_BAG	1
#define	MAN		2
#define	BUG		3
#define	DEAD		4
#define	BOUNCE		5

/* sprite type definitions */
#define	BAG_0		0
#define	BAG_4		1
#define	BAG_5		2
#define	BAG_6		3
#define	BAG_7		4
#define	BAG_8		5
#define	BAG_9		6

/* bug sprite types */
#define	ADVANCING	0
#define	NORMAL		1

#include <DIGGER.INC>

#define	FALSE		0
#define TRUE		(!0)

/* turn on debug - developement routines */
/* #define	DEBUG		1 */


/* use to generate a demo copy */
/*#define		FREEDEMO	1*/


extern	char	keychr, tick;
extern 	int	pdir, ldir, keydir, lkdir, fire, fires, endgame, sound, music;
extern 	int	defseg, joyx, joyy, butt1, butt2, sound2, sn2on, per2;

#define FALSE 0
#define TRUE  -1

/*  random number table  */

	char	rnd_table[] = {
		 74,130,197,120, 34,249,121,216,177,118, 72,228, 62,141,149,119,
		212,  3,106,123, 48, 21, 65,193,  9,138,  1,242,251,129, 60,160,
		 11, 40,152,128, 31,113, 43,131, 88,182,109,245,114,  2, 93,100,
		 42, 57,  7,219, 27, 54,214,194,236, 99, 18,237, 14, 20,132,155,
		181,124,252,148,168,201, 46,135, 76, 78,189, 47, 90, 81,195, 83,
		 68, 69, 24,183,157,198, 94, 26,192,244,200, 71, 41, 56,139,159,
		 73,227,241, 58, 17,  4,206,125,234, 82,188,215,247, 84,253,190,
		169,105,235, 75,136,204, 87,229, 23, 32, 67,117,175, 33,224,  6,
		185,150, 86, 91, 92,246,161,134,223,165, 13,153,104,103, 52,164,
		179,133,226,187,255,222,239,158, 28,202, 53, 61,112,145, 64, 19,
		180,207,140, 66,107,151,167,146, 38, 12, 49,170,250,143,166, 16,
		205, 51,176,174,231,210, 80, 96,243,163, 22,122,108,137, 30,240,
		 59, 79, 63,173, 50,101, 15,  8, 95, 25, 45,225, 39,218,116,221,
		 10,220,238, 77,186,217,144,154,147,  0,  5,111,230,203,102,184,
		162,208, 29,211, 70,156, 35,178,199, 85, 97,232,172,191, 89, 44,
		213, 36,142,254,248, 37,127,233,110,115,171,209, 55,126, 98,196	};

	int	rnd_seed;	/*  pointer to random number table  */

extern	int	defseg;		/*  data segment pointer for peek  */


/*	<<<<<<<<<<  Print Text String  >>>>>>>>>>	*/

prints(string,x,y,color)
int	x, y, color;
char	*string;
{
	int	n = 0;		/*  string pointer  */

	while (string[n]) {
		printc(string[n++],x,y,color);	/*  print character  */
		x += 12;			/* next character position  */
	}
}


/*	<<<<<<<<<<  Print Character  >>>>>>>>>>		*/

printc(chr,x,y,color)
char	chr;
int	x, y, color;
{
	switch (chr) {
		case 'A': put(x,y,char_a,color); break;
		case 'B': put(x,y,char_b,color); break;
		case 'C': put(x,y,char_c,color); break;
		case 'D': put(x,y,char_d,color); break;
		case 'E': put(x,y,char_e,color); break;
		case 'F': put(x,y,char_f,color); break;
		case 'G': put(x,y,char_g,color); break;
		case 'H': put(x,y,char_h,color); break;
		case 'I': put(x,y,char_i,color); break;
		case 'J': put(x,y,char_j,color); break;
		case 'K': put(x,y,char_k,color); break;
		case 'L': put(x,y,char_l,color); break;
		case 'M': put(x,y,char_m,color); break;
		case 'N': put(x,y,char_n,color); break;
		case 'O': put(x,y,char_o,color); break;
		case 'P': put(x,y,char_p,color); break;
		case 'Q': put(x,y,char_q,color); break;
		case 'R': put(x,y,char_r,color); break;
		case 'S': put(x,y,char_s,color); break;
		case 'T': put(x,y,char_t,color); break;
		case 'U': put(x,y,char_u,color); break;
		case 'V': put(x,y,char_v,color); break;
		case 'W': put(x,y,char_w,color); break;
		case 'X': put(x,y,char_x,color); break;
		case 'Y': put(x,y,char_y,color); break;
		case 'Z': put(x,y,char_z,color); break;
		case '0': put(x,y,char_0,color); break;
		case '1': put(x,y,char_1,color); break;
		case '2': put(x,y,char_2,color); break;
		case '3': put(x,y,char_3,color); break;
		case '4': put(x,y,char_4,color); break;
		case '5': put(x,y,char_5,color); break;
		case '6': put(x,y,char_6,color); break;
		case '7': put(x,y,char_7,color); break;
		case '8': put(x,y,char_8,color); break;
		case '9': put(x,y,char_9,color); break;
		case '.': put(x,y,char_pe,color); break;
		case '_': put(x,y,char_ul,color); break;
		case ' ': put(x,y,char_sp,color); break;

		default:  break;
	}
}


/*	<<<<<<<<<<  Print Integer Number  >>>>>>>>>>	*/

printn(number,x,y,length,color)
int	number, x, y, length, color;
{
	int	num;
	int	x_loc = (length-1) * 12 + x;		/*  location of last digit  */

	for (; length>0; length--, x_loc -= 12) {	/*  loop throught digits  */
		num = number % 10;			/*  get digit  */

		if ((length>1) || num)
			printd(num,x_loc,y,color);	/*  print digit  */

		number /= 10;			/*  shift number right one digit  */
	}
}


/*	<<<<<<<<<<  Print Long Integer Number  >>>>>>>>>>	*/

println(number,x,y,length,color)
long	number;
int	x, y, length, color;
{
	int	num;
	int	x_loc = (length-1) * 12 + x;		/*  location of last digit  */

	for (; length>0; length--, x_loc -= 12) {	/*  loop throught digits  */
		num = number % 10L;			/*  get digit  */

		if ((length>1) || num)
			printd(num,x_loc,y,color);	/*  print digit  */

		number /= 10L;			/*  shift number right one digit  */
	}
}


/*	<<<<<<<<<<  Print Integer Digit  >>>>>>>>>>	*/

printd(digit,x,y,color)
int	digit, x, y, color;
{
	switch (digit) {
		case 0:	put(x,y,char_0,color); break;
		case 1:	put(x,y,char_1,color); break;
		case 2:	put(x,y,char_2,color); break;
		case 3:	put(x,y,char_3,color); break;
		case 4:	put(x,y,char_4,color); break;
		case 5:	put(x,y,char_5,color); break;
		case 6:	put(x,y,char_6,color); break;
		case 7:	put(x,y,char_7,color); break;
		case 8:	put(x,y,char_8,color); break;
		case 9:	put(x,y,char_9,color); break;

		default: break;
	}
}


/*	<<<<<<<<<<  Return a Random Number  >>>>>>>>>>		*/

rnd(range)
int	range;
{
	/*  add timer count for auto seeding  */

	int	n = (++rnd_seed + timer()) & 255;

	return(((rnd_table[n] * ++range) >> 8) & 255);
}


/*	<<<<<<<<<<  Read Timer Counter  >>>>>>>>>>	*/

timer()
{
	int	a, temp;

	temp=defseg;	/* save old defseg value */
	defseg = 0x40;		/*  set data segment to bios data area  */
	a=peek(0x6c);
	defseg=temp;	/* restore origional defseg */
	return(a);
}


abs(value)
int	value;
{	/* return the absolute value */
	if(value<0)
		value=-value;
	return(value);
}




sleep(time)
int	time;
{
	int	a,b;

	for(a=0; a<time; a++) {
		for(b=0; b<100; b++);
	}
}

int	bug_count[6], bug_inc[6];

char	bkgnd_2[X_WID_1*Y_WID_1];
char	bkgnd_3[X_WID_1*Y_WID_1];
char	bkgnd_4[X_WID_1*Y_WID_1];
char	bkgnd_5[X_WID_1*Y_WID_1];
char	bkgnd_6[X_WID_1*Y_WID_1];
char	bkgnd_7[X_WID_1*Y_WID_1];

char	bkgnd_8[X_WID_c0*Y_WID_c0];
char	bkgnd_9[X_WID_c0*Y_WID_c0];
char	bkgnd_10[X_WID_c0*Y_WID_c0];
char	bkgnd_11[X_WID_c0*Y_WID_c0];
char	bkgnd_12[X_WID_c0*Y_WID_c0];
char	bkgnd_13[X_WID_c0*Y_WID_c0];


init_images()
{
	int	loop;

	sp_init(1,image_1,outln_1,bkgnd_1,X_WID_1,Y_WID_1,0,0);
	sp_init(2,image_1,outln_1,bkgnd_2,X_WID_1,Y_WID_1,0,0);
	sp_init(3,image_1,outln_1,bkgnd_3,X_WID_1,Y_WID_1,0,0);
	sp_init(4,image_1,outln_1,bkgnd_4,X_WID_1,Y_WID_1,0,0);
	sp_init(5,image_1,outln_1,bkgnd_5,X_WID_1,Y_WID_1,0,0);
	sp_init(6,image_1,outln_1,bkgnd_6,X_WID_1,Y_WID_1,0,0);
	sp_init(7,image_1,outln_1,bkgnd_7,X_WID_1,Y_WID_1,0,0);

	sp_init(8,image_m0,outln_m0,bkgnd_8,X_WID_m0,Y_WID_m0,0,0);
	sp_init(9,image_m0,outln_m0,bkgnd_9,X_WID_m0,Y_WID_m0,0,0);
	sp_init(10,image_m0,outln_m0,bkgnd_10,X_WID_m0,Y_WID_m0,0,0);
	sp_init(11,image_m0,outln_m0,bkgnd_11,X_WID_m0,Y_WID_m0,0,0);
	sp_init(12,image_m0,outln_m0,bkgnd_12,X_WID_m0,Y_WID_m0,0,0);
	sp_init(13,image_m0,outln_m0,bkgnd_13,X_WID_m0,Y_WID_m0,0,0);

	init_b_images();

	for(loop=0; loop<6; loop++) {
		bug_count[loop]=0; bug_inc[loop]=1;
	}

}


rst_images()
{
	sp_chnge(1,image_1,outln_1,X_WID_1,Y_WID_1,0,0);
	sp_chnge(2,image_1,outln_1,X_WID_1,Y_WID_1,0,0);
	sp_chnge(3,image_1,outln_1,X_WID_1,Y_WID_1,0,0);
	sp_chnge(4,image_1,outln_1,X_WID_1,Y_WID_1,0,0);
	sp_chnge(5,image_1,outln_1,X_WID_1,Y_WID_1,0,0);
	sp_chnge(6,image_1,outln_1,X_WID_1,Y_WID_1,0,0);
	sp_chnge(7,image_1,outln_1,X_WID_1,Y_WID_1,0,0);


	sp_chnge(8,image_m0,outln_m0,X_WID_m0,Y_WID_m0,0,0);
	sp_chnge(9,image_m0,outln_m0,X_WID_m0,Y_WID_m0,0,0);
	sp_chnge(10,image_m0,outln_m0,X_WID_m0,Y_WID_m0,0,0);
	sp_chnge(11,image_m0,outln_m0,X_WID_m0,Y_WID_m0,0,0);
	sp_chnge(12,image_m0,outln_m0,X_WID_m0,Y_WID_m0,0,0);
	sp_chnge(13,image_m0,outln_m0,X_WID_m0,Y_WID_m0,0,0);

	rst_b_images();


}


draw_bug(bug_num,bug_type,bug_dir,x,y)
int	bug_num, bug_type, bug_dir, x, y;
{
	int	stat;

	bug_count[bug_num]+=bug_inc[bug_num];

	if(bug_count[bug_num]==2 || bug_count[bug_num]==0)
		bug_inc[bug_num]=-bug_inc[bug_num];

	if(bug_count[bug_num]>2)	/* saftey feature - should never be needed */
		bug_count[bug_num]=2;
	if(bug_count[bug_num]<0)
		bug_count[bug_num]=0;

	switch(bug_type) {
	case ADVANCING:
        	switch(bug_dir) {
		case RIGHT:
			switch(bug_count[bug_num]) {
			case 0:
				sp_chnge(bug_num+8,image_c0,outln_c0,X_WID_c0,Y_WID_c0,0,0);
				break;
			case 1:
				sp_chnge(bug_num+8,image_c1,outln_c1,X_WID_c1,Y_WID_c1,0,0);
				break;
			case 2:
				sp_chnge(bug_num+8,image_c2,outln_c2,X_WID_c2,Y_WID_c2,0,0);
				break;
			}
        		break;
		case LEFT:
			switch(bug_count[bug_num]) {
			case 0:
				sp_chnge(bug_num+8,image_a0,outln_a0,X_WID_a0,Y_WID_a0,0,0);
				break;
			case 1:
				sp_chnge(bug_num+8,image_a1,outln_a1,X_WID_a1,Y_WID_a1,0,0);
				break;
			case 2:
				sp_chnge(bug_num+8,image_a2,outln_a2,X_WID_a2,Y_WID_a2,0,0);
				break;
			}
        		break;
		}
	
		stat=sp_move(bug_num+8,x,y);	/* draw the new image & get colision info */

		break;


	case NORMAL:
		switch(bug_count[bug_num]) {
		case 0:
			sp_chnge(bug_num+8,image_m0,outln_m0,X_WID_m0,Y_WID_m0,0,0);
			break;
		case 1:
			sp_chnge(bug_num+8,image_m1,outln_m1,X_WID_m1,Y_WID_m1,0,0);
			break;
		case 2:
			sp_chnge(bug_num+8,image_m2,outln_m2,X_WID_m2,Y_WID_m2,0,0);
			break;
		}


		stat=sp_move(bug_num+8,x,y);	/* draw the new image & get colision info */

		break;
	}

	return(stat);	/* return colision info */


}

draw_dead_bug(bug_num,bug_type,bug_dir,x,y)
int	bug_num, bug_type, bug_dir, x, y;
{
	int	stat;

	switch(bug_type) {
	case ADVANCING:
        	switch(bug_dir) {
		case RIGHT:
			sp_chnge(bug_num+8,image_c3,outln_c3,X_WID_c3,Y_WID_c3,0,0);
        		break;
		case LEFT:
			sp_chnge(bug_num+8,image_a3,outln_a3,X_WID_a3,Y_WID_a3,0,0);
        		break;
		}
	
		stat=sp_move(bug_num+8,x,y);	/* draw the new image & get colision info */

		break;


	case NORMAL:
		sp_chnge(bug_num+8,image_m3,outln_m3,X_WID_m3,Y_WID_m3,0,0);

		stat=sp_move(bug_num+8,x,y);	/* draw the new image & get colision info */

		break;
	}

	return(stat);	/* return colision info */


}



draw_bag(bag_num,bag_type,x,y)
int	bag_num, bag_type, x, y;
{
	int	colision;

	switch(bag_type) {
	case BAG_0:
		sp_chnge(bag_num,image_1,outln_1,X_WID_1,Y_WID_1,0,0);
		colision=sp_move(bag_num,x,y);
		break;
	case BAG_4:
		sp_chnge(bag_num,image_b4,outln_b4,X_WID_b4,Y_WID_b4,0,0);
		colision=sp_move(bag_num,x,y);
		break;
	case BAG_5:
		sp_chnge(bag_num,image_b5,outln_b5,X_WID_b5,Y_WID_b5,0,0);
		colision=sp_move(bag_num,x,y);
		break;
	case BAG_6:
		sp_chnge(bag_num,image_b6,outln_b6,X_WID_b6,Y_WID_b6,0,0);
		colision=sp_move(bag_num,x,y);
		break;
	case BAG_7:
		sp_chnge(bag_num,image_b7,outln_b7,X_WID_b7,Y_WID_b7,0,0);
		colision=sp_move(bag_num,x,y+(Y_WID_1-Y_WID_b7));	/* offset is added for size difference */
		break;
	case BAG_8:
		sp_chnge(bag_num,image_b8,outln_b8,X_WID_b8,Y_WID_b8,0,0);
		colision=sp_move(bag_num,x,y+(Y_WID_1-Y_WID_b8));	/* offset is added for size difference */
		break;
	case BAG_9:
		sp_chnge(bag_num,image_b9,outln_b9,X_WID_b9,Y_WID_b9,0,0);
		colision=sp_move(bag_num,x,y+(Y_WID_1-Y_WID_b9));	/* offset is added for size difference */
		break;
	}

	return(colision);

}




put_man(stat,x,y)
int	stat, x, y;
{	/* used to display lives left - 0 prints a man for player 0, 1 man for player 1, 2 = blank */

	switch(stat) { 
	case 0:
		sp_put(x,y,image_s0,outln_s0,X_WID_s0,Y_WID_s0);
		break;
	case 1:
		sp_put(x,y,image_s1,outln_s1,X_WID_s1,Y_WID_s1);
		break;
	case 2:
		sp_put(x,y,image_s2,outln_s2,X_WID_s2,Y_WID_s2);
		break;
	}

}




put_coin(x,y)
int	x,y;
{

	sp_blank(x,y,X_WID_cn,Y_WID_cn);
	sp_put(x,y,image_cn,outln_cn,X_WID_cn,Y_WID_cn);
	sp_disp();
}



rem_coin(x,y)
int	x,y;
{

	sp_blank(x,y,X_WID_nc,Y_WID_nc);
	sp_put(x,y,image_nc,outln_nc,X_WID_nc,Y_WID_nc);
	sp_disp();
}


int	man_count, man_inc;
int	mis_num;	/* counter for missle types */

init_b_images()
{
	mis_num=0;	/* missle image counter */

	man_count=0; man_inc=1;

	sp_init(0,image_0,outln_0,bkgnd_0,X_WID_0,Y_WID_0,0,0);

	sp_init(14,image_z1,outln_z1,bkgnd_z1,X_WID_z1,Y_WID_z1,0,0);	/* bonus object */

	sp_init(15,image_15,outln_15,bkgnd_15,X_WID_15,Y_WID_15,0,0);	/* missile */

}


rst_b_images()
{
	mis_num=0;	/* missle image counter */

	man_count=0; man_inc=1;

	sp_chnge(0,image_0,outln_0,X_WID_0,Y_WID_0,0,0);

	sp_chnge(14,image_z1,outln_z1,X_WID_z1,Y_WID_z1,0,0);	/* bonus object */

	sp_chnge(15,image_15,outln_15,X_WID_15,Y_WID_15,0,0);	/* missile */

}



/* background erase routines */

era_right(x,y)	/* erase background in right direction */
int	x,y;
{
	sp_blank(x+16,y-1,X_WID_rt,Y_WID_rt);
	sp_put(x+16,y-1,image_rt,outln_rt,X_WID_rt,Y_WID_rt);
	sp_disp();

}



era_left(x,y)	/* erase background in left direction */
int	x,y;
{
	sp_blank(x-8,y-1,X_WID_lt,Y_WID_lt);
	sp_put(x-8,y-1,image_lt,outln_lt,X_WID_lt,Y_WID_lt);
	sp_disp();

}



era_up(x,y)	/* erase background in upward direction */
int	x,y;
{
	sp_blank(x-4,y-6,X_WID_up,Y_WID_up);
	sp_put(x-4,y-6,image_up,outln_up,X_WID_up,Y_WID_up);
	sp_disp();

}



era_down(x,y)	/* erase background in downward direction */
int	x,y;
{
	sp_blank(x-4,y+15,X_WID_dn,Y_WID_dn);
	sp_put(x-4,y+15,image_dn,outln_dn,X_WID_dn,Y_WID_dn);
	sp_disp();

}



era_b_down(x,y)	/* erase background in downward direction for falling money bags */
int	x,y;
{
	sp_blank(x-4,y+15,X_WID_bd,Y_WID_bd);
	sp_put(x-4,y+15,image_bd,outln_bd,X_WID_bd,Y_WID_bd);
	sp_disp();

}



era_b_first(x,y)	/* erase the first piece of background in downward direction for falling money bags */
int	x,y;
{
	sp_blank(x-4,y+17,X_WID_bf,Y_WID_bf);
	sp_put(x-4,y+17,image_bf,outln_bf,X_WID_bf,Y_WID_bf);
	sp_disp();

}



draw_background(lev)
int	lev;
{
	int	x, y;

	for(y=14; y<200; y+=4) {
		for(x=0; x<320; x+=20) {
			switch(lev) {
			case 1:
				sp_put(x,y,image_p1,outln_p1,X_WID_p1,Y_WID_p1);
				break;
			case 2:
				sp_put(x,y,image_p2,outln_p2,X_WID_p2,Y_WID_p2);
				break;
			case 3:
				sp_put(x,y,image_p3,outln_p3,X_WID_p3,Y_WID_p3);
				break;
			case 4:
				sp_put(x,y,image_p4,outln_p4,X_WID_p4,Y_WID_p4);
				break;
			case 5:
				sp_put(x,y,image_p5,outln_p5,X_WID_p5,Y_WID_p5);
				break;
			case 6:
				sp_put(x,y,image_p6,outln_p6,X_WID_p6,Y_WID_p6);
				break;
			case 7:
				sp_put(x,y,image_p7,outln_p7,X_WID_p7,Y_WID_p7);
				break;
			case 8:
				sp_put(x,y,image_p8,outln_p8,X_WID_p8,Y_WID_p8);
				break;
			}
		}
	}

}



draw_missile(x,y,mis_type)
int	x, y, mis_type;
{
	switch(mis_type) {
	case 0:
		mis_num++;
		if(mis_num>2)	/* get new image number */
			mis_num=0;
		switch(mis_num) {
		case 0:
			sp_chnge(15,image_15,outln_15,X_WID_15,Y_WID_15,0,0);
			break;
		case 1:
			sp_chnge(15,image_k1,outln_k1,X_WID_k1,Y_WID_k1,0,0);
			break;
		case 2:
			sp_chnge(15,image_k2,outln_k2,X_WID_k2,Y_WID_k2,0,0);
			break;
		}
		return(sp_move(15,x,y));
		break;
	case 1:
		sp_chnge(15,image_e1,outln_e1,X_WID_e1,Y_WID_e1,0,0);
		sp_move(15,x,y);
		break;
	case 2:
		sp_chnge(15,image_e2,outln_e2,X_WID_e2,Y_WID_e2,0,0);
		sp_move(15,x,y);
		break;
	case 3:
		sp_chnge(15,image_e3,outln_e3,X_WID_e3,Y_WID_e3,0,0);
		sp_move(15,x,y);
		break;
	}

}



draw_bonus(x,y)
int	x, y;
{

	sp_chnge(14,image_z1,outln_z1,X_WID_z1,Y_WID_z1,0,0);
	sp_place(14,x,y);

}



draw_man(dir,x,y,cab)
int	dir, x, y, cab;
{
	int	stat;

	man_count+=man_inc;

	if(man_count==2 || man_count==0)
		man_inc=-man_inc;

	if(man_count>2)	/* saftey feature - should never be needed */
		man_count=2;
	if(man_count<0)
		man_count=0;

	switch(dir) {
	case RIGHT:
		switch(man_count) {
		case 0:
			if(cab)
				sp_chnge(0,image_r0,outln_r0,X_WID_r0,Y_WID_r0,0,0);
			else
				sp_chnge(0,image_r4,outln_r4,X_WID_r4,Y_WID_r4,0,0);

			break;
		case 1:
			if(cab)
				sp_chnge(0,image_r1,outln_r1,X_WID_r1,Y_WID_r1,0,0);
			else
				sp_chnge(0,image_r5,outln_r5,X_WID_r5,Y_WID_r5,0,0);
			break;
		case 2:
			if(cab)
				sp_chnge(0,image_r2,outln_r2,X_WID_r2,Y_WID_r2,0,0);
			else
				sp_chnge(0,image_r6,outln_r6,X_WID_r6,Y_WID_r6,0,0);
			break;
		}

	
		stat=sp_move(0,x,y);	/* draw the new image & get colision info */
		break;


	case LEFT:
		switch(man_count) {
		case 0:
			if(cab)
				sp_chnge(0,image_l0,outln_l0,X_WID_l0,Y_WID_l0,0,0);
			else
				sp_chnge(0,image_l4,outln_l4,X_WID_l4,Y_WID_l4,0,0);
			break;
		case 1:
			if(cab)
				sp_chnge(0,image_l1,outln_l1,X_WID_l1,Y_WID_l1,0,0);
			else
				sp_chnge(0,image_l5,outln_l5,X_WID_l5,Y_WID_l5,0,0);
			break;
		case 2:
			if(cab)
				sp_chnge(0,image_l2,outln_l2,X_WID_l2,Y_WID_l2,0,0);
			else
				sp_chnge(0,image_l6,outln_l6,X_WID_l6,Y_WID_l6,0,0);
			break;
		}


		stat=sp_move(0,x,y);	/* draw the new image & get colision info */
		break;

	case UP:
		switch(man_count) {
		case 0:
			if(cab)
				sp_chnge(0,image_u0,outln_u0,X_WID_u0,Y_WID_u0,0,0);
			else
				sp_chnge(0,image_u4,outln_u4,X_WID_u4,Y_WID_u4,0,0);
			break;
		case 1:
			if(cab)
				sp_chnge(0,image_u1,outln_u1,X_WID_u1,Y_WID_u1,0,0);
			else
				sp_chnge(0,image_u5,outln_u5,X_WID_u5,Y_WID_u5,0,0);
			break;
		case 2:
			if(cab)
				sp_chnge(0,image_u2,outln_u2,X_WID_u2,Y_WID_u2,0,0);
			else
				sp_chnge(0,image_u6,outln_u6,X_WID_u6,Y_WID_u6,0,0);
			break;
		}

		stat=sp_move(0,x,y);	/* draw the new image & get colision info */
		break;

	case DOWN:
		switch(man_count) {
		case 0:
			if(cab)
				sp_chnge(0,image_d0,outln_d0,X_WID_d0,Y_WID_d0,0,0);
			else
				sp_chnge(0,image_d4,outln_d4,X_WID_d4,Y_WID_d4,0,0);
			break;
		case 1:
			if(cab)
				sp_chnge(0,image_d1,outln_d1,X_WID_d1,Y_WID_d1,0,0);
			else
				sp_chnge(0,image_d5,outln_d5,X_WID_d5,Y_WID_d5,0,0);
			break;
		case 2:
			if(cab)
				sp_chnge(0,image_d2,outln_d2,X_WID_d2,Y_WID_d2,0,0);
			else
				sp_chnge(0,image_d6,outln_d6,X_WID_d6,Y_WID_d6,0,0);
			break;
		}

		stat=sp_move(0,x,y);	/* draw the new image & get colision info */
		break;

	case STOP:
		break;

	case FALL_1:
		sp_chnge(0,image_f1,outln_f1,X_WID_f1,Y_WID_f1,0,0);
		stat=sp_move(0,x,y);	/* draw the new image & get colision info */
		break;
	case FALL_2:
		sp_chnge(0,image_f2,outln_f2,X_WID_f2,Y_WID_f2,0,0);
		stat=sp_move(0,x,y);	/* draw the new image & get colision info */
		break;
	case FALL_3:
		sp_chnge(0,image_f3,outln_f3,X_WID_f3,Y_WID_f3,0,0);
		stat=sp_move(0,x,y);	/* draw the new image & get colision info */
		break;
	case FALL_4:
		sp_chnge(0,image_f4,outln_f4,X_WID_f4,Y_WID_f4,0,0);
		stat=sp_move(0,x,y);	/* draw the new image & get colision info */
		break;
	case FALL_5:
		sp_chnge(0,image_f5,outln_f5,X_WID_f5,Y_WID_f5,0,0);
		stat=sp_move(0,x,y);	/* draw the new image & get colision info */
		break;
	case FALL_9:
		sp_chnge(0,image_f9,outln_f9,X_WID_f9,Y_WID_f9,0,0);
		stat=sp_move(0,x,y);	/* draw the new image & get colision info */
		break;
	}

	return(stat);	/* return colision info */


}

#define		C0	72977
#define		CS0	68882
#define		D0	65017
#define		DS0	61369
#define		E0	57922
#define		F0	54672
#define		FS0	51603
#define		G0	48707
#define		GS0	45973
#define		A0	43393
#define		AS0	40958
#define		B0	38659










#define		C1	36489
#define		CS1	34441
#define		D1	32508
#define		DS1	30684
#define		E1	28961
#define		F1	27336
#define		FS1	25801
#define		G1	24353
#define		GS1	22986
#define		A1	21697
#define		AS1	20479
#define		B1	19329










#define		C2	18244
#define		CS2	17220
#define		D2	16254
#define		DS2	15342
#define		E2	14480
#define		F2	13668
#define		FS2	12901
#define		G2	12177
#define		GS2	11493
#define		A2	10848
#define		AS2	10239
#define		B2	9665










#define		C3	9122
#define		CS3	8610
#define		D3	8127
#define		DS3	7671
#define		E3	7240
#define		F3	6834
#define		FS3	6450
#define		G3	6088
#define		GS3	5747
#define		A3	5424
#define		AS3	5120
#define		B3	4832










#define		C4	4561
#define		CS4	4305
#define		D4	4063
#define		DS4	3835
#define		E4	3620
#define		F4	3417
#define		FS4	3225
#define		G4	3044
#define		GS4	2873
#define		A4	2712
#define		AS4	2560
#define		B4	2416










#define		C5	2280
#define		CS5	2152
#define		D5	2032
#define		DS5	1918
#define		E5	1810
#define		F5	1708
#define		FS5	1612
#define		G5	1522
#define		GS5	1437
#define		A5	1356
#define		AS5	1280
#define		B5	1208










#define		C6	1140
#define		CS6	1076
#define		D6	1016

#define		REST	32000

/* all man related variables are re-initialized for eack round & screen */

int	bug[6][20];


#define		BUG_ACTIVE	0
#define		BUG_X		1
#define		BUG_Y		2
#define		BUG_X_POS	3
#define		BUG_Y_POS	4
#define		BUG_X_REM	5
#define		BUG_Y_REM	6
#define		BUG_DIR		7
#define		BUG_OLD_DIR	8
#define		BUG_WAIT	9
#define		BUG_ALIVE	10
#define		BUG_TYPE	11
#define		BUG_STUCK	12
#define		DEAD_TYPE	13
#define		DEAD_NUM	14
#define		DEAD_WAIT	15
#define		BUG_BEGIN	16

/* the first element specifies the bug number (0-5)

   the second element specifies:
		BUG_ACTIVE		- set to TRUE if the bug is active on the screen 
		BUG_X      		- X screen location of bug 
		BUG_Y      		- Y screen location of bug 
		BUG_X_POS		- X matrix position og bug 
		BUG_Y_POS		- Y matrix position og bug 
		BUG_X_REM		- X remainder 
		BUG_Y_REM		- Y remainder
		BUG_DIR	 		- direction of travel
		BUG_OLD_DIR		- last direction of travel ( used to draw bug )
		BUG_WAIT   		- wait counter
		BUG_ALIVE  		- alive or dead status - TRUE = alive
		BUG_TYPE   		- Normal or advancing types of bugs
		BUG_STUCK  		- counter to turn normal bugs into advancing ext.
		DEAD_TYPE  		- type of dead body being displayed
		DEAD_NUM   		- the bag number that coused the bugs death
		DEAD_WAIT  		- wait between dead body type changes
        	BUG_BEGIN		- delay before moving new bug


*/

int	wait_flag;	/* set up by other modules to void bug_wait */

int	bugs_created, bugs_total, bugs_max, bugs_delay, start_delay;
int 	bonus_ready;

init_ta()
{	
	int	bug_num;

	for(bug_num=0; bug_num<6; bug_num++) {

		bug[bug_num][BUG_ACTIVE]=FALSE;

	}

	start_delay=(45-(get_dificulty()<<1));

	bugs_created=0;	/* counter of number of bugs that have been created on screen */
	bugs_total=5+get_dificulty();	/* total number of bugs to be in the round */
/*	bugs_total=1;	/* ********************* */  */

	switch(get_dificulty()) { /* maximum number of bugs to be on the screen at one time */
	case 1:
		bugs_max=3;	
		break;
	case 2:
	case 3:
	case 4:
	case 5:
	case 6:
	case 7:
		bugs_max=4;
		break;
	case 8:
	case 9:
	case 10:
		bugs_max=5;
		break;
	}
/* 	bugs_max=1;	/* ******************* */  */

	bugs_delay=10;	/* delay brfore first bug is created */
	bonus_ready=TRUE;	/* show that a bonus may be created */
}





end_ta()
{
	int	bug_num;

	for(bug_num=0; bug_num<6; bug_num++) {
		if(bug[bug_num][BUG_ACTIVE])
			sp_erase(bug_num+8);	/* erase bug from screen */
	}
}


task_a()
{
	int	bug_num;
	
/* check if new bugs need creating */
	if(bugs_delay>0)
		bugs_delay--;
	else {
		if(bugs_created<bugs_total && bugs_count()<bugs_max && get_m_status() && (!get_bonus()) )
			start_bug();
		if(bonus_ready && bugs_created==bugs_total && bugs_delay==0 && get_m_status()) {
			bonus_ready=FALSE;	/* only create one bonus per round */
			begin_bonus(1);	/* initiate bonus sequence */
		}
	}


/* move all active bugs */
	for(bug_num=0; bug_num<6; bug_num++) {
		if(bug[bug_num][BUG_ACTIVE]) {
			if(bug[bug_num][BUG_STUCK]>(10-get_dificulty()) && bug[bug_num][BUG_TYPE]==NORMAL) {
				bug[bug_num][BUG_STUCK]=0;
				bug[bug_num][BUG_TYPE]=ADVANCING;
			}


			if(bug[bug_num][BUG_ALIVE]) {
				if(!bug[bug_num][BUG_WAIT]) {
					move_bug(bug_num);
					/* alow bug to move again to increase speed */
					if(bug[bug_num][BUG_ALIVE] && (rnd(15-get_dificulty())==0) 
					   && bug[bug_num][BUG_TYPE]!=ADVANCING)
						move_bug(bug_num);
				}
				else
					bug[bug_num][BUG_WAIT]--;
			}
			else
				move_dead_bug(bug_num);
		}
	}

}



start_bug()
{
	int	bug_num;

	for(bug_num=0; bug_num<6; bug_num++) {
		if(!bug[bug_num][BUG_ACTIVE]) {
			bug[bug_num][BUG_ACTIVE]=TRUE;
			bug[bug_num][BUG_ALIVE]=TRUE;
			bug[bug_num][BUG_WAIT]=0;
			bug[bug_num][BUG_TYPE]=NORMAL;
			bug[bug_num][BUG_STUCK]=0;

			bug[bug_num][BUG_X_POS]=14;
			bug[bug_num][BUG_Y_POS]=0;
			bug[bug_num][BUG_X]=14*20+X_OFFSET;
			bug[bug_num][BUG_Y]=Y_OFFSET;
			bug[bug_num][BUG_X_REM]=0;
			bug[bug_num][BUG_Y_REM]=0;
			bug[bug_num][BUG_DIR]=LEFT;
			bug[bug_num][BUG_OLD_DIR]=LEFT;

			bugs_created++;	/* increment count of bugs already created */
			bugs_delay=start_delay;	/* set delay before next bug creation */
			bug[bug_num][BUG_BEGIN]=5;	/* delay before new bug starts to move */
			sp_place(bug_num+8,bug[bug_num][BUG_X],bug[bug_num][BUG_Y]);
			break;	/* only place one bug */
		}
	}
			
}



move_bug(bug_num)
int	bug_num;
{
	int	colision, flag, bug_x_old, bug_y_old, dir, dir_1, dir_2, dir_3, dir_4, temp;

	bug_x_old=bug[bug_num][BUG_X];
	bug_y_old=bug[bug_num][BUG_Y];

/* check for change of direction if on an even intersection */
	if(bug[bug_num][BUG_X_REM]==0 && bug[bug_num][BUG_Y_REM]==0) {


/* check if an advancing bug should be changed back to normal */
		if(bug[bug_num][BUG_STUCK]>(30+get_dificulty()*2) && bug[bug_num][BUG_TYPE]==ADVANCING ) {
			bug[bug_num][BUG_STUCK]=0;
			bug[bug_num][BUG_TYPE]=NORMAL;
		}



/* find order of best directions */
		if(abs(get_m_y()-bug[bug_num][BUG_Y]) > abs(get_m_x()-bug[bug_num][BUG_X]) ) {		
			/* if Y distance is greater then give priority to Y travel */
			if(get_m_y()<bug[bug_num][BUG_Y]) {
				dir_1=UP;
				dir_4=DOWN;
			}
			else {
				dir_1=DOWN;
				dir_4=UP;
			}
			if(get_m_x()<bug[bug_num][BUG_X]) {
				dir_2=LEFT;
				dir_3=RIGHT;
			}
			else {
				dir_2=RIGHT;
				dir_3=LEFT;
			}
		}
		else {
			if(get_m_x()<bug[bug_num][BUG_X]) {
				dir_1=LEFT;
				dir_4=RIGHT;
			}
			else {
				dir_1=RIGHT;
				dir_4=LEFT;
			}
			if(get_m_y()<bug[bug_num][BUG_Y]) {
				dir_2=UP;
				dir_3=DOWN;
			}
			else {
				dir_2=DOWN;
				dir_3=UP;
			}

		}



/* if bugs are running away then change order of directions */
		if(get_bonus() ) {
			temp=dir_1;
			dir_1=dir_4;
			dir_4=temp;
			temp=dir_2;
			dir_2=dir_3;
			dir_3=temp;
		}


/* make backtracking the last choice */

		dir=get_rev(bug[bug_num][BUG_DIR]);

		if(dir==dir_1) {
			dir_1=dir_2;
			dir_2=dir_3;
			dir_3=dir_4;
			dir_4=dir;
		}
		if(dir==dir_2) {
			dir_2=dir_3;
			dir_3=dir_4;
			dir_4=dir;
		}
		if(dir==dir_3) {
			dir_3=dir_4;
			dir_4=dir;
		}

/* add randmness to movement */
		if((rnd(5+get_dificulty())==1) && get_dificulty()<6) {
			temp=dir_1;
			dir_1=dir_3;
			dir_3=temp;
		}

/* choose best direction that is a clear path */
		while(TRUE) {
			if(back_check(dir_1,bug[bug_num][BUG_X_POS],bug[bug_num][BUG_Y_POS])) {
				dir=dir_1;
				break;
			}
			if(back_check(dir_2,bug[bug_num][BUG_X_POS],bug[bug_num][BUG_Y_POS])) {
				dir=dir_2;
				break;
			}
			if(back_check(dir_3,bug[bug_num][BUG_X_POS],bug[bug_num][BUG_Y_POS])) {
				dir=dir_3;
				break;
			}
			if(back_check(dir_4,bug[bug_num][BUG_X_POS],bug[bug_num][BUG_Y_POS])) {
				dir=dir_4;
				break;
			}
			break;
		}			

		if(bug[bug_num][BUG_TYPE]==ADVANCING)	/* bug diggs a new path when advancing */
			dir=dir_1;	/* always go in the best direction */


/* delay bugs as they cross an even boundary when changing direction */
		if(bug[bug_num][BUG_DIR]!=dir)
			bug[bug_num][BUG_WAIT]++;


		bug[bug_num][BUG_DIR]=dir;			

	}



/* check if bug is going off screen */
	if( (bug[bug_num][BUG_X]==X_LAST && bug[bug_num][BUG_DIR]==RIGHT)
	 || (bug[bug_num][BUG_X]==X_FIRST && bug[bug_num][BUG_DIR]==LEFT)
	 || (bug[bug_num][BUG_Y]==Y_LAST && bug[bug_num][BUG_DIR]==DOWN)
	 || (bug[bug_num][BUG_Y]==Y_FIRST && bug[bug_num][BUG_DIR]==UP) )
		bug[bug_num][BUG_DIR]=STOP;

	if(bug[bug_num][BUG_DIR]==LEFT || bug[bug_num][BUG_DIR]==RIGHT)
		bug[bug_num][BUG_OLD_DIR]=bug[bug_num][BUG_DIR];

/* move position values */
	if(bug[bug_num][BUG_TYPE]==ADVANCING) 	/* bug is digging a new tunnel - update background array */
		era_background(bug[bug_num][BUG_X],bug[bug_num][BUG_Y],bug[bug_num][BUG_DIR]);

	switch(bug[bug_num][BUG_DIR]) {
	case RIGHT:
		if(bug[bug_num][BUG_TYPE]==ADVANCING)
			era_right(bug[bug_num][BUG_X],bug[bug_num][BUG_Y]);	/* erase a new path */
		bug[bug_num][BUG_X]+=4;
		break;
	case LEFT:
		if(bug[bug_num][BUG_TYPE]==ADVANCING)
			era_left(bug[bug_num][BUG_X],bug[bug_num][BUG_Y]);	/* erase a new path */
		bug[bug_num][BUG_X]-=4;
		break;
	case UP:
		if(bug[bug_num][BUG_TYPE]==ADVANCING)
			era_up(bug[bug_num][BUG_X],bug[bug_num][BUG_Y]);	/* erase a new path */
		bug[bug_num][BUG_Y]-=3;
		break;
	case DOWN:
		if(bug[bug_num][BUG_TYPE]==ADVANCING)
			era_down(bug[bug_num][BUG_X],bug[bug_num][BUG_Y]);	/* erase a new path */
		bug[bug_num][BUG_Y]+=3;
		break;
	}


	if(bug[bug_num][BUG_TYPE]==ADVANCING) {	/* bug is digging a new tunnel */
		/* remove any coin in the path */
		coin_check((bug[bug_num][BUG_X]-X_OFFSET)/20,(bug[bug_num][BUG_Y]-Y_OFFSET)/18,
			   (bug[bug_num][BUG_X]-X_OFFSET)%20,(bug[bug_num][BUG_Y]-Y_OFFSET)%18,bug[bug_num][BUG_DIR]);
	}

	if(!get_m_status() ) {	/* reset bug position if man is already dying */
		bug[bug_num][BUG_X]=bug_x_old;
		bug[bug_num][BUG_Y]=bug_y_old;
	}

	if(bug[bug_num][BUG_BEGIN]) {	/* delay before movement begins */
		bug[bug_num][BUG_BEGIN]--;
		bug[bug_num][BUG_X]=bug_x_old;
		bug[bug_num][BUG_Y]=bug_y_old;
	}

/* move bug on screen & check for colisions */

	if(bug[bug_num][BUG_TYPE]==ADVANCING && bug[bug_num][BUG_STUCK]<100)
		bug[bug_num][BUG_STUCK]++;	/* increment counter for digging monsters */

	flag=TRUE;	/* start showing a good move */
	colision=draw_bug(bug_num,bug[bug_num][BUG_TYPE],bug[bug_num][BUG_OLD_DIR],bug[bug_num][BUG_X],bug[bug_num][BUG_Y]);
	inc_plot();	/* report a screen plot */
	if(colision & 0x3f00) {	/* colision with other bugs */
		bug[bug_num][BUG_WAIT]++;
		dir_change(bug_num,colision);	/* change direction of coliding bugs */
		inc_extra(colision);	/* increment plot counter for colisions with other bugs */
	}

	if(colision & 0xfe & get_active_bags()) {
		bug[bug_num][BUG_WAIT]++;
		wait_flag=FALSE;	/* flag will be set if a money pile was hit */
		if(bug[bug_num][BUG_DIR]==LEFT || bug[bug_num][BUG_DIR]==RIGHT) {
			flag=move_all_bags(bug[bug_num][BUG_DIR],colision);	/* move bags touched bu bug */
			bug[bug_num][BUG_WAIT]++;	/* slow down bug */
		}
		else {
			if(!money_check(colision))	/* remove any broken bags touched bu bug */
				flag=FALSE;
		}
		if(wait_flag)
			bug[bug_num][BUG_WAIT]=0;	/* dont slow bug if getting money pile */
		
                if(bug[bug_num][BUG_TYPE]==ADVANCING && bug[bug_num][BUG_STUCK]>1) 
			break_bags(colision);	/* break bags that are blocking the way */


	}


 	/* bug is stuck if on top of another bug */
	if(bug[bug_num][BUG_TYPE]==NORMAL && (colision & 0x3f00) && get_m_ststus() )
		bug[bug_num][BUG_STUCK]++;



	if(!flag) {	/* move bug back to the origional position */
		bug[bug_num][BUG_X]=bug_x_old;
		bug[bug_num][BUG_Y]=bug_y_old;	/* dont allow bags to be moved up or down */
		draw_bug(bug_num,bug[bug_num][BUG_TYPE],bug[bug_num][BUG_OLD_DIR],bug[bug_num][BUG_X],bug[bug_num][BUG_Y]);
		inc_plot();	/* report a screen plot */
		if(bug[bug_num][BUG_TYPE]==NORMAL) 
			bug[bug_num][BUG_STUCK]++;

		/* dont let normal bug get stuck going up or down */
		if( (bug[bug_num][BUG_DIR]==UP || bug[bug_num][BUG_DIR]==DOWN) && bug[bug_num][BUG_TYPE]==NORMAL)
			bug[bug_num][BUG_DIR]=get_rev(bug[bug_num][BUG_DIR]);	/* change bugs direction */

	}

 	if((colision & 0x01) && get_m_status() ) {
		if(get_bonus()) {
			era_bug(bug_num);
			bonus_score();
			snd_bug();	/* sound for bonus bug eaten */
		}
		else
			kill_man(BUG,0);	/* if man is still alive then kill man if hit by bug */
	}


	bug[bug_num][BUG_X_POS]=(bug[bug_num][BUG_X]-X_OFFSET)/20;
	bug[bug_num][BUG_Y_POS]=(bug[bug_num][BUG_Y]-Y_OFFSET)/18;
	bug[bug_num][BUG_X_REM]=(bug[bug_num][BUG_X]-X_OFFSET)%20;
	bug[bug_num][BUG_Y_REM]=(bug[bug_num][BUG_Y]-Y_OFFSET)%18;


}



move_dead_bug(bug_num)
int	bug_num;
{

	switch(bug[bug_num][DEAD_TYPE]) {
	case MONEY_BAG:
		if(get_y_bag(bug[bug_num][DEAD_NUM])+6>bug[bug_num][BUG_Y])
			bug[bug_num][BUG_Y]=get_y_bag(bug[bug_num][DEAD_NUM]);

		draw_dead_bug(bug_num,bug[bug_num][BUG_TYPE],bug[bug_num][BUG_OLD_DIR],bug[bug_num][BUG_X],bug[bug_num][BUG_Y]);
		inc_plot();	/* report a screen plot */
		
		if(get_d_bag(bug[bug_num][DEAD_NUM])==STOP) {
			bug[bug_num][DEAD_WAIT]=1;
			bug[bug_num][DEAD_TYPE]=DEAD;
		}

		break;

	case DEAD:
		if(bug[bug_num][DEAD_WAIT]) {
			bug[bug_num][DEAD_WAIT]--;
			break;
		}
		era_bug(bug_num);	/* erase bug */
		score_bug();		/* score for killing bug with bag */
		break;
	}

}


/*
add_bug()
{	/* allows another bug to be created */
	bugs_total++;

}
*/



inc_extra(colision)
int	colision;
{	/* reports aditional delay when bugs plot over each other */
	int	loop, mask;

	mask=0x100;
	for(loop=0; loop<6; loop++) {
		if(colision & mask)
			inc_plot();	/* report aditional plots */
		mask<<=1;
	}

}


dir_change(bug_num,colision)
int	bug_num, colision;
{
	int	loop, mask;

	mask=0x100;
	for(loop=0; loop<6; loop++) {
		if(colision & mask) {
			if(bug[bug_num][BUG_DIR]==bug[loop][BUG_DIR] && bug[loop][BUG_BEGIN]==0 && bug[bug_num][BUG_BEGIN]==0)
				bug[loop][BUG_DIR]=get_rev(bug[loop][BUG_DIR]);
		}
		mask<<=1;
	}

}



back_check(dir,x_pos,y_pos)
int	dir, x_pos, y_pos;
{
	int	flag;

	flag=FALSE;

	switch(dir) {
	case RIGHT:
		if(x_pos<W_MAX-1) {
			if( (get_background(x_pos+1,y_pos) & 0x2000)==0 
			    && ( (get_background(x_pos+1,y_pos) & 0x1)==0 || (get_background(x_pos,y_pos) & 0x10)==0) )
				flag=TRUE;
		}
		break;
	case LEFT:
		if(x_pos>0) {
			if( (get_background(x_pos-1,y_pos) & 0x2000)==0 
			    && ( (get_background(x_pos-1,y_pos) & 0x10)==0 || (get_background(x_pos,y_pos) & 0x1)==0) )
				flag=TRUE;
		}
		break;
	case UP:
		if(y_pos>0) {
			if( (get_background(x_pos,y_pos-1) & 0x2000)==0 
			    && ( (get_background(x_pos,y_pos-1) & 0x800)==0 || (get_background(x_pos,y_pos) & 0x40)==0) )
				flag=TRUE;
		}
		break;
	case  DOWN:
		if(y_pos<H_MAX-1) {
			if( (get_background(x_pos,y_pos+1) & 0x2000)==0 
			    && ( (get_background(x_pos,y_pos+1) & 0x40)==0 || (get_background(x_pos,y_pos) & 0x800)==0) )
				flag=TRUE;
		}
		break;
	}

	return(flag);

}



save_bugs(x_pos)
int	x_pos;
{
	int	bug_num;

	for(bug_num=0; bug_num<6; bug_num++) {
		if(bug[bug_num][BUG_X_POS]==x_pos && bug[bug_num][BUG_DIR]==UP)
			bug[bug_num][BUG_DIR]=DOWN;	/* give bug intelegence to run away from falling bags */
	}

}



era_bug(bug_num)
int	bug_num;
{

	if(bug[bug_num][BUG_ACTIVE]) {	/* dont erase a dead image */
		bug[bug_num][BUG_ACTIVE]=FALSE;
		bug[bug_num][BUG_ALIVE]=FALSE;
		sp_erase(bug_num+8);
		if(get_bonus() )	/* create another bug if in bonus round */
			bugs_total++;		
	}

}
 


bag_bugs(bag_num,colision)
int	bag_num, colision;
{	/* kill all bugs indicated by the colision as they have been hit by a money bag */
	int	bug_num, mask;

	mask=0x100;
	for(bug_num=0; bug_num<6; bug_num++) {
		if((colision & mask) && bug[bug_num][BUG_Y]>=get_y_bag(bag_num)) {	/* this bug has been hit */
			kill_bug(bug_num,MONEY_BAG,bag_num);
		}
		mask<<=1;
	}

}



rem_bugs(colision)
int	 colision;
{	/* erase all bugs indicated by the colision word */
	int	bug_num, mask, stat;

	stat=0;	/* counter for number of bugs removed */
	mask=0x100;
	for(bug_num=0; bug_num<6; bug_num++) {
		if(colision & mask) {	/* this bug has been hit */
			era_bug(bug_num);
			stat++;
		}
		mask<<=1;
	}
	return(stat);
}



kill_bug(bug_num,d_type,num)
int	bug_num, d_type, num;
{

	bug[bug_num][BUG_ALIVE]=FALSE;
	bug[bug_num][DEAD_TYPE]=d_type;
	bug[bug_num][DEAD_NUM]=num;


}


bugs_left()
{	/* check if all bugs that should be created are dead */
	return(bugs_count()+bugs_total-bugs_created);

}



bugs_count()
{
	int	bug_num, a;

	a=0;	/* counter for active bugs */
	for(bug_num=0; bug_num<6; bug_num++) {
		if(bug[bug_num][BUG_ACTIVE])
			a++;
	}
	return(a);	/* return count of active bugs */

}	


delay_bugs(a)
int	a;
{	/* delay bugs to balance movement speed */

	int	loop;

	if(a>6)
		a=6;

	for(loop=0; loop<a; loop++) {
		if(loop!=0)	/* one bug always goes at full speed */
			bug[loop][BUG_WAIT]++;
	}

}



rst_bwait()
{
	wait_flag=TRUE;

}
	
#define		DROP_WAIT	15


#define		BAG_X		0
#define		BAG_Y		1
#define		BAG_X_POS   	2
#define		BAG_Y_POS   	3
#define		BAG_X_REM  	4
#define		BAG_Y_REM	5
#define		BAG_DIR		6
#define		BAG_LOOSE	7
#define		BAG_COUNT	8
#define		BAG_FIRST	9
#define		BAG_ACTIVE	10
#define		BAG_BROKEN	11
#define		BAG_BRAKABLE	12

int	bags_0[8][20];
int	bags_1[8][20];
int	bags[8][20];

/* the first value specifies the bag number for current round (1-7)
   
	   The second is the information for that bag
		0 = true X value (0-319)
		1 = true Y value (0-199)
		2 = X matrix position (0-14)
		3 = Y matrix position (0-9)
		4 = 0 if bag is directly within an X matrix location
		5 = 0 if bag is directly within an Y matrix location
		6 = Direction of bag movement
		7 = TRUE when bag is ready to fall - after digging under it
		8 = Counter for bag falling - decremented toward zero if above if TRUE
		9 = TRUE when bag is fall for the first time - the background is not erased for the first move
		10 = TRUE when bag is presently being used on screen
		11 = >0 when bag has fallen more than one level and has broken
		12 = TRUE when bag has fallen more than one level and needs to be broken
*/


int	bag_wait;	/* for convenience, the same variable is used for boath players */
int	broke_max;

init_tb()	/* create money bags at corrct positions for the level */
{	
        int	bag_num, x, y, x_pos, y_pos, loop;

	bag_wait=0;
	broke_max=150-get_dificulty()*10;	/* time before money pile disapears */

	for(bag_num=1; bag_num<8; bag_num++) {
		bags[bag_num][BAG_ACTIVE]=FALSE;
	}

	bag_num=1;
	for(x_pos=0; x_pos<W_MAX; x_pos++) {
		for(y_pos=0; y_pos<H_MAX; y_pos++) {
			if(get_mat(x_pos,y_pos,get_screen())=='B' && bag_num<8) {
				bags[bag_num][BAG_ACTIVE]=TRUE;		/* show that the bag is now on screen */
				bags[bag_num][BAG_BROKEN]=0;		/* show that the bag is not broken */
				bags[bag_num][BAG_BRAKABLE]=0;		/* show that the bag may not be broken */
				bags[bag_num][BAG_DIR]=STOP;	/* start bag with no movement */
				bags[bag_num][BAG_LOOSE]=FALSE;	/* set loose bag flag */
				bags[bag_num][BAG_COUNT]=DROP_WAIT;		/* set loose bag counter */
				bags[bag_num][BAG_FIRST]=TRUE;		/* set flag to show that bag has not started falling */
				x=x_pos*20+X_OFFSET;	/* find X coordinate of screen image */
				y=y_pos*18+Y_OFFSET;	/* find Y coordinate of screen image */
				bags[bag_num][BAG_X]=x;	/* save X coordinate of screen image */
				bags[bag_num][BAG_Y]=y;	/* save X coordinate of screen image */
				bags[bag_num][BAG_X_POS]=x_pos;	/* save X matrix coordinate of the image */
				bags[bag_num][BAG_Y_POS]=y_pos;	/* save Y matrix coordinate of the image */
				bags[bag_num][BAG_X_REM]=0;	/* set flag to show that bag is on an even x matrix location */
				bags[bag_num][BAG_Y_REM]=0;	/* set flag to show that bag is on an even Y matrix location */
				bag_num++;	/* set up for next bag */
			}
		}
	}
			
	for(bag_num=1; bag_num<8; bag_num++) {
		for(loop=0; loop<20; loop++) {
			if(get_player()==0)
				bags_0[bag_num][loop]=bags[bag_num][loop];
			else
				bags_1[bag_num][loop]=bags[bag_num][loop];
		}
	}

}


start_tb()
{
        int	bag_num, loop;


	for(bag_num=1; bag_num<8; bag_num++) {
		for(loop=0; loop<20; loop++) {
			if(get_player()==0)
				bags[bag_num][loop]=bags_0[bag_num][loop];
			else
				bags[bag_num][loop]=bags_1[bag_num][loop];

		}
		if(bags[bag_num][BAG_ACTIVE]) {
			sp_place(bag_num,bags[bag_num][BAG_X],bags[bag_num][BAG_Y]);	/* draw bag on screen */
		}
	}


}




end_tb()
{
	int	bag_num, loop;

	rst_fall();	/* stop any sound for falling bags */

	for(bag_num=1; bag_num<8; bag_num++) {

		if( (bags[bag_num][BAG_X_POS]==M_X_START && bags[bag_num][BAG_Y_POS]==M_Y_START)
		    || (bags[bag_num][BAG_X_REM] || bags[bag_num][BAG_Y_REM])
		    || (bags[bag_num][BAG_BROKEN] || bags[bag_num][BAG_BRAKABLE] || bags[bag_num][BAG_LOOSE]) ) {
			if(bags[bag_num][BAG_ACTIVE]) {
				bags[bag_num][BAG_ACTIVE]=FALSE;
				sp_erase(bag_num);
			}
		}

		for(loop=0; loop<20; loop++) {
			if(get_player()==0)
				bags_0[bag_num][loop]=bags[bag_num][loop];
			else
				bags_1[bag_num][loop]=bags[bag_num][loop];

		}

	}

}

task_b()
{
	int	bag_num, x_pos, y_pos, flagf, flagl;


	for(bag_num=1; bag_num<8; bag_num++) {

		if(bags[bag_num][BAG_ACTIVE]) {	/* check only active bags */
			if(bags[bag_num][BAG_BROKEN]) {

/* redraw bag for falling/breaking effect */
				if(bags[bag_num][BAG_BROKEN]==1) {
					snd_break();	/* start broken bag sound */
					draw_bag(bag_num,BAG_7,bags[bag_num][BAG_X],bags[bag_num][BAG_Y]);
					inc_plot();	/* report a screen plot */
				}
				if(bags[bag_num][BAG_BROKEN]==3) {
					draw_bag(bag_num,BAG_8,bags[bag_num][BAG_X],bags[bag_num][BAG_Y]);
					inc_plot();	/* report a screen plot */
				}
				if(bags[bag_num][BAG_BROKEN]==5) {
					draw_bag(bag_num,BAG_9,bags[bag_num][BAG_X],bags[bag_num][BAG_Y]);
					inc_plot();	/* report a screen plot */
				}

/* increment broken bag timer */
				bags[bag_num][BAG_BROKEN]++;

/* check if bag needs to be removed */
				if(bags[bag_num][BAG_BROKEN]==broke_max)	/* erase bag after time limit */
					era_bag(bag_num);
                                else {	/* if area below the bag has been dug out then increment timer for quick removal */
					if(bags[bag_num][BAG_Y_POS]<(H_MAX-1) && bags[bag_num][BAG_BROKEN]<(broke_max-10)) {
						x_pos=bags[bag_num][BAG_X_POS];
						y_pos=bags[bag_num][BAG_Y_POS];
						if((get_background(x_pos,y_pos+1) & 0x2000)==0)
							bags[bag_num][BAG_BROKEN]=broke_max-10;
					}
				}
			}
			else
/* process any active unbroken bags */
				check_bag(bag_num);
      		}
	}

/* check if falling or loose bag sound is finished */
	flagf=TRUE;	/* check for falling bags - if none then turn off falling bag sound */
	flagl=TRUE;	/* check for loose bags - if none then turn off loose bag sound */
	for(bag_num=1; bag_num<8; bag_num++) {
		if(bags[bag_num][BAG_DIR]==DOWN && bags[bag_num][BAG_ACTIVE])
			flagf=FALSE;
		if(bags[bag_num][BAG_LOOSE] && bags[bag_num][BAG_DIR]!=DOWN && bags[bag_num][BAG_ACTIVE])
			flagl=FALSE;
	}	
	if(flagf)
		rst_fall();	/* stop falling bag sound */
	if(flagl)
		rst_loose();	/* stop loose bag sound */

}


check_bag(bag_num)
int	bag_num;
{
	int	x, x_pos, x_rem, y, y_pos, y_rem, temp;


	x=bags[bag_num][BAG_X];
	x_pos=bags[bag_num][BAG_X_POS];
	x_rem=bags[bag_num][BAG_X_REM];
	y=bags[bag_num][BAG_Y];
	y_pos=bags[bag_num][BAG_Y_POS];
	y_rem=bags[bag_num][BAG_Y_REM];





	switch(bags[bag_num][BAG_DIR]) {
	case STOP:
/* check if a man has burrowed under a bag 
   if not already at the bottom of the screen and it is on an even X matrix position */
		if(y<Y_LAST && x_rem==0) {
			if(bags[bag_num][BAG_LOOSE]) {	/* the bag is already loose & getting ready to fall */
				if(!bags[bag_num][BAG_COUNT]) {	/* if the count is over then move the bag down */
					bags[bag_num][BAG_DIR]=DOWN;
					init_fall();	/* start falling bag sound */
				}
				else {
					bags[bag_num][BAG_COUNT]--;
					temp=bags[bag_num][BAG_COUNT]%8;
					switch(temp) {
					case 0:
						draw_bag(bag_num,BAG_4,x,y);
						inc_plot();	/* report a screen plot */
						init_loose();	/* sound for rocking bag */
						break;
					case 2:
						draw_bag(bag_num,BAG_0,x,y);
						inc_plot();	/* report a screen plot */
						init_loose();	/* sound for rocking bag */
						break;
					case 4:
						draw_bag(bag_num,BAG_5,x,y);
						inc_plot();	/* report a screen plot */
						init_loose();	/* sound for rocking bag */
						break;
					case 6:
						draw_bag(bag_num,BAG_0,x,y);
						inc_plot();	/* report a screen plot */
						init_loose();	/* sound for rocking bag */
						break;
					}
				}
		        }
			else {
				if(((get_background(x_pos,y_pos+1) & 0xfdf)!=0xfdf) && (!get_man_block(x_pos,y_pos+1)) )
					bags[bag_num][BAG_LOOSE]=TRUE;
			}
        	}
		else {	/* if bag is not ready to fall then reset falling variables - needed if a bag is moved
		  	   while it is getting ready to fall */
			bags[bag_num][BAG_COUNT]=DROP_WAIT;
			bags[bag_num][BAG_LOOSE]=FALSE;
		}

		break;

	case LEFT:
	case RIGHT:
/* check if bag needs to fall after being pushed left or right by the man or another bag 
   or if the bag is moving left or right and is directly in an X matrix position & not at the 
   bottom of screen, then change its direction to down 
   or if bag is at an even matrix position and ground is intact underneath - stop the movement */
		if(x_rem==0 && y<Y_LAST) {
			/* if a hole or partial hole is under the bag then start it falling */	
			if((get_background(x_pos,y_pos+1) & 0xfdf)!=0xfdf) {
				bags[bag_num][BAG_DIR]=DOWN;
				bags[bag_num][BAG_COUNT]=0;	/* clear counter to stop bags from wobbling */
				init_fall(DOWN);	/* start falling sound */
			}
			else
				stop_bag(bag_num);
		}

		if(x_rem==0 && y>=Y_LAST)	/* special case for stopping right - left movement on the bottom row */
			stop_bag(bag_num);
		break;

	case DOWN:
/* check if bag has fallen one level - bag must be broken when bottom is reached 
   also check for conditions that stop the bag from continuing to fall */
		if(y_rem==0) {
			bags[bag_num][BAG_BRAKABLE]++;
		}

		/* check for conditions to stop bag falling */
		if(y>=Y_LAST) {	/* stop bag at bottom of screen */
			stop_bag(bag_num);
		}
		else {	/* stop bag if the next layer is completely intact */			
			if(((get_background(x_pos,y_pos+1) & 0xfdf)==0xfdf) && y_rem==0) {
				stop_bag(bag_num);
			}
		}

		save_bugs(bags[bag_num][BAG_X_POS]);	/* tell bugs that a bag is falling on a Y tunnel */

		break;

	}
		

/* move bag if required */

	if(bags[bag_num][BAG_DIR]!=STOP) {	/* check for delay in moving bags left and right */
		if(bags[bag_num][BAG_DIR]!=DOWN && bag_wait) {	/* never delay falling bags */
			bag_wait--;
		}
		else
			move_bag(bag_num,bags[bag_num][BAG_DIR]);
	}

}



stop_bag(bag_num)	/* stop bag movement & set bag matrix information */
int	bag_num;
{
	int	loop, mask, colision;

	if(bags[bag_num][BAG_DIR]==DOWN && bags[bag_num][BAG_BRAKABLE]>1)
		bags[bag_num][BAG_BROKEN]=1;	/* start broken bag sequence */
	else
		bags[bag_num][BAG_BRAKABLE]=0;
		

	bags[bag_num][BAG_DIR]=STOP;
	bags[bag_num][BAG_COUNT]=DROP_WAIT;
	bags[bag_num][BAG_LOOSE]=FALSE;

	colision=draw_bag(bag_num,BAG_0,bags[bag_num][BAG_X],bags[bag_num][BAG_Y]);
	inc_plot();	/* report a screen plot */
	mask=0x2;	/* set mask for first bag */

	for(loop=1; loop<8; loop++) {
		if(mask & colision) 
			era_bag(loop);	/* erase any bags unbroken under the one just stopped */
		mask<<=1;	/* check the next bag */
	}	
}



move_bag(bag_num,dir)
int	bag_num, dir;
{	/* move a specific bag - if any other bags are hit then the move is aborted & a false is returned */
	int	x, y, x_pos, y_pos, x_rem, y_rem, old_x, old_y, colision, flag;

	flag=TRUE;	/* initialize flag to show a good move */
	x=bags[bag_num][BAG_X];
	x_pos=bags[bag_num][BAG_X_POS];
	x_rem=bags[bag_num][BAG_X_REM];
	y=bags[bag_num][BAG_Y];
	y_pos=bags[bag_num][BAG_Y_POS];
	y_rem=bags[bag_num][BAG_Y_REM];

	old_x=x; old_y=y;	/* save old location incase of a bad move */

/* check if bag is not active (broken on ground) */
	if(bags[bag_num][BAG_BROKEN]) {
		grab_money(bag_num);	/* check if man hits money pile */
		return(TRUE);	/* show a good move but don't actually move the bag */
	}



/* check if trying to move a falling bag left or right - ignore unless hitting man or bug */
	if(bags[bag_num][BAG_DIR]==DOWN && (dir==LEFT || dir==RIGHT) )  {
		colision=draw_bag(bag_num,BAG_6,x,y);	/* redraw the bag to see if it hits the man */
		inc_plot();	/* report a screen plot */
		if((colision & 0x01) && get_m_y()>=y) {	/* check for colisions with man lower on the screen */
			kill_man(MONEY_BAG,bag_num);	/* start man dead sequence */
		}		
		if(colision & 0x3f00) {	/* check for colision with bugs */
			bag_bugs(bag_num,colision);
        	}

		return(TRUE);	/* show a good move but don't actually move the bag */
	}


/* check if bag would go off screen */
	if( (x==X_LAST && dir==RIGHT) || (x==X_FIRST && dir==LEFT) ||
	    (y==Y_LAST && dir==DOWN) || (y==Y_FIRST && dir==UP) )
		flag=FALSE;	/* set flag for bad move */





	if(flag) {	/* find new bag position & erase background if bag is falling */
		switch(dir) {	/* move bag position */
		case RIGHT:
			x+=4;
			break;
		case LEFT:
			x-=4;
			break;
		case DOWN:
			if(bags[bag_num][BAG_FIRST]) {	/* don't erase top of passage when first starting to fall */
				bags[bag_num][BAG_FIRST]=FALSE;
				era_b_first(x,y);	/* erase first piece of background if bag is starting to fall */ 
				era_up(x,y+21);	/* erase above to create a hole as bugs will take this new route */

			}
			else
				era_b_down(x,y);	/* erase background if bag is falling */
			era_background(x,y,dir);	/* erase background array bits */
			dest_coin(x_pos,y_pos);	/* remove any coin in area to be destroyed - next block down */
			y+=6;
			break;
		}
		

/* move the bag - check & handle colisions */
		switch(dir) {
		case DOWN:
			colision=draw_bag(bag_num,BAG_6,x,y);	/* move a falling bag on screen */
			inc_plot();	/* report a screen plot */
			if((colision & 0x01) && get_m_y()>=y) {	/* check for colisions with man lower on the screen */
				kill_man(MONEY_BAG,bag_num);	/* start man dead sequence */
			}		
			if(colision & 0x3f00)	/* bugs hit by falling bag */
				bag_bugs(bag_num,colision);

			break;

		case LEFT:
		case RIGHT:
/* bags may not be loose if being pushed sideways */
			bags[bag_num][BAG_COUNT]=DROP_WAIT;
			bags[bag_num][BAG_LOOSE]=FALSE;

			colision=draw_bag(bag_num,BAG_0,x,y);	/* move normal bag on screen */
			inc_plot();	/* report a screen plot */
			bag_wait=1;	/* delay bag movement if a colision occures */
			if(colision & 0xfe) {	/* check for colisions with other bags */
				/* if other bags won't move then set flag & move back to the origional position */
				if(!move_all_bags(dir,colision)) {
					x=old_x; y=old_y;	/* restore origional coordinates */
					draw_bag(bag_num,BAG_0,x,y);		/* move bag */
					inc_plot();	/* report a screen plot */
					flag=FALSE;	/* show a bad move */
				}
			}

			if((colision & 0x1) || (colision & 0x3f00) ) {	/* check for colisions with man or bug */
				x=old_x; y=old_y;	/* restore origional coordinates */
				draw_bag(bag_num,BAG_0,x,y);		/* move bag */
				inc_plot();	/* report a screen plot */
				flag=FALSE;	/* show a bad move */
			}

			break;

		}



/* if move was ok then make bag keep moving else change direction */
		if(flag) 	
			bags[bag_num][BAG_DIR]=dir;
		else
			bags[bag_num][BAG_DIR]=get_rev(dir);


/* save temparary values in permenent array */ 	
		bags[bag_num][BAG_X]=x;	
		bags[bag_num][BAG_Y]=y;
		bags[bag_num][BAG_X_POS]=(x-X_OFFSET)/20;	/* indicate X matrix position */
		bags[bag_num][BAG_Y_POS]=(y-Y_OFFSET)/18;	/* indicate Y matrix position */
		bags[bag_num][BAG_X_REM]=(x-X_OFFSET)%20;	/* indicate if bag is on an even X matrix position */
		bags[bag_num][BAG_Y_REM]=(y-Y_OFFSET)%18;	/* indicate if bag is on an even Y matrix position */


	}
	
        return(flag);	/* return a true if move was sucessfull */

}



move_all_bags(dir,colision)
int	dir, colision;
{	/* move all bags that are indicated by the colision status */
	int	flag, bag_num, mask;

	flag=TRUE;	/* flag is reset to false if any bag will not move */
	mask=2;

	for(bag_num=1; bag_num<8; bag_num++) {
		if(colision & mask) {	/* try to move bag - if not possible then set flag to false */
			if(!move_bag(bag_num,dir))
				flag=FALSE;
		}
		mask<<=1;	/* set mask for next bit */
	}


	return(flag);	/* return a true if the move was completely sucessfull */

}



money_check(colision)
int	 colision;
{	/* check if any bags indicated by the colision status are broken money bags */
	int	flag, bag_num, mask;

	flag=TRUE;	/* flag is reset to false if any bag will not move */
	mask=2;

	for(bag_num=1; bag_num<8; bag_num++) {
		if(colision & mask) {	/* try to move bag - if not possible then set flag to false */
			if(bags[bag_num][BAG_BROKEN]) 
				grab_money(bag_num);	/* set flag to false if bag was not broken */
			else 
				flag=FALSE;
		}
		mask<<=1;	/* set mask for next bit */
	}
	return(flag);
}



era_bag(bag_num)
int	bag_num;
{

	if(bags[bag_num][BAG_ACTIVE]) {
		bags[bag_num][BAG_ACTIVE]=FALSE;	/* set non active flag */
		sp_erase(bag_num);	/* erase sprite from screen */
	}

}


get_y_bag(bag_num)
int	bag_num;
{
	return(bags[bag_num][BAG_Y]);

}

get_d_bag(bag_num)
int	bag_num;
{
	if(bags[bag_num][BAG_ACTIVE])
		return(bags[bag_num][BAG_DIR]);
	else
		return(STOP);	/* show bag stopped if not active */

}


get_active_bags()	/* return a mask to ignore all inactive bags */
{
	int	bag_num, mask, a;

	mask=2; a=0;
	for(bag_num=1; bag_num<8; bag_num++) {
		if(bags[bag_num][BAG_ACTIVE])
			a|=mask;	/* set apropriate colision mask bit ( sprites 1-7 ) */					
		mask<<=1;	/* set mask for the next bit */
	}

	return(a);

}


break_bags(colision)	/* remove all bags indicated by the colision data */
{
	int	bag_num, mask;

	mask=2;
	for(bag_num=1; bag_num<8; bag_num++) {
		if(bags[bag_num][BAG_ACTIVE] && (colision & mask) )
			era_bag(bag_num);	/* remove bag */

		mask<<=1;	/* set mask for the next bit */
	}

}


get_moving_bags()	/* return a mask to ignore all inactive bags */
{
	int	bag_num, mask, a;

	a=0;
	for(bag_num=1; bag_num<8; bag_num++) {
		if(bags[bag_num][BAG_ACTIVE] && bags[bag_num][BAG_BROKEN]<10 
		   && (bags[bag_num][BAG_BROKEN] || bags[bag_num][BAG_LOOSE]))
			a++;
	}

	return(a);

}


grab_money(bag_num)
int	bag_num;
{
	int	colision;

	colision=draw_bag(bag_num,BAG_9,bags[bag_num][BAG_X],bags[bag_num][BAG_Y]);	/* check if man hits a money pile */
	inc_plot();	/* report a screen plot */
	if(colision & 0x01) {
		score_money();	/* increase score for getting money */
		snd_money();	/* start sound for grabbing money */
		rst_mwait();	/* reset man wait so man is not delayed getting money */
	}		
	else
		rst_bwait();	/* reset bug wait so bug is not delayed getting money */

	era_bag(bag_num);	/* remove money pile */
}

/* all man related variables are re-initialized for eack round & screen */

int	man_x, man_y, m_x_pos, m_y_pos, m_x_rem, m_y_rem;
int	m_dir, new_m_dir, m_last_dir, m_wait, m_alive, m_active;

int	mis_ready, mis_wait, mis_x, mis_y, mis_dir, mis_explode;

int	dead_type, dead_num, dead_body, dead_wait, fall_count;

int	bonus_flash, bonus_time, bonus_active, bonus_on, bonus_count;

int	coin_time;

/*	dead_type indicates the present death sequence i.e. falling due to money bag ext.
	dead_num is used with money bag death to show which gag is killing man
	dead_body indicates the mans body for the death roll
	dead_wait is the wait between the final death roll segments
*/

init_tc()
{	
	m_dir=LEFT; new_m_dir=LEFT; m_last_dir=RIGHT; /* start with no movement */
	m_x_pos=M_X_START; m_y_pos=M_Y_START; 
	man_x=m_x_pos*20+X_OFFSET; man_y=m_y_pos*18+Y_OFFSET;
	m_x_rem=0; m_y_rem=0;
	m_alive=TRUE; dead_type=MONEY_BAG; m_active=TRUE;
	m_wait=0;	/* delay before next man move */
	fall_count=0;	/* counter used to spin man as he falls to death */
	sp_place(0,man_x,man_y);

	mis_ready=TRUE;	/* show that missle is ready to fire */
	mis_wait=0;	/* no wait to fire missle */
	mis_explode=0;	/* reset explotion counter */
	fires=FALSE;	/* clear fire key */

	bonus_active=FALSE;	/* start with bonus not active */
	bonus_on=FALSE;		/* bonus mode not on */

	coin_time=0;	/* timer to indicate sucessive coin eating */

}


end_tc()
{
	sp_erase(0);	/* erase man from screen */
	m_active=FALSE;	/* stop man from being moved */
}


task_c()
{

/* move missile */	
	if(mis_explode)
		explode_missile();
	else
		move_missile();

/* move man */
	if(m_active) {
		if(m_alive) {	/* do normal movement for live man */
			if(m_wait) {
				draw_man(m_dir,man_x,man_y,(mis_ready && !mis_wait) );
				inc_plot();	/* report a screen plot */
				m_wait--;
			}
			else
				move_man();
		}
		else {	/* move man through dying sequence */
			dead_move();
		}
	}

/* check bonus operation */
	if(bonus_on && m_alive) {
		if(bonus_time) {
			bonus_time--;
			if(bonus_flash || bonus_time<20) {	/* flash for start & end of bonus time */
				bonus_flash--;
				if(bonus_time & 1) {
					palette(0);	/* back to normal */
					init_chase();	/* sound for chase start */
				}
				else {
					palette(1);	/* change screen color */
					init_chase();	/* sound for chase start */
				}
				if(bonus_flash==0) {
					init_music(0);
					rst_chase();	/* end sound for chase change */
					palette(1);	/* change screen color */
				}
			}
		}
		else {
			end_bonus();
			rst_chase();	/* end sound for chase change */
			init_music(1);	/* restart regular music */
		}

	}

	if(bonus_on && (!m_alive)) {
		end_bonus();
		rst_chase();	/* end sound for chase change */
		init_music(1);	/* restart regular music */
	}

/* adjuct counter for coin eating */
	if(coin_time>0)
		coin_time--;

}



move_missile()
{
	int	colision, mask, loop, point_stat;

	if(mis_ready) {
		if(mis_wait) {
			mis_wait--;	/* wait untill timer has gone to zero */
		}
		else {
			if(get_button() && get_m_status() ) {	/* fire if button has been pressed & man is alive */
				mis_wait=60+get_dificulty()*3;
				mis_ready=FALSE;	/* show missle is active */
				switch(m_last_dir) {
				case RIGHT:
					mis_x=man_x+8; mis_y=man_y+4;	/* set up initial missle position */
					break;
				case LEFT:
					mis_x=man_x; mis_y=man_y+4;	/* set up initial missle position */
					break;
				case UP:
					mis_x=man_x+4; mis_y=man_y;	/* set up initial missle position */
					break;
				case DOWN:
					mis_x=man_x+4; mis_y=man_y+8;	/* set up initial missle position */
					break;
				}
				mis_dir=m_last_dir; 	/* set up initial missle direction */
				sp_place(15,mis_x,mis_y);	/* place missle */
				init_fire();	/* start missle sound */
			}

		}
	}
	else {	/* move an active missle */
		switch(mis_dir) {
		case RIGHT:
			mis_x+=8;
			point_stat=ppoint(mis_x,mis_y+4);
			point_stat|=ppoint(mis_x+4,mis_y+4);
			break;
		case LEFT:
			mis_x-=8;
			point_stat=ppoint(mis_x,mis_y+4);
			point_stat|=ppoint(mis_x+4,mis_y+4);
			break;
		case UP:
			mis_y-=7;
			point_stat=ppoint(mis_x+4,mis_y) & 0xc0;
			point_stat|=ppoint(mis_x+4,mis_y+1) & 0xc0;
			point_stat|=ppoint(mis_x+4,mis_y+2) & 0xc0;
			point_stat|=ppoint(mis_x+4,mis_y+3) & 0xc0;
			point_stat|=ppoint(mis_x+4,mis_y+4) & 0xc0;
			point_stat|=ppoint(mis_x+4,mis_y+5) & 0xc0;
			point_stat|=ppoint(mis_x+4,mis_y+6) & 0xc0;
			break;
		case DOWN:
			mis_y+=7;
			point_stat=ppoint(mis_x,mis_y) & 3;
			point_stat|=ppoint(mis_x,mis_y+1) & 3;
			point_stat|=ppoint(mis_x,mis_y+2) & 3;
			point_stat|=ppoint(mis_x,mis_y+3) & 3;
			point_stat|=ppoint(mis_x,mis_y+4) & 3;
			point_stat|=ppoint(mis_x,mis_y+5) & 3;
			point_stat|=ppoint(mis_x,mis_y+6) & 3;
			break;
		}

		
		colision=draw_missile(mis_x,mis_y,0);
		inc_plot();	/* report a screen plot */

		if(colision & 0x3f00) {
			mask=0x100;
			for(loop=0; loop<6; loop++) {		
				if(colision & mask) {
					era_bug(loop);	/* remove bug */
					score_bug();	/* score for killing bug with missile */
					mis_explode=1;	/* start explosion */
				}
				mask<<=1;
			}
		}
		if(colision & 0x40fe)	/* hit bonus or money */
			mis_explode=1;	/* start explosion */
	
  /* check for off screen or end of tunnel conditions */
		switch(mis_dir) {
		case RIGHT:
			if(mis_x>(X_LAST+4))
				mis_explode=1;	/* start explosion */
			else {
				if(point_stat && !colision) {
					mis_explode=1;	/* start explosion */
					mis_x-=8;	/* move missile back to origional position */
					draw_missile(mis_x,mis_y,0);
				}
			}
			break;
		case LEFT:
			if(mis_x<(X_FIRST+4))
					mis_explode=1;
			else {
				if(point_stat && !colision) {
					mis_explode=1;	/* start explosion */
					mis_x+=8;	/* move missile back to origional position */
					draw_missile(mis_x,mis_y,0);
				}
			}
			break;
		case UP:
			if(mis_y<(Y_FIRST+3))
					mis_explode=1;
			else {
				if(point_stat && !colision) {
					mis_explode=1;	/* start explosion */
					mis_y+=7;	/* move missile back to origional position */
					draw_missile(mis_x,mis_y,0);
				}
			}
			break;
		case DOWN:
			if(mis_y>(Y_LAST+3))
				mis_explode=1;
			else {
				if(point_stat && !colision) {
					mis_explode=1;	/* start explosion */
					mis_y-=7;	/* move missile back to origional position */
					draw_missile(mis_x,mis_y,0);
				}
			}
			break;
		}


	}
}

explode_missile()
{
	switch(mis_explode) {
	case 1:
		snd_explode();	/* start explode sound */
		draw_missile(mis_x,mis_y,1);
		inc_plot();	/* report a screen plot */
		mis_explode=2;
		break;
	case 2:
		draw_missile(mis_x,mis_y,2);
		inc_plot();	/* report a screen plot */
		mis_explode=3;
		break;
	case 3:
		draw_missile(mis_x,mis_y,3);
		inc_plot();	/* report a screen plot */
		mis_explode=4;
		break;
	default:
		era_missile();
		mis_explode=0;
		break;
	}
}



era_missile()
{
	if(!mis_ready) {
		mis_ready=TRUE;
		sp_erase(15);
		rst_fire();	/* stop missle sound */
	}

}


move_man()
{
	int	m_key_dir, colision, m_x_old, m_y_old, flag, temp;
	
/* update keyboard & joystick variables */
	joystk();
	m_key_dir=check_turn();


/* set up the next direction of travel - do not change present direction */
	switch(m_key_dir) {
	case UP:
		new_m_dir=UP;
		break;
	case DOWN:
		new_m_dir=DOWN;
		break;
	case RIGHT:
		new_m_dir=RIGHT;
		break;  	
	case LEFT:
		new_m_dir=LEFT;
		break;
	default:
		new_m_dir=STOP;
	}


/* check for a change in Y direction */
	if(m_x_rem==0 && (new_m_dir==UP || new_m_dir==DOWN)) {
		m_dir=new_m_dir;
		m_last_dir=new_m_dir;
	}

/* check for a change in X direction */
	if(m_y_rem==0 && (new_m_dir==LEFT || new_m_dir==RIGHT)) {
		m_dir=new_m_dir;
		m_last_dir=new_m_dir;
	}


/* if no direction is requested then stop, else continue in the old direction */
	if(m_key_dir==STOP) {
		m_dir=STOP;
	}
	else
		m_dir=m_last_dir;


/* check if man is going to go past screen edges */
	if((man_x==X_LAST && m_dir==RIGHT) || (man_x==X_FIRST && m_dir==LEFT)
	    || (man_y==Y_LAST && m_dir==DOWN) || (man_y==Y_FIRST && m_dir==UP))
		m_dir=STOP;


/* erase background in front of man then move man */
	m_x_old=man_x; m_y_old=man_y;	/* store old location incase mans move is bad */

        if(m_dir!=STOP)
		era_background(man_x,man_y,m_dir);	/* update background matrix */
	switch(m_dir) {
	case RIGHT:
		era_right(man_x,man_y);
		man_x+=4;
		break;  	
	case LEFT:
		era_left(man_x,man_y);
		man_x-=4;
		break;
	case UP:
		era_up(man_x,man_y);
		man_y-=3;
		break;
	case DOWN:
		era_down(man_x,man_y);
		man_y+=3;
		break;
	}

/* remove or redraw coins in mans path */
	colision=coin_check((man_x-X_OFFSET)/20,(man_y-Y_OFFSET)/18,(man_x-X_OFFSET)%20,(man_y-Y_OFFSET)%18,m_dir);
	if(colision) {	/* man has eaten coin */
		score_coin();
		snd_coin();	/* sound for coin being eaten */
		snd_2_coin(coin_time);
		coin_time=9;	/* timer to indicate sucessive coin eating */
	}

/* check for colision */
	colision=draw_man(m_last_dir,man_x,man_y,(mis_ready && !mis_wait) );	/* redraw stopped man in new position on the screen */
	inc_plot();	/* report a screen plot */

	if(colision & 0xfe & get_active_bags()) {	/* colision detection for money bags */
		if(m_dir==RIGHT || m_dir==LEFT) {	/* move bags if going left or right */
			flag=move_all_bags(m_dir,colision);	/* move bags touched by the man */
			m_wait++;	/* make man miss a move if hitting money bags */
		}
		else {
			if(!money_check(colision))	/* check if any broken money bags are touched */
				flag=FALSE;	/* dont allow bags to be moved up or down if bag is not broken */
		}


		if(!flag) {	/* if bags would not move - return man to origional position */

			man_x=m_x_old; man_y=m_y_old;	/* restore old coordinates */
			draw_man(m_dir,man_x,man_y,(mis_ready && !mis_wait) );	/* redraw man in new position on the screen */
			inc_plot();	/* report a screen plot */

			m_last_dir=get_rev(m_dir);	/* reverse mans direction to prevent him from becoming stuck */

		}			
	}

	/* colision between bug & man is ONLY checked in ta.  This prevents dead bugs from killing man */
	if(colision & 0x3f00) {
		if(get_bonus() ) {	/* bonus is on */
			temp=rem_bugs(colision);
			while(temp) {	/* score for each bug removed */
				snd_bug();	/* start sound for bonus bug eaten */
				bonus_score();
				temp--;
			}
		}
	}

	if(colision & 0x4000) {
		score_extra();	/* score for getting bonus */
		start_bonus();	/* activate bonus operation */
	}

/* update variables for next time */
	m_x_pos=(man_x-X_OFFSET)/20; 
	m_x_rem=(man_x-X_OFFSET)%20;
	m_y_pos=(man_y-Y_OFFSET)/18;
	m_y_rem=(man_y-Y_OFFSET)%18;

}


dead_move()
{
	int	colision;

	switch(dead_type) {
	case MONEY_BAG:
		if(get_y_bag(dead_num)+6>man_y)
			man_y=get_y_bag(dead_num)+6;

		draw_man(FALL_9,man_x,man_y,FALSE);
		inc_plot();	/* report a screen plot */

		if(get_d_bag(dead_num)==STOP) {
			snd_dead();	/* start dead sound */
			dead_wait=5;
			dead_type=MAN;
			dead_body=0; 
			man_y-=6;
		}
		break;
	case MAN:
		if(dead_wait) {
			dead_wait--;
			break;
		}
		switch(dead_body) {
		case 0:
			init_music(2);	/* start music for death song */
			colision=draw_man(FALL_5,man_x,man_y,FALSE);
			inc_plot();	/* report a screen plot */
			if(colision & 0x3f00)
				rem_bugs(colision);	/* remove bugs hit by grave - prevents flashing */
			dead_body=1;
			dead_wait=2;
			break;
		case 1:
			draw_man(FALL_4,man_x,man_y,FALSE);
			inc_plot();	/* report a screen plot */
			dead_body=2;
			dead_wait=2;
			break;
		case 2:
			draw_man(FALL_3,man_x,man_y,FALSE);
			inc_plot();	/* report a screen plot */
			dead_body=3;
			dead_wait=2;
			break;
		case 3:
			draw_man(FALL_2,man_x,man_y,FALSE);
			inc_plot();	/* report a screen plot */
			dead_body=4;
			dead_wait=2;
			break;
		case 4:
			draw_man(FALL_1,man_x,man_y,FALSE);
			inc_plot();	/* report a screen plot */
			dead_type=DEAD;
			if(music)
				dead_wait=60;
			else
				dead_wait=10;
			break;
		}
		break;
	case BUG:

		dead_wait=0;
		dead_type=BOUNCE;
		dead_body=0;
		break;

	case BOUNCE:
		switch(dead_body) {
		case 0:
			draw_man(FALL_9,man_x,man_y-3,FALSE);
			inc_plot();	/* report a screen plot */
			dead_body=1;
			snd_dead();	/* start dead sound */
			break;
		case 1:
			draw_man(FALL_9,man_x,man_y-5,FALSE);
			inc_plot();	/* report a screen plot */
			dead_body=2;
			break;
		case 2:
			draw_man(FALL_9,man_x,man_y-6,FALSE);
			inc_plot();	/* report a screen plot */
			dead_body=3;
			break;
		case 3:
			draw_man(FALL_9,man_x,man_y-6,FALSE);
			inc_plot();	/* report a screen plot */
			dead_body=4;
			break;
		case 4:
			draw_man(FALL_9,man_x,man_y-5,FALSE);
			inc_plot();	/* report a screen plot */
			dead_body=5;
			break;
		case 5:
			draw_man(FALL_9,man_x,man_y-3,FALSE);
			inc_plot();	/* report a screen plot */
			dead_body=6;
			break;
		case 6:
			draw_man(FALL_9,man_x,man_y,FALSE);
			rst_music();
			inc_plot();	/* report a screen plot */
			dead_wait=5;
			dead_body=0;
			dead_type=MAN;
			break;
		}
		break;

	case DEAD:
		if(dead_wait) {
			dead_wait--;
			break;
		}
		make_dead(TRUE);	/* show tz that man is dead */
		break;
	}

}




begin_bonus()
{	/* allows bonus to be activated */
	bonus_active=TRUE;
	draw_bonus(20*14+X_OFFSET,Y_OFFSET);	/* show bonus marker on screen */

}


start_bonus()
{	/* activates bonus mode */
	bonus_on=TRUE;
	era_bonus();	/* remove marker from screen */
	palette(1);	/* change screen color */
	bonus_time=250-get_dificulty()*20;
	bonus_flash=20;
	bonus_count=1;	/* score multiplyer */
}



end_bonus()
{	/* end bonus mode */
	bonus_on=FALSE;
	palette(0);	/* normal screen color */

}


era_bonus()
{
	if(bonus_active) {
		bonus_active=FALSE;
		sp_erase(14);
	}
	palette(0);	/* normal screen color */
}



bonus_score()
{
	add_score(bonus_count*200);
	bonus_count <<=1;	/* double score next time */
}


get_bonus()
{	/* return bonus indicator */
	return(bonus_on);

}



get_rev(dir)
int	dir;
{

	switch(dir) {	/* reverse direction */
	case RIGHT:
		dir=LEFT;
		break;
	case LEFT:
		dir=RIGHT;
		break;
	case UP:
		dir=DOWN;
		break;
	case DOWN:
		dir=UP;
		break;
	}

	return(dir);

}


get_man_block(x,y)
int	x, y;
{
	if((m_dir==UP || m_dir==DOWN) && ( man_x-X_OFFSET)/20==x && ( (man_y-Y_OFFSET)/18==y || (man_y-Y_OFFSET)/18+1==y ) ) 
		return(TRUE);
	else
		return(FALSE);

}


get_m_x()
{
	return(man_x);

}



get_m_y()
{
	return(man_y);

}


get_m_status()
{

	return(m_alive);

}


kill_man(d_type,num)
int	d_type, num;
{
	if(dead_type!=MAN && dead_type!=DEAD && dead_type!=BUG) {
		rst_music();	/* stop music */
		m_alive=FALSE;
		dead_type=d_type;
		dead_num=num;
	}
}

rst_mwait()
{
	m_wait=0;

}


ppoint(x,y)
{	/* find screen location color */
	int	ax, temp;

	ax=(y & 0xfe)*40;
	if(y & 1)
		ax+=0x2000;	

	ax+=(x>>2);

	defseg=0xb800;
	temp=peek(ax);

	return(temp);

}

char	coins[H_MAX][W_MAX];	/* used during each round of play 
			   if a coin is at the location, data & player==TRUE 
			   player=1 for player#1, 2 for player #2 */


int	p_mask;


init_td()	/* clear all locations that may contain a coin then insert coins at corrct positions for the level */
{	

        int	loopx, loopy;

	if(get_player()==0)
		p_mask=1;	/* set mask for player 0 */
	else
		p_mask=2;	/* set mask for player 1 */


	for(loopx=0; loopx<W_MAX; loopx++) {
		for(loopy=0; loopy<H_MAX; loopy++) {
			if(get_mat(loopx,loopy,get_screen())=='C')
				coins[loopy][loopx] |=p_mask;
			else
				coins[loopy][loopx] &=~p_mask;
		}
	}

}



start_td()
{	

        int	loopx, loopy;

	if(get_player()==0)
		p_mask=1;	/* set mask for player 0 */
	else
		p_mask=2;	/* set mask for player 1 */

	for(loopx=0; loopx<W_MAX; loopx++) {
		for(loopy=0; loopy<H_MAX; loopy++) {
			if(coins[loopy][loopx] & p_mask)
				put_coin(loopx*20+X_OFFSET,loopy*18+3+Y_OFFSET);
		}
	}

}



coin_check(x_pos,y_pos,x_rem,y_rem,dir)
int	x_pos, y_pos, x_rem, y_rem, dir;
{	/* check for coins near area that man is digging */

	int	stat;

	stat=FALSE;	/* set to TRUE if a coin is removed - used for scoring */

	switch(dir) {
	case RIGHT:
		if(x_rem)
			x_pos++;	/* round up to point to real location */

		if(coins[y_pos][x_pos] & p_mask) {	/* update screen if a coin is present */
			if(x_rem==8) {	/* redraw coin to cover bite taken by man */
				put_coin(x_pos*20+X_OFFSET,y_pos*18+3+Y_OFFSET);
				inc_plot();	/* report screen plot */
			}
			if(x_rem==12) {	/* erase coin */
				rem_coin(x_pos*20+X_OFFSET,y_pos*18+3+Y_OFFSET);
				inc_plot();	/* report screen plot */
				stat=TRUE;
				coins[y_pos][x_pos]&=~p_mask;	/* remove coin from array */
			}
		}
		break;
	case LEFT:
		if(coins[y_pos][x_pos] & p_mask) {	/* update screen if a coin is present */
			if(x_rem==16) {	/* redraw coin to cover bite taken by man */
				put_coin(x_pos*20+X_OFFSET,y_pos*18+3+Y_OFFSET);
				inc_plot();	/* report screen plot */
			}
			if(x_rem==12) {	/* erase coin */
				rem_coin(x_pos*20+X_OFFSET,y_pos*18+3+Y_OFFSET);
				inc_plot();	/* report screen plot */
				stat=TRUE;
				coins[y_pos][x_pos]&=~p_mask;	/* remove coin from array */
			}
		}
		break;
	case UP:
		if(coins[y_pos][x_pos] & p_mask) {	/* update screen if a coin is present */
			if(y_rem==12) {	/* redraw coin to cover bite taken by man */
				put_coin(x_pos*20+X_OFFSET,y_pos*18+3+Y_OFFSET);
				inc_plot();	/* report screen plot */
			}
			if(y_rem==9) {	/* erase coin */
				rem_coin(x_pos*20+X_OFFSET,y_pos*18+3+Y_OFFSET);
				inc_plot();	/* report screen plot */
				stat=TRUE;
				coins[y_pos][x_pos]&=~p_mask;	/* remove coin from array */
			}
		}
		break;
	case DOWN:
		if(y_rem)
			y_pos++;	/* round up to point to real location */

		if(coins[y_pos][x_pos] & p_mask) {	/* update screen if a coin is present */
			if(y_rem==6) {	/* redraw coin to cover bite taken by man */
				put_coin(x_pos*20+X_OFFSET,y_pos*18+3+Y_OFFSET);
				inc_plot();	/* report screen plot */
			}
			if(y_rem==9) {	/* erase coin */
				rem_coin(x_pos*20+X_OFFSET,y_pos*18+3+Y_OFFSET);
				inc_plot();	/* report screen plot */
				stat=TRUE;
				coins[y_pos][x_pos]&=~p_mask;	/* remove coin from array */
			}
		}
		break;
        }
	return(stat);
}



count_coins()
{
	int	x, y, temp;

	temp=0;		/* reset coin counter */
	for(x=0; x<W_MAX; x++) {
		for(y=0; y<H_MAX; y++) {
			if(coins[y][x] & p_mask)
				temp++;
		}
	}

	return(temp);	/* return number of active coins */

}



	

dest_coin(x_pos,y_pos)	/* d=remove coin from matrix - used if a falling money bag destroys a coin */
int	x_pos, y_pos;
{

	if(coins[y_pos+1][x_pos] & p_mask) {
		coins[y_pos+1][x_pos]&=~p_mask;
        	rem_coin(x_pos*20+X_OFFSET,(y_pos+1)*18+3+Y_OFFSET);
	}
}

int	last_key, joy_x_low, joy_y_low, joy_x_high, joy_y_high, joyuse, button, last_x, last_y;


init_joy()	/* Initialize joysticks */
{
	joyuse=FALSE;
}



joystk()
{	/* update variables related to joystick, buttons & keyboard */

	int	loop;

	last_key=lkdir;
	if(keydir!=STOP)
		last_key=keydir;

	lkdir=STOP;

	if(fire || fires)	/* reset button of keyboard F1 is not pressed */
		button=TRUE;
	else
		button=FALSE;
	fires=FALSE;
}


start_wait()	/* check for the joystick button or a key to be pressed (other than ESC) */
{		/* the joystick MUST be in the centre position at this time */
		/* if no key or button then FALSE is returned */

	int	a, loop;

	a=FALSE;	/* show no key or joystick button to be pressed */

#ifdef	IBM
	if(keychr!=0 && !(keychr&0x80) && keychr!=01) {
#endif
#ifdef	HYP
	if(keychr!=0 && !(keychr&0x80) && keychr!=13) {
#endif
		a=TRUE;
		joyuse=FALSE;
		keychr=0;
        
	}

	if(a==FALSE)
		return(FALSE);	/* return to wait loop */

	return(TRUE);	/* show that a key or button was pressed */

}



check_turn()
{	/* get direction from keyboard or joystick */
	int	a;

	a=last_key;

/*	cprintf(" x = %d  y = %d  dir = %d \n\r",joyx,joyy,a);  */
	return(a);	/* return direction value */
	
}
		


get_button()	/* return the button status */
{
	return(button);

}

extern	char	diskdata[];	/* external disk transfer buffer */
extern	char	text[];

long	score_p, score_0, score_1, bonus_0, bonus_1;

char	htemp[10], highscore[40];

long	score[11];

char	name[11][4]	= { "...", "...", "...", "...", "...", "...", "...", "...", "...", "...", "..." };


int	timeout;
int	filenum;



/* ================= score values ===================

	bug	= 250
	coin	= 25
	money	= 500

	bonus for 8 sucessive coins = 250

	bonus	= 1000
	bugs after bonus:
	1	= 200
	2	= 400
	3	= 800
	ext.

*/


init_tf()	/* reset scores related to the present game - not high scores */
{
	add_score(0);	/* show present players score on screen in color red */
}


                             

init_hi_score()
{	/* reset high score */
	int	temp, count, loop, loop2;


#ifndef	FREEDEMO

/*	getbuf();*/	/* get track 39, sector #1 of drive 0 */ 
#endif
/*
#ifdef	FREEDEMO

	filenum=open("digger.scr",0x8002);
	if(filenum>0) {
		read(filenum,diskdata,512);
		close(filenum);
	}
#endif
*/


#if 0
	count=1;	/* recover high scores from disk buffer */
	for(loop=1; loop<11; loop++) {

		for(loop2=0; loop2<3; loop2++) {	/* get 3 character name */
			name[loop][loop2]=diskdata[count];
			count++;
		}

		count+=2;	/* disgard padding of 2 spaces */

		for(loop2=0; loop2<6; loop2++) {	/* get 6 digit score */
			htemp[loop2]=diskdata[count];
			count++;
		}

		strnum(htemp,&score[loop]);	/* convert 6 digit score string to la long int */

	}

	if(diskdata[0]!='s') 
#endif
	{ /* reset all scores if read was not good */
		for(temp=0; temp<11; temp++) {
			score[temp]=0;
			strcpy(name[temp],"...");
		}
	}


}



rst_score()	/* reset scores for this game */
{
	score_p=0; score_0=0; score_1=0; bonus_0=20000; bonus_1=20000;

}



task_f()	/* update fill multiplyer */
{
	int	a;

	a=a;

}


flash_score(color)
int	color;
{
	if(get_player()==0) {
		println(score_0,0,0,6,color);
	}
	else {
		if(score_1<100000)
			println(score_1,236,0,6,color);
		else
			println(score_1,248,0,6,color);
	}

}




add_score(val)	/* called to increase score */
int	val;
{


	if(get_player()==0) {
		score_0+=val;	/* add new score */
		if(score_0>999999)
			score_0=0;
		println(score_0,0,0,6,GREEN);
		if(score_0>=bonus_0) {	/* new life if posible */
			if(get_lives(1)<5) {
				add_life(1);	/* give player 1 a new life */
				print_lives();	/* update display */
			}
			bonus_0+=20000;	/* set up for next new life */
		}
	}
	else {
		score_1+=val;	/* add new score */
		if(score_1>999999)
			score_1=0;
		if(score_1<100000)
			println(score_1,236,0,6,GREEN);
		else
			println(score_1,248,0,6,GREEN);

		if(score_1>bonus_1) {	/* new life if posible */
			if(get_lives(2)<5) {
				add_life(2);	/* give player 2 a new life */
				print_lives();	/* update display */
			}
			bonus_1+=20000;	/* set up for next new life */
		}

	}

	inc_plot();	/* report screen printing */
	inc_plot();
	inc_plot();

}




check_hi_score()
{	/* update score display & check for high score */
	int	loop, xloop, yloop;

	add_score(0);	/* update score display */
	
	if(get_player()==0)
		score_p=score_0;
	else
		score_p=score_1;

#if 0
	if(score_p>score[10]) {	/* a new high score has been reached */
		clear(0);

		print_present_score();
		strcpy(text,"PLAYER ");	/* set up string */
		if(get_player()==0)
			strcat(text,"1");
		else
			strcat(text,"2");
		prints(text,108,0,RED);
		

		prints(" NEW HIGH SCORE ",64,40,RED);	/* write high score on screen */

		get_name();	/* get initiales for this player */

		sort_scores();	/* update high score list */

		save_scores();	/* save high scores on disk */
		
	}
	else

#else
	if(score_p>score[10])
	{
		score[10] = score_p;
		sort_scores();	/* update high score list */
	}

#endif

	 {	/* display game over message if not a new high score */
		blank_top();	/* clear top line of screen */

		prints("GAME OVER",104,0,WHITE);

		sn2_off();
		set_tone(40);
		sn2_stop();	/* turn off second sound source to stabalize interupts */
		for(xloop=0; xloop<20; xloop++) {
			for(loop=0; loop<8; loop++) {
				for(yloop=0; yloop<111; yloop++)
					yloop=yloop;
			}			

			for(loop=0; loop<8; loop++) {
				for(yloop=0; yloop<111; yloop++)
					yloop=yloop;
			}			

		}
                sn2_start();	/* restart sound interupts */

		prints("         ",104,0,WHITE);
	}
	
}



print_present_score()
{	/* display present score, number of lives left & high score if one has been set */
	println(score_0,0,0,6,3);	/* print present scores at top of screen */
	if(players()==2) {	/* show second score if 2 players are active */
		if(score_1<100000)
			println(score_1,236,0,6,3);
		else
			println(score_1,248,0,6,3);
	}
	
}






print_lives()
{	/* draw men on the top line to show spare lives */
 	int	loop, temp;

	temp=get_lives(1)-1;	/* dont show present life */
	for(loop=1; loop<5; loop++) {	/* a maximum of 4 lives may be displayed */

		if(temp>0)	/* draw gun */
			put_man(0,60+loop*20,0);
		else
			put_man(2,60+loop*20,0);

		temp--;
	}

	if(players()==2) {
		temp=get_lives(2)-1;	/* dont show present life */
		for(loop=1; loop<5; loop++) {	/* a maximum of 4 lives may be displayed */

			if(temp>0)	/* draw gun */
				put_man(1,244-loop*20,0);
			else
				put_man(2,244-loop*20,0);

			temp--;
		}


	}
}



show_players()	/* display number of players message */
{

	if(players()==1) {
		prints("ONE",220,25,BROWN);
		prints(" PLAYER ",192,39,BROWN);
	}
	else {
		prints("TWO",220,25,BROWN);
		prints(" PLAYERS",184,39,BROWN);
	}

}

show_scores()	/* display high score list */
{
	int	loop, color;


	prints("HIGH SCORES",16,25,3);
	color=2;
	for(loop=1; loop<11; loop++) {
		strcpy(highscore,"");	/* empty string */
		strcat(highscore,name[loop]);
		strcat(highscore,"  ");
		strscr(htemp,score[loop],TRUE);	/* get ascii string for score value */
		strcat(highscore,htemp);
		prints(highscore,16,31+loop*13,color);
		color=1;
	}

}




save_scores()	/* save scores to disk buffer */
{
#if 0
	int	loop, temp;

	strcpy(diskdata,"s");	/* clear buffer & show good data with s as the first character */


	for(loop=1; loop<11; loop++) {
		strcpy(highscore,"");	/* empty string */
		strcat(highscore,name[loop]);
		strcat(highscore,"  ");
		strscr(htemp,score[loop],TRUE);	/* get ascii string for score value */
		strcat(highscore,htemp);
		strcat(diskdata,highscore);
	}
#endif

#ifndef FREEDEMO

/* 	savbuf();*/	/* save to disk */  

#endif

/*
#ifdef	FREEDEMO

	filenum=creat("digger.scr",0x8002);
	if(filenum>0) {
		write(filenum,diskdata,512);
		close(filenum);
	}
#endif
*/

}




	

get_name()	/* get players initials from the keyboard */
{
#if 0
	int	y, temp, count, loop, yloop;

	prints("ENTER YOUR",100,70,3);
	prints(" INITIALS",100,90,3);
	prints("_ _ _",128,130,3);
	strcpy(name[0],"...");

	sn2_off();
	set_tone(40);
	sn2_stop();	/* turn off second sound source to stabalize interupts */


	timeout=FALSE;
	for(count=0; count<3; count++) {
		temp=0;
		while(temp==0 && !timeout) {
			temp=getkey(128+count*24,130);
			if(count && temp==0xe)
				count--;
			temp=conkey(temp);
		}

		if(temp!=0) {
			printc(temp,128+count*24,130,3);
			name[0][count]=temp;	/* store ascii in string */
		}

	}
	keychr=0;
	for(temp=0; temp<20; temp++)
		flash_palettes(15);
	sn2_start();	/* restart sound interupts */
	clear(0);
	palette(0);
#endif
}


flash_palettes(loop_max)
int	loop_max;
{
	int	loop, loop1, yloop;
	char	a;

	a=19;
	for(loop=0; loop<loop_max; loop++) {
		palette(1);
		for(yloop=0; yloop<a; yloop++) {
			yloop=yloop;
		}
		palette(0);
		for(yloop=0; yloop<a; yloop++) {
			yloop=yloop;
		}
	}

}


getkey(x,y)	/* get a letter from the keybaord & flash cursor */
int	x, y;
{
	int	count, loop;

	keychr=0;

	printc('_',x,y,3);
	for(loop=0; loop<50; loop++) {
		for(count=0; count<40; count++) {
			if(!(keychr & 0x80) && keychr)
				return((int)keychr);
			flash_palettes(15);			
		}
		for(count=0; count<40; count++) {
			if(!(keychr & 0x80) && keychr) {
				printc('_',x,y,3);
				return((int)keychr);
			}
			flash_palettes(15);			
		}
	}
	timeout=TRUE;	/* dont wait for ever */
	return(0);
}



sort_scores()	/* sort new score into the top 10 list */
{
        int	loop, count;


	count=10;
	while(count>1)  {	/* locate position of new score */
		if(score_p>=score[count-1])
			count--;
		else {
			break;
		}
	}

	for(loop=10; loop>count; loop--) {
		score[loop]=score[loop-1];
		strcpy(name[loop],name[loop-1]);
	}

	score[count]=score_p;
	strcpy(name[count],name[0]);


}



score_bug()
{	/* score for killing bug */

	add_score(250);

}



score_coin()
{	/* score for getting coin */

	add_score(25);
}



score_2_coin()
{	/* extra score for getting 8 sucessive coins */

	add_score(250);
}



score_money()
{	/* score for grabing money */

	add_score(500);

}



score_extra()
{	/* score for getting bonus */

	add_score(1000);

}


strscr(out,amount,blanks)	/* convert a long integer to a string  */
char	out[];
long	amount;
int	blanks;	/* if set to true a blank is inserted for leading zero's */
{

	int	chr, offset, flag;
	long	digit, testval;
	char	tstr[10];

	offset=0; digit=100000; flag=FALSE;
	strcpy(out,"");	/* initialize output string */

	while(digit>1) {	/* print all digits seperately exept the last */
		chr=amount/digit;
		amount %=digit;
		stcu_d(tstr,chr,10);	/* get ascii into tstr */
		if(chr || flag)	{ 	/* dont use leading zero's */
			strcat(out,tstr);	/* put new ascii digit on end of string */
			flag=TRUE;	/* show end of leading zero's */
		}
		else
			if(blanks)
				strcat(out," ");	/* replace leading zero's with a blank */

		digit /=10; offset++;
	}

	chr=amount;	/* print the last digit */
	stcu_d(tstr,chr,10);	/* get ascii into tstr */
	strcat(out,tstr);	/* put new ascii digit on end of string */


}


strnum(instr,amount)	/* convert a 6 digit string to a long integer  */
char	instr[];
long	*amount;
{

	int	chr, offset, flag;
	long	digit;

	offset=0; digit=100000; *amount=0;

	while(digit>0) {	/* print all digits seperately exept the last */
		chr=getval(instr[offset]);
		*amount =*amount+(digit*chr);
		digit /=10; offset++;
	}

}

int	back_0[H_MAX][W_MAX];
int	back_1[H_MAX][W_MAX];

int	background[H_MAX][W_MAX]; /* used to store info for present screen background 
				     the integer is split up to indicate the following:
				    	Bit number  Value   Meaning
				  		0     	0     	The first horizontal bite from the right has been removed
				  		1	0	The second     	"		"		"	
				  		2	0	The third	"		"		"	
                	                        3	0	The fourth	"		"		"
				  		4	0	The last	"		"		"

				  		6	0	The first vertical bite from the top has been removed
				  		7	0	The second	"		"		"
				  		8	0	The third	"		"		"
				  		9	0	The fourth	"		"		"
				  		10	0	The fifth	"		"		"
				  		11	0	The last	"		"		"

				  		13	0	The entire background square is removed
				  */		
								

init_tg()	/* create background and paths at corrct positions for the level */
{	
        int	temp, x_pos, y_pos;


	for(x_pos=0; x_pos<W_MAX; x_pos++) {
		for(y_pos=0; y_pos<H_MAX; y_pos++) {
			background[y_pos][x_pos]=0xffff;	/* show an un-eaten square */

			temp=get_mat(x_pos,y_pos,get_screen()); 	/* get type of square */
			if(temp=='S' || temp=='V') 	/* erase a vertical path */
					background[y_pos][x_pos]&=0xd03f;	/* set up matrix for this player */
			if(temp=='S' || temp=='H') 	/* erase a horizontal path */
					background[y_pos][x_pos]&=0xdfe0;	/* set up matrix for this player */

			if(get_player()==0)
				back_0[y_pos][x_pos]=background[y_pos][x_pos];
			else
				back_1[y_pos][x_pos]=background[y_pos][x_pos];

		}
	}

}



start_tg()
{
	int	x, y;

	for(x=0; x<W_MAX; x++) {
		for(y=0; y<H_MAX; y++) {
			if(get_player()==0)
				background[y][x]=back_0[y][x];
			else
				background[y][x]=back_1[y][x];

		}
	}
	palette(0);
	draw_background(get_screen());	/* create background pattern */
	era_path();

}


end_tg()
{
	int	x, y;

	for(x=0; x<W_MAX; x++) {
		for(y=0; y<H_MAX; y++) {
			if(get_player()==0)
				back_0[y][x]=background[y][x];
			else
				back_1[y][x]=background[y][x];

		}
	}

}



era_path()
{
        int	x_pos, y_pos, x, y;


	for(x_pos=0; x_pos<W_MAX; x_pos++) {
		for(y_pos=0; y_pos<H_MAX; y_pos++) {
			if((background[y_pos][x_pos] & 0x2000)==0) {	/* path is in this block */
				x=x_pos*20+X_OFFSET;
				y=y_pos*18+Y_OFFSET;
				if((background[y_pos][x_pos] & 0xfc0)!=0xfc0) {	/* erase a vertical path */
					background[y_pos][x_pos]&=0xd03f;	/* set up matrix for this player */
					era_down(x,y-15);	/* erase screen */
					era_down(x,y-12);
					era_down(x,y-9);
					era_down(x,y-6);
					era_down(x,y-3);
					era_up(x,y+3);

				}
				if((background[y_pos][x_pos] & 0x1f)!=0x1f) {
					background[y_pos][x_pos]&=0xdfe0;	/* set up matrix for this player */
					era_right(x-16,y);	/* erase screen */
					era_right(x-12,y);
					era_right(x-8,y);
					era_right(x-4,y);
					era_left(x+4,y);					                                	
				}					
				if(x_pos<(W_MAX-1)) {
					if((background[y_pos][x_pos+1] & 0xfdf)!=0xfdf)
						era_right(x,y); 
				}
				if(y_pos<(H_MAX-1)) {
					if((background[y_pos+1][x_pos] & 0xfdf)!=0xfdf)	/* if any are erased */
						era_down(x,y); 
				}

			}
		}
	}


}



era_background(x,y,dir)
int	x, y, dir;
{
	int	x_pos, x_rem, y_pos, y_rem;

	x_pos=(x-X_OFFSET)/20; x_rem=((x-X_OFFSET)%20)/4;
	y_pos=(y-Y_OFFSET)/18; y_rem=((y-Y_OFFSET)%18)/3;

	inc_plot();	/* report screen plotting */
	switch(dir) {	/* correct coordinates for next bite in direction of travel */
	case RIGHT:
		x_pos++;	/* correct to next matrix position to right */
		switch(x_rem) {
		case 0:
			background[y_pos][x_pos]&=0xfffe;	/* set flag for bite removed from background */
			break;
		case 1:
			background[y_pos][x_pos]&=0xfffd;
			break;
		case 2:
			background[y_pos][x_pos]&=0xfffb;
			break;
		case 3:
			background[y_pos][x_pos]&=0xfff7;
			break;
		case 4:
			background[y_pos][x_pos]&=0xffef;
			break;
		}
		if((background[y_pos][x_pos]&0x1f)==0)
			background[y_pos][x_pos]&=0xdfff;	/* set flag for entire square eaten */
		break;
	case LEFT:
		x_rem--;
		if(x_rem<0) {	/* correct for next position to the left */
			x_rem+=5;
			x_pos--;
		}
		switch(x_rem) {
		case 0:
			background[y_pos][x_pos]&=0xfffe;	/* set flag for bite removed from background */
			break;
		case 1:
			background[y_pos][x_pos]&=0xfffd;
			break;
		case 2:
			background[y_pos][x_pos]&=0xfffb;
			break;
		case 3:
			background[y_pos][x_pos]&=0xfff7;
			break;
		case 4:
			background[y_pos][x_pos]&=0xffef;
			break;
		}
		if((background[y_pos][x_pos]&0x1f)==0)
			background[y_pos][x_pos]&=0xdfff;	/* set flag for entire square eaten */
		break;
	case UP:
		y_rem--;
		if(y_rem<0) {	/* correct for next position up */
			y_rem+=6;
			y_pos--;
		}
		switch(y_rem) {
		case 0:
			background[y_pos][x_pos]&=0xffbf;	/* set flag for bite removed from background */
			break;
		case 1:
			background[y_pos][x_pos]&=0xff7f;
			break;
		case 2:
			background[y_pos][x_pos]&=0xfeff;
			break;
		case 3:
			background[y_pos][x_pos]&=0xfdff;
			break;
		case 4:
			background[y_pos][x_pos]&=0xfbff;
			break;
		case 5:
			background[y_pos][x_pos]&=0xf7ff;
			break;
		}
		if((background[y_pos][x_pos]&0xfc0)==0)
			background[y_pos][x_pos]&=0xdfff;	/* set flag for entire square eaten */
		break;
	case DOWN:
		y_pos++;	/* correct to next Y matrix location */
		switch(y_rem) {
		case 0:
			background[y_pos][x_pos]&=0xffbf;	/* set flag for bite removed from background */
			break;
		case 1:
			background[y_pos][x_pos]&=0xff7f;
			break;
		case 2:
			background[y_pos][x_pos]&=0xfeff;
			break;
		case 3:
			background[y_pos][x_pos]&=0xfdff;
			break;
		case 4:
			background[y_pos][x_pos]&=0xfbff;
			break;
		case 5:
			background[y_pos][x_pos]&=0xf7ff;
			break;
		}
		if((background[y_pos][x_pos]&0xfc0)==0)
			background[y_pos][x_pos]&=0xdfff;	/* set flag for entire square eaten */
		break;
	}
/*
	for(y_pos=0; y_pos<H_MAX; y_pos++) {
		for(x_pos=0; x_pos<W_MAX; x_pos++) {
			cprintf("%04x ",background[y_pos][x_pos]);
		}
		cprintf("\n\r");
	}
	cprintf("\n\r");
*/
}



get_background(x,y)
int	x, y;
{	/* return background square information */
	return(background[y][x]);

}

/* note length definitions */
#define		NS	1
#define		NE	2
#define		NQ	4
#define		NH	8
#define		NW	16

/* note shape definitions */
#define		ATTACK	0
#define		HOLD	1
#define		DECAY	2

#define TIMER_MODE	0x43
#define TIMER_PORT	0x42
#define INTERUPT_PORT	0x40
#define PORT_B		0x61
#define TIMER_ENABLE	0x01
#define SPEAKER_ENABLE	0x02
#define	ON		1
#define	OFF		0
#define	PULSE		1
#define	SQUARE		2


int	sound_freq, sound_on, sound2_on, sn2_stat, sn2_mode;
int	t_period, p_period, p_width, volume;

int	fall_period, fall_stat, fall_toggle, fall_num;
int	loose_stat, loose_type;
int	fire_stat, fire_freq, fire_pause;
int	chase_stat, chase_count, chase_toggle;
int	exp_stat, exp_period, exp_count;
int	break_stat, break_count, break_period;
int	coin_count, coin_stat;
int	coin_2_count, coin_2_stat, coin_2_period, coin_2_type;
int	bug_stat, bug_period, bug_c_1, bug_c_2;
int	dead_stat, dead_count, dead_period;
int	life_stat, life_count;
int	end_stat, end_count, end_loop;

int	money_stat, money_toggle, money_1, money_2, money_count;
int	m_pointer, m_type, m_count, m_note, m_stat, m_pause;
int	attack_level, attack_rate, hold_level, hold_rate, hold_count, decay_rate;
int	envelope, env_position;

int	time_reg=1;
int	timetemp;	/* used to equilize time on diferent speed CPU's */
int	time_mul;	/* used to equilize sound pulse width on diferent speed CPU's */


/*	tico-tico

	C5,NQ, AS4,NQ, C5,NQ, G4,NQ, DS4,NQ, G4,NQ, C4,NH,
	C5,NQ, AS4,NQ, C5,NQ, G4,NQ, DS4,NQ, G4,NQ, C4,NH,
	C5,NQ, D5,NQ, DS5,NQ, DS5,NQ, DS5,NQ, C5,NQ, D5,NQ, D5,NQ, D5,NQ,
	AS4,NQ, C5,NQ, C5,NQ, C5,NQ, B4,NQ, C5,12,

	C5,NQ, AS4,NQ, C5,NQ, G4,NQ, DS4,NQ, G4,NQ, C4,NH,
	C5,NQ, AS4,NQ, C5,NQ, G4,NQ, DS4,NQ, G4,NQ, C4,NH,
	C5,NQ, D5,NQ, DS5,NQ, DS5,NQ, DS5,NQ, C5,NQ, D5,NQ, D5,NQ, D5,NQ,
	AS4,NQ, C5,NQ, C5,NQ, C5,NQ, B4,NQ, C5,12,
*/


int	music0[] = { 	/* music for bonus round */
	C4,NE, C4,NE, C4,NQ, C4,NE, C4,NE, C4,NQ, C4,NE, C4,NE, F4,NQ, G4,NQ, A4,NQ,
	C4,NE, C4,NE, C4,NQ, C4,NE, C4,NE, C4,NQ, F4,NE, A4,NE, G4,NQ, E4,NQ, C4,NQ,
	C4,NE, C4,NE, C4,NQ, C4,NE, C4,NE, C4,NQ, C4,NE, C4,NE, F4,NQ, G4,NQ, A4,NQ,
	F4,NE, A4,NE, C5,10, AS4,NE, A4,NE, G4,NE, F4,NQ, A4,NQ, F4,NQ, 

	C4,NE, C4,NE, C4,NQ, C4,NE, C4,NE, C4,NQ, C4,NE, C4,NE, F4,NQ, G4,NQ, A4,NQ,
	C4,NE, C4,NE, C4,NQ, C4,NE, C4,NE, C4,NQ, F4,NE, A4,NE, G4,NQ, E4,NQ, C4,NQ,
	C4,NE, C4,NE, C4,NQ, C4,NE, C4,NE, C4,NQ, C4,NE, C4,NE, F4,NQ, G4,NQ, A4,NQ,
	F4,NE, A4,NE, C5,10, AS4,NE, A4,NE, G4,NE, F4,NQ, A4,NQ, F4,NQ, 

	A4,NE, A4,NE, A4,NQ, A4,NE, A4,NE, A4,NQ, A4,NE, A4,NE, A4,NQ, 
	D5,NQ, A4,NQ, D5,NQ, A4,NQ, D5,NQ, A4,NQ, G4,NQ, F4,NQ, E4,NQ, D4,NQ,
	A4,NE, A4,NE, A4,NQ, A4,NE, A4,NE, A4,NQ, A4,NE, A4,NE, A4,NQ, 
	D5,NQ, A4,NQ, D5,NQ, A4,NQ, D5,NQ, C5,NQ, B4,NQ, C5,NQ, B4,NQ, C5,NQ, 

	A4,NE, A4,NE, A4,NQ, A4,NE, A4,NE, A4,NQ, A4,NE, A4,NE, A4,NQ, 
	D5,NQ, A4,NQ, D5,NQ, A4,NQ, D5,NQ, A4,NQ, G4,NQ, F4,NQ, E4,NQ, D4,NQ,
	A4,NE, A4,NE, A4,NQ, A4,NE, A4,NE, A4,NQ, A4,NE, A4,NE, A4,NQ, 
	D5,NQ, A4,NQ, D5,NQ, A4,NQ, D5,NQ, C5,NQ, B4,NQ, C5,NQ, B4,NQ, C5,NQ, 

		32100 };



int	music1[] = { 	/* music for normal movement of man */

	D4,NE, C4,NE, 
	D4,NE, A3,NE, F3,NE, A3,NE, D3,NQ, D4,NE, C4,NE, 
	D4,NE, A3,NE, F3,NE, A3,NE, D3,NQ, D4,NE, E4,NE, 
	F4,NE, E4,NE, F4,NE, D4,NE, E4,NE, D4,NE, E4,NE, C4,NE,
	D4,NE, C4,NE, D4,NE, AS3,NE, D4,NQ, D4,NE, C4,NE,

	D4,NE, A3,NE, F3,NE, A3,NE, D3,NQ, D4,NE, C4,NE, 
	D4,NE, A3,NE, F3,NE, A3,NE, D3,NQ, D4,NE, E4,NE, 
	F4,NE, E4,NE, F4,NE, D4,NE, E4,NE, D4,NE, E4,NE, C4,NE,
	D4,NE, C4,NE, D4,NE, E4,NE, F4,NQ, A4,NE, G4,NE,
	
	A4,NE, F4,NE, C4,NE, F4,NE, A3,NQ, A4,NE, G4,NE,
	A4,NE, F4,NE, C4,NE, F4,NE, A3,NQ, A4,NE, B4,NE,
	C5,NE, B4,NE, C5,NE, A4,NE, B4,NE, A4,NE, B4,NE, G4,NE,
	A4,NE, G4,NE, A4,NE, F4,NE, A4,NQ, A4,NE, G4,NE,

	A4,NE, F4,NE, C4,NE, F4,NE, A3,NQ, A4,NE, G4,NE,
	A4,NE, F4,NE, C4,NE, F4,NE, A3,NQ, A4,NE, B4,NE,
	C5,NE, B4,NE, C5,NE, A4,NE, B4,NE, A4,NE, B4,NE, G4,NE,
	A4,NE, G4,NE, A4,NE, F4,NE, A4,NQ, D5,NE, C5,NE,

	A4,NE, F4,NE, C4,NE, F4,NE, A3,NQ, A4,NE, G4,NE,
	A4,NE, F4,NE, C4,NE, F4,NE, A3,NQ, A4,NE, B4,NE,
	C5,NE, B4,NE, C5,NE, A4,NE, B4,NE, A4,NE, B4,NE, G4,NE,
	A4,NE, G4,NE, F4,NE, G4,NE, A4,NQ,

		32100 };


int	music2[] = { 	/* music for death of man */
	REST,NE, C4,6, C4,NQ, C4,NE, C4,6, DS4,NQ, D4,NE, D4,NQ, C4,NE, C4,NQ, B3,NE, C4,12,
	REST,NW, REST,NW, REST,NW, REST,NW, REST,NW, REST,NW, REST,NW, REST,NW, REST,NW, REST,NW, REST,NW, REST,NW, 
		32100 };




find_speed()
{
	int	flag;

	while (tick==0) {	/* wait for tick to be zero */
		flag=flag;
	}
	while (!(tick==0)) {	/* wait for tick to be not zero */
		flag=flag;
	}

	time_reg=0;
	timetemp=0;
	while (tick==timetemp) {	/* wait for tick to change */
		time_reg++;
		if (time_reg <= 0) break;
	}
	if (time_reg <= 0) time_reg = 32767;

	time_mul=time_reg/550;	/* adjustment for pulse width music */
	if(time_mul<1)
		time_mul=1;

	time_reg-=550;	/* adjust for PC speed */
	if(time_reg<1)
		time_reg=1;
}





time()
{

	if(sound && (!sound_on) ) {	/* if keyboard module flags sound on & it is not on in the program
					   then turn on in program */
		sound_on=TRUE;
		music=0xffff;	/* TRUE must not be used */
	}

	if(!sound && sound_on) {	/* if keyboard module flags sound off & it is on in the program
					   then turn off in program */
		sound_on=FALSE;
		set_tone(40);	/* set tone to a high freq - turning speaker off causes a clic */
		sn2_off();	/* turn off all sound */
	}

	if(sound_on && (!m_pause) ) {
		p_period=32000;	/* default for no sound */  
		t_period=40;
		if(music)	/* only play music when toggle is enabled */
			chk_music();     

		chk_2_coin();	/* second sound for coins */
		chk_loose();	/* sound for loose bags */
		chk_dead();	/* sound for dead man */
		chk_break();	/* sound for breaking bag */
		chk_money();	/* sound for getting money */
		chk_coin();	/* sound for man eating coin */
		chk_explode();	/* sound for missle explotion */
		chk_fire();	/* sound for missile fire */
		chk_bug();	/* sound for bug being eaten during bonus round */
		chk_fall();	/* sound for falling bags */
		chk_life();	/* sound when new life is given */
		chk_chase();	/* sound during bonus round change-over */

		if(p_period==32000 || t_period!=40) 
			sn2_off();	/* turn off second sound source */
		else {
			sn2_on();	/* turn on second sound source */
			sn2_new();	/* update sound */ 
		}
		set_sound(t_period); 

	}

}


tdelay()
{

	/* equilize system clock speed */

	timetemp=0;
	while (timetemp<time_reg) {	
		timetemp++;
		if (timetemp <= 0) break;
	}


}




init_th()	/* initialize sound */
{
	rst_fall();	/* turn of bag falling sound */	
	rst_loose();	/* turn off loose bag sound */
	rst_fire();	/* turn off missile sound */
	rst_music();	/* stop any background music */
	rst_chase();	/* stop sound for bonus round change-over */
	rst_explode();	/* sound for missle explotion */
	rst_break();	/* sound for bag breaking */
	rst_coin();	/* sound for coin being eaten */
	rst_2_coin();	/* second sound for coin being eaten */
	rst_money();	/* sound for money being grabbed */
	rst_bug();	/* sound for bug being eaten during bonus round */
	rst_dead();	/* sound for dead man */
	rst_life();	/* sound when new life is given */

}




rst_end()	/* sound for end of screen  */
{
	end_stat=FALSE;
	m_pause=FALSE;
}



snd_end()	/* sound for end of screen  - not interrupt driven */
{
	int	a;

	init_th();	/* turn off all other sounds */
	m_pause=TRUE;
	end_count=0;
	end_loop=20;
	end_stat=TRUE;
	while(end_stat) {
		if(tick!=a) {
			chk_end();
			a=tick;
		}
	}
}


chk_end()
{
	if(sound_on) {
		switch(end_count) {
		case 0:
			t_period=C5;
			break;
		case 1:
			t_period=E5;
			break;
		case 2:
			t_period=G5;
			break;
		case 3:
			t_period=D5;
			break;
		case 4:
			t_period=F5;
			break;
		case 5:
			t_period=A5;
			break;
		case 6:
			t_period=E5;
			break;
		case 7:
			t_period=G5;
			break;
		case 8:
			t_period=B5;
			break;
		case 9:
		case 10:
			t_period=C5/2;
			break;
		}


		p_period=t_period+35;
		p_width=50;

		sn2_on();
		sn2_new();
		set_sound(t_period);

		if(end_loop>0)
			end_loop--;
		else {
			end_loop=20;
			end_count++;
			if(end_count>10)
				rst_end();
		}
	}
	else {
		sleep(100);
		end_stat=FALSE;
	}
}


init_fall()
{
	fall_period=1000;
	fall_stat=TRUE;

}


rst_fall()
{
	fall_stat=FALSE;
	fall_num=0;
}



chk_fall()
{

	if(fall_stat) {	/* update if sound of fall is active */
		if(fall_num<1) {
			fall_num++;
			if(fall_toggle) {
				t_period=fall_period;
			}
		}
		else {
			fall_num=0;
			if(fall_toggle) {
				fall_period+=50;
				fall_toggle=FALSE;
			}
			else
				fall_toggle=TRUE;
		}

	}

}


snd_break()
{	/* sound for bag breaking */

	break_count=3;
	if(break_period<15000)
		break_period=15000;
	break_stat=TRUE;
}

rst_break()
{
	break_stat=FALSE;

}

chk_break()
{
	if(break_stat) {
		
		if(break_count) {
			break_count--;
			t_period=break_period;
		}
		else
			break_stat=FALSE;
	}
}



chk_loose()
{
	if(loose_stat) {
		loose_type++;
		if(loose_type>63)
			loose_type=0;

		switch(loose_type) {
		case 0:
			t_period=2000;
			break;
		case 16:
			t_period=2500;
			break;
		case 32:
			t_period=3000;
			break;
		case 48:
			t_period=2500;
			break;
		}

	}

}


init_loose()
{
	loose_stat=TRUE;

}

rst_loose()
{

	loose_stat=FALSE;
	loose_type=0;

}



init_fire()
{
	fire_freq=500;
	fire_stat=TRUE;

}

rst_fire()
{
	fire_stat=FALSE;
	fire_pause=0;
}

chk_fire()
{
	if(fire_stat) {
		if(fire_pause==1) {
			fire_pause=0;
			fire_freq+=fire_freq/55;
			t_period=fire_freq+rnd(fire_freq>>3);
			if(fire_freq>30000)
				rst_fire();
		}
		else
			fire_pause++;
	}
}

snd_explode()
{	/* sound for missle explotion */

	exp_period=1500;
	exp_count=10;
	exp_stat=TRUE;
	rst_fire();	/* end normal fire sound */
}

rst_explode()
{
	exp_stat=FALSE;

}

chk_explode()
{
	if(exp_stat) {
		if(exp_count) {
			exp_period-=(exp_period>>3);
			t_period=exp_period;
			exp_count--;
		}
		else
			exp_stat=FALSE;
	}

}




init_chase()
{

	chase_stat=TRUE;

}

rst_chase()
{
	chase_stat=FALSE;
	chase_count=0;
}

chk_chase()
{
	if(chase_stat) {
		chase_count++;
		if(chase_count>15)
			chase_count=0;

		switch(chase_count) {
		case 0:		
		case 1:		
		case 2:		
		case 3:		
		case 4:		
		case 5:		
			t_period=1230;
			break;
		case 8:		
		case 9:		
		case 10:		
		case 11:		
		case 12:		
		case 13:		
			t_period=1513;
			break;
		}

	}
}




rst_coin()
{	/* sound for man eating coins */
	coin_stat=FALSE;
}

snd_coin()
{
	coin_stat=TRUE;
}

chk_coin()
{
	if(coin_stat) {
		t_period=1000;
		rst_coin();
	}

}




rst_2_coin()
{	/* second sound for man eating coins */
	coin_2_stat=FALSE;
}

snd_2_coin(new_flag)
int	new_flag;
{
	if(new_flag) {
		switch(coin_2_period) {
		case C5:
			coin_2_period=D5;
			break;
		case D5:
			coin_2_period=E5;
			break;
		case E5:
			coin_2_period=F5;
			break;
		case F5:
			coin_2_period=G5;
			break;
		case G5:
			coin_2_period=A5;
			break;
		case A5:
			coin_2_period=B5;
			break;
		case B5:
			coin_2_period=C6;
			score_2_coin();	/* extra bonus for getting 8 sucessive coins */
			break;
		case C6:
			coin_2_period=C5;
			break;
		}
	}
	else
		coin_2_period=C5;

	coin_2_count=7;
	coin_2_type=0;
	coin_2_stat=TRUE;

}

chk_2_coin()
{
	if(coin_2_stat) {
		if(coin_2_count) {
			switch(coin_2_type) {
			case 0:
			case 1:
				t_period=coin_2_period;
				break;
			case 2:
			case 3:
			case 4:
			case 5:
			case 6:
			case 7:
				break;
			}

			coin_2_type++;
			if(coin_2_type>7) {
				coin_2_type=0;
				coin_2_count--;
			}

		}
		else
			rst_2_coin();	

	}

}



rst_money()
{	/* sound for money being grabbed */

	money_stat=FALSE;

}


snd_money()
{

	money_1=500;
	money_2=4000;
	money_count=30;
	money_toggle=FALSE;
	money_stat=TRUE;

}

chk_money()
{
	if(money_stat) {
		if(money_count)
			money_count--;
		else
			money_stat=FALSE;

		if(money_toggle) {
			money_toggle=FALSE;
			t_period=money_1;
		}
		else {
			money_toggle=TRUE;
			t_period=money_2;
		}

		money_1+=(money_1>>4);
		money_2-=(money_2>>4);
	}
}



rst_bug()
{	/* sound for bug being eaten during bonus round */
	
	bug_stat=FALSE;

}

snd_bug()
{

	bug_c_1=20;
	bug_c_2=3;
	bug_period=2000;
	bug_stat=TRUE;

}

chk_bug()
{

	if(bug_stat) {

		if(bug_c_2) {	/* loop for 3 sets of tones */

			if(bug_c_1) {
				if((bug_c_1 %4)==1)
					t_period=bug_period;
				if((bug_c_1 %4)==3)
					t_period=bug_period-(bug_period>>4); 
				bug_c_1--;
				bug_period-=(bug_period>>4);
			}
			else {
				bug_c_1=20;
				bug_c_2--;
				bug_period=2000;
			}
		}
		else
			bug_stat=FALSE;
	}
}



rst_dead()	/* sound for dead man */
{

	dead_stat=FALSE;

}

snd_dead()
{

	dead_count=0;
	dead_period=20000;
	dead_stat=TRUE;

}

chk_dead()
{
	if(dead_stat) {
		dead_count++;

		switch(dead_count) {
		case 1:
			rst_music();
			dead_period=19000;
			break;
		case 2:
			dead_period=18000;
			break;
		case 3:
			dead_period=17000;
			break;
		case 4:
			dead_period=16000;
			break;
		case 5:
			dead_period=15000;
			break;
		case 6:
			dead_period=14000;
			break;
		case 7:
			dead_period=13000;
			break;
		case 8:
			dead_period=12000;
			break;
		case 9:
			dead_period=11000;
			break;
		case 10:
			dead_period=10000;
			break;
		}

		if(dead_count>10)
			dead_period+=500;


		if(dead_period>30000)
			rst_dead();
	
       		t_period=dead_period;

	}
}


rst_life()	/* sound when new life is given */
{
	life_stat=FALSE;
}

snd_life()
{

	life_count=96;
	life_stat=TRUE;

}

chk_life()
{
	if(life_stat) {

		if((life_count/3)%2)
			t_period=600+(life_count<<2);
		life_count--;
		if(life_count<1)
			life_stat=FALSE;
	}

}




rst_music()
{
	m_stat=FALSE;
	m_pointer=0;
	
}


init_music(x)
int	x;
{
	m_type=x;
	m_count=0;
	m_pointer=0;

	switch(m_type) {
	case 0:	/* chase music */
		attack_level=50;
		attack_rate=20;
		hold_level=20;
		hold_rate=10;
		decay_rate=4;
		break;
	case 1:	/* normal man movement music */
		attack_level=50;
		attack_rate=50;
		hold_level=8;
		hold_rate=15;
		decay_rate=1;
		break;
	case 2:	/* man death music */
		attack_level=50;
		attack_rate=50;
		hold_level=25;
		hold_rate=5;
		decay_rate=1;
		break;
	}

	m_stat=TRUE;

	if(x==2)	/* death march */
		rst_dead();	/* turn off dead sound */

}


chk_music()
{
	if(m_stat) {	/* execute if music is active */

		if(m_count) {
			m_count--;
		}
		else {

			envelope=ATTACK;	/* set pointer for start of note envelope */
			env_position=0;

			switch(m_type) {
			case 0:	/* chase music */
				m_count=music0[m_pointer+1]*3;
				m_note=music0[m_pointer];
				hold_count=m_count-3;
				m_pointer+=2;
				if(music0[m_pointer]==32100)
					m_pointer=0;
				break;
			case 1:	/* normal man movement music */
				m_count=music1[m_pointer+1]*6;
				m_note=music1[m_pointer];
				hold_count=12;
				m_pointer+=2;
				if(music1[m_pointer]==32100)
					m_pointer=0;
				break;
			case 2:	/* man death music */
				m_count=music2[m_pointer+1]*10;
				m_note=music2[m_pointer];
				hold_count=m_count-10;
				m_pointer+=2;
				if(music2[m_pointer]==32100)
					m_pointer=0;
				break;
			}
		}

		env_position++;	/* position within envelope */
		sn2_mode=PULSE;	/* initialize to pulse mode */

		p_period=m_note;	/* set up tone value */

		if(env_position>=hold_count)
			envelope=DECAY;

		switch(envelope) {
		case ATTACK:
			if( (p_width+attack_rate) >= attack_level) {
				p_width=attack_level;
				envelope=HOLD;	/* move to next part of envelope */
			}
			else
				p_width+=attack_rate;
			break;
		case HOLD:
			if( (p_width-hold_rate)<=hold_level) 
				p_width=hold_level;
			else
				p_width-=hold_rate;
			break;
		case DECAY:
			if( (p_width-decay_rate)<=1)
				p_width=1;
			else
				p_width-=decay_rate;
			break;
		}

		if(p_width==1)
			p_period=32000;

	}

}






init_pause()
{	/* set up a pause to stop background music during keyboard hold */

	m_pause=TRUE;

}



rst_pause()
{
	m_pause=FALSE;

}


rst_sound()
{	/* turn off speaker port at end of game - used during developement */
	int	temp;

	temp=inp(PORT_B); 
	temp =temp & 0xfc & ~SPEAKER_ENABLE & ~TIMER_ENABLE;
	outp(PORT_B,temp);	/* turn off timer */

	outp(INTERUPT_PORT,0xff);
	outp(INTERUPT_PORT,0xff);

}


init_sound()
{	/* turn on speaker & start up the external 2 tone sound routine */
	int	temp;

	outp(TIMER_MODE,0xb6);	/* set timer mode */
	outp(TIMER_PORT,0x20);	/* initialize timer to a high freq. */
	outp(TIMER_PORT,0x0);

	temp=inp(PORT_B); 
	temp =temp & 0xfc | SPEAKER_ENABLE | TIMER_ENABLE;
	outp(PORT_B,temp);	/* turn on speaker */


	outp(TIMER_MODE,0x36);	/* speed up timer */
	outp(INTERUPT_PORT,0);
	outp(INTERUPT_PORT,0x80);

	sound_on=TRUE;	/* set sound on flag */
	sound2_on=FALSE;	/* Reset sound2 flag */
	sn2on=0;
	sn2_mode=SQUARE;	/* initialize to square wave mode */
	p_period=12000;
	p_width=8;
	t_period=40;	
	sn2_stat=ON;	/* needed to insure that sn2_off will turn off sound */
	sn2_off();	/* turn off all sound to begin */
	
	init_th();
	sn2_start();	/* initialize interupt sound */
	sound2=0xffff;
	outp(INTERUPT_PORT,0x4000 & 0xff);
	outp(INTERUPT_PORT,0x4000 >> 8);	

}


/* ***************************************************************************
   	interupt pulse sound routines
   ***************************************************************************
*/


sn2_new()	/* set new frequency for boath tone generators */
{
	int	temp;


	if(sound_on) {	/* only update if the sound is turned on */

		set_tone(t_period); 	/* set first tone generator */
		if(p_period<1000 && sn2_mode==SQUARE)	/* check maximum freq of interupts */
			p_period=1000;
		if(p_period<1000 && sn2_mode==PULSE)
			p_period=1000;

		outp(INTERUPT_PORT,p_period & 0xff);
		outp(INTERUPT_PORT,p_period >> 8);	
		if(p_period<16000)
			sound2=(p_period<<2);	/* set new tick counter value */
		else
			sound2=0xffff;

		if(p_width<1)
			p_width=1;
		if(p_width>50)
			p_width=50;
		per2=p_width*time_mul;
		sn2_on();	/* insure that sound is on */ 
	}

}


sn2_off()	/* turn off second sound source */
{
	int	temp;

	if(sn2_stat==ON) {	/* sound 2 is now on */
		sn2_stat=OFF;
		sn2on=0;
		temp=inp(PORT_B); 
		temp =temp & 0xfc | SPEAKER_ENABLE | TIMER_ENABLE;
		outp(PORT_B,temp);	/* turn on speaker */
	}
}

sn2_on()	/* turn on second sound source */
{
	int	temp;

/* for pulse wave - sn2on = 1
   for square wave - sn2on = 2 */

	sn2on=sn2_mode;	/* turn sound on with desired mode */	

	if(sn2_stat==OFF && sound_on) {	/* sound 2 is now off */
		sn2_stat=ON; 
		temp=inp(PORT_B); 
		temp =temp & 0xfc | SPEAKER_ENABLE | TIMER_ENABLE;
		outp(PORT_B,temp);	/* turn on speaker */
	}

}

sn2_start()	/* start up interupt sound source if it is not already on */
{
	if(!sound2_on) {
		sn2_init();
		sound2=0xffff;
		outp(INTERUPT_PORT,0x4000 & 0xff);
		outp(INTERUPT_PORT,0x4000 >> 8);	
		sound2_on=TRUE;
	}

}


sn2_stop()	/* stop interupt sound source if it is already on & stop sound source 1 */  
{
	int	temp;

	if(sound2_on) {
		sn2_rst();
		sound2_on=FALSE;
	}

	set_sound(40);	/* set to a high tone for no sound */

	temp=inp(PORT_B); 
	temp =temp & 0xfc | SPEAKER_ENABLE | TIMER_ENABLE;
	outp(PORT_B,temp);	/* turn on speaker */


	outp(TIMER_MODE,0x36);	/* speed up timer */
	outp(INTERUPT_PORT,0);
	outp(INTERUPT_PORT,0x80);

}



set_sound(period)	
{	/* if sound is on then set the timer to a value - used by high score sound routine ext. */

	if(sound_on) {
		outp(TIMER_PORT,period & 0xff);
		outp(TIMER_PORT,period >> 8);	
	}

}


set_tone(freq)
{	/* always sets the sound port - used within this task */
	outp(TIMER_PORT,freq & 0xff);
	outp(TIMER_PORT,freq >> 8);	

}

#define MAXARG 8		/* maximum command line arguments */

_main(line)
char *line;
{
	static int argc = 0;
	static char *argv[MAXARG];

	main(argc, argv);	/* call main function */
	_exit(0);
}

/* ************************************************************************** */
/* Matrix definitions for all levels of play */
/* ************************************************************************** */

char	mat_1[H_MAX][W_MAX] = {	{ 'S',' ',' ',' ','B',' ',' ',' ',' ',' ','H','H','H','H','S'},
				{ 'V',' ',' ','C','C',' ',' ','C',' ',' ','V',' ','B',' ',' '},
				{ 'V','B',' ','C','C',' ',' ','C',' ',' ','V',' ',' ',' ',' '},
				{ 'V',' ',' ','C','C','B',' ','C','B',' ','V',' ','C','C','C'},
				{ 'V',' ',' ','C','C',' ',' ','C',' ',' ','V',' ','C','C','C'},
				{ 'H','H',' ','C','C',' ',' ','C',' ',' ','V',' ','C','C','C'},
				{ ' ','V',' ',' ',' ',' ','B',' ','B',' ','V',' ',' ',' ',' '},
				{ ' ','H','H','H','H',' ',' ',' ',' ',' ','V',' ',' ',' ',' '},
				{ 'C',' ',' ',' ','V',' ',' ',' ',' ',' ','V',' ',' ',' ','C'},
				{ 'C','C',' ',' ','H','H','H','H','H','H','H',' ',' ','C','C'}
			};


char	mat_2[H_MAX][W_MAX] = {	{ 'S','H','H','H','H','H',' ',' ','B',' ','B',' ',' ','H','S'},
				{ ' ','C','C',' ',' ','V',' ',' ',' ',' ',' ',' ',' ','V',' '},
				{ ' ','C','C',' ',' ','V',' ','C','C','C','C','C',' ','V',' '},
				{ 'B','C','C','B',' ','V',' ','C','C','C','C','C',' ','V',' '},
				{ 'C','C','C','C',' ','V',' ',' ',' ',' ',' ',' ',' ','V',' '},
				{ 'C','C','C','C',' ','V',' ','B',' ',' ','H','H','H','H',' '},
				{ ' ','C','C',' ',' ','V',' ','C','C',' ','V',' ',' ',' ',' '},
				{ ' ','B','B',' ',' ','V','C','C','C','C','V',' ','C','C',' '},
				{ 'C',' ',' ',' ',' ','V',' ','C','C',' ','V',' ','C','C',' '},
				{ 'C','C',' ',' ',' ','H','H','H','H','H','H',' ',' ',' ',' '}
			};


char	mat_3[H_MAX][W_MAX] = {	{ 'S','H','H','H','H','B',' ','B',' ','B','H','H','H','H','S'},
				{ 'C','C',' ',' ','V',' ','C',' ','C',' ','V',' ','B','B',' '},
				{ 'C',' ',' ',' ','V',' ','C',' ','C',' ','V',' ','C','C',' '},
				{ ' ','B','B',' ','V',' ','C',' ','C',' ','V','C','C','C','C'},
				{ 'C','C','C','C','V',' ','C',' ','C',' ','V','C','C','C','C'},
				{ 'C','C','C','C','H','H','H','H','H','H','H',' ','C','C',' '},
				{ ' ','C','C',' ',' ','C',' ','V',' ','C',' ',' ','C','C',' '},
				{ ' ','C','C',' ',' ','C',' ','V',' ','C',' ',' ',' ',' ',' '},
				{ 'C',' ',' ',' ',' ','C',' ','V',' ','C',' ',' ',' ',' ','C'},
				{ 'C','C',' ',' ',' ','C',' ','H',' ','C',' ',' ',' ','C','C'}
			};


char	mat_4[H_MAX][W_MAX] = {	{ 'S','H','B','C','C','C','C','B','C','C','C','C','B','H','S'},
				{ 'C','V',' ',' ','C','C','C','C','C','C','C',' ',' ','V','C'},
				{ 'C','H','H','H',' ','C','C','C','C','C',' ','H','H','H','C'},
				{ 'C',' ',' ','V',' ',' ','C','C','C',' ',' ','V',' ',' ','C'},
				{ ' ',' ',' ','H','H','H',' ','C',' ','H','H','H',' ',' ',' '},
				{ ' ',' ','B',' ',' ','V',' ','B',' ','V',' ',' ','B',' ',' '},
				{ ' ',' ','C',' ',' ','V','C','C','C','V',' ',' ','C',' ',' '},
				{ ' ','C','C','C',' ','H','H','H','H','H',' ','C','C','C',' '},
				{ 'C','C','C','C','C',' ','C','V','C',' ','C','C','C','C','C'},
				{ 'C','C','C','C','C',' ','C','H','C',' ','C','C','C','C','C'}
			};


char	mat_5[H_MAX][W_MAX] = {	{ 'S','H','H','H','H','H','H','H','H','H','H','H','H','H','S'},
				{ 'V','B','C','C','C','C','B','V','C','C','C','C','C','C','V'},
				{ 'V','C','C','C','C','C','C','V',' ','C','C','B','C',' ','V'},
				{ 'V',' ','C','C','C','C',' ','V','C','C','B','C','C','C','V'},
				{ 'V','C','C','C','C','C','C','V',' ','C','C','C','C',' ','V'},
				{ 'V',' ','C','C','C','C',' ','V','B','C','C','C','C','C','V'},
				{ 'V','C','C','B','C','C','C','V',' ','C','C','C','C',' ','V'},
				{ 'V',' ','C','C','B','C',' ','V','C','C','C','C','C','C','V'},
				{ 'V','C','C','C','C','C','C','V','C','C','C','C','C','C','V'},
				{ 'H','H','H','H','H','H','H','H','H','H','H','H','H','H','H'}
			};


char	mat_6[H_MAX][W_MAX] = {	{ 'S','H','H','H','H','H','H','H','H','H','H','H','H','H','S'},
				{ 'V','C','B','C','C','V',' ','V',' ','V','C','C','B','C','V'},
				{ 'V','C','C','C',' ','V','B','V','B','V',' ','C','C','C','V'},
				{ 'V','C','C','C','H','H',' ','V',' ','H','H','C','C','C','V'},
				{ 'V','C','C',' ','V',' ','C','V','C',' ','V',' ','C','C','V'},
				{ 'V','C','C','H','H',' ','C','V','C',' ','H','H','C','C','V'},
				{ 'V','C',' ','V',' ','C','C','V','C','C',' ','V',' ','C','V'},
				{ 'V','C','H','H','B','C','C','V','C','C','B','H','H','C','V'},
				{ 'V','C','V','C','C','C','C','V','C','C','C','C','V','C','V'},
				{ 'H','H','H','H','H','H','H','H','H','H','H','H','H','H','H'}
			};


char	mat_7[H_MAX][W_MAX] = {	{ 'S','H','C','C','C','C','C','V','C','C','C','C','C','H','S'},
				{ ' ','V','C','B','C','B','C','V','C','B','C','B','C','V',' '},
				{ 'B','V','C','C','C','C','C','V','C','C','C','C','C','V','B'},
				{ 'C','H','H','C','C','C','C','V','C','C','C','C','H','H','C'},
				{ 'C','C','V',' ','C','C','C','V','C','C','C',' ','V','C','C'},
				{ 'C','C','H','H','H','C','C','V','C','C','H','H','H','C','C'},
				{ 'C','C','C','C','V',' ','C','V','C',' ','V','C','C','C','C'},
				{ 'C','C','C','C','H','H',' ','V',' ','H','H','C','C','C','C'},
				{ 'C','C','C','C','C','V',' ','V',' ','V','C','C','C','C','C'},
				{ 'C','C','C','C','C','H','H','H','H','H','C','C','C','C','C'}
			};


char	mat_8[H_MAX][W_MAX] = {	{ 'H','H','H','H','H','H','H','H','H','H','H','H','H','H','S'},
				{ 'V',' ','C','C','B','C','C','C','C','C','B','C','C',' ','V'},
				{ 'H','H','H','C','C','C','C','B','C','C','C','C','H','H','H'},
				{ 'V','B','V',' ','C','C','C','C','C','C','C',' ','V','B','V'},
				{ 'V','C','H','H','H','C','C','C','C','C','H','H','H','C','V'},
				{ 'V','C','C','B','V',' ','C','C','C',' ','V','B','C','C','V'},
				{ 'V','C','C','C','H','H','H','C','H','H','H','C','C','C','V'},
				{ 'V','C','C','C','C',' ','V',' ','V',' ','C','C','C','C','V'},
				{ 'V','C','C','C','C','C','V',' ','V','C','C','C','C','C','V'},
				{ 'H','H','H','H','H','H','H','H','H','H','H','H','H','H','H'}
			};



get_mat(x,y,lev)
int	x,y,lev;
{

	switch(lev) {
	case 1:
		return((int)mat_1[y][x]);
	case 2:
		return((int)mat_2[y][x]);
	case 3:
		return((int)mat_3[y][x]);
	case 4:
		return((int)mat_4[y][x]);
	case 5:
		return((int)mat_5[y][x]);
	case 6:
		return((int)mat_6[y][x]);
	case 7:
		return((int)mat_7[y][x]);
	case 8:
		return((int)mat_8[y][x]);
	}

}



/* *************************************************************************** */
/*	scan code to ascii & ascii to number convertions */
/* *************************************************************************** */

getval(chr)
char	chr;
{

	switch(chr) {
	case '1':
		return(1);
	case '2':
		return(2);
	case '3':
		return(3);
	case '4':
		return(4);
	case '5':
		return(5);
	case '6':
		return(6);
	case '7':
		return(7);
	case '8':
		return(8);
	case '9':
		return(9);
	default:
		return(0);
	}

}



conkey(chr)
char	chr;
{	/* convert the key scan code to the ascii equivelent */

	switch(chr) {
#ifdef	IBM
	case 0x1e:
		return('A');
	case 0x30:
		return('B');
	case 0x2e:
		return('C');
	case 0x20:
		return('D');
	case 0x12:
		return('E');
	case 0x21:
		return('F');
	case 0x22:
		return('G');
	case 0x23:
		return('H');
	case 0x17:
		return('I');
	case 0x24:
		return('J');
	case 0x25:
		return('K');
	case 0x26:
		return('L');
	case 0x32:
		return('M');
	case 0x31:
		return('N');
	case 0x18:
		return('O');
	case 0x19:
		return('P');
	case 0x10:
		return('Q');
	case 0x13:
		return('R');
	case 0x1f:
		return('S');
	case 0x14:
		return('T');
	case 0x16:
		return('U');
	case 0x2f:
		return('V');
	case 0x11:
		return('W');
	case 0x2d:
		return('X');
	case 0x15:
		return('Y');
	case 0x2c:
		return('Z');

	case 0x34:
		return('.');
	case 0x39:
		return(' ');

	case 0x0b:
		return('0');
	case 0x02:
		return('1');
	case 0x03:
		return('2');
	case 0x04:
		return('3');
	case 0x05:
		return('4');
	case 0x06:
		return('5');
	case 0x07:
		return('6');
	case 0x08:
		return('7');
	case 0x09:
		return('8');
	case 0x0a:
		return('9');
#endif
#ifdef	HYP
	case 46:
		return('A');
	case 65:
		return('B');
	case 63:
		return('C');
	case 48:
		return('D');
	case 33:
		return('E');
	case 49:
		return('F');
	case 50:
		return('G');
	case 51:
		return('H');
	case 38:
		return('I');
	case 52:
		return('J');
	case 53:
		return('K');
	case 54:
		return('L');
	case 67:
		return('M');
	case 66:
		return('N');
	case 39:
		return('O');
	case 40:
		return('P');
	case 31:
		return('Q');
	case 34:
		return('R');
	case 47:
		return('S');
	case 35:
		return('T');
	case 37:
		return('U');
	case 64:
		return('V');
	case 32:
		return('W');
	case 62:
		return('X');
	case 36:
		return('Y');
	case 61:
		return('Z');

	case 69:
		return('.');
	case 75:
		return(' ');

	case 24:
		return('0');
	case 15:
		return('1');
	case 16:
		return('2');
	case 17:
		return('3');
	case 18:
		return('4');
	case 19:
		return('5');
	case 20:
		return('6');
	case 21:
		return('7');
	case 22:
		return('8');
	case 23:
		return('9');
#endif
	default:
		return(0);
	}
}

int	table[] = { 14,13,7,6,5,4,3,2,1,12,11,10,9,8,15,0 };

int	game[2][4];


#define	DEATH		0
#define	LIVES		1
#define	LEVEL		2
#define	DONE_LEVEL	3

char	text[30];	/* text string used for high score ext */
int	player, num_players, new_round, new_player;
int	plot_count;




main()
{
	int	flag, demo_time, loop, x;

	med_res();
	palette(0); backgrnd(0);
	/*init_hi_scores();*/
	kb_init(); init_joy();
	init_sound();
	num_players=1;

	clear(0);
	med_txt("Wait, initializing...",5,5,7);

	/* determine system clock speed */
	find_speed();

	clear(0);

	while(TRUE) {	/* continuous loop for game */
		init_th();	/* turn off sounds */
		sp_table(table);
		init_images();
		init_joy();
/* demo - title page display */
		clear(0);
		gentitle();  
		line(280,199,319,199,0);
		prints("D I G G E R",100,0,3);
		show_players();
		show_scores();
		demo_time=0;
		endgame=FALSE;		
		flag=FALSE;
		while(!flag) {

			/* exit demo if a key has been pressed */
			flag=start_wait();

			/* ESC: end game */
			if(endgame) {
				_exit(0);
			}

			/* clear demo area of screen */
			if(demo_time==0) {
				for(loop=54; loop<174; loop+=12)
					prints("            ",164,loop,0);
				demo_time = 50;
			}

			/* bring on first bug */
			if(demo_time==50) {
				sp_place(8,292,63);	/* place normal bug */
				x=292; 	/* set up starting position */	
			}
			if(demo_time>50 && demo_time<=77) {
				x-=4;
				draw_bug(0,NORMAL,LEFT,x,63);
			}
			if(demo_time>77)
				draw_bug(0,NORMAL,RIGHT,184,63);
			if(demo_time==83)
				prints("NOBBIN",216,64,RED);


			/* bring on second bug */
			if(demo_time==90) {
				sp_place(9,292,82);
				draw_bug(1,ADVANCING,LEFT,292,82);
				x=292; 	/* set up starting position */	
			}
			if(demo_time>90 && demo_time<=117) {
				x-=4;
				draw_bug(1,ADVANCING,LEFT,x,82);
			}
			if(demo_time>117) 
				draw_bug(1,ADVANCING,RIGHT,184,82);

			if(demo_time==123)
				prints("HOBBIN",216,83,RED);

			/* bring on digger */
			if(demo_time==130) {
				sp_place(0,292,101);
				draw_man(LEFT,292,101,TRUE);
				x=292; 	/* set up starting position */	
			}
			if(demo_time>130 && demo_time<=157) {
				x-=4;
				draw_man(LEFT,x,101,TRUE);
			}
			if(demo_time>157)
				draw_man(RIGHT,184,101,TRUE);
			if(demo_time==163)
				prints("DIGGER",216,102,RED);

			/* start bag display */
			if(demo_time==178) {
				sp_place(1,184,120);
				draw_bag(1,BAG_0,184,120);
			}
			if(demo_time==183) {
				prints("GOLD",216,121,RED);
			}

			/* start emerald display */
			if(demo_time==198) {
				put_coin(184,141);
			}
			if(demo_time==203) {
				prints("EMERALD",216,140,RED);
			}

			/* start bonus display */
			if(demo_time==218) {
				draw_bonus(184,158);
			}
			if(demo_time==223) {
				prints("BONUS",216,159,RED);
			}

			/* increment counter with wrap around */
			demo_time++;
			if(demo_time>250)
				demo_time=0;

			
			for(loop=0; loop<45; loop++) {
				sleep(1);
				if(keychr && !(keychr & 0x80)) {
					break;
				}
			}

		}


/* set up player 0 variables */
		game[0][LEVEL]=1; game[0][LIVES]=3;

/* set up player 1 variables if being used */
		if(num_players==2) {
			game[1][LEVEL]=1; game[1][LIVES]=3;
		}
		else
			game[1][LIVES]=0;

/* initialize all tasks for boath players */
		clear(0);	/* clear screen */

		player=0;	
		init_level();
		player=1;
		init_level();

		rst_scores();	/* reset scores for this round */

		new_round=TRUE;	/* screen is redrawn if new_round=TRUE */
		if(num_players==2)
			new_player=TRUE;	/* player up message at top of screen is displayed if new_player=TRUE */
		player=0;	/* start with first player */

		while(game[0][LIVES] || game[1][LIVES]) {	/* loop untill boath players are dead */
	
			game[player][DEATH]=FALSE;

			while(!game[player][DEATH] && game[player][LIVES]) {
				rst_images();	/* restore origional images */
				play_round();	/* do game untill player dies */
       			}


			if(player==0) {
				if(game[1][LIVES]) {	/* check if other player is still alive */
					new_player=TRUE;
					new_round=TRUE;
					player=1;
				}
			}
			else {
				if(game[0][LIVES]) {	/* check if player 0 is still alive */
					new_player=TRUE;
					new_round=TRUE;
					player=0;
				}
			}

		}

	}

}


med_txt(string,x,y,color)
int	x,y,color;
char	*string;
{

	int	n=0;

	ttyrst(y,x);

	while(string[n]) {
		ttywrt(string[n++],color);
	}
}



play_round()
{
	int	loop;


	if(new_round) {	/* redraw screen if players have changed or first play */
		new_round=FALSE;
		start_level();	/* redraw screen */
		if(new_player) {
			new_player=FALSE;
			strcpy(text,"PLAYER ");	/* set up string */
			if(player==0)
				strcat(text,"1");
			else
				strcat(text,"2");
			blank_top();	/* clear top of screen */

			for(loop=0; loop<15; loop++) {
				prints(text,108,0,1);
				flash_score(1);
				sleep(20);
				prints(text,108,0,2);
				flash_score(2);
				sleep(20);
				prints(text,108,0,3);
				flash_score(3);
				sleep(20);
			}
			print_present_score();	/* display boath players score in brown */
			add_score(0);
		}
	}
	else
		restart_level();

	keychr=0;	/* clear keyboard */ 
	prints("        ",108,0,3); 
	init_tf();	/* print scores */
	print_lives();	/* show lives left */
	init_music(1);	/* start regular music */
	joystk();	/* clear any old keyboard charaters before beginning */
	while(!game[player][DEATH] && !game[player][DONE_LEVEL]) {			

		plot_count=0;
		task_c();	/* move man */
		
		task_a();	/* move bugs */ 
		
		task_b();	/* check for money bag movement */
		
		if(plot_count<8) {	/* delay for constant speed */
			for(loop=(8-plot_count)*5; loop>0; loop--)
				sleep(1);
		}

		if(plot_count>8)	/* extra delay for very heavy movement times */
			delay_bugs(plot_count-8);

		if (exit_check())
		{
			end_tc();	/* erase old man */
			rst_music();	/* end background music */
			init_th();	/* end all sounds */
			era_missile();	/* remove any missiles left on screen */
			game[0][DEATH] = 1;
			game[0][LIVES] = 0;
			era_bonus();	/* erase any bonus markers */
			end_tb();
			end_tg();
			end_ta();	/* erase bugs */
			check_hi_score();
			return;
		}
                        	
		done_check();	/* see if all coins are eaten */
	}
	end_tc();	/* erase old man */
	rst_music();	/* end background music */

	loop=20;	/* allows some movement to finish sound effects */
	while(get_moving_bags() || loop) {
		if(loop)
			loop--;
		plot_count=0;
		task_b(); 	/* allow bags to fall */
		task_c();	/* move any missiles */		
		task_a();	/* keep bugs moving */
		
		if(plot_count<8) {	/* delay for constant speed */
			for(loop=(8-plot_count)*5; loop>0; loop--)
				sleep(1);
		}
	}


	init_th();	/* end all sounds */
	era_missile();	/* remove any missiles left on screen */

	era_bonus();	/* erase any bonus markers */
	end_tb();
	end_tg();
	end_ta();	/* erase bugs */

	if(game[player][DONE_LEVEL])
		snd_end();	/* sound for end of screen */

	if(count_coins()==0) {	/* initialize level now so that coins destroyed by mans death alse result
				   in advancing to the next level */
		game[player][LEVEL]++;	/* advance to next level */
		if(game[player][LEVEL]>1000)
			game[player][LEVEL]=1000;
		init_level();  
	}


#ifdef	FREEDEMO

	if(game[player][LEVEL]>2) {
		game[player][LIVES]=0;
		check_hi_score();
	}
#endif

		
	if(game[player][DEATH]) {
		game[player][LIVES]--;
		print_lives();	/* update display */
		if(game[player][LIVES]<1)
			check_hi_score();

	}

	if(game[player][DONE_LEVEL]) {
		game[player][LEVEL]++;	/* advance to next level */
		if(game[player][LEVEL]>1000)
			game[player][LEVEL]=1000;
		init_level();  
	}

}


toggle_players()
{

	if(num_players==1)
		num_players=2;
	else
		num_players=1;

}


init_level()
{
	game[player][DONE_LEVEL]=FALSE;
	init_tg();
	init_td();
	init_tb();
	new_round=TRUE;	/* screen must be redrawn */
}



start_level()
{
	init_images();	/* redefine all sprites as inactive with origional shapes */
	start_tg();	/* draw background */
	start_tb();	/* draw money bags */
	start_td();	/* draw coins */
	init_tc();	/* draw man in starting position */
	init_ta();	/* create first bug */
}


restart_level()
{
	rst_images();	/* redefine sprites with origional shapes */
	init_tc();	/* draw man in starting position */
	init_ta();	/* create first bug */
}



done_check()
{
/* check if coins are eaten or all bugs are dead & man is not in the process of dying */
	if((count_coins()==0 || bugs_left()==0) && get_m_status() )
		game[player][DONE_LEVEL]=TRUE;
	else
		game[player][DONE_LEVEL]=FALSE;

}


inc_plot()
{	/* counter for # of screen plotd per loop of game */
	plot_count++;
	
}




blank_top()
{
	prints("                          ",0,0,3);
	prints(" ",308,0,3);

}


get_screen()
{	/* return a screen value 1 - 8  if level is greater than 8 then use levels 5-8 over */
	int	temp;

	temp=get_level();
	if(temp>8) {
		temp= temp%4;
		temp+=5;
	}

	return(temp);

}

get_dificulty()
{	/* levels of dificulty range from 1 - 10 */

	if(game[player][LEVEL]>10)
		return(10);
	else
		return(game[player][LEVEL]);

}


get_level()
{
	return(game[player][LEVEL]);
}



make_level(x)
{
	game[player][LEVEL]=x;

}


get_lives(num)
{
	if(num==1)
		return(game[0][LIVES]);
	else
		return(game[1][LIVES]);


}


add_life(num)
int	num;
{
	if(num==1)
		game[0][LIVES]++;
	else
		game[1][LIVES]++;

	snd_life();	/* sound for new life */
}



make_dead(status)
int	status;
{
	game[player][DEATH]=status;

}


get_player()
{
	return(player);

}

players()
{

	return(num_players);

}


exit_check()
{	/* check for a hold condition - also exit to dos during debug */
	int	a;

	a = endgame;
	endgame = 0;
	return a;

#if 0
	if(endgame) {	/*	removed for sale vertion  */
		rst_sound();
		kb_rst();  
		sn2_stop();
		_exit();
	}
#endif

#if 0
	if(keychr==57 || keychr==185) {	/* check for a hold condition */
		init_pause();	/* turn off background music */
		set_sound(40);	/* turn off sound */ 
		sn2_off();
		blank_top();	/* erase top line */
		prints("PRESS ANY KEY",80,0,GREEN);	/* display message at top of screen */
		while(keychr==57)	/* hold game while pressing space key */
			a=a;
		while(keychr & 0x80)	/* hold game while last character was a key up */
			a=a;
		blank_top();
		print_present_score();	/* reprint top status line */
		add_score(0);	/* change color of present players score */
		print_lives();
		sleep(200);	/* delay for keyboard debounce */
		keychr=0;	/* reset key incase game was restarted with a space key */
	}
	else
		rst_pause();	/* turn on background music */
#endif
}

