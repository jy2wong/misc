#!/bin/bash

timidity -OF -o - -T 120 $1 | ffmpeg -i - `basename $1 .mid`.mp3
