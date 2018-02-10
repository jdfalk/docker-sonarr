FROM lsiobase/mono

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="jdfalk"

# set environment variables
ARG BUILD_DATE
ARG DEBIAN_FRONTEND="noninteractive"
ARG VCS_REF
ENV XDG_CONFIG_HOME="/config/xdg"

LABEL Name="Sonarr"
LABEL org.label-schema.build-date=$BUILD_DATE \
	org.label-schema.vcs-url="https://github.com/jdfalk/docker-sonarr.git" \
	org.label-schema.vcs-ref=$VCS_REF

# add mediainfo repo
ADD . /tmp

# add sonarr repository
RUN \
	curl https://mediaarea.net/repo/deb/repo-mediaarea_1.0-2_all.deb -o /tmp/repo-mediaarea.deb && \
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC && \
	echo "deb http://apt.sonarr.tv/ develop main" > \
	/etc/apt/sources.list.d/sonarr.list && \
	echo "**** install packages ****" && \
	apt-get update && \
	apt-get install -y apt-transport-https && \
	dpkg -i /tmp/repo-MediaArea-*.deb && \
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
EXPOSE 8080
VOLUME /config

HEALTHCHECK --interval=200s --timeout=100s CMD curl --fail http://localhost:8080 || exit 1
