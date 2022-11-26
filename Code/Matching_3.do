// load data
clear all
use "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/Comprehensive-Sample.dta"
// use "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/aspo_full.dta"
// use "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/comprehensive_new.dta"
// use "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/comprehensive_new_full.dta"
// keep incidence2COW discoveryaspoPC index onset2COWCS onsetUCS coup periregular numcode year ecgrowth logmountain ethnic_fractionalization religion_fractionalization language_fractionalization leg_british no_transition popdens_diff pop_maddison_diff democracy_diff wildcat_diff out_regdisaster_diff valoilres_diff valoilres_binarize valoilres_public_diff valoilres_public_binarize oilpop_diff oilpop_binarize valoilres_impute_diff valoilres_impute_binarize oilpop_impute_diff oilpop_impute_binarize milexp_pergdpSIPRI_diff

// declare panel data
tsset numcode year, yearly

// data cleaning
* drop if missing(wildcat)
* drop if missing(discoveryaspoPC)

*******************************************************************************


// success = binarized discovery
centile(discoveryaspoPC)
gen success=1 if discoveryaspoPC>0 & discoveryaspoPC!=. 
replace success=0 if discoveryaspoPC==0


// what predicts success in oil discovery
	// no lag
logit success logvaloilres logGDP_M ecgrowth logpop_M logpopdens democracy logmountain ethnic_fractionalization religion_fractionalization language_fractionalization leg_british wildcat, robust cluster(numcode)

test logvaloilres logGDP_M ecgrowth logpop_M logpopdens democracy logmountain ethnic_fractionalization religion_fractionalization language_fractionalization leg_british wildcat

	// one year's lag
logit success L.logvaloilres L.logGDP_M L.ecgrowth L.logpop_M L.logpopdens L.democracy L.logmountain L.ethnic_fractionalization L.religion_fractionalization L.language_fractionalization L.leg_british L.wildcat, robust cluster(numcode)

test L.logvaloilres L.logGDP_M L.ecgrowth L.logpop_M L.logpopdens L.democracy L.logmountain L.ethnic_fractionalization L.religion_fractionalization L.language_fractionalization L.leg_british L.wildcat


*******************************************************************************


// create wildcat_diff_binary 
gen wildcat_diff_binary = 1  if wildcat_diff>0 & wildcat_diff!=. 
replace wildcat_diff_binary=0 if wildcat_diff<0

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

