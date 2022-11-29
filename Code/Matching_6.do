******************************************************************************
************************ STRATIFICATION AND FE *******************************
******************************************************************************

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







