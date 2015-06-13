library(lubridate)
library(stringr)
library(magrittr)


extract_wins <- function(x){
    slash <- str_locate(x,"/5")[1]
    dollar <- str_locate(x,"\\$")[1]
    decimal <- str_locate(x,"\\.")[1]
    winners <- str_sub(x,slash+2,dollar-1) %>% str_replace_all(",","")
    prize <- str_sub(x,dollar+1,decimal+2) %>% str_replace_all(",","")
    return(c(as.numeric(winners),as.numeric(prize)))
}

date <- update(today(),years=2012,months=1,days=1)
end.date <- update(today(),years=2015,months=1,days=1)

final <- NULL
while(date < end.date){
    month.string <- ifelse(month(date) < 10,str_c("0",month(date)),month(date))
    day.string <- ifelse(day(date) < 10,str_c("0",day(date)),day(date))
    date.string <- str_c(year(date),
                         month.string,
                         day.string)
    url <- str_c("http://www.txlottery.org/export/sites/lottery/Games/Cash_Five/Draw_Sales/",
                    date.string,
                    "_c5.txt")
    if (wday(date) != 1){
        raw <- readLines(url)
        
        win.nums <- raw[(sapply(raw, function(x) str_detect(x,"WINNING NUMBERS:")))] %>%
                    str_extract_all("[0-9]{2}") 
        win.nums <- sort(as.numeric(win.nums[[1]]))
        
        match5 <- raw[(sapply(raw, function(x) str_detect(x,"5/5")))] %>% extract_wins()
        match4 <- raw[(sapply(raw, function(x) str_detect(x,"4/5")))] %>% extract_wins()
        match3 <- raw[(sapply(raw, function(x) str_detect(x,"3/5")))] %>% extract_wins()
        match2 <- raw[(sapply(raw, function(x) str_detect(x,"2/5")))] %>% extract_wins()
        
        sale <- raw[(sapply(raw, function(x) str_detect(x,"NET SALES")))]
        colon <- str_locate(sale,":")
        sale <- str_sub(sale,colon[1]+1) %>% 
                str_replace_all("\\$","") %>% 
                str_replace_all(",","") %>%
                as.numeric()
                
        date.string <- str_c(year(date),"-",
                             month.string,"-",
                             day.string)        
        final <- rbind(final,
                       c(date.string,
                       sale,
                       win.nums[1],win.nums[2],win.nums[3],win.nums[4],win.nums[5],
                       match5[1],match4[1],match3[1],match2[1],
                       match5[2],match4[2],match3[2],match2[2])
                       )
        
    }
    date <- date + days(1)
}

final <- data.frame(final)
names(final) <- c('drawdate','sales',
                  'n1','n2','n3','n4','n5',
                  'winners_5','winners_4','winners_3','winners_2',
                  'prize_5','prize_4','prize_3','prize_2')

write.table(final,"tx_cash5.csv",sep=",",row.names=FALSE,quote=FALSE)

