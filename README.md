# Strworld's Png Frames to Font Glyphs Converter
takes png frames and turns it into a font  
to make frame by frame animations using characters.

### Requirements:
potrace  
pngtopnm  
fontforge  
inkscape  
python  

### Options:
```
--folder    takes folder path.  
--file      takes file path.  

[ optional, these arguments always go last. ]   
--fast      skips simplification and optimization.  
--no-clean  does not remove svgs (useful to see number of nodes).  
```
### Usage:
`frames2font.sh --folder [ FOLDER_PATH ] --fast --no-clean`  

Files must be in .png  

### Important:
The output files are located next to the executable,    
including a frames_unicode.json file that contains  
the unicode code assigned to the character within its png name,    
it won't change unicode codes for the file names it has  
seen before, only is going to update the font's apparance.    
if you change your file names, it will get confused, and  
you should delete frames_unicode.json to generate a fresh one.  

this project has names hardwritten because it is made for strworld  
but you should be able to quickly overwrite that.  
