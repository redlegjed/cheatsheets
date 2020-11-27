Linux cheatsheets
====================

Remove directory and all files in it
----------------------------------------

    rm -r dir_name


Adding HP printers
---------------------
See [https://developers.hp.com/hp-linux-imaging-and-printing/howtos/install]

Check for a package called hplip

    dpkg -l hplip
    
Get this output

    Desired=Unknown/Install/Remove/Purge/Hold
    | Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
    |/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
    ||/ Name           Version      Architecture Description
    +++-==============-============-============-=================================
    ii  hplip          3.17.10+repa amd64        HP Linux Printing and Imaging Sys

If the ii is present then the HP software is installed
    
    
Run HP setup which is a GUI which can search for printers on USB or network

    hp-setup
    

Bash up arrow history
-----------------------

Put this in .bashrc file to enable up arrow completion from history

        bind '"\e[A": history-search-backward'
        bind '"\e[B": history-search-forward'

        
Mount SMB drive
-------------------

    sudo mount -t cifs -o username=pi //192.168.1.199/naspath/ mount
    shared/ mount

    
Systemctl
----------

List all services 

    systemctl list-units --type=service
    
List all services running

    systemctl list-units --type=service --state=running 
    
List all services that will start up automatically

    systemctl list-unit-files --state=enabled
    
List services that are disabled

    systemctl list-unit-files --state=disabled
    
Status of a service e.g. cups

    systemctl status cups.service
    
    
    
