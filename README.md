# Bluelock
Bluelock is a little bash script that uses the quality of a bluetooth connection to lock your computer screen if you leave you workspace with a predefined bluetooth device.

## Requirements
Bluelock requires bluez to be installed on your system. You can install it with the following command
```bash
sudo apt-get install bluez
```

## Usage
Bluelock helps you to find your bluetooth device and establish a connection if you just run it without any arguments
```./bluelock.sh```

However, you may define the bluetooth address and rssi threshold as follows
```./bluelock.sh <bluetooth address> <rssi threshold>```