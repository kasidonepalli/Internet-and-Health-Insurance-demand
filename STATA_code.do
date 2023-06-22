cd "C:\Users\91798\Desktop\flame\sem-6\econometrics\research"

use 36151-0002-Data, clear

//creating new dummy variable for health insurance status of household: if has government or private insurance

gen HHealth_Ins =0
replace HHealth_Ins = 1 if  IN15B1== 1 | IN15B2== 1
replace HHealth_Ins = 0 if  IN15B1== 0 & IN15B2== 0
tab HHealth_Ins

//creating a proxy dummy for internet access to household: =1 if household has a computer or laptop or a mobile


gen Int_access=.
replace Int_access=1 if CGCOMPUTER==1 | MM10==1
replace Int_access=0 if CGCOMPUTER==0 & MM10==0

//Creating a grouped caste variable from ID13(castes classification):
gen caste=.
replace caste=0 if ID13==1 | ID13==2 | ID13==3
replace caste=1 if ID13==4
replace caste=2 if ID13==5
replace caste=3 if ID13==6

label define caste 0 "General" 1 "SC" 2 "ST" 3 "other"
label value caste caste
tab caste

//Creating a religion variable with new groups from ID11
gen religion=.
replace religion=0 if ID11==1 //hindu
replace religion=1 if ID11==2 //muslim
replace religion=2 if ID11==3 //christian
replace religion=3 if ID11==4 |ID11==5 | ID11==6 | ID11==7 | ID11== 8 | ID11== 9 //grouping sikhs, buddhism, jain, tribal, other & none

label define religion 0"Hindu" 1 "Muslim" 2 "Christian" 3 " Other"
label value religion religion
tab religion

//URBAN2011- rural or urban household- rename to urban
rename URBAN2011 urban
tab urban

//MI1- Major illness/Accidents - large amount of expenditure/loss
tab MI1

//variable to check for financial security of household = 1 if has bought securities/fixed deposits/bank savings/part of credit society/has post office account/pension,LIC

 gen fin_secure=.
 replace fin_secure=1 if DB9C==1 | DB9D==1 | DB9E==1 | DB9F==1 |DB9G==1 | DB9H==1
 replace fin_secure=0 if DB9C==0 & DB9D==1 & DB9E==0 & DB9F==0 & DB9G==0 & DB9H==0
 tab fin_secure
 
 tab CI9
 
 //regrouping confidence in government hospitals and doctors to provide good care ,as =1 if confident else 0, little to no confidence.
gen conf_ghosp=.
replace conf_ghosp=1 if CI9==1
replace  conf_ghosp=0 if CI9==2 | CI9==3
label define conf_ghosp 1 "confident in ghosp" 0 "little to no confidence in ghosp"
label value conf_ghosp conf_ghosp
tab conf_ghosp

 //regrouping confidence in courts to deliver justice,as =1 if confident else 0, little to no confidence.
 gen conf_courts=.
 replace conf_courts=1 if CI11==1
 replace conf_courts=0 if CI11==2 | CI11==3
 label define conf_courts 1 "confident on courts" 0 "little to no confidence on courts"
 label value conf_courts conf_courts
 tab conf_courts
 
 //regrouping confidence in banks to keep money safe,as =1 if confident else 0, little to no confidence.
 gen conf_banks=.
 replace conf_banks=1 if CI12==1
 replace conf_banks=0 if CI12==2 | CI12==3
 label define conf_banks 1 "confident on banks" 0 "little to no confidence on banks"
 label value conf_banks conf_banks
 tab conf_banks
 
 //rename male-head age variable
 rename MHEADAGE head_age
 
 rename DB1 debt
 
 //regrouping highest adult education into <10th,10th pass , 12th pass, >12th
 gen educ_level = .
 replace educ_level=0 if HHEDUC==0 | HHEDUC==1 | HHEDUC==2 | HHEDUC==3 | HHEDUC==4 | HHEDUC==5 | HHEDUC==6 | HHEDUC==7 | HHEDUC==8 | HHEDUC==9 
 replace educ_level= 1 if HHEDUC==10 | HHEDUC==11
 replace educ_level= 2 if HHEDUC==12 | HHEDUC==13
 replace educ_level=3 if HHEDUC==14 | HHEDUC==15 | HHEDUC==16
 label define educ_level 0 "<10th" 1 "10th pass" 2 "12th pass" 3 ">12th"
 label value educ_level educ_level
 tab educ_level
 
 rename INCOME income
 rename MI1 major_illness
 rename NPERSONS N_persons
 
 //creating a new variable for confidence in government to look after people , = 1 if confident,else 0, if little to no confidence
 gen conf_gov = .
 replace conf_gov=1 if CI4==1
 replace conf_gov=0 if CI4==2 | CI4==3
 label define conf_gov 1 "confident on gov" 0 "little to no confidence on gov"
 label value conf_gov conf_gov
 tab conf_gov


probit HHealth_Ins Int_access i.caste i.religion major_illness urban fin_secure conf_ghosp conf_banks conf_gov conf_courts N_persons income debt head_age i.educ_level

probit HHealth_Ins Int_access  i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov conf_courts N_persons income debt head_age i.educ_level if urban==1

probit HHealth_Ins Int_access  i.religion major_illness  fin_secure conf_ghosp conf_banks conf_gov conf_courts N_persons income debt head_age i.educ_level if urban==0

//graphs
 graph bar (count), over(HHealth_Ins) over(urban)
 graph bar (count), over(Int_access) over(urban)
 graph bar (count), over(Int_access) over(educ_level)
 graph bar (count), over(HHealth_Ins) over(religion)
 
 drop if income<0
 
tabstat HHealth_Ins Int_access caste religion major_illness fin_secure conf_ghosp conf_banks conf_gov income conf_courts N_persons debt head_age educ_level urban, stat(mean)
tabstat HHealth_Ins Int_access caste religion major_illness fin_secure conf_ghosp conf_banks conf_gov income conf_courts N_persons debt head_age educ_level urban, stat(sd)
tabstat HHealth_Ins Int_access caste religion major_illness fin_secure conf_ghosp conf_banks conf_gov income conf_courts N_persons debt head_age educ_level urban, stat(count)
tabstat HHealth_Ins Int_access caste religion major_illness fin_secure conf_ghosp conf_banks conf_gov income conf_courts N_persons debt head_age educ_level urban, stat(min)
tabstat HHealth_Ins Int_access caste religion major_illness fin_secure conf_ghosp conf_banks conf_gov income conf_courts N_persons debt head_age educ_level urban, stat(max)

probit HHealth_Ins Int_access i.caste  i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov conf_courts N_persons income debt head_age i.educ_level if urban==1

probit HHealth_Ins Int_access i.caste i.religion major_illness  fin_secure conf_ghosp conf_banks conf_gov conf_courts N_persons income debt head_age i.educ_level if urban==0
 
 
reg HHealth_Ins Int_access i.caste  i.religion major_illness fin_secure conf_ghosp conf_banks i.conf_gov##c.income conf_courts N_persons debt head_age i.educ_level  if urban==1

reg HHealth_Ins Int_access i.caste i.religion major_illness  fin_secure conf_ghosp conf_banks i.conf_gov##c.income conf_courts N_persons debt head_age i.educ_level if urban==0
 
 
 
probit HHealth_Ins Int_access i.caste  i.religion major_illness fin_secure conf_ghosp conf_banks i.conf_gov##c.income conf_courts N_persons debt head_age i.educ_level  if urban==1
margins, dydx(*) atmeans

probit HHealth_Ins Int_access i.caste i.religion major_illness  fin_secure conf_ghosp conf_banks i.conf_gov##c.income conf_courts N_persons debt head_age i.educ_level if urban==0
margins, dydx(*) atmeans

//OLS specification

reg HHealth_Ins Int_access,robust
eststo m1
reg HHealth_Ins Int_access i.caste,robust
eststo m2
reg HHealth_Ins Int_access i.caste i.religion,robust
eststo m3
reg HHealth_Ins Int_access i.caste i.religion major_illness,robust
eststo m4
reg HHealth_Ins Int_access i.caste i.religion major_illness fin_secure,robust
eststo m5
reg HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp,robust
eststo m6
reg HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks,robust
eststo m7
reg HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov,robust
eststo m8
reg HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov income,robust
eststo m9
reg HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov income conf_courts,robust
eststo m10
reg HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov income conf_courts N_persons,robust
eststo m11
reg HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov income conf_courts N_persons debt,robust
eststo m12
reg HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov income conf_courts N_persons debt head_age,robust
eststo m13
reg HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov income conf_courts N_persons debt head_age i.educ_level,robust
eststo m14
reg HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov income conf_courts N_persons debt head_age i.educ_level urban,robust
eststo m15
reg HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks i.conf_gov##c.income conf_courts N_persons debt head_age i.educ_level urban,robust
eststo m16

esttab m1 m2 m3 m4 m5 m6 m7  , r2 ar2 se scalar(rmse) b(3) star(* 0.1 ** 0.05 *** 0.01)
esttab m8 m9 m10 m11 m12 m13 m14 m15 m16  , r2 ar2 se scalar(rmse) b(3) star(* 0.1 ** 0.05 *** 0.01)



//LPM graph
reg HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks i.conf_gov##c.income conf_courts N_persons debt head_age i.educ_level urban,robust
estat endog
ovtest
vif
rvfplot
predict yhatttt, xb
graph twoway (lfitci HHealth_Ins income) (scatter HHealth_Ins income)

// Descriptive statistics
tab urban 
tab Int_access
tab Int_access if urban==1
tab Int_access if urban==0
tab HHealth_Ins 
tab HHealth_Ins if urban==1
tab HHealth_Ins if urban==0







//probit urban==0
probit HHealth_Ins Int_access if urban==0,r
eststo m11
probit HHealth_Ins Int_access i.caste if urban==0,r
eststo m22
probit HHealth_Ins Int_access i.caste i.religion if urban==0,robust
eststo m33
probit HHealth_Ins Int_access i.caste i.religion major_illness if urban==0,robust
eststo m44
probit HHealth_Ins Int_access i.caste i.religion major_illness fin_secure if urban==0,robust
eststo m55
probit HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp if urban==0,robust
eststo m66
probit HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks if urban==0,robust
eststo m77
probit HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov if urban==0,robust
eststo m88
probit  HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov income if urban==0,robust
eststo m99
probit HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov income conf_courts if urban==0,robust
eststo m100
probit HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov income conf_courts N_persons if urban==0,robust
eststo m111
probit HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov income conf_courts N_persons debt if urban==0,robust
eststo m122
probit HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov income conf_courts N_persons debt head_age if urban==0,robust
eststo m133
probit HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov income conf_courts N_persons debt head_age i.educ_level if urban==0,robust
eststo m144
probit HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov##c.income conf_courts N_persons debt head_age i.educ_level if urban==0,robust
eststo m155


esttab m11 m22 m33 m44 m55 m66 m77  ,  pr2 se b(3) star(* 0.1 ** 0.05 *** 0.01)
esttab m88 m99 m100 m111 m122 m133 m144 m155  , pr2 se b(3) star(* 0.1 ** 0.05 *** 0.01)

probit HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov##c.income conf_courts N_persons debt head_age i.educ_level if urban==0,robust
margins, dydx(*) atmeans



//Probit Urban==1
probit HHealth_Ins Int_access if urban==1,r
eststo m111
probit HHealth_Ins Int_access i.caste if urban==1,r
eststo m222
probit HHealth_Ins Int_access i.caste i.religion if urban==1,robust
eststo m333
probit HHealth_Ins Int_access i.caste i.religion major_illness if urban==1,robust
eststo m444
probit HHealth_Ins Int_access i.caste i.religion major_illness fin_secure if urban==1,robust
eststo m555
probit HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp if urban==1,robust
eststo m666
probit HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks if urban==1,robust
eststo m777
probit HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov if urban==1,robust
eststo m888
probit  HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov income if urban==1,robust
eststo m999
probit HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov income conf_courts if urban==1,robust
eststo m1000
probit HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov income conf_courts N_persons if urban==1,robust
eststo m1111
probit HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov income conf_courts N_persons debt if urban==1,robust
eststo m1222
probit HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov income conf_courts N_persons debt head_age if urban==1,robust
eststo m1333
probit HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov income conf_courts N_persons debt head_age i.educ_level if urban==1,robust
eststo m1444
probit HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov##c.income conf_courts N_persons debt head_age i.educ_level if urban==1,robust
eststo m1555


probit HHealth_Ins Int_access i.caste i.religion major_illness fin_secure conf_ghosp conf_banks conf_gov##c.income conf_courts N_persons debt head_age i.educ_level if urban==1,robust
margins ,dydx(*) atmeans


esttab m111 m222 m333 m444 m555 m666 m777  ,  pr2 se b(3) star(* 0.1 ** 0.05 *** 0.01)
esttab m888 m999 m1000 m1111 m1222 m1333 m1444  , pr2 se b(3) star(* 0.1 ** 0.05 *** 0.01)
esttab m999 m1000 m1111 m1222 m1333 m1444 m1555  , pr2 se b(3) star(* 0.1 ** 0.05 *** 0.01)


//probit margins at means













