#!/bin/sh

if ( xrandr|grep 'VGA1 connected' &> /dev/null ) ; then
	MARGIN=1413
	xrandr --output VGA1 --above LVDS1 --preferred
	xsetwacom set 'Serial Wacom Tablet WACf008 stylus' MapToOutput LVDS1
	xsetwacom set 'Serial Wacom Tablet WACf008 stylus' Area 55 5 24595 18357
	xsetwacom set 'Serial Wacom Tablet WACf008 eraser' MapToOutput VGA1
	xsetwacom set 'Serial Wacom Tablet WACf008 eraser' Mode Relative
else
    MARGIN=133
	xrandr --auto
    xsetwacom set "Serial Wacom Tablet WACf008 stylus" Area 105 40 24590 18377
    xsetwacom set "Serial Wacom Tablet WACf008 touch" Area 46 75 920 950
	xsetwacom set 'Serial Wacom Tablet WACf008 eraser' MapToOutput LVDS1
	xsetwacom set 'Serial Wacom Tablet WACf008 eraser' Mode Absolute
fi

killall dzen2 
killall visibility 
dzen_dock &
visibility &
