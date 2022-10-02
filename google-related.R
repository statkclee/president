library(httr)
library(rvest)
dong_kim <- snsdata::get_related_search_candidate("김동연")
hey_kim <- snsdata::get_related_search_candidate("김은혜")
seok_kang <- snsdata::get_related_search_candidate("강용석")

related_google_tbl <- bind_rows(dong_kim, hey_kim, seok_kang)

related_google_tbl %>%
  write_rds("data/related_google_tbl_20220601.rds")
related_google_tbl <- read_rds("data/related_google_tbl_20220601.rds")

library('tidygraph')
library('ggraph')
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
    ggraph(layout='nicely') +
    geom_edge_link(color='gray50', alpha=.2) +
    geom_node_point(aes(color=factor(group), size=eigen)) +
    geom_node_text(aes(label=name), size=3, repel=TRUE) +
    theme_minimal() +
    theme_graph(base_family = "NanumBarunPen") +
    ggtitle(glue::glue("{hubo_name} : 구글 연관검색어")) +
    theme(legend.position = "none",
          plot.title=element_text(size=16, face="bold", family = "NanumBarunpen"),
          plot.subtitle=element_text(face="bold", size=13, colour="grey10", family = "NanumBarunpen"))
}
library(patchwork)
seok_kang_g <- draw_related_keywords("강용석")
dong_kim_g <- draw_related_keywords("김동연")
hey_kim_g <- draw_related_keywords("김은혜")
ragg::agg_("fig/related_keywords_20220601.png", width = 297, height = 210,
           units = "mm", res = 600)
# seok_kang_g + dong_kim_g + hey_kim_g
seok_kang_g | dong_kim_g | hey_kim_g
dev.off()


