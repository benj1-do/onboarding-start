## How it works

The SPI controller sends signals (COPI, SCLK, nCS) to the SPI peripheral through ui_in[2:0]. On reset, every register is driven to the default value as given in the design (usually zero). Metastability is prevented through passing the signals sent by the controller through two flip flops. 

The SPI peripheral waits until a negative nCS edge is detected, which in this case is detecting whether the two oldest nCS signals stored are 1 and 0 respectively. This edge detection is also similarily used for SCLK (where posedge is detected if the two oldest signals are 0 and 1 respectively). Upon receiving an nCS negedge, the bit counter (which keeps track of how many bits are read in the transaction) and transaction data are reset. While the nCS is driven down, on every SCLK posedge, the data is shifted in, counting every bit until 16 bits are read. Upon completion, the data is sent to the pwm module. 

The PWM module outputs a signal depending on the duty cycle specified in the SPI peripheral. 
## How to test

The SPI peripheral is tested through cocotb, where different data is sent to different addresses (including invalid ones).
The PWM peripheral is also tested through cocotb, where different duty cycles are tested for their outputs.

## External hardware
None used
