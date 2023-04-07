FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntujammy

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
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    frei0r-plugins \
    i965-va-driver \
    kdenlive \
    mediainfo \
    python3 \
    python3-pip \
    va-driver-all \
    vainfo \
    vdpau-driver-all && \
  echo "**** install vosk ****" && \
  VOSK=$(curl -sX GET "https://api.github.com/repos/alphacep/vosk-api/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]') && \
  SHORT=$(echo ${VOSK} |awk '{print substr($1,2); }') && \
  curl -L -o \
    /tmp/vosk-${SHORT}-py3-none-manylinux_2_12_x86_64.manylinux2010_x86_64.whl \
    "https://github.com/alphacep/vosk-api/releases/download/${VOSK}/vosk-${SHORT}-py3-none-manylinux_2_12_x86_64.manylinux2010_x86_64.whl" && \
  pip3 install /tmp/vosk-${SHORT}-py3-none-manylinux_2_12_x86_64.manylinux2010_x86_64.whl && \
  pip3 install -U \
    srt && \
  echo "**** cleanup ****" && \
  apt-get purge --auto-remove -y \
    python3-pip && \
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
