FROM ubuntu:24.04

ARG MAVEN_VERSION=3.9.4
ARG USER_HOME_DIR="/root"
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

# Install dependencies, including CA certificates for SSL validation
RUN apt update \
    && apt install -y openjdk-8-jdk \
    && apt install -y curl \
    && apt install -y ca-certificates \
    && update-ca-certificates

# Install Maven
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
 && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
 && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
 && rm -f /tmp/apache-maven.tar.gz \
 && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

# Set Maven and Java environment variables
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

COPY . /data

# Define working directory
WORKDIR /data

# Run Maven install (this will download dependencies, compile, and install)
RUN mvn install
