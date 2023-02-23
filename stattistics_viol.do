**** Este dofile crea estadísticas descriptivas a partir de la base de protestas

/* 
SOURCE AVALAIBLE 
LINK: http://data.gdeltproject.org/events/index.html 
*/

net install scheme-modern, from("https://raw.githubusercontent.com/mdroste/stata-scheme-modern/master/")
net install cleanplots, from("https://tdmize.github.io/data/cleanplots")

** Disc
global disc "C:/Users/`c(username)'/Dropbox/Tesis/Data/VIOLENCE"

**Storing
global main_place "${disc}/VIPPA"
cd "${main_place}"

** Abrir la base de datos
use "ViPAA_v1.4.dta", clear

** Actores
#d;
gen actor_new = cond(actor_main=="Criminal organizations",1, 
                cond(actor_main=="FARC Dissidents" | 
				     actor_main=="Insurgents",2,
			    cond(actor_main=="Paramilitaries",3,
				cond(actor_main=="Government",4,.))));
#d cr
				
label define actors 1"Other" 2"Insurgents" 3"Paramilitaries" 4"Government"
label values actor_new actors

** Generar collapse 
gen num_viol=1
collapse (sum) num_viol, by(year actor_new)

** Dejar años de interes
keep if year>=2011 & year<=2021
colorpalette viridis, global

#d;
	tw (line num_viol year if actor_new==1)
		(line num_viol year if actor_new==2)
		(line num_viol year if actor_new==3)
		(line num_viol year if actor_new==4),
		scheme(modern)
		name("pea", replace)												
		xlabel(2011(1)2020)
		ytitle("", margin(r=2)) 
		xtitle("")
		title("Violent events 2011-2020 by perpetrator", margin(b=3)) 
		legend(order(1 "Other" 2 "Insurgents" 3 "Paramilitaries" 4 "Government"));
#d cr 

graph export "violentvippa.pdf", replace


** Nivel municipal

** Abrir la base de datos
use "ViPAA_v1.4.dta", clear

#d;
gen actor_new = cond(actor_main=="Criminal organizations",1, 
                cond(actor_main=="FARC Dissidents" | 
				     actor_main=="Insurgents",2,
			    cond(actor_main=="Paramilitaries",3,
				cond(actor_main=="Government",4,.))));
#d cr
				
label define actors 1"GAOs" 2"Insurgencias" 3"Paramilitares" 4"Gobierno"
label values actor_new actors

** Generar collapse 
gen num_viol=1
keep if year>=2011 & year<=2021
collapse (sum) num_viol, by(mun)
rename mun mpio_ccnct

tempfile sos
save `sos'

clear all
shp2dta using municipios_sin_repet,	/// 
		database(base_col) coordinates(coord_col) genid(id) genc(c) replace

use "base_col.dta", replace 
rename cod_mun mpio_ccnct

merge 1:1 mpio_ccnct using `sos'

preserve
 spmap num_viol using coord_col, id(id) 				    	/// 
	fcolor(Purples) osize("thin")									/// 
	ndf(white) clnumber(6) 										///
	title("Hechos violentos 2011-2020") 						///
	subtitle("Promedio anual municipal")						///
	caption("Fuente: ViPAA_v1.4") 								/// 
	name(mapa_1, replace) legend(size(*1.4)) legstyle(2)
    graph export "violencia.png", replace
restore 


