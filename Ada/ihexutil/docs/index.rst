.. ihexutil documentation master file, created by
   sphinx-quickstart on Mon Dec 26 15:34:34 2016.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

.. toctree::
   :maxdepth: 2
   :caption: Contents:



ihexutil - Intel Hex binary utility
===================================

**Usage**

ihexutil [flags] [hexfile(s)]


=====    =========
flag     usage
=====    =========
-h       help
-v       verbose
-s       show. simply display the hex binary data in hex and ascii form
-x       generate the checksum of the provided text (in hexadecimal format)
-a       add a computed CRC value at the address specified
-c       mcu spec
-o       output hex file. this is required if a CRC is requested
-f       find the provided argument in the hexfile
-d       this requires 2 hexfiles as arguments. display the difference
=====    =========