// load data
clear all
use "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/aspo_full.dta"
// clear all
// use "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/aspo-sample.dta"

// declare panel data
tsset numcode year, yearly

// data cleaning
* drop obs with positive discovery and no wildcat
drop if newdiscovery_aspo > 0.00001 & newdiscovery_aspo!=. & wildcat < 0.5

// define lagged variables
foreach v in milexgdpSIPRI_diff popdens_diff pop_M_diff valoilres_diff democracy_diff out_regdisaster_diff oilpop_impute_diff oilreserves_diff logGDP_M ecgrowth crude1990P logmountain ethnic_fractionalization religion_fractionalization language_fractionalization leg_british{
	gen l1`v' = L.`v'
	gen l2`v'= L2.`v'
	gen l5`v'= L5.`v'
	gen l10`v'= L10.`v'
}


*******************************************************************************
** To-do:
*** try standard estimation on the sample for matching
**** example: match on same sub-sample	
	// xi: reg dincidence2COW     logvaldisc wildcat Llogvaloilres LlogGDP_M Lecgrowth Llogpop_M              Ldemocracy i.numcode i.decade, robust cluster(numcode)
	// keep if e(sample)
*******************************************************************************


// create wildcat_diff_binary 
gen wildcat_diff_binary = 1  if wildcat_diff>1.00e-05 & wildcat_diff!=. 
replace wildcat_diff_binary=0 if !(wildcat_diff>1.00e-05) & wildcat_diff!=. 

save "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/aspo_full_matching.dta", replace


keep if democracy>0.005
save "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/aspo_full_matching-demo.dta", replace

clear all 
use "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/aspo_full_matching.dta"
drop if democracy>0.005
save "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/aspo_full_matching-non-demo.dta", replace



*******************************************************************************

// using the set of determinants for matching in the original paper
// one-year lag by default

clear all
use "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/aspo_full_matching.dta"

* check propensity score
* should change that into ML
logit wildcat_diff_binary Llogoilres 
mfx
logit wildcat_diff_binary Lcrude1990P 
mfx	
logit wildcat_diff_binary Ldemocracy  
mfx
logit wildcat_diff_binary Lincidence2COW  
mfx
logit wildcat_diff_binary Llogoilres Lcrude1990P Ldemocracy Lincidence2COW 
mfx
logit wildcat_diff_binary Llogoilres Lcrude1990P Ldemocracy Lincidence2COW africa asia oceania southam
mfx	

*******************************************************************************
** To-do:
* for the purpose of matching get higher terms, interaction terms
	// gen o2=Llogoilres^2
	// gen dem2=Ldemocracy^2
	// gen dem3=Ldemocracy^3
	// gen odem=Llogoilres*Ldemocracy
	// gen o2dem=Llogoilres^2*Ldemocracy
	// gen crude2=Lcrude1990P^2
	// gen ocrude=Llogoilres*Lcrude1990P
	// gen warcrude=Lincidence2COW*Lcrude1990P
*******************************************************************************	


******************************************************************************
** logit or probit
*******************************************************************************

// Stratification and fixed effect
** should be done in ML
pscore wildcat o2 ocrude  odem Ldemocracy Lincidence2COW Llogoilres Lcrude1990P africa southam asia oceania, pscore(p1) blockid(b1) logit comsup numblo(8)

xi: reg d2incidence2COW logvaldisc         wildcat Llogvaloilres LlogGDP_M Lecgrowth Llogpop_M     Ldemocracy i.numcode i.decade i.b1, robust cluster(numcode)

xi: reg d2incidence2COW logvaldisc failure wildcat Llogvaloilres LlogGDP_M Lecgrowth Llogpop_M     Ldemocracy i.numcode i.decade i.b1, robust cluster(numcode)

xi: reg d2incidence2COW valdisc            wildcat Llogvaloilres LlogGDP_M Lecgrowth Llogpop_M     Ldemocracy i.numcode i.decade i.b1, robust cluster(numcode)
	

************************************************
** To-do:
** kernel matching
** kmatch
** psmatch2
************************************************


*******************************************************************************


// using a new set of covariates
// does not include Llogoilres Lcrude1990P africa southam asia oceania

// Propensity score matching - all sample
	// no lag
foreach `v' in onset2COWCS d2incidence2COW d3_6incidence2COW onsetUCS dincidenceU d3_6incidenceU{
	* clear all
	* use "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/aspo_full_matching.dta"
	* logit wildcat_diff_binary valoilres_diff ecgrowth popdens_diff democracy_diff logmountain ethnic_fractionalization religion_fractionalization language_fractionalization leg_british, robust cluster(numcode)
	teffects psmatch (`v') (wildcat_diff_binary valoilres_diff ecgrowth popdens_diff democracy_diff logmountain ethnic_fractionalization religion_fractionalization language_fractionalization leg_british, progit)
	* teffects psmatch (`v') (wildcat_diff_binary valoilres_diff ecgrowth popdens_diff democracy_diff logmountain ethnic_fractionalization religion_fractionalization language_fractionalization leg_british, progit), generate(stub)
	teffects psmatch (`v') (wildcat_diff_binary valoilres_diff ecgrowth popdens_diff democracy_diff logmountain ethnic_fractionalization religion_fractionalization language_fractionalization leg_british, progit)
	* teffects psmatch (`v') (wildcat_diff_binary valoilres_diff ecgrowth popdens_diff democracy_diff logmountain ethnic_fractionalization religion_fractionalization language_fractionalization leg_british, progit), generate(stub)
	* predict ps0 ps1, ps // The propensity scores for each group.
    * predict y0 y1, po // The potential outcome estimated for each group.
    * predict te // The treatment effect estimated for each group.
    * sum te
    * tebalance summarize
}



	// one year's lag
clear all
use "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/aspo_full_matching.dta"

teffects psmatch (onset2COWCS) (wildcat_diff_binary l1valoilres_diff l1ecgrowth l1popdens_diff l1democracy_diff l1logmountain l1ethnic_fractionalization l1religion_fractionalization l1language_fractionalization l1leg_british, logit), generate(stub)
	// teffects psmatch (onset2COWCS) (wildcat_diff_binary oilreserves_diff crude1990P logGDP_M ecgrowth popdens_diff democracy_diff logmountain ethnic_fractionalization religion_fractionalization language_fractionalization leg_british, logit), generate(stub)
	
predict ps0 ps1, ps // The propensity scores for each group.
predict y0 y1, po // The potential outcome estimated for each group.
predict te // The treatment effect estimated for each group.
summarise te
tebalance summarize


// Method two: stratification and fixed effect
** should be done in ML


*******************************************************************************


** change outcome
** change subsample


*******************************************************************************


* // success = binarized discovery
* gen success=1 if discoveryaspoPC>1.00e-05 & discoveryaspoPC!=. 
* replace success=0 if !(discoveryaspoPC>1.00e-05) & discoveryaspoPC!=. 
* 
* 
* // what predicts success in oil discovery
* 	// no lag
* logit success logvaloilres logGDP_M ecgrowth logpop_M logpopdens democracy logmountain ethnic_fractionalization religion_fractionalization language_fractionalization leg_british wildcat, robust cluster(numcode)
* 
* test logvaloilres logGDP_M ecgrowth logpop_M logpopdens democracy logmountain ethnic_fractionalization religion_fractionalization language_fractionalization leg_british wildcat
* 
* 	// one year's lag
* logit success L.logvaloilres L.logGDP_M L.ecgrowth L.logpop_M L.logpopdens L.democracy L.logmountain L.ethnic_fractionalization L.religion_fractionalization L.language_fractionalization L.leg_british L.wildcat, robust cluster(numcode)
* 
* test L.logvaloilres L.logGDP_M L.ecgrowth L.logpop_M L.logpopdens L.democracy L.logmountain L.ethnic_fractionalization L.religion_fractionalization L.language_fractionalization L.leg_british L.wildcat





