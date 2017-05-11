check_raid
==========

Checks bandwidth, and outputs data in format that pnp4nagios likes.

Parses data from reading `/sys/class/net/$INTERFACE/statistics/{tx,rx}_{bytes,packets}`


Usage
-----

- Add a command line argument for monitoring an interface. (Only one interface)i

- Since I belive that each interface requires individual monitoring always, deploy with as many interfaces as required.

- Party Hard! (Is a Must!)

