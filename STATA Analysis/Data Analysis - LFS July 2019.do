/* DATA ANALYSIS */

* labeled categorical variables*
label define sex 0 "male" 1 "female"
label define education 0 "Pre-primary" 1 "Secondary education" 2 "Post-secondary non-degree education" 3 "Baccalaureate education" 4 "Post-baccalaureate education" 
label define industry 0 "agriculture" 1 "industry" 2 "services"
label values sex sex
label values education education
label values industry industry


* did descriptive statistics *
tab wage sex
tab wage education
tab wage industry


* multicollniearity check *
* multicolliniearity <10 = not serious *
reg wage age i.sex ib0.industry
reg wage age i.sex ib0.education ib0.industry
vif

* correlation check *
corr wage age sex education industry


* skewness and kurtosis check *
predict resid, residuals
sktest resid


* wage and age are transformed to log form to make it more "normal"  *
tabstat wage age sex education industry, stat(sk)
g lwage = log(wage)
g lage = log(age)
g lsex = log(sex)
g leducation = log(education)
g lexperience = log(experience)
g lindustry = log(industry)
g sqexperience = experience^2
tabstat lwage lage sex education industry, stat(sk)


* model is correctly specified *
reg lwage lage i.sex ib0.education ib0.industry
vif
corr lwage lage sex education industry
ovtest
hettest


* mckinnon test *
reg lwage lage i.sex ib0.education ib0.industry
predict yhat
reg lwage lage i.sex ib0.education ib0.industry
predict yhat2
reg lwage lage i.sex ib0.education ib0.industry yhat2
reg lwage lage i.sex ib0.education ib0.industry yhat 
reg lwage lage i.sex ib0.education ib0.industry
predict resid2, residuals
g sqresid2 = resid2^2
g lsqresid2 = log(sqresid2)
reg lsqresid2 lage
reg lsqresid2 lsex
reg lsqresid2 leducation
reg lsqresid2 lexperience
reg lsqresid2 lindustry


* park test. used age as it is the only non categorical variable causing heteroskedasticity *
reg lwage i.sex ib0.education ib0.industry [aw=1/lage]
hettest
reg lwage i.sex ib0.education ib0.industry [aw=1/lage^.5]
hettest


* skewness and kurtosis check *
reg lwage lage i.sex ib0.education ib0.industry, robust
predict resid3, residuals
sktest resid3


* used bootstrap regression since it is still heteroskedastic *
* 10,000 reps based from wooldridge *
bootstrap, reps (1000) : reg lwage lage i.sex ib0.education ib0.industry
predict resid4, residuals
sktest resid4

