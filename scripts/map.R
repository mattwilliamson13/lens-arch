library(sf)
library(tmap)

neon.boxes <- read_sf("data/original/NEON-AOP-FlightBoxes.shp") %>% 
  mutate(site2 = substr(Site, 5, 8)) %>% 
  filter(., site2 %in% pca.filter$site2) %>% 
  group_by(.,site2) %>% 
  summarize(geometry = st_union(geometry))
tmap::tmap_mode("view")
tmap::qtm(neon.boxes, basemaps = leaflet::providers$Stamen.TerrainBackground, fill = "red", text="site2", text.size=2, text.col="black")
