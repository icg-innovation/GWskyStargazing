#!/bin/sh

# get sky maps
wget -nc https://svs.gsfc.nasa.gov/vis/a000000/a004800/a004851/starmap_2020_4k.exr
wget -nc https://svs.gsfc.nasa.gov/vis/a000000/a004800/a004851/constellation_figures_4k.tif

# combine maps if doing so
yes | ffmpeg -apply_trc iec61966_2_1 -i starmap_2020_4k.exr -i constellation_figures_4k.tif -filter_complex '[1:v]colorkey=0x000000:0.01:0.01,colorchannelmixer=aa=0.20[ckout];[0:v][ckout]overlay[out]' -map '[out]' sky.png

# overlay the timer 
yes | ffmpeg -loop 1 -i sky.png -r 30 -i text_frames/tstamp_%05d.png -filter_complex \
"[0:v][1:v]overlay=(W-w)/2:(H-h)/2:shortest=1,format=yuv420p[v]" \
-map "[v]" -movflags +faststart predub.mp4



