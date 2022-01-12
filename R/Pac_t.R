library(data.table)
library(rgdal)
library(raster)
library(ncdf4)
library(terra)
setwd("E:/Documents/CZU/Advanced R/Project/data/klementinum")
prs = fread('RR_STAID000027.txt', na.strings = '-9999')
tem = fread('TG_STAID000027.txt', na.strings = '-9999')

pr = brick('EUR_pr_day_CanESM2_historical_rcp85_r25i1p1_19500101-21001231.nc')
te = brick('EUR_tas_day_CanESM2_historical_rcp85_r50i1p1_19500101-21001231.nc')
extract(pr, te, method='simple', buffer=NULL, small=FALSE, cellnumbers=FALSE, 
        fun=NULL, na.rm=TRUE, layer, nl, df=FALSE, factors=FALSE)
nc <- list.files(paste0(path,"nc"),
                       pattern = "*.nc",
                       full.names = TRUE)
prs_r<- rast(nc[1])
tem_r <- rast(nc[2])


station = vect(data.frame(lon = 14 + 24/60 + 59/60/100, lat = 50 + 05/60 + 11/60/100))

prs_m = terra::extract(prs_r,terra::vect(station))
prs_md <- data.table(prs_m)
pr = pr[!is.na(RR)]


g1 = obs_q[1] / ctrl_q[1]
g2 = obs_q[2] / ctrl_q[2]

b = log( (g2 * scen_q[2])/(g1 * scen_q[1])) / log( (g2 * ctrl_q[2])/(g1*ctrl_q[1]) )
a = scen_q[1] / (ctrl_q[1]^b) * g1^(1-b)

Ec = pr_ctrl[pr5>ctrl_q[2], mean(pr5 - ctrl_q[2])]
Es = pr_scen[pr5>scen_q[2], mean(pr5 - scen_q[2])]

pr[pr_o5 < obs_q[2], pr_trans := a * pr_o ^ b]
pr[pr_o5 >= obs_q[2], pr_trans := Es/Ec * (pr_o - obs_q[2]) + a * obs_q[2] ^ b]    
pr

#DATA
setwd("E:/Documents/CZU/Advanced R/Project/data/klementinum")



save(pr, file = "~/m/data/pr.rda")
load("~/m/data/pr.rda")
setwd("~/m")
usethis::use_data(pr, overwrite = T)

  
  
save(te, file = "~/tmp/data/te.rda")
load("~/tmp/data/te.rda")
setwd("~/tmp")
usethis::use_data(pr, overwrite = T)
  
require(rgdal)
pra <- readOGR(dsn = "E:/Documents/CZU/Advanced R/Project/data/klementinum",
               layer = "")

  
  
  