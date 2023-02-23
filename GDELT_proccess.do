**** Este dofile procesa GDELT

/* 
SOURCE AVALAIBLE 
LINK: http://data.gdeltproject.org/events/index.html 
*/

** Disc
global disc "C:/Users/ad.gomezb/Dropbox/Tesis/Data/GDELT"

**Storing
global main_store "${disc}/RAW DATA"
cd "${main_store}"

**Listing
import delimited using "${disc}/LISTS/files_GDELT.txt", clear delim(";")
split v1, gen(new) parse(.)
keep new1
gen counting = strlen(new1)
keep if counting==8


local totalnumb = _N
local j=1
global storing_1 "20220511"
forvalues i = 2/`totalnumb'{
	local seed = new1[`i']
	di `seed'
	global storing_`i' "${storing_`j'} `seed'"
	local j= `j'+1	
}

**Processing storing_3324

foreach seed in $storing_3324 {
	clear all 
	di `seed'
	cap unzipfile `seed'.zip, replace
	cap import delimited `seed'.export.csv, delim("""") encoding("utf-8") clear
	** Unique ID
	cap rename v1 id_event
	** Date 
	cap rename (v2 v3 v4) (date year_month year)
	** First Actor
	cap rename (v6 v7 v8) (Actor1Code Actor1Name Actor1CountryCode)
	** Second Actor
	cap rename v18 Actor2CountryCode
	** Event type
	cap rename (v27 v28 v29 v30) (EventCode EventBaseCode EventRootCode QuadClass) 
	** Selection 
	cap rename (v31 v32 v33 v34 v35) (GoldsteinScale NumMentions NumSources NumArticles AvgTone)
	** Georref First Actor
	cap rename (v36 v37 v38 v39) (Actor1Geo_Type Actor1Geo_FullName Actor1Geo_CountryCode Actor1Geo_ADM1Code)
	cap rename (v40 v41 v42) (Actor1Geo_Lat Actor1Geo_Long Actor1Geo_FeatureID)
	** Georref Second Actor
	cap rename (v43 v44 v45 v46) (Actor2Geo_Type Actor2Geo_FullName Actor2Geo_CountryCode Actor2Geo_ADM1Code)
	cap rename (v47 v48 v49) (Actor2Geo_Lat Actor2Geo_Long Actor2Geo_FeatureID)
	** Georref Action 
	cap rename (v50 v51 v52 v53) (ActionGeo_Type ActionGeo_FullName ActionGeo_CountryCode ActionGeo_ADM1Code)
	cap rename (v54 v55 v56) (ActionGeo_Lat ActionGeo_Long ActionGeo_FeatureID)
	*** link source
	cap rename v58 source
	** Drop remaining variables
	cap drop v*
	** Dejar Colombia
	cap keep if ActionGeo_CountryCode=="CO"
	** Dejar Protestas
	cap keep if EventRootCode==14	
	** Guardar como dta
	cap save "${disc}\TEMPO\\`seed'.dta", replace
	di _N
	** Abrir la base madre
	clear all
	cap use "${disc}\TEMPO\base_madre.dta", clear
	cap append using "${disc}\TEMPO\\`seed'.dta", force
	** Guardar base madre
	cap compress
	keep if EventRootCode==14
	cap save "${disc}\TEMPO\base_madre.dta", replace
	di _N 
	cap erase `seed'.export.csv
	cap erase "${disc}\TEMPO\\`seed'.dta"
}


**Listing
import delimited using "${disc}/LISTS/files_GDELT.txt", clear delim(";")
split v1, gen(new) parse(.)
keep new1
gen counting = strlen(new1)
keep if counting<8


local totalnumb = _N
local j=1
global capabil_1 "201303"
forvalues i = 2/`totalnumb'{
	local seed = new1[`i']
	di `seed'
	global capabil_`i' "${capabil_`j'} `seed'"
	local j= `j'+1	
}

*cap import delimited "C:\Users\ad.gomezb\Dropbox\Tesis\Data\GDELT\SOLO ARCHIVES\201303\201303.csv", delim("""") encoding("utf-8") clear

**39
foreach seed in $capabil_39 {
	clear all 
	di `seed'
	cap unzipfile `seed'.zip, replace
	cap import delimited `seed'.csv, delim("""") encoding("utf-8") clear
	** Unique ID
	cap rename v1 id_event
	** Date 
	cap rename (v2 v3 v4) (date year_month year)
	** First Actor
	cap rename (v6 v7 v8) (Actor1Code Actor1Name Actor1CountryCode)
	** Second Actor
	cap rename v18 Actor2CountryCode
	** Event type
	cap rename (v27 v28 v29 v30) (EventCode EventBaseCode EventRootCode QuadClass) 
	** Selection 
	cap rename (v31 v32 v33 v34 v35) (GoldsteinScale NumMentions NumSources NumArticles AvgTone)
	** Georref First Actor
	cap rename (v36 v37 v38 v39) (Actor1Geo_Type Actor1Geo_FullName Actor1Geo_CountryCode Actor1Geo_ADM1Code)
	cap rename (v40 v41 v42) (Actor1Geo_Lat Actor1Geo_Long Actor1Geo_FeatureID)
	** Georref Second Actor
	cap rename (v43 v44 v45 v46) (Actor2Geo_Type Actor2Geo_FullName Actor2Geo_CountryCode Actor2Geo_ADM1Code)
	cap rename (v47 v48 v49) (Actor2Geo_Lat Actor2Geo_Long Actor2Geo_FeatureID)
	** Georref Action 
	cap rename (v50 v51 v52 v53) (ActionGeo_Type ActionGeo_FullName ActionGeo_CountryCode ActionGeo_ADM1Code)
	cap rename (v54 v55 v56) (ActionGeo_Lat ActionGeo_Long ActionGeo_FeatureID)
	** Drop remaining variables
	cap drop v*
	** Dejar Colombia
	cap keep if ActionGeo_CountryCode=="CO"
	** Dejar Protestas
	destring EventRootCode, replace
	cap keep if EventRootCode==14
	** Guardar como dta
	cap save "${disc}\TEMPO\\`seed'.dta", replace
	di _N
	** Abrir la base madre
	clear all
	cap use "${disc}\TEMPO\base_madre.dta", clear
	cap append using "${disc}\TEMPO\\`seed'.dta", force
	** Guardar base madre
	cap compress
	keep if EventRootCode==14
	cap save "${disc}\TEMPO\base_madre.dta", replace
	di _N 
	cap erase `seed'.csv
	cap erase "${disc}\TEMPO\\`seed'.dta"
}

use "${disc}\TEMPO\base_madre.dta", clear
save "C:\Users\ad.gomezb\Dropbox\Tesis\Data\GDELT\FINAL DATA\protest_2010_2013.dta", replace


append using "C:\Users\ad.gomezb\Dropbox\Tesis\Data\GDELT\FINAL DATA\protest_2013_2022.dta"

drop if year<2010

duplicates drop id_event, force

save "C:\Users\ad.gomezb\Dropbox\Tesis\Data\GDELT\FINAL DATA\protest_2010_2022.dta", replace

keep id_event ActionGeo_Lat ActionGeo_Long
export delimited using "C:\Users\ad.gomezb\Dropbox\Tesis\Data\GDELT\FINAL DATA\protest_2010_2022.csv", delim(",") replace

import delimited "C:\Users\ad.gomezb\Dropbox\Tesis\Data\GDELT\SOLO ARCHIVES\ProtestMun.txt", delim(";") clear
keep id_event mpio_narea mpio_ccnct dpto_ccdgo mpio_ccdgo

merge 1:1 id_event using "C:\Users\ad.gomezb\Dropbox\Tesis\Data\GDELT\FINAL DATA\protest_2010_2022.dta"

save "C:\Users\ad.gomezb\Dropbox\Tesis\Data\GDELT\FINAL DATA\protest_2010_2022_adj.dta", replace

use "C:\Users\ad.gomezb\Dropbox\Tesis\Data\GDELT\FINAL DATA\protest_2010_2022_adj.dta", clear

gen protestas=1 
collapse (sum) protestas, by(mpio_ccnct year)
keep if year >=2011 & year <=2021
destring mpio_ccnct, gen(cod_mpio)
keep if cod_mpio!=.

save "C:\Users\ad.gomezb\Dropbox\Tesis\Data\GDELT\FINAL DATA\protest_2010_2022_agreg.dta", replace