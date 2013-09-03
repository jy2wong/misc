#!/bin/sh

usage="usage: $0 -c {up|down|mute} [-i increment] [-m mixer]"
command=
increment=3
mixer='PCM'

while getopts i:m:h o
do case "$o" in
    i) increment=$OPTARG;;
    m) mixer=$OPTARG;;
    h) echo "$usage"; exit 0;;
    ?) echo "$usage"; exit 0;;
esac
done

shift $(($OPTIND - 1))
command=$1

if [ "$command" = "" ]; then
    echo "usage: $0 {up|down|mute} [increment]"
    exit 0;
fi

display_volume=0

if [ "$command" = "up" ]; then
    #display_volume=$(amixer set $mixer $increment+ unmute | grep -m 1 "%]" | cut -d "[" -f2|cut -d "%" -f1)
    display_volume=$(ossvol -i $increment | cut -d " " -f8|cut -d ":" -f1)
fi

if [ "$command" = "down" ]; then
    #display_volume=$(amixer set $mixer $increment- unmute | grep -m 1 "%]" | cut -d "[" -f2|cut -d "%" -f1)
    display_volume=$(ossvol -d $increment | cut -d " " -f8|cut -d ":" -f1)
fi

icon_name=""

if [ "$command" = "mute" ]; then
    display_volume=$(ossvol -t | cut -d " " -f8|cut -d ":" -f1)
#	mixer='Master'
#    if amixer get Master | grep "\[on\]"; then
#        display_volume=0
#        icon_name="notification-audio-volume-muted"
#        amixer set $mixer mute
#    else
#        display_volume=$(amixer set $mixer unmute | grep -m 1 "%]" | cut -d "[" -f2|cut -d "%" -f1)
#    fi
fi

#if [ "$icon_name" = "" ]; then
#    if [ "$display_volume" = "0" ]; then
#        icon_name="notification-audio-volume-off"
#    else
#        if [ "$display_volume" -lt "33" ]; then
#            icon_name="notification-audio-volume-low"
#        else
#            if [ "$display_volume" -lt "67" ]; then
#                icon_name="notification-audio-volume-medium"
#            else
#                icon_name="notification-audio-volume-high"
#            fi
#        fi
#    fi
#fi
#notify-send " " -i $icon_name -h int:value:$display_volume -h string:synchronous:volume
# use variable $level to create an OSD for the current volume level
do_dzen() {
  local pipe='/tmp/volpipe' s=1

  # make a fifo from which dzen will read, this prevents mutliple dzens
  # from being spawned given repeated volume commands
  if [[ ! -e "$pipe" ]]; then
    mkfifo "$pipe"
    (dzen2 "${dzen_args[@]}" < "$pipe"; rm -f "$pipe") &
  fi

  # send the text to the fifo (and eventually to dzen)
  (echo ${display_volume} 61.4 | gdbar "${gdbar_args[@]}"; sleep $s) >> "$pipe"
}

dzen_args=(
  -tw 420 -h 20 -x 302 -y -30
  -bg '#101010'
)

gdbar_args=(
  -w 400 -h 7
  -fg '#606060' 
  -bg '#404040'
)

# do dzen only if in X
[[ -n "$DISPLAY" ]] && do_dzen || echo "$mixer set to $display_volume"
