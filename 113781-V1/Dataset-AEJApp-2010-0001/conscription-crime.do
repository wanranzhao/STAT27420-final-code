clear
cap log close
set more off
set memory 250m
set matsize 3000
set maxvar 3000

log using Crime.log, replace

* Figure 1

use Compliers.dta, clear

set obs 95
replace cohort = 1956 in 95
set obs 96
replace cohort = 1957 in 96
sort cohort
set more on
line proporcinquelah cohort if cohort<1976, cmissing(n)
set more off
clear

use Crime.dta, clear

keep if cohort>1957 & cohort<1963
keep cohort draftnumber enfdummy

sort cohort draftnumber
gen smooth_id=0

forvalues i=5(5)1000 {
replace smooth_id=`i' if draftnumber<=`i' &  draftnumber>`i'-5 & cohort==1958
}

forvalues i=5(5)1000 {
replace smooth_id=`i' if draftnumber<=`i' &  draftnumber>`i'-5 & cohort==1959
}

forvalues i=5(5)1000 {
replace smooth_id=`i' if draftnumber<=`i' &  draftnumber>`i'-5 & cohort==1960
}

forvalues i=5(5)1000 {
replace smooth_id=`i' if draftnumber<=`i' &  draftnumber>`i'-5 & cohort==1961
}

forvalues i=5(5)1000 {
replace smooth_id=`i' if draftnumber<=`i' &  draftnumber>`i'-5 & cohort==1962
}

collapse (mean)  draftnumber enfdummy, by( cohort smooth_id)

twoway (line enfdummy draftnumber if cohort==1958, sort lcolor(black) lwidth(thick)), ytitle(, color(white)) ylabel(0.01(0.01)0.12) xtitle(, color(white)) xlabel(0(100)1000) xline(24 174, lwidth(medthick) lcolor(gs9) lpattern(dash) )
twoway (line enfdummy draftnumber if cohort==1959, sort lcolor(black) lwidth(thick)), ytitle(, color(white)) ylabel(0.01(0.01)0.12) xtitle(, color(white)) xlabel(0(100)1000) xline(319 174, lwidth(medthick) lcolor(gs9) lpattern(dash))
twoway (line enfdummy draftnumber if cohort==1960, sort lcolor(black) lwidth(thick)), ytitle(, color(white)) ylabel(0.01(0.01)0.12) xtitle(, color(white)) xlabel(0(100)1000) xline(340 319, lwidth(medthick) lcolor(gs9) lpattern(dash))
twoway (line enfdummy draftnumber if cohort==1961, sort lcolor(black) lwidth(thick)), ytitle(, color(white)) ylabel(0.01(0.01)0.12) xtitle(, color(white)) xlabel(0(100)1000) xline(349 340, lwidth(medthick) lcolor(gs9) lpattern(dash))
twoway (line enfdummy draftnumber if cohort==1962, sort lcolor(black) lwidth(thick)), ytitle(, color(white)) ylabel(0.01(0.01)0.12) xtitle(, color(white)) xlabel(0(100)1000) xline(319 349, lwidth(medthick) lcolor(gs9) lpattern(dash))

clear

* Figures in the online appendix

use Crime.dta

collapse crimerate, by(cohort highnumber)
gen eligible=crimerate*highnumber
gen ineligible=crimerate*(1-highnumber)
collapse (sum) eligible ineligible, by(cohort)
set more on
line eligible ineligible cohort if cohort>=1958 & cohort<=1962
set more off
clear

use Crime.dta

egen crimrateavg=mean(crimerate), by(cohort)
set more on
line crimrateavg cohort, xline(1956 1957 1976)
set more off
clear

use Crime.dta

* Summary statistics

summarize highnumber sm navy malvinas crimerate arms property sexual murder threat drug whitecollar formal unemployment income argentine indigenous naturalized dist* if cohort > 1957 & cohort < 1963 

* Table 2: test for pre-treatment characteristics

gen cohorttests=cohort if cohort>=1958 & cohort<=1962
sort cohorttests

by cohorttests: ttest argentine, by(highnumber) unequal
by cohorttests: ttest indigenous, by(highnumber) unequal
by cohorttests: ttest naturalized, by(highnumber) unequal

* Footnote 19: balancing of pre-treatment province of residence 

by cohorttests: ttest dist1, by(highnumber) unequal
by cohorttests: ttest dist2, by(highnumber) unequal
by cohorttests: ttest dist3, by(highnumber) unequal
by cohorttests: ttest dist4, by(highnumber) unequal
by cohorttests: ttest dist5, by(highnumber) unequal
by cohorttests: ttest dist6, by(highnumber) unequal
by cohorttests: ttest dist7, by(highnumber) unequal
by cohorttests: ttest dist8, by(highnumber) unequal
by cohorttests: ttest dist9, by(highnumber) unequal
by cohorttests: ttest dist10, by(highnumber) unequal
by cohorttests: ttest dist11, by(highnumber) unequal
by cohorttests: ttest dist12, by(highnumber) unequal
by cohorttests: ttest dist13, by(highnumber) unequal
by cohorttests: ttest dist14, by(highnumber) unequal
by cohorttests: ttest dist15, by(highnumber) unequal
by cohorttests: ttest dist16, by(highnumber) unequal
by cohorttests: ttest dist17, by(highnumber) unequal
by cohorttests: ttest dist18, by(highnumber) unequal
by cohorttests: ttest dist19, by(highnumber) unequal
by cohorttests: ttest dist20, by(highnumber) unequal
by cohorttests: ttest dist21, by(highnumber) unequal
by cohorttests: ttest dist22, by(highnumber) unequal
by cohorttests: ttest dist23, by(highnumber) unequal
by cohorttests: ttest dist24, by(highnumber) unequal

* Footnote 19: balancing of pre-treatment characteristics in a regression framework

regress highnumber argentine indigenous naturalized dist*

* Online appendix: differences in failure rates in the medical examination by eligibility group and cohort 

gen cutoff=.

replace cutoff=174 if cohort==1958
replace cutoff=319 if cohort==1959
replace cutoff=340 if cohort==1960
replace cutoff=349 if cohort==1961
replace cutoff=319 if cohort==1962

ttest enfdummy if cohort==1958, by(highnumber) unequal
ttest enfdummy if cohort==1959, by(highnumber) unequal
ttest enfdummy if cohort==1960, by(highnumber) unequal
ttest enfdummy if cohort==1961, by(highnumber) unequal
ttest enfdummy if cohort==1962, by(highnumber) unequal

* Failure rates by eligibility status for those individuals whose draft numbers were within twenty, fifteen, and ten numbers around the final cutoff number

ttest enfdummy if cohort==1958 & draftnumber>cutoff-20 & draftnumber<=cutoff+20, by(highnumber) unequal
ttest enfdummy if cohort==1959 & draftnumber>cutoff-20 & draftnumber<=cutoff+20, by(highnumber) unequal
ttest enfdummy if cohort==1960 & draftnumber>cutoff-20 & draftnumber<=cutoff+20, by(highnumber) unequal
ttest enfdummy if cohort==1961 & draftnumber>cutoff-20 & draftnumber<=cutoff+20, by(highnumber) unequal
ttest enfdummy if cohort==1962 & draftnumber>cutoff-20 & draftnumber<=cutoff+20, by(highnumber) unequal

ttest enfdummy if cohort==1958 & draftnumber>cutoff-15 & draftnumber<=cutoff+15, by(highnumber) unequal
ttest enfdummy if cohort==1959 & draftnumber>cutoff-15 & draftnumber<=cutoff+15, by(highnumber) unequal
ttest enfdummy if cohort==1960 & draftnumber>cutoff-15 & draftnumber<=cutoff+15, by(highnumber) unequal
ttest enfdummy if cohort==1961 & draftnumber>cutoff-15 & draftnumber<=cutoff+15, by(highnumber) unequal
ttest enfdummy if cohort==1962 & draftnumber>cutoff-15 & draftnumber<=cutoff+15, by(highnumber) unequal

ttest enfdummy if cohort==1958 & draftnumber>cutoff-10 & draftnumber<=cutoff+10, by(highnumber) unequal
ttest enfdummy if cohort==1959 & draftnumber>cutoff-10 & draftnumber<=cutoff+10, by(highnumber) unequal
ttest enfdummy if cohort==1960 & draftnumber>cutoff-10 & draftnumber<=cutoff+10, by(highnumber) unequal
ttest enfdummy if cohort==1961 & draftnumber>cutoff-10 & draftnumber<=cutoff+10, by(highnumber) unequal
ttest enfdummy if cohort==1962 & draftnumber>cutoff-10 & draftnumber<=cutoff+10, by(highnumber) unequal

drop cutoff

* Footnote 21: use the previous year's cutoff

gen cutoff=.

replace cutoff=24 if cohort==1958
replace cutoff=174 if cohort==1959
replace cutoff=319 if cohort==1960
replace cutoff=340 if cohort==1961
replace cutoff=349 if cohort==1962

gen highnumber1=0
replace highnumber1=1 if cohort==1958 & draftnumber>24
replace highnumber1=1 if cohort==1959 & draftnumber>174
replace highnumber1=1 if cohort==1960 & draftnumber>319
replace highnumber1=1 if cohort==1961 & draftnumber>340
replace highnumber1=1 if cohort==1962 & draftnumber>349
 
ttest enfdummy if cohort==1958, by(highnumber1) unequal
ttest enfdummy if cohort==1959, by(highnumber1) unequal
ttest enfdummy if cohort==1960, by(highnumber1) unequal
ttest enfdummy if cohort==1961, by(highnumber1) unequal
ttest enfdummy if cohort==1962, by(highnumber1) unequal

ttest enfdummy if cohort==1958 & draftnumber>cutoff-20 & draftnumber<=cutoff+20, by(highnumber1) unequal
ttest enfdummy if cohort==1959 & draftnumber>cutoff-20 & draftnumber<=cutoff+20, by(highnumber1) unequal
ttest enfdummy if cohort==1960 & draftnumber>cutoff-20 & draftnumber<=cutoff+20, by(highnumber1) unequal
ttest enfdummy if cohort==1961 & draftnumber>cutoff-20 & draftnumber<=cutoff+20, by(highnumber1) unequal
ttest enfdummy if cohort==1962 & draftnumber>cutoff-20 & draftnumber<=cutoff+20, by(highnumber1) unequal

ttest enfdummy if cohort==1958 & draftnumber>cutoff-15 & draftnumber<=cutoff+15, by(highnumber1) unequal
ttest enfdummy if cohort==1959 & draftnumber>cutoff-15 & draftnumber<=cutoff+15, by(highnumber1) unequal
ttest enfdummy if cohort==1960 & draftnumber>cutoff-15 & draftnumber<=cutoff+15, by(highnumber1) unequal
ttest enfdummy if cohort==1961 & draftnumber>cutoff-15 & draftnumber<=cutoff+15, by(highnumber1) unequal
ttest enfdummy if cohort==1962 & draftnumber>cutoff-15 & draftnumber<=cutoff+15, by(highnumber1) unequal

ttest enfdummy if cohort==1958 & draftnumber>cutoff-10 & draftnumber<=cutoff+10, by(highnumber1) unequal
ttest enfdummy if cohort==1959 & draftnumber>cutoff-10 & draftnumber<=cutoff+10, by(highnumber1) unequal
ttest enfdummy if cohort==1960 & draftnumber>cutoff-10 & draftnumber<=cutoff+10, by(highnumber1) unequal
ttest enfdummy if cohort==1961 & draftnumber>cutoff-10 & draftnumber<=cutoff+10, by(highnumber1) unequal
ttest enfdummy if cohort==1962 & draftnumber>cutoff-10 & draftnumber<=cutoff+10, by(highnumber1) unequal

drop cutoff highnumber1

* Table 3: first stage regression

areg sm highnumber if cohort > 1957 & cohort < 1963, robust absorb(cohort)
regress sm highnumber if cohort == 1958, robust
regress sm highnumber if cohort == 1959, robust
regress sm highnumber if cohort == 1960, robust
regress sm highnumber if cohort == 1961, robust
regress sm highnumber if cohort == 1962, robust

* Mean of dependent variables (used for % change)

summ crimerate if cohort > 1957 & cohort < 1963 & highnumber==0
summ crimerate if cohort > 1957 & cohort < 1966 & highnumber==0
summ crimerate if cohort > 1928 & cohort < 1956 & highnumber==0
summ crimerate if cohort > 1928 & cohort < 1966 & highnumber==0
summ formal if cohort > 1957 & cohort < 1963 & highnumber==0
summ unemployment if cohort > 1957 & cohort < 1963 & highnumber==0
summ income if cohort > 1957 & cohort < 1963 & highnumber==0
summ formal if cohort > 1957 & cohort < 1966 & highnumber==0
summ unemployment if cohort > 1957 & cohort < 1966 & highnumber==0
summ income if cohort > 1957 & cohort < 1966 & highnumber==0

* Table 4: main results

areg crimerate highnumber if cohort > 1957 & cohort < 1963, robust absorb(cohort)
areg crimerate highnumber indigenous naturalized dist* if cohort > 1957 & cohort < 1963, robust absorb(cohort)
areg crimerate sm if cohort > 1957 & cohort < 1963, robust absorb(cohort)
areg crimerate sm indigenous naturalized dist* if cohort > 1957 & cohort < 1963, robust absorb(cohort)
xi: ivreg crimerate (sm = highnumber) i.cohort if cohort > 1957 & cohort < 1963, robust 
xi: ivreg crimerate (sm = highnumber) indigenous naturalized dist* i.cohort if cohort > 1957 & cohort < 1963, robust 
areg crimerate highnumber if cohort > 1928 & cohort < 1966, robust absorb(cohort)
areg crimerate highnumber if cohort > 1928 & cohort < 1957, robust absorb(cohort)
areg crimerate highnumber if cohort > 1956 & cohort < 1966, robust absorb(cohort)

* Footnote 24: similar results if we control for draftnumber and navy 

areg crimerate highnumber draftnumber navy if cohort > 1957 & cohort < 1963, robust absorb(cohort)
areg crimerate highnumber indigenous naturalized dist* draftnumber navy if cohort > 1957 & cohort < 1963, robust absorb(cohort)
areg crimerate sm draftnumber navy if cohort > 1957 & cohort < 1963, robust absorb(cohort)
areg crimerate sm indigenous naturalized dist* draftnumber navy if cohort > 1957 & cohort < 1963, robust absorb(cohort)
xi: ivreg crimerate (sm = highnumber) draftnumber navy i.cohort if cohort > 1957 & cohort < 1963, robust 
xi: ivreg crimerate (sm = highnumber) indigenous naturalized dist* draftnumber navy i.cohort if cohort > 1957 & cohort < 1963, robust 
areg crimerate highnumber draftnumber navy if cohort > 1928 & cohort < 1966, robust absorb(cohort)
areg crimerate highnumber draftnumber navy if cohort > 1928 & cohort < 1957, robust absorb(cohort)
areg crimerate highnumber draftnumber navy if cohort > 1956 & cohort < 1966, robust absorb(cohort)

* Footnote 24: similar results when instead of draftnumber we control for the distance of the number to the cutoff

gen cutoff=.

replace cutoff=150 if cohort==1929
replace cutoff=136 if cohort==1930
replace cutoff=1 if cohort==1931
replace cutoff=1 if cohort==1932
replace cutoff=1 if cohort==1933
replace cutoff=60 if cohort==1934
replace cutoff=1 if cohort==1935
replace cutoff=1 if cohort==1936
replace cutoff=98 if cohort==1937
replace cutoff=1 if cohort==1938
replace cutoff=61 if cohort==1939
replace cutoff=53 if cohort==1940
replace cutoff=1 if cohort==1941
replace cutoff=41 if cohort==1942
replace cutoff=112 if cohort==1943
replace cutoff=229 if cohort==1944
replace cutoff=262 if cohort==1945
replace cutoff=209 if cohort==1946
replace cutoff=279 if cohort==1947
replace cutoff=294 if cohort==1948
replace cutoff=214 if cohort==1949
replace cutoff=214 if cohort==1950
replace cutoff=129 if cohort==1951
replace cutoff=124 if cohort==1952
replace cutoff=144 if cohort==1953
replace cutoff=69 if cohort==1954
replace cutoff=24 if cohort==1955
replace cutoff=174 if cohort==1958
replace cutoff=319 if cohort==1959
replace cutoff=340 if cohort==1960
replace cutoff=349 if cohort==1961
replace cutoff=319 if cohort==1962
replace cutoff=349 if cohort==1963
replace cutoff=399 if cohort==1964
replace cutoff=358 if cohort==1965

gen distancecutoff=.
replace distancecutoff=draftnumber-cutoff if draftnumber>=cutoff
replace distancecutoff=cutoff-draftnumber if draftnumber<cutoff

areg crimerate highnumber distancecutoff navy if cohort > 1957 & cohort < 1963, robust absorb(cohort)
areg crimerate highnumber indigenous naturalized dist* distancecutoff navy if cohort > 1957 & cohort < 1963, robust absorb(cohort)
areg crimerate sm distancecutoff navy if cohort > 1957 & cohort < 1963, robust absorb(cohort)
areg crimerate sm indigenous naturalized dist* distancecutoff navy if cohort > 1957 & cohort < 1963, robust absorb(cohort)
xi: ivreg crimerate (sm = highnumber) distancecutoff navy i.cohort if cohort > 1957 & cohort < 1963, robust 
xi: ivreg crimerate (sm = highnumber) indigenous naturalized dist* distancecutoff navy i.cohort if cohort > 1957 & cohort < 1963, robust 
areg crimerate highnumber distancecutoff navy if cohort > 1928 & cohort < 1966, robust absorb(cohort)
areg crimerate highnumber distancecutoff navy if cohort > 1928 & cohort < 1957, robust absorb(cohort)
areg crimerate highnumber distancecutoff navy if cohort > 1956 & cohort < 1966, robust absorb(cohort)

* footnote 24: results remain unchanged when we control in the first stage for the lottery number 

areg sm highnumber draftnumber if cohort > 1957 & cohort < 1963, robust absorb(cohort)
areg sm highnumber distancecutoff if cohort > 1957 & cohort < 1963, robust absorb(cohort)

areg sm highnumber draftnumber navy if cohort > 1957 & cohort < 1963, robust absorb(cohort)
areg sm highnumber distancecutoff navy if cohort > 1957 & cohort < 1963, robust absorb(cohort)

drop distancecutoff

* Footnote 25: alternative denominator for crime rates

gen crimerateII=crimrecordi/denom

areg crimerateII highnumber if cohort > 1957 & cohort < 1963, robust absorb(cohort)
areg crimerateII highnumber indigenous naturalized dist* if cohort > 1957 & cohort < 1963, robust absorb(cohort)
areg crimerateII sm if cohort > 1957 & cohort < 1963, robust absorb(cohort)
areg crimerateII sm indigenous naturalized dist* if cohort > 1957 & cohort < 1963, robust absorb(cohort)
xi: ivreg crimerateII (sm = highnumber) i.cohort if cohort > 1957 & cohort < 1963, robust 
xi: ivreg crimerateII (sm = highnumber) indigenous naturalized dist* i.cohort if cohort > 1957 & cohort < 1963, robust 

drop crimerateII

* Footnote 26: similar results using sample until 1975

areg crimerate highnumber if cohort > 1928 & cohort < 1976, robust absorb(cohort)
areg crimerate highnumber if cohort > 1956 & cohort < 1976, robust absorb(cohort)

* False experiment II: faked highnumber for cohort 1976

gen fakehigh=.
replace fakehigh=1 if cohort==1976 & draftnumber>754 
replace fakehigh=0 if cohort==1976 & draftnumber<=754

regress crimerate fakehigh if cohort==1976 
regress crimerate fakehigh if cohort==1976, robust 

drop fakehigh

* Table 5: peace vs war times and 1-year vs 2-years

gen hnmalvinas = highnumber*malvinas

* Malvinas

areg crimerate highnumber hnmalvinas if cohort > 1928 & cohort < 1966, absorb(cohort) robust
areg crimerate highnumber hnmalvinas if cohort > 1956 & cohort < 1966, absorb(cohort) robust

* Navy

areg crimerate highnumber navy if cohort > 1928 & cohort < 1966, absorb(cohort) robust
areg crimerate highnumber navy if cohort > 1956 & cohort < 1966, absorb(cohort) robust

* Footnote 31: combine the intention-to-treat Malvinas War and Navy variables with the 
* treatment variable Conscription in 2SLS regressions for the 1958-62 cohorts

xi: ivreg crimerate (sm = highnumber) hnmalvinas i.cohort if cohort > 1957 & cohort < 1963, robust 
xi: ivreg crimerate (sm = highnumber) navy i.cohort if cohort > 1957 & cohort < 1963, robust 

drop hnmalvinas

* Footnote 32: similar results during military governments

gen hnmilitary = highnumber*military

areg crimerate highnumber hnmilitary if cohort > 1957 & cohort < 1966, absorb(cohort) robust

drop hnmilitary

* Table 7: job market outcomes 

* Participation in the formal job market

areg formal highnumber if cohort > 1956 & cohort < 1963, robust absorb(cohort)
xi: ivreg formal (sm = highnumber) i.cohort if cohort > 1956 & cohort < 1963, robust 
areg formal highnumber if cohort > 1956 & cohort < 1966, robust absorb(cohort)

* Unemployment rate

areg unemployment highnumber if cohort > 1956 & cohort < 1963, robust absorb(cohort)
xi: ivreg unemployment (sm = highnumber) i.cohort if cohort > 1956 & cohort < 1963, robust 
areg unemployment highnumber if cohort > 1956 & cohort < 1966, robust absorb(cohort)

* Earnings

areg income highnumber if cohort > 1956 & cohort < 1963, robust absorb(cohort)
xi: ivreg income (sm = highnumber) i.cohort if cohort > 1956 & cohort < 1963, robust 
areg income highnumber if cohort > 1956 & cohort < 1966, robust absorb(cohort)

* Footnote 35: job market outcomes in alternative sample

areg formal highnumber if cohort > 1928 & cohort < 1956, robust absorb(cohort)
areg unemployment highnumber if cohort > 1928 & cohort < 1956, robust absorb(cohort)
areg income highnumber if cohort > 1928 & cohort < 1956, robust absorb(cohort)

* Table 6: type of crime

xi: ivreg arms (sm = highnumber) i.cohort if cohort > 1956 & cohort < 1963, robust 
xi: ivreg property (sm = highnumber) i.cohort if cohort > 1956 & cohort < 1963, robust 
xi: ivreg sexual (sm = highnumber) i.cohort if cohort > 1956 & cohort < 1963, robust 
xi: ivreg murder (sm = highnumber) i.cohort if cohort > 1956 & cohort < 1963, robust 
xi: ivreg threat (sm = highnumber) i.cohort if cohort > 1956 & cohort < 1963, robust 
xi: ivreg drug (sm = highnumber) i.cohort if cohort > 1956 & cohort < 1963, robust 
xi: ivreg whitecollar (sm = highnumber) i.cohort if cohort > 1956 & cohort < 1963, robust 

* False experiment I: fake low numbers

xi: regress crimerate falselow2 i.cohort if low2==1 & cohort > 1957 & cohort < 1963, robust

* False experiment II: cohorts 1956 and 1957 

preserve
keep if cohort == 1958
rename low2 low2A
replace cohort = 1956
keep idnumber cohort low2A
tempfile b1
save "`b1'", replace

restore
preserve
keep if cohort == 1959
rename low2 low2A
replace cohort = 1957
keep idnumber cohort low2A
app using "`b1'"

sort cohort idnumber
save "`b1'", replace

restore
keep if cohort == 1956 | cohort == 1957
sort cohort idnumber
merge cohort idnumber using "`b1'"

xi: regress crimerate low2A i.cohort, robust

* Footnote 12: Eligibility into the military service is not correlated with missing crime types in the alternative database

use baseA.dta, clear

areg crimratecrimrecord_aI2 highnumber if clase > 1928 & clase < 1966, robust absorb(clase)
areg crimratecrimrecord_aI2 highnumber if clase > 1928 & clase < 1957, robust absorb(clase)
areg crimratecrimrecord_aI2 highnumber if clase > 1956 & clase < 1966, robust absorb(clase)

use baseB.dta, clear

areg crimratecrimrecord_bI2 highnumber if clase > 1928 & clase < 1966, robust absorb(clase)
areg crimratecrimrecord_bI2 highnumber if clase > 1928 & clase < 1957, robust absorb(clase)
areg crimratecrimrecord_bI2 highnumber if clase > 1956 & clase < 1966, robust absorb(clase)

use baseC.dta, clear

areg crimratecrimrecord_cI2 highnumber if clase > 1928 & clase < 1966, robust absorb(clase)
areg crimratecrimrecord_cI2 highnumber if clase > 1928 & clase < 1957, robust absorb(clase)
areg crimratecrimrecord_cI2 highnumber if clase > 1956 & clase < 1966, robust absorb(clase)

log close


