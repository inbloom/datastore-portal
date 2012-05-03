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


if [ -d ${DESTINATION_DIR} ]; then
   rm -rf ${DESTINATION_DIR}
fi
mkdir -p ${DESTINATION_DIR}/{/webapps,/deploy,/bin,/conf/Catalina/localhost}
echo "#############################"
echo "Preparing files"
echo "#############################"

#download portal war files
wget -O ${DESTINATION_DIR}/webapps/portal.war http://downloads.sourceforge.net/project/lportal/Liferay%20Portal/6.1.0%20GA1/liferay-portal-6.1.0-ce-ga1-20120106155615760.war
scp nxslave4.slidev.org:/jenkins/workspace/Portal/dist/*.war ${DESTINATION_DIR}/deploy/


#The setenv.sh has settings for the JVM that are used when tomcat starts
cp ${LIFERAY}/installer/conf/setenv.sh ${DESTINATION_DIR}/bin/

# Adding jars that liferay depends on to lib/ext
cp -r ${LIFERAY}/installer/conf/ext ${DESTINATION_DIR}

# Update catalina.properties to look for jars in the directory created above (lib/ext)
cp ${LIFERAY}/installer/conf/catalina.properties ${DESTINATION_DIR}/conf

# Copy the portal.xml file into tomcat 
cp -r ${LIFERAY}/installer/conf/localhost ${DESTINATION_DIR}/conf/Catalina/localhost


# Copy the portal-ext.properties file into tomcat
cp ${LIFERAY}/installer/conf/portal-ext.properties ${DESTINATION_DIR}

#Copy installation script
cp ${LIFERAY}/installer/ProvisionScript.sh ${DESTINATION_DIR}

#Copy lar file
cp ${LIFERAY}/installer/layout.lar ${DESTINATION_DIR}

#Copy Environment properties
echo "api.client=apiClient
api.server.url=https://devjuggernauts.slidev.org/
security.server.url=https://devjuggernauts.slidev.org/
oauth.client.id=X583c5HXTh
oauth.client.secret=AAAearFawozhl63jofnhCp1ms4VeKGFPQUmP2UalJgbK4g6C
oauth.redirect=https://${DESTINATION_URL}/portal/c/portal/login
">${DESTINATION_DIR}/environment.properties

#mysql for portal
cp ${LIFERAY}/installer/mysql/lr_mysql_init.sql ${DESTINATION_DIR}/r_mysql_init.sql

#copy to destination
echo "#############################"
echo "copying to ${DESTINATION_URL}"
echo "#############################"
ssh ${DESTINATION_URL} "rm -rf ${DESTINATION_DIR};mkdir -p ${DESTINATION_DIR}"
scp -r ${DESTINATION_DIR}/* ${DESTINATION_URL}:${DESTINATION_DIR}/

echo "#############################"
echo "Next step. ssh ${DESTINATION_URL} then execute ${DESTINATION_DIR}/ProvisionScript.sh"
