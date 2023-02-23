**** Este dofile crea estadísticas descriptivas a partir de la base de protestas

/* 
SOURCE AVALAIBLE 
LINK: http://data.gdeltproject.org/events/index.html 
*/

** Disc
global disc "C:/Users/`c(username)'/Dropbox/Tesis/Data/GDELT"

**Storing
global main_place "${disc}/TEND"
cd "${main_place}"

use "protest_2010_2022_adj", clear
gen total=1
collapse (sum) total, by(year)

keep if year>=2011 & year<=2022
tsset year

#d;
	tw (tsline total, lcolor(cranberry%90) lpattern("--"))
	    (scatter total year if year<2018, 
			mlabel(total) mlabposition(12) mlabformat(%4.0f) 	
			mlabcolor(cranberry) mcolor(cranberry))	
		(scatter total year if year>2018, 
			mlabel(total) mlabposition(10) mlabformat(%4.0f) 	
			mlabcolor(cranberry) mcolor(cranberry))
		(scatter total year if year==2018, 
			mlabel(total) mlabposition(6) mlabformat(%4.0f) 	
			mlabcolor(cranberry) mcolor(cranberry)),
		name("pea", replace)												
		plotregion(fcolor(white) lcolor(black)) 								
		graphregion(fcolor(white) lcolor(white)) 								
		ylabel(, nogrid) 	
		xlabel(2011(1)2022)
		ytitle("", margin(r=2)) 
		xtitle("")
		title("Protestas 2011-2022", color($p6)) 
		subtitle("Número de protestas anuales en Colombia", margin(b=3)) 
		note("{bf:Datos:} GDELT 2.0", margin(t=4))
		legend(off);
#d cr 
graph export "protestas_anuales.pdf", replace





