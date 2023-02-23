**** Este dofile descarga la base de GDELT

/* 
SOURCE AVALAIBLE 
LINK: http://data.gdeltproject.org/events/index.html 
*/

**Disc
global disc "C:/Users/ad.gomezb/Dropbox/Tesis/Data/GDELT"

**Storing
global main_store "${disc}/RAW DATA"
cd "${main_store}"

**Listing
import delimited using "${disc}/LISTS/files_GDELT.txt", clear delim(";")
split v1, gen(new) parse(.)
keep new1

**Downloading

mat result = J(_N,2,.)
local totalnumb = _N
forvalues i = 1/`totalnumb'{
	local seed = new1[`i']
	di `seed'
		cap copy http://data.gdeltproject.org/events/`seed'.export.CSV.zip `seed'.zip
	    cap unzipfile `seed'.zip, replace	
		cap confirm new file `seed'.export.csv
						if _rc==0 {
							mat result[`i',1]=`seed'
							mat result[`i',2]=1
						}
						else {
							mat result[`i',1]=`seed'
							mat result[`i',2]=0
						}
}

mat result = J(_N,2,.)
local totalnumb = _N
forvalues i = 1/`totalnumb'{
	local seed = new1[`i']
	di `seed'
	    erase `seed'.export.csv	
		cap confirm new file `seed'.export.csv
						if _rc==0 {
							mat result[`i',1]=`seed'
							mat result[`i',2]=1
						}
						else {
							mat result[`i',1]=`seed'
							mat result[`i',2]=0
						}
}



svmat result
rename (result1 result2) (archive notdownloaded)

gen pdtc = strlen(new1)
keep if pdtc < 8


mat result = J(_N,2,.)
local totalnumb = _N
forvalues i = 1/`totalnumb'{
	local seed = new1[`i']
	di `seed'
		cap copy http://data.gdeltproject.org/events/`seed'.zip `seed'.zip
		cap confirm new file `seed'.zip
						if _rc==0 {
							mat result[`i',1]=`seed'
							mat result[`i',2]=1
						}
						else {
							mat result[`i',1]=`seed'
							mat result[`i',2]=0
						}
}

