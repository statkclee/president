#####################################################################
#
# 서울특별시 보궐, 대선, 지선 (2021~2022) + 여론조사
#
#####################################################################


# 00. Packages -----------------------------------------------

library(tidyverse)
library(readxl)

# 01. 데이터 -------------------------------------------------

seoul_tbl  <- read_rds("data/seoul_song_tbl.rds")

# 02. 정당지지율 -------------------------------------------------

party_raw <- read_excel("z:/선거데이터/02_여론조사/제8회_지선_여론조사.xlsx", 
                        sheet = "정당지지도", skip = 3)

party_tbl <- party_raw %>% 
  rename(등록번호 = `...1`) %>% 
  slice(1:10) %>% 
  janitor::clean_names(ascii = FALSE) %>% 
  mutate(조사일자 = str_extract(조사기간, "\\d{2}\\.\\d{1,2}\\.\\d{1,2}")) %>% 
  select(등록번호, 조사일자, 더불어민주당, 국민의힘, 정의당, 기타정당, 응답_유보층) %>% 
  pivot_longer(cols = 더불어민주당:응답_유보층, 
               names_to = "정당",
               values_to = "지지율") %>% 
  mutate(지지율 = parse_number(지지율) / 100) %>% 
  mutate(조사일자 = lubridate::ymd(조사일자)) %>% 
  mutate(정당 = factor(정당, levels = c("국민의힘", "더불어민주당", "정의당", "기타정당", "응답_유보층")))
  
party_mean_tbl <- party_tbl %>% 
  group_by(조사일자, 정당) %>% 
  summarise(지지율 = mean(지지율)) %>% 
  ungroup() 

party_tbl %>% 
  ggplot(aes(x = 조사일자, y = 지지율, color = 정당)) +
    geom_point() +
    geom_line(data = party_mean_tbl, aes(x = 조사일자, y = 지지율)) +
    scale_color_manual(values = c("red", "blue", "yellow", "gray70", "gray30")) +
    scale_y_continuous(labels = scales::percent) +
    scale_x_date(date_labels = "%m월%d일") +
    theme_bw(base_family = "MaruBuri") +
    labs(title = "제8회 지방선거 여론조사",
         subtitle = "후보자등록 신청 마감일('22. 5. 14.) 이후 여론조사결과")


# 3. 서울시장 -------------------------------------------------
## 3.1. 여론조사 결과 -----------------------------------------
seoul_raw <- read_excel("z:/선거데이터/02_여론조사/제8회_지선_여론조사.xlsx", 
                        sheet = "서울(광)", skip = 3)

seoul_interview <- seoul_raw %>% 
  slice(1:8) %>% 
  rename(등록번호 = `...1`) %>% 
  janitor::clean_names(ascii = FALSE) %>% 
  mutate(조사일자 = str_extract(조사기간, "\\d{2}\\.\\d{1,2}\\.\\d{1,2}")) %>% 
  mutate(구분 = "전화인터뷰")
  
seoul_ars <- seoul_raw %>% 
  slice(82:(82+12)) %>% 
  rename(등록번호 = `...1`) %>% 
  janitor::clean_names(ascii = FALSE) %>% 
  mutate(조사일자 = str_extract(조사기간, "\\d{2}\\.\\d{1,2}\\.\\d{1,2}")) %>% 
  mutate(구분 = "ARS")

seoul_tbl <- bind_rows(seoul_interview, seoul_ars) %>% 
  select(등록번호, 조사일자, 구분, 더불어민주당_송영길, 
         국민의힘_오세훈, 정의당_권수정, 기본소득당_신지혜, 
         무소속_김광종, 기타후보, 응답_유보층) %>% 
  pivot_longer(cols = 더불어민주당_송영길:응답_유보층,
               names_to = "정당",
               values_to = "지지율")  %>% 
  mutate(조사일자 = lubridate::ymd(조사일자)) %>% 
  mutate(지지율 = parse_number(지지율) / 100) %>% 
  mutate(정당 = factor(정당, levels = c("국민의힘_오세훈", 
                                    "더불어민주당_송영길",
                                    "정의당_권수정",
                                    "기본소득당_신지혜", 
                                    "무소속_김광종",
                                    "기타후보", 
                                    "응답_유보층" )))

## 3.2. 여론조사 평균 -----------------------------------------
seoul_mean_tbl <- seoul_tbl %>%
  group_by(조사일자, 정당) %>%
  summarise(지지율 = mean(지지율, na.rm = TRUE)) %>%
  ungroup()

## 3.3. 최종 결과 -----------------------------------------
seoul_actual <- tibble(등록번호 = "10000",
       조사일자 = as.Date("2022-06-01"), 
       구분     = "실제선거",
       정당     = "더불어민주당_송영길",
       지지율   = 0.3923
       ) %>% 
  add_row(등록번호 = "10000",
          조사일자 = as.Date("2022-06-01"), 
          구분     = "실제선거",
          정당     = "국민의힘_오세훈",
          지지율   = 0.5905) %>% 
  add_row(등록번호 = "10000",
          조사일자 = as.Date("2022-06-01"), 
          구분     = "실제선거",
          정당     = "정의당_권수정",
          지지율   = 0.0121)   

## 3.4. 연결선 -----------------------------------------
seoul_interpolation <- seoul_mean_tbl %>% 
  filter(조사일자 == max(조사일자)) %>% 
  bind_rows(seoul_actual %>% 
              select(조사일자, 정당, 지지율))

seoul_polls_g <- seoul_tbl %>% 
  ggplot(aes( x= 조사일자, y = 지지율, color = 정당)) +
  geom_point() +
  geom_line(data = seoul_mean_tbl) +
  scale_color_manual(values = c("red", "blue", "yellow", "gray30", "gray40", "gray50", "gray60")) +
  scale_y_continuous(labels = scales::percent) +
  scale_x_date(date_labels = "%m월%d일") +
  theme_bw(base_family = "MaruBuri") +
  labs(title = "제8회 지방선거 여론조사 - 서울시장",
       subtitle = "후보자등록 신청 마감일('22. 5. 14.) 이후 여론조사결과") +
  geom_point(data = seoul_actual, size = 5) +
  geom_line(data = seoul_interpolation, linetype =2) +
  geom_text(data = seoul_actual, aes(label = scales::percent(지지율) ), vjust= -1) +
  theme(panel.background = element_rect(fill = "gray90"))  

seoul_polls_g  

## 여론조사 유형별로 구분 ------------------

seoul_polls_type_g <- seoul_tbl %>% 
  ggplot(aes( x= 조사일자, y = 지지율, color = 정당)) +
  geom_point() +
  geom_smooth(se = FALSE, method = "lm") +
  scale_color_manual(values = c("red", "blue", "yellow", "gray30", "gray40", "gray50", "gray60")) +
  scale_y_continuous(labels = scales::percent) +
  scale_x_date(date_labels = "%m월%d일") +
  theme_bw(base_family = "MaruBuri") +
  labs(title = "제8회 지방선거 조사방법별 여론조사 - 서울시장",
       subtitle = "후보자등록 신청 마감일('22. 5. 14.) 이후 여론조사결과") +
  facet_wrap( ~ 구분) +
  theme(panel.background = element_rect(fill = "gray90"))    

seoul_polls_type_g
