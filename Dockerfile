FROM openshift/base-centos7

LABEL maintainer="Said SOUTEH <s_souteh@yahoo.fr>"

ENV MAVEN_VERSION=3.5.4

LABEL io.k8s.description="Platform for building Maven project and running Java" \
      io.k8s.display-name="builder Java application" \
      io.openshift.expose-services="8080" \
      io.openshift.tags="builder,java,maven"

# Install Java
RUN yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel && \
    yum clean all -y 

# Install Maven
RUN wget -q http://www-eu.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    mkdir /opt/maven && \
    tar xzf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /opt/maven && \
    rm -rf apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    ln -s /opt/maven/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/local/bin/mvn

# S2I scripts
COPY ./s2i/bin/ /usr/libexec/s2i

RUN chown -R 1001:1001 /opt/app-root
USER 1001

EXPOSE 8080

CMD ["/usr/libexec/s2i/usage"]
