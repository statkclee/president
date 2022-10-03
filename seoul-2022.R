#####################################################################
#
# 지방선거 2022 년 시도지사 선거
#
#####################################################################


# 00. Packages ------------------------------------------------------------

library(tidyverse)
library(readxl)

# 01. 함수 ----------------------------------------------------------------------
## 변수명 정리하는 함수
make_varnames <- function(dataframe) {
  
  # 템플릿 변수명 ----------------------
  template_colnames <- c("선거구명", "구시군명", "읍면동명", "구분", "선거인수", 
                         "투표수", "계", "무효투표수", "기권수")
  
  data_colname <- dataframe %>% names() 
  
  # 후보명 칼럼 ----------------------
  candidate_mask <- ! data_colname %in% template_colnames
  
  # 후보명 추출 ----------------------
  row_one_name <- dataframe %>% 
    slice(1) %>% 
    pivot_longer(cols = everything()) %>% 
    pull()
  
  candidates <- row_one_name[candidate_mask]
  
  # 후보명 변수에 치환 ----------------------
  data_colname[candidate_mask] <- candidates
  
  varname_tbl <- dataframe %>% 
    set_names(data_colname)
  
  return(varname_tbl)
}

## 중복값 제거하고 분석 가능하게 준비하는 함수
clean_contents <- function(dataframe) {
  
  contents_tbl <- dataframe %>% 
    janitor::clean_names(ascii = FALSE) %>% 
    select(!starts_with("na")) %>% 
    mutate(구분 = ifelse(is.na(구분), 읍면동명, 구분))  %>% 
    filter(!is.na(읍면동명), 읍면동명 != "합계", 구분 != "소계") %>% 
    pivot_longer(cols = 선거인수:기권수, names_to = "변수", values_to="득표") %>% 
    mutate(득표 = parse_number(득표))
  
  contents_tbl
}

split_data <- raw_data %>% 
  fill(선거구명, .direction = "up") %>% 
  group_split(선거구명) 

sejong <- make_varnames(split_data[[10]])

clean_contents(sejong) %>% 
  filter(str_detect(변수, "이춘희|최민호")) %>% 
  group_by(변수) %>% 
  summarise(득표 = sum(득표, na.rm = TRUE))


# 01. Data ----------------------------------------------------------------

raw_data <- read_excel("z:/선거데이터/01_대선_총선_지선_데이터/01_지방선거/제8회_지선_2022/시도지사선거.xlsx")

raw_data %>% 
  count(선거구명)

sido_tbl <- raw_data %>% 
  filter(!is.na(선거구명)) %>% 
  group_split(선거구명) %>% 
  enframe(value = "원데이터") %>% 
  mutate(varname = map(원데이터, make_varnames)) %>% 
  mutate(data = map(varname, clean_contents)) %>% 
  mutate(시도 = map_chr(data, ~.x %>% select(선거구명) %>% pull(선거구명) %>% unique(.)) ) %>% 
  select(시도, data) 

sido_tbl

## 데이터 정합성 -----------------------------------------------------------------
library(testthat)
test_that("2022 서울시장", {
                    
  song_votes <- sido_tbl %>% 
    filter(str_detect(시도, "서울")) %>% 
    pull(data) %>% .[[1]] %>% 
    group_by(변수) %>% 
    summarise(득표 = sum(득표, na.rm = TRUE)) %>% 
    filter(str_detect(변수, "송영길")) %>% 
    pull(득표)
  
  expect_equal(song_votes, parse_number("1,733,183"))
})

# 02. 내보내기 ----------------------------------------------------------------

sido_tbl %>% 
  write_rds("data/sido-2022.rds")
