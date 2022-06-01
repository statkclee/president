
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

