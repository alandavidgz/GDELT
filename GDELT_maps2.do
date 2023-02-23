**** Este dofile mapea las protestas

/* 
SOURCE AVALAIBLE 
LINK: http://data.gdeltproject.org/events/index.html 
*/

** Disc
global disc "C:/Users/`c(username)'/Dropbox/Tesis/Data/GDELT"

**Storing
global main_place "${disc}/MAPS"
cd "${main_place}"


*ssc install spmap, replace 
*ssc install shp2dta, replace
*ssc install schemepack, replace

clear all
shp2dta using municipios_sin_repet,	/// 
		database(base_col) coordinates(coord_col) genid(id) genc(c) replace

use "base_col.dta", replace 
rename cod_mun mpio_ccnct

preserve
keep mpio_ccnct
tempfile completion
gen a=1 
collapse a, by(mpio_ccnct)
save `completion'
unique mpio_ccnct
restore

forvalues i=2011/2021 {
	preserve 
	use "protest_2010_2022_agreg.dta", clear
	keep if year==`i'
	destring mpio_ccnct, replace
	merge 1:1 mpio_ccnct using `completion', nogen
	replace year=`i' if year==.
	save "p`i'.dta", replace
	restore
}

preserve
use p2011.dta, clear
forvalues i=2012/2021 {
	append using "p`i'.dta"
}
save pcomplet.dta, replace
restore

preserve
use pcomplet.dta, replace
collapse (mean) protestas, by(mpio_ccnct)
rename protestas protestas_ind
save "pcomplet_ny.dta", replace
restore

cap drop _merge
merge 1:1 mpio_ccnct using pcomplet_ny

colorpalette viridis, n(15) nograph reverse
local colors `r(p)'

preserve
 spmap protestas_ind using coord_col, id(id) 				    /// 
	fcolor(Blues) osize("thin")							/// 
	ndf(white) clnumber(6) 										///
	title("Protestas 2011-2021") 								///
	subtitle("Promedio anual municipal")						///
	caption("Fuente: GDELT") 									/// 
	name(mapa_1, replace) legend(size(*1.4)) legstyle(2)
    graph export "protestas.png", replace
restore 

