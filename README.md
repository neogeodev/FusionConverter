# FusionConverter

![Fusion converter](photo.jpg)

Ready to use unbranded PCB GERBERs, BOM, Verilog and bitstream files.

Compatibility list: https://wiki.neogeodev.org/index.php?title=Fusion_converter

How to build:

* Order both PCBs with the following options: 2-layers 1.6mm thickness FR4, ENIG or hard gold fingers, edge bevelling.
* Order the components listed in `BOM.txt`. If you don't want the voltage supervision function, leave out CHA U3, R1 and D1.
* Bend the card edge connectors pins inwards to reduce their spacing and slide the boards between the rows.
* Solder everything.
* Program the CPLD with fusion_vsense.jed. JTAG connections: see `JTAG.png`. The board MUST be powered externally during programming, the programming cable doesn't provide power.
* Wire the "RESET" pads on both boards together with a small wire.
* Use 8 screws and 4 standoffs to join both boards together.

The shell is optional. It can be printed with any method (FDM, SLA...)

# Note to JGO

* You went through the trouble of cloning an open-hardware project when you could just have used these files.
* You're not respecting the license.
* If you cloned a device without paying attention to its open-source nature, that means you would also clone closed-source devices without caring.

From all the people who create things and share them for free: Fuck you.
