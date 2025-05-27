<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

SPI-controlled PWM peripheral that uses SPI at 100 KHz to configure registers that control output enables, PWM enables, and duty cycles. 

Register Map: Address (Reset = 0x00)

en_reg_out_7_0: 0x00
en_reg_out_15_8: 0x01
en_reg_pwm_7_0: 0x02
en_reg_pwm_15_8: 0x03
pwm_duty_cycle: 0x04

Features: 
- samples data on posedge sclk, valid on negedge sclk
- Only writes
- cdc synchronized by 2-stage flip flop to prevent metastability
- has fixed 16 clock cycle / transaction
    - 1 Read/write bit
    - 7 address bits
    - 8 data bits

## How to test

PWM testbench
- test duty cycle from 0x00 to 0xFF
- test output enable and its link with pwm enable registers
- verify frequency (~ 3 kHz)
- verify pwm duty

## External hardware

List external hardware used in your project (e.g. PMOD, LED display, etc), if any
