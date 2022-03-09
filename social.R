library(gtrendsR)
library(tidyverse)
library(readxl)
library(httr)
library(rvest)
library(extrafont)
loadfonts()
library(jsonlite)
library(plotly)

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
  write_rds(glue::glue('data/social/google_trends_{Sys.Date() %>% str_remove_all(., "-")}.rds'))

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
  write_rds(glue::glue("data/social/social_youtube_raw_{Sys.Date() %>% str_remove_all('-')}.rds"))

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
    geom_smooth(aes(group = 후보명, color = 후보명), se = FALSE, method = "loess", span = 0.75) +
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


# 4. 썸트렌드 -----------------------------------------------
## 4.1. 데이터: SNS 언급량 ----------------------------------------------
library(readxl)
library(lubridate)

get_some_wom_data <- function() {
  ## 1.1 이재명.................................  
  
  lee_words <- read_excel("data/social/some/20220308/[썸트렌드] 이재명_언급량_220101-220308.xlsx", sheet = "언급량", skip = 13)
  
  lee_wom <- lee_words %>% 
    select(-합계) %>% 
    mutate(날짜 = ymd(날짜)) %>% 
    pivot_longer(-날짜, names_to = "구분", values_to = "언급횟수") %>% 
    mutate(후보 = "이재명")
  
  ## 1.2 윤석열.................................
  yoon_words <- read_excel("data/social/some/20220308/[썸트렌드] 윤석열_언급량_220101-220308.xlsx", sheet = "언급량", skip = 13)
  
  yoon_wom <- yoon_words %>% 
    select(-합계) %>% 
    mutate(날짜 = ymd(날짜)) %>% 
    pivot_longer(-날짜, names_to = "구분", values_to = "언급횟수") %>% 
    mutate(후보 = "윤석열")
  
  ## 1.3. 안철수.................................
  ahn_words <- read_excel("data/social/some/20220308/[썸트렌드] 안철수_언급량_220101-220308.xlsx", sheet = "언급량", skip = 13)
  
  ahn_wom <- ahn_words %>% 
    select(-합계) %>% 
    mutate(날짜 = ymd(날짜)) %>% 
    pivot_longer(-날짜, names_to = "구분", values_to = "언급횟수") %>% 
    mutate(후보 = "안철수")
  
  ## 1.4. 세후보 결합
  three_wom <- bind_rows(lee_wom, yoon_wom) %>% 
    bind_rows(ahn_wom)
  
  three_wom
}


wom_raw <- get_some_wom_data()

wom_raw %>% 
  write_rds(glue::glue("data/social/wom_raw_{Sys.Date() %>% str_remove_all('-')}.rds"))


## 4.2. 데이터: 유튜브 언급량 ----------------------------------------------


get_some_youtube_data <- function() {
  ## 2.1. 이재명 -------------------------
  lee_youtube_raw <- read_excel("data/social/some/20220308/[썸트렌드] 이재명 컨텐츠조회수추이_220101-220308.xlsx", sheet = "전체 탐색량", skip = 13)
  
  lee_youtube <- lee_youtube_raw %>% 
    select(-전체) %>% 
    mutate(날짜 = ymd(날짜)) %>% 
    pivot_longer(-날짜, names_to = "구분", values_to = "언급횟수") %>% 
    mutate(후보 = "이재명")
  
  ## 2.2. 윤석열 -------------------------
  yoon_youtube_raw <- read_excel("data/social/some/20220308/[썸트렌드] 윤석열 컨텐츠조회수추이_220101-220308.xlsx", sheet = "전체 탐색량", skip = 13)
  
  yoon_youtube <- yoon_youtube_raw %>% 
    select(-전체) %>% 
    mutate(날짜 = ymd(날짜)) %>% 
    pivot_longer(-날짜, names_to = "구분", values_to = "언급횟수") %>% 
    mutate(후보 = "윤석열")
  
  ## 2.3. 이재명 -------------------------
  ahn_youtube_raw <- read_excel("data/social/some/20220308/[썸트렌드] 안철수 컨텐츠조회수추이_220101-220308.xlsx", sheet = "전체 탐색량", skip = 13)
  
  ahn_youtube <- ahn_youtube_raw %>% 
    select(-전체) %>% 
    mutate(날짜 = ymd(날짜)) %>% 
    pivot_longer(-날짜, names_to = "구분", values_to = "언급횟수") %>% 
    mutate(후보 = "안철수")
  
  
  ## 2.4. 세후보 결합
  three_youtube <- bind_rows(lee_youtube, yoon_youtube) %>% 
    bind_rows(ahn_youtube) 
  
  three_youtube
}

youtube_raw <- get_some_youtube_data()

youtube_raw %>% 
  write_rds(glue::glue("data/social/youtube_raw_{Sys.Date() %>% str_remove_all('-')}.rds"))


## 4.2 시각화 ------------------
wom_raw  <-  
  read_rds(glue::glue("data/social/wom_raw_{Sys.Date() %>% str_remove_all('-')}.rds"))

wom_g <- wom_raw %>% 
  mutate(구분 = factor(구분, levels = c("뉴스", "블로그", "커뮤니티", "유튜브", "인스타그램", "트위터"))) %>% 
  ggplot(aes(x = 날짜, y = 언급횟수, color = 후보, group = 후보)) +
  geom_line() +
  geom_point(size = 0.7) +
  facet_wrap(~구분, scale= "free_y") +
  scale_y_continuous(labels = scales::comma) +
  scale_x_date(date_labels = "%y년%m월") +
  theme_bw(base_family = "NanumBarunPen") +
  theme(legend.position = "top",
        legend.title=element_text(size=19), 
        legend.text=element_text(size=13),
        strip.text.x = element_text(size = rel(1.3), colour = "black", face="bold"),
        axis.text.y = element_text(size = rel(1.7), colour = "gray35", face="bold", 
                                   margin = margin(t = 0, r = 0, b = 0, l = 00)),
        axis.text.x = element_text(size = rel(1.3), colour = "black",  face="bold"),
        strip.background=element_rect(fill="gray95"),
        plot.title=element_text(size=25, face="bold", family = "NanumBarunpen"),
        plot.subtitle=element_text(face="bold", size=17, colour="grey10", family = "NanumBarunpen"))  +
  labs(x = "",
       y = "언급횟수/조회수",
       title = "대통령선거 SNS 트래픽",
       subtitle = glue::glue("조사일자: 2022-01-01 ~ {wom_raw %>% filter(날짜 == max(날짜)) %>% pull(날짜)}"),
       caption = "데이터 출처: 썸트렌드") +
  scale_color_manual(values = c("이재명" = "blue", 
                                "윤석열" = "red", 
                                "안철수" = "#DE5020" ))  

ggplotly(wom_g)


# 5. 감성분석 -----------------------------------------------
## 5.1. 소셜 SNS 감성 데이터 ---------------------------------------

get_some_social_emotion_data <- function(channel = "커뮤니티") {

  ## 1.1 이재명 -------------------------
  lee_emotion <- read_excel("data/social/some/20220308/[썸트렌드] 이재명_긍부정 추이(건수)_220101-220308.xlsx", sheet = channel, skip = 13)
  
  lee_emo <- lee_emotion %>% 
    mutate(날짜 = ymd(날짜)) %>% 
    pivot_longer(-날짜, names_to = "구분", values_to = "긍부정횟수") %>% 
    mutate(후보 = "이재명") %>% 
    mutate(채널 = channel)
  
  ## 1.2 윤석열 -------------------------
  yoon_emotion <- read_excel("data/social/some/20220308/[썸트렌드] 윤석열_긍부정 추이(건수)_220101-220308.xlsx", sheet = channel, skip = 13)
  
  yoon_emo <- yoon_emotion %>% 
    mutate(날짜 = ymd(날짜)) %>% 
    pivot_longer(-날짜, names_to = "구분", values_to = "긍부정횟수") %>% 
    mutate(후보 = "윤석열") %>% 
    mutate(채널 = channel)
  
  ## 1.3. 안철수 -------------------------
  ahn_emotion <- read_excel("data/social/some/20220308/[썸트렌드] 안철수_긍부정 추이(건수)_220101-220308.xlsx", sheet = channel, skip = 13)
  
  ahn_emo <- ahn_emotion %>% 
    mutate(날짜 = ymd(날짜)) %>% 
    pivot_longer(-날짜, names_to = "구분", values_to = "긍부정횟수") %>% 
    mutate(후보 = "안철수") %>% 
    mutate(채널 = channel)
  
  ## 1.4. 세후보 결합
  three_emo <- bind_rows(lee_emo, yoon_emo) %>% 
    bind_rows(ahn_emo) %>% 
    mutate(구분 = str_remove_all(구분, "\\s?건수"))
  
  three_emo
}

emotion_social_raw <- tibble(채널 = c("커뮤니티", "인스타", "블로그", "뉴스", "트위터")) %>% 
  mutate(data = map(채널, get_some_social_emotion_data)) %>% 
  select(-채널) %>% 
  unnest(data)

emotion_social_raw %>% 
  write_rds(glue::glue("data/social/emotion_social_raw_{Sys.Date() %>% str_remove_all('-')}.rds"))


emotion_social_raw

## 5.2. 유튜브 감성 데이터 ---------------------------------------

get_some_youtube_emotion_data <- function() {
  
  ## 2.1. 이재명 -------------------------
  lee_youtube_emo_raw <- read_excel("data/social/some/20220308/[썸트렌드] 이재명 유튜브감성추이_220101-220308.xlsx", sheet = "일자별 감성 추이", skip = 13)
  
  lee_youtube_emo <- lee_youtube_emo_raw %>% 
    mutate(날짜 = ymd(날짜)) %>% 
    pivot_longer(-날짜, names_to = "구분", values_to = "긍부정횟수") %>% 
    mutate(후보 = "이재명") %>% 
    mutate(채널 = "유튜브")
  
  ## 2.2. 윤석열 -------------------------
  yoon_youtube_emo_raw <- read_excel("data/social/some/20220308/[썸트렌드] 윤석열 유튜브감성추이_220101-220308.xlsx", sheet = "일자별 감성 추이", skip = 13)
  
  yoon_youtube_emo <- yoon_youtube_emo_raw %>% 
    mutate(날짜 = ymd(날짜)) %>% 
    pivot_longer(-날짜, names_to = "구분", values_to = "긍부정횟수") %>% 
    mutate(후보 = "윤석열") %>% 
    mutate(채널 = "유튜브")
  
  ## 2.3. 안철수 -------------------------
  ahn_youtube_emo_raw <- read_excel("data/social/some/20220308/[썸트렌드] 안철수 유튜브감성추이_220101-220308.xlsx", sheet = "일자별 감성 추이", skip = 13)
  
  ahn_youtube_emo <- ahn_youtube_emo_raw %>% 
    mutate(날짜 = ymd(날짜)) %>% 
    pivot_longer(-날짜, names_to = "구분", values_to = "긍부정횟수") %>% 
    mutate(후보 = "안철수") %>% 
    mutate(채널 = "유튜브")
  
  ## 2.4. 세후보 결합
  three_youtube_emo <- bind_rows(lee_youtube_emo, yoon_youtube_emo) %>% 
    bind_rows(ahn_youtube_emo)
  
  three_youtube_emo
}

emotion_youtube_raw <- get_some_youtube_emotion_data()

emotion_youtube_raw %>% 
  write_rds(glue::glue("data/social/emotion_youtube_raw_{Sys.Date() %>% str_remove_all('-')}.rds"))





# fix ---------------------------------------------------------------------

# time_span <- glue::glue("2021-11-01 2022-01-29}") %>% as.character(.)
time_span <- glue::glue("2022-01-01 {Sys.Date()}") %>% as.character(.)

Sys.setenv(TZ = "Asia/Seoul")

Sys.getenv("TZ")

Sys.setlocale("LC_ALL", "C")

hubo_raw <- gtrends(keyword = c("이재명", "윤석열", "안철수", "심상정"),
                    geo = "KR",
                    hl = "ko-KR",
                    time = "2022-01-01 2022-03-07",
                    low_search_volume = FALSE,
                    cookie_url = "http://trends.google.com/Cookies/NID",
                    gprop = "web")


Sys.setlocale("LC_ALL", "Korean")

hubo_raw$interest_over_time %>% 
  as_tibble() %>% 
  arrange(desc(date))
