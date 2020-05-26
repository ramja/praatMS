FROM  rocker/r-ver:3.4.2

RUN apt-get update && apt-get -y install zlib1g-dev gtk+2.0 libasound2 libssl-dev curl libcurl4-openssl-dev wget

ADD F_0101_10y4m_1.wav /tmp

WORKDIR /usr/bin


RUN Rscript -e "install.packages(c('git2r','devtools' ,'dplyr','plotly', 'audio', 'cluster', 'igraph','ggfortify', 'gridExtra','shiny', 'ggplot2', 'shinydashboard', 'shinydashboard')  )"

RUN Rscript -e "install.packages('')" -e "install.packages('devtools')" -e "devtools:::install_github('usagi5886/PraatR')"

RUN wget https://github.com/praat/praat/releases/download/v6.0.20/praat6020_linux64.tar.gz

RUN tar -zxvf /usr/bin/praat6020_linux64.tar.gz




