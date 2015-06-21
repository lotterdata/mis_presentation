# MIS Presentation

This repository houses data, code, and R markdown files for a presentation on
using lottery prize data to gain insights into lottery players' preferred 
selections.

## Files and folders 
* main_pres.Rmd: R markdown for the presentation   
* main_pres.html: output from running knitr on the Rmd file  
* get_sales_data_2.R, code for dowloading Texas Cash 5 data  
* extract_pa_cash_5_all.R: code for dowloading Pennsylvnaia Cash 5 data
* nj_data, pa_data, tx_data: folders with data from Cash 5 games in the respective states  

## Required R libraries  
* dplyr  
* ggplot2  
* magrittr  
* lubridate  
* stringr  
* XML  
* httr  
* rvest  

## Comments on downloading data (if you want to reproduce my work)
* New Jersey data were downloaded manually from <https://www.njlottery.com/en-us/drawgames/dailygames/jerseycash.html>  
* Pennsylvania data were downloaded in two steps  
    + First, go to <http://www.palottery.state.pa.us/Games/Past-Winning-Numbers.aspx>. Choose 
    "Cash 5" and the year you wish to download. Click the "Search" button and save the source file using the name convention "pa_data\pa_yyyy.txt"
    + Second, run the code in extract_pa_cash_5_all.R. The list of years may be edited in line 9.  
    
* Texas data were downloaded using get_sales_data_2.R. The start and end dates may be edited in lines 15 and 16.