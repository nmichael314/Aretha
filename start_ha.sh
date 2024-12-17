#!/bin/bash
echo "START HEARING AID SCRIPT"
echo "0" > /sys/class/leds/userled_blue/brightness
echo "0" > /sys/class/leds/userled_green/brightness
echo "1" > /sys/class/leds/userled_red/brightness
amixer -cwm8904audio set 'Capture Input' ADC
amixer -cwm8904audio set 'Capture' 5
amixer -cwm8904audioa set 'Capture' 27 
amixer -cwm8904audioc set 'Capture' 27 
amixer -cwm8904audio set 'Headphone' 57
amixer -cwm8904audioa set 'Headphone' 63 
amixer -cwm8904audioc set 'Headphone' 63 
amixer -cwm8904audio set 'Left Capture Mode' 'Single-Ended'
sleep 2 

FS=24000

mha --interface=0.0.0.0 --port=33337 --daemon  ?read:/root/hearing_aid/index.cfg &
#mha --interface=0.0.0.0 --port=33337 --daemon  ?read:/root/hearing_aid/thruAlsa6.cfg &

IRQ_PID=`ps -eLo pid,cmd | grep irq/41-sdma | awk 'NR==1{print $1}'`
chrt -f -p 95 $IRQ_PID

sleep 10 
if [ $FS -eq 24000 ]
then
  # 24kHz
  #Disable System Clock
  i2cset -f -y 1 0x1a 0x16 0x0000 w
  sleep 0.75

  # SYSCLK = MCLK/2
  i2cset -f -y 1 0x1a 0x14 0x0100 w
  sleep 0.75

  #Set divider for 24kHz
  i2cset -f -y 1 0x1a 0x15 0x0314 w
  sleep 0.75

  i2cset -f -y 1 0x1a 0x1a 0x0400 w
  sleep 0.75

  i2cset -f -y 1 0x1a 0x1b 0x8000 w
  sleep 0.75

  #Enable clocks, MCLK source
  i2cset -f -y 1 0x1a 0x16 0x0700 w
  sleep 0.75

  #Disable System Clock
  i2cset -f -y 2 0x1a 0x16 0x0000 w
  sleep 0.5

  # SYSCLK = MCLK/2
  i2cset -f -y 2 0x1a 0x14 0x0100 w
  sleep 0.75

  #Set divider for 24kHz
  i2cset -f -y 2 0x1a 0x15 0x0314 w
  sleep 0.5

  i2cset -f -y 2 0x1a 0x1a 0x0400 w
  sleep 0.75

  i2cset -f -y 2 0x1a 0x1b 0x8000 w
  sleep 0.75


  #Enable clocks, MCLK source
  i2cset -f -y 2 0x1a 0x16 0x0700 w
  sleep 0.5

elif [ $FS -eq 32000 ]
then
  #Disable System Clock
  i2cset -f -y 1 0x1a 0x16 0x0000 w
  sleep 0.75

  i2cset -f -y 1 0x1a 0x14 0x0100 w
  sleep 0.75

  i2cset -f -y 1 0x1a 0x15 0x0410 w
  sleep 0.75

  i2cset -f -y 1 0x1a 0x1a 0x0300 w
  sleep 0.75

  i2cset -f -y 1 0x1a 0x1b 0x8000 w
  sleep 0.75

  #Enable clocks, MCLK source
  i2cset -f -y 1 0x1a 0x16 0x0700 w
  sleep 0.5

  # codec b
  #Disable System Clock
  i2cset -f -y 2 0x1a 0x16 0x0000 w
  sleep 0.75

  i2cset -f -y 2 0x1a 0x14 0x0100 w
  sleep 0.75

  i2cset -f -y 2 0x1a 0x15 0x0410 w
  sleep 0.75

  i2cset -f -y 2 0x1a 0x1a 0x0300 w
  sleep 0.75

  i2cset -f -y 2 0x1a 0x1b 0x8000 w
  sleep 0.75

  #Enable clocks, MCLK source
  i2cset -f -y 2 0x1a 0x16 0x0700 w
  sleep 0.5

elif [ $FS -eq 16000 ]
then
  #Disable System Clock
  i2cset -f -y 1 0x1a 0x16 0x0000 w
  sleep 0.75

  i2cset -f -y 1 0x1a 0x14 0x0100 w
  sleep 0.75

  i2cset -f -y 1 0x1a 0x15 0x0218 w
  sleep 0.75

  i2cset -f -y 1 0x1a 0x1a 0x0700 w
  sleep 0.75

  i2cset -f -y 1 0x1a 0x1b 0x8000 w
  sleep 0.75

  #Enable clocks, MCLK source
  i2cset -f -y 1 0x1a 0x16 0x0700 w
  sleep 0.5

  # codec b
  #Disable System Clock
  i2cset -f -y 2 0x1a 0x16 0x0000 w
  sleep 0.75

  i2cset -f -y 2 0x1a 0x14 0x0100 w
  sleep 0.75

  i2cset -f -y 2 0x1a 0x15 0x0218 w
  sleep 0.75

  i2cset -f -y 2 0x1a 0x1a 0x0700 w
  sleep 0.75

  i2cset -f -y 2 0x1a 0x1b 0x8000 w
  sleep 0.75

  #Enable clocks, MCLK source
  i2cset -f -y 2 0x1a 0x16 0x0700 w
  sleep 0.5


fi

######################################
#Adjust right channel amp gains
#(setting codec a also because alsa command doesn't always work)
######################################
#Preamp gains codec b
i2cset -f -y 2 0x1a 0x2c 0x1b00 w
sleep 0.5
i2cset -f -y 2 0x1a 0x2d 0x1b00 w
sleep 0.5
i2cset -f -y 1 0x1a 0x2c 0x1b00 w
sleep 0.5
i2cset -f -y 1 0x1a 0x2d 0x1b00 w
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

echo "0" > /sys/class/leds/userled_blue/brightness
echo "1" > /sys/class/leds/userled_green/brightness
echo "0" > /sys/class/leds/userled_red/brightness

