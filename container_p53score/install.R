#Utilize the publich tidyverse R4.2 docker (bioconductor version 3.15) to install GSVA package (version 1.46.0)

BiocManager::install(version = "3.18")
install.packages(c("tidyverse", "optparse", "readr"),update = FALSE,ask = FALSE,repos = "http://cran.us.r-project.org")
BiocManager::install(c("GSVA"),update = FALSE,ask = FALSE)
