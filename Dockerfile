FROM openjdk:8-jdk


ARG MAVEN_VERSION=3.6.3
ARG USER_HOME_DIR="/root"
ARG SHA=c35a1803a6e70a126e80b2b3ae33eed961f83ed74d18fcd16909b2d44d7dada3203f1ffe726c17ef8dcca2dcaa9fca676987befeadc9b9f759967a8cb77181c0
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

COPY mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
COPY settings-docker.xml /usr/share/maven/ref/

RUN apt-get update && apt-get install -y ca-certificates openssh-client git --no-install-recommends && rm -r /var/lib/apt/lists/*


COPY git.sh /tmp/git.sh

RUN chmod +x /tmp/git.sh && mkdir -p /root/.ssh && echo "Host *\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile /dev/null\n" >> /root/.ssh/config

VOLUME "/root/project"

WORKDIR "/root/project"

ENV SHA="HEAD" \
 GIT_ROOT="/root/project" \
 SERVICE="" \
 USERNAME="" \
 REPOSITORY="" \
 METHOD="http" \
 BRANCH="" \
 DEPTH=20 \
 DEBUG=FALSE

#CMD ["/tmp/git.sh"]

ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]
CMD ["mvn","/tmp/git.sh"]
