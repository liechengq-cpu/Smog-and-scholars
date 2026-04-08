*==============================================================================* 
* Project: Smog and Scholar			               				  		       *
* Date:   2026, April		                                                       *
* Author: Xiaofang Dong, Liecheng Qiao, Yinggang Zhou                          *    
*==============================================================================* 


********************************************************************************
*Main Figures and Tables
********************************************************************************

clear all
clear matrix
set more off
cd ""
global root = ""


***********************************Table 1**************************************

**** Panel A
use "$root\main.dta", clear
global depvar_unweid pub_unweighted
global depvar_weid pub_weighted
global control ctrl_humi ctrl_prec ctrl_pres ctrl_wind ctrl_temp
eststo clear
eststo: reghdfe $depvar_unweid plut_pm25 $control, vce(clu loc_id)
eststo: reghdfe $depvar_unweid plut_pm25 $control, a(au_id i.year c.trend#i.city_id) vce(clu loc_id)
eststo: reghdfe $depvar_unweid plut_pm25 $control, a(au_id year#city_id) vce(clu loc_id)
eststo: reghdfe $depvar_weid plut_pm25 $control,  vce(clu loc_id)
eststo: reghdfe $depvar_weid plut_pm25 $control, a(au_id i.year c.trend#i.city_id) vce(clu loc_id)
eststo: reghdfe $depvar_weid plut_pm25 $control, a(au_id year#city_id) vce(clu loc_id)
capture erase table1_panelA.rtf
esttab  using table1_panelA.rtf, scalar(N r2_a)  sfmt(%12.0f %9.4f) compress nogap /// 
star(* 0.1 ** 0.05 *** 0.01)  ///
b(%6.4f) se(%8.4f) keep(plut_pm25)  ///
title ( ) mtitles("(1)" "(2)" "(3)" "(4)" "(5)" "(6)")

**** Panel B
eststo clear
eststo: ivreghdfe $depvar_unweid $control (plut_pm25 = inversion), vce(cluster loc_id) a(au_id year#city_id) first 
eststo: ivreghdfe $depvar_weid $control (plut_pm25 = inversion), vce(cluster loc_id) a(au_id year#city_id) first 
capture erase table1_panelB.rtf
esttab  using table1_panelB.rtf, scalar(N r2_a widstat) sfmt(%12.0f %12.4f %12.4f) compress nogap /// 
star(* 0.1 ** 0.05 *** 0.01)  ///
b(%6.4f) se(%6.4f)  keep(plut_pm25) ///
title ( ) mtitles("unweighted" "weighted")

