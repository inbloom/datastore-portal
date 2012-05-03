#!/bin/bash
#Before running this script,
#this script needs elevated privilidges

DESTINATION_DIR=/tmp/opt/boot
TOMCAT_ROOT=/opt/tomcat
TOMCAT_HOME=${TOMCAT_ROOT}/apache-tomcat-7.0.27

sudo /etc/rc.d/init.d/tomcat stop
sleep 3

sudo mkdir -p /opt/deploy
sudo chown tomcat.tomcat /opt/deploy
sudo chown tomcat.tomcat ${DESTINATION_DIR}/deploy/*
sudo mv ${DESTINATION_DIR}/deploy/* /opt/deploy/
sudo su - tomcat -c "cp -f ${DESTINATION_DIR}/layout.lar /opt/deploy/"


if [ -f ${TOMCAT_HOME}/webapps/portal.war ]; then
   sudo rm -f ${TOMCAT_HOME}/webapps/portal.war
fi

sudo mysql < ${DESTINATION_DIR}/r_mysql_init.sql

sudo cp ${DESTINATION_DIR}/webapps/portal.war ${TOMCAT_HOME}/webapps/portal.war


sudo /etc/rc.d/init.d/tomcat start

sleep 3 

#sudo /etc/rc.d/init.d/tomcat stop


#The setenv.sh has settings for the JVM that are used when tomcat starts
sudo cp -f ${DESTINATION_DIR}/bin/setenv.sh ${TOMCAT_HOME}/bin/
   
   
# Adding jars that liferay depends on to lib/ext
sudo cp -r ${DESTINATION_DIR}/ext ${TOMCAT_HOME}/lib/

# Update catalina.properties to look for jars in the directory created above (lib/ext)
sudo cp ${DESTINATION_DIR}/conf/catalina.properties ${TOMCAT_HOME}/conf/

# Copy the portal.xml file into tomcat 
sudo cp -r ${DESTINATION_DIR}/conf/Catalina/localhost/ ${TOMCAT_HOME}/conf/Catalina/


# Copy the portal-ext.properties and environment.properties file into tomcat
sudo cp ${DESTINATION_DIR}/portal-ext.properties /opt/tomcat
sudo cp ${DESTINATION_DIR}/environment.properties /opt/tomcat


