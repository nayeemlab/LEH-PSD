* directory 

*merge datasets
use "hh",clear
sort HH1 HH2
save "hh",replace

use "hl",clear
rename HL1 LN
sort HH1 HH2 LN
save "hl_2",replace

use "fs",clear
sort HH1 HH2 LN
save "fs",replace

merge m:1 HH1 HH2 using hh.dta
keep if _merge==3
save "fs",replace
drop _merge

merge 1:1 HH1 HH2 LN using hl_2.dta
keep if _merge==3
save "fs",replace
drop _merge


*psu, weight, strata
svyset HH1 [pw=fsweight], strata(stratum)

*inclusion and exclusion
**keeping those students who was admitted last year
keep if CB9==1
**keeping primary students who was admitted last year
keep if inlist(CB10B, 1,2,3,4,5)
* Keeping primary students who is adimtted in current year
drop if inlist(CB8B,7,8)

* Taking age between 6 and 12 
keep if inlist(CB3,6,7,8,9,10,11,12)
drop if schage==5
svy: tab CB7

*DROPOUT
svy: tab CB7
gen dropout=CB7
recode dropout 1=0
recode dropout 2=1
recode dropout 9=.
svy: tab dropout
label define dropoutlab 1 "Yes" 0 "No"
label values dropout dropoutlab 
svy: tab dropout

*Age
svy: tab CB3
gen cage=CB3
recode cage 6/8 = 1 9/12 = 2
label define cagel 1 "Age 6 to 8" 2 "Age 9 to 12"
label values cage cagel
tab cage
tab cage dropout, row
svy: tab cage dropout, row

*Age at beginning of school year 
svy: tab schage
gen sage=schage
recode sage 6/8 = 1 9/12 = 2
label values sage cagel
tab sage
tab sage dropout, row
svy: tab sage dropout, row

*Gender
svy: tab HL4
gen sex=HL4
recode sex 1=1
recode sex 2=2
label define sexlab 1 "Male" 2 "Female"
label values sex sexlab
tab sex dropout, row
svy: tab sex dropout, row

*Child's functional difficulties
svy: tab fsdisability
tab fsdisability dropout, row
svy: tab fsdisability dropout, row

*child has emotional,behavioral and communicational functional difficulties
recode FCF16 9=.
recode FCF17 9=.
recode FCF19 9=.
recode FCF21 9=.
recode FCF24 9=.
recode FCF25 9=.
gen fcf16 = FCF16
gen fcf17 = FCF17
gen fcf19 = FCF19
gen fcf21 = FCF21
gen fcf24 = FCF24
gen fcf25 = FCF25
recode fcf16 1/2=0
recode fcf16 3/4 = 1
recode fcf17 1/2=0
recode fcf17 3/4 = 1
recode fcf19 1/2=0
recode fcf19 3/4 = 1
recode fcf21 1/2=0
recode fcf21 3/4 = 1
recode fcf24 1/2 = 0
recode fcf24 3/4 = 1
recode fcf25 3/5 = 0
recode fcf25 1/2 = 1
gen emdif= fcf16+fcf17+fcf19+fcf21+fcf24+fcf25
recode emdif 0=0
recode emdif 1/6=1
label define emdiflab 0 "No" 1 "Yes"
label values emdif emdiflab
tab emdif dropout, row
svy: tab emdif dropout, row

*Child's involvement in economic activities
gen cL1a = CL1A
gen cL1b = CL1B
gen cL1c = CL1C
gen cL1x = CL1X
recode cL1a 9=.
recode cL1a 2=0
recode cL1b 9=.
recode cL1b 2=0
recode cL1c 9=.
recode cL1c 2=0
recode cL1x 9=.
recode cL1x 2=0
gen checon=cL1a+cL1b+cL1c+cL1x
recode checon 0=0
recode checon 1/4=1
label define checonlab 0 "No" 1 "Yes"
label values checon checonlab
tab checon dropout, row
svy: tab checon dropout, row

*Child needs to be physically punished to be brought up properly
gen cpun=FCD5
recode cpun 8=.
recode cpun 9=.
label values cpun FCD5
tab cpun dropout, row
svy: tab cpun dropout, row 

*Severe Physical displine
recode FCD2I 9=.
recode FCD2K 9=.
recode FCD2I 2=0
recode FCD2K 2=0
gen chdissp =FCD2I+FCD2K
recode chdissp 0=0
recode chdissp 1/2=1
label define chdislab 1 "Yes" 0 "No"
label values chdissp chdislab
tab chdissp dropout, row
svy: tab chdissp dropout, row

*Mother's education
svy: tab melevel
recode melevel 9=.
svy: tab melevel
tab melevel dropout, row
svy: tab melevel dropout, row

*Mother's or caretaker's functional difficulties
svy: tab caretakerdis
tab caretakerdis dropout, row
svy: tab caretakerdis dropout, row

*Mother or caretaker of another child under 5
svy: tab FCD3
tab FCD3 dropout, row
svy: tab FCD3 dropout, row

*Father's education
svy: tab felevel
recode felevel 5/9=.
svy: tab felevel
tab felevel dropout, row
svy: tab felevel dropout, row


*Area.
svy: tab HH6
gen area=HH6
recode area 1=1
recode area 2=2
label define arealab 1 "Urban" 2 "Rural"
label values area arealab
svy: tab area
tab area dropout, row
svy: tab area dropout, row

*Division.
svy: tab HH7
tab HH7 dropout, row
svy: tab HH7 dropout, row

*Gender of Household Head
svy: tab HHSEX
tab HHSEX dropout, row
svy: tab HHSEX dropout, row

*Ethnicity of household head
svy: tab ethnicity
tab ethnicity dropout, row
svy: tab ethnicity dropout, row

*Religion
svy: tab HC1A
gen religion=HC1A
recode religion 9=.
label values religion HC1A
tab religion dropout, row
svy: tab religion dropout, row

*Household size
svy: tab HH48
gen size=HH48
recode size 1/4=1
recode size 5/29=2
label define sizelab 1 "Lowest through 4" 2 "4+"
label values size sizelab
tab size dropout, row
svy: tab size dropout, row

*wealth index quintile
svy: tab windex5
gen wealth=windex5
recode wealth 0=.
recode windex5 1/2=1
recode wealth 3=2
recode wealth 4/5=3
label define wealthlab  1 "Poor" 2 "Middle" 3 "Rich"
label values wealth wealthlab
tab wealth dropout, row
svy: tab wealth dropout, row

*Household has electricity
svy: tab HC8
gen elec= HC8
recode elec 1/2=1
recode elec 3=0
recode elec 9=.
label define eleclab 1 "Yes" 0 "No"
label values elec eleclab
tab elec dropout, row
svy: tab elec dropout, row

* Household has internet
svy: tab HC13
gen intnet= HC13
recode intnet 9=.
label values intnet HC13
tab intnet dropout, row
svy: tab intnet dropout, row

*Type of toilet facility.
svy: tab WS11
gen toilet=1
replace toilet=2 if(WS11==14|WS11==23|WS11==51|WS11==95|WS11==96)
label define toiletlab 1 "Improved" 2 "Unimproved"
label values toilet toiletlab
tab toilet dropout, row
svy: tab toilet dropout, row

*Salt Iodization.
svy: tab SA1
gen salt=SA1
recode salt 1=0
recode salt 2/3=1
recode salt 4/6=0
recode salt 9=.
label define saltlab 0 "No" 1 "Yes"
label values salt saltlab
tab salt dropout, row
svy: tab salt dropout, row

*Sources of Water
gen water = 0
replace water = 1 if(WS1==32|WS1==42|WS1==81|WS1==96)
label define waterlab 0 "Improved" 1 "Unimproved"
label values water waterlab
label variable water "Sources of Water"
tab water dropout, row
svy: tab water dropout, row


*3 or more books to read at home
svy: tab PR3
gen books= PR3
recode books 99=.
recode books 0/2=0
recode books 3/10=1
label define booklab 1 "Yes" 0 "No"
label values books booklab
tab books dropout, row
svy: tab books dropout, row

*read books or are read to at home
recode FL6A 9=.
recode FL6B 9=.
gen rbook=FL6A+FL6B
recode rbook 2/3=1
recode rbook 4=0
label define rbooklab 1 "Yes" 0 "No"
label values rbook rbooklab
tab rbook dropout, row
svy: tab rbook dropout, row

*Same language at home and school
recode FL7 9=.
recode FL9 8=.
recode FL9 9=.
gen slang=0
replace slang=1 if(FL7==FL9)
label define slanglab 1 "Yes" 0 "No"
label values slang slanglab
tab slang dropout, row
svy: tab slang dropout, row


* Crode model of log-binomial regression model
svy: glm dropout i.cage, family(binomial) link(log) eform
svy: glm dropout i.sage, family(binomial) link(log) eform
svy: glm dropout ib1.sex ,family(binomial) link(log) eform
svy: glm dropout ib2.fsdisability ,family(binomial) link(log) eform
svy: glm dropout i.checon ,family(binomial) link(log) eform
svy: glm dropout i.chdissp , family(binomial) link(log) eform
svy: glm dropout i.melevel,family(binomial) link(log) eform
svy: glm dropout i.felevel,family(binomial) link(log) eform
svy: glm dropout i.HH7 ,family(binomial) link(log) eform
svy: glm dropout ib1.HHSEX ,family(binomial) link(log) eform
svy: glm dropout ib1.wealth ,family(binomial) link(log) eform
svy: glm dropout i.intnet ,family(binomial) link(log) eform
svy: glm dropout i.toilet,family(binomial) link(log) eform
svy: glm dropout i.salt,family(binomial) link(log) eform
svy: glm dropout i.water,family(binomial) link(log) eform
svy: glm dropout i.books,family(binomial) link(log) eform
svy: glm dropout i.rbook ,family(binomial) link(log) eform

* checking multicollinearity
regress dropout i.cage i.sage i.sex  ib2.fsdisability i.checon i.chdissp i.melevel i.felevel i.HH7 i.HHSEX i.wealth i.intnet i.toilet i.salt i.water i.books i.rbook

vif

*Log-binomial regression
svy:glm dropout i.sage i.sex  ib2.fsdisability i.checon i.chdissp i.melevel i.felevel i.HH7 i.HHSEX i.wealth i.intnet i.toilet i.salt i.water i.rbook, family(binomial) link(log) eform 

glm dropout i.sage i.sex  ib2.fsdisability i.checon i.chdissp i.melevel i.felevel i.HH7 i.HHSEX i.wealth i.intnet i.toilet i.salt i.water i.rbook, family(binomial) link(log) eform 

* Storing estimated value of Log Binomial model
estimates store lb

* Logistic Modeling
svy:logit dropout i.sage i.sex  ib2.fsdisability i.checon i.chdissp i.melevel i.felevel i.HH7 i.HHSEX i.wealth i.intnet i.toilet  i.salt i.water i.rbook,or

logit dropout  i.sage i.sex  ib2.fsdisability i.checon i.chdissp i.melevel i.felevel i.HH7 i.HHSEX i.wealth i.intnet i.toilet i.salt i.water i.rbook,or

* Storing estimated value of Logistic model
estimates store log


*Negative binomial

svy:nbreg dropout i.sage i.sex  ib2.fsdisability i.checon i.chdissp i.melevel i.felevel i.HH7 i.HHSEX i.wealth i.intnet i.toilet i.salt i.water i.rbook, eform 

nbreg dropout i.sage i.sex  ib2.fsdisability i.checon i.chdissp i.melevel i.felevel i.HH7 i.HHSEX i.wealth i.intnet i.toilet i.salt i.water i.rbook

* Storing estimated value of Negative binomial
estimates store nb

*Calculate AIC and BIC.
estimates stats log lb nb


* ROC curve

svy:glm dropout i.sage i.sex  ib2.fsdisability i.checon i.chdissp i.melevel i.felevel i.HH7 i.HHSEX i.wealth i.intnet i.toilet i.salt i.water i.rbook, family(binomial) link(log) eform 

predict logb, xb 

roctab dropout logb, graph
