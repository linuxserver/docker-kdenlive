FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntunoble

# set version label
ARG BUILD_DATE
ARG VERSION
ARG KDENLIVE_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# app title
ENV TITLE=Kdenlive

ARG DEBIAN_FRONTEND="noninteractive"

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/kdenlive-logo.png && \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    frei0r-plugins \
    i965-va-driver \
    kdenlive \
    mediainfo \
    python3-venv \
    va-driver-all \
    vainfo \
    vdpau-driver-all && \
  echo "**** install vosk ****" && \
  python3 -m venv /lsiopy && \
  pip install -U --no-cache-dir \
    pip \
    wheel && \
  pip3 install -U --no-cache-dir --find-links https://wheel-index.linuxserver.io/ubuntu/ \
    srt \
    vosk && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** cleanup ****" && \
  rm -rf \
    /config/.cache \
    /root/.cache \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000
VOLUME /config
