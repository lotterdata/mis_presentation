library(XML)
library(httr)
library(rvest)
library(magrittr)
library(stringr)

final <- NULL

for(year in c("2012","2013","2014","2015")){
    file.name <- str_c("pa_data\\pa_",year,".txt")
    test <- readLines(file.name)
    urls <- test[(sapply(test,function(x) str_detect(x,"Payouts\\.aspx\\?id")))] %>%
            sapply(function(x) str_c("http://www.palottery.state.pa.us",
                                     str_sub(x,
                                       start = str_locate(x,"<")[1]+9,
                                       end = str_locate(x,">")[1]-2)))
    for(url in urls){
    
        pa_cash_5 <- html_session(url)
        
        part1 <- pa_cash_5 %>% html_nodes("h2:nth-child(4)") %>% html_text() 
        part2 <- pa_cash_5 %>% html_nodes("p:nth-child(5)") %>% html_text() 
        
        date <- str_c("20",str_sub(part1,start=7,end=8),
                      "-",str_sub(part1,start=1,end=2),
                      "-",str_sub(part1,start=4,end=5))
        
        n1 <- as.numeric(str_sub(part1,start = 35, end = 36))
        n2 <- as.numeric(str_sub(part1,start = 39, end = 40))
        n3 <- as.numeric(str_sub(part1,start = 43, end = 44))
        n4 <- as.numeric(str_sub(part1,start = 47, end = 48))
        n5 <- as.numeric(str_sub(part1,start = 51, end = 52))
        
        dollars <- str_locate_all(part2,"\\$")[[1]]
        periods <- str_locate_all(part2,"\\.")[[1]]
        init <- str_locate(part2,"players")
        
        prize_5 <- str_sub(part2, start = dollars[1,1]+1, end = periods[1,1]+2) %>% 
            str_replace_all(.,",","") %>% 
            as.numeric(.)
        prize_5 <- as.numeric(str_sub(part2, start = 1, end = init[1,1]-1))*prize_5
        prize_4 <- as.numeric(str_sub(part2, start = dollars[2,1]+1, end = periods[2,1]+2))
        prize_3 <- as.numeric(str_sub(part2, start = dollars[3,1]+1, end = periods[3,1]+2))
        
        final <- rbind(final,c(date,n1,n2,n3,n4,n5,prize_5,prize_4,prize_3))
    }
}

final <- data.frame(final)
names(final) <- c('drawdate',
                  'n1','n2','n3','n4','n5',
                  'prize_5','prize_4','prize_3')
write.table(final,"pa_data\\pa_cash5.csv",sep=",",row.names=FALSE,quote=FALSE)