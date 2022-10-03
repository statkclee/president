#####################################################################
#
# 서울특별시 보궐, 대선, 지선 (2021~2022)
#
#####################################################################


# 00. Packages -----------------------------------------------

library(tidyverse)
library(readxl)

# 01. 데이터 -------------------------------------------------

local_2021_tbl <- read_rds("data/sido-2021.rds") %>% filter(str_detect(시도, "서울")) %>% pull(data) %>% .[[1]]
local_2022_tbl <- read_rds("data/sido-2022.rds") %>% filter(str_detect(시도, "서울")) %>% pull(data) %>% .[[1]]

presi_2022_tbl <- krvote::election_20220309$득표율 %>%
  filter(str_detect(시도명, "서울"))  %>% 
  pivot_longer(선거인수:계, names_to = "후보", values_to = "득표")

# 02. 정제 -------------------------------------------------
## 2021년 재보궐선거  --------------------------------------
candidate_2021 <- c("국가혁명당허경영", "국민의힘오세훈", "기본소득당신지혜", "더불어민주당박영선", 
                    "무소속신지예", "무소속이도엽", "무소속정동희", "진보당송명숙",
                    "미래당오태양", "민생당이수봉", "신자유민주연합배영규", "여성의당김진아")

local_2021 <- local_2021_tbl %>% 
  group_by(시도명, 구시군, 후보) %>% 
  summarise(득표 = sum(득표)) %>% 
  ungroup() %>% 
  filter(후보 %in% candidate_2021) %>% 
  mutate(구분 = case_when(str_detect(후보, "국민의힘") ~ "국민의힘",
                          str_detect(후보, "더불어민주당") ~ "민주당",
                          TRUE ~ "기타")) %>% 
  group_by(구시군, 후보=구분) %>% 
  summarise(득표 = sum(득표)) %>% 
  ungroup() %>% 
  mutate(시점 = "2021_지선")  

## 2022년 대선  --------------------------------------
candidate_2022 <- c("더불어민주당이재명", 
  "국민의힘윤석열", "정의당심상정", "기본소득당오준호", 
  "국가혁명당허경영", "노동당이백윤", "새누리당옥은호", 
  "신자유민주연합김경재", "우리공화당조원진", 
  "진보당김재연", "통일한국당이경희", "한류연합당김민찬")

presid_2022 <- presi_2022_tbl %>% 
  filter(후보 %in% candidate_2022) %>% 
  mutate(구분 = case_when(str_detect(후보, "국민의힘") ~ "국민의힘",
                        str_detect(후보, "더불어민주당") ~ "민주당",
                        TRUE ~ "기타")) %>% 
  group_by(구시군=구시군명, 후보=구분) %>% 
  summarise(득표 = sum(득표)) %>% 
  ungroup() %>% 
  mutate(시점 = "2022_대선")  

## 2022년 대선  --------------------------------------
candidate_local_2022 <- c("더불어민주당_송영길", 
                          "국민의힘_오세훈", "정의당_권수정", "기본소득당_신지혜", 
                          "무소속_김광종")

local_2022 <- local_2022_tbl %>% 
  filter(변수 %in% candidate_local_2022) %>% 
  mutate(구분 = case_when(str_detect(변수, "국민의힘") ~ "국민의힘",
                        str_detect(변수, "더불어민주당") ~ "민주당",
                        TRUE ~ "기타")) %>% 
  group_by(구시군=구시군명, 후보=구분) %>% 
  summarise(득표 = sum(득표)) %>% 
  ungroup() %>% 
  mutate(시점 = "2022_지선")

## 데이터 결합

seoul_tbl <- bind_rows(local_2022, presid_2022) %>% 
  bind_rows(local_2021) %>% 
  relocate(시점, .before = 구시군)

seoul_tbl %>% 
  write_rds("data/seoul_song_tbl.rds")

# 탐색적 데이터 분석 ---------------------

## 전체 현황 -----------------------------
extrafont::loadfonts()

overall_g <- seoul_tbl %>% 
  mutate(후보 = factor(후보, levels = c("민주당", "국민의힘", "기타"))) %>% 
  group_by(시점, 후보) %>% 
  summarise(득표 = sum(득표)) %>% 
  mutate(득표율 = 득표 / sum(득표)) %>% 
  ggplot(aes(x = 시점, y = 득표율, fill = 후보)) +
    geom_col(width =0.5) +
    facet_wrap( ~ 후보) +
    geom_text(aes(label = scales::percent(득표율, 0.1)), vjust = -1, size = 5) +
    scale_fill_manual(values = c("blue", "red", "gray50")) +
    scale_y_continuous(labels = scales::percent) +
    labs(title = "서울특별시 득표율 (2021 ~ 2022)",
         subtitle = "재보궐, 대선, 지선",
         x = "") +
    theme_bw(base_family = "Maruburi") +
    theme(legend.position = "none")

overall_g
 
## 구청별 현황 -----------------------------
gu_g <- seoul_tbl %>% 
  mutate(후보 = factor(후보, levels = c("민주당", "국민의힘", "기타"))) %>% 
  group_by(시점, 구시군, 후보) %>% 
  summarise(득표 = sum(득표)) %>% 
  mutate(득표율 = 득표 / sum(득표)) %>% 
  ggplot(aes(x = 시점, y = 득표율, fill = 후보)) +
    geom_bar(width =0.5, position = "dodge", stat='identity') +
    facet_wrap( ~ 구시군) +
    geom_text(aes(label = scales::percent(득표율, 0.1)), 
              position=position_dodge(width=0.9),
              vjust = -0.5, size = 3) +
    scale_fill_manual(values = c("blue", "red", "gray50")) +
    scale_y_continuous(labels = scales::percent) +
    labs(title = "서울특별시 구별 득표율 (2021 ~ 2022)",
         subtitle = "재보궐, 대선, 지선",
         x = "") +
    theme_bw(base_family = "Maruburi") +
    theme(legend.position = "none") +
    expand_limits(y = 0.8)

gu_g





