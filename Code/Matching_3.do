// load data
clear all
use "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/aspo_full.dta"

// declare panel data
tsset numcode year, yearly

// data cleaning
* drop obs with positive discovery and no wildcat
drop if newdiscovery_aspo>1.00e-05 & newdiscovery_aspo!=. & wildcat==1.00e-05 
* to improve readability
* replace valdisc=valdisc/100




*******************************************************************************
** To-do:
** 1. try standard estimation on the sample for matching
***** example: match on same sub-sample	
	// xi: reg dincidence2COW     logvaldisc wildcat Llogvaloilres LlogGDP_M Lecgrowth Llogpop_M              Ldemocracy i.numcode i.decade, robust cluster(numcode)
	// keep if e(sample)
*******************************************************************************



// success = binarized discovery
centile(discoveryaspoPC)
gen success=1 if discoveryaspoPC>1.00e-05 & discoveryaspoPC!=. 
replace success=0 if !(discoveryaspoPC>1.00e-05) & discoveryaspoPC!=. 


// what predicts success in oil discovery
	// no lag
logit success logvaloilres logGDP_M ecgrowth logpop_M logpopdens democracy logmountain ethnic_fractionalization religion_fractionalization language_fractionalization leg_british wildcat, robust cluster(numcode)

test logvaloilres logGDP_M ecgrowth logpop_M logpopdens democracy logmountain ethnic_fractionalization religion_fractionalization language_fractionalization leg_british wildcat

	// one year's lag
logit success L.logvaloilres L.logGDP_M L.ecgrowth L.logpop_M L.logpopdens L.democracy L.logmountain L.ethnic_fractionalization L.religion_fractionalization L.language_fractionalization L.leg_british L.wildcat, robust cluster(numcode)

test L.logvaloilres L.logGDP_M L.ecgrowth L.logpop_M L.logpopdens L.democracy L.logmountain L.ethnic_fractionalization L.religion_fractionalization L.language_fractionalization L.leg_british L.wildcat





*******************************************************************************

// create wildcat_diff_binary 
gen wildcat_diff_binary = 1  if wildcat_diff>1.00e-05 & wildcat_diff!=. 
replace wildcat_diff_binary=0 if !(wildcat_diff>1.00e-05) & wildcat_diff!=. 


*******************************************************************************

// using the set of determinants for matching in the original paper
// one-year lag by default

* check propensity score
* should change that into ML
logit wildcat Llogoilres 
mfx
logit wildcat Lcrude1990P 
mfx	
logit wildcat Ldemocracy  
mfx
logit wildcat Lincidence2COW  
mfx
logit wildcat Llogoilres Lcrude1990P Ldemocracy Lincidence2COW 
mfx
logit wildcat Llogoilres Lcrude1990P Ldemocracy Lincidence2COW africa asia oceania southam
mfx	

* for the purpose of matching get higher terms, interaction terms
	gen o2=Llogoilres^2
	gen dem2=Ldemocracy^2
	gen dem3=Ldemocracy^3
	gen odem=Llogoilres*Ldemocracy
	gen o2dem=Llogoilres^2*Ldemocracy
	gen crude2=Lcrude1990P^2
	gen ocrude=Llogoilres*Lcrude1990P
	gen warcrude=Lincidence2COW*Lcrude1990P
	
teffects psmatch (onset2COWCS) (wildcat_diff_binary logdiscoveryaspo logGDP_M ecgrowth)


pscore wildcat o2 ocrude  odem Ldemocracy Lincidence2COW Llogoilres Lcrude1990P africa southam asia oceania, pscore(p1) blockid(b1) logit comsup numblo(8)



*******************************************************************************



// what predicts success in wildcat_binary & matching
	// no lag
logit wildcat_diff_binary logvaloilres logGDP_M ecgrowth logpopdens democracy logmountain ethnic_fractionalization religion_fractionalization language_fractionalization leg_british, robust cluster(numcode)

test logvaloilres logGDP_M ecgrowth logpop_M logpopdens democracy logmountain ethnic_fractionalization religion_fractionalization language_fractionalization leg_british

teffects psmatch (onset2COWCS) (wildcat_diff_binary logdiscoveryaspo logGDP_M ecgrowth)

	// one year's lag
logit wildcat_diff_binary L.logvaloilres L.logGDP_M L.ecgrowth L.logpop_M L.logpopdens L.democracy L.logmountain L.ethnic_fractionalization L.religion_fractionalization L.language_fractionalization L.leg_british, robust cluster(numcode)

test L.logvaloilres L.logGDP_M L.ecgrowth L.logpop_M L.logpopdens L.democracy L.logmountain L.ethnic_fractionalization L.religion_fractionalization L.language_fractionalization L.leg_british 

teffects psmatch (onset2COWCS) (wildcat_diff_binary logdiscoveryaspo logGDP_M ecgrowth L.language_fractionalization L.leg_british)

	// diff, no lag
logit wildcat_diff_binary valoilres_diff logGDP_M ecgrowth popdens_diff democracy_diff logmountain ethnic_fractionalization religion_fractionalization language_fractionalization leg_british, robust cluster(numcode)

test valoilres_diff logGDP_M ecgrowth popdens_diff democracy_diff logmountain ethnic_fractionalization religion_fractionalization language_fractionalization leg_british

teffects psmatch (onset2COWCS) (wildcat_diff_binary valoilres_diff logGDP_M ecgrowth logmountain language_fractionalization)

teffects psmatch (onset2COWCS) (wildcat_diff_binary logGDP_M ecgrowth language_fractionalization)

