#!/bin/sh

for note in "$@"; do
	AUDIODEV=/dev/oss/oss_hdaudio0/pcm0 AUDIODRIVER=oss play -r 48000 -n synth 2 saw $note vol -21 dB
done
