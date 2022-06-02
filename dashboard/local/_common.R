
# 역대선거 투표율 (2012~2022) ----------------------------

library(tidyverse)

## 2012년 대선
gg_2012_casting_raw <- krvote::election_20121219$투표율 %>% 
  filter(str_detect(시도명, "경기")) %>% 
  mutate(구시군 = case_when(
    str_detect(구시군명, "고양시") ~ "고양시",
    str_detect(구시군명, "부천시") ~ "부천시",
    str_detect(구시군명, "성남시") ~ "성남시",
    str_detect(구시군명, "수원시") ~ "수원시",
    str_detect(구시군명, "안산시") ~ "안산시",
    str_detect(구시군명, "안양시") ~ "안양시",
    str_detect(구시군명, "용인시") ~ "용인시",
    str_detect(구시군명, "광명시") ~ "광명시",
    str_detect(구시군명, "광주시") ~ "광주시",
    str_detect(구시군명, "군포시") ~ "군포시",
    str_detect(구시군명, "김포시") ~ "김포시",
    str_detect(구시군명, "남양주") ~ "남양주",
    str_detect(구시군명, "의정부") ~ "의정부",
    str_detect(구시군명, "화성시") ~ "화성시",
    str_detect(구시군명, "파주시") ~ "파주시",
    str_detect(구시군명, "평택시") ~ "평택시",
    str_detect(구시군명, "시흥시") ~ "시흥시",
    TRUE ~ 구시군명))  %>% 
  group_by(시도명, 구시군) %>% 
  summarise( 투표수 = sum(투표수),
            선거인수 = sum(선거인수)) %>% 
  ungroup() %>% 
  mutate(투표율 = 투표수 / 선거인수) %>% 
  mutate(선거 = "2012년") %>% 
  select(선거, 시도명, 구시군명=구시군, 선거인수, 투표수, 투표율)



## 2017년 대선
gg_2017_casting_raw <- krvote::election_20170509$투표율 %>% 
  filter(str_detect(시도명, "경기")) %>% 
  mutate(구시군 = case_when(
    str_detect(구시군명, "고양시") ~ "고양시",
    str_detect(구시군명, "부천시") ~ "부천시",
    str_detect(구시군명, "성남시") ~ "성남시",
    str_detect(구시군명, "수원시") ~ "수원시",
    str_detect(구시군명, "안산시") ~ "안산시",
    str_detect(구시군명, "안양시") ~ "안양시",
    str_detect(구시군명, "용인시") ~ "용인시",
    str_detect(구시군명, "광명시") ~ "광명시",
    str_detect(구시군명, "광주시") ~ "광주시",
    str_detect(구시군명, "군포시") ~ "군포시",
    str_detect(구시군명, "김포시") ~ "김포시",
    str_detect(구시군명, "남양주") ~ "남양주",
    str_detect(구시군명, "의정부") ~ "의정부",
    str_detect(구시군명, "화성시") ~ "화성시",
    str_detect(구시군명, "파주시") ~ "파주시",
    str_detect(구시군명, "평택시") ~ "평택시",
    str_detect(구시군명, "시흥시") ~ "시흥시",
    TRUE ~ 구시군명))  %>% 
  group_by(시도명, 구시군) %>% 
  summarise( 투표수 = sum(투표수),
            선거인수 = sum(선거인수)) %>% 
  ungroup() %>% 
  mutate(투표율 = 투표수 / 선거인수) %>% 
  mutate(선거 = "2017년") %>% 
  select(선거, 시도명, 구시군명=구시군, 선거인수, 투표수, 투표율)


## 2022년 대선
gg_2022_raw_excel <- readxl::read_excel("data/2022년_개표결과_대통령선거_전체.xlsx") 

gg_2022_casting_raw <- gg_2022_raw_excel %>% 
  filter(str_detect(시도, "경기")) %>% 
  mutate(읍면동명 = ifelse(is.na(읍면동명), 구시군, 읍면동명),
             투표구명 = ifelse(is.na(투표구명), 읍면동명, 투표구명)) %>% 
  filter(!str_detect(구시군, "합계"),
         !str_detect(읍면동명, "합계"),
         !str_detect(투표구명, "소계")) %>% 
  janitor::clean_names(ascii = FALSE) %>% 
  select(시도, 구시군, 선거인수, 투표수) %>% 
  mutate(투표수 = parse_number(투표수),
            선거인수     = parse_number(선거인수)) %>% 
  mutate(구시군명 = case_when(
    str_detect(구시군, "고양시") ~ "고양시",
    str_detect(구시군, "부천시") ~ "부천시",
    str_detect(구시군, "성남시") ~ "성남시",
    str_detect(구시군, "수원시") ~ "수원시",
    str_detect(구시군, "안산시") ~ "안산시",
    str_detect(구시군, "안양시") ~ "안양시",
    str_detect(구시군, "용인시") ~ "용인시",
    str_detect(구시군, "광명시") ~ "광명시",
    str_detect(구시군, "광주시") ~ "광주시",
    str_detect(구시군, "군포시") ~ "군포시",
    str_detect(구시군, "김포시") ~ "김포시",
    str_detect(구시군, "남양주") ~ "남양주",
    str_detect(구시군, "의정부") ~ "의정부",
    str_detect(구시군, "화성시") ~ "화성시",
    str_detect(구시군, "파주시") ~ "파주시",
    str_detect(구시군, "평택시") ~ "평택시",
    str_detect(구시군, "시흥시") ~ "시흥시",
    TRUE ~ 구시군))  %>% 
  group_by(시도, 구시군명) %>% 
  summarise( 투표수 = sum(투표수),
            선거인수 = sum(선거인수)) %>% 
  ungroup() %>% 
  mutate(투표율 = 투표수 / 선거인수) %>% 
  mutate(선거 = "2022년") %>% 
  select(선거, 시도명=시도, 구시군명, 선거인수, 투표수, 투표율)

## 2016년 총선 -----------------------
gg_2016_casting_raw <- krvote::general_2016 %>% 
  filter(시도 == "경기") %>% 
  unnest(data) %>% 
  mutate(구시군명 = case_when(
    str_detect(선거구, "고양시") ~ "고양시",
    str_detect(선거구, "부천시") ~ "부천시",
    str_detect(선거구, "성남시") ~ "성남시",
    str_detect(선거구, "수원시") ~ "수원시",
    str_detect(선거구, "안산시") ~ "안산시",
    str_detect(선거구, "안양시") ~ "안양시",
    str_detect(선거구, "용인시") ~ "용인시",
    str_detect(선거구, "광명시") ~ "광명시",
    str_detect(선거구, "광주시") ~ "광주시",
    str_detect(선거구, "군포시") ~ "군포시",
    str_detect(선거구, "김포시") ~ "김포시",
    str_detect(선거구, "남양주") ~ "남양주",
    str_detect(선거구, "의정부") ~ "의정부",
    str_detect(선거구, "화성시") ~ "화성시",
    str_detect(선거구, "파주시") ~ "파주시",
    str_detect(선거구, "평택시") ~ "평택시",
    str_detect(선거구, "시흥시") ~ "시흥시",
    TRUE ~ 선거구))  %>% 
  group_by(구시군명, 구분) %>% 
  summarise(득표수 = sum(사람수)) %>% 
  ungroup() %>% 
  filter(구분 %in% c("선거인수", "투표수")) %>% 
  pivot_wider(names_from = 구분, values_from = 득표수) %>% 
  mutate(선거 = "2016년",
           시도명 = "경기도") %>% 
  mutate(투표율 = 투표수 / 선거인수) %>% 
  select(선거, 시도명, 구시군명, 선거인수, 투표수, 투표율)


## 2020년 총선 -----------------------
gg_2020_casting_raw <- krvote::general_2020 %>% 
  filter(시도 == "경기") %>% 
  unnest(data) %>% 
  mutate(구시군명 = case_when(
    str_detect(선거구, "고양시") ~ "고양시",
    str_detect(선거구, "부천시") ~ "부천시",
    str_detect(선거구, "성남시") ~ "성남시",
    str_detect(선거구, "수원시") ~ "수원시",
    str_detect(선거구, "안산시") ~ "안산시",
    str_detect(선거구, "안양시") ~ "안양시",
    str_detect(선거구, "용인시") ~ "용인시",
    str_detect(선거구, "광명시") ~ "광명시",
    str_detect(선거구, "광주시") ~ "광주시",
    str_detect(선거구, "군포시") ~ "군포시",
    str_detect(선거구, "김포시") ~ "김포시",
    str_detect(선거구, "남양주") ~ "남양주",
    str_detect(선거구, "의정부") ~ "의정부",
    str_detect(선거구, "화성시") ~ "화성시",
    str_detect(선거구, "파주시") ~ "파주시",
    str_detect(선거구, "평택시") ~ "평택시",
    str_detect(선거구, "시흥시") ~ "시흥시",
    TRUE ~ 선거구))  %>% 
  separate(구시군명, into = c("구시군", "구시군명"), sep = "_") %>% 
  mutate(구시군명 = ifelse(is.na(구시군명), 구시군, 구시군명)) %>% 
  group_by(구시군명, 구분) %>% 
  summarise(득표수 = sum(사람수)) %>% 
  ungroup() %>% 
  filter(구분 %in% c("선거인수", "투표수")) %>% 
  pivot_wider(names_from = 구분, values_from = 득표수) %>% 
  mutate(선거 = "2020년",
           시도명 = "경기도") %>% 
  mutate(투표율 = 투표수 / 선거인수) %>% 
  select(선거, 시도명, 구시군명, 선거인수, 투표수, 투표율)

## 2014년 지방선거 ---------------

clean_df <- function(raw_df) {
  clean_df <- raw_df %>% 
    pivot_longer(선거인수:기권수)
  return(clean_df)
}

gg_2014_raw <- krvote::local_sgg_20140604$경기도 %>% 
  mutate(clean_data = map(data, clean_df) )

gg_2014_casting_raw <- gg_2014_raw %>% 
  select(-data) %>% 
  unnest(clean_data) %>% 
  filter(name %in% c("선거인수", "투표수")) %>% 
  group_by(시도명, 구시군, name) %>% 
  summarise(합계 = sum(value)) %>% 
  ungroup() %>% 
  pivot_wider(names_from = name, values_from = 합계) %>% 
  mutate(선거 = "2014년") %>% 
  mutate(투표율 = 투표수 / 선거인수) %>% 
  select(선거, 시도명, 구시군명=구시군, 선거인수, 투표수, 투표율)




## 2018년 지방선거
gg_2018_casting_raw <- krvote::local_sgg_20180613 %>% 
  filter(시도 == "경기도") %>% 
  mutate(clean_data = map(data, clean_df) ) %>% 
  select(-data) %>% 
  unnest(clean_data) %>% 
  filter(name %in% c("선거인수", "투표수")) %>% 
  mutate(구시군 = case_when(
    str_detect(구시군명, "고양시") ~ "고양시",
    str_detect(구시군명, "부천시") ~ "부천시",
    str_detect(구시군명, "성남시") ~ "성남시",
    str_detect(구시군명, "수원시") ~ "수원시",
    str_detect(구시군명, "안산시") ~ "안산시",
    str_detect(구시군명, "안양시") ~ "안양시",
    str_detect(구시군명, "용인시") ~ "용인시",
    str_detect(구시군명, "광명시") ~ "광명시",
    str_detect(구시군명, "광주시") ~ "광주시",
    str_detect(구시군명, "군포시") ~ "군포시",
    str_detect(구시군명, "김포시") ~ "김포시",
    str_detect(구시군명, "남양주") ~ "남양주",
    str_detect(구시군명, "의정부") ~ "의정부",
    str_detect(구시군명, "화성시") ~ "화성시",
    str_detect(구시군명, "파주시") ~ "파주시",
    str_detect(구시군명, "평택시") ~ "평택시",
    str_detect(구시군명, "시흥시") ~ "시흥시",
    TRUE ~ 구시군명))  %>% 
  group_by(시도명, 구시군, name) %>% 
  summarise(합계 = sum(value)) %>% 
  ungroup() %>% 
  pivot_wider(names_from = name, values_from = 합계) %>% 
  mutate(선거 = "2018년") %>% 
  mutate(투표율 = 투표수 / 선거인수) %>% 
  select(선거, 시도명, 구시군명=구시군, 선거인수, 투표수, 투표율)




## 데이터 결합 ----------------------

gg_casting_raw <- bind_rows(gg_2012_casting_raw, gg_2014_casting_raw) %>% 
  bind_rows(gg_2016_casting_raw) %>% 
  bind_rows(gg_2017_casting_raw) %>% 
  bind_rows(gg_2018_casting_raw) %>% 
  bind_rows(gg_2020_casting_raw) %>% 
  bind_rows(gg_2022_casting_raw)

gg_casting_total <- gg_casting_raw %>% 
  group_by(선거) %>% 
  summarise(선거인수 = sum(선거인수),
                투표수   = sum(투표수)) %>% 
  mutate(투표율 = 투표수/선거인수) %>% 
  mutate(시도명 = "경기도",
            구시군명   = "총계")

gg_casting_raw <- gg_casting_raw %>% 
  bind_rows(gg_casting_total)

gg_casting_raw <- krvote::clean_varnames(gg_casting_raw)

gg_2012_casting_raw <- gg_2012_casting_raw %>% 
  mutate(구시군명 = stringi::stri_escape_unicode(구시군명)) %>% 
  mutate(구시군명 = stringi::stri_unescape_unicode(구시군명))

gg_casting_raw %>% 
  write_rds("data/gg_casting_raw.rds")

# 사전투표 ---------------------------------------------------------------------

## 2022년 대선 --------------------------

read_rds("data/사전투표/대통령선거_2022년.rds") %>% 
  filter(시도명 == "경기도",
            구시군명 == "가평군") %>% 
  mutate(선거 = "2022년") %>% 
  ggplot(aes(x=시간순서, y=사전투표율, group = 구시군명)) +
  geom_line() +
  geom_point() +
  coord_flip() +
  theme_election() +
  labs(x="",
       y="사전투표율(%)") +
  scale_y_continuous(labels = scales::percent, limits = c(0, 0.45))   

## 2022년 지선 -------------------------

library(rvest)
library(httr)
library(lubridate)

get_early_voting_data_latest <- function(sido_code = "1100", date_code = "1", time_code = "07") {
  
  cat("\n------------------------------\n", sido_code, ":", date_code, ":", time_code, "\n")
  
  nec_url <- glue::glue("http://info.nec.go.kr/electioninfo/electionInfo_report.xhtml?",
                        "electionId=0020220601",
                        "&requestURI=%2FWEB-INF%2Fjsp%2Felectioninfo%2F0020220601%2Fvc%2Fvcap01.jsp",
                        "&topMenuId=VC",
                        "&secondMenuId=VCAP01",
                        "&menuId=VCAP01",
                        "&statementId=VCAP01_%232",
                        "&cityCode={sido_code}",
                        "&dateCode={date_code}",
                        "&timeCode={time_code}")
  
  Sys.setlocale("LC_ALL", "C")
  
  nec_html <- read_html(nec_url)
  
  nec_raw <- nec_html %>% 
    html_element(css = '#table01') %>% 
    html_table(fill = TRUE)
  
  Sys.setlocale("LC_ALL", "Korean")
  
  nec_tbl <- nec_raw %>% 
    set_names(c("구시군명", "선거인수", "사전투표자수", "사전투표율"))
  
  nec_tbl
  
}

get_early_voting_data_latest("4900", "2", "17")

presid_sigungu_code_2017 <- read_csv("data/사전투표/presid_sigungu_code_2017.csv")

early_voting_code <- presid_sigungu_code_2017 %>% 
  group_by(시도코드, 시도명) %>% 
  summarise(n = n()) %>% 
  ungroup() %>% 
  select(-n)

early_voting_2022_raw <- early_voting_code %>% 
  mutate(사전투표일 = rep(list(c(1, 2)), n())) %>% 
  unnest(사전투표일) %>% 
  mutate(사전투표시간 = rep(list( c(7:18)), 34 )) %>% 
  unnest(사전투표시간) %>% 
  mutate(사전투표시간 = as.character(사전투표시간) %>% str_pad(., 2, "left", pad = "0")) %>% 
  mutate(data = pmap(list(시도코드, 사전투표일, 사전투표시간), get_early_voting_data_latest))


early_voting_2022_tbl <- early_voting_2022_raw %>% 
  mutate(data = map(data, ~.x %>% mutate_all(., as.character ) )) %>%
  unnest(data, names_repair = "unique") %>% 
  mutate(across(선거인수:사전투표율, parse_number))

early_voting_2022_order <- early_voting_2022_tbl %>% 
  filter(구시군명 != "합계") %>% 
  select(시도명, 구시군명, 사전투표일, 시간=사전투표시간, 선거인수, 투표자수=사전투표자수) %>% 
  pivot_wider(names_from=사전투표일, values_from = 투표자수) %>% 
  group_by(시도명, 구시군명) %>% 
  mutate(누적투표수 = max(`1`) + `2`)  %>% 
  ungroup() %>% 
  select(-`2`) %>% 
  pivot_longer(`1`:누적투표수, names_to = "사전투표일", values_to = "누적투표수") %>% 
  mutate(사전투표일 = ifelse(사전투표일 == "누적투표수", "2일", "1일")) %>% 
  mutate(시간순서 = glue::glue("{사전투표일}-{시간}")) %>% 
  arrange(시도명, 구시군명, 시간순서) 

early_voting_2022 <- early_voting_2022_order %>% 
  mutate(사전투표율 = 누적투표수 / 선거인수) %>% 
  mutate(선거구분 = "제8회") %>% 
  relocate(선거구분, .before = 시도명) %>% 
  filter(구시군명 != "합계") %>% 
  mutate(시간 = as.numeric(시간)) %>% 
  mutate(시간 = glue::glue('{str_pad(시간, 2, "left", "0")}시'))

early_voting_2022 %>% 
  write_rds("data/사전투표/지방선거_2022년.rds")


## [엑셀] 2018년 지선 --------------------------

library(readxl)
library(tidyverse)

ev_first_raw <- read_excel("data/사전투표/제7회_경기도_사전투표.xlsx", sheet =  "1일차", skip = 4)
ev_second_raw <- read_excel("data/사전투표/제7회_경기도_사전투표.xlsx", sheet =  "2일차", skip = 4)

ev_first_tbl <- ev_first_raw %>% 
  janitor::clean_names(ascii = FALSE) %>% 
  filter(!is.na(x1)) %>% 
  slice(2:n()) %>% 
  select(-x8) %>% 
  pivot_longer(cols = contains("시"), names_to = "시간", values_to = "투표수") %>% 
  rename(구시군명 = x1,
             선거인수 = x2) %>% 
  mutate(투표수 = parse_number(투표수),
            선거인수 = parse_number(선거인수)) %>% 
  mutate(구시군 = case_when(
    str_detect(구시군명, "고양시") ~ "고양시",
    str_detect(구시군명, "부천시") ~ "부천시",
    str_detect(구시군명, "성남시") ~ "성남시",
    str_detect(구시군명, "수원시") ~ "수원시",
    str_detect(구시군명, "안산시") ~ "안산시",
    str_detect(구시군명, "안양시") ~ "안양시",
    str_detect(구시군명, "용인시") ~ "용인시",
    str_detect(구시군명, "광명시") ~ "광명시",
    str_detect(구시군명, "광주시") ~ "광주시",
    str_detect(구시군명, "군포시") ~ "군포시",
    str_detect(구시군명, "김포시") ~ "김포시",
    str_detect(구시군명, "남양주") ~ "남양주",
    str_detect(구시군명, "의정부") ~ "의정부",
    str_detect(구시군명, "화성시") ~ "화성시",
    str_detect(구시군명, "파주시") ~ "파주시",
    str_detect(구시군명, "평택시") ~ "평택시",
    str_detect(구시군명, "시흥시") ~ "시흥시",
    TRUE ~ 구시군명)) %>% 
  group_by(구시군, 시간) %>% 
  summarise(투표수 = sum(투표수),
               선거인수 = sum(선거인수)) %>% 
  ungroup() %>% 
  mutate(시간 = parse_number(시간)) %>% 
  mutate(시간 = str_pad(시간, width = 2, side = "left", pad = 0)) %>% 
  arrange(구시군, 시간) %>% 
  mutate(일차 = "1일") %>% 
  mutate(선거 = "2018년")  %>% 
  select(선거, 일차, everything())

ev_second_tbl <- ev_second_raw %>% 
  janitor::clean_names(ascii = FALSE) %>% 
  filter(!is.na(x1)) %>% 
  slice(2:n()) %>% 
  select(-x8) %>% 
  pivot_longer(cols = contains("시"), names_to = "시간", values_to = "투표수") %>% 
  rename(구시군명 = x1,
         선거인수 = x2) %>% 
  mutate(투표수 = parse_number(투표수),
         선거인수 = parse_number(선거인수)) %>% 
  mutate(구시군 = case_when(
    str_detect(구시군명, "고양시") ~ "고양시",
    str_detect(구시군명, "부천시") ~ "부천시",
    str_detect(구시군명, "성남시") ~ "성남시",
    str_detect(구시군명, "수원시") ~ "수원시",
    str_detect(구시군명, "안산시") ~ "안산시",
    str_detect(구시군명, "안양시") ~ "안양시",
    str_detect(구시군명, "용인시") ~ "용인시",
    str_detect(구시군명, "광명시") ~ "광명시",
    str_detect(구시군명, "광주시") ~ "광주시",
    str_detect(구시군명, "군포시") ~ "군포시",
    str_detect(구시군명, "김포시") ~ "김포시",
    str_detect(구시군명, "남양주") ~ "남양주",
    str_detect(구시군명, "의정부") ~ "의정부",
    str_detect(구시군명, "화성시") ~ "화성시",
    str_detect(구시군명, "파주시") ~ "파주시",
    str_detect(구시군명, "평택시") ~ "평택시",
    str_detect(구시군명, "시흥시") ~ "시흥시",
    TRUE ~ 구시군명)) %>% 
  group_by(구시군, 시간) %>% 
  summarise(투표수 = sum(투표수),
            선거인수 = sum(선거인수)) %>% 
  ungroup() %>% 
  mutate(시간 = parse_number(시간)) %>% 
  mutate(시간 = str_pad(시간, width = 2, side = "left", pad = 0)) %>% 
  arrange(구시군, 시간) %>% 
  mutate(일차 = "2일") %>% 
  mutate(선거 = "2018년")  %>% 
  select(선거, 일차, everything())


ev_2018_raw <- bind_rows(ev_first_tbl, ev_second_tbl)

ev_2018_tbl <- ev_2018_raw %>% 
  pivot_wider(names_from = 일차, values_from = 투표수) %>% 
  group_by(선거, 구시군) %>% 
  mutate(누적투표수 = max(`1일`) + `2일`)  %>% 
  ungroup() %>% 
  select(-`2일`) %>% 
  pivot_longer(`1일`:누적투표수, names_to = "사전투표일", values_to = "누적투표수") %>% 
  mutate(사전투표일 = ifelse(사전투표일 == "누적투표수", "2일", "1일")) %>% 
  mutate(시간순서 = glue::glue("{사전투표일}-{시간}")) %>% 
  arrange(구시군, 시간순서)   %>% 
  mutate(선거구분 = "지선 (2018)",
         시도명 = "경기도") %>% 
  rename(구시군명 = 구시군) %>% 
  mutate(시간순서 = glue::glue("{사전투표일}-{시간}")) %>% 
  arrange(시도명, 구시군명, 시간순서)  %>% 
  mutate(사전투표율 = 누적투표수 / 선거인수) %>% 
  select("선거구분", "시도명", "시간", "선거인수", "사전투표일", "누적투표수", 
           "시간순서", "사전투표율", "구시군명")

ev_2018_tbl %>% 
  write_rds("data/사전투표/지방선거_2018년.rds")


