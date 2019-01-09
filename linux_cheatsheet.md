Linux cheatsheets
====================


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
    

