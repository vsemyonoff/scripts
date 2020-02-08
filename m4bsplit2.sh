#!/bin/bash

input="$1"
EXT2="m4a"

json=$(ffprobe -i "$input" -loglevel error -print_format json -show_format -show_chapters)
title=$(echo $json | jq -r ".format.tags.title")
count=$(echo $json | jq ".chapters | length")
target=$(echo $json | jq -r ".format.tags | .date + \" \" + .artist + \" - \" + .title")
mkdir "$target"

echo "[playlist]
NumberOfEntries=$count" > "$target/0_Playlist.pls"

for i in $(seq -w 1 $count);
do
  j=$((10#$i))
  n=$(($j-1))
  start=$(echo $json | jq -r ".chapters[$n].start_time")
  end=$(echo $json | jq -r ".chapters[$n].end_time")
  name=$(echo $json | jq -r ".chapters[$n].tags.title")
  ffmpeg -activation_bytes secret -i $input -vn -acodec -map_chapters -ss $start -to $end -metadata title="$title $name" "$target/$i $name.$EXT2"
  echo "File$j=$i $name.$EXT2" >> "$target/0_Playlist.pls"
done
