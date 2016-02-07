bw2.io
======

## How to install a bosswave executable

In order for processes on your machine to talk to the bosswave network, you need to install the bosswave executable. You can either clone this repository and build one, or you can download one from http://get.bw2.io/.

For example:
```
wget http://get.bw2.io/linux/amd64/bw2_rx_2.0.2_rc1 -O bw2
chmod a+x bw2
```

You may want to move this executable to /usr/bin or put it somewhere in your path.

## How to set up a local router

Processes on your machine use a local bosswave router to connect to the bosswave network. It makes it easier than trying to support all the crypto in every language.

```
bw2 makeconf
bw2 router
```

You may want to consult your distribution's manual to determine how to run `bw2 router` on startup. Note that by default it checks the current directory for the bw2.ini file that has the options for the router.

