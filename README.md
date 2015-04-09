"Dialer" is a ComputerCraft program that acts as a server for a touchscreen portal system. It can change a MystCraft portal to a given destination, out of any provided in a given chest.

## Requirements
*As tested on Direwolf20 1.7.10 1.0.3 and 1.1.1*

* ComputerCraft
* MystCraft
* Open Peripherals Core + Integration + Addons

## Known Issues

* Do not use IronChests chests, as they have been found to randomly destroy books. Safest containers to use are vanilla chests.
* There is no official method for automatically turning on a computer after a server restart. The autonomous activator is therefore required for this.

## Setup

### Required components
![Components](http://i.imgur.com/MJwzQY3.png "Required components")

1. An advanced computer
2. An advanced monitor of at least 2x2 in size
3. A vanilla single/double chest (can be changed in `dialer.lib.lua` line 19)
4. A MystCraft portal of any valid configuration with a book recepticle that **must be directly above the chest**
5. A note block (audio output)
6. *Optional*: A wired modem connection to any required peripheral
7. *Optional*: A (powered as of DW20 1.1.1) Autonomous Activator that:
  * Must be underneath the computer
  * Must be [facing upwards](http://i.imgur.com/JZqknN2.png)
  * Must be configured to [turn off when a redstone signal is given](http://i.imgur.com/79ZwnHy.png)
  
### Installation

Just upload all repository files, including `startup`, into the computer's directory. To find the directory:

1. Execute "id" on the computer and [note the number](http://i.imgur.com/rIvTtrJ.png)
2. In `world/computer` find or [create the computer's directory](http://i.imgur.com/gvtUbQY.png)

Reboot the computer to run the server, or execute `dialer.lua` directly.
