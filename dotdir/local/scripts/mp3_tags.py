import glob
import eyed3
import sys
import re

path = sys.argv[1]

if path[-1] != "/": path += "/"


eyed3.log.setLevel("ERROR")

for f in glob.glob(path + "*"):
    # Get only file name, split and strip
    data = f[f.rfind("/") + 1:-4].split(" - ")
    data = [x.strip() for x in data]

    if (len(data) < 4): data.append("Singles")
    if (len(data) < 5): data.append("Various")

    track = eyed3.load(f)

    track.initTag()
    track.tag.genre = data[0]
    track.tag.title = data[1]
    track.tag.artist = data[2]
    track.tag.album = data[3]
    track.tag.album_artist = data[4]

    track.tag.save()
