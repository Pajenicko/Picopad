/**
 * MIT License
 *
 * Copyright (c) 2021 GitJer
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 * https://github.com/GitJer/Some_RPI-Pico_stuff/tree/main/HCSR04
 *
 * int main()
 * {
 *     // needed for printf
 *     stdio_init_all();
 *     // the instance of the HCSR04 (Echo pin = 14, Trig pin = 15)
 *     HCSR04 my_HCSR04(14, 15);
 *     // infinite loop to print distance measurements
 *     while (true)
 *     {
 *         // read the distance sensor and print the result
 *         float cm = my_HCSR04.read();
 *         printf("cm = %f\n", cm);
 *         sleep_ms(100);
 *     }
 * }
 */

#include "hcsr04.h"
#include "hcsr04.pio.h"

// constructor
HCSR04::HCSR04(uint input, uint output)
{
    // pio 0 is used
    pio = pio0;
    // state machine 0
    sm = 0;
    // configure the used pins
    pio_gpio_init(pio, input);
    pio_gpio_init(pio, output);
    // load the pio program into the pio memory
    uint offset = pio_add_program(pio, &HCSR04_program);
    // make a sm config
    pio_sm_config c = HCSR04_program_get_default_config(offset);
    // set the 'in' pins, also used for 'wait'
    sm_config_set_in_pins(&c, input);
    // set the 'jmp' pin
    sm_config_set_jmp_pin(&c, input);
    // set the output pin to output
    pio_sm_set_consecutive_pindirs(pio, sm, output, 1, true);
    // set the 'set' pins
    sm_config_set_set_pins(&c, output, 1);
    // set shift direction
    sm_config_set_in_shift(&c, false, false, 0);
    // init the pio sm with the config
    pio_sm_init(pio, sm, offset, &c);
    // enable the sm
    pio_sm_set_enabled(pio, sm, true);
}

// read the distance to an object in cm (0 cm means invalid measurement)
float HCSR04::read()
{
    // value is used to read from the sm RX FIFO
    uint32_t clock_cycles = 0;
    // clear the FIFO: do a new measurement
    pio_sm_clear_fifos(pio, sm);
    // give the sm some time to do a measurement and place it in the FIFO
    sleep_ms(100);
    // check that the FIFO isn't empty
    if (pio_sm_is_rx_fifo_empty(pio, sm))
    {
        return 0;
    }
    // read one data item from the FIFO
    // Note: every test for the end of the echo puls takes 2 pio clock ticks,
    //       but changes the 'timer' by only one
    clock_cycles = 2 * pio_sm_get(pio, sm);
    // using
    // - the time for 1 pio clock tick (1/125000000 s)
    // - speed of sound in air is about 340 m/s
    // - the sound travels from the HCSR04 to the object and back (twice the distance)
    // we can calculate the distance in cm by multiplying with 0.000136
    float cm = (float)clock_cycles * 0.000136f;
    return (cm);
}
