# ihexutil
## Intel Hex binary file utility

This is command line utility to parse, analyze and compare intel hex files

Several ROM models are supported:
* MSC1210
* DSP - F2810

### Usage:
Switch | Long Switch | Description
-------|-------------|------------
-h | --help | print the usage
-v | --verbose | Output extra verbose information
-a | --add-crc ARG | Add computed CRC at address specified
-o | --output ARG | Output file name
-m | --compare ARG | Compare with the hex file
 -x | --hexline ARG | Compute checksum for the hexline
 -c | --mcu-spec ARG | MCU name and type e.g. PMD:f2810 or AHP:msc1210

