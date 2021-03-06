---
layout: page
title: "제8회 지방선거"
subtitle: "경기지사"
author:
- name: "데이터 과학자 이광춘"
date: "2022-05-31"
tags: ["여론조사", "제20대", "대통령 선거", "후진국", "중진국", "선진국", "선거일정", "경선"]
output:
  html_document: 
    include:
      after_body: footer.html
      before_body: header.html
    toc: yes
    toc_depth: 2
    toc_float: true
    highlight: tango
    code_folding: hide
    number_section: true
    self_contained: true
bibliography: bibliography_presid.bib
csl: biomed-central.csl
urlcolor: blue
linkcolor: blue
editor_options: 
  chunk_output_type: console
---



# 데이터 {#president-tilemap_sigungu}

## 대선


```r
library(tidyverse)

## 2012년 대선
gg_2012_raw <- krvote::election_20121219$득표율 %>% 
  filter(str_detect(시도명, "경기")) %>% 
  select(-선거인수, - 투표수) %>% 
  pivot_longer(박근혜:김순자, names_to = "후보", values_to = "득표수")  %>% 
  mutate(정당 = case_when(str_detect(후보, "박근혜") ~ "국민의힘",
                          str_detect(후보, "문재인") ~ "민주당",
                          TRUE ~ "그외정당")) %>% 
  mutate(구시군명 = ifelse(str_detect(구시군명, "여주"), "여주시", 구시군명) ) %>% 
  group_by(시도명, 구시군명, 정당) %>% 
  summarise( 득표수 = sum(득표수, na.rm = TRUE)) %>% 
  mutate(선거 = "2012년") %>% 
  ungroup() %>% 
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
  select(선거, 시도명, 구시군명=구시군, 정당, 득표수)



## 2017년 대선
gg_2017_raw <- krvote::election_20170509$득표율 %>% 
  filter(str_detect(시도명, "경기")) %>% 
  select(-선거인수, - 투표수) %>% 
  pivot_longer(문재인:김민찬, names_to = "후보", values_to = "득표수")  %>% 
  mutate(정당 = case_when(str_detect(후보, "홍준표") ~ "국민의힘",
                          str_detect(후보, "안철수") ~ "국민의힘",
                          str_detect(후보, "유승민") ~ "국민의힘",
                          str_detect(후보, "문재인") ~ "민주당",
                          TRUE ~ "그외정당")) %>% 
  group_by(시도명, 구시군명, 정당) %>% 
  summarise( 득표수 = sum(득표수, na.rm = TRUE)) %>% 
  mutate(선거 = "2017년") %>% 
  ungroup() %>% 
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
  select(선거, 시도명, 구시군명=구시군, 정당, 득표수)
  

## 2022년 대선
gg_2022_raw_excel <- readxl::read_excel("data/2022년_개표결과_대통령선거_전체.xlsx") 

gg_2022_raw <- gg_2022_raw_excel %>% 
  filter(str_detect(시도, "경기")) %>% 
  mutate(읍면동명 = ifelse(is.na(읍면동명), 구시군, 읍면동명),
         투표구명 = ifelse(is.na(투표구명), 읍면동명, 투표구명)) %>% 
  filter(!str_detect(구시군, "합계"),
         !str_detect(읍면동명, "합계"),
         !str_detect(투표구명, "소계")) %>% 
  janitor::clean_names(ascii = FALSE) %>% 
  select(-선거인수, - 투표수, -무효투표수, -기권수) %>% 
  pivot_longer(더불어민주당_이재명:한류연합당_김민찬, names_to = "후보", values_to = "득표수") %>% 
  separate(후보, into = c("정당", "후보"), sep = "_") %>% 
  mutate(득표수 = parse_number(득표수),
         계     = parse_number(계)) %>% 
  mutate(정당 = case_when(str_detect(후보, "이재명") ~ "민주당",
                          str_detect(후보, "윤석열") ~ "국민의힘",
                          TRUE ~ "그외정당")) %>% 
  rename(시도명 = 시도, 
         구시군명 = 구시군) %>% 
  group_by(시도명, 구시군명, 정당) %>% 
  summarise( 득표수 = sum(득표수, na.rm = TRUE)) %>% 
  mutate(선거 = "2022년") %>% 
  ungroup() %>% 
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
  select(선거, 시도명, 구시군명=구시군, 정당, 득표수)
```

## 총선


```r
## 2016년 총선 -----------------------
gg_2016_raw <- krvote::general_2016 %>% 
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
  ungroup() 


gg_2016_dat <- gg_2016_raw %>% 
  filter( str_detect(구분, "국민의당|노동당|녹색당|더불어민주당|무소속|민중연합당|새누리당|정의당")) %>% 
  separate(구분, into = c("정당", "후보"), sep = " ") %>% 
  mutate(정당 = case_when(str_detect(정당, "민주당") ~ "민주당",
                          str_detect(정당, "새누리당") ~ "국민의힘",
                          str_detect(정당, "국민의당") ~ "국민의힘",
                          TRUE ~ "그외정당")) %>%   
  group_by(구시군명, 정당) %>% 
  summarise(득표수 = sum(득표수, na.rm = TRUE)) %>% 
  # left_join( gg_2016_raw %>% filter(구분 == "계") %>% rename(합계 = 득표수)) %>% 
  ungroup() %>% 
  mutate(선거 = "2016년")

## 2020년 총선 -----------------------
gg_2020_raw <- krvote::general_2020 %>% 
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
  ungroup()

gg_2020_dat <- gg_2020_raw %>% 
  separate(구시군명, into = c("선거구", "구시군명"), sep = "_") %>% 
  mutate(구시군명 = ifelse(is.na(구시군명), 선거구, 구시군명)) %>% 
  filter( str_detect(구분, "국가혁명배당금당|기독자유통일당|기본소득당|더불어민주당|무소속|미래통합당|민생당|민중당|우리공화당|정의당|친박신당")) %>% 
  separate(구분, into = c("정당", "후보"), sep = " ") %>% 
  mutate(정당 = case_when(str_detect(정당, "민주당") ~ "민주당",
                          str_detect(정당, "새누리당") ~ "국민의힘",
                          str_detect(정당, "국민의당") ~ "국민의힘",
                          TRUE ~ "그외정당")) %>%   
  group_by(구시군명, 정당) %>% 
  summarise(득표수 = sum(득표수, na.rm = TRUE)) %>% 
  # left_join( gg_2020_raw %>% filter(구분 == "계") %>% rename(합계 = 득표수)) %>% 
  ungroup() %>% 
  mutate(선거 = "2020년")
```

## 지선


```r
## 2014년 지방선거

clean_df <- function(raw_df) {
  clean_df <- raw_df %>% 
    pivot_longer(선거인수:기권수)
  return(clean_df)
}

gg_2014_raw <- krvote::local_sgg_20140604$경기도 %>% 
  mutate(clean_data = map(data, clean_df) )
```

```
Error in `mutate()`:
! Problem while computing `clean_data = map(data, clean_df)`.
Caused by error in `chr_as_locations()`:
! Can't subset columns that don't exist.
✖ Column `선거인수` doesn't exist.
```

```r
gg_2014_total <- gg_2014_raw %>% 
  select(-data) %>% 
  unnest(clean_data) %>% 
  separate(name, into = c("정당", "후보"), sep = "\n") %>% 
  filter(정당 == "계") %>% 
  group_by(시도명, 구시군) %>% 
  summarise(합계 = sum(value)) %>% 
  ungroup()
```

```
Error in select(., -data): 객체 'gg_2014_raw'를 찾을 수 없습니다
```

```r
gg_2014_dat <- gg_2014_raw %>%
  select(-data) %>% 
  unnest(clean_data) %>% 
  separate(name, into = c("정당", "후보"), sep = "\n") %>% 
  filter(str_detect(정당, "녹색당|무소속|새누리당|새정치당|새정치민주연합|정의당|통합진보당")) %>%
  # filter(!is.na(후보)) %>% 
  mutate(정당 = case_when(str_detect(정당, "민주연합") ~ "민주당",
                          str_detect(정당, "새누리당") ~ "국민의힘",
                          TRUE ~ "그외정당")) %>%   
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
  group_by(시도명, 구시군명, 정당) %>% 
  summarise(득표수 = sum(value)) %>% 
  ungroup() %>% 
  # left_join( gg_2014_total ) %>% 
  mutate(선거 = "2014년") %>% 
  select(선거, 구시군명, 정당, 득표수)
```

```
Error in select(., -data): 객체 'gg_2014_raw'를 찾을 수 없습니다
```

```r
## 2018년 지방선거

gg_2018_raw <- krvote::local_sgg_20180613 %>% 
  filter(시도 == "경기도") %>% 
  mutate(clean_data = map(data, clean_df) ) %>% 
  select(-data) %>% 
  unnest(clean_data) %>% 
  separate(name, into = c("정당", "후보"), sep = "_") %>% 
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
                      TRUE ~ 구시군명))  


gg_2018_total <- gg_2018_raw %>%   
  filter(정당 == "계") %>% 
  group_by(시도명, 구시군명) %>% 
  summarise(합계 = sum(value)) %>% 
  ungroup()

gg_2018_dat <- gg_2018_raw %>% 
  filter(str_detect(정당, "대한애국당|더불어민주당|무소속|민주평화당|민중당|바른미래당|자유한국당|정의당")) %>% 
  mutate(정당 = case_when(str_detect(정당, "민주당") ~ "민주당",
                          str_detect(정당, "자유한국당") ~ "국민의힘",
                          str_detect(정당, "바른미래당") ~ "국민의힘",
                          TRUE ~ "그외정당")) %>%   
  group_by(시도명, 구시군, 정당) %>% 
  summarise(득표수 = sum(value)) %>% 
  ungroup() %>% 
  # left_join( gg_2018_total )
  mutate(선거 = "2018년") %>% 
  select(선거, 구시군명=구시군, 정당, 득표수)
```

## * 종합



```r
## 데이터 결합

gg_raw <- bind_rows(gg_2012_raw, gg_2017_raw) %>% 
  bind_rows(gg_2022_raw) %>% 
  select(선거, 구시군명, 정당, 득표수) %>% 
  bind_rows(gg_2020_dat) %>% 
  bind_rows(gg_2016_dat) %>% 
  bind_rows(gg_2014_dat) %>% 
  bind_rows(gg_2018_dat)
```

```
Error in list2(...): 객체 'gg_2014_dat'를 찾을 수 없습니다
```

```r
gg_raw %>% 
  write_rds("data/gg_raw.rds")
```

```
Error in saveRDS(x, con, version = version, refhook = refhook, ascii = text): 객체 'gg_raw'를 찾을 수 없습니다
```


# 시각화

## 표


```r
gg_raw_tbl <- gg_raw %>% 
  group_by(선거, 정당) %>% 
  summarise(득표수 = sum(득표수)) %>% 
  ungroup() %>% 
  mutate(득표율 = 득표수 / 합계) 
```



```r
gg_raw_tbl %>% 
  mutate(text = glue::glue("{scales::comma(득표수)} / {scales::comma(합계)} = {scales::percent(득표율, 0.1)}")) %>% 
  select(선거, 정당, text) %>% 
  pivot_wider(names_from = 정당, values_from = text) %>% 
  select(선거, 민주당, 국민의힘, 그외정당)
```

## 그래프


```r
gg_raw_tbl %>% 
  ggplot(aes(x = 선거, y = 득표율, color = 정당, group = 정당)) +
    geom_point() +
    geom_line()
```


# echarts


```r
# https://www.infoworld.com/article/3607068/plot-in-r-with-echarts4r.html

library(echarts4r)
gg_raw %>%
  group_by(선거) %>% 
  summarise(득표수 = sum(득표수) ) %>% 
  ungroup() %>% 
  e_charts(x = 선거) %>% 
  e_line(serie = 득표수)
```

```
Error in group_by(., 선거): 객체 'gg_raw'를 찾을 수 없습니다
```

# echarts 지도


```r
library(echarts4r)
library(echarts4r.maps)
```

```
Error in library(echarts4r.maps): 'echarts4r.maps'이라고 불리는 패키지가 없습니다
```

```r
e_charts() %>%
  em_map("South_Korea") %>% 
  e_map(map = "South_Korea") %>% 
  e_visual_map()
```

```
Error in em_map(., "South_Korea"): 함수 "em_map"를 찾을 수 없습니다
```

# echarts globe


```r
library(echarts4r.assets)

airports <- read.csv(
  paste0("https://raw.githubusercontent.com/plotly/datasets/",
         "master/2011_february_us_airport_traffic.csv")
)

airports |> 
  e_charts(long) |> 
  e_globe(
    environment = ea_asset("starfield"),
    base_texture = ea_asset("world"), 
    globeOuterRadius = 100
  ) |> 
  e_scatter_3d(lat, cnt, coord_system = "globe", blendMode = 'lighter') |> 
  e_visual_map(inRange = list(symbolSize = c(1, 10)))
```

```
Error in path.expand(path): 인자 'path'가 올바르지 않습니다.
```


# crosstalk


```r
gg_raw <- read_rds("data/gg_raw.rds")

gg_raw %>% 
  filter(구시군명 == "가평군") %>% 
  mutate(정당 = factor(정당, levels = c("민주당", "국민의힘", "그외정당"))) %>% 
  ggplot(aes(x = 선거, y = 득표수, color = 정당, group = 정당)) +
    geom_line() +
    geom_point() +
    scale_color_manual(values = c("blue", "red", "gray70"))
```

```
Error in `filter()`:
! Problem while computing `..1 = 구시군명 == "가평군"`.
Caused by error:
! 객체 '구시군명'를 찾을 수 없습니다
```

