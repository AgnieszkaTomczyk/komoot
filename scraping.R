# set working directory
setwd("E:\\R\\komoot")

# load packages
source("./packages.R", encoding = "UTF-8")

# page to scraping
url <- 'https://www.komoot.com/pioneers/club?country=PL'
webpage <- read_html(url)

# data frame 
pioneers_experts <- data.frame(user = as.character(),
                               pioneer = as.character(),
                               expert = as.character(),
                               stringsAsFactors = FALSE)

# get data
user <- "user"
i <- 1
while(!is.na(user)){
user_selector <- sprintf('#list > div > div > div:nth-child(%s) > div > a > div.o-box.o-box--large.u-padding-bottom-none.u-text-center.o-view.o-view--flex > p', i)
user <- html_nodes(webpage, user_selector) %>% 
  stri_match(regex = ">(.+)<") %>%
  .[2]

pioneer_selector <- sprintf('#list > div > div > div:nth-child(%s) > div > a > div.o-box.o-box--large.u-padding-bottom-none.u-text-center.o-view.o-view--flex > ul > li:nth-child(1) > div > div.o-media__body > span.u-color-default.u-text-bold', i)
pioneer <- html_nodes(webpage, pioneer_selector) %>% 
  stri_match(regex = ">(.+)<") %>%
  .[2] %>%
  as.numeric()

expert_selector <- sprintf('#list > div > div > div:nth-child(%s) > div > a > div.o-box.o-box--large.u-padding-bottom-none.u-text-center.o-view.o-view--flex > ul > li:nth-child(2) > div > div.o-media__body > span.u-color-default.u-text-bold', i)
expert <- html_nodes(webpage, expert_selector) %>% 
  stri_match(regex = ">(.+)<") %>%
  .[2] %>%
  as.numeric()

temp <- cbind.data.frame(user = user, pioneer = pioneer, expert = expert)
rbind.data.frame(pioneers_experts, temp) -> pioneers_experts
i <- i + 1
}

pioneers_experts %>% filter(!is.na(user)) ->  pioneers_experts
pioneers_experts$expert[is.na(pioneers_experts$expert)] <- 0


