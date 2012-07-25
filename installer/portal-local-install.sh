#!/bin/bash

EXECUTE_ALL=0
PURGE_OPT=0
INTERACTIVE=0
DATABASE_INIT=0
UPDATE_JSON=0
SKIP_DEPLOY=0

while getopts aipdjs o
do
   case  "$o" in
      a)   EXECUTE_ALL=1;;
      i)   INTERACTIVE=1;;
      p)   PURGE_OPT=1;;
      d)   DATABASE_INIT=1;;
      j)   UPDATE_JSON=1;;
      s)   SKIP_DEPLOY=1;;
      [?])   echo "-a (equivalent of -p -d -j)"
             echo "-i (interactive mode to setup Tomcat and Portal)"
             echo "-p (purge /opt before install)"
             echo "-d (drop and create loption database)"
             echo "-j (update JSON file then update mongo)"
             echo "-s (skip deploy portal applications to /opt/deploy)"
             echo "useful link https://thesli.onconfluence.com/display/sli/Checkout+and+Build+Portal"
           exit 1;;
   esac
done

if [ ${EXECUTE_ALL} == 1 ]; then
   PURGE_OPT=1
   DATABASE_INIT=1
   UPDATE_JSON=1
fi

WGET=`which wget`

if [ -z "${WGET}" ]; then
   echo "wget is required"
   echo "hint for OSX: brew install wget"
   echo "hint for RedHat: yum install wget"
   echo "hint for Ubuntu: apt-get install wget"
   exit
fi

DIALOG=`which dialog`
if [ -z "${DIALOG}" ]; then
   echo "dialog is required"
   echo "hint for OSX: brew install dialog"
   echo "hint for RedHat: yum install dialog"
   echo "hint for Ubuntu: apt-get install dialog"
   exit
fi

if [ -f ~/.portal-local-install.env ]; then
. ~/.portal-local-install.env
else
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
PORTAL_PORT="7000"
fi

if [ ${INTERACTIVE} == 1 ]; then
   PID=$$

   dialog --title "liferay git repo" --backtitle "Portal Local Install: 1 of 7" --nocancel --inputbox "Enter location of liferay git repo directory" 8 80 ${LIFERAY_HOME} 2>/tmp/portal-install.${PID}
   LIFERAY_HOME=`cat /tmp/portal-install.${PID}`
   rm -f /tmp/portal-install.${PID}

   dialog --title "sli git repo" --backtitle "Portal Local Install: 2 of 7" --nocancel --inputbox "Enter location of portal git repo directory" 8 80 ${SLI_HOME} 2>/tmp/portal-install.${PID}
   SLI_HOME=`cat /tmp/portal-install.${PID}`
   rm -f /tmp/portal-install.${PID}

   dialog --title "TOMCAT version" --backtitle "Portal Local Install: 3 of 7" --nocancel --inputbox "Enter Tomcat version you want to install" 8 80 ${TOMCAT_VERSION} 2>/tmp/portal-install.${PID}
   TOMCAT_VERSION=`cat /tmp/portal-install.${PID}`
   rm -f /tmp/portal-install.${PID}

   dialog --title "client id" --backtitle "Portal Local Install: 4 of 7" --nocancel --inputbox "Enter your client id for Portal" 8 80 ${CLIENT_ID} 2>/tmp/portal-install.${PID}
   CLIENT_ID=`cat /tmp/portal-install.${PID}`
   rm -f /tmp/portal-install.${PID}

   dialog --title "client secret" --backtitle "Portal Local Install: 5 of 7" --nocancel --inputbox "Enter your client secret for Portal" 8 80 ${CLIENT_SECRET} 2>/tmp/portal-install.${PID}
   CLIENT_SECRET=`cat /tmp/portal-install.${PID}`
   rm -f /tmp/portal-install.${PID}

   dialog --title "API Server" --backtitle "Portal Local Install: 6 of 7" --nocancel --inputbox "Enter your API Server" 8 80 ${API} 2>/tmp/portal-install.${PID}
   API=`cat /tmp/portal-install.${PID}`
   rm -f /tmp/portal-install.${PID}

   dialog --title "Portal Server Port" --backtitle "Portal Local Install: 7 of 7" --nocancel --inputbox "Enter Portal Server Listening Port" 8 80 ${PORTAL_PORT} 2>/tmp/portal-install.${PID}
   PORTAL_PORT=`cat /tmp/portal-install.${PID}`
   rm -f /tmp/portal-install.${PID}
fi

echo "LIFERAY_HOME=${LIFERAY_HOME}
SLI_HOME=${SLI_HOME}
OPT=${OPT}
PORTAL_TOMCAT=${PORTAL_TOMCAT}
DEPLOY_DIR=${DEPLOY_DIR}
ENCRYPTION_DIR=${ENCRYPTION_DIR}
TOMCAT_VERSION=${TOMCAT_VERSION}
TOMCAT_HOME=${TOMCAT_HOME}
USER=${USER}
CLIENT_ID=${CLIENT_ID}
CLIENT_SECRET=${CLIENT_SECRET}
API=${API}
PORTAL_PORT=${PORTAL_PORT}"> ~/.portal-local-install.env

if [ ${DATABASE_INIT} == 1 ]; then
   MYSQL=`which mysql`
   if [ -z "${MYSQL}" ]; then
      echo "mysql command not found in PATH, or it may not be installed"
      echo "Abort installation"
      exit 1
   fi
   if [ ! -f ${LIFERAY_HOME}/installer/mysql/lr_mysql_init.sql ]; then
      echo "${LIFERAY_HOME}/installer/mysql/lr_mysql_init.sql file does not exist"
      echo "Please make sure your liferay repo directory is \"${LIFERAY_HOME}\""
      echo "You can specify your liferay repo directory by running \"portal-local-install.sh -i\""
      exit
   fi
   echo "Dropping lportal database"
   mysqladmin drop lportal -u root
   mysql -u root < ${LIFERAY_HOME}/installer/mysql/lr_mysql_init.sql
fi

if [ ! -d ${SLI_HOME}/config ]; then
   echo "${SLI_HOME} is incorrect"
   echo "Please make sure your sli repo directory is \"${SLI_HOME}\""
   echo "You can specify your liferay repo directory by running \"portal-local-install.sh -i\""
   exit
fi

if [ ${PURGE_OPT} == 1 ]; then
   dialog --title "Deleting ${OPT} directory"  --backtitle "Portal Local Install"  --yesno "Are you sure you want to permanetly delete \"${OPT}\"?" 8 80
   YES_NO=$?
   case $YES_NO in
      0) sudo rm -rf ${OPT};;
      1) echo "${OPT} directory not deleted";;
      255) echo "[ESC] key pressed. I am exiting out"; exit;;
   esac
fi




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
else
   echo "################################"
   echo "${TOMCAT_HOME} exists"
   echo "Skipping downloading apache-tomcat-${TOMCAT_VERSION}.tar.gz"
   echo "################################"
fi
rm -f /tmp/environment.properties
echo "api.client=apiClient
api.server.url=${API}
security.server.url=${API}
oauth.client.id=${CLIENT_ID}
oauth.client.secret=${CLIENT_SECRET}
oauth.redirect=http://local.slidev.org:${PORTAL_PORT}/portal/c/portal/login
oauth.encryption=false" > /tmp/environment.properties

if [ ! -f ${OPT}/portal-ext.properties ]; then
   grep -v jdbc.default.encrypted.password ${LIFERAY_HOME}/installer/conf/portal-ext.properties|grep -v jdbc.default.password > ${OPT}/portal-ext.properties
   echo "jdbc.default.password=liferaywgen" >> ${OPT}/portal-ext.properties
else
   echo "################################"
   echo "${OPT}/portal-ext.properties exists"
   echo "Skipping creating ${OPT}/portal-ext.properties"
   echo "################################"
fi

if [ ! -f ${PORTAL_TOMCAT}/conf/sli.properties ]; then
   grep -v bootstrap.app.keys ${SLI_HOME}/config/properties/sli.properties |grep -v portal.footer.url |grep -v portal.header.url > ${PORTAL_TOMCAT}/conf/sli.properties
   echo "bootstrap.app.keys = admin,databrowser,dashboard,portal" >> ${PORTAL_TOMCAT}/conf/sli.properties
   echo "portal.header.url = http://local.slidev.org:${PORTAL_PORT}/headerfooter-portlet/api/secure/jsonws/headerfooter/get-header" >> ${PORTAL_TOMCAT}/conf/sli.properties
   echo "portal.footer.url = http://local.slidev.org:${PORTAL_PORT}/headerfooter-portlet/api/secure/jsonws/headerfooter/get-footer" >> ${PORTAL_TOMCAT}/conf/sli.properties
   echo "sli.domain=slidev.org" >> ${PORTAL_TOMCAT}/conf/sli.properties
else
   echo "################################"
   echo "${PORTAL_TOMCAT}/conf/sli.properties exists"
   echo "Skipping creating ${PORTAL_TOMCAT}/conf/sli.properties"
   echo "################################"
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
else
   echo "################################"
   echo "${PORTAL_TOMCAT}/webapps/portal.war  exists"
   echo "Skipping downloading ${PORTAL_TOMCAT}/webapps/portal.war "
   echo "################################"
fi

if [ ${SKIP_DEPLOY} == 0 ]; then
   RM_PORTAL=0
   if [ ! -d ${PORTAL_TOMCAT}/webapps/portal ]; then
      cd ${PORTAL_TOMCAT}/webapps/
      unzip -d ${PORTAL_TOMCAT}/webapps/portal portal.war
      RM_PORTAL=1
   fi
   cd ${LIFERAY_HOME}
   CLASSPATH=${LIFERAY_HOME}/lib/ecj.jar ant -Denv=/tmp/environment.properties deploy
   #temporary until DE1385 is fix.
   rm -f ${DEPLOY_DIR}/Analytics-hook*.war
   if [ ${RM_PORTAL} == 1 ]; then
      rm -rf ${PORTAL_TOMCAT}/webapps/portal
   fi
   mv /opt/portal/environment.properties ${OPT}/
fi
rm -rf /opt/portal/
if [ ${UPDATE_JSON} == 1 ]; then
   echo "UPDATING JSON"
   grep 213ee853-8983-fe48-bf5e-fde3c3a6437b ${SLI_HOME}/acceptance-tests/test/data/application_fixture.json > /dev/null 2>&1
   JSON_DATA=$?
   if [ ${JSON_DATA} == 1 ]; then
      echo '{ "_id" : "213ee853-8983-fe48-bf5e-fde3c3a6437b", "type" : "application", "body" : { "authorized_ed_orgs" : ["IL-SUNSET", "IL", "IL-DAYBREAK", "15", "NC-KRYPTON", "GALACTICA", "CAPRICA", "PICON", "SAGITTARON", "VIRGON", "NY-Parker","NY-Dusk", "NY", "SC-OVERLORD", "KS-GREATVILLE", "KS-SMALLVILLE","KS-OVERLORD"], "version": "0.0", "image_url": "http://placekitten.com/150/150", "administration_url": "http://local.slidev.org:PORTAL_PORT/c/portal/login", "application_url":"http://local.slidev.org:PORTAL_PORT/c/portal/login", "client_secret" : "ghjZfyAXi7qwejklcxziuohiueqjknfdsip9cxzhiu13mnsX", "registration": {"status": "APPROVED", "request_date": 1330521193111, "approval_date": 1330521193111}, "redirect_uri" : "http://local.slidev.org:PORTAL_PORT/portal/c/portal/login", "description" : "Portal Local", "name" : "Portal Local", "is_admin": false, "authorized_for_all_edorgs": true, "allowed_for_all_edorgs": true, "created_by": "slcdeveloper", "installed": false, "client_id" : "lY83c5HmTPX", "behavior": "Full Window App", "vendor" : "SLC"}, "metaData" : { "updated" : { "$date" : 1330521193111 }, "created" : { "$date" : 1330521193111 }} }' |sed "s/PORTAL_PORT/${PORTAL_PORT}/g" >> ${SLI_HOME}/acceptance-tests/test/data/application_fixture.json
      echo '{ "_id" :{ "$binary" : "D0j+8nc6kW62GFLgZnwNnA==", "$type" : "03" }, "type" : "applicationAuthorization", "body" :{ "authId" : "IL-DAYBREAK", "authType" : "EDUCATION_ORGANIZATION", "appIds" : [ "78f71c9a-8e37-0f86-8560-7783379d96f7", "deb9a9d2-771d-40a1-bb9c-7f93b44e51df", "148eebc7-e320-4e35-b7c2-238e90dbd957", "1ad39ff1-65f8-4a16-8912-b49872f1ee96", "63e006bd-fc5f-450f-89c2-69bdfa979c43", "ee3e4e95-0c28-4110-b41b-b29cdec344e6", "25d21fdd-7e97-4aa4-aed0-6d6592a35bb2", "7a8a28cf-f9f2-4ea4-a238-d11b84a3dad2", "8a3def8c-016c-454a-a3ef-cf851e386d4e", "df91814a-ae2e-47f9-b642-742b8c26d65f", "25d21fdd-7e97-4aa4-79d0-6d6592a35bb2", "7a8a28cf-f9f2-4ea4-7938-d11b84a3dad2", "df91814a-ae2e-47f9-7942-742b8c26d65f", "7ae2a2f6-09dc-455d-b139-4d0da6189b52", "af264911-f638-4ec7-b792-69a2a2949b1e", "71ee2a92-788a-4dff-9d72-f1b6f0670aa7", "f4ad653b-2108-4e92-864c-e03722e5ef82", "b26e9c15-54d5-43d5-9d6f-52b8998a6047", "6387e94d-1912-4918-85e0-4f38014253cf", "213ee853-8983-4e40-bf5e-fde3c3a6437b", "52ab3769-1655-4542-971c-1fa02b1b368d", "1ef3990c-e0b5-4046-985c-fbcbab680bb9", "19cca28d-7357-4044-8df9-caad4b1c8ee4", "ee3e4e95-0c28-5114-b41b-b29cdec344e6", "2274ab86-6e21-ab75-9d6f-52b8998a6007", "eab130ba-6e5a-ab75-864c-e03722e523c2", "c09628da-9ea2-d969-85e0-4f3801425388", "c07a656a-6a2c-d9b1-85e0-4fe419425b3b", "1abf3940-84cc-11e1-b0c4-0800200c9a66", "c6251365-e571-482e-8f80-aaece6fd5136", "206e28d3-89a9-db4a-8f80-aaece6fda529", "213ee853-8983-fe48-bf5e-fde3c3a6437b" ] }, "metaData" : { "updated" :{ "$date" : 1332785105123 }, "created" :{ "$date" : 1332785105123 }} }' >> ${SLI_HOME}/acceptance-tests/test/data/applicationAuthorization_fixture.json
   fi
   echo
   echo
   echo
   echo "######## REQURED ########"
   echo "Please run bundle exec rake realmInitNoPeople"
   echo
   echo
   echo
fi
echo "########## Next Step ###########"
echo "setup Tomcat for Eclipse"
echo "Append following line to Eclipse Tomcat 'General Information'->'Open launch configuration'->'Arguments' tab->'VM arguments:'"
echo "Please make sure you select 'Use custom location (does not modify Tomcat installation)' and set '/opt/tomcat' for 'Server path:' and set 'webapps' for 'Deploy path:' before saving it"
echo "https://thesli.onconfluence.com/display/sli/Checkout+and+Build+Portal and refer 'Option 2. Script Driven Install'"
if [ ${DATABASE_INIT} == 1 ]; then
   echo "Your lportal database has been newly created.  This is very important that Tomcat server needs to start \"TWICE\" before you login to portal"
fi
echo "############# BEGIN ###########"
echo "-Dorg.apache.catalina.loader.WebappClassLoader.ENABLE_CLEAR_REFERENCES=false -Xmx1024m -XX:+CMSClassUnloadingEnabled -XX:+CMSPermGenSweepingEnabled -XX:MaxPermSize=512m -Dsli.encryption.keyStore=${ENCRYPTION_DIR}/ciKeyStore.jks -Dsli.encryption.properties=${ENCRYPTION_DIR}/ciEncryption.properties -Dsli.trust.certificates=${ENCRYPTION_DIR}/trustedCertificates -Dsli.conf=${PORTAL_TOMCAT}/sli.properties"
echo "############# END #############"
