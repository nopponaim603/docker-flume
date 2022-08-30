FROM debian:jessie
MAINTAINER Alex Wilson a.wilson@alumni.warwick.ac.uk

# Environment
ENV JAVA_HOME /opt/java
ENV PATH /usr/local/flume/bin:/opt/java/bin:$PATH
ENV DEBIAN_FRONTEND noninteractive
ENV FLUME_VERSION 1.9.0

# wget
RUN apt-get -y update && apt-get install -y wget

# Java
RUN mkdir /opt/java \
    && wget --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" -qO- \
          http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz \
          | tar zxvf - -C /opt/java --strip 1

#RUN apt-get install -y --no-install-recommends openjdk-8-jre-headless

# Flume
RUN cd /tmp && \
    wget http://archive.apache.org/dist/flume/${FLUME_VERSION}/apache-flume-${FLUME_VERSION}-bin.tar.gz && \
    tar -xvzf apache-flume-${FLUME_VERSION}-bin.tar.gz -C /usr/local && \
    rm apache-flume-${FLUME_VERSION}-bin.tar.gz

RUN cd /usr/local && ln -s apache-flume-${FLUME_VERSION}-bin flume

ADD start-flume.sh /usr/local/flume/bin/start-flume
ADD ./conf/flume.conf /usr/local/flume/conf/flume.conf

#ENTRYPOINT [ "start-flume" ]
CMD flume-ng agent -n docker -c /usr/local/flume/conf -f /usr/local/flume/conf/flume.conf -Dflumonf/flume.conf -Dflume.root.logger=DEBUG,console