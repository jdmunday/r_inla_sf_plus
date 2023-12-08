# Use an official R runtime as a parent image
FROM rocker/r-base:latest

# Set a working directory
WORKDIR /docker/home

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
       libgdal-dev \
       libproj-dev \
       libgeos-dev \
       libudunits2-dev

# Install R packages
RUN R -e "install.packages(c('pacman', 'data.table', 'tidyverse', 'sf', 'rmapshaper', 'flextable', 'cowplot', 'spdep', 'jsonlite', 'splines', 'ISOweek', 'scales', 'units', 'scoringutils'), dependencies=TRUE)"

# Install rINLA separately due to additional system dependencies
# Define the version/repo of INLA to use. Choose either: 'stable' or 'testing'
ARG INLA_REPO='testing'
ARG TIMESTAMP

# Install INLA
RUN Rscript -e "install.packages('INLA', repos=c('https://cloud.r-project.org/', INLA='https://inla.r-inla-download.org/R/$INLA_REPO'), dep=TRUE)" && \
   rm -rf /tmp/*

# Set environment variables
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Define default command to run when the container starts
USER root 


