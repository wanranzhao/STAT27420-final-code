******************************************************************************
************************ STRATIFICATION AND FE *******************************
******************************************************************************

* foreach v in onset2COWCS d2incidence2COW d3_6incidence2COW onsetUCS dincidenceU d3_6incidenceU dcoup periregular milexgdpSIPRI_diff{
* 	**
* }

****************************** FULL SAMPLE ************************************ 

** use significance level of 0.05

************** no lag **************
* onset2COWCS
	* reinitialize the dataset
	clear all
	use "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/aspo_full_matching.dta"
	* work on the same sample
	reg onset2COWCS valdisc wildcat_diff_binary valoilres_diff ecgrowth popdens_diff democracy_diff i.numcode i.decade, robust cluster(numcode)
		keep if e(sample)
	* check propensity score
	logit wildcat_diff_binary valoilres_diff ecgrowth popdens_diff democracy_diff logmountain incidence2COW 
		mfx
	* pscore bloc
	pscore wildcat_diff_binary  valoilres_diff ecgrowth logmountain, pscore(p1) blockid(b1) logit comsup 
	* Stratification and fixed effect -- no lag
	reg onset2COWCS valdisc_binary wildcat_diff_binary  valoilres_diff ecgrowth popdens_diff democracy_diff i.numcode i.decade i.b1, robust cluster(numcode)
	* doubly robust IPW regression-adjusted ATE estimation
	teffects aipw (onset2COWCS valdisc  valoilres_diff ecgrowth popdens_diff democracy_diff logmountain  ethnic_fractionalization religion_fractionalization language_fractionalization leg_british) (wildcat_diff_binary valoilres_diff ecgrowth logmountain, probit)

* defense burden
	clear all
	use "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/aspo_full_matching.dta"
	reg milexgdpSIPRI_diff valdisc wildcat_diff_binary valoilres_diff ecgrowth popdens_diff democracy_diff i.numcode i.decade, robust cluster(numcode)
		keep if e(sample)
	logit wildcat_diff_binary valoilres_diff ecgrowth popdens_diff democracy_diff logmountain incidence2COW 
		mfx
	** no significant confounders for ps matching
	teffects ra (onset2COWCS valoilres_diff ecgrowth popdens_diff democracy_diff logmountain ethnic_fractionalization religion_fractionalization language_fractionalization leg_british) (wildcat_diff_binary)

******** one year lag **************
* onset2COWCS
	clear all
	use "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/aspo_full_matching.dta"
	reg onset2COWCS valdisc wildcat_diff_binary l1valoilres_diff l1ecgrowth l1popdens_diff l1democracy_diff i.numcode i.decade, robust cluster(numcode)
		keep if e(sample)
	logit wildcat_diff_binary l1valoilres_diff l1ecgrowth l1popdens_diff l1democracy_diff l1logmountain l1incidence2COW 
		mfx
	pscore wildcat_diff_binary l1ecgrowth, pscore(p1) blockid(b1) logit comsup 
	reg onset2COWCS valdisc_binary wildcat_diff_binary valoilres_diff ecgrowth popdens_diff democracy_diff i.numcode i.decade i.b1, robust cluster(numcode)
	teffects aipw (onset2COWCS l1valoilres_diff l1popdens_diff l1democracy_diff l1logmountain l1ethnic_fractionalization l1religion_fractionalization l1language_fractionalization l1leg_british) (wildcat_diff_binary l1ecgrowth, probit)
	
* defense burden
	clear all
	use "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/aspo_full_matching.dta"
	reg milexgdpSIPRI_diff valdisc wildcat_diff_binary l1valoilres_diff l1ecgrowth l1popdens_diff l1democracy_diff i.numcode i.decade, robust cluster(numcode)
		keep if e(sample) 
	logit wildcat_diff_binary  l1valoilres_diff l1ecgrowth l1popdens_diff l1democracy_diff l1logmountain l1incidence2COW 
		mfx
	pscore wildcat_diff_binary  l1valoilres_diff, pscore(p1) blockid(b1) logitcomsup 
	reg milexgdpSIPRI_diff valdisc_binary wildcat_diff_binary l1valoilres_diff l1ecgrowth l1popdens_diff l1democracy_diff i.numcode i.decade i.b1, robust cluster(numcode)
	teffects aipw (onset2COWCS popdens_diff democracy_diff logmountain ethnic_fractionalization religion_fractionalization language_fractionalization leg_british) (wildcat_diff_binary  valoilres_diff ecgrowth, probit)

	
****************************** DEMO SAMPLE ************************************ 

************ no lag **************
* onset2COWCS
	* reinitialize the dataset
	clear all
	use "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/aspo_full_matching-demo.dta"
	* work on the same sample
	reg onset2COWCS valdisc wildcat_diff_binary valoilres_diff ecgrowth popdens_diff democracy_diff i.numcode i.decade, robust cluster(numcode)
		keep if e(sample)
	* check propensity score
	logit wildcat_diff_binary  valoilres_diff ecgrowth popdens_diff democracy_diff logmountain incidence2COW 
		mfx
	** no significant confounders	

* defense burden
	clear all
	use "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/aspo_full_matching-demo.dta"
	reg milexgdpSIPRI_diff valdisc wildcat_diff_binary valoilres_diff ecgrowth popdens_diff democracy_diff i.numcode i.decade, robust cluster(numcode)
		keep if e(sample)
	logit wildcat_diff_binary  valoilres_diff ecgrowth popdens_diff democracy_diff logmountain incidence2COW 
		mfx
	** no significant confounders

******** one year lag **************
* onset2COWCS
	clear all
	use "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/aspo_full_matching-demo.dta"
	reg onset2COWCS valdisc wildcat_diff_binary l1valoilres_diff l1ecgrowth l1popdens_diff l1democracy_diff i.numcode i.decade, robust cluster(numcode)
		keep if e(sample)
	logit wildcat_diff_binary  l1valoilres_diff l1ecgrowth l1popdens_diff l1democracy_diff l1logmountain l1incidence2COW 
		mfx
	** no significant confounders

* defense burden
	clear all
	use "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/aspo_full_matching-demo.dta"
	reg milexgdpSIPRI_diff valdisc wildcat_diff_binary l1valoilres_diff l1ecgrowth l1popdens_diff l1democracy_diff i.numcode i.decade, robust cluster(numcode)
		keep if e(sample)
	logit wildcat_diff_binary  l1valoilres_diff l1ecgrowth l1popdens_diff l1democracy_diff l1logmountain l1incidence2COW 
		mfx
	pscore wildcat_diff_binary  l1valoilres_diff l1ecgrowth, pscore(p1) blockid(b1) logitcomsup 
	reg milexgdpSIPRI_diff valdisc_binary wildcat_diff_binary l1valoilres_diff l1ecgrowth l1popdens_diff l1democracy_diff i.numcode i.decade i.b1, robust cluster(numcode)
	** signficant l1valoilres_diff 


	
*************************** NON-DEMO SAMPLE *********************************** 

************ no lag **************
* onset2COWCS
	* reinitialize the dataset
	clear all
	use "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/aspo_full_matching-non-demo.dta"
	reg onset2COWCS valdisc wildcat_diff_binary valoilres_diff ecgrowth popdens_diff democracy_diff i.numcode i.decade, robust cluster(numcode)
		keep if e(sample)
	logit wildcat_diff_binary  valoilres_diff ecgrowth popdens_diff democracy_diff logmountain incidence2COW 
		mfx
	pscore wildcat_diff_binary  ecgrowth, pscore(p1) blockid(b1) logitcomsup 
	reg onset2COWCS valdisc_binary wildcat_diff_binary valoilres_diff ecgrowth popdens_diff democracy_diff i.numcode i.decade i.b1, robust cluster(numcode)	

* defense burden
	clear all
	use "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/aspo_full_matching-non-demo.dta"
	reg milexgdpSIPRI_diff valdisc wildcat_diff_binary valoilres_diff ecgrowth popdens_diff democracy_diff i.numcode i.decade, robust cluster(numcode)
		keep if e(sample)
	logit wildcat_diff_binary  valoilres_diff ecgrowth popdens_diff democracy_diff logmountain incidence2COW 
		mfx
	** no significant confounders

******** one year lag **************
* onset2COWCS
	clear all
	use "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/aspo_full_matching-non-demo.dta"
	reg onset2COWCS valdisc wildcat_diff_binary l1valoilres_diff l1ecgrowth l1popdens_diff l1democracy_diff i.numcode i.decade, robust cluster(numcode)
		keep if e(sample)
	logit wildcat_diff_binary  l1valoilres_diff l1ecgrowth l1popdens_diff l1democracy_diff l1logmountain l1incidence2COW 
		mfx
	** no significant confounders

* defense burden
	clear all
	use "/Users/zwanran/Desktop/STAT27420/Final/STAT27420-final-code/Data/data/aspo_full_matching-non-demo.dta"
	reg milexgdpSIPRI_diff valdisc wildcat_diff_binary l1valoilres_diff l1ecgrowth l1popdens_diff l1democracy_diff i.numcode i.decade, robust cluster(numcode)
		keep if e(sample)
	logit wildcat_diff_binary  l1valoilres_diff l1ecgrowth l1popdens_diff l1democracy_diff l1logmountain l1incidence2COW 
		mfx
	** no significant confounders


********************************************************************************
* check propensity score
* logitwildcat_diff_binary  oilreserves_diff crude1990P_diff ecgrowth popdens_diff democracy_diff logmountain incidence2COW 
** pscore block
* pscore wildcat ecgrowth, pscore(p2) blockid(b2) logitcomsup numblo(8)

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

************************************************
** To-do:
** kernel matching
** kmatch
** psmatch2
************************************************







