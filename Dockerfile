
ARG JAVA_MAJOR_VERSION=11
ARG JAVA_VERSION=11.0.9.1
ARG SCALA_VERSION=3.0.0-M3
ARG SBT_VERSION=1.4.6

# -------------------------- STAGE 1 -----------------------------------------
# download-and-extract-stage does not neet to be based on debian:buster.
# As long as it has the `tar` command, it should work.
FROM debian:buster-slim as download-and-extract-stage
ARG SCALA_VERSION
ARG SBT_VERSION
# An example URL to download Scala: https://github.com/lampepfl/dotty/releases/download/3.0.0-M3/scala3-3.0.0-M3.tar.gz
ADD https://github.com/lampepfl/dotty/releases/download/${SCALA_VERSION}/scala3-${SCALA_VERSION}.tar.gz /tmp/scala3-${SCALA_VERSION}.tar.gz
RUN tar -xzf /tmp/scala3-${SCALA_VERSION}.tar.gz -C /usr/local && mv /usr/local/scala3-${SCALA_VERSION} /usr/local/scala3

# An example URL to download sbt: https://github.com/sbt/sbt/releases/download/v1.4.6/sbt-1.4.6.tgz
ADD https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz /tmp/sbt-${SBT_VERSION}.tar.gz
RUN tar -xzf /tmp/sbt-${SBT_VERSION}.tar.gz -C /usr/local

# -------------------------- STAGE 2 -----------------------------------------
# The "official" openjdk image is based on debian buster.
FROM openjdk:${JAVA_VERSION}-jre-slim as scala-stage

COPY --from=download-and-extract-stage /usr/local/scala3 /usr/local/scala3
ENV SCALA_HOME=/usr/local/scala3

COPY --from=download-and-extract-stage /usr/local/sbt /usr/local/sbt
ENV SBT_HOME=/usr/local/sbt

ENV PATH="${SCALA_HOME}/bin:${SBT_HOME}/bin:${PATH}"
