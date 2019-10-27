# Raspberry Pi cheatsheet


A collection of useful tips for R-Pi

- [Raspberry Pi cheatsheet](#raspberry-pi-cheatsheet)
  - [GPIO pin overlay](#gpio-pin-overlay)
  - [SPI interface](#spi-interface)
  - [Automatically start programs on boot](#automatically-start-programs-on-boot)
    - [Step 1– Create A Unit File](#step-1-create-a-unit-file)
    - [Step 2 – Configure systemd](#step-2--configure-systemd)

## GPIO pin overlay


(Link to github site)[https://github.com/splitbrain/rpibplusleaf]


## SPI interface


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

Link to (Raspberry Pi SPI info)[https://www.raspberrypi.org/documentation/hardware/raspberrypi/spi/README.md]
    

## Automatically start programs on boot


See (Dexter Industries help)[https://www.dexterindustries.com/howto/run-a-program-on-your-raspberry-pi-at-startup/]

The preferred method is to use *systemd*

### Step 1– Create A Unit File

Open a sample unit file using the command as shown below:


    sudo nano /lib/systemd/system/sample.service

Add in the following text :

    [Unit]
    Description=My Sample Service
    After=multi-user.target

    [Service]
    Type=idle
    ExecStart=/usr/bin/python /home/pi/sample.py

    [Install]
    WantedBy=multi-user.target


The permission on the unit file needs to be set to 644 :

    sudo chmod 644 /lib/systemd/system/sample.service

### Step 2 – Configure systemd

Now the unit file has been defined we can tell systemd to start it during the boot sequence :

    sudo systemctl daemon-reload
    sudo systemctl enable sample.service

Reboot the Pi and your custom service should run:

    sudo reboot

Check the status of the service using

    sudo systemctl status sample.service