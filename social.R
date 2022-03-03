library(gtrendsR)
library(tidyverse)
library(readxl)
library(httr)
library(rvest)
library(extrafont)
loadfonts()

# 1. 검색 트렌드 --------------------------------
## 1.1. 구글 ------------------------------------
### 1.1.1. 구글 트렌드데이터 다운로드 ----------------------

Sys.setlocale("LC_ALL", "C")

get_google_trends <- function() {
  
  # time_span <- glue::glue("2021-11-01 2022-01-29}") %>% as.character(.)
  time_span <- glue::glue("2022-01-01 {Sys.Date()}") %>% as.character(.)
  
  hubo_raw <- gtrends(keyword = c("이재명", "윤석열", "안철수", "심상정"),
                      geo = "KR",
                      hl = "ko-KR",
                      time = time_span,
                      low_search_volume = FALSE,
                      cookie_url = "http://trends.google.com/Cookies/NID",
                      tz = 0,
                      # tz = "Asia/Seoul", # 540, "Asia/Seoul", GMT+9, 9(시간)*60(분)
                      gprop = "web")
  
  hubo_raw
}

hubo_raw <- get_google_trends()

Sys.setlocale("LC_ALL", "Korean")

hubo_raw %>%
  write_rds(glue::glue('data/social/google_trends_{Sys.Date()}.rds'))

### 1.1.2. 구글 트렌드 시각화 ----------------------

# hubo_raw <-
#   read_rds(glue::glue('data/social/google_trends_{Sys.Date()}.rds'))
# 
# data_date <- hubo_raw$interest_over_time %>%
#   mutate(date = lubridate::ymd(date)) %>%
#   filter(date == max(date) -1) %>%
#   pull(date) %>%
#   unique()
# 
# hubo_raw$interest_over_time %>%
#   as_tibble() %>%
#   filter(str_detect(keyword, "이재명|윤석열|안철수|심상정")) %>%
#   mutate(#date = lubridate::force_tz(date, tzone = "Asia/Seoul") %>% as.Date(),
#     date = lubridate::ymd(date),
#     keyword = factor(keyword, levels = c("이재명", "윤석열", "안철수", "심상정", "김건희")),
#     hits = as.numeric(hits)) %>%
#   rename(후보 = keyword) %>%
#   filter(date != max(date)) %>% 
#   ggplot(aes(x = date, y = hits, color = 후보 )) +
#   geom_point(show.legend = FALSE) +
#   scale_size_continuous(range = c(0.5, 1.5)) +
#   geom_line() +
#   scale_x_date(date_labels = "%m월%d일", limits = c(as.Date("2022-1-01"), as.Date("2022-03-09"))) +
#   theme_bw(base_family = "NanumBarunPen") +
#   theme(legend.position = "top",
#         legend.title=element_text(size=12),
#         legend.text=element_text(size=10),
#         strip.text.x = element_text(size = rel(1.3), colour = "black", family = "NanumMyeongjo", face="bold"),
#         axis.text.y = element_text(size = rel(1.2), colour = "gray35", family = "NanumBarunpen", face="bold"),
#         axis.text.x = element_text(size = rel(1.1), colour = "black", family = "NanumBarunpen", face="bold"),
#         strip.background=element_rect(fill="gray95"),
#         plot.title=element_text(size=25, face="bold", family = "NanumBarunpen"),
#         plot.subtitle=element_text(face="bold", size=17, colour="grey10", family = "NanumBarunpen"))  +
#   scale_color_manual(values = c("blue", "red", "#EA5505", "yellow", "black")) +
#   labs(x = "",
#        y = "검색수(hits)",
#        title = "Google Trends 서비스",
#        subtitle = glue::glue("지역: 대한민국, 시점: 2022년 01월 01일 ~ {format(data_date, '%Y년 %m월 %d일')}"),
#        caption = "데이터 출처: 구글 트렌드 API, gtrendsR 패키지")  +
#   geom_vline(xintercept = Sys.Date(), linetype="dashed", color = "black") +
#   geom_vline(xintercept = as.Date("2022-03-09"), linetype="dashed", color = "black") +
#   annotate("text", x = Sys.Date()-1.5, y = 99, label= glue::glue("현재:\n{format(Sys.Date(), '%m월%d일')}"),
#            colour="black", size = 5, family = "NanumBarunpen") +
#   annotate("text", x = as.Date("2022-03-09")-1.5, y = 99, label="선거일:\n 3월 9일", colour="black",
#            size = 5, family = "NanumBarunpen")


## 1.2. 네이버 ----------------------
### 1.2.1. 네이버 데이터 다운로드 ----------------------

Sys.setenv(RETICULATE_PYTHON="C:/Users/statkclee/anaconda3/python.exe")
reticulate::repl_python()

# newsletter/pynaver_package.py

### 1.2.2. 시각화 ----------------------

# naver_json <- jsonlite::read_json("data/social/naver_20220303.json")
# 
# naver_tbl <- naver_json$results %>%
#   enframe() %>%
#   mutate(keyword = map_chr(value, "title")) %>%
#   mutate(data = map(value, "data")) %>%
#   unnest(data) %>%
#   mutate(date = map_chr(data, "period"),
#          ratio = map_dbl(data, "ratio")) %>%
#   select(keyword, date, ratio)
# 
# naverdata_date <- naver_tbl %>%
#   mutate(date = lubridate::ymd(date)) %>%
#   filter(date == max(date)) %>%
#   pull(date) %>% unique()
# 
# trend_naver_g <- naver_tbl %>%
#   mutate(date = lubridate::ymd(date),
#          keyword = factor(keyword, levels = c("이재명", "윤석열", "안철수", "심상정", "김건희"))) %>%
#   rename(후보 = keyword) %>%
#   ggplot(aes(x = date, y = ratio, color = 후보 )) +
#   geom_point(show.legend = FALSE) +
#   scale_size_continuous(range = c(0.5, 1.5)) +
#   geom_line() +
#   scale_x_date(date_labels = "%m월%d일") +
#   theme_bw(base_family = "NanumBarunPen") +
#   theme(legend.position = "top",
#         legend.title=element_text(size=15),
#         legend.text=element_text(size=13),
#         strip.text.x = element_text(size = rel(1.3), colour = "black", family = "NanumMyeongjo", face="bold"),
#         axis.text.y = element_text(size = rel(1.5), colour = "gray35", family = "NanumBarunpen", face="bold"),
#         axis.text.x = element_text(size = rel(1.3), colour = "black", family = "NanumBarunpen", face="bold"),
#         strip.background=element_rect(fill="gray95"),
#         plot.title=element_text(size=18, face="bold", family = "NanumBarunpen"),
#         plot.subtitle=element_text(face="bold", size=13, colour="grey10", family = "NanumBarunpen"))  +
#   scale_color_manual(values = c("blue", "red", "#EA5505", "yellow", "black")) +
#   labs(x = "",
#        y = "검색수(hits)",
#        title = "네이버 검색어 트렌드 서비스",
#        subtitle = glue::glue("지역: 대한민국, 시점: 2022년 12월 01일 ~ {format(naverdata_date, '%Y년 %m월 %d일')}"),
#        caption = "데이터 출처: 네이버 검색어 트렌드 API")   +
#   geom_vline(xintercept = Sys.Date(), linetype="dashed", color = "black") +
#   geom_vline(xintercept = as.Date("2022-03-09"), linetype="dashed", color = "black") +
#   annotate("text", x = Sys.Date()-1, y = 99, label= glue::glue("현재:\n{format(Sys.Date(), '%m월%d일')}"),
#            colour="black", size = 5, family = "NanumBarunpen") +
#   annotate("text", x = as.Date("2022-03-09")-1, y = 99, label="선거일:\n3월 9일",
#            colour="black", size = 5, family = "NanumBarunpen")
# 
# 
# trend_naver_g

