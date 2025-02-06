FROM --platform=linux/amd64 rocker/tidyverse:4.3.1

LABEL maintainer="Alan Chen <cchen21@mdanderson.org>"

ADD . /requirements 
RUN Rscript --vanilla /requirements/install.R 
