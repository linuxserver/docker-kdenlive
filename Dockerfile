# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-selkies:ubuntunoble

# set version label
ARG BUILD_DATE
ARG VERSION
ARG KDENLIVE_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# app title
ENV TITLE=Kdenlive \
    NO_GAMEPAD=true

ARG DEBIAN_FRONTEND="noninteractive"

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/kdenlive-logo.png && \
  echo "**** install packages ****" && \
  if [ -z ${KDENLIVE_VERSION+x} ]; then \
    KDENLIVE_VERSION=$(curl -s 'https://apps.kde.org/kdenlive/index.xml' \
    | awk -F'[<>]' '{for(i=1; i<=NF; i++) if($i=="guid"){split($(i+1), a, "#"); print a[2]; exit}}'); \
  fi && \
  curl -o \
    /tmp/kdenlive.app -L \
    "https://download.kde.org/stable/kdenlive/$(echo "$KDENLIVE_VERSION" | sed 's/\.[^.]*$//')/linux/kdenlive-${KDENLIVE_VERSION}-x86_64.AppImage" && \
  cd /tmp && \
  chmod +x kdenlive.app && \
  ./kdenlive.app --appimage-extract && \
  mv \
    squashfs-root \
    /opt/kdenlive && \
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
