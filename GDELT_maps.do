**** Este dofile mapea las protestas

/* 
SOURCE AVALAIBLE 
LINK: http://data.gdeltproject.org/events/index.html 
*/

** Disc
global disc "C:/Users/ad.gomezb/Dropbox/Tesis/Data/GDELT"

**Storing
global main_place "${disc}/MAPS"
cd "${main_place}"

ssc install spmap, replace 
ssc install shp2dta, replace

use base_col.dta, clear

shp2dta using co_dep, database(base_col) coordinates(coord_col) genid(id) genc(c) replace
