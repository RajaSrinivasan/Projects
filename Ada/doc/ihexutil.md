# ihexutil
## Intel Hex binary file utility

This is command line utility to parse, analyze and compare intel hex files (https://en.wikipedia.org/wiki/Intel_HEX)

Several ROM models are supported:
* MSC1210
* DSP - F2810

### Usage:

> Usage: ihexutil [switches] [arguments]

Switch | Long Switch | Description
-------|-------------|------------
-h | --help | print the usage
-v | --verbose | Output extra verbose information
-s | --show | Show the contents of the hex file
-a | --add-crc ARG | Add computed CRC at address specified
-o | --output ARG | Output file name
-m | --compare ARG | Compare with the hex file
-x | --hexline ARG | Compute checksum for the hexline
-c | --mcu-spec ARG | MCU name and type e.g. PMD:f2810 or AHP:msc1210

