# Raspberry Pi cheatsheet


A collection of useful tips for R-Pi

- [Raspberry Pi cheatsheet](#raspberry-pi-cheatsheet)
  - [GPIO pin overlay](#gpio-pin-overlay)
  - [SPI interface](#spi-interface)
  - [Automatically start programs on boot](#automatically-start-programs-on-boot)
    - [Step 1– Create A Unit File](#step-1-create-a-unit-file)
    - [Step 2 – Configure systemd](#step-2--configure-systemd)
  - [Setting up wireless Access Point or Hotspot](#setting-up-wireless-access-point-or-hotspot)
  - [Useful links](#useful-links)
  - [Log of terminal commands](#log-of-terminal-commands)

## Get Raspbian version

    cat /etc/os-release
    
  
## GPIO pin overlay


[Link to github site](https://github.com/splitbrain/rpibplusleaf)


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

Link to [Raspberry Pi SPI info](https://www.raspberrypi.org/documentation/hardware/raspberrypi/spi/README.md)
    

## Automatically start programs on boot


See [Dexter Industries help](https://www.dexterindustries.com/howto/run-a-program-on-your-raspberry-pi-at-startup/)

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
    ExecStart=/usr/bin/python3 /home/pi/sample.py

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


## Setting up wireless Access Point or Hotspot

## Useful links

* [Raspberry Pi foundation docs](https://www.raspberrypi.org/documentation/configuration/wireless/access-point.md)
* [Quick method](https://howtoraspberrypi.com/create-a-wi-fi-hotspot-in-less-than-10-minutes-with-pi-raspberry/)
* [Github page for GUI interface](https://github.com/billz/raspap-webgui)

Notes
* The configuration from R-Pi foundation is long and error prone and I've never got it to work successfully.
* The Quick method seems to work, although I can't find the GUI.

## Log of terminal commands
Based on [Raspberry Pi foundation docs](https://www.raspberrypi.org/documentation/configuration/wireless/access-point.md)

Backup the following files:

    sudo mv /etc/dhcpcd.conf /etc/dhcpcd.conf.orig
    sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
    sudo mv /etc/default/hostapd /etc/default/hostapd.orig
    sudo mv /etc/sysctl.conf /etc/sysctl.conf.orig
    sudo cp /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf.orig

Note: restoring these files seems to undo the hotspot setup and get you back to the normal network again.



Load the required packages:

    sudo apt install dnsmasq hostapd

Stop the install packages from running

    sudo systemctl stop dnsmasq
    sudo systemctl stop hostapd


Configure IP address of network

    sudo nano /etc/dhcpcd.conf

Add this to end of file

    interface wlan0
    static ip_address=192.168.4.1/24
    nohook wpa_supplicant

Restart dhcpd daemon

    sudo service dhcpcd restart

Configure DHCPD server. **Make a new dnsmasq.conf file**

    sudo nano /etc/dnsmasq.conf

Add this

    interface=wlan0  # Use the required wireless interface - usually wlan0
    dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h


Reload dnsmasq to use the updated configuration:

    sudo systemctl reload dnsmasq

Configuring the access point host software (hostapd)

    sudo nano /etc/hostapd/hostapd.conf
    # File is initially empty

Add this

    interface=wlan0
    driver=nl80211
    ssid=NameOfNetwork
    hw_mode=g
    channel=7
    wmm_enabled=0
    macaddr_acl=0
    auth_algs=1
    ignore_broadcast_ssid=0
    wpa=2
    wpa_passphrase=PutPassPhraseHere
    wpa_key_mgmt=WPA-PSK
    wpa_pairwise=TKIP
    rsn_pairwise=CCMP

We now need to tell the system where to find this configuration file.

    sudo nano /etc/default/hostapd

Find the line with #DAEMON_CONF, and replace it with this:

    DAEMON_CONF="/etc/hostapd/hostapd.conf"


Start it up
Now enable and start hostapd:

    sudo systemctl unmask hostapd
    sudo systemctl enable hostapd
    sudo systemctl start hostapd

Do a quick check of their status to ensure they are active and running:

    sudo systemctl status hostapd
    sudo systemctl status dnsmasq


Add routing and masquerade

Edit /etc/sysctl.conf and uncomment this line:

    net.ipv4.ip_forward=1

Add a masquerade for outbound traffic on eth0:

    sudo iptables -t nat -A  POSTROUTING -o eth0 -j MASQUERADE

Save the iptables rule.

    sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

Edit /etc/rc.local and add this just above "exit 0" to install these rules on boot.

    iptables-restore < /etc/iptables.ipv4.nat

Reboot

Finally connec to pi

    ssh pi@192.168.4.1
