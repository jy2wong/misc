#!/bin/bash

FILE="$1"
BASEFILE="${FILE%.*}"
QUALITY=$2
OUTDIR="$3"

echo $FILE
echo $BASEFILE
ffmpeg -i "$FILE" -f ffmetadata /tmp/"$BASEFILE".txt -acodec pcm_s16le -f wav - |\
	neroAacEnc -q $QUALITY -ignorelength -if - -of /tmp/"$BASEFILE".mp4

ffmpeg -f ffmetadata -i /tmp/"$BASEFILE".txt -i /tmp/"$BASEFILE".mp4 -vn -acodec copy -bsf:a aac_adtstoasc "$OUTDIR/$BASEFILE".m4a
rm /tmp/"$BASEFILE".{mp4,txt}
