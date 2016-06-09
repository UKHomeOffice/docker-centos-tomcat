#!/bin/bash -e

if [ -f "/opt/tomcat/ssl/tomcat-users.xml" ] && [ -f "/opt/tomcat/ssl/ca.crt" ] && [ -f "/opt/tomcat/ssl/crt.pem" ] && [ -f "/opt/tomcat/ssl/key.pem" ]
then
    echo "SSL Keys and Passwords found - running in secure password mode"
    cp /opt/tomcat/conf/web.xml.password /opt/tomcat/conf/web.xml
    exec catalina.sh run
elif [ -f "/opt/tomcat/ssl/ca.crt" ] && [ -f "/opt/tomcat/ssl/crt.pem" ] && [ -f "/opt/tomcat/ssl/key.pem" ]
then
    echo "SSL Keys found - running in secure mode"
    cp /opt/tomcat/conf/web.xml.secure /opt/tomcat/conf/web.xml
    exec catalina.sh run
else
    echo "SSL Keys not found - running in none secure mode"
    cp /opt/tomcat/conf/web.xml.nonsecure /opt/tomcat/conf/web.xml
    exec catalina.sh run
fi
