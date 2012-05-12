#!/bin/bash
#Usage
#ProvisionScriptForTestServer.sh <remote IP address>

#Before running this script,
#git clone git@git.slidev.org:sli/liferay.git

#Your liferay git repository dir
LIFERAY=${HOME}/liferay

DESTINATION_DIR=/tmp/opt/boot


SERVER=$1
if [ ! $SERVER ]; then
   echo "USAGE: ProvisionScriptForTestServer.sh <remote IP address>"
   exit
fi
DESTINATION_URL=${SERVER:="devlr1.slidev.org"}

ssh ${DESTINATION_URL} rm -rf ${DESTINATION_DIR}
ssh ${DESTINATION_URL} mkdir -p ${DESTINATION_DIR}{/bin,/conf/Catalina/localhost}

#The setenv.sh has settings for the JVM that are used when tomcat starts
scp ${LIFERAY}/installer/conf/setenv.sh ${DESTINATION_URL}:${DESTINATION_DIR}/bin/

# Adding jars that liferay depends on to lib/ext
scp -r ${LIFERAY}/installer/conf/ext ${DESTINATION_URL}:${DESTINATION_DIR}

# Update catalina.properties to look for jars in the directory created above (lib/ext)
scp ${LIFERAY}/installer/conf/catalina.properties ${DESTINATION_URL}:${DESTINATION_DIR}/conf

# Copy the portal.xml file into tomcat 
scp -r ${LIFERAY}/installer/conf/localhost ${DESTINATION_URL}:${DESTINATION_DIR}/conf/Catalina/localhost


# Copy the portal-ext.properties file into tomcat
scp ${LIFERAY}/installer/conf/portal-ext.properties ${DESTINATION_URL}:${DESTINATION_DIR}

#Copy installation script
scp ${LIFERAY}/installer/ProvisionScript.sh ${DESTINATION_URL}:${DESTINATION_DIR}

#Copy lar file
scp ${LIFERAY}/installer/layout.lar ${DESTINATION_URL}:${DESTINATION_DIR}

#Copy Environment properties
scp ${LIFERAY}/devjuggernauts.properties ${DESTINATION_URL}:${DESTINATION_DIR}/environment.properties

#mysql for portal
scp ${LIFERAY}/installer/mysql/lr_mysql_init.sql ${DESTINATION_URL}:${DESTINATION_DIR}/r_mysql_init.sql


echo "Next step. ssh ${DESTINATION_URL} then execute ${DESTINATION_DIR}/ProvisionScript.sh"
