#!/bin/bash
echo "KRB START AUDIO SCRIPT"
export PATH=/root/openMHA/bin:$PATH
gpioset gpiochip2 26=0
gpioset gpiochip2 27=0
gpioset gpiochip2 28=1
sleep 5
export JACK_NO_AUDIO_RESERVATION=1
amixer -cwm8904audio set 'Capture Input' ADC
amixer -cwm8904audio set 'Capture' 27 
amixer -cwm8904audioa set 'Capture' 27 
amixer -cwm8904audioc set 'Capture' 27 
amixer -cwm8904audio set 'Headphone' 63 
amixer -cwm8904audioa set 'Headphone' 63 
amixer -cwm8904audioc set 'Headphone' 63 
jackd -R -P90 -dalsa -i 4 -o 4 -dhw:wm8904audioa  -r24000 -p 55 -S -n2 &
sleep 5
#jack_connect system:capture_1 system:playback_1
#jack_connect system:capture_2 system:playback_2
#jack_connect system:capture_3 system:playback_3
#jack_connect system:capture_4 system:playback_4
#jack_connect system:capture_5 system:playback_5
#jack_connect system:capture_6 system:playback_6
#jack_connect system:capture_7 system:playback_7
#jack_connect system:capture_8 system:playback_8
mha --interface=0.0.0.0 --port=33337 --daemon  ?read:/root/hearing_aid/index.cfg &
gpioset gpiochip2 26=0
gpioset gpiochip2 27=1
gpioset gpiochip2 28=0
sleep 2

# 24kHz
#Disable System Clock
i2cset -f -y 1 0x1a 0x16 0x0000 w
sleep 0.5

i2cset -f -y 1 0x1a 0x15 0x0314 w
sleep 0.5

i2cset -f -y 1 0x1a 0x16 0x0700 w
sleep 0.5

#Disable System Clock
i2cset -f -y 2 0x1a 0x16 0x0000 w
sleep 0.5
i2cset -f -y 2 0x1a 0x15 0x0314 w
sleep 0.5

i2cset -f -y 2 0x1a 0x16 0x0700 w
sleep 0.5

######################################
#Adjust right channel amp gains
######################################
#Preamp gains codec b
i2cset -f -y 2 0x1a 0x2c 0x1b00 w
sleep 0.5
i2cset -f -y 2 0x1a 0x2d 0x1b00 w
sleep 0.5

#Set Headphone gain codec b to +6dB Left/Right channel
i2cset -f -y 2 0x1a 0x39 0xff00 w
sleep 0.5
i2cset -f -y 2 0x1a 0x3A 0xff00 w
sleep 0.5

# Enable CM rejection
i2cset -f -y 1 0x1a 0x2e 0x5900 w
sleep 0.5
i2cset -f -y 1 0x1a 0x2f 0x5900 w
sleep 0.5

i2cset -f -y 2 0x1a 0x2e 0x5900 w
sleep 0.5
i2cset -f -y 2 0x1a 0x2f 0x5900 w
sleep 0.5


