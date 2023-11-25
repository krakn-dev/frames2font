import fontforge
import json
from glob import glob
import random
import re

# setup frames_unicode file
framesUnicodeFileName = "frames_unicode.json"
framesUnicodeFile = None
try:
    framesUnicodeFile = open(framesUnicodeFileName, "r")
except IOError:
    print("creating frames_unicode.json")
    framesUnicodeFile = open(framesUnicodeFileName, "x")
    json.dump({}, open(framesUnicodeFileName, 'w'))
    framesUnicodeFile = open(framesUnicodeFileName, "r")

framesUnicodeJson = json.load(framesUnicodeFile)
svgFilePaths = glob("tmp/*.svg")

# setup font
newFont = fontforge.font()
newFont.fontname = "strworld"
newFont.familyname = "strworld"

# if frame exists update svg only(not generate a new unicode value)
# else add new frame to frames_unicode.json and generate a new unicode value

def createNewGlyph(path, unicodeCode):            
    newGlyph = newFont.createChar(unicodeCode)
    newGlyph.importOutlines(path)
    
for svgPath in svgFilePaths:
    newFrameName = (re.split(r'\.|/',svgPath)[1])
    if newFrameName in framesUnicodeJson:
        createNewGlyph(svgPath,framesUnicodeJson[newFrameName])
    else:
        unicodeCode = random.randint(1, 60_000) 
        framesUnicodeJson[newFrameName] =unicodeCode
        createNewGlyph(svgPath,unicodeCode)

# save file
json.dump(framesUnicodeJson, open(framesUnicodeFileName, 'w'), sort_keys=True, indent=4)

# generate font
newFont.generate('strworld.ttf')

