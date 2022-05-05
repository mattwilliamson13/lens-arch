library(ggbiplot)
library(tidyverse)
library(softImpute)
library(ggsci)
aop.df.orig <- read.csv("data/original/NEON-AOP-Mergeddata.csv") #some weird extra rows likely due to excel
aop.df <- aop.df.orig[1:57,] 
aop.df$FIRST_nlcdClass <- as.numeric(factor(aop.df$FIRST_nlcdClass))
aop.df$FIRST_soilTypeOrder <- as.numeric(factor(aop.df$FIRST_soilTypeOrder))

lc.vars <- colnames(aop.df)[c(2:19)]
ag.vars <- colnames(aop.df)[c(21,25:27, 30)]
acs.vars <- colnames(aop.df)[c(33,43,54:63,  77:80)]
topo.vars <- colnames(aop.df)[c(81:82,85)] 
categ.top.vars <- colnames(aop.df)[c(83:84)] 
clim.vars <- colnames(aop.df)[c(86, 92, 97, 100)]
aop.vars <- colnames(aop.df)[c(105, 106, 111:113, 118)]


aop.subset.vars <- aop.df %>% 
  select(
    c(all_of(lc.vars), all_of(ag.vars), all_of(acs.vars), all_of(topo.vars), all_of(clim.vars), all_of(aop.vars))) %>% 
  mutate_all(as.numeric)

fit <-softImpute(as.matrix(aop.subset.vars), rank.max = 50, lambda = 49, type = "svd", thresh = 1e-09)
aop.impute <- complete(as.matrix(aop.subset.vars), fit,  unscale = TRUE)
aop.subset.vars.scl <- biScale(as.matrix(aop.impute), maxit = 50, trace = TRUE)


#aop.subset.scl <- cbind(aop.subset.vars.scl, aop.df[,83:84])


aop.clust.subs <- hclust(dist(aop.subset.vars.scl),  "ave") 
plot(aop.clust.subs, labels = substr(aop.df$Site, 5, 8))

rect.hclust(aop.clust.subs, k = 10, border = pal_jco()(10))

group.mem10 <- cutree(aop.clust.subs, k = 10)

pca.filter <- aop.subset.vars.scl %>% 
  bind_cols(., "groupID" = group.mem10, "site" = aop.df$Site) %>% 
  mutate(site2 = substr(site, 5,8)) %>% 
  filter(. ,group.mem10 == 4) %>% 
  select(., -c(groupID, site))
  
pr.out <- prcomp(pca.filter[, 1:52], center=FALSE, scale. = FALSE)

ggbiplot2(pr.out, labels =  pca.filter$site2, scale=0,
         varname.adjust = 0.8, varname.abbrev = TRUE)


pca.filter <- aop.subset.scl %>% 
  bind_cols(., "groupID" = group.mem10, "site" = aop.df$Site) %>% 
  mutate(site2 = substr(site, 5,8)) %>% 
  filter(. ,group.mem10 == 2) %>% 
  select(., -c(groupID, site))

pr.out <- prcomp(pca.filter[, 1:54], center=FALSE, scale. = FALSE)

ggbiplot2(pr.out, labels =  pca.filter$site2, scale=0,
         varname.adjust = 1.05)
