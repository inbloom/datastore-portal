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
   TOMCAT_VERSION=7.0.29
   TOMCAT_HOME=${OPT}/apache-tomcat-${TOMCAT_VERSION}
   USER=`whoami`
   CLIENT_ID="lY83c5HmTPX"
   CLIENT_SECRET="ghjZfyAXi7qwejklcxziuohiueqjknfdsip9cxzhiu13mnsX"
   API="http://local.slidev.org:8080/"
   PORTAL_PORT="7000"
   if [ -f ~/.portal-local-install.env ]; then
      . ~/.portal-local-install.env
   fi
   if [ ${INTERACTIVE} == 1 ]; then
      dialog --title "liferay git repo" --backtitle "Portal Local Install: 1 of 10" --nocancel --inputbox "Enter Tomcat Portal Base directory" 8 80 ${OPT} 2>/tmp/portal-install.${PID}
      OPT=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}

      dialog --title "liferay git repo" --backtitle "Portal Local Install: 2 of 10" --nocancel --inputbox "Enter location of liferay git repo directory" 8 80 ${LIFERAY_HOME} 2>/tmp/portal-install.${PID}
      LIFERAY_HOME=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}
   
      dialog --title "sli git repo" --backtitle "Portal Local Install: 3 of 10" --nocancel --inputbox "Enter location of portal git repo directory" 8 80 ${SLI_HOME} 2>/tmp/portal-install.${PID}
      SLI_HOME=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}

      dialog --title "Encryption directory" --backtitle "Portal Local Install: 4 of 10" --nocancel --inputbox "Enter ciEncryption directory to install" 8 80 ${ENCRYPTION_DIR} 2>/tmp/portal-install.${PID}
      ENCRYPTION_DIR=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}
   
      dialog --title "TOMCAT version" --backtitle "Portal Local Install: 5 of 10" --nocancel --inputbox "Enter Tomcat version you want to install" 8 80 ${TOMCAT_VERSION} 2>/tmp/portal-install.${PID}
      TOMCAT_VERSION=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}
   
      dialog --title "client id" --backtitle "Portal Local Install: 6 of 10" --nocancel --inputbox "Enter your Portal client id for Portal" 8 80 ${CLIENT_ID} 2>/tmp/portal-install.${PID}
      CLIENT_ID=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}
   
      dialog --title "client secret" --backtitle "Portal Local Install: 7 of 10" --nocancel --inputbox "Enter your Portal client secret for Portal" 8 80 ${CLIENT_SECRET} 2>/tmp/portal-install.${PID}
      CLIENT_SECRET=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}
   

      dialog --title "Portal Server Port" --backtitle "Portal Local Install: 9 of 10" --nocancel --inputbox "Enter Portal Server Listening Port" 8 80 ${PORTAL_PORT} 2>/tmp/portal-install.${PID}
      PORTAL_PORT=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}

      if [ ${API_INSTALL} != 0 ]; then
         API="http://local.slidev.org:${PORTAL_PORT}/"
      else
         API="http://local.slidev.org:8080/"
      fi
      dialog --title "API Server" --backtitle "Portal Local Install: 9 of 10" --nocancel --inputbox "Enter your API Server" 8 80 ${API} 2>/tmp/portal-install.${PID}
      API=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}

      dialog --title "Portal Hot Deployment Directory" --backtitle "Portal Local Install: 10 of 10" --nocancel --inputbox "Enter Portal Hot Deployment Directory" 8 80 ${DEPLOY_DIR} 2>/tmp/portal-install.${PID}
      DEPLOY_DIR=`cat /tmp/portal-install.${PID}`
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
#shell commands to prepare portal environment
   if [ ! -d ${OPT} ]; then
      mkdir ${OPT}
      RET=$?
      if [ ${RET} != 0 ]; then
         echo "Fail to create ${OPT} directory."
         echo "exiting out..."
         exit 1
      fi
   fi
}

function setup_tomcat() {
   mkdir -p ${PORTAL_TOMCAT}/{webapps,logs,bin} ${DEPLOY_DIR} ${OPT}/logs
   if [ ! -d ${PORTAL_TOMCAT}/conf ]; then
      NUM=`grep --binary-files=text -n "# END OF SCRIPT #" $0|grep -v cut|cut -d':' -f1`
      NUM=`expr $NUM + 1`
      tail -n+${NUM} $0 > ${PORTAL_TOMCAT}/tomcat-conf.tar.gz
      tar -C ${PORTAL_TOMCAT} -zxf ${PORTAL_TOMCAT}/tomcat-conf.tar.gz
      rm -f ${PORTAL_TOMCAT}/tomcat-conf.tar.gz
   fi
#   find ${PORTAL_TOMCAT}/webapps -type d -depth 1|grep -v portal |xargs rm -rf
   if [ ! -d ${TOMCAT_HOME} ]; then
      if [ -f ~/apache-tomcat-${TOMCAT_VERSION}.tar.gz ]; then
         cp ~/apache-tomcat-${TOMCAT_VERSION}.tar.gz ${OPT}/apache-tomcat.tar.gz
      else
         wget -O ${OPT}/apache-tomcat.tar.gz http://apache.mirrors.hoobly.com/tomcat/tomcat-7/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
         RET=$?
         if [ ${RET} != 0 ]; then
            echo "Failed to doanload apache-tomcat.  Exiting out..."
            exit 1
         fi
      fi
      tar -C ${OPT} -zxf ${OPT}/apache-tomcat.tar.gz
      rm -f ${OPT}/apache-tomcat.tar.gz
      if [ -f ${PORTAL_TOMCAT}/conf/server.xml.template ]; then
         sed -e "s/{PORTAL_PORT}/${PORTAL_PORT}/g" ${PORTAL_TOMCAT}/conf/server.xml.template > ${PORTAL_TOMCAT}/conf/server.xml
         rm -f ${PORTAL_TOMCAT}/conf/server.xml.template
      fi
      ln -sf ${TOMCAT_HOME}/bin/catalina.sh ${PORTAL_TOMCAT}/bin/catalina.sh
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
      if [ -f ~/portal.war ]; then
         cp ~/portal.war ${PORTAL_TOMCAT}/webapps/portal.war
      else
         wget -O ${PORTAL_TOMCAT}/webapps/portal.war http://downloads.sourceforge.net/project/lportal/Liferay%20Portal/6.1.0%20GA1/liferay-portal-6.1.0-ce-ga1-20120106155615760.war
         RET=$?
         if [ ${RET} != 0 ]; then
            echo "Failed to doanload Liferay.  Exiting out..."
            exit 1
         fi
      fi
   else
      echo "################################"
      echo "${PORTAL_TOMCAT}/webapps/portal.war  exists"
      echo "Skipping downloading ${PORTAL_TOMCAT}/webapps/portal.war "
      echo "################################"
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
   dialog --backtitle "Portal deployment selection" --radiolist "Select Type of Deployment" 10 40 2 1 "Deploy all" on 2 "Deploy individuals" off 2>/tmp/portal-install.${PID}
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
      bundle exec rake realmInitNoPeople
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
         if  echo $line |grep "Hook for wsrp-portlet is available for use"; then
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
      dialog --title "Starting Portal Tomcat?"  --backtitle "Starting Tomcat"  --yesno "Start Portal Tomcat?" 8 80
      YES_NO=$?
      case $YES_NO in
         0) start_tomcat;;
         1) if [ $FIRST_TIME == 1 ]; then echo "Please start and stop Tomcat twice";fi;;
      esac
   fi
}

function select_apps_install() {
   if [ ${MODULES} == 1 ]; then
      dialog --backtitle "Deployment selection" --checklist "Choose Applications to deploy with Portal Tomcat" 30 80 3 1 "API" off 2 "Simple IDP" off 3 "Dashboard" off 2>/tmp/portal-install.${PID}
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
cp /tmp/portal-install.${PID} /tmp/portal.api
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

while getopts aipdjs o
do
   case  "$o" in
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
echo "Usefuly hints and commands:"
echo " Start Tomcat                       : ${PORTAL_TOMCAT}/bin/start.sh"
echo " Start Tomcat with JPDA (debug mode): ${PORTAL_TOMCAT}/bin/debug-start.sh"
echo " Stop  Tomcat                       : ${PORTAL_TOMCAT}/bin/stop.sh"
echo " Location of Tomcat env settings    : ${PORTAL_TOMCAT}/bin/setenv.sh"
echo " Location of Tomcat log             : ${PORTAL_TOMCAT}/logs/catalina.out"
echo " Location of Tomcat Web Apps Dir    : ${PORTAL_TOMCAT}/webapps"
exit




















#### DO NOT DELETE LINES BELOW #####
#### IT CONTAINS BINARY FILES (TOMCAT CONFIGURATIONS) #####
#### END OF SCRIPT #####
� ��P �}is�ȑ�|֯�9�giL����#98:<��"g�^��D5P��P@r8b���̬�n(2[Ԯ��G�nTeVUVV^��A�~�"����&�o6����>z����=~���www�p�����=:8�=�{���~��6�N�)U!r@�H��H/o:�2�����n47��=v�0x��{�d�p��G��w�c�l�������=�N���ݻw��ys����?�����s	o�I������'G���Sx��߼@N��>~�������A�}��������?ڿ蘯�(L.�=�w�����]��a���o��g���-�����{��87�=������C}����'Xat���G�������`���vw����x�����m����p�Ў��p��;��5<���]����/�_��ã�;��E�%��J�4
�9����þ��������"�u��������?\��{w��kxh�od�/�j���7��������K��ho�g��uϿ����qބ�L��"u��t�3��?�鰘�\:��2	H�w���~��G�;i"�4w�4��� �"e�E�GG�r)c��s�S)��w��N^�r�a$� T�@���;*ơr�i~��+!��&�E���H�A�� n6��Ѹp�i"s53�9Ñ���pQ�_�
��[Z�a4Fl&b���A(��.vu��2�n=��3�ֱ�;IZ8�����̗Y�^q�"�ecd5����N�A!�}A#q�a�5����3.�����t:�a��h�����w��\�56�9��R0Y��0�)��V� �����"���f;m;ʬ>v�\�ŤU(�Л/�����:>uNN���OON���_O�~|�����Ǐ���N^�:�?:/޿{yrv��|z������'�^n;���Y�� ��S��)U( ��g�I?�>-�b$�Q:�y�t��<.��&
� zR�����+��%mN�0��I�;�7x���9�̒�դ�F�r(ʨp�,��T�%	��Sg ĉȇ5�� C��~���x[�TJ .��Aզ�Y�r�^��4�9>I��I���Gs�G�H�XL�W��0��t�+��ڭ��DW��N%к3���x��S3�9Aru��#����Ph�Ȉ�<�=�n��Q�=l�K$��H�}"��q4{���$x��� 8=�=|�����G�?g����GOww��@~Q8��NpK$������[�t/_9^}|{rzJ[ϲG`����81s��s1�=Z; �@� ��-�ק�������'0�������c�EoԇWQ�wE�-�{��S
"�5���\2j.`G�[=0;�%a�6�!M��t���5��x��o?�r�ۏ�߾B|z`�y�5�4"�>7ʍ'��_��9yw|m��$zd��q���.c��8a�B�R�n흋|3�F�h�����	��.-�S��:`��2
d�!f�� �Ob�(�����^f #Q%)8hJRZ4�s��E3��L����bfW�_:�a꽆~3Z��l5)�����`2����J]�Nϲ��)�)����v�r8a�`���B{zV@�
g��F� �5s�n�ʗ߭�:ʇ�ǒ���-5.� ���B]��e�G�x	�ޤhM�F �� ��_��K;*�0��~��mvHjYuv�A�ɼ�v �Z� n=�ɾg\ӛt�"��w� FP�*m��I���J�/ڏ2��(2�O��%!������Wt��vv���:>S��3�����)�@b���'��I���(�����}�qg"���Nt~ ����c�yⴺ����i�PM����D~�k���y��'g�BPo�ds�~��Ɋ�>[e2�E�<��"��#<���`&���f�N�Ճm5�C��U6Vj�__����{��d�,������A?��ti�eE��J:лT˰Y!������B*(Ʃ2ĉV-#�
?O��Q¥��h��R�(���; �
��VC��7����h�"}��.h�Y���2�N��\��mczJ�����4��'�
[��>2�U�N����Vٌ���܁�a!?�9����~���_���|b4�%nB�аtl�B,3�@��Q8��F�u.�7�J���5��	�qN��>�5E�P^X,Y/<Cx���׏�y����� ���h:t�?��ᅃG�iZ�������0�#��[�H`�7�G'�����{����ݰt<�u �!��&��<�)juQ���S紲.��!�t�<���
1��С�D[�oЃ���u�������b|�^�X^�K��?��w���.��#	�?�F^�G7ꆎ9�1U�v����s��pi#^g��zM�7'��>o���3�u��|��d��ۿ�p�\wV���#�s���~�]|��׷o�J }�01(G�#�e�[3���t�A5�3R��O,n�.^�����dg8I>����MhT>�`C�!h��r����{2z2�B��+�K���溥U�Z��� ����\[?�W�.G�4���))N���7'oO�~���ׯ_}��])#Oo���W_�����o�����5�~{��P��AS��L�pܵ�rz�����o��>�����o/޿��݋W\��;G��N{�t�4�
���'�-F��ח���9>��S����g�?��6�Ǩ�/@p/�q��N7��������UNS���P[����H�I�R5]�}���0QҺ�,K���+��
B�Eb�A[�ntT����d�q��xѽ��Y����ք+��휆��O_�w���n����Ph�ѕ�լ�[tZb���X�vb���*�M�G� �j�)fj6�=q�M�0}���g����-�@���w�Hh��������R�~�|�*�(z۶c��������u�� 
�+�F��o�+�����o;;�ܿc��;�W��V��d7�L���p8h@��q�H�P�&����H��ޠ4�i\�*���47�Ͳ�_Y�[�����`/�8Jq�A8	�Rtu�h_��u�8T�q�ʸ�p����V�E�j�*v&~T�H���y8�z�H6g�� 
�^KdAѨp`&&�A���s��4!*��hY��DFS���EX���-h�&�LP�cs�߽?>&Z��*N�\�-t�BbQx�#/����K����Q����pOJM^��G��o��74L����v�T^<G�H$s���><<�GI���֟,;��KR!�Q:y�xw����nʖ�D;��3��Ϫ���&j�̛���cO-1�ͧ;Dw��6��4�+Ƹ������ ;i뫿�r�����ps����w���������������,��b������_{����?w�����Ϸ׿�e���-��o��~}�s���k���Z�cq��p������׷|w��e���m�/��70.\���6�1.L��+R�����'Tfu�;LJ2�~(&�H$bq%KS�Q"8�HW_��`(�a��c�8�F�R�+j��.)������m#[4�x����~R�¶w�����T�x���)�/�yZ��W����t�Jg���	��Y����e��E��6��Б�H�_'vP#�mna ��ҊZ$s?n��Ž�^�;�N���"6ժ/ �'Ňy�q�W�@1Vf��[i�x��0�-}if�Ǯ��3u�`
�8-����R�E �
ima��T�d�(�Bo 6�������Pl{(`QZ
B���@�pD��d�DrX8B9`N۴������:t�p�w�k�P͑�A�_����[�4�z�&`�Fح�{��6Cm4���quC$���c=͆�V=R���S� ɱ	d �����`==�gk#Y�Ɯ�@���ݮ�R���껩P����Qak�!��@���X]2P	y.o�J��*I��Ċ(���H&;�hc����T67E������n�IG�a������1�C�
�d����lP\Mo0j���&T<hIb���5M	a�E}Ef���c��ٛ��oY�@��"LA�Ν�G�B�U�i���K�kH��3N$�J`�Cu��o��w5���,�7?���jт��"w���2!���#G��f�N��R�d?����T���a��?�.�l�^��^�u�������h����2��<WY����R��{��E������P-���}���џ��4����y��]A6i^�����&�Y���Յʂy��p�q���t���W�|�s�f���
�~۳p��V�`\?UK]� ��6+:�"����Z����(�NA��R'87헃$|@��-n�2������>H�I�n��Ϩ�.}��{-w\a�~1KӨz�\��s$�4	��En�>�33�
���IE��/,���3�0o�:п�}�yę'�Y�ǥA�p����S���T4\`3�9��Ĉ_����Q�7H��J��P(��K]�B����,O'a`6|���)|�.|���1ùe(��c |�a�-f�:'u��aV�JFx��}���>濩����@Կ�PZe�7Q����o�_�C +A0�;��~���۷:�/B���#�T0q�uW��a$H�(P��}J�:(����g�����r��w_��8���շV�gE^�B~��>����1��c�#�=$�m��i�Y���;���?���`������xtt�w�����������G��6���������G�����������?â;�b׳�=o��@6�S����g���[~~��߹�=��W�0�
_���+tx|��5}�&����Zpx
O���)tX<�N���u��0���F�j�+�YX�>�5y�ɤ�y�W�:~�N��Z��#1]�W�R���(`�����U��B�����8?יRu4@�����g�!��ڊ$j�e;��D^40�\���j���E϶����||��F_;j�
��-�7ڒ�x�b�Mi�BH#4�02~�Zh#L=��P�s?��`���&ƫ��_����K�#_�(�AS��~�S-�m���gI�7�o�����@M�9����ã��G:�o�.��y�!��wO������������]�x:�������ѣ�;��K<w����'�_[����cgK߷���R��B�h�w�^�<����Iz͌�_���*�JTn�-&���#z#��If����	R_�h{���E�#-Cc��u�g[�wwn9U��g[�?�|�����Pj��Չ�ɵ�����{��t�c����p̪������X����r�ϫ؃˰�|պF���v� 2�Vn�39��7��P�S!u�As��gY9��<D�K�,�֧5�K�5��q:-�����T#��#������2�@�H�ؙ%q9dN�R�]1�o�2��{^]�\�%Xo ��^B�o�1�d���(��Rd�e�b�(:�D��~��ZM�F@�٫U�J�le� t�+� m��;JqW�n��:��p#�\R���)��M�H�u��`�Љ�����G)��b���@��Qժ*A�0��580+E�I~^��A��
WUb��BCA�$ׯ��irib�Z7�r����Vö@Bl�@]�P�E�R��:�$�s�ToX< ��� �\��w"���n��6�;�����2ۜ��ARA��$��j(78K��&�UE��d��T�;[����� 1�:��.5���)���9�:5eA����j�ye:2�hr�{���4���y�]�n��%3�D�,�da��S�����p�i�Y���Ʋoa�lx�~�L*���t�r��%UQ�{�2�M�ص�ot๪c2O��<�p�L��������i{)7�.�Q�-j��������;��siw�<�IB?xB�Gv��Նձ�h�R�� ,�p���y{��(6R�ǻ�wۼj���Vx�2-A��G]lˈ<���������na>�"�M�l���˦�s�2���A��k�Xg"�R�r�>W�s�gE�kht1)��d�ǻk�]~��X~q�8���z���t-���A5��=��]Ǳ�tz�j9�8UA�3	�C����ǃі�8�j�1�⥊y�X��BX�Eg�Ϡ���Z��1A��dIr��1'+3��PDȟp#/���/i�㢎����Rч��7���ի�Kh��yk���u��V�4����.�#MN�8Z�nrA��z�\��q.�N=�%�ÛG�aՇC
Z��i���Z�\,d�\e��&W���!F�c����YA�k3��q��\�}��6+H3�����M¼��J���`uW��R�{ղ�bJ�
`� :��'�G�ݲ�����A&��ܡ4���fΖN����l�b��Ƴ-�kok�9��.k�^Ѓ�.0�I��LGW���Ɖ	�f�q�U���h*L�}E$�>��y��FO�ij�A	0iH1-��P�5�Fэ�T���
?�N	�3?3ͪ�a+O�2v8�ߗE-�gFq�f�J���æ�4��d����~.�|��¿hI�E�/yM���׀����f�M�f�<Z�Pm���m.L.r�����6T�v�:�?��hDd�5�����cx�m4o��O��5�'��K��zNc"�rE۪G�nUǩ���zyA1�g��`��g[�̰�
[�RfQ:7G�ي��Y&x����ʼ��^{EOI;9G���!O�����qWd1ŋ�+	�[S���$Hдw�츾N�vi�5GQ�K��:����(-��{bR�x�P��)Ăinp+�Vֱ��2�V�O��c�yV_�iM���Z��M:2~�:cR�Hm-@�~��>r~_:�/���L�?�>��:�W��(h��&���M�ߠ'��rH?{Ŭ0FB�8���jz�I��(�u~���ߟi��r���J��y��R�9�v��uw��>������;�b�g���lDa����tp�{�w��?���������?��]���w�����w����Yk:e���{ [i�����~���������_������}��q~h�w!M=lؙ��r&��;*C�y�H֋���:��M�Յ��ը\l-�]X�}H47�ĵƭK4o�$=�5��M��!��K �OTk�ZHS� ,��Nc_-�!E����8�*A�����[�4��9�r�1�J�� ��B��6��Sm�5�= ��`a)�.�A�a)�S�y��=7^�2ϑ!i�]���\���"�
\���3?��Y���S����~��b��t�
����{�����Fդ<x�{d����s�a���=�k/��#l�R��������_�Y��̕^��?>:ؿ������>����·��Fv��R�;|����hi�����2ϝ�w��������k�x���<�y`;%J�w�B�"�e��vঢ়D�wR�7��TX���6=�%v���׷oN1\D�U�h�§C"0bUbvs�?��v�;�mכ�`kyY�m�vw�:2���܍�n�G�]kU��&"*����ND�w��xjߞ��ܻbU�{�Zd�yt�:����ۼ��z���U��vcc=9�0��uy5���X�<���v���nf�Z�Juu]���^�_s2�Kֻ�i���4�������_�:��^�4Qw�]���J�[��������AeuV�J%z
���:���v~(C ���9չٜE�\����=����uU��e�66t_b�c��_s='h�)���uHi��ks���g��38)�Ta�M�v�}�����B�M������9M��Vݚ@%!��tV�'��k��c����&' ;Q�O%�5��fQ�~Q�vt�ߥ^�w#�%�Ўt�5-|�Ei�1ALl/���,&�����?�����+#V/ԟ���Ȕba/6s���PQ�������x�$+��N�A�����~�%b�2��m���br�p��w�~���;\��ϩf��:a�K�lFg=�$��^�ď�5`N��Z�g"�Ɵa���_���'˛
/ʚn�B�3��X$�^�W��]E��$ 1-*9w���{�� �aO�e#���}G���7��iY��{��Um��~����wb�D��'FǫJ�m��𖾡I���Q�\�2P��� ��|����+:�,Ǜ�s���q`����o���׸G��э��E:�$���V��*���=)��c����I�	�<V/���ދ�B���Š�����c��b��&��`�����z�W�(��h���(�kX�t��>���E�����FB wrcot=`��Ai��X2�d�7�����q쵟�~aҸk5�3�����M���n\�9���*��HȞ�y���**^��J:�z�%#U{��$U�3�0�WU����A���M�5��}�m�`{�.Ls�C�Q��!5��RY�Fd�C/�b-��jE�I9%��|��sճ��k/\�/nt=�q��6�C󴰗��\��Y�v��t�w��w���ꯍ�~�4,��Kw�*;$ʕV��� ͗�G���鳌đ��i�O8�x�@�L��e���c�O����_��ǘ�熯~���v�e
��>���Tu��iѣn���'.YI_��]�֠}���fݫt�?߭���v�A��b=1 ������CLFXf����Y��\��e���]�/HU�/�[�!��V��Db���"	Uܢ8����ظ�����8g���U�|�eݩ(��?,,xU9�����w޹ʶ�4�-�w�ݭ�����U����fO4��N�D�a8����ɥY���h����;�FT����'�g���� �eD�g����B����,��*2���A"��}4�ꢖ�%G�J)�b#����t�:�!��P����H0 �Tnv}�%�C��~��!�r>��n����o�x+�nõ|�z���RQ���+�^���/�-rB^g�ZQ5����P��D��� *�`<�ʬ�MBi�/�H��H:K��4nX�5L���J����8��-��>�~���K��|�rE��NKw��Ur�>GMu}\{_d�N����[|�E5s&m�/oa��yG���_�3���K�����<x��DU����Ф�V���d�n��?�?0��x�^K.@�� �s�$���`@l�[SunQ�/����V��IU�'\-�xM޺���VLMίM�����1瑨�GU��e�
���-J�V�+�~�O{��8;u�x�(N� �E�����Ç��t��"�0�,�(�s���x_�����BD@�
���Y>������.՗�b
����m�#�� ����p5�e�S˓�'��e�Pꤙ>YN
m<��DT��(c:Ā���1d�/eO�D�~��.��/!��^+OS��g;�1*Mʰ��"����U����}�l�jr�ǀ.�Z�a����2 b�bmO����<O����J� Er� [����DZ���1�Ŝ��R%�:"��a���@���K����1�@�R�~#4���ph��ԝ_�0l6bd��3��p��M��f�)��� ��P������J�C�4�oWz�򆋂��Ɣ��e�h%��6k����w�^�E~��b�����{���ֺ�=�V,�0�q���'I�(K106O'uF
�D��^���!UvG�\u�^c��O;"G39	/�U�ׅW�/)�@9	��,z��j�E�����tߟ��i���9�ƍ ����#O�|���ᮻ{x����{���p�ꉻ��x����'O^>9��>�Y>��0�w9���<���F,Wi���ظOċsq��V����j��e�q��B�l���c��Tү:'U�
M����ï��>��0И"J���1���!�ot��\<lEl,�[�
�3����v��uO�c
?��l8t
STȥ���t[�ߺ�V���lx�fo(t�'�U�\�/�}���� l-��K��zыX��}2�!2#�`�~�]�i�l\��`��,�I�6�������j21c�d�׀��B����ɜȍl�A*u�c�k�̟�^�74<�x!����RK��ߺ�}<I�����us���*;-�$p�/ ��8-��l��F|���0 s��-$ѪZ�������'�����2��ݿ�ٖ��ߺ煠T�z�k�ɊW����gZ&���-(�J����6gh�L���<X�="�PW��NI"mY-�9���j��R-`��8����o�3V离FD�ϗXa)H������|�"0���>y��	�9�<wM+�~U�߂�;X$��:���Td��;�Ό�����M|M>�>�Ǖ�A��u�b�g���YH�j e���(�)��{�sp�#�P�����q	*�5!��ҷ��c�� llr�7��a�3���$����9YP�ֈ��6b�{�W�\���|���41��a��+���Zn�F�� ���(i����f�o�AV��#ה��(M�9m�����7|s����'�d���+��xgY:�� hX������~��?��p�u��{L`3��̋�k�E�o�舧��5�5�մ3��U�@Mb	SC;��b��`�X�/�v`���m'���	^�(I`�E�jA���ItX,�^?�زV�|}U���$ϝ	'3�� �N�8��j÷�L��S�t=�^���5򺥸��m���5X0��޾1vn��E���D�.�E��нP��^�O_�2�~tj��ؾ�h�VK�}�����E�v}��׊��(��W�dӔ[�梚QR \�j��>���}F�t��{���W_��p�ǿ�ma�½t�la8��چa�B[Pi�]�-�,v5�&�]���f}�]��W�i����p���=fl�#:c�ґ$��A�3���]u{b�i����Z1�Z���P��ڤ��g㶗$�Ћ�)nqy5�����R[�hDe[�����>|=��5nO�����;�y�<�������S���8ݵ��]�mt��S�#�x�DU�1������UXM��I���z	�0ԞxC
]{sD�L���R��H���S�2a�%
�q��o���Yi�6�V/�GGG��/9Dz�à�vk$D�ծyA�I���.:�~��_N\!�ׂ,>�]��w["Tc�v�']i4�����hd�v��3�ͪ�rg�L��w��Mi���֎?
�A��|�U�%�ڴ&�N2'\VnfX/���̔Q�b�S qY��|־2��Jz�ٹBX¯��+��rmX� �Ҟ�gMH��c$J����i�,�1lF�h^���GJ������ j��q�����S�߲�q�Vb��t�g��lX+�Gr���2J�C���-�dFe���t�ӷ��ɼ3��f�[��� W����%�Ui��kR���V�������9h�7�Ň����[t���skۤ'}�#G��4J��e�J@�Jr?5L�
��[�8y��̵������Xj2h�jDI�rmU2�[���}�10Ұv$c�{���*E� ^u�
��MX���G�u�Z5sF��0����rB)X4ǥn@隖�D0n��PhrVȬ��-���T�o�4�W�'m]_I�X���z���ʩr'�A:A�������+z��[�-Q��B��$-�32����$?���kj`gJ6r9��T	��r6�?(J���J�6+)�z��H�@���'z��)4�3��Sc��Y��e��+�B�G����|����&���/�}����*�[5�ٿ��/�n0�zX��a��Ǯ�]e�h�L��~8w�J�l�o?���|��j�b�1�&k2>��$�ϪmEc���>�ۨ�w�����E%��b����R���OϪ��K�6fGa�@/*��ĩ��N�֗���vw}�s5I=ݾ$uڝ�B��5����#����o�T�{�"��*U/Oc��O2�P&�$��HeUC��WA��Q!CR��iM�:�[V{��?�_�ȝn��ڂ�0�M5T��0�V��z���_Bj�_�j[�JN�u��/���I����ux��u8Ʋ���Ï=��h���&�{���w[�ܡ�c��_��͍0�S%kl{S8b��gx1�u��������Jr 41�Z����_��v=��OE�+�!ei��-uQ�>�rV�'��Ab�ui׍"�ѩ��|y�{�ZG�6�j2˨��M�MRݎ���U�W�ګ�rS��Rv��]��cyڶ��jT�1]�����Ȫ��1ƌ��Ri����2�z�T��z��;��wf���xV��p����������d��]D�]D�M랻��+�{��օP%��Xj��}�����e����w���y��KT���eE��e�Xkj��V��CL����5����Z���v�e�]��J�c����B���0���Y��9^_�Z���O�.�j�9/Zy��ӧ���u)Y,��uW�q�i�WRRM���S"���џo�$��
�/�^W�җ�"�eZO�u��A-å�����`���j{d���K�Փ����+����{s��/�`��R��*��d�_�,�uV��\
g�>�\�c�N��L'Y��V$�z9�%8��V�v���[����F�7n�*�}L��ď�L*��Z����r�����r����5��Zn�A�|�n�'������;���W�%*��8�L���ҢT�B��k��V!v#q �?|��n�|��{2�9e�>Ь?P&��>۬��}�����{�L81�C��8ͱ�(z[ذ�;�(�0E��*���C�~ٰP��B��n,��#ԩ���4��h���г�(
P�d^��`��[8Ks�[f2>+��`�FZ��/7����zN��O)�	���8�ll!�<�������<jDb��l̅�В+A����0���p{�P�|�J��k��<��υFh�!SUh	����X�|P�K#�`og��RP��n�ܚăt =h�6~хأ������?~�vbX�"L5�A �ڄZDG£�<($3D����q�.�ǟy��o����	���Ή��j˄��&������vn��$�a1`���e'��2�����وAu2mm7�˯�ض�d��?Do2�L�b6��0�i�QL�tr��L���Eju^������;����	5�Zӄ	�3QKE8�F���Ҝ&2a�UfB�lւI�`�؃��ޛ?�*��	֓�oe���gh��?=M�r�l�o֙�~�֊��Y����Q�W��Y�Q'L�X�k/CG��cE�Z9��ē�4�`�b`w" ?�)�!����B+�d�&<�+"5F+j��J(@2��8����ߩ8��V�\�h��ހ̀<w:����a�J/j���k{���?&�_��UL	��>������Ӓ�uBz�d�{)F:҅	fjm�b�y,.0��		ky4��$�SE���G=0�b�������ً6��n���{�4�~��5�����]�NUИB�4oO�ֆ ?*e����|��>�@"4`��YAbnv��ܡ�l�Gir���X���R�Ck�b3h��4����A���4좡�X�Њ?
�|�v�~�EY����z]�<���7X��"�@٦�<h|�3Ʒԩ�Zl�g�1�M����~��$h����2ab���l��\�N}f��e
e����n�c�&���L�D�hXI_$�0aS��S+����X���b�VV/B!`
F>Y��%�9�:_,c��@[�KɅ��$q'�$�Ŕ�OZ3?L��(\8H+1�Bi�h�Q��S���"ȱ��[�`nm��-^c����e,.�]`"$��趴47?���탲%sw*D����t�N���Q0F��5k�8���(g;�#+aA+ub��V�0PV�:�:����*��:-|w!s�A*خ; B��~�LD�(�����j��!d�Mm#��S"��B�F�BlxX�w�����TũO!�lHt+�͓&�S���`6���y�<�s��<��Q��*�؍eR�!Թ�Sz�hj��c��1!`��[���^�/��|��u<c8��u�>��/�:
c��Y�E���:�"u�� �`\VR�V#s6�g�������'�/X5�|�i�V15�y��<許�&T\�	|ew�)��Oً�To���߭���� ޲�AuƗ�O� Z���UR�l\v3�:ņ~���J��j�|v�46�!��@tr�8dd�H�@0�a����%�����B��x����@L�L�(�jù$����}֜��OX禱���ZF�d��<j̃��L�B�T��ٰ���Ϊu�q����j#0��BC��q��.S}vR"w�v����>����s�����Kʇ���Ml;@�*Fu8�w*��i��O�l���� Y�V6`Fb�X�M,��E{!�Al�61��_��� O�λX1&|��	�@<h[bP/~��������՗f2�+.�B��p����^Th��~�6��LּY\{!+����>1��B2��{d�[�W�B/`c��u�/4aL9�=/�kᛍvg��zW��(L��
��(��9��6ozP�*�^�� vή8r�	��V��
6ٿP��Q7{c�!�v��&Ğ��+�ڸ<����5�*m�35�Nϲ��&\���i�Eia�����v$�j��Kg=o���hg����b�e��-�kS�����ǻ���ZR�\x��|�<:|t=DtC>D�]sFtC&Db+=�gM+�$�D�(��-��@�869�Kw9?D�+�%p����4�"�cIFV2�D��b�	��C��>�R*c˭�3
�2�6>.��p"r�apI���Va�������̬L���eVZ�]�>c*e��K�H�9%�'1vgl]�"S�1�-��,����6T�%�.�3���MpᙕfD�3�fCQ�o��o�K[N1ź�C�:D~ΰ�J4(و��$$x�/��^`����W���-�^������I�*���5�v��P� �X�m��on*�{Ԏ��:����"Q&�U;	��n�� #1O�B�+}����D�չ)G\��pdyۃ�p3�\��2�0�r���[�ܹ����z7�S����ʭ8sg|y��Q߂��M&����l*�Ⱥ&D�9��<j̈́G�&b�h"���#��]UF��8:H�f\�#��e�%�W��]�����&�a�C�z�(��� �v:_6#�f=obӰ3.6-��]��|o*�8ʄF�zK6�¾ �0*gX��c�	1,n�gX&�rq?�!|Ş|g8�\��ן^�k����l�`��:�;�:����sN�{�o-�d�Elz�i���at0\�ytp�As^��ߥ�i:���}}5���UPD�]��h��bP�B�U����:�^�+�U�e=b�5��w �"��8X��	��uBi@e$�����5E�VW{4����ɘ�pԷ8È-[�Ȯ�nc� &$EX�]��Pw*���R*���J��Yg�x�Ȭ���H:g��;�t�� ��|kI�~.����GlGcn�Hn��;-W�1���"?�-�z0�#��3L5��X�dF�]��M[�����&CxNsE�D� �,1�~��?�Ɠ�3d� `�d��YVp�Egu��̷���G{��$�M.���q�h�˱z�TX[b�	#;|k�n�޶hǘ-�`�ŷ�]~�i���ԩq6�'���͘0���Qcr���vq�5\�����:��C@rv�u�c���h��������/d"b)Dƶ	��6��/sb���"c�'n����'���k4&i�foO���V�%ܷ�C&�����aw��|?�SF3'���8̨���e�S�pP�
qE����E60	���*�
^�r8����:{��d���aw�:=Xz��Ӥ�������H�s�+"��\�\�d�k�~�	���	MR���"�5��iU�+/d+>�nc�]�@?j̓��=֥}@�߱��B��bؾ�=M���eU����Ԋ~ҋ9r�����C��Y�R��@ZX�s�ȅ�J��T��ӝ���C+^a0�.���x�w���q1���øP�3�E0&mskN�2KU��f���$^e,��۠aa�GeU�b��ګ�a�|��.5gBĺ0{�����P{�T�x�����?7�Z�f��y��s6j=��Mb=CW��N�HS�H�e�#�*-s6��yh_�E��Y�Ǚ{͹��yb[��� ���6��4�9��T��&Ȭ��m �"�/��z+0;���]�gl<.� �`2�ˏӺ4-����;ކ]W;Wi����b�P���ˏ���qM�@�0��|́�,�MK4��a��J�%[e��������9� K���(��y1�x�U��l��.{�m����/ka��5w)�%+ِȬ��,�J�%�k�z3x�+��D�je\��"�iZ�m���`ZԤ�@Zs%�1O��h��\L��	Q���G,����Bc��y�&<���E���1c�P��ė^ �E�rY!����ynr�}a�k��^1����E"���{��Σ�����2&�:��}��e!��<ݚsmz cW�������k\!q�_BD��޶ΎG�i��_�T���p�^n���f�w��ʥV<���x&m5�A��s�N��>!�����0J�R�o�r������Pc�g�����2�$�\w��Ϋ)�G���7�����w��Î�}�H�~�bS����>��qt;�	&�1@�+j�[���g�1�q�{ҹ�Ň�.�A�5�3�줬EJ'�5�y�Fk�3ŢK�|f��;i(�������E`�����r,��qH?���:<[Mr�-�VLeγ�~��E��$c$e;I��$��A�{� JS��Z2��]h��y@�V�!_��|ƫ�om|�&L�����.��&<��Ҡ�>��e��yk}�W3Vn��9��3<�:�`}�D���VZ'6@C�!'��=���q`=��sA.�c<��3Q�B8�ádK$��SvZ�t:*A�eԏ�R�P}�<-$|b$>�	&=�p�鮾8P�1[F>|���m�_|�Y��hs�| �/�.L�r���`��l�I��Z���a����@8�^@�1�T�_[��ǝ�\#Yxy�d�ΰj胈��tIg��ks�H����XY�_�X��K3C�kfH{��>��Q��v�ݪN��С� ϺU;v�t7���[snd���Ⱥ�h�0{ftc4�f�`����'�/o��n�x����i6.ϗy�>ٓ7����"�F��\j�)d�{c���;����v�����*DɜS��N��� *e�K/.�"��E3��f`XL�k6\���X�Y�2Va��ol �I_�v�V�Y�_u�c� =�)a����L��pȭN�X�\��e�Nh��`엨��ˠ|K�*��)�Od�	��;RZ����J<Ӓ�O�l���Bl�l�"2���Q�-����H�4�rlX_��؟���=.'RzА-�D��[T��y����J�![q6����r�y�ٺ�8������<��I�/�hf�^g�@	l�ؑ�l�I�3�Y��E�0c��[�L�9��� I/B�鶞���T�N˅X���dƄ�bFr�Ap��ZM���@z���L��D>[��NS��A1�6�!�ZWomƠ�$�΄��T��Ją:�A�^v�IN$��$�
T�"	��aNU˸t�$�>5j\��fM���ֈL������>{b�S�{}IZ��NE��uY�/��B�^*�\q��Rau�o��:�\h��S@�b&|i�-��7 �;�u�g2y��%��u^�A4J:�{	~օ�ayB� %0P�C(�����%�#n��\��ͯ��`�Z��okf�o�de����s9R.KN�UJ��^�|^��pk�P�*�E����.W�q:[y�~+�(�S�k���Q���Mj�����E�/�}L���$�1�R�/5��U�>n�A- ��P�u����F�#� ��K���tS�H�0;���}�KI����d$�2�k	�l!P�[aW̅~j%Pm��Ō@w��p9Ȕ�_�"��"�:���ä���5ih(��3��d�қ
�x((?�%J���HP�lb=7�Q�tg�T�]��.�#�7Q��k5L��Mo�s�R��̌�����"�4��޾q�T�(�2L]%��ӂM�ِ��R��[g�Ш��C�������ԉ��p��LqfW�[���~R`:��0�%��^ݖ	��]dj�dB�������R�f���*Y��Y��0r����Y�� �Gn��%f��������n��V���+��Opnp]X�Y1#��
G�(ʜm6���!�� w;�6�����XM+��5��S��0
d~ĆF�F���ei^�A$�AX�lI�3ʯl7��e�y_n�̿��D���[Gw�3�Zq���H���p��4-f!۝��O��qS���1�U�uU�B�+r#��>3Z�2;Wl�����N��.�gCK1pX�_��J ��j��2ΑW讯�r�r1g<vGV�Cg�?�J�Ԍ	�c^we���`���ȗ?o��8�,�k�I�+�#�>���Ao����"nݎ����=e 䆾;�������e�5�O�u4jɄ���I�d���٘Pԭ}��ʧ�y�ڇr��G�b�ZeIϲ��"H�CO$�g^ғ��g��\#Sb-a�U홰�V.�>d)�ש˳�ë<8Qy*$��������~G�٬\m�_�q�#�ٳ�e�*� L65��}j��<26y�;=�
��#��<ml�e�t��0�j�N7F+j�;� �_K�n�R����0[e�n��ɺ�8���..mcL�ܾ)E�s)��("v�C�ˈ�}j�KU��<�ض���*�b�K��<�7E�����"��v�څ+cf&%��l�m2ua���0"fE���Ljz؎ͬ[Z'�&Q��lѫ�]N���1l�L�S��27,X��f�w**y s�"�{��ţ�L����p)&&L>��J:��I���i��b�Z�Q;�!�\��O����"�n �B�\�tJ�I���;L��P7 �������������}.V�ij��m���A�9T���S�*_��3[g�jDـw���n�	\?�i��|�yw c�=��n|ٺ���T�&Z�Y�dQ9��kt�]|�Ψ
�u]/̢�NB|ߣ�<�H���A��H3`�i6!�,��m�2�9�X��3��&�*P��c���0�u�M��E/�:)��vA�f�z�wG\Q�*g�8�#+!�=nY9����룓�`6$�|����M�5��T�e�ϻ�/O���y�b"b��lD�p�t�R>�237�#��U�\�x�Z�:�L(�a�>�d����쉵k:JER�5eBB]#�!���m�z����f�&6\�X%�W��?E�R���̭V&���uB_���ݮ�*`n7�u�vy�&0h�4�3�C̘��8��<�J\7�,u9�y5��������Cc�Z��~�K��޸4{�['�T�X%��|kAU����K��l�ʷ;�I�� �`�_�|+.�@Beir��M,z�Y#Q_VS��Ք]VU�j\�<�u%�Wؕ��C�B�lڥ
�M�-T���{t҈�1'?��L�lq�:`���-Ҙ�!��XIk314�Eȶ�-��X�K���g!�Rr�+��)���CW�u�x+�]P�
E~�����l�T�Ђ-�&w�IX��a��y�]w4X�"�y��q�8P�1��y��
�pg�ч.cY5�6��V�\zԖ���+z_wGQ:`�l��o�d�1��'�r´��9s�j	b��-h��B5����z��w������\]�f��u�=�����@&�b�x��;{�
�� >���*����X�����b�Y��a�&J�vGd��q��U�������W�X�[�Y�B���pB��@��η��^����ǆ��B�p%"6>bo.)d�$��ͫ�4q�W�n̗>C��Uh�>q���C;�7��=B�.%�*��u )�c T�f^M�sɋZ�������:*����ܱʮZò�0�7-V��Ůr�;,Q�f�O�O��ƄɁ�E��3j�G
�����s��s��&we{1{*B��B6�*����Rn%ۙ� �2b1U�کq���������h�k�	��&�R��7��Z�V"���"1E��ˆ����L<��sg�Q���Ǡ�^s~t��u
�"[x���JRM�q���ȅFc�"Wg�Sa�S@]�"��%V&n��;�XK>���en(C{U�	�;�A-��`3(/��7���&����P*{-thL�,�R�fn݈[ٯjÄ���Fd�Òِ�?�&lQ�%���"�Z�z�[��S˴�A�K�Q��Z`�8�/�b"�!��=�D�B$������\f7.ٰ��LɆ�uvӥ�7bvSɒ{s�A��x>��8ńG?;�ծB�"i��q���g!���@L��!fq������q8�:����Mv+�Q��s�{_��®�����N!�?��������L�X�Hx�Q����4���n,�5�h��'ؘ��>�v�(�;@�g��]�H~����ea[wf��F<�Ǳu,F\�_cɖ�w�1x�M�o����L�aډ�,�������m��Eݎ;o-��(OSP!�4���9��<���������=2����"c���2���V�?�0a��{���P"�d�y��P��P�⋁�d&r �����d�(�cU86�Oa�~� �~a�E��Y��\�*��]�vͧL{��Ɛ��c�d��t��(g2`Mg�nQS�Z2�������8�(�q�O1��@Z���H\�(�rhM�Є��]����^��Y���C��9�%a1��!��pH�K�aF��;ud�<�����/�;���������	��:Cj~�8� egࢹDX�2�S�K�ĢB }�q�7*�}���QN��~z:�k�\dc��f�y�xQ�������I��z��4tm�b���Y�V���tr�%Њ����(
޳}��s3PN&�g�l�-J����#����_�����3�������o���&�M���������| X�>	�2Q���aȖ}P�/O��|f+P~E�q�s1�E�y8��~�&T�Ԯ~�	׽���/�����u�����b�7�����ķ�uԄ�}� ��A��Q��' ����'�}���pNR˰��xY&y��Y'��o� ���$��Z����ʝ�Ww�����: �|�)�bG��2X˂Г4��U�X��׆��~�r�;NE�qS��W����B��M��e{~�ί�b�T��!,��:y�2b���K��Td�n�3+k��á�#�S�g����vg�S�}i���ƅA`����@z�e�M6�@]��Cy���~�M���V��4Fl���#+����5���6Z�ݾq�嵟ڥ�7й���]�B��Bܸ�-��o�8������g������9�X�H�Fz��e}���w3�D=m���{��m���N��h����N�Ɩ��3�{ZZ�d�~�/��r�����@��<�Q���"٧|�:���e�� ��������z.C�&Pg�~��_�Ol�_w��� �&�/oP�*�0i|�S�TY
}[Տ��p�QX�q�ce>ಯM�݉M�?�b���������F�q>'�A��y�2b.L�+�\F�G�h\�����.�'�pi!���, M�FL����U�1˽�S��9�f�m|��L��p`'�"s�phQ��
�)x扏��8����R� H����t|���'h���BF&vW`�}ι�K����i�\��iΉ��n�6��Zr!a�?�����v�Ƽ�y�>U�6����	'��Ah��t�"�| -ș/�F����؄A�l�r���0�>5מ6�cR`��:N:Mj,e��������EK�m1��S*˥���Ά�}�Bn2+���Ub����}�Y��d�+4�qy~Ëiy����ٮ�(�]U��blg���*W��	����e���,�1�����'T.�b���ZU<��͏�^s?M��B�w��(��0Q�Ŏ,�9��������Ċ�]�6|�|i�L?�Q$<hʉH����鶷�Xw��O�i��4(��>g�N��?�1�y"�9�C~.��7�>ht+Y@�Ŷ��S�\��q��?닄���g�Nx��v�Z��1~�E��%ߨs���[��c�c�D��a�R`/:�/)2�ٚ�y)���
�W�K�uI�M����?3�d:n,G8�*�����{(s�)|_�̘o;�X:��%}"Y8Q�^(��Hq�lkj0�@�-g�0�D��с��v¡cjko#D����d�X74�i �tK�A!�U�{ΕO������N=�\6�X3L	�˜>������<]��}%W{ w�ʜh�����)�w?�TE�����ˢ�y�{��V�j:Ϥ��4!|)C����5�3X)���?:f�s�X��z���+L�Һ ��o��N�D[�
�`��5���D��������I���.�7�/�w4[�]�:2X��]n;*u�Q�.Z��QH �y5��z�\��k�q�?h^*Y�^ch}W;�l�̘;��U�`D�ߞ�g�i�O뇮�m^?�Zm����3h��o�����v$���Q���b����w���q�
����>t�yD��������{t������{x�w���ߏv�qf�;Jo�����M�RFW���Í榞��N��w����>~������c��g{��<~�߉��ý�}���9}��ɛ��(;y�p�������{���a�>�{�����@��3J<ۿw�C�{�Y������Q������q���������wt�����˞����=w��s��=w��s��=w��s��=w��s��=w��s��=w��s��=w��s��=w��s��=w��s���|�?MU�   
