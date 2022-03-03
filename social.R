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

# 2. (구글) 연관검색어 ----------------------------------------------------

## 2.1. 데이터 ------------------------------------------------------------

ysy <- snsdata::get_related_search_candidate("윤석열")
ljm <- snsdata::get_related_search_candidate("이재명")
acs <- snsdata::get_related_search_candidate("안철수")

related_google_tbl <- bind_rows(acs, ljm, ysy)

related_google_tbl %>%
  write_rds(glue::glue("data/social/related_google_tbl_{Sys.Date() %>% str_remove_all(., '-')}.rds"))

## 2.2. 시각화 ------------------------------------------------------------

related_google_tbl <- read_rds(glue::glue("data/social/related_google_tbl_{Sys.Date() %>% str_remove_all(., '-')}.rds"))

library(tidygraph)
library(ggraph)
library(patchwork)
library(ggforce)

convert_from_wide_to_nw <- function(rawdata) {
  
  lvl_one_tbl <- rawdata %>%
    select(from = hubo, to = lvl_01) %>%
    distinct(.)
  
  lvl_two_tbl <- rawdata %>%
    select(from = lvl_01, to = lvl_02)
  
  nw_tbl <- bind_rows(lvl_one_tbl, lvl_two_tbl)
  
  nw_tbl
}


draw_related_keywords <- function(hubo_name) {
  
  network_viz_tbl <-  convert_from_wide_to_nw(related_google_tbl %>% filter(hubo == hubo_name))
  
  network_viz_tbl %>%
    as_tbl_graph(directed=FALSE) %>%
    activate(nodes) %>%
    mutate(eigen = centrality_eigen(),
           group = group_infomap()) %>%
    mutate(관심사항 = ifelse(str_detect(name, "윤석열 안철수 단일화"), 1, 0 ) ) %>%   
    ggraph(layout='nicely') +
      geom_edge_link(color='gray50', alpha=.2) +
      geom_node_point(aes(color=factor(group), size=eigen)) +
      geom_node_text(aes(label=name), size=3, repel=TRUE) +
      theme_minimal() +
      theme_graph(base_family = "NanumBarunPen") +
      ggtitle(glue::glue("{hubo_name} : 구글 검색 연관검색어")) +
      theme(legend.position = "none",
            plot.title=element_text(size=16, face="bold", family = "NanumBarunpen"),
            plot.subtitle=element_text(face="bold", size=13, colour="grey10", family = "NanumBarunpen")) +
      geom_mark_hull(aes(x = x, y = y, fill = "red", filter = 관심사항 == 1,
                         label = "윤안 단일화",
                         con.colour = "black",
                         label.buffer = unit(100, 'mm') ))
}


ljm_g <- draw_related_keywords("이재명")
ysy_g <- draw_related_keywords("윤석열")
acs_g <- draw_related_keywords("안철수")

ljm_g  + ysy_g + acs_g


# 3. 유튜브 ----------------------------------------------------
## 3.1. 데이터 ------------------------------------------------------------
library(tuber)

yt_oauth(app_id = Sys.getenv("yt_client_id"),
         app_secret = Sys.getenv("yt_secret"),
         token = "")

candidate_video_raw <- snsdata::candidates %>%
  filter(후보명 %in% c("이재명", "윤석열", "안철수", "심상정")) %>%
  mutate(data = map2(후보명, channel_id, snsdata::get_candidate_video_stat, video_date = "20220101"))

candidate_video_raw %>%
  write_rds(glue::glue("data/social_youtube_raw_{Sys.Date() %>% str_remove_all('-')}.rds"))

## 3.2. 시각화 -------------------------------------------------

candidate_video_raw <-
  read_rds(glue::glue("data/social_youtube_raw_{Sys.Date() %>% str_remove_all('-')}.rds"))

yt_stat <- candidate_video_raw %>%
  select(data) %>%
  unnest(data)

yt_data_date <- yt_stat %>%
  mutate(게시일 = as.Date(publishedAt)) %>%
  filter(게시일 == max(게시일)) %>%
  pull(게시일) %>% unique()

youtube_g <- yt_stat %>%
  mutate(게시일 = as.Date(publishedAt)) %>%
  pivot_longer(조회수:댓글수) %>%
  mutate(value = as.numeric(value)) %>%
  mutate(후보명 = factor(후보명, levels = c("이재명", "윤석열", "안철수", "심상정"))) %>%
  mutate(name = factor(name, levels = c("조회수", "좋아요수", "댓글수"))) %>% 
  ggplot(aes(x=게시일, y= value, color = 후보명,
             text = glue::glue("후보명: {후보명}\n",
                               "댓글/조회/좋아요: {scales::comma(value, accuracy=1)}\n",
                               "동영상: {video_id}\n",
                               "게시일: {format(게시일, '%m월% %d일')}") )) +
    geom_point(size = 0.5) +
    geom_smooth(se = FALSE, method = "loess", span = 0.75) +
    scale_x_date(date_labels = "%m월%d") +
    scale_y_sqrt(labels = scales::comma) +
    theme_bw(base_family = "NanumBarenPen") +
    scale_color_manual(values=c("blue", "red", "#EA5505", "yellow")) +
    labs(x        = "",
         y        = "",
         title    = "대선 후보 유튜브 활동성 통계",
         subtitle = glue::glue("시점: 2021년 12월 01일 ~ {format(naverdata_date, '%Y년 %m월 %d일')}")) +
    facet_wrap(~name, scales = "free_y") +
    theme_bw(base_family = "NanumBarunPen") +
    theme(legend.position = "top",
          legend.title=element_text(size=13),
          legend.text=element_text(size=11),
          strip.text.x = element_text(size = rel(1.2), colour = "black", family = "NanumMyeongjo", face="bold"),
          axis.text.y = element_text(size = rel(1.0), colour = "gray35", family = "NanumBarunpen", face="bold"),
          axis.text.x = element_text(size = rel(1.0), colour = "black", family = "NanumBarunpen", face="bold"),
          strip.background=element_rect(fill="gray95"),
          plot.title=element_text(size=18, face="bold", family = "NanumBarunpen"),
          plot.subtitle=element_text(face="bold", size=13, colour="grey10", family = "NanumBarunpen"))

ggplotly(youtube_g, tooltip = "text")





