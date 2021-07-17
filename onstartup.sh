#!/bin/bash

DIRECTORY="$(readlink -f "$(dirname "$0")")"

while true;do
  update=1
  
  output="$(sudo apt update 2>&1)"
  exitcode=$?
  
  #inform user packages are upgradeable
  if [ -z "$(echo "$output" | grep 'can be upgraded' )" ];then
    update=0
  elif [ $exitcode != 0 ];then
    update=0
  fi
  #only continue script if upgrades available
  
  LIST="$(apt list --upgradable 2>/dev/null | cut -d/ -f 1 | tail -n +2 | grep -vx "$(dpkg --get-selections | grep "\<hold$" | tr -d ' \t' | sed 's/hold//g' | sed -z 's/\n/\\|/g' | sed -z 's/\\|$/\n/g')")"
  
  if [ -z "$LIST" ];then
    update=0
  fi
  
  if [ $update == 1 ];then
    screen_width="$(xdpyinfo | grep 'dimensions:' | tr 'x' '\n' | tr ' ' '\n' | sed -n 7p)"
    screen_height="$(xdpyinfo | grep 'dimensions:' | tr 'x' '\n' | tr ' ' '\n' | sed -n 8p)"
    
    yad --form --text='Update Buddy:
APT updates available.' \
      --on-top --skip-taskbar --undecorated --close-on-unfocus \
      --geometry=260+$((screen_width-262))+$((screen_height-150)) \
      --image="${DIRECTORY}/logo.png" \
      --button="Details!${DIRECTORY}/icons/info.png":0 \
      --button="Later!${DIRECTORY}/icons/exit.png":1 \
      2>/dev/null || update=0
  fi
  
  if [ $update == 1 ];then
    echo -e "$LIST" | yad --center --title='Update Buddy' --width=310 --height=300 --no-headers --no-selection \
      --list --separator='\n' --window-icon="${DIRECTORY}/logo.png" \
      --text='These packages can be upgraded:' \
      --column=Package \
      --button='Cancel'!"${DIRECTORY}/icons/exit.png"!:1 \
      --button='Update now'!"${DIRECTORY}/icons/download.png":0 \
      2>/dev/null || update=0
  fi
  
  if [ $update == 1 ];then
    "${DIRECTORY}/terminal-run" 'sudo apt -y full-upgrade --allow-downgrades;echo "Closing in 10 seconds.";sleep 10' 'Upgrading packages'
  fi
  
  echo "Waiting 12 hours"
  sleep 12h
done
