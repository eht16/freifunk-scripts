# Set LED Status

Sets LED status on Freifunk router devices to display
only interesting information like:

  - are any clients connected?
  - is a Freifunk gateway assigned (i.e. is the device connected to the Freifunk network)
  - simple system health check (CPU load, free memory, NVRAM usage)

More details and installation instructions can be found on:
https://www.pending.io/optimize-leds-on-freifunk-routers/

# Not working?
Getting an error like this one?
```
set_led_status.sh: line 1: can't create /sys/class/leds/tp-link:green:qss/trigger: nonexistent directory
set_led_status.sh: line 1: can't create /sys/class/leds/tp-link:green:qss/brightness: nonexistent directory
set_led_status.sh: line 1: can't create /sys/class/leds/tp-link:green:wan/trigger: nonexistent directory
set_led_status.sh: line 1: can't create /sys/class/leds/tp-link:green:wan/brightness: nonexistent directory
set_led_status.sh: line 1: can't create /sys/class/leds/tp-link:green:wlan/trigger: nonexistent directory
set_led_status.sh: line 1: can't create /sys/class/leds/tp-link:green:wlan/brightness: nonexistent directory
```

Solution: Check what leds do you have on your gluon router by viewing the files of this directory, e.g.:
```
ls /sys/class/leds

ath9k-phy0           tp-link:blue:lan2    tp-link:blue:lan4    tp-link:blue:system  tp-link:blue:wlan
tp-link:blue:lan1    tp-link:blue:lan3    tp-link:blue:qss     tp-link:blue:wan     tp-link:red:wan
```

Default color in *set_led_status.sh* script is green, change the variable *LED_COLOR* in the script to your routers color accordingly. 