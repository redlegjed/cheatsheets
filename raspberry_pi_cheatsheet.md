Raspberry Pi cheatsheet
==========================

A collection of useful tips for R-Pi

GPIO pin overlay
-----------------

(Link to github site)[https://github.com/splitbrain/rpibplusleaf]


SPI interface
------------------

From Python using spidev library

    # Example using MCP3008 8 channel/10bit Analogue to Digital converter

    # Create SPI object
    spi = spidev.SpiDev()

    # Open connection to SPI bus 0, device 0
    # device 0 corresponds to GPIO 8 (CE0)
    # 1 is GPIO 7 (CE1).
    # Standard R-PI can only connect to two devices
    spi.open(0,0)

    # Set speed, any speed lower than this works
    # higher speeds affect the value returned for
    # the ADC
    spi.max_speed_hz=1953000

    # MCP3008 command for reading channel 7
    # 3 bytes
    # Byte 0 = |0|0|0|0|0|0|0|1
    # Byte 1 = |Single/differential|D2|D1|D0|0|0|0|0
    # Byte 2 = 0
    #
    # Single/Differential : 1 = single, 0 = Differential
    # |D2|D1|D0| = channel number in binary
    cmd = [0x01,0b11110000,0]
    spi.xfer(cmd)

    # Output is returned in cmd as 3 bytes
    # e.g. [0,1,14]
    print(cmd)

    # Value returned in cmd
    # Byte 0 = Don't care, no useful data, usually 0
    # Byte 1 = |0|0|0|0|0|0|B9|B8|
    # Byte 2 = |B7|B6|B5|B4|B3|B2|B1|B0|
    # Where B0-9 is the 10bit ADC value
    #
    # The decimal value can be obtained by shifting
    # byte 1 by 8 places and then adding to byte 2
    # e.g.
    # (cmd[1]<<8) + cmd[2]

    # Close connection
    spi.close()


