#!/bin/bash

DIR=~/music/chiptunes/turrican_wav
tfmxplay -o /tmp/asdfmoo_.pcm "$1"
ffmpeg -f s16le -ar 44100 -ac 2 -i /tmp/asdfmoo_.pcm "$DIR/`basename $1 .TFX`".flac
