MORSE CODE CONVERTER
by Altug Karakurt, Fall 2013

I implemented this project for the Digital Design course of my university. This
code was implemented for a Digilent BASYS2 board. So, if you are considering to
re-use it, you should check the ucf file to make sure it fits your FPGA's
architecture.

The circuit consists of 3 modules; PS/2 interface, clock divider and the main 
output generation module. The most challenging part for this implementation 
was, by far the PS/2 keyboard interfacing. The code for this part is based 
on a complicated finite state machine, which is found online* and the code was 
adapted that design. The contribution of the mentioned tutorial was extremely 
helpful for this project, so if you are doing anything related to PS/2 keyboard 
interfacing, go check it out.

The short description of the modules;
- clkdiv is the clock divider module. It simply divides the 50MHz internal clock
of the  FPGA to 2 and generates a 25 MHZ clock. I am notreally sure this task is
mandatory, but in order to be synchronised with PS/2's 25 KHz data clock, I implemented
this at some point of the project. The removal of this module may be considered.

- ps2con is the the PS/2 interfacing module. As mentioned, the code is based on somebody
else's design and code. So, I suggest you to check his tutorial for a better, more detailed
walkthrough. Please note that, the output of this module is the scan code of the pressed
button, not the corresponding ASCII code. The scan code reference can be found at Digilent's
website and possibly in many more areas. Scan Codes are the decoding standard of PS/2 systems 
that is unique for each key to distinguish. 

- pulse_conv is the brain of the project. It reads the input from PS/2 keyboard and by using the
gigantic internal Look-up Table, it matches the characters with corresponding output sequences.
The output is chosen to be obeying the universal standards of morse code, which is 3 units of time
for line and 1 unit of time for dot. In this code, any number and non-alphanumeric key is simply
ignored. The output clock is fed by the clk_div. I do not remember the frequency I have chosen,
but it is definitely arbitrary, one can experiment to choose the best frequency for himself. 

For any questions please feel free to poke my mailbox. This code is provided to the open source
community. You can do whatever you want with it. Copy, paste, distribute, modify, you have my whole
permission. Please do such contributions to open source community, yourself.

*LBEBooks Online Tutorials - http://www.youtube.com/watch?v=EtJBqvk1ZZw