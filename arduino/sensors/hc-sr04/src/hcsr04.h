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
 */
#ifndef HCSR04_H
#define HCSR04_H

#include "pico/stdlib.h"
#include "hardware/pio.h"

// class that sets up and reads the HCSR04
// The HCSR04 works by giving it a 10 us pulse on its Trigger pin
// The distance to an object is represented by the length of the pulse on its Echo pin
class HCSR04
{
public:
    // constructor
    // input = pin connected to the 'Echo' pin of the HCSR04.
    // ! NOTE: USE A VOLTAGE DIVIDER FOR THE INPUT (i.e. the Echo pin of the HCSR04)
    //         to go from 5V (which is needed by the HCSR04 module) to 3.3V
    // output = pin connected to the 'Trig' pin of the HCSR04.
    HCSR04(uint input, uint output);
    // read the distance to an object in cm (0 cm means invalid measurement)
    float read(void);

private:
    // the pio instance
    PIO pio;
    // the state machine
    uint sm;
};

#endif // HCSR04_H
