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
* to improve readability
* replace valdisc=valdisc/100

// define lagged variables
foreach v in milexgdpSIPRI_diff popdens_diff pop_M_diff valoilres_diff democracy_diff out_regdisaster_diff oilpop_impute_diff oilreserves_diff logGDP_M ecgrowth crude1990P{
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


*******************************************************************************

// using the set of determinants for matching in the original paper
// one-year lag by default

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


// Method one: Propensity score matching
******************************************************************************
** logit or probit
*******************************************************************************
	// ATE
teffects psmatch (onset2COWCS) (wildcat_diff_binary Llogoilres Lcrude1990P Ldemocracy Lincidence2COW africa asia oceania southam, logit)
teffects psmatch (onset2COWCS) (wildcat_diff_binary Llogoilres Lcrude1990P Ldemocracy Lincidence2COW africa asia oceania southam, probit)
predict ps0 ps1, ps // The propensity scores for each group.
predict y0 y1, po // The potential outcome estimated for each group.
predict te // The treatment effect estimated for each group.
summarise te
tebalance summarize
	// ATT
	teffects psmatch (onset2COWCS) (wildcat_diff_binary Llogoilres Lcrude1990P Ldemocracy Lincidence2COW africa asia oceania southam, logit), atet
teffects psmatch (onset2COWCS) (wildcat_diff_binary Llogoilres Lcrude1990P Ldemocracy Lincidence2COW africa asia oceania southam, probit), atet
predict ps0 ps1, ps // The propensity scores for each group.
predict y0 y1, po // The potential outcome estimated for each group.
predict te // The treatment effect estimated for each group.
summarise te
tebalance summarize


// Method two: stratification and fixed effect
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


// Method one: Propensity score matching
	// no lag
logit wildcat_diff_binary logvaloilres logGDP_M ecgrowth logpopdens democracy logmountain ethnic_fractionalization religion_fractionalization language_fractionalization leg_british
* logit wildcat_diff_binary logvaloilres logGDP_M ecgrowth logpopdens democracy logmountain ethnic_fractionalization religion_fractionalization language_fractionalization leg_british, robust cluster(numcode)
teffects psmatch (onset2COWCS) (wildcat_diff_binary logdiscoveryaspo logGDP_M ecgrowth, logit)
teffects psmatch (onset2COWCS) (wildcat_diff_binary logdiscoveryaspo logGDP_M ecgrowth, probit)

	// one year's lag
logit wildcat_diff_binary L1logvaloilres Ll1ogGDP_M L1ecgrowth L1logpop_M L1logpopdens L1democracy L1logmountain L1ethnic_fractionalization L1religion_fractionalization L1language_fractionalization L1leg_british

teffects psmatch (onset2COWCS) (wildcat_diff_binary L1logdiscoveryaspo L1logGDP_M L1ecgrowth L1language_fractionalization L1leg_british)





*******************************************************************************


// success = binarized discovery
gen success=1 if discoveryaspoPC>1.00e-05 & discoveryaspoPC!=. 
replace success=0 if !(discoveryaspoPC>1.00e-05) & discoveryaspoPC!=. 


// what predicts success in oil discovery
	// no lag
logit success logvaloilres logGDP_M ecgrowth logpop_M logpopdens democracy logmountain ethnic_fractionalization religion_fractionalization language_fractionalization leg_british wildcat, robust cluster(numcode)

test logvaloilres logGDP_M ecgrowth logpop_M logpopdens democracy logmountain ethnic_fractionalization religion_fractionalization language_fractionalization leg_british wildcat

	// one year's lag
logit success L.logvaloilres L.logGDP_M L.ecgrowth L.logpop_M L.logpopdens L.democracy L.logmountain L.ethnic_fractionalization L.religion_fractionalization L.language_fractionalization L.leg_british L.wildcat, robust cluster(numcode)

test L.logvaloilres L.logGDP_M L.ecgrowth L.logpop_M L.logpopdens L.democracy L.logmountain L.ethnic_fractionalization L.religion_fractionalization L.language_fractionalization L.leg_british L.wildcat





