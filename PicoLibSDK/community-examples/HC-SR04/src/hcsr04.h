#ifndef HCSR04_H
#define HCSR04_H

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
