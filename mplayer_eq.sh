#!/usr/bin/env bash
# --------------------------------------------------
# To change equalizer preset in mplayer
# Derived from: http://advantage-bash.blogspot.in/2013/05/mplayer-presets.html
#
# Usage:
# bash ./mplayer_eq.sh
# --------------------------------------------------

EQ="af=equalizer"
CONFIG_PATH=$HOME/.mplayer/config

echo -e "1. Flat\n2. Classical\n3. Club\n4. Dance\n5. Full-bass\n6. Full-bass-and-treble\n7. Full-treble\n8. Headphones\n9. Large-hall\n10. Live\n11. Party\n12. Pop\n13. Reggae\n14. Rock\n15. Ska\n16. Soft\n17. Soft-rock\n18. Techno\n"

# Display present configuration if any.
if [ -f ${CONFIG_PATH} ];
then
    present_conf=$(grep "#" ${CONFIG_PATH} | awk '{print $NF}' | sed -e 's/#//g')
    echo -e "Present configuration:" ${present_conf}
fi

read -p "your choice: "
case $REPLY in
     1)echo "${EQ}=0.0:0.0:0.0:0.0:0.0:0.0:0.0:0.0:0.0:0.0  #flat" > ${CONFIG_PATH}
      ;;
     2)echo "${EQ}=0.0:0.0:0.0:0.0:0.0:-4.4:-4.4:-4.4:-5.8  #classical" > ${CONFIG_PATH}
      ;;
     3)echo "${EQ}=0.0:0.0:4.8:3.3:3.3:3.3:1.9:0.0:0.0  #club" > ${CONFIG_PATH}
      ;;
     4)echo "${EQ}=5.7:4.3:1.4:0.0:0.0:-3.4:-4.4:-4.3:0.0:0.0  #dance" > ${CONFIG_PATH}
      ;;
     5)echo "${EQ}=-4.8:5.7:5.7:3.3:1.0:-2.4:-4.8:-6.3:-6.7:-6.7  #full bass" > ${CONFIG_PATH}
      ;;
     6)echo "${EQ}=4.3:3.3:0.0:-4.4:-2.9:1.0:4.8:6.7:7.2:7.2  #full bass and treble" > ${CONFIG_PATH}
      ;;
     7)echo "${EQ}=-5.8:-5.8:-5.8:-2.4:1.4:6.7:9.6:9.6:9.6:10.1  #full treble" > ${CONFIG_PATH}
      ;;
     8)echo "${EQ}=2.8:6.7:3.3:-2.0:-1.4:1.0:2.8:5.7:7.7:8.6  #headphones" > ${CONFIG_PATH}
      ;;
     9)echo "${EQ}=6.2:6.2:3.3:3.3:0.0:-2.9:-2.9:-2.9:0.0:0.0  #large hall" > ${CONFIG_PATH}
      ;;
     10)echo "${EQ}=-2.9:0.0:2.4:3.3:3.3:3.3:2.4:1.4:1.4:1.4  #live" > ${CONFIG_PATH}
      ;;
     11)echo "${EQ}=4.3:4.3:0.0:0.0:0.0:0.0:0.0:0.0:4.3:4.3  #party" > ${CONFIG_PATH}
      ;;
     12)echo "${EQ}=-1.0:2.8:4.3:4.8:3.3:0.0:-1.4:-1.4:-1.0:-1.0  #pop" > ${CONFIG_PATH}
      ;;
     13)echo "${EQ}=0.0:0.0:0.0:-3.4:0.0:3.8:3.8:0.0:0.0:0.0  #reggae" > ${CONFIG_PATH}
      ;;
     14)echo "${EQ}=4.8:2.8:-3.4:-4.8:-2.0:2.4:5.3:6.7:6.7:6.7  #rock" > ${CONFIG_PATH}
      ;;
     15)echo "${EQ}=-1.4:-2.9:-2.4:0.0:2.4:3.3:5.3:5.7:6.7:5.8  #ska" > ${CONFIG_PATH}
      ;;
     16)echo "${EQ}=2.8:1.0:0.0:-1.4:0.0:2.4:4.8:5.7:6.7:7.2  #soft" > ${CONFIG_PATH}
      ;;
     17)echo "${EQ}=2.4:2.4:1.4:0.0:-2.4:-3.4:-2.0:0.0:1.4:5.3  #soft rock" > ${CONFIG_PATH}
      ;;
     18)echo "${EQ}=4.8:3.3:0.0:-3.4:-2.9:0.0:4.8:5.7:5.8:5.3  #techno" > ${CONFIG_PATH}
      ;;
esac
