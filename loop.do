cd "C:\Users\ad.gomezb\Dropbox\Tesis\Data\GDELT"

cap copy http://data.gdeltproject.org/events//20140101.export.CSV.zip 20140101.zip



 forvalues y=2014/2021 {
 	forvalues m=1/12 {
		mat y_`y'_m_`m'= J(31,2,.)
		forvalues d=1/31{
		  local i=1
			if `m'<=9 {
				if `d'<=9 {
				   cap copy http://data.gdeltproject.org/events/`y'0`m'0`d'.export.CSV.zip `y'0`m'0`d'.zip
			       cap unzipfile `y'0`m'0`d'.zip, replace	
				   cap confirm new file `y'0`m'0`d'.export.csv
						if _rc==0 {
							mat y_`y'_m_`m'[`i',1]=`y'0`m'0`d'
							mat y_`y'_m_`m'[`i',2]=1
						}
						else {
							mat y_`y'_m_`m'[`i',1]=`y'0`m'0`d'
							mat y_`y'_m_`m'[`i',2]=0
						}
				}
			    else {
				   cap copy http://data.gdeltproject.org/events/`y'0`m'`d'.export.CSV.zip `y'0`m'`d'.zip
			       cap unzipfile `y'0`m'`d'.zip, replace
				   cap confirm new file `y'0`m'`d'.export.csv
						if _rc==0 {
							mat y_`y'_m_`m'[`i',1]=`y'0`m'`d'
							mat y_`y'_m_`m'[`i',2]=1
						}
						else {
							mat y_`y'_m_`m'[`i',1]=`y'0`m'`d'
							mat y_`y'_m_`m'[`i',2]=0
						}
				}
			}
			else {
				if `d'<=9 {
				   cap copy http://data.gdeltproject.org/events/`y'`m'0`d'.export.CSV.zip `y'`m'0`d'.zip
			       cap unzipfile `y'`m'0`d'.zip, replace
				   cap confirm new file `y'`m'0`d'.export.csv
						if _rc==0 {
							mat y_`y'_m_`m'[`i',1]=`y'`m'0`d'
							mat y_`y'_m_`m'[`i',2]=1
						}
						else {
							mat y_`y'_m_`m'[`i',1]=`y'`m'0`d'
							mat y_`y'_m_`m'[`i',2]=0
						}
				}
			    else {
				   cap copy http://data.gdeltproject.org/events/`y'`m'`d'.export.CSV.zip `y'`m'`d'.zip
			       cap unzipfile `y'`m'`d'.zip, replace
				   cap confirm new file `y'`m'`d'.export.csv
						if _rc==0 {
							mat y_`y'_m_`m'[`i',1]=`y'`m'`d'
							mat y_`y'_m_`m'[`i',2]=1
						}
						else {
							mat y_`y'_m_`m'[`i',1]=`y'`m'`d'
							mat y_`y'_m_`m'[`i',2]=0
						}
				}
			}
		  local i=`i'+1
		  di `y'`m'`d'
		}
       
	}
 }
 
cap copy http://data.gdeltproject.org/events/20220511.export.CSV.zip 20220511.zip
cap unzipfile 20220511.zip, replace
confirm new file 20220511.export.csv


