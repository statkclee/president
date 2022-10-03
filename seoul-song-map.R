#####################################################################
#
# 서울특별시 보궐, 대선, 지선 (2021~2022)
#
#####################################################################


# 00. Packages -----------------------------------------------

library(tidyverse)
library(readxl)

# 01. 데이터 -------------------------------------------------

seoul_tbl  <- read_rds("data/seoul_song_tbl.rds")

# 02. 지도 ---------------------

library(geofacet)

# https://github.com/hafen/geofacet/issues/366
seoul_grid <- tribble(~"name",~"row",~"col",~"code",
                      "강북구",1,5,"강북구",
                      "도봉구",1,6,"도봉구",
                      "은평구",2,3,"은평구",
                      "종로구",2,4,"종로구",
                      "성북구",2,5,"성북구",
                      "노원구",2,6,"노원구",
                      "중랑구",2,7,"중랑구",
                      "강서구",3,1,"강서구",
                      "양천구",3,2,"양천구",
                      "마포구",3,3,"마포구",
                      "서대문구",3,4,"서대문구",
                      "중구",3,5,"중구",
                      "동대문구",3,6,"동대문구",
                      "광진구",3,7,"광진구",
                      "강동구",3,8,"강동구",
                      "구로구",4,2,"구로구",
                      "영등포구",4,3,"영등포구",
                      "동작구",4,4,"동작구",
                      "용산구",4,5,"용산구",
                      "성동구",4,6,"성동구",
                      "송파구",4,7,"송파구",
                      "금천구",5,3,"금천구",
                      "관악구",5,4,"관악구",
                      "서초구",5,5,"서초구",
                      "강남구",5,6,"강남구")

## 01. 구별 득표율 ---------------------

draw_geofacet <- function(election = "2022_대선") {
  
  type_year <- str_split(election, "_", simplify = TRUE)
  
  seoul_tbl %>% 
    mutate(후보 = factor(후보, levels = c("민주당", "국민의힘", "기타"))) %>%   
    filter(시점 == election) %>% 
    group_by(시점, 구시군, 후보) %>% 
    summarise(득표 = sum(득표)) %>% 
    mutate(득표율 = 득표 / sum(득표)) %>%   
    rename(name = 구시군)  %>% 
    ggplot(aes(후보, 득표율, fill = 후보)) +
      geom_col(width = 0.5) +
      coord_flip() +
      facet_geo(~ name, grid = seoul_grid) +
      geom_text(aes(label = scales::percent(득표율, 0.1)), hjust = -0.1, size = 3) +
      scale_fill_manual(values = c("blue", "red", "gray50")) +
      scale_y_continuous(labels = scales::percent) +
      labs(title = "서울특별시 구별 득표율 (2022)",
           subtitle = glue::glue("{type_year[1]}년 {type_year[2]}"),
           x = "") +
      theme_bw(base_family = "Maruburi") +
      theme(legend.position = "none") +
      expand_limits(y = 0.8)
}

draw_geofacet("2021_지선")
draw_geofacet("2022_지선")
draw_geofacet("2022_대선")


## 02. 추세 득표율 ---------------------

seoul_tbl %>% 
  mutate(후보 = factor(후보, levels = c("민주당", "국민의힘", "기타"))) %>%   
  group_by(시점, 구시군, 후보) %>% 
  summarise(득표 = sum(득표)) %>% 
  mutate(득표율 = 득표 / sum(득표)) %>%   
  ungroup() %>% 
  rename(name = 구시군)  %>% 
  ggplot(aes(x = 시점, y = 득표율, group= 후보, color = 후보)) +
    geom_line() +
    geom_point() +
    facet_wrap(~ 구시군) +
    facet_geo(~ name, grid = seoul_grid) +
    geom_text(aes(label = scales::percent(득표율, 0.1)), vjust = -0.3, size = 3) +
    scale_color_manual(values = c("blue", "red", "gray50")) +
    scale_y_continuous(labels = scales::percent) +
    theme_bw(base_family = "Maruburi") +
    theme(legend.position = "none") +
    expand_limits(y = 0.8) +
  labs(title = "서울특별시 득표율 (2021 ~ 2022)",
       subtitle = "재보궐, 대선, 지선",
       x = "")
  
  
  
  

