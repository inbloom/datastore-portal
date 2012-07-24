#!/bin/bash


LIFERAY_HOME=~/liferay
SLI_HOME=~/sli/sli
OPT=/opt
PORTAL_TOMCAT=${OPT}/tomcat
DEPLOY_DIR=${OPT}/deploy
ENCRYPTION_DIR=${PORTAL_TOMCAT}/encryption
TOMCAT_VERSION=7.0.29
TOMCAT_HOME=/opt/apache-tomcat-${TOMCAT_VERSION}
USER=`whoami`
CLIENT_ID="lY83c5HmTPX"
CLIENT_SECRET="ghjZfyAXi7qwejklcxziuohiueqjknfdsip9cxzhiu13mnsX"
API="http://local.slidev.org:8080/"





#shell commands to prepare portal environment
if [ ! -d ${OPT} ]; then
   sudo mkdir ${OPT}
   sudo chown -R ${USER} ${OPT}
fi
mkdir -p ${PORTAL_TOMCAT}/{webapps,conf} ${ENCRYPTION_DIR} ${DEPLOY_DIR}
find ${PORTAL_TOMCAT}/webapps -type d -depth 1|grep -v portal |xargs rm -rf
if [ ! -d ${TOMCAT_HOME} ]; then
   wget -O /opt/apache-tomcat.tar.gz http://apache.mirrors.hoobly.com/tomcat/tomcat-7/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
   tar -C /opt -zxvf /opt/apache-tomcat.tar.gz
   rm -f /opt/apache-tomcat.tar.gz
fi
rm -f /tmp/environment.properties
echo "api.client=apiClient
api.server.url=${API}
security.server.url=${API}
oauth.client.id=${CLIENT_ID}
oauth.client.secret=${CLIENT_SECRET}
oauth.redirect=http://local.slidev.org:7000/portal/c/portal/login
oauth.encryption=false" > /tmp/environment.properties

if [ ! -f ${OPT}/portal-ext.properties ]; then
grep -v jdbc.default.encrypted.password ${LIFERAY_HOME}/installer/conf/portal-ext.properties > ${OPT}/portal-ext.properties
#   cp ${LIFERAY_HOME}/installer/conf/portal-ext.properties ${OPT}
fi

if [ ! -f ${PORTAL_TOMCAT}/conf/sli.properties ]; then
   grep -v bootstrap.app.keys ${SLI_HOME}/config/properties/sli.properties > ${PORTAL_TOMCAT}/conf/sli.properties
   echo "bootstrap.app.keys = admin,databrowser,dashboard,portal
bootstrap.app.portal.name = Portal
bootstrap.app.portal.description = The SLC Portal application is the primary access portal.
bootstrap.app.portal.version = 0.0 
bootstrap.app.portal.client_secret = ghjZfyAXi7qwejklcxziuohiueqjknfdsip9cxzhiu13mnsX
bootstrap.app.portal.client_id = lY83c5HmTPX
bootstrap.app.portal.template = applications/portal.json
bootstrap.app.portal.url = http://local.slidev.org:7000/portal
bootstrap.app.portal.authorized_for_all_edorgs = true
bootstrap.app.portal.allowed_for_all_edorgs = true" >> ${PORTAL_TOMCAT}/conf/sli.properties
   echo "sli.domain=slidev.org" >> ${PORTAL_TOMCAT}/conf/sli.properties
fi

if [ ! -f ${LIFERAY_HOME}/build.${USER}.properties ]; then
   echo "app.server.portal.dir=${PORTAL_TOMCAT}/webapps/portal
app.server.lib.global.dir=${LIFERAY_HOME}/installer/conf/ext
app.server.deploy.dir=${DEPLOY_DIR}
app.server.type=tomcat
app.server.dir=${TOMCAT_HOME}" > ${LIFERAY_HOME}/build.${USER}.properties
fi

if [ ! -f ${ENCRYPTION_DIR}/ciKeyStore.jks  ]; then
   cp ${SLI_HOME}/data-access/dal/keyStore/ciKeyStore.jks ${ENCRYPTION_DIR}
fi

if [ ! -f ${ENCRYPTION_DIR}/ciEncryption.properties  ]; then
   cp ${SLI_HOME}/data-access/dal/keyStore/ciEncryption.properties ${ENCRYPTION_DIR}
fi

if [ ! -f ${ENCRYPTION_DIR}/trustedCertificates ]; then
   cp ${SLI_HOME}/common/common-encrypt/trust/trustedCertificates ${ENCRYPTION_DIR}
fi

if [ ! -d ${PORTAL_TOMCAT}/lib ]; then
   ln -s ${LIFERAY_HOME}/installer/conf/ext ${PORTAL_TOMCAT}/lib
fi

if [ ! -f ${DEPLOY_DIR}/layout.lar ]; then
   cp ${LIFERAY_HOME}/installer/layout.lar ${DEPLOY_DIR}
fi

if [ ! -f ${PORTAL_TOMCAT}/webapps/portal.war ]; then
   wget -O ${PORTAL_TOMCAT}/webapps/portal.war http://downloads.sourceforge.net/project/lportal/Liferay%20Portal/6.1.0%20GA1/liferay-portal-6.1.0-ce-ga1-20120106155615760.war
fi

RM_PORTAL=0
if [ ! -d ${PORTAL_TOMCAT}/webapps/portal ]; then
   cd ${PORTAL_TOMCAT}/webapps/
   unzip -d ${PORTAL_TOMCAT}/webapps/portal portal.war
   RM_PORTAL=1
fi
cd ${LIFERAY_HOME}
ant -Denv=/tmp/environment.properties deploy
#temporary until DE1385 is fix.
rm -f ${DEPLOY_DIR}/Analytics-hook*.war
cd -
if [ ${RM_PORTAL} == 1 ]; then
   rm -rf ${PORTAL_TOMCAT}/webapps/portal
fi
mv /opt/portal/environment.properties ${OPT}/
rm -rf /opt/portal/
echo "########## Next Step ###########"
echo "setup Tomcat for Eclipse"
echo "Append following line to Eclipse Tomcat 'General Information'->'Open launch configuration'->'Arguments' tab->'VM arguments:'"
echo "Please make sure you select 'Use custom location (does not modify Tomcat installation)' and set '/opt/tomcat' for 'Server path:' and set 'webapps' for 'Deploy path:' before saving it"
echo "############# BEGIN ###########"
echo "-Dorg.apache.catalina.loader.WebappClassLoader.ENABLE_CLEAR_REFERENCES=false -Xmx1024m -XX:+CMSClassUnloadingEnabled -XX:+CMSPermGenSweepingEnabled -XX:MaxPermSize=512m -Dsli.encryption.keyStore=${ENCRYPTION_DIR}/ciKeyStore.jks -Dsli.encryption.properties=${ENCRYPTION_DIR}/ciEncryption.properties -Dsli.trust.certificates=${ENCRYPTION_DIR}/trustedCertificates -Dsli.conf=${PORTAL_TOMCAT}/sli.properties"
echo "############# END #############"
