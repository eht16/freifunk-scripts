# Various Freifunk / Gluon scripts


## Set LED Status

Sets LED status on Freifunk router devices to display
only interesting information like:

  - are any clients connected?
  - is a Freifunk gateway assigned (i.e. is the device connected to the Freifunk network)
  - simple system health check (CPU load, free memory, NVRAM usage)

More details and installation instructions can be found on:
https://www.pending.io/optimize-leds-on-freifunk-routers/


## gluon_status

Simple command line script to query and display the node information and statistics
from one or more Freifunk devices.

Example:
```
enrico@endor: ~% python3 gluon_status '[2a03:2267:2::16cc:20ff:feb4:c774]' '[2001:608:a01:2:c6e9:84ff:fe5b:9e26]'
CCCHH
=====
  Node ID <unknown> / Owner: <unknown>
  Model: TP-Link TL-WDR4300 v1 (v2018.1.4.0 <unknown>)
  Gateway: de:ad:be:ef:30:2f

  Uptime: 1 days, 08:41:04
  Load: 0.16 / Processes: 1 / 51
  Memory: 31 MB / 122 MB
  NVRAM: 7.05 %
  Clients: Total: 3 Wifi: 3
  Traffic: Rx: 2675.87 MB Tx: 123.92 MB


RFguy-Augustenstrasse-Nord (ffmuc)
==================================
  Node ID c4e9845b9e26 / Owner: rfguy@muc.ccc.de
  Model: TP-Link CPE210 v1.0 (gluon-v2015.1-472-gdddade2 v2016.0)
  Gateway: 1a:d1:a8:16:38:32

  Uptime: 37 days, 13:06:50
  Load: 0.51 / Processes: 2 / 48
  Memory: 29 MB / 60 MB
  NVRAM: 8.05 %
  Clients: Total: 6 Wifi: 6
  Traffic: Rx: 29083.11 MB Tx: 1811.79 MB
```

Requires Python3 and Requests and BeautifulSoup4 packages.
