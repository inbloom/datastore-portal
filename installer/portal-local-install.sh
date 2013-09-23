#!/bin/bash


PID=$$
function check_dependancy() {
   WGET=`which wget`
   
   if [ -z "${WGET}" ]; then
      echo "wget is required"
      echo "hint for OSX: brew install wget"
      echo "hint for RedHat: yum install wget"
      echo "hint for Ubuntu: apt-get install wget"
      echo "Windows? ..... format your hard drive and install Linux"
      exit 1
   fi
   
   DIALOG=`which dialog`
   if [ -z "${DIALOG}" ]; then
      echo "dialog is required"
      echo "hint for OSX: brew install dialog"
      echo "hint for RedHat: yum install dialog"
      echo "hint for Ubuntu: apt-get install dialog"
      echo "Windows? ..... format your hard drive and install Linux"
      exit 1
   fi
}

function set_env() {
   LIFERAY_HOME=~/liferay
   SLI_HOME=~/sli/sli
   OPT=~/opt
   PORTAL_TOMCAT=${OPT}/tomcat
   DEPLOY_DIR=${OPT}/deploy
   ENCRYPTION_DIR=${PORTAL_TOMCAT}/encryption
   TOMCAT_VERSION=7.0.32
   TOMCAT_HOME=${OPT}/apache-tomcat-${TOMCAT_VERSION}
   USER=`whoami`
   CLIENT_ID="lY83c5HmTPX"
   CLIENT_SECRET="ghjZfyAXi7qwejklcxziuohiueqjknfdsip9cxzhiu13mnsX"
   API="http://local.slidev.org:8080/"
   PORTAL_PORT="7000"
   #sourcing previous environment variables from the file
   if [ -f ~/.portal-local-install.env ]; then
      . ~/.portal-local-install.env
   fi
   if [ ${INTERACTIVE} == 1 ]; then
      dialog --title "liferay git repo" --backtitle "Portal Local Install: 1 of 10" --nocancel --inputbox "Enter Location of Tomcat directory that contains Tomcat installation" 8 80 ${OPT} 2>/tmp/portal-install.${PID}
      OPT=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}

      dialog --title "liferay git repo" --backtitle "Portal Local Install: 2 of 10" --nocancel --inputbox "Enter location of liferay git repository directory" 8 80 ${LIFERAY_HOME} 2>/tmp/portal-install.${PID}
      LIFERAY_HOME=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}
   
      dialog --title "sli git repo" --backtitle "Portal Local Install: 3 of 10" --nocancel --inputbox "Enter location of SLI git repository directory" 8 80 ${SLI_HOME} 2>/tmp/portal-install.${PID}
      SLI_HOME=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}

      dialog --title "Encryption directory" --backtitle "Portal Local Install: 4 of 10" --nocancel --inputbox "Enter the directory to install ciEncryption in" 8 80 ${ENCRYPTION_DIR} 2>/tmp/portal-install.${PID}
      ENCRYPTION_DIR=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}
   
      dialog --title "TOMCAT version" --backtitle "Portal Local Install: 5 of 10" --nocancel --inputbox "Enter Tomcat version you want to install" 8 80 ${TOMCAT_VERSION} 2>/tmp/portal-install.${PID}
      TOMCAT_VERSION=`cat /tmp/portal-install.${PID}`
      TOMCAT_HOME=${OPT}/apache-tomcat-${TOMCAT_VERSION}
      rm -f /tmp/portal-install.${PID}
   
      dialog --title "client id" --backtitle "Portal Local Install: 6 of 10" --nocancel --inputbox "Enter your unecnrypted client id for Portal" 8 80 ${CLIENT_ID} 2>/tmp/portal-install.${PID}
      CLIENT_ID=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}
   
      dialog --title "client secret" --backtitle "Portal Local Install: 7 of 10" --nocancel --inputbox "Enter your unencrypted client secret for Portal" 8 80 ${CLIENT_SECRET} 2>/tmp/portal-install.${PID}
      CLIENT_SECRET=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}
   

      dialog --title "Portal Server Port" --backtitle "Portal Local Install: 9 of 10" --nocancel --inputbox "Which port will Portal use for listening?" 8 80 ${PORTAL_PORT} 2>/tmp/portal-install.${PID}
      PORTAL_PORT=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}

      if [ ${API_INSTALL} != 0 ]; then
         API="http://local.slidev.org:${PORTAL_PORT}/"
      else
         API="http://local.slidev.org:8080/"
      fi
      dialog --title "API Server" --backtitle "Portal Local Install: 9 of 10" --nocancel --inputbox "Enter URL for API Server" 8 80 ${API} 2>/tmp/portal-install.${PID}
      API=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}

      dialog --title "Portal Hot Deployment Directory" --backtitle "Portal Local Install: 10 of 10" --nocancel --inputbox "Enter Portal Hot Deployment Directory" 8 80 ${DEPLOY_DIR} 2>/tmp/portal-install.${PID}
      DEPLOY_DIR=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}
   fi
   #saving environment variable for future execution
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
}

function database_init() {
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
         exit 1
      fi
      echo "Dropping lportal database"
      mysqladmin drop lportal -u root
      mysql -u root < ${LIFERAY_HOME}/installer/mysql/lr_mysql_init.sql
      echo "You can ignore \"ERROR 1062\" if displayed"
   fi
}

function check_SLI_HOME() {
   if [ ! -d ${SLI_HOME}/config ]; then
      echo "${SLI_HOME} is incorrect"
      echo "Please make sure your sli repo directory is \"${SLI_HOME}\""
      echo "You can specify your liferay repo directory by running \"portal-local-install.sh -i\""
      exit 1
   fi
   if [ ${API_INSTALL} != 0 ]; then
      API_INSTALL=${SLI_HOME}/api/target/api.war
      if [ ! -f ${API_INSTALL} ]; then
         echo "${API_INSTALL} does not exist."
         exit 1
      fi
   fi
   if [ ${SIMPLE_IDP_INSTALL} != 0 ]; then
      SIMPLE_IDP_INSTALL=${SLI_HOME}/simple-idp/target/simple-idp.war
      if [ ! -f ${SIMPLE_IDP_INSTALL} ]; then
         echo "${SIMPLE_IDP_INSTALL} does not exist."
         exit 1
      fi
   fi
   if [ ${DASHBOARD_INSTALL} != 0 ]; then
      DASHBOARD_INSTALL=${SLI_HOME}/dashboard/target/dashboard.war
      if [ ! -f ${DASHBOARD_INSTALL} ]; then
         echo "${DASHBOARD_INSTALL} does not exist."
         exit 1
      fi
   fi
}

function purge_opt() {
   if [ ${PURGE_OPT} == 1 ]; then
      if [ -d ${OPT} ]; then
         dialog --title "Deleting ${OPT} directory"  --backtitle "Portal Local Install"  --yesno "Are you sure you want to permanetly delete \"${OPT}\"?" 8 80
         YES_NO=$?
         case $YES_NO in
            0) rm -rf ${OPT};;
            1) echo "${OPT} directory not deleted";;
            255) echo "[ESC] key pressed. I am exiting out"; exit;;
         esac
      fi
   fi
}

function check_opt() {
   if [ ! -d ${OPT} ]; then
      mkdir ${OPT}
      RET=$?
      if [ ${RET} != 0 ]; then
         echo "Fail to create ${OPT} directory."
         echo "exiting"
         exit 1
      fi
   fi
}

function setup_tomcat() {
   mkdir -p ${PORTAL_TOMCAT}/{webapps,logs,bin} ${DEPLOY_DIR} ${OPT}/logs
   cp -a ${LIFERAY_HOME}/installer/conf/tomcat/* ${PORTAL_TOMCAT}

   if [ ! -d ${TOMCAT_HOME} ]; then
      if [ -f ~/.portal/apache-tomcat-${TOMCAT_VERSION}.tar.gz ]; then
         echo
         echo "Found ~/.portal/apache-tomcat-${TOMCAT_VERSION}.tar.gz"
         echo
         cp ~/.portal/apache-tomcat-${TOMCAT_VERSION}.tar.gz ${OPT}/apache-tomcat.tar.gz
      else
         echo
         echo "Downloading Tomcat from the Internet"
         echo
         wget -O ${OPT}/apache-tomcat.tar.gz http://apache.mirrors.hoobly.com/tomcat/tomcat-7/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
         RET=$?
         if [ ${RET} != 0 ]; then
            echo "Failed to doanload apache-tomcat.  Exiting out..."
            exit 1
         fi
         if [ ! -d ~/.portal ]; then
            mkdir ~/.portal
         fi
         cp ${OPT}/apache-tomcat.tar.gz ~/.portal/apache-tomcat-${TOMCAT_VERSION}.tar.gz
      fi
      tar -C ${OPT} -zxf ${OPT}/apache-tomcat.tar.gz
      rm -f ${OPT}/apache-tomcat.tar.gz
      if [ -f ${PORTAL_TOMCAT}/conf/server.xml.template ]; then
         sed -e "s/{PORTAL_PORT}/${PORTAL_PORT}/g" ${PORTAL_TOMCAT}/conf/server.xml.template > ${PORTAL_TOMCAT}/conf/server.xml
         rm -f ${PORTAL_TOMCAT}/conf/server.xml.template
      fi
      ln -sf ${TOMCAT_HOME}/bin/catalina.sh ${PORTAL_TOMCAT}/bin/catalina.sh

      #Generating start/stop/debug-start script for Tomcat
      echo "export CATALINA_HOME=${TOMCAT_HOME}
export CATALINA_BASE=${PORTAL_TOMCAT}
${PORTAL_TOMCAT}/bin/catalina.sh start
unset CATALINA_HOME
unset CATALINA_BASE" > ${PORTAL_TOMCAT}/bin/start.sh
chmod a+x ${PORTAL_TOMCAT}/bin/start.sh
      echo "export CATALINA_HOME=${TOMCAT_HOME}
export CATALINA_BASE=${PORTAL_TOMCAT}
${PORTAL_TOMCAT}/bin/catalina.sh jpda start
unset CATALINA_HOME
unset CATALINA_BASE" > ${PORTAL_TOMCAT}/bin/debug-start.sh
chmod a+x ${PORTAL_TOMCAT}/bin/debug-start.sh
      echo "export CATALINA_HOME=${TOMCAT_HOME}
export CATALINA_BASE=${PORTAL_TOMCAT}
${PORTAL_TOMCAT}/bin/catalina.sh stop
unset CATALINA_HOME
unset CATALINA_BASE" > ${PORTAL_TOMCAT}/bin/stop.sh
chmod a+x ${PORTAL_TOMCAT}/bin/stop.sh
   else
      echo "################################"
      echo "${TOMCAT_HOME} exists"
      echo "Skipping downloading apache-tomcat-${TOMCAT_VERSION}.tar.gz"
      echo "################################"
   fi
   if [ ! -d ${PORTAL_TOMCAT}/webapps/ROOT ]; then
      cp -fr ${TOMCAT_HOME}/webapps/ROOT ${PORTAL_TOMCAT}/webapps/
   fi
   if [ ! -d ${PORTAL_TOMCAT}/webapps/manager ]; then
      cp -fr ${TOMCAT_HOME}/webapps/manager ${PORTAL_TOMCAT}/webapps/
   fi
   if [ ! -d ${PORTAL_TOMCAT}/webapps/host-manager ]; then
      cp -fr ${TOMCAT_HOME}/webapps/host-manager ${PORTAL_TOMCAT}/webapps/
   fi
}

function set_portal_env() {

   if [ ! -f ${OPT}/portal-ext.properties ]; then
      grep -v jdbc.default.encrypted.password ${LIFERAY_HOME}/installer/conf/portal-ext.properties|grep -v jdbc.default.password |grep -v auto.deploy.deploy.dir > ${OPT}/portal-ext.properties
      echo "jdbc.default.password=liferaywgen" >> ${OPT}/portal-ext.properties
      echo "auto.deploy.deploy.dir=${DEPLOY_DIR}" >> ${OPT}/portal-ext.properties
      echo "# disable access to repositories
plugin.repositories.trusted=
plugin.repositories.untrusted=

#disable new plugin notifications
plugin.notifications.enabled=false" >> ${OPT}/portal-ext.properties
   else
      echo "################################"
      echo "${OPT}/portal-ext.properties exists"
      echo "Skipping creating ${OPT}/portal-ext.properties"
      echo "################################"
   fi
   
   if [ ! -f ${PORTAL_TOMCAT}/conf/sli.properties ]; then
      echo "api.client=apiClient
api.server.url=${API}
security.server.url=${API}
portal.oauth.client.id=${CLIENT_ID}
portal.oauth.client.secret=${CLIENT_SECRET}
portal.oauth.redirect=http://local.slidev.org:${PORTAL_PORT}/portal/c/portal/login
portal.oauth.encryption=false
log.path=${OPT}/logs" > ${PORTAL_TOMCAT}/conf/sli.properties
      ${SLI_HOME}/config/scripts/webapp-provision.rb ${SLI_HOME}/config/config.in/portal_config.yml local /dev/stdout|grep -v security.server.url |grep -v api.server.url |grep -v oauth.client.id|grep -v oauth.client.secret|grep -v oauth.redirect |grep -v oauth.encryption|grep -v api.client |grep -v log.path |grep -v bootstrap.app.dashboard.authorized_for_all_edorgs >> ${PORTAL_TOMCAT}/conf/sli.properties

      #If a user chose to install additional applicaiton, generate sli.properties
      SLI_PROP=""
      if [ ${API_INSTALL} != 0 ]; then
          if [ -z ${SLI_PROP} ]; then
             SLI_PROP=${PORTAL_TOMCAT}/conf/.sli.properties.tmp
             ${SLI_HOME}/config/scripts/webapp-provision.rb ${SLI_HOME}/config/config.in/canonical_config.yml local ${SLI_PROP}
          fi
          cat ${SLI_PROP}|grep -v security.server.url |grep -v api.server.url |grep -v oauth.encryption|grep -v api.client |grep -v log.path |sed -e "s/:8080/:${PORTAL_PORT}/g" > ${SLI_PROP}.1
          mv -f ${SLI_PROP}.1 ${SLI_PROP}
      fi
      if [ ${SIMPLE_IDP_INSTALL} != 0 ]; then
          if [ -z ${SLI_PROP} ]; then
             SLI_PROP=${PORTAL_TOMCAT}/conf/.sli.properties.tmp
             ${SLI_HOME}/config/scripts/webapp-provision.rb ${SLI_HOME}/config/config.in/canonical_config.yml local ${SLI_PROP}
          fi
          cat ${SLI_PROP}|grep -v security.server.url |grep -v api.server.url |grep -v oauth.encryption|grep -v api.client |grep -v log.path |sed -e "s/:8082/:${PORTAL_PORT}/g" > ${SLI_PROP}.1
          mv -f ${SLI_PROP}.1 ${SLI_PROP}
      fi
      if [ ${DASHBOARD_INSTALL} != 0 ]; then
          if [ -z ${SLI_PROP} ]; then
             SLI_PROP=${PORTAL_TOMCAT}/conf/.sli.properties.tmp
             ${SLI_HOME}/config/scripts/webapp-provision.rb ${SLI_HOME}/config/config.in/canonical_config.yml local ${SLI_PROP}
          fi
          cat ${SLI_PROP}|grep -v security.server.url |grep -v api.server.url |grep -v oauth.encryption|grep -v api.client |grep -v log.path |grep -v portal.footer.url |grep -v portal.header.url |sed -e "s/:8888/:${PORTAL_PORT}/g" > ${SLI_PROP}.1
          mv -f ${SLI_PROP}.1 ${SLI_PROP}
          echo "portal.footer.url=http://local.slidev.org:${PORTAL_PORT}/headerfooter-portlet/api/secure/jsonws/headerfooter/get-footer" >> ${SLI_PROP}
          echo "portal.header.url=http://local.slidev.org:${PORTAL_PORT}/headerfooter-portlet/api/secure/jsonws/headerfooter/get-header" >> ${SLI_PROP}
      fi
      if [ ! -z ${SLI_PROP} ]; then
         if [ -f ${SLI_PROP} ]; then
            cat ${SLI_PROP} |grep -v dashboard.encryption.keyStore |grep -v sli.encryption.keyStore >> ${PORTAL_TOMCAT}/conf/sli.properties
            echo "dashboard.encryption.keyStore = ${ENCRYPTION_DIR}/ciKeyStore.jks" >> ${PORTAL_TOMCAT}/conf/sli.properties
            echo "sli.encryption.keyStore = ${ENCRYPTION_DIR}/ciKeyStore.jks" >> ${PORTAL_TOMCAT}/conf/sli.properties
            echo "bootstrap.app.dashboard.authorized_for_all_edorgs = true" >> ${PORTAL_TOMCAT}/conf/sli.properties
            rm -f ${SLI_PROP} 
         fi
      fi
#this must be a bug for simple-idp.  it should not be in this file
         echo "sli.encryption.keyStorePass=changeit" >> ${PORTAL_TOMCAT}/conf/sli.properties
   else
      echo "################################"
      echo "${PORTAL_TOMCAT}/conf/sli.properties exists"
      echo "Skipping creating ${PORTAL_TOMCAT}/conf/sli.properties"
      echo "################################"
   fi

   echo "app.server.portal.dir=${PORTAL_TOMCAT}/webapps/portal
app.server.lib.global.dir=${LIFERAY_HOME}/installer/conf/ext
app.server.deploy.dir=${PORTAL_TOMCAT}/webapps
app.server.type=tomcat
auto.deploy.dir=${DEPLOY_DIR}
app.server.dir=${TOMCAT_HOME}" > ${LIFERAY_HOME}/build.${USER}.properties

   if [ ! -d ${ENCRYPTION_DIR} ]; then
      mkdir -p ${ENCRYPTION_DIR}
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
      if [ -f ~/.portal/portal.war ]; then
         echo 
         echo "Found ~/.portal/portal.war"
         echo 
         cp ~/.portal/portal.war ${PORTAL_TOMCAT}/webapps/portal.war
      else
         echo 
         echo "Downloading portal.war from the Internet"
         echo 
         wget -O ${PORTAL_TOMCAT}/webapps/portal.war http://downloads.sourceforge.net/project/lportal/Liferay%20Portal/6.1.0%20GA1/liferay-portal-6.1.0-ce-ga1-20120106155615760.war
         RET=$?
         if [ ${RET} != 0 ]; then
            echo "Failed to doanload Liferay.  Exiting out..."
            exit 1
         fi
         if [ ! -d ~/.portal ]; then
            mkdir ~/.portal
         fi
         cp ${PORTAL_TOMCAT}/webapps/portal.war ~/.portal/
      fi
   else
      echo "################################"
      echo "${PORTAL_TOMCAT}/webapps/portal.war  exists"
      echo "Skipping downloading ${PORTAL_TOMCAT}/webapps/portal.war "
      echo "################################"
      echo 
   fi
   if [ ! -f ${PORTAL_TOMCAT}/bin/setenv.sh ]; then
      echo "CATALINA_OPTS='-Dwtp.deploy=\"${PORTAL_TOMCAT}/webapps\" -Djava.endorsed.dirs=\"${TOMCAT_HOME}/endorsed\" -Dorg.apache.catalina.loader.WebappClassLoader.ENABLE_CLEAR_REFERENCES=false -Xmx1024m -XX:+CMSClassUnloadingEnabled -XX:+CMSPermGenSweepingEnabled -XX:MaxPermSize=512m -Dsli.encryption.keyStore=${ENCRYPTION_DIR}/ciKeyStore.jks -Dsli.encryption.properties=${ENCRYPTION_DIR}/ciEncryption.properties -Dsli.trust.certificates=${ENCRYPTION_DIR}/trustedCertificates -Dsli.conf=${PORTAL_TOMCAT}/conf/sli.properties -Dliferay.home=${OPT}'" > ${PORTAL_TOMCAT}/bin/setenv.sh
   fi
}

function deploy_all() {
   CLASSPATH=${LIFERAY_HOME}/lib/ecj.jar ant deploy
   RET=$?
   if [ $RET != 0 ];then
      echo "Failed compiling Portal hooks/portlets.  Exiting..."
      exit 1
   fi
   #temporary until DE1385 is fix.
   rm -f ${DEPLOY_DIR}/Analytics-hook*.war
}

function deploy_individual() {
   COUNT=0
   LIST=""
   LISTS=`find portlets hooks webs -type d -depth 1`
   for APPS in ${LISTS}
   do
      COUNT=`expr $COUNT + 1`
      APP=`echo $APPS|cut -d '/' -f2`
      DATA[$COUNT]=$APPS
      LIST="$LIST $COUNT $APP off "
   done
   
   if [ -f /tmp/portal-install.${PID} ]; then
      rm -f /tmp/portal-install.${PID}
   fi
   dialog --backtitle "Portal deployment selection" --checklist 'Select Deployment Application(s)' 30 80 $COUNT $LIST 2>/tmp/portal-install.${PID}
   for APPS in `cat /tmp/portal-install.${PID}`
   do
      NUM=`echo $APPS|sed -e 's/"//g'`
      cd ${DATA[$NUM]}
      CLASSPATH=${LIFERAY_HOME}/lib/ecj.jar ant deploy
      RET=$?
      if [ $RET != 0 ];then
         echo "Failed compiling Portal hooks/portlets.  Exiting..."
         exit 1
      fi
      cd -
   done
   rm -f /tmp/portal-install.${PID}
}

function interactive_app_selection() {
   if [ -f /tmp/portal-install.${PID} ]; then
      rm -f /tmp/portal-install.${PID}
   fi
   dialog --backtitle "Portal deployment selection" --radiolist "Select Type of Deployment" 10 40 2 1 "Deploy all" on 2 "Deploy individual portal applications" off 2>/tmp/portal-install.${PID}
   NUM=`sed 's/"//g' /tmp/portal-install.${PID}`
   rm -f /tmp/portal-install.${PID}
   if [ "${NUM}" == "1" ]; then
      deploy_all
   elif [ "${NUM}" == "2" ]; then
      deploy_individual
   fi
}

function deploy_portal_apps() {
   if [ ${SKIP_DEPLOY} == 0 ]; then
      RM_PORTAL=0
      if [ ! -d ${PORTAL_TOMCAT}/webapps/portal ]; then
         cd ${PORTAL_TOMCAT}/webapps/
         unzip -qd ${PORTAL_TOMCAT}/webapps/portal portal.war
         RM_PORTAL=1
      fi
      #if [ -f ${LIFERAY_HOME}/build.properties ]; then
      #   rm -f ${LIFERAY_HOME}/build.properties
      #fi
      cd ${LIFERAY_HOME}
      if [ ${INTERACTIVE} == 0 ]; then
         deploy_all
      else
         interactive_app_selection
      fi
      if [ ${RM_PORTAL} == 1 ]; then
         rm -rf ${PORTAL_TOMCAT}/webapps/portal
      fi
   fi
   rm -rf ${OPT}/portal/
}

function update_json() {
   if [ ${UPDATE_JSON} == 1 ]; then
      echo "UPDATING JSON fixture files"
      grep 213ee853-8983-fe48-bf5e-fde3c3a6437b ${SLI_HOME}/acceptance-tests/test/data/application_fixture.json > /dev/null 2>&1
      JSON_DATA=$?
      if [ ${JSON_DATA} == 1 ]; then
         echo '{ "_id" : "213ee853-8983-fe48-bf5e-fde3c3a6437b", "type" : "application", "body" : { "authorized_ed_orgs" : ["IL-SUNSET", "IL", "IL-DAYBREAK", "15", "NC-KRYPTON", "GALACTICA", "CAPRICA", "PICON", "SAGITTARON", "VIRGON", "NY-Parker","NY-Dusk", "NY", "SC-OVERLORD", "KS-GREATVILLE", "KS-SMALLVILLE","KS-OVERLORD"], "version": "0.0", "image_url": "http://placekitten.com/150/150", "administration_url": "http://local.slidev.org:PORTAL_PORT/c/portal/login", "application_url":"http://local.slidev.org:PORTAL_PORT/c/portal/login", "client_secret" : "ghjZfyAXi7qwejklcxziuohiueqjknfdsip9cxzhiu13mnsX", "registration": {"status": "APPROVED", "request_date": 1330521193111, "approval_date": 1330521193111}, "redirect_uri" : "http://local.slidev.org:PORTAL_PORT/portal/c/portal/login", "description" : "Portal Local", "name" : "Portal Local", "is_admin": false, "authorized_for_all_edorgs": true, "allowed_for_all_edorgs": true, "created_by": "slcdeveloper", "installed": false, "client_id" : "lY83c5HmTPX", "behavior": "Full Window App", "vendor" : "SLC"}, "metaData" : { "updated" : { "$date" : 1330521193111 }, "created" : { "$date" : 1330521193111 }} }' |sed "s/PORTAL_PORT/${PORTAL_PORT}/g" >> ${SLI_HOME}/acceptance-tests/test/data/application_fixture.json
         echo '{ "_id" :{ "$binary" : "D0j+8nc6kW62GFLgZnwNnA==", "$type" : "03" }, "type" : "applicationAuthorization", "body" :{ "authId" : "IL-DAYBREAK", "authType" : "EDUCATION_ORGANIZATION", "appIds" : [ "78f71c9a-8e37-0f86-8560-7783379d96f7", "deb9a9d2-771d-40a1-bb9c-7f93b44e51df", "148eebc7-e320-4e35-b7c2-238e90dbd957", "1ad39ff1-65f8-4a16-8912-b49872f1ee96", "63e006bd-fc5f-450f-89c2-69bdfa979c43", "ee3e4e95-0c28-4110-b41b-b29cdec344e6", "25d21fdd-7e97-4aa4-aed0-6d6592a35bb2", "7a8a28cf-f9f2-4ea4-a238-d11b84a3dad2", "8a3def8c-016c-454a-a3ef-cf851e386d4e", "df91814a-ae2e-47f9-b642-742b8c26d65f", "25d21fdd-7e97-4aa4-79d0-6d6592a35bb2", "7a8a28cf-f9f2-4ea4-7938-d11b84a3dad2", "df91814a-ae2e-47f9-7942-742b8c26d65f", "7ae2a2f6-09dc-455d-b139-4d0da6189b52", "af264911-f638-4ec7-b792-69a2a2949b1e", "71ee2a92-788a-4dff-9d72-f1b6f0670aa7", "f4ad653b-2108-4e92-864c-e03722e5ef82", "b26e9c15-54d5-43d5-9d6f-52b8998a6047", "6387e94d-1912-4918-85e0-4f38014253cf", "213ee853-8983-4e40-bf5e-fde3c3a6437b", "52ab3769-1655-4542-971c-1fa02b1b368d", "1ef3990c-e0b5-4046-985c-fbcbab680bb9", "19cca28d-7357-4044-8df9-caad4b1c8ee4", "ee3e4e95-0c28-5114-b41b-b29cdec344e6", "2274ab86-6e21-ab75-9d6f-52b8998a6007", "eab130ba-6e5a-ab75-864c-e03722e523c2", "c09628da-9ea2-d969-85e0-4f3801425388", "c07a656a-6a2c-d9b1-85e0-4fe419425b3b", "1abf3940-84cc-11e1-b0c4-0800200c9a66", "c6251365-e571-482e-8f80-aaece6fd5136", "206e28d3-89a9-db4a-8f80-aaece6fda529", "213ee853-8983-fe48-bf5e-fde3c3a6437b" ] }, "metaData" : { "updated" :{ "$date" : 1332785105123 }, "created" :{ "$date" : 1332785105123 }} }' >> ${SLI_HOME}/acceptance-tests/test/data/applicationAuthorization_fixture.json
      fi
      if [ ${SIMPLE_IDP_INSTALL} != 0 ]; then
         mv ${SLI_HOME}/acceptance-tests/test/data/realm_fixture.json ${SLI_HOME}/acceptance-tests/test/data/.realm_fixture.json
         cat ${SLI_HOME}/acceptance-tests/test/data/.realm_fixture.json|sed -e "s/:8082/:${PORTAL_PORT}/g" > ${SLI_HOME}/acceptance-tests/test/data/realm_fixture.json
         rm -f ${SLI_HOME}/acceptance-tests/test/data/.realm_fixture.json
      fi
      #echo "Please run bundle exec rake realmInitNoPeople"
      cd ${SLI_HOME}/acceptance-tests
      bundle install
      bundle exec rake realmInit
      echo
   fi
}

function deploy_sli_applications() {
   if [ ${API_INSTALL} != 0 ]; then
      cp -f ${API_INSTALL} ${PORTAL_TOMCAT}/webapps
   fi
   if [ ${SIMPLE_IDP_INSTALL} != 0 ]; then
      cp -f ${SIMPLE_IDP_INSTALL} ${PORTAL_TOMCAT}/webapps
   fi
   if [ ${DASHBOARD_INSTALL} != 0 ]; then
      cp -f ${DASHBOARD_INSTALL} ${PORTAL_TOMCAT}/webapps
   fi
}

function start_tomcat() {
   FIRST_TIME=0
   if [ ! -d ${PORTAL_TOMCAT}/webapps/portal ]; then
      FIRST_TIME=1
   fi
   export CATALINA_HOME=${TOMCAT_HOME}
   export CATALINA_BASE=${PORTAL_TOMCAT}
   ${PORTAL_TOMCAT}/bin/catalina.sh start
   unset CATALINA_HOME
   unset CATALINA_BASE
   if [ ${FIRST_TIME} == 1 ]; then
      sleep 1
      COUNT=0
      echo "Please wait while Tomcat is deploying applications...."
      tail -f ${PORTAL_TOMCAT}/logs/catalina.out | while read -t 30 line
      do
         COUNT=`expr ${COUNT} + 1`
         echo -en "\033[2JPlease wait while Tomcat is deploying applications....${COUNT}"
         if echo $line |grep "Hook for wsrp-portlet is available for use"; then
            clear
            echo "Restarting Tomcat..."
            sleep 10
            ${PORTAL_TOMCAT}/bin/stop.sh
            sleep 10
            ${PORTAL_TOMCAT}/bin/start.sh
            break
         fi
      done
   fi
   deploy_sli_applications
}
   
function starting_tomcat() {
   TOMCAT=`ps aux |grep "${OPT}/tomcat"|grep -v jetty|grep -v tomcat`
   if [ -z "${TOMCAT}" ]; then
      FIRST_TIME=0
      if [ ! -d ${PORTAL_TOMCAT}/webapps/portal ]; then
         FIRST_TIME=1
      fi
      dialog --title "Starting Portal Tomcat?"  --backtitle "Starting Tomcat"  --yesno "Start Tomcat?" 8 80
      YES_NO=$?
      case $YES_NO in
         0) start_tomcat;;
         1) if [ $FIRST_TIME == 1 ]; then echo "Please start and stop Tomcat twice";fi;;
      esac
   fi
}

function select_apps_install() {
   if [ ${MODULES} == 1 ]; then
      dialog --backtitle "Deployment selection" --checklist "Choose Applications to deploy in the same Tomcat as Portal" 30 80 3 1 "API" off 2 "Simple IDP" off 3 "Dashboard" off 2>/tmp/portal-install.${PID}
      for APPS in `cat /tmp/portal-install.${PID}`
      do
         NUM=`echo $APPS|sed -e 's/"//g'`
         if [ "${NUM}" == "1" ]; then
            API_INSTALL=1
         elif [ "${NUM}" == "2" ]; then
            SIMPLE_IDP_INSTALL=1
         elif [ "${NUM}" == "3" ]; then
            DASHBOARD_INSTALL=1
         fi
      done
      rm -f /tmp/portal-install.${PID}
   fi
}






####################
## Main functinon ##
####################
EXECUTE_ALL=0
PURGE_OPT=0
INTERACTIVE=0
DATABASE_INIT=0
UPDATE_JSON=0
SKIP_DEPLOY=0
API_INSTALL=0
MODULES=0
SIMPLE_IDP_INSTALL=0
DASHBOARD_INSTALL=0

while getopts aipdjse option
do
   case  "$option" in
      a)   EXECUTE_ALL=1;;
      i)   INTERACTIVE=1;;
      p)   PURGE_OPT=1;;
      d)   DATABASE_INIT=1;;
      j)   UPDATE_JSON=1;;
      s)   SKIP_DEPLOY=1;;
      e)   MODULES=1;;
      [?])   echo "-a Fresh Install (equivalent of -p -d -j)"
             echo "-i (interactive mode to setup Tomcat and Portal)"
             echo "-p (purge opt directory before install)"
             echo "-d (drop and create loption database)"
             echo "-j (update JSON fixture file then update mongo)"
             echo "-s (skip deploy portal applications to /opt/deploy)"
             echo "-e (Install API/Simple IDP/Dashboard)"
             echo "useful link https://thesli.onconfluence.com/display/sli/Checkout+and+Build+Portal"
           exit 1;;
   esac
done

if [ ${EXECUTE_ALL} == 1 ]; then
   PURGE_OPT=1
   DATABASE_INIT=1
   UPDATE_JSON=1
fi

select_apps_install
check_dependancy
set_env
check_SLI_HOME
purge_opt
check_opt
database_init
setup_tomcat
set_portal_env
deploy_portal_apps
starting_tomcat
update_json

echo "#####################"
echo "IF you need to setup Tomcat for Eclipse"
echo "Append following line to Eclipse Tomcat 'General Information'->'Open launch configuration'->'Arguments' tab->'VM arguments:'"
echo "Please make sure you select 'Use custom location (does not modify Tomcat installation)' and set '${OPT}/tomcat' for 'Server path:' and set 'webapps' for 'Deploy path:' before saving it"
echo "https://thesli.onconfluence.com/display/sli/Checkout+and+Build+Portal and refer 'Option 2. Script Driven Install'"
if [ ${DATABASE_INIT} == 1 ]; then
   echo "Your lportal database has been newly created.  This is very important that Tomcat server needs to start and stop \"TWICE\" before you login to portal"
fi
echo "############# BEGIN ###########"
echo "-Dorg.apache.catalina.loader.WebappClassLoader.ENABLE_CLEAR_REFERENCES=false -Xmx1024m -XX:+CMSClassUnloadingEnabled -XX:+CMSPermGenSweepingEnabled -XX:MaxPermSize=512m -Dsli.encryption.keyStore=${ENCRYPTION_DIR}/ciKeyStore.jks -Dsli.encryption.properties=${ENCRYPTION_DIR}/ciEncryption.properties -Dsli.trust.certificates=${ENCRYPTION_DIR}/trustedCertificates -Dsli.conf=${PORTAL_TOMCAT}/conf/sli.properties -Dliferay.home=${OPT}"
echo "############# END #############"
echo "Please check ${PORTAL_TOMCAT}/logs/catalina.out"
echo "Useful hints and commands:"
echo " Start Tomcat                       : ${PORTAL_TOMCAT}/bin/start.sh"
echo " Start Tomcat with JPDA (debug mode): ${PORTAL_TOMCAT}/bin/debug-start.sh"
echo " Stop  Tomcat                       : ${PORTAL_TOMCAT}/bin/stop.sh"
echo " Location of Tomcat env settings    : ${PORTAL_TOMCAT}/bin/setenv.sh"
echo " Location of Tomcat log             : ${PORTAL_TOMCAT}/logs/catalina.out"
echo " Location of Tomcat Web Apps Dir    : ${PORTAL_TOMCAT}/webapps"
echo " Uninstall this Portal              : rm -rf ${OPT}"
exit

