FROM lsiobase/mono
MAINTAINER jdfalk

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="jf version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# set environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV XDG_CONFIG_HOME="/config/xdg"

# add mediainfo and sonarr repository
RUN \
 curl https://mediaarea.net/repo/deb/repo-mediaarea_1.0-2_all.deb -o /tmp/repo-mediaarea.deb && \
 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC && \
 echo "deb http://apt.sonarr.tv/ master main" > \
	/etc/apt/sources.list.d/sonarr.list && \

# install packages
 apt-get update && \
 apt-get install -y apt-transport-https && \
 dpkg -i /tmp/repo-mediaarea.deb && \
 apt-get update && \
 apt-get install -y \
	nzbdrone mediainfo && \

# cleanup
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8989
VOLUME /config /downloads /tv
