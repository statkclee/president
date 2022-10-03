#####################################################################
#
# 지방선거 2021 년 시도지사
#
#####################################################################


# 00. Packages -----------------------------------------------

library(tidyverse)
library(readxl)

# 01. 데이터 -------------------------------------------------

seoul_tbl <- krvote::by_election_2021 %>% 
  dplyr::filter(str_detect(시도명, "서울")) %>% 
  pivot_wider(names_from = 후보, values_from = 득표수) %>% 
  filter(읍면동명 != "합계", 구분 != "계") %>% 
  pivot_longer(cols = 선거인수:후보_계, names_to = "후보", values_to = "득표" ) %>% 
  mutate(후보 = str_remove(후보, "후보_"))
  
pusan_tbl <- krvote::by_election_2021 %>% 
  dplyr::filter(str_detect(시도명, "부산")) %>% 
  pivot_wider(names_from = 후보, values_from = 득표수) %>% 
  filter(읍면동명 != "합계", 구분 != "계") %>% 
  pivot_longer(cols = 선거인수:후보_계, names_to = "후보", values_to = "득표" ) %>% 
  mutate(후보 = str_remove(후보, "후보_"))


local_2021_tbl <- tibble(시도 = c("서울특별시", "부산광역시"),
       data = list(seoul_tbl, pusan_tbl))

local_2021_tbl %>% 
  write_rds("data/sido-2021.rds")
