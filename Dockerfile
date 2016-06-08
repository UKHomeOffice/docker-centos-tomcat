FROM quay.io/ukhomeofficedigital/docker-centos-openjdk8:latest
MAINTAINER "Mark Olliver mark@keao.cloud"
LABEL Version="0.1"
LABEL Name="tomcat"
LABEL Description="Apache Tomcat Container"

ENV TOMCAT_MAJOR=8
ENV TOMCAT_MINOR=8.0.35
ENV OPENSSL_VERSION=1.0.2h
ENV JAVA_MAJOR=${JAVA_MAJOR}
ENV JAVA_MINOR=${JAVA_MINOR}

RUN curl -#L http://www.mirrorservice.org/sites/ftp.apache.org/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_MINOR}/bin/apache-tomcat-${TOMCAT_MINOR}.tar.gz -o /tmp/apache-tomcat.tar.gz
RUN curl -#L https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz -o /tmp/openssl.tar.gz

RUN tar -zxf /tmp/apache-tomcat.tar.gz -C /opt && \
    rm /tmp/apache-tomcat.tar.gz && \
    mv /opt/apache-tomcat-* /opt/tomcat

RUN yum install -y apr-devel java-${JAVA_MAJOR}-openjdk-devel && \
    yum groupinstall -y "Development Tools"

WORKDIR /tmp
RUN tar zxf openssl.tar.gz && \
    rm openssl.tar.gz && \
    mv openssl-* openssl && \
    cd openssl && \
    ./config shared && \
    make depend && \
    make install

ENV JAVA_HOME /usr/lib/jvm/java-${JAVA_MAJOR}-openjdk-${JAVA_MAJOR}.${JAVA_MINOR}.el7_2.x86_64
ENV JRE_HOME /usr/lib/jvm/java-${JAVA_MAJOR}-openjdk-${JAVA_MAJOR}.${JAVA_MINOR}.el7_2.x86_64
ENV PATH /opt/tomcat/bin:/usr/lib/jvm/jre-${JAVA_MAJOR}-openjdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV CATALINA_HOME /opt/tomcat
WORKDIR /opt/tomcat
 
RUN mkdir -p /opt/tomcat-native && \
    tar -zxf bin/tomcat-native.tar.gz -C /opt/tomcat-native --strip-components=1 && \
    cd /opt/tomcat-native/native && \
    ./configure \
        --libdir=/usr/lib/ \
        --prefix="$CATALINA_HOME" \
        --with-apr=/usr/bin/apr-1-config \
        --with-java-home="$JAVA_HOME" \
        --with-ssl=yes && \
    make -j$(nproc) && \
    make install && \
    rm -rf /opt/tomcat-native /tmp/openssl
               
RUN set -e \
	if `catalina.sh configtest | grep -q 'INFO: Loaded APR based Apache Tomcat Native library'` \
        then \
	    echo "Build Passed" \
        else \
            echo "Build Failed" \
            exit 1 \
	fi

RUN yum remove -y apr-devel && \
    yum groupremove -y "Development Tools" && \
    yum clean all
    
EXPOSE 8080

ENTRYPOINT catalina.sh run
