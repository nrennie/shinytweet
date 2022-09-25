FROM rocker/shiny:4.2.1
RUN install2.r rsconnect
WORKDIR /home/shinyusr
COPY ui.R ui.R 
COPY server.R server.R 
COPY likes.rds likes.rds
COPY deploy.R deploy.R
CMD Rscript deploy.R