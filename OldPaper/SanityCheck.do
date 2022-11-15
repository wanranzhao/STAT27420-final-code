// ssc install estout, replace

use "./Dataset/Crime.dta", clear

forval year = 1958/1962{
  foreach v in crimerate-arms {
  tabstat `v', by(navy) stats(n mean median min max sd var)
  } 
}


// forval year = 1958/1962{
// 	foreach v in crimerate-arms {
// 		eststo X : qui estpost tabstat `v', by(navy) stats(n mean median min max sd var)
// 		esttab X using id-number-group-variation-`v'-`year'.csv, ///
// 			cells("v") plain nomtitle nonumber noobs
// 	}
// 	
// }

