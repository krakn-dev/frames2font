#!/bin/bash
# requirements:
#   potrace
#   pngtopnm
#   fontforge
#   inkscape
#   python
#
#
# options:
#   --folder    [folder path]
#   --file      [file path]
#   --fast      skips simplification and optimization

# ----------------------------
# 0. parse and check for input
# ----------------------------

# execute all commands from this file's directory
cd "$(dirname "$0")"

# check for flags
if [[ $* == *--folder* ]] 
then
    isFolder=true

elif [[ $* == *--file* ]] 
then
    isFolder=false
else 
    echo "missing flags"
    exit 1
fi

# check if path argument is empty 
if [ -z "$2" ]
then
    echo "missing path argument"
    exit 1
fi
pathArgument="$2"

# -----------------------------------
# 1. convert png frames to svg frames
# -----------------------------------

# remove tmp if exists
if test -d tmp; then
    rm -r tmp
fi

# add pngs working with to tmp dir
mkdir tmp

if [ $isFolder = true ] 
then
    cp $pathArgument/*.png tmp   
else
    cp $pathArgument tmp
fi

# actually convert them to svgs
for file in tmp/*
do
    fileName="$(basename -as .png $file)"
    pngtopnm -mix $file | potrace --svg -o tmp/$fileName.svg
done

# ----------------
# 2. simplify svgs  (skippable)
# ----------------

# if is not fast
if [[ $* != *--fast* ]] 
then
    for file in tmp/*.svg
    do
        fileName="$(basename -as .png $file)"

        # simplify path
        inkscape $file --actions="select-all;path-simplify;path-simplify;path-simplify;export-filename:./tmp/$fileName;export-do"

        # clean svg
        scour tmp/$fileName \
        --enable-viewboxing \
        --enable-id-stripping \
        --enable-comment-stripping \
        --shorten-ids \
        --indent=none \
        --remove-metadata \
        --quiet > tmp/_$fileName

        mv tmp/_$fileName tmp/$fileName
    done
else 
    echo "fast mode enabled (development only)"
fi

# -----------------------
# 3. convert svgs to font
# -----------------------

python svg2font.py

# -----------------------
# 4. clear
# -----------------------

rm -r tmp

exit 0
