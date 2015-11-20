# Docker image for oync server
# Setup and run synchronization between OSM API server and a Postgis DB
# (suitable for pointing a tiling server to)

FROM ubuntu:14.04
MAINTAINER Chris Natali

RUN apt-get update && \
    apt-get -y install \
        curl \        
        build-essential \        
        ruby \
        ruby-dev \
        zlib1g-dev \
        git \
        make \
        cmake \
        g++ \
        libboost-dev \
        libboost-system-dev \
        libboost-filesystem-dev \
        libboost-thread-dev \
        libexpat1-dev \
        zlib1g-dev \
        libbz2-dev \
        libpq-dev \
        libgeos-dev \
        libgeos++-dev \
        libproj-dev \
        lua5.2 \
        liblua5.2-dev \
        postgresql

# Add oync source required for setup
RUN mkdir /oync
ADD install-oync.sh /oync/
ADD install-osm2pgsql.sh /oync/
ADD "Gemfile" "Gemfile.lock" /oync/

WORKDIR /oync
# install dependencies
RUN bash install-osm2pgsql.sh
RUN bash install-oync.sh

# add rest of source
ADD oync_load.rb /oync/
ADD oync.sh /oync/
ADD run-oync.sh /oync/
ADD empty.osm /oync/
ADD oync.style /oync/

# run oync on startup
CMD ["./run-oync.sh"]
