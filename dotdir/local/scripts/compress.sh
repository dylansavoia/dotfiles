#!/bin/bash

mkdir -p ORIGINAL
mkdir -p COMPRESSED
for f in ./*; do
    case "$f" in
        *.mp4|*.m4v)
            mv "$f" "ORIGINAL/$f"
            ffmpeg -i "ORIGINAL/$f" -c:a copy -c:v libx265 -crf 32 "COMPRESSED/${f%.*}.mp4"
            ;;

        *.jpg|*.jpeg)
            mv "$f" "ORIGINAL/$f"
           read w h <<< $(convert "ORIGINAL/$f" -ping -format "%w %h" info: )
           if [ $w -gt $h ]; then
              convert "ORIGINAL/$f" -resize "1920x1080>" -auto-orient "COMPRESSED/${f%.*}.jpg"
           else
              convert "ORIGINAL/$f" -resize "1080x1920>" -auto-orient "COMPRESSED/${f%.*}.jpg"
           fi

            # convert "ORIGINAL/$f" \
            # -sampling-factor 4:2:0 \
            # -strip \
            # -quality 85 \
            # -interlace Plane \
            # -gaussian-blur 0.05 \
            # -colorspace RGB \
            # "COMPRESSED/${f%.*}.jpg"
            ;;

        *)
            echo "nope"
            ;;
    esac
done

du -sh *
