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
‹ ¥áP í}isÜÈ‘è|Ö¯€9ëgiL€§¨Ã#98:<œÕ"gÆ^ïÆD5Pİ—P@r8bÿÄûïŸ¾Ì¬èn(2[Ô®‰°GìnTeVUVV^•ùAÌ~”"ùŸ&Ão6òìîî>zøĞùæ=~†§úwwwÿpÏÙÛßİ=:8Ú=Ú{èìî~ãÌ6ƒNû)U!r@¥H•¸H/o:–2º¢Ÿö n47õì=vÊ0x¶¿{ôdïp÷ñ“G÷öw¿cùlïàğàñ£ƒÃı=üN´¾Ûİ»wğØysòÃñÇ?üòÊós	o¤IıÖşááã'G÷öSxãÍß¼@Ní>~¼·»ÿøŞşAõ}˜¤Ïöìïí?Ú¿è˜¯“(L.=¹wÛô¿üÁ]¿³aÕşÿoøûgÿ÷ÿ-ïüĞŞÿ{ûß87Œ=ÿâûŸÖÿC}¼…€'Xatñÿ½G´ş‡»‡ö`ıövwïøÿ—xºùÿÁã‡mş¸ûğpïĞ³¬pöƒ;Îş5<´ÿ«]¿¡ƒ /ÿ_ìÿÃ£ƒ;şÿE%şïJğ²4
ı9˜£ÃÃ¾üÖÿÑáÁÿÿ"ÏuøÿŞÑîÁÿ?\áÿ{wüÿkxhÿod×/jÿÿ÷7ëøÿş£‡‡»Kûÿhoïg—‘uÏ¿øşßÙqŞ„¾L”œ"uŠ±t3áÃ?§é°˜Š\:¯Ó2	H¹wîŸ¾~àÀG™;i"4wâ4—÷  ¤"eßEºGGŒr)c™ÊsœS)©ûwïÏN^¼r†a$ Tº@Ÿ†Å;*Æ¡r¦i~á¡+!‚‘&ğE¬ÉåHäA˜Œ n6ÏÃÑ¸pÒi"s53»9Ã‘œ¾®pQº_‚
ãü[Zša4Fl&bÛùúA(ûŞ.vußÙ2¿n=ø“3‡Ö±˜;IZ8¥’®åÌ—Y¨^q…"ñecd5˜¿™NÒA!à}A#qÒaó5àºĞÛâ3.ŠìéÎÎt:õaì¥ùh§àÎ˜Öw§¯\56ú9‰¤R0YŸÊ0‡)Ì‘V¾ ®‘˜âÒ"ÑâÓf;m;Ê¬>vÓ\¥Å¤U(ÂĞ›/À´‰ÄÙ:>uNN·œOON·±“_OÎ~|ÿó™óëñÇÇïÎN^:ï?:/Ş¿{yrvòş|zí¿û›óï'ï^n;¦àÈY–ã Í§S´¶)U( ¡àg•I?†>-•b$Q:‘y‚t’É<.«ì&
ã° zR«ãòîá+ÏÚ%mNë¸0¿„IŸ;ô7xâ¸ÎÒ9Ì’Õ¤†Fãr(Ê¨p”,€TÕ%	‘öSg Ä‰È‡5º„ CÅş~úåíx[âTJ .¨œAÕ¦¤YÙr«^·œ4Ã9>IêıIô­ùGs¦G¹H°XLØWøë0¢tŠ+ÒØÚ­ÅÑDWµ„N%Ğº3•ƒŠx±ÑS3ß9Aru„ï#–ŞıPhê—Èˆœ<…=ÀnğQÍ=léK$˜ÎHâŸ}"Âq4{Ãÿí$xº²Ğ 8=Ú=|ììïîí»»Gğ?gïñÓÃGOwwÿØ@~Q8ÿÆNpK$ìœşíôìÕ[Øt/_9^}|{rzJ[Ï²G`­ª½Ì81sœ©s1ş=Z; Ğ@ş àÍ-¤×§ÿöüÑ§±ü'0­Á»åüãcEoÔ‡WQ›wE‹-ñ§{ÿüS
"Š5ÈïÔ\2j.`Gã[=0;Ï%a6…!M’ŞtĞÿÛ5„£x¾óo?ÿrüÛïß¾B|z`íy·5¥4"û>7Ê'‰è_Ÿ¿9yw|m²ï$zdqšĞÀ.cÍô8a²B´R®ní‹|3ˆFéh„ìêøÃ	¾ı.-äSçÄ:`Üó2
dÿ!fî ñObŒ(ï´£¡Ğù^f #Q%)8hJRZ4§sÛéšE3³„L‹çıÓbfWÛ_:­aê½†~3Z¿él5)óßşà`2‘à÷ÿJ]ıNÏ²—å)À)àğİÚv¶r8a¶`•®‡B{zV@¢
g‡ÇFĞ ˆ5sšnÔÊ—ß­¿:Ê‡ŞÇ’¼•œ-5.‹ ôˆÓôB]ıeíG²x	¥Ş¤hM»F Á½ ¹ø_»ŸK;*‹0òªÅ~£ÿmvHjYuvñAÓÉ¼Ùv ’Zÿ n=èÉ¾g\Ó›tÜ"œëwÔ FP±*m‹˜I…ğÏJæ/Ú2‚Æ(2¯Oşò%!şüáÃÇWt”ıvvòöÕ:>Sóù3¢Òú )©@bõ‘ '¿ÌI²İÖ(ƒ¨Ü¬›}âqg"‘éÓNt~ ¬Ìñ€c¿yâ´º‡ó¥Ùi´PM¤Æ›¨D~Ûk¾şÊyµº'g”BPo–dsç~™àÉŠò>[e2ÍE¶<€…"¢µ#<¯…‡`&òÁÓf‹NşÕƒm5ûCœåU6Vjå‡__ıà¼{İêdõ,À¹¦ñ•ÇA?ù¨tiÍeE™ÙJ:Ğ»TË°Y!‘å…ÇÌ¶B*(Æ©2Ä‰V-#Ï
?O¾QÂ¥÷h‘åR«(…À; ò
çıVCÛë7ø‰åˆˆh¥"}™ö.hüY• ã2ÛNèÁ\¥à¥mczJ–¨¾Ç4„á'Æ
[¡Ş>2¨UñN©­¨±VÙŒš¬‘Üâa!?¼9¸œ½ì~©äë_ÙóÚ|b4%nB¤Ğ°tlÃB,3š@˜¸Q8‘ÈFˆu.É7†J‚°Á5ÈÆ	qN•¶>˜5E»P^X,Y/<Cxš¢ ×•yûúéİË Üô¶h:tÃ?½üá…ƒGÇiZæ¾üƒ¶€™æ¸0±#óî[”H`‹7ŞG'‘†’€¾{Ïş´Çİ°t<Úu è!ûî&Ì<õ)juQÍÂûSç´².˜¤!‰tÚ<íÀ¦
1¿öĞ¡ùD[£oĞƒÈıñu›·’ëö’‰b|ó^ğX^ÛKµŠ?ıò–wõè×.€é#	®?ğF^™G7ê†9–1UævâéñÆsÖîpi#^gâŒzM§7'–å>oÂ„ª™Ë3¼u‹¹|¾ÏdòÓÛ¿®p…\wV£ßã#sõ§ã¿~¨]|…ó×·oàJ }‚01(G¶#šeµ[3€ëütúA5å3RäàOÂ†,n .^ˆ‘´¨æ‡dg8I>è¼†ò©MhT>€`C†!h Ôr“  ¥{2z2çB¡Ò+£KÈå†ıæº¥UçZ¢·„ Â‡í„“ûâ\[?³W¶.Gè‡4˜“Í))N€½7'oOÎ~ûáç×¯_}¼Ş])#OoïÅûW_¼úíìıoÿñêãû5ô~{ä×P’ÆAS¢ôLÜpÜµ¾rzöñäÅÙo§¯>şòæÕÙo/Ş¿ãøİ‹W\ÃÕ;G¿N{ï”tç4¬
ü»ã·'ï–-Fùú×—¿¾9>ıñ·“S÷‡ãÇgï?®ã6½Ç¨/@p/ÖqŸŠN7Åêõòƒ«‘üUNSÿâ–µP[õéù­H IŞR5]·}ÌåÜ0QÒºÊ,Kó¢òØ+©Ñ
B•EbîA[×ntT¬¶«dqªÙxÑ½‰×YåºÓ·Ö„+Ÿùíœ†í·O_éwÛïünéí¶±¢šPh¯Ñ•±Õ¬ë[tZb´ÂXÜvbİÍÂ*ÃMÌGÔÂ „j´)fj6Ü=q©MÁ0}ÃöëgŸ»£Š-ª@ƒ¡w¾Hh’Ë‘€õ‚ĞR„~‰|Å*è(zÛ¶c™¶ˆî¶‰ñÀÁuè² 
+ÆF°ÁoŒ+ƒ¢üš½o;;ÆÜ¿c¬Ø;ÛW‹ÆV½õd7ôLäÑËp8h@õÍqàH²P²&—íÊH®ÍŞ 4åi\…*® Ğ47£Í²†_YÈ[èéÈÁº`/Ñ8Jq†A8	ƒRtu±h_ğuº8T¶qıÊ¸ápÂï‘ÎVåEÙjÎ*v&~TâH…¶Šy8‘zèH6gĞÓ 
Õ^KdAÑ¨p`&&®A×úÍs©²4!*€ÜhYÉëDFSÄÊÏEXŠšì¡-h˜&¤LP”csÒß½?>&ZÓî–*N”\é-t¾BbQx¡#/ª¨¸³KÂğŒœQùÿÚÁpOJM^óÅG«™oû–74Lª§¶ævãT^<G­H$s”ü><<ØGIÕÌÿÖŸ,;ıÎKR!¼Q:yúxw¥£şÉnÊ–öD;”ğš3µ¼Ïª™»·&jó´Ì›„¼ØcO-1ÁÍ§;Dwİï6»–4Ì+Æ¸²‡©û½ö ;ië«¿äréı¯ÚÚpsÖ÷¿öwöŞİÿúÏºÿõğîş××ù,İÿbÜõ‹çêû_{û‡«÷?w÷ŞİÿúÏ·×¿¾eºıõ-Ëå¯oÙî~}ËsõëÛkŞüúZâcqï›pÜúú–áÒ×·|w¾¾e¹òõmç/œ¾70.\®‰6€1.L²¨+Rœ¾…ší'Tfuì;LJ2‚~(&ÈH$bq%KS‰Q"8¦HW_¢ø`(³a•ıcÑ8ÖFâR¯+jß.)«¦‘ûëm#[4ÃxàŒ…‚~RÖÂ¶wÏüèé¶ÏT™xÛëÌ)­/ÓyZÈÖWÆ±½êtúJgø¥†	±ÛY°¥´›eœƒEØÙ6ğ’ÅĞ‘ãH¢_'vP#·mna ë¶ÒŠZ$s?n™ÅÅ½Ÿ^ş;ÌNÔÚñ"6Õª/ é•'Å‡yıqğW’@1VfÄ™[iŞx™È0È-}if—Ç®‡î¡3uÎ`
Õ8-£€âÍRëE ²
ima³T…dö(æ Bo 6ñåş›˜ÈêPl{(`QZ
B›¸ê@¥pDìîdèDrX8B9`NÛ´¿¼­ü¹ï:tp…w«k˜PÍ‘šAÂ_¯ŒûÔ[Ã4İzê&`˜FØ­À{¡š6Cm4ÙùquC$Âîøc=Í†±V=R¦“ÖSƒ É±	d òóéÜô`==Ògk#Y×ÆœÒ@¶×Åİ®ıR¿ßÅê»©PÛçşçQakõ!ÂÅ@ÿˆĞX]2P	y.o‰JÖÅ*I˜“ÄŠ(ô¸şH&;’hc‘ßøğT67E Ñ¯¥˜n¶IGĞa€ïÏßàû1ôC’
Îd­ôîé™lP\Mo0jãÑò&T<hIb„¥û5M	aÒE}Ef˜‹écÛÎÙ›—¦oYø@…ƒ"LAšÎGè¬ÂˆBÅU¥iÑêàK¨kHŒ’3N$·J`ğCu„Şoş‚w5êïê,õ7?‘ä°ÒjÑ‚¨¥"wù§Ó2!ù§ş#Gäâ«fĞN¨÷R‹d?‰ü”æ—T¥§aöì?ïµ.±l¯^Şİ^ºuºıŸ÷ —Ôh®Èô·2ªÿ<WYı·¹»RşÏ{õéEàÌ¤Èöã¥P-ƒåÑ}Á‹€ÑŸ®Œ4ş¹ûyÉà]A6i^Ÿ¤×ø&øY»‹ó¤Õ…Ê‚yû…pïqâÊÖté¯ÔÊWÃ|å«s±fÚÈ
~Û³pÏÜVÆ`\?UK]À ªù6+:"ÁÁ«ïZŞù«(ÒNAõİR'87í—ƒ$|@´ı-n¨2Ãı¿Üêı>HóIÑn¦íÏ¨ú.}£¯{-w\aÜ~1KÓ¨zë\‘ùs$ó4	ãÔEn“>Ë33ğ©
¢ÃóªIEŠğ/,èú¤3¿0oÁ:Ğ¿ã}ıyÄ™'ÀYÌÇ¥A°pà¥×é¼úS¯ è¿T4\`3“9¨­Äˆ_ÌâèƒQÕ7Hã‰JôßP(¨K]¹B™œûò·,O'a`6|¿¨÷)|Î.|µ·§1Ã¹e(·½c |³aõ-f–:'uêçaV¼JFxã¿}‘æò¸Â”>æ¿© š¯ƒ@Ô¿ÀPZeõ7Q±Ùüáo‹_èC +ÂA0Æ;’À~ƒßèÛ·:ü/B½Äé#ùT0q±uWø—a$H‘(Pøò…”}Jú:(¡¾–g•×âÀƒrèéw_Ê8˜ÃÖÕ·VƒgE^‚B~Õë>¤¯“³1èÚc#=$³müïiøYÒÛÿ;üËş?íæö`§ğÁ°Ïÿxtt¸wçÿûÏòÿİùÿ¾ÎGûÿ6±ëÏÕş¿İı‡GËù’ÿÿÎÿ·ùçû?Ã¢;æb×³­=oÃÊ@6€SïÙÖÏg¯İÇ[~~ïûß¹î=‡ÃWè0ù
_¡Ãæ+tx|…Î5}…&½€…«Zpx
O¡Ãç)tX<…N—§ĞuŸã–0·•šF¿j‰+ëYX‹>¬5yìÉ¤üy®W‘:~ÙNéÊZ£ #1]ÊWØR¿ÿ«(`¥ƒæ—çU€€B–şıÎò8?×™Ru4@†Š–¿ºg’!‘ƒÚŠ$j²e;ú©D^40Ñ\ş¨®j õEÏ¶¶œı¾||“§F_;jİ
ŸÒ-Ş7Ú’¢xâb‘Mi«BH#4ö02~ÁZh#L=¬íPús?’Ö`ş‹ˆ&Æ«ö_çÿšàKÊ#_Ô(šASíá~¿S-ñmóûågIş7öo ¯°§@M¿9ŒŞòÿÃ£ƒ£G:şoï.ÿûy®!ÿãwOÛÉÿîäÿ¯ó¡ı¿‘]¿x:âÿöÚûïèÑ£ƒ;ùÿK<wòÿü'ÿ_[ş×ÙcgKß·ßÂñRšÜBÉhˆwµ^è<í¨´IzÍŒÃ_•¤Ø*¨JTnÛ-&ñ›#z#“ñ¥IfäÜÂÙ	R_íh{ÅÔÇEİ#-Ccèàuğg[wwn9U¾Óg[§?ş|öòı¯ï¶Pj¥¡Õ‰éÉµ‹¾Ğ€Õ{ÊÀt¾c¾é§ë´pÌª¡‘¢µ”Xøˆ‰ïr‘Ï«ØƒË°™|ÕºFæôôv¬ 2ÉVnä39Îò7•ÒPã¶S!u‚AsğögY9«³<DªK«,Ö§5ÁKñ5ŞÙq:-Òõˆ÷ÁT#°Š#†œ ºäÄ2Æ@’HŠØ™%q9dNÀR·]1ôo‡2¦¡{^]“\¾%Xo ”^B­o—1úd•÷—(ˆ¨RdÕe‹b…(:Dğİ~—£ZM£F@§Ù«UñJ½le“ të—+¼ mİí;JqWn¡š:¯àp#¦\R¡ê)†ĞMæH¥u¬Î`¾Ğ‰«¤±øúG)¢˜b”˜²@„îQÕª*A¬0 Ÿ580+EI~^¢AÉÀ
WUb‚‘BCA×$×¯áàiribüZ7Úr´¡ùÓVÃ¶@Bl´@]P³EÁRëáµ:Ò$³sÉToX< Äãñ ®\ÿ¸w"±ü„n…ã6±;ú¨¤§Î2ÛœØöARA¹ô$©új(78Kúœ&€UE¶İdÍúTÁ;[±™ù 1Û:©‡.5’š°)üÙ¢9£:5eAÕÁ˜µj¸ye:2¸hrĞ{û´Ğ4¤ïÕy¢]ïnÕû%3İD,üda †Sà‹²şöp«iØYìĞãÆ²oaülxš~‘L*ˆ€ÖtÂr È%UQÅ{û2„M²Øµ¸otà¹ªcÂ‹2OÖ‹<ÅpüL„óãÙÙ§Æåi{)7.÷Qª-jÿ‡‚§ª–º;şéƒsiwâ<«IB?xBßGv áƒÕ†Õ±¼hñR¯· ,àp¦ììy{‹Æ(6R›Ç»wÛ¼jñÎÂVxÆ2-AÊÙG]lËˆ<ÿøğşãÙñ›ßğŸna>­"…Mül«‚‡Ë¦ïsĞ2ÒááAµÚkÖXg"ÑR“rƒ>WÉsgEñkht1)ú©dµÇ»kñ]~ıÒX~qÍ8›öÊzÀõÒt-ô°€A5Šê=Û]Ç±ştzúj9×8UAÑ3	”CÑÉ÷–ÇƒÑ–8ÙjÖ1¹â¥Šy´X²èBXƒEg¤Ï µ…®Z«¬1Aë†dIr²…1'+3½ÂPDÈŸp#/ÖùÏ/i¬ã¢éÂ‡‚RÑ‡³7§—˜Õ«…Khûîyk÷Òî“uû¨V4ÇıÀ.Û#MN˜8Z¾nrAÊ×zÿ\—†qî£¶.ªN=Ğ%ÀÃ›G²aÕ‡C
Z†éi…İôZŸ\,d£\e©‘&WÑü³!Fâ’c©¯ÍÔYAêk3¾q“é\ğ}Üò6+H3ş©‚ÁMÂ¼ÀûJ˜á×`uW±R‡{Õ²ÿbJÑ
`¶ :„Î'ñGØİ²™µ‘ø¸A&¡æÜ¡4çÃ÷fÎ–Nêêâıl‹bßé­Æ³-økok‰9˜Î.k¼^ĞƒÁ.0ÛI–„LGWâ¦®Æ‰	–fªqÈU“¦ûh*LÎ}E$ó>…¹y°ÚFO´ijÎA	0iH1- çPƒ5àFÑ»T‹±ğ
?óN	¡3?3Íªó¤±a+O˜2v8†ß—E-¬gFqÚfò‘Jº¨ÈÃ¦Ô4ÍÕd¸úÂä°~.Õ|ÃÖÂ¿hIèE/yM”¶×€Œ˜½î«fôMñºfÌ<ZèPm·ğm.L.rî´àÇÉÜ6T¨vû:¹?¨ÀhDd„5òŒÀÛÂßcx÷m4o÷‚O‘Â5Ô'˜£Kæé‘zNc"í¦rEÛªGınUÇ©‰åûzyA1Äg€ñ`ö“g[ÆÌ°…
[úRfQ:7GŠÙŠ½Y&xßï×ãÊ¼òü^{EOI;9GÉûÄ!O§ÉÀ×ÔqWd1Å‹+	ó[S¹Ìó–$HĞ´w¬ì¸¾NÙviî5GQ’Kû®:°ôıÚ(-Îº{bRÆx×P»™)Ä‚inp+ç‰VÖ±Úâ§2„VäO€cŞyV_ÊiM“ZîM:2~é:cRÅHm-@ı~ìü>r~_:¿/œÿó©L‹?ı>×ÿ:¿WÎï(hõ©&§ßôMáß '„“rH?{Å¬0FB×8¿‘¿jzİI³Â(ìu~ïßŸi¥ƒr‰îÀJôÙyşıR½9vô¤uw£†>¿§ÿ”ùó;ïb¿gÉÿ¿lDaÑ×ÿtp´{´wˆù?öîâ¿ÈÓíÿ?Üß]ñÿÓwııÿ»ûwşÿ¯óYk:e†Ñÿ{ [iÿíİÅÿ~‘çÎÿçÿ¿óÿ_Ëÿßäšõš}õÔq~h§w!M=lØ™ª’r&÷±;*CyÓHÖ‹”:˜M—Õ…—ëÕ¨\l-«]X}H47ÅÄµÆ­K4oá$=â5ïÚM„!œK ğOTk«ZHSù ,ĞíNc_-î!Eª’îŒÜ8˜*A­¾ıè[†4ú¦9¼rÏ1úJíë BÉ6Œ¶Smñ5›= ´¥`a)“.ÖA‰a)ÉSçyç=7^·2Ï‘!iË]ñïõ\ÃšŞ"ã
\úÿÚ3?ÑğªYª›ÕSµø©¥~—ÒbÜÙtû
èú§Ë{¨›ÒÀ—FÕ¤<x¥{dêÀÏå¢sÄa‚­·=Õk/ñâ#l¥Rœö¶¹íóï_ıYÒÿÌ•^ö÷?>:Ø¿Óÿ¾Äó…î>¹Óÿ¾Î‡öÿFvıâ¹Rÿ;|¸¿¿ûhiÿŞİÿü2Ïşw§ÿİé×Òÿ€kºx°Ş<¸y`;%J‡wÀBè"¤e‚Õvà§DÑwRš7ŸÎTX¿Ë6= %v¸·ó×·oN1\D¸UÍh¥Â§C"0bUbvsÖ?ívÌ;øm×›©`kyYÍmçvw”:2òêúÜÀníG®]kUÕÉ&"*¥¢µüNDÑw«åxjßéÏÜ»bU¤{›Zd°yt”:’•¾•Û¼‘ªz‚ıäU•Ávcc=9ã0„ïuy5½XÖ<ş¶v–®énfüZƒJuu]çÓØ^Ú_s2¼KÖ»óiôÇò4úƒıîäİ_:•ú^Ç4Qwë]ºˆÀJ¿[éøö¼Š‰¥µAeuVõJ%z
Ûö’:†óŠv~(C ¾“Ä9Õ¹ÙœEâ\µ–¶Û=âÙÔ¹uUÁ÷eŞ66t_bcøÖ_s='hë)–œÕuHi³ksš’ˆg¶ú38)öTaˆM¨và}½ƒŠßâB³MšôØèÏÌ9MùÏVİš@%!²¨tV—'ôækõ‡c‰©İ—&' ;Qâ¨O%ş5È–fQ~Qšvtµß¥^âw#ª%áĞtœ5-|ËEi1ALl/üˆ,&æõï»ÿÕ?†§Õ®ì+#V/ÔŸ‹´™È”ba/6süşPQ‚«öÎƒİôxÃ$+‹¥Nè»A‰µÖ…·~î%b¶2õ m³ì‡ßbrôp™÷w¯~£ãÅ;\´÷Ï©f²‹:aõK€lFg=´$’Â^ìÄî5`N¬ëZ³g"ñÆŸaôöñ_İıÕ'Ë›
/ÊšnºBó3±·X$ó^óW­Í]E¦ë$ 1-*9wÙü­{°Æ ÕaOˆe#¤óä}G¯Å×7»¾iY¬ô{ıİUmÄş~ãıšèwbšDóæ'FÇ«Jºmé¢îğ–¾¡I‘ÁøQ¾\ô2P¾ Å µ¼|õæÕÙ+:§,Ç›Ës‰Éÿq`€ŞÕìoóóË×¸GëçµÑ«ÄE:’$ÔÁÓVÑ¿*çü=)£¨c¸›¯’I€	³<V/œ«ÜŞ‹ÁBœ©šÅ Ïú¶¢âc€b¡…&½û`óıûÄÄzWß(ªĞh¥íö(ªkXtŠğ>ı‘„E×£©˜«FB wrcot=`¿˜Ai—úX2çdè7×ü¨£ùqìµŸµ~aÒ¸k5¥3¬ÑÿçåM¸Éñ¾n\õ9ëø¥*ÒØHÈóy é‹è¯**^â“ÉJ:Òzé%#U{†ó$U3“0ÍWUÇÍÊÍA˜ŞâM€5ÒÇ}ûmÄ`{ã‡.Ls§C¡Qô½!5–’RY…FdëC/¤b-ŠÓjE­I9%¦º|¼ësÕ³€ƒk/\‹/nt=–qÁç6ÖCó´°—¾°\ÿ YİvÍÒtöwÅÜwÎÃÓê¯‹~á4,ËKwŞ*;$Ê•Vøµ÷ Í—ÈGÚ‡Ñé³ŒÄ‘Şıi©O8Ùx®@êLÔÆe¹ÑùcêO‡œ¼‡_¥ìÇ˜‰ç†¯~¿Óúvõe
Û¾>†¶ÇTuŒÕiÑ£nºè'.YI_Òô]…Ö }¿Óøfİ«tè?ß­ŞÓ€vÖAê¾b=1 ¥Ïºù†¦CLFXfÏ÷¾ßYşÊ\¨°e¡«ª]“/HUÇ/é[º!å¤VÛ¦Db›ôÇ"	UÜ¢8“¡º†Ø¸Ÿ·¨©í8g¹¨œUÑ|»eİ©(Îô?,,xU9‘êşÈÖwŞ¹Ê¶®4´-õw©İ­·©­İßU†·ŞÏfO4”–NàDÈa8æè´É¥YÅäˆìhİÛï÷;FT˜ªÈ'Îg™§ÛÎ æeDÑg†¬Œ›Bô±˜,öŞ*2¸¤ˆA"ÿ}4ê¢–¯%G¤J)Ñb#Ä½ÆÈtœ:ª!ó€ªİP¿º‘ÙH0 ²Tnv}‘%C·¯~¡¡!èr>¤ênîù®íoıx+‹nÃµ|¹z¾ùñRQ§Åó+¥^¡‘Ò/Æ-rB^gàZQ5òî³ŞP—êDÂÁ¾ *œ`<öÊ¬ÒMBi×/­H™çH:KÆ4nXÂ5L¾ñüJŒ½şå8©«-‘Û>­~¢İÒKÂÕ|¾rEëÔNKwš‡Ur“>GMu}\{_dşNÉÆ÷Ë[|áE5s&mĞ/oaçïyG—ˆÍ_¿3ÑÁKøôå­â×<xªçDU‰Ãô•Ğ¤õVœòÏd…n³İ?ò°‘?0ñçx›^K.@½ú ¢sÀ$¥îÓ`@l¢[SunQ‡/›·üİVıIUÔ'\-…xMŞºÙõĞVLMÎ¯M…´ô·î1ç‘¨öGUˆ­eª
“Şı-JÜVÅ+•~–O{şÊ8;uÍx‘(Nß şEÄöÓéÇÃ‡ãtĞÏ"‰0´,è(ÿsíºŞx_“´òŠÊBD@ñ
æğıY>­ş´¬‡Ù.Õ—¸b
€™µm½#¤Ë ¢úåp5êeıSË“¤'˜ìeµPê¤™>YN
m<îìDT˜ (c:Ä€€¡æ1dƒ/eOüD„~†¹.“Ü/!é¯^+OS¢«g;Î1*MÊ°¼ù"ÿéµàU¹½ûà·}ÑlŸjrâ¤Ç€.ÒZ©aİı½Š2 bìbmOÀ—š¿<Oó÷ÉÏJş Er’ [šÇãÂDZõ·î1üÅœ™¡R%¥:"ĞÚa‰ó§ı@“½ÎK½Š¢Æ1¤@ÅRÃ~#4¬ßşphäæ­Ô_ª0l6bd—3¬‡p¬ÓMĞïfÏ)³ƒµ ‹¾PÚÉİû·®J®C³4ÇoWzé—ò†‹‚ÃÆ”æe’h%¬Í6k•‰®w¬^ŒE~œçbŞÙÃı­{ªó­Öºº=ÅV,Ô0¬qÀûö'IŒ(K106O'uF
€DÛ†^ø –!UvGä\uÚ^c¼–O;"G39	/œUû×…W»/)ô@9	˜‰,zâ÷j–E ™åÍìtßŸ«ìi¡™á9Æ Ëîùó#O¿|òâñá®»{xøÊİÛ{¹çşpğê‰»»ûx÷áëÃ'O^>9ø¯>ıY>­ş0°w9‚‹ò<êÀôF,Wi‚§â·Ø¸OÄ‹sq¿ÃVıùìõjØÇeøq÷BÊl±‘ôcöÛTÒ¯:'Uı
M†ÖÈìÃ¯ªâ>Äé0Ğ˜"JĞÊÇ1±¬¢!¡ot¼Ú\<lEl,Æ[³
Ì3±Ú†Üv¥¿uO–c
?ì‚îl8t
STÈ¥’øåt[‡ßº§Vú…¼lxşfo(tü'•U\ä/ğ}—±“” l-‰ºKµzÑ‹X½¿}2Ô!2#ë`’~ã]Âi‘l\’˜`¯ ,³I6»Îşèô¦®j21c«dì×€íî¯BÌôáÉÉœÈlÙA*uªcÔkûÌŸÎ^Œ74<çx!ç¡åã“éRK˜”ßº}<I«Şşîîus›åÏ*;-Ï$pÕ/ ı‰8-ª¶lÿ×F|­Ø¿0 sø‰-$ÑªZßÕùìÓßêœ'˜µÓôº2«›İ¿—Ù–®Ùßºç… T‡zâkÇÉŠW¤ĞúøgZ&¹–¹-(óJáìßÂ6ghÅLÁıÕ<XÙ="PW…ñ—NI"mY-æ¯9ÀÅíj†ã‹R-`õ8¨ğÁòo”3Vç¦»FDÓÏ—Xa)HÈùğ¿ìú³|–"0æô>y—	ğ9©<wM+Î~U•ß‚É;X$ãĞ:úÙëTdôì; ÎŒ° €‘¸M|M>Ó>úÇ•ëA˜…u˜bĞg¿ÕÙYH³j eŒÛó’(Œ)ÂÎ{ØspÎ#úPô™áÀ±q	*†5!şÒ·”ŸcõÈ llrò7š‘aª3µßÑ$ö™¿Ê9YP¬Öˆîø6bŠ{ÉWı\ığ³|Úó×41›§a¯”+·µÎZnåŸF× Ôäë(i£ã…ıŸfÂo†AVúÇ#×”ş£(M­9mø¨‚úØ7|sƒ¢Š–'”dˆ€Ç+ßèxgY:•À hX…ÖØïÿê~Ğï¹?Ìëpãuı­{L`3îÑÌ‹ükÅEïµoÌèˆ§ˆ55í£Õ´3»ŠUó@Mb	SC;äæbÄú`°XÉ/«v`«¦“m'Îéé	^Â(I`éŸE¾jA¹äItX,¾^?ÍØ²Vö|}UÀÜô$Ï	'3¼Ô €Nˆ8˜¼jÃ·•L½²SŒt=Ñ^Òú¾5òº¥¸¼ÅmØæ€ı5X0ŸÏŞ¾1vn¼ÔE¥ŒD.ˆE°ªĞ½P§¸^îO_Ş2×~tjˆØ¾•h¾VK¡}Š²¼õ¼E»v}¯á×ŠéÛ(ïÔWÎdÓ”[æ¢šQR \¾jöç>øİß}FûtÛÙ{†¦¥W_ŸİpìÇ¿ÖmaªÂ½tâla8¢Ú†aŒB[Piê]Ü-û,v5é&û]ºæñf}ê]øãWÊiş±º˜pİşÖ=fl™#:cºÒ‘$°¹Aô3£ı]u{b»iËîÙ¥Z1×Z¡‹P¯Ú¤—œgã¶—$¼Ğ‹û)nqy5öÂ­˜¦R[£hDe[©º³Ğı>|=·ß5nOàòü•;´yÉ<¬¯öô±½ÖS…³¿8İµÛÈ]ñmt¼S¬#×xáDUå1©„şèë¿UXM‹ÄIöÆîz	à0ÔxC
]{sD…L ‘ÙR¨HŞ‡«Sö2a¸%
ïqˆã½o­ğßYi‚6§V/àGGGÜà/9Dz¡Ã ‘vk$DãÕ®yAõIœ¿€.:ó… ~ÿÅ_N\!®×‚,>]¸¸w["Tc¢vª']i4¥ èêØhdöv–û3ÉÍªÜrgóL‡®w‰æMi¼ÙßÖ?
İA˜ì|·U%ÆÚ´&ïN2'\VnfX/À¥ÌÌ”QƒbÀS qYÍô|Ö¾2ÔÔJz¥Ù¹BXÂ¯¢+rmX éÒÕgMH‘“c$J’‰¨Ñi‡,Á1lFh^†¹óGJ‚à™¨§¿ jÒõq¼ıı½ÊSØß²ÇqVb©–tãg§–lX+ÁGrÚâÁ2JÍC¾¬Ë-ëdFeÒô©tã§Ó·“É¼3¥ÅfÇ[ïõ¦ W·ş±%ÔUiœªkRİøé½V­íÍÇû÷Ó9h±7’Å‡³àóû[t‘¸ÂskÛ¤'}Ğ#Gå³4Je½J@éJr?5Lø
ƒé[ü8yˆäÌµ§çÆâşXj2hjDIşrmU2Ï[šŸ’}È10Ò°v$c™{µĞ¿*EÚ ^uÍ
¨MXßÚGÜu”Z5sFøğ0ñĞîîrB)X4Ç¥n@éš–ò¯D0n´½PhrVÈ¬Š¥-ÅÒîTo«4‡W§'m]_I‘XÑü€zëËâÊ©r'ŠA:AõËÿµ…Âí†+z»¦[Ô-Q®ûBÉë»$-¾32ªÉÜŞ$?–‰¯kj`gJ6r9êÉT	·Úr6Ì?(JçØè¯Jæ¸6+)íz­ÿH¦@üšä'zª)4Õ3·œScĞØY¦Áe›³+ëB™G®‘ãŸï|¿ÓüØ&  µ/Ö}Ô×Åö*[5ºÙ¿Ûõ/În0®zXŠ£a­°Ç®±]eÌh£L®~8wî˜Jûlâo?€«ø|‹ŒjĞb—1¦&k2>¶®$³ÏªmEc¸™É>€Û¨Ğw„ßêÆúE%Ğ’b›û½¡R¢ñïOÏª¤²K¡6fGaÈ@/*ø•Ä©öıNó½•Ö—¡úåvw}×s5I=İ¾$uÚ­BÍß5ª¹£#êûåoıT³{ù"›˜*U/OcíàO2·P&Ê$¨ÖHeUC¼‰WA ÜQ!CRÇâiM:¦[V{±¦?Ê_×Èn•‰Ú‚È0ØM5Têê0£V„özµûÆ_Bj×_äj[şJN±uñÿ/òğëIºÚÁÿuxø‡u8Æ²ƒ¿ÓÃ=¤åhŒ‘Ø&ˆ{ÑÇÖw[¸Ü¡¹c°‚_¤ÇÍ0¶S%kl{S8bŠâgx1çuº”œ†‚êÜéJr 41åZ²¥£±_ô·v=êƒÚOE®+±!ei¬­-uQ·>ôrVù'“âAbçšui×"¤Ñ©‚í|yà{İZGÇ6İj2Ë¨àŞM MRİ©ŠêU†W³Ú«ôrSÛëRv Û]—ğcyÚ¶×ÆjTÏ1]‘³šÒéÈª¬Û1ÆŒÒÁRiøİïö2êz†Tíãzãı;ú·wf®ŞİxVÃŞp‘šïÿÉûîÁŸ¿d´ä]DÈ]DˆMë»ˆ+Ÿ{ø¯Ö…P%¾¹Xj¼û}Ñ–¼ÛîeÇëà˜wÎÿÿyÎÿKTµæ†eE‡é´eXkj¥£VäõCLïëÔÀ5¦››ÙZöœõvœeÈ]£ÒJ£c´ÆŒÆB¹İÀ0Ñå×Y‰Ë9^_àZ„¯¤O“.èŠj¸9/Zy‘×Ó§éíè¨u)Y,™£uW…qƒi·WRRMŒª†S"§”±ÑŸo’$šö
¥/º^W§Ò—©"öeZOóuãêŒA-Ã¥şÁà÷ü`íïj{d»«K¸Õ“ùöäí+‡û«¶{sì¿â/ò`¸ÏRåŸí*‘Éd¢_ ,’uV‚ö\
gë…>¨\Äc«NğßL'YøƒV$©z9†%8æíVÍvß–[¬ÍıF×7n¨*À}LïÔÄ´L*”°ZÏëÁör©¬¶·¥r¯´Ôå5ÛZnÚAÕ|Ín­'çùŞşÁ÷;‹‹W¨%*õÏ8ïL’À‹Ò¢Tî»ïBÓÅk†ÒV!v#q ¸?|˜nÁ|´ß{2İ9eÙ>Ğ¬?P&˜>Û¬ôÌ}ô™îêê{„L81°C˜Ä8Í±Ê(z[Ø°ğ;±(ƒ0Eøø*ĞøÚC‡~Ù°P×ÆBÉƒn,ÌÄ#Ô©åØá4ÍÙh¿›èĞ³‹(
Píd^°¡`…²[8Ks¬[f2>+ú`ÂFZ®‡/7À’üÒzNüÒO)×	İöë‚8äll!è<ô†„ı˜¨ìº<jDb”‹lÌ…ÃĞ’+A¥ï÷Ø0°…p{ Pø|§JÕÖk<ºÊÏ…FhÅ!SUh	™ü°·X‡|PûK#¬`og´¶RPÈÆnÂÜšÄƒt =hè6~Ñ…Ø£ˆ¬ ş…É?~ÙvbXØ"L5ãA ¶Ú„ZDGÂ£†<($3D’¤œqÏ.¬ÇŸy¡o›Á–	¡šİÎ‰•ÛjË„õ&Òöå…Ïvnçû$Œa1`ÎÙôe'Á2ëşŠ¢ÌÙˆAu2mm7ĞË¯ØØ¶êdÛÆ?Do2ÁLí…b6¡§0èiîQL¨tr¤ÍLû­ëEju^ãûœ±Ùæ°;èÙø“	5±ZÓ„	«3QKE8óF À“Òœ&2aºUfB…lÖ‚I§`²ØƒôàŞ›?*‰”	Ö“á‚oeµ¢¿gh¯ã?=M¼rØlÒoÖ™Á~îÖŠ–÷Y˜ƒüïQÂWéÃYïQ'LèX™k/CG±¡cE‹Z9ŸÓÄ“ƒ4½`Âb`w" ?Ò)å!æÂÀÏB+ádæš&<à+"5F+jÅßJ(@2Àø8ò‚øÓß©8ÖV«\Šh’øŞ€Í€<w:—‘–ça¡J/j®²œk{’‡¬?&©_ÈÂUL	—Ì>°·Øìƒ¸Ó’ªuBz‘dÌ{)F:Ò…	fjm¢b¸y,.0Šˆ		ky4Ëå$”SE—ú•G=0ábéÙÀÉåÉØÙ‹6±çŠn»µ¦{à4~›ğ5¦´Ïå]òNUĞ˜B¸4oOÄÖ† ?*e‘—ªğ|‘ƒ>š@"4`œˆYAbnvÁ†Ü¡µlàGiráù‡X´›‹RıCk…b3hŒ¾4¬›AÃÚç¿4ì¢¡X¹ĞŠ?
‚|Év¨~†EY½ŒÏÁz]Ê<ò¨Öş7X’ì"ô@Ù¦Æ<h|ñ3Æ·Ô©«Zlğgİ1 M¨£Õ~¬ì™$hÖÂ‡£ŒÚ2ab©İûlŠ½\ÈN}f…şe
eî—›˜°‰ÃnÛc“& °ÇL€DœhXI_$Œ0aS¸°S+†°ÒX°…ÍbVV/B!`
F>Y£ğ©”%—9Ü:_,c¼Õ@[“KÉ…ì$q'À$ÈÅ”•OZ3?L™Ë(\8H+1Bi£hıQ§ùSëÛô"È±­Í[·`nmî™-^c±‰†ãîˆe,.é]`"$¶™è¶´47?›¥Åíƒ²%sw*Dùº´›t©Nº«“Q0Fù¡5kÂ8‰¼‰(g;§#+aA+ubåVù0PVş:Ì:ÂûÂÚ*ìç¡:-|w!s·A*Ø®; Böº~¡LD²(øçÂš´ñ©j•ñ!díMm#„—S"áò«BÖFıBlxXúw¶ƒæ¦ÖTÅ©O!ÁlHt+Í“&æS»¥Ì`6¹²Ûy·<ís‰™<òóQø¥*ÒØeR²!Ô¹ªSz•hjïĞcš1!`ŸÏ[€^Æ/àÅ|ª­u<c8‡Ÿu’>·µ/³:
cá“ÅYøE–³:·"uâò `\VR«V#s6†g§ÏÌÜÙÃİ'®/X5Ù|i’V15×yÍÖ<è¨±å&T\÷	|ewî)¾ƒOÙ‹ÉTo‡óæß­·¢÷˜ Ş²ÃAuÆ—šO¸ ZùıÒURÆl\v3»:Å†~™îÔJÇÁjÂ|vË46ë!™ö@trò8ddØH‰@0‡aì€á¥ò¨%…ˆ¤†Bä•x°å¸äØ@Lâ´L¬(°jÃ¹$¾•­œ}ÖœÇùOXç¦±ğ çÖZFÏdÎ<jÌƒ†´L¾B‘T·œÙ°øòêÎªuËqš×j#0´ËBC÷Ëq ğ.S}vR"w¤vĞíÃç>‹íòğsŞĞú¬ãKÊ‡¬ÀMl;@Á*Fu8œw*šŞi¿O¸l˜º«Û Y™V6`Fb«X®M,º½E{!•AlÅ61‰µ_–šğ O­Î»X1&|Ø×	œ@<h[bP/~šäŞ×èŞÚÕ—f2™+.‹B¹épú²Æ±^ThÀ«~æ6ŒíLÖ¼Y\{!+§ñÆÒ>1€åB2»½{dš[ÆWB/`cˆ™u/4aL9ä=/Ôká›vg¯ÑzW®¼(L¤ò
ÁÒ(»Ô9øş6ozPØ*¾^²ä´ vÎ®8r©	ğÙV‰à
6Ù¿PãîQ7{c¶!—vÂ×&Äù+€Ú¸<Á¤“Î5Ì*m£35èNÏ²´Ç&\÷¾ƒi§Eiaô¦—™Àv$İjÊÆKg=oûØÛhgÖç¶ÊÒbˆe—¨-·kS‘¾Œ²ÃÇ»»ıùZRÊ\x†|ˆ<:|t=DtC>D]sFtC&Db+=ßgM+í³¢$éDá(ö¨-Öú@®869ì‘Kw9?Dè+É%pÉğÈş4¡"®cIFV2ïDÙÓbª	îäCÿñ>—R*cË­ï3
Û2í6>.ÄÎp"r§apI¾ÒÎVaÌ˜¤‰õ²œÌ¬Lìù´eVZé]ø>c*e©¬KÛHõ9%é'1vgl]Á"S˜1-‹¨,¾Š‰è6TÕ%ñ.°3«ØÆMpá™•fD¯3¶fCQ€o¬œo˜K[N1ÅºäCÀ:D~Î°úJ4(Ùˆà³ı$$xƒ/ú…^`ÂÀ¼ÈWøÅğ°·-„^åúèÑíöI§*´¸İ5•v¡PÅ ÔX²m³¡on*á{Ô»Ä:èëÊß"Q&¾U;	 ˜nŠÓ #1OËÂB¶+}ÃÑÃëDÕ¹)G\ÂØpdyÛƒÙp3ì\—ê2×0—rÇàÃ[ƒÜ¹öƒÜÉz7¹SçŞäĞÊ­8sg|yø†Qß‚†úM& ½ó±Ùl*ÃÈº&Dú9–Î<jÍ„G‰&b“h"ëûâ”#œ°]UFı”8:Hâf\Î#úeÛ%ğW´ª]‰¸¤Û&Öa»C z‘(šò ‘v:_6#Ùf=obÓ°3.6-âí¯¼]äá |o*•8Ê„FÏzK6¥Â¾ Î0*gXıÜcÌ	1,ngX&rq?¨!|Å|g8é\š…×Ÿ^ækïÖåô†lŞ`èÉ:ï;ö:†åçÏsNÕ{´o-ŒdšElzÔiÜÒÌat0\ìytpAs^šÙß¥åi:‘®ğ}}5UPD]„îhœªbPªB²UŸİŞÆ:‡^æ+­U¬e=b«5’Öw Ë"Ÿ»8Xš³	£‘uBi@e$¹àŒ¬5EÊVW{4¶¶šıÉ˜·pÔ·8Ãˆ-[àÈ®ÆncÜ &$EXÌ]À…Pw*¥„ØR*’’JØÛYg­xÈ¬íÂÃH:g«ì;útí †ò|kI‰~.¬ö…ÊGlGcn­HnìˆÈ;-W—1‡äœÓ"?Ê-ãz0Æ#Œì3L5’›X£dF…]ÑàM[¹ƒ‘ıÅ&CxNsE§Dß ®,1£~‰€?ÊÆ“ğ3dû `‰d‹ÍYVpñEgu‡Ì·ñÇûG{ıÌ$úM. šqô€h§Ë±zÈTX[b 	#;|knÃŞ¶hÇ˜-ò`üÅ·’]~Şi˜ŒÙÔ©q6²'´ÌÕÍ˜0°«ÃQcr¹šÇvq½5\Òìø“•:‡ÙC@rvÈu×cÜí¨h¹òù¸¸°å/d"b)DÆ¶	º¥6î¢£º«/sb½Ñæ"cá'nÀ¦»'ö™©k4&iÈfoO¬÷ıV%Ü·¾C&…ÌùŒ®aw…´|?ËSF3'­ìÕ8Ì¨®¥ÌeâS¢pPš
qE÷…öùE60	æ÷*â
^år8…İÁ¦:{«ˆd°©Ëawî:=Xz‘ä°Ó¤¿‘‘Ú½¨±HìsÌ+"ÿÁ\œ\dç’kë€~“	¨µ°	MRÁ—º"ì®5µÊiUš+/d+>ncæ­]@?jÍƒ‡ı=Ö¥}@Ÿß±ÙÉBûÄbØ¾ğ=M£¹²eUí²‹™›ÔŠ~Ò‹9ræ¥àüşC†×Yë”R·Š@ZXçsªÈ…®J‡ÅTäÒÓğà“C+^a0·.ºµÄxïw…¹ıq1ˆ±šÃ¸PĞ3ÆE0&mskNæ2KUˆÉf«¹á$^e,²Û aaŸGeU°bÎÉÚ«¸aË|âû.5gBÄº0{®¦ç¢ÓöP{…T™xçû±ô ?7ZÓfó“Ûy­¡s6j=·óMb=CW€´N¸HS—Hìeë#è*-s6‹Ëyh_œE·áYûÇ™{Í¹ø÷yb[ŠÖ ›¹Œ6†ó4°9ÎÓT¶ä&È¬Óê£m ğ"×/İÕz+0;¹ö]gl<.ë ¨`2ôËÓº4-«Íø¼;Ş†]W;Wi§‚Ø´b³P«ìË÷¢ÇqM÷@ã0àò|Ìİ,×MK4†Öaà„JÓ%[eú‹Ğú º•…9ç KÅ¥é(’®y1öx±U”Ñl¸â­.{ßm˜°ÙÔ/ka’ü5w)¦%+ÙÈ¬Š‰,—J¢%•kÑz3xØ+„‡DØje\ö‹"ÆiZ°mÌîÜ`ZÔ¤™@Zs%æ1O­£håë\L¯·	Qˆ„²G, şŸñBcš•yæš&<àÖÄE¶İñ1cÿPº‰Ä—^ ÕE‘rY!¢õ©ynr¦}aœk×í^1“Œ¥‡E"ÓÄù{ÎÆÎ£±•ü·û2&:²Î}›§e!<İšsmz cWƒèÁãıî”Ôk\!qğ_BDÄĞŞ¶ÎGÚiÊá_„T–¬›pÒ^nå»ßÄf´wÇÅÊ¥V<ğûŒx&m5åA¢‡s©NÇ•>!â›Œ¦Ö0J‹R×oÊr®ˆÅè³ÕĞPc¼g•ƒ‹òÅ2Å$”\w­â½Î«)›G¡§µ7æ³öÆûwšÃ³}®Hñ~ÏbS¬£½…>¸…qt;«	&1@å+j€[‡àÀgé1ãqØ{Ò¹î™Å‡İ.ØAö5ª3‚ì¤¬EJ'î5í½yÙFk¥3Å¢Kø|fƒß;i(¼šˆÌå‹E`¥ºâûŒr,¬¯qH?†‰:<[Mr“-ÏVLeÎ³‹~¡¤E¹$c$e;I·à$«„AØ{ë JS¤œZ2áÚ]h¤÷y@ûV‚!_¾ˆ|Æ«±om|¤&LÀéìê±ó.¾ì™&<àËÒ ±>ÖÆeƒßyk}‘W3Vnœ²9î»“›ò3<©:•`}•D¿É´VZ'6@Cè!'Ÿ•=Š°¶q`=éí¯sA.óc<´ò3Q‚B8Ã¡dK$®SvZ¦t:*AàeÔíR¯P}º<-$|b$>‡	&=ÒpÇé®¾8PË1[F>|¡“ïm¢_|ŞYûÈhsç| ³/Ó.L™r€¦Ñ`îÅl‰IâØZˆòÇa–”…Â@8‘^@ÿ1›TÛ_[Œ¹Çú\#YxyÎdÎ°jèƒˆ³étIg¹€ksšH®º¨¨XÂ‡Yê_ÈÂ•XK3CÊkfH{š”>•¡Q¯ävòİªN‡Ğ¡ğ ÏºU;v‹t7ëİÌ[snd·áİÈº½hü0{ftc4Êf·`ÜÏíø'ä/oöÎnƒx­ÓæÄi6.Ï—yñ>Ù“7³¿û"ÕF€ö\jí)dƒ{cİ«ê;½¬½°vòÁ†‰*DÉœSÄê¾N¶ŒÌ *eèK/.£"ÌŸE3³¾f`XLãk6\¬õÂX¹Y2Vaíol ‡I_v›VY©_uäc˜ =²)aŸ¬‘¨LŸØpÈ­NİXä\¹²e®NhÀë`ì—¨ÕË |K¯*†˜)™Odî§	 Â;RZ›††J<Ó’‹Oölˆ­öBl—lŸ"2•âğQÅ-¸”­Hé4ÁrlX_®©ØŸâÛ…=.'RzĞ-‰DÜí€[T —yÀ–öÒJú![q6êî—¬ré§y€Ùºª8¹âÄÚïÎ<µæIñ/Şhf^gÌ@	l¸Ø‘ålÂI‚3ëYä¡òEó0cã³[õLÜ9´íæ I/Báé¶šÇàT•NË…X§…•dÆ„«bFrËApÉÀZM¦†@z¬·íŠLÏÜD>[‹ÄNS™¹A1€6Œ!ÂZWomÆ ¼$²Î„—ÈT‘ŒJÄ…:àAÅ^vIN$—“$Ö
T’"	ôéaNUË¸tù$±>5j\”ßfM¬ëßÖˆLå€›Úìš¯>{b¯Sê{}IZ°å©NE·ÇuY·/ÏÃB•^*Ô\qÙÚRau·o®£:»\hØåS@õb&|iÛ-Òë7 ü;×uŞg2y™ú%¦ïu^ÂA4J:®{	~Ö…‚ayBå¥ %0Pè¸C(¼¸¿À»%—#níÀ\ƒøÍ¯¯¬`ıZç»okfµoŞde€“µ¸s9R.KNâUJÎÅ^¹|^­½pk†P¥*áEı¾Ë·.W·q:[y±~+°(¼S¾kãüQ¤ÔMj­ŒâƒÎÓEÀ/‚}Løê²$Ş1œR/5–òŠU°>n×A- ñàP»uæƒÄÅûF¤#® êéKƒìètSH³0;ø»ƒ}¨KIÁ®Øãd$Ò2Œk	¦l!PĞ[aWÌ…~j%Pm¾•ÅŒ@w’Şp9È”Ë_–"Íì"è:ˆ¸Ã¤¹µ¥5ih(’ğ3ŸÚd¯Ò›
‡x((?Í%J£‚íHPÃlb=7ëQòtgœTÓ]µ¯.Ä#¼7Q³¼k5L“ÂMo˜sêRåáÌŒîÒ¨àÔ"ø4¡ÏŞ¾qÒT×(¬2L]%’óÓ‚MÏÙ†ÙRºç˜[gØĞ¨šÊC÷ ˜µˆ‰Ô‰îÁpéìLqfW¸[¿ÏÚ~R`:Òá0ô%œò^İ–	¡Î]djúdBù‚ëÀÌö¬R‚f¾Úã*YíY‰¹0r„ÎåÈY†Û ôGnãÒ%f¬„şÆßÊnµøV¹š+‘ËOpnp]XÎY1#†
G‰(Êœm6¬òØ!¹ w;ª6Â‚„µ×šÁXM+³Ï5¥S™Ê0
d~Ä†FçF¬²®ei^ˆA$İAXÄlI‘3Ê¯l7…Ÿeœy_næÌ¿ªD­˜à[GwŒ3—ZqÁ·HÔÌøpè4-f!Ûœ¬Oâ«åqSş«Œ1ÿUÖuUïBŸ+r#³÷>3Z»2;WlÆá–­‚ÌNÇï¹.ÌgCK1pX‰_ÁÀJ ÓğjÅß2Î‘Wè®¯¸rêr1g<vGV÷Cg®?–J¹ÔŒ	«c^weâçó¬`»ÇÈ—?oÂÛ8ä,½küIï³+û#¼>óÙßAo™°³Ê"nİ‹Èú¸=e ä†¾;˜º‘ÈÙÒŞeÑ5òOĞu4jÉ„ƒµ“IçdŠ¤ÈÙ˜PÔ­}›ŒÊ§—yÀÚ‡rû…GbóZeIÏ²Âô"HûCO$œg^Ò“õ²gÇñ\#Sb-aÛUí™°¹V.´>d)ç¤×©Ë³ÀÃ«<8Qy*$™Àã“ÒÒî‚ˆË¢½~GÚÙ¬\mº_ëqŠ#Ù³‘eâ†*‚ L65›™}jÆã<26y¯;=Ë
ÊÂ#²ó<mlãeê†t¢¢0jœN7F+j³;¯ Â_KÍnÊR›ó´±Åİ0[e‹nàüÉº¢8§­Ì..mcL³Ü¾)E¨s)©ğ("vÆCÊËˆÏ}jç´KU¡ü<ÌØ¶¹º‘*©b¾Kâ™ê<Õ7E¤—Ó"ŞËvªÚ…+cf&%œól‰m2ua›Ş›0"fEòËLjzØÍ¬[Z'&Q¨ÆlÑ«™]N“åÍ1lˆL­SğÄ27,X¯Çfów**y sŒ"›{”íÅ£öL˜ô¼÷p)&&L>ÙëJ:¥ÇIÈ‹òiÚb’ZéQ;ìœ!†\¾ÈOöš‘á"—n £B¸\ètJó›I•ş©;L·ÒP7 ºóİì©õÁõ©ù…şïå}.Vùij­Èm•™õA¶9T¾²SÙ*_­ä½3[g‰jDÙ€w¥›„nÊ	\?iúÙ|Éyw cÅ=ı¸n|ÙºÛÏòT‡&ZâY™dQ9ÉÀktÂƒ”]|¼Î¨
åu]/Ì¢áNB|ß£æ<ˆHëàÆA©ÂH3`êi6!­,ÊëmÒ2÷9¯Xæ£Î3­Ú&ô*P»’c¹…É0åuØMµşE/ó€µ:)«ÕvAªf­z˜wG\Q‡*g‹8È#+!¦=nY9”µö™ë£“ô`6$¾|ı¿¼ÇMû5Â‚‹çTÈeÎÏ»ó¡/Oÿ¹Ÿyçb"béÁlD²p©tìR>æ237‘#üÂUó¤\ªxZ¹:¨L(µa‚>ìdÖì©êóì‰µk:JER¤5eBB]#§!¦½ÌmôzñÉ™ºfÎ&6\ÈX%ÍW™È?Eî§R²¥›Ì­V&”‹uB_²£İ®–*`n7Šuävyò&0hî4Œ3ÊCÌ˜©ï8¡¸<ÌJ\7å,u9õy5°ó¢áûŒ´¦¬Cc±Z’~™Kë–ĞŞ¸4{å['ĞTşX%›¯|kAU»ü•ŸK™øläÊ·;üIæú á`«_®|+.¸@BeirÃM,zÜY#Q_VSŒ—Õ”]VUªj\ˆ<u%ÈWØ•²ÏCÚBÅlÚ¥
¬Mä-TÂ˜Ó¬‚{tÒˆˆ1'?…î¾L¬lqô:`ëÛæ-Ò˜æ!Ÿ±XIk314‰EÈ¶×-ÄÅX‡KÁ€ìg!æRr¡+ûİ)ÙÊÒCWöué©x+‡]P
E~–«íâl¸TäĞ‚-ÈÂ…&wê†IX„œa¦ĞyŞ]w4X«"×y¬øqî8Pö1»ãy§
ÃpgÀÑ‡.cY5´6•€VÃ\zÔ–‹‘µ+z_wGQ:`Ël¢ºo“dï1‚ì'rÂ´ºÍ9sÙj	bÀ‘-h¶ˆB5¶âÛğzñéw®Û‹¢ç‚Ï\]Îf®€uë†=°©’Êõ@&´b—xœ;{’
£Î >öš–*´ç€©ˆXŸ›ÂÄÊbÄY”ÃaÈ&J„vGdŸËq£ìU¾‹”­¾¥²WóX¡[ÇY°B·ö•pBì‹@¬¹Î·¡Û^€İ¸ÊÇ†¬õBê p%"6>bo.)d‹$ô×Í«ê4q±W›nÌ—>CõˆUhÊ>qÈêˆC;§7øÏ=Bˆ.%“*Ÿ™u )‚c TÈf^M®sÉ‹ZñÀ·º£±:*³¼º±Ü±Ê®ZÃ²¯0ç7-VÖÄÅ®r±;,Qò‡f‚Oï‘O£öÆ„É¶E°·3j£G
şÇí‘Êìs„«s®»&we{1{*Båê¸B6¬*ÔÂëœçRn%Û™È ¾2b1UÊÚ©q‘âÂ¤¾˜²™hìk§	’í&²R–Š7€ÂZ„V"Œ ·"1EæıË†Œ½ƒ¸L<˜òsgèQ…½ßÇ ƒ^s~t¬‰u
Ú"[x•²¯JRM‡q—óÏÈ…Fcø"WgôSaíS@]ş"ô¨%V&nºŒ;òXK>©ÂŞen(C{UØ	£;±A-ã“`3(Â‚/«´7÷–Ê&“€ÏÿP*{-thLı,´RÈfnİˆ[Ù¯jÃ„€õÁFd©Ã’Ù°?Î&lQİ%áôµ"ÅZîzë¼[¸¸SË´åA˜KŸQ°Z`Ô8õ/¦b"İ!§²=µDªB$²˜¦ù…ò¨\f7.Ù°¸‘LÉ†…uvÓ¥›7bvSÉ’{s¾A„Óx>»¡8Å„G?;çÕ®BŒ"iŸ›q¹ög!¬Óû@L°ƒ!fqŠÁü®Èıq8á:·Û–‚Mv+®QîÓsí{_±ŸÂ®ØŒŸ­ÎN!…?¶€¤İ‹ó›ÆL¨XñHxQœŞü4ÏìÔn,ã5¨h«¹'Ø˜”€>õv«(ô;@‹g»÷]íH~œ‹’óea[wfÀ¥F<àÇ±u,F\Å_cÉ–ğ«w®1x‘M»o–óíLŞaÚ‰‰,¸²‚˜Ëîòmâ„Eİ;o-ÎÆ(OSP!‹4¸ö9»‹<„ÿ°åñí¶³òËÃ=2…­º”"c“½ì2Ÿà•VĞ?â0aÓ»{ô˜çP"ÎdÀy…¡P™Põâ‹«d&r üÀˆ¨dä(ìœcU86÷Oaç~Ú ü~aìE™óYòû\—*Œé]ØvÍ§L{·ÂÆ±·cd’Æt¿¨(g2`MgÖnQS‹Z2áğå¥ãòÀ²8º(‹qšO1ï€‹@Zæ‡¡H\Ş(ÇrhMĞ„ëŒÒ]İø¨Û^ÈâYÆçÖCÅ9á%a1ŸÚ!í¸pHíKÃaFµÌ;udâ<ğ¥ÆãÛ/í;Üî€«¬­°¦	øÂ:Cj~ò8 egà¢¹DX–2ñS¶KåÄ¢B }éq¦7*í}æ„£êQN¬å~z:ïkà£\dc¾³fÒyxQ‡‚à¹âÊIÏÿz§¾4tmbßéÿYÏVÿ¯œtrú%ĞŠ´µ­‰(
Ş³}ÒÉs3PN&¥g‡l°-J¿Ğàé#ôÛåú_Ûÿøş­3şÛäü·Îúo›÷ß&ó¿Mîÿµ°ÿÛåÿ·| Xû>	‰2Q™ôÃaÈ–}P±/O¨|f+P~E“qÛs1ñEŞy8ëà~ı&TËÔ®~…	×½¨‰ß/ËúÌå³u¨ñÿòbÑ7¿ò„ùâÂÄ·ŞuÔ„¸}Æ ÅA°¥QŸ„' ¼ÌÅû'©}ÀİÆpNRË°³xY&y·¡Y'­Òoò µó¼×$ÈŞZÿ™°İÊØWwà»µÊŞ: |Ñ)÷bGÀø2XË‚Ğ“4ôåŒUäŸXŠÌ×†¦Â~šr…;NEçqS•¢W™€öÌB‘Mîô†e{~çºÎ¯°b‘TÊù!,à:yâ2bƒîÊKëÃTdnÁ3+kîçÃ¡Ÿ#ıS€g¾ˆéÀvgÖSÂˆ„}i¤¼ÄÆ…A`íìæÆ@zšeáM6¾@]õ‘CyöÜ~úM ÖúV‡Ş4Flµ›¦#+Áƒö…5×á¦ï„¦6Zë‘İ¾q±åµŸÚ¥µ7Ğ¹ôú©]²B„ËBÜ¸æ-Áoß8§”ÖéÒã·gÎäú¤¹á9ƒX½HãFz—ãe}‹Ùàw3·D=m”€©{öúmèéÌN¼“h½ËëN¦Æ–ËÓ3{ZZÌd“~»/µàr·¦±•Ù@çªò<íQ´²"Ù§|×:¦™µe¹ “ù¯˜ÆÔşz.CÆ&Pg·~Ü²_†Olç_wàæò Ã&ø/oPœ*»0i|ŸSTY
}[Õ©Úp¢QX«q ce>à²¯M»İ‰M¶?ábû³¯âÆÂÌÎÆFµq>'îAàúyª2b.Lì’+Ì\F™Gáh\¸‚íßÌ.²'špi!³í, MêFLğíë›ÕUï1Ë½ÎSô°9fİm|˜ÁL‘p`'ù"sƒphQ¸¦
ö)xæ‰ù‘8ËÎìÊRæª H²¢¡ìt|Ÿ¾µ'hÍîàBF&vW`á}Î¹°K“‰Â»i¦\™çiÎ‰ÈĞn›6ˆ“Zr!a­?Ìøî¼ÍÆvéÆ¼±y³>Uµ6‹ÀÄ	'ô¾AhÕùtÌ"ë| -È™/ÙF‰ëøØ„A˜l¨rÏÌŞ0È>5×6®cR`Æà:N:Mj,e’¤Èç£û‚EKøm1æÂS*Ë¥çØàÎ†«}ŠBn2+®¿ŒUb­¤}ñY›•dÎ+4ëqy~Ã‹iyóâÖÙ®Ò(ó]UØblg©òŸ²*W™¥	°ÖÀœeıõü,œ1êù™µÉ'T.µb‚ƒZU<ëÍ™^s?M¨‚BÂw¦ô(‡ô…0Q·Å,ë9âûœÜà¥ÉğÄŠƒ]µ6|Ÿ|iïL?‡Q$<hÊ‰H÷ÍÇÍé¶·ªXwç«O„i˜é4(ÙÂ>góN·¼?–1†y"ü9—C~.«È7ı>ht+Y@ÆÅ¶‚ğSÖ\÷ÿq«Ğ?ë‹„Ÿ¡Íg¼NxÁ¹v•Zùî1~­E°Ï%ß¨sûéçƒ[Ÿ´c‘c®D¡§a‚R`/:€/)2ìÙšÇy)‡¢Œ
çWKçuIçM¨Šµ¯?3¡d:n,G8¦*¦óóÇø{(så)|_İÌ˜o;ÅX:„%}"Y8Qš^(§ÙHqĞlkj0Á@Ç-gã0D±èÑÉØvÂ¡cjko#DÒêÏÇdÀX74€i ÔtKÂA!–U{Î•O£¿“¡“¤N=åˆ\6X3L	øËœ>âëÍşÃÁ<]ˆã}%W{ wÊœhÁÿÓ)w?¿TE‡Ÿå†—Ë¢Ìy¸{è€ÒV”j:Ï¤4!|)C«“Íô5û3X)À¤À?:fªsşXözÌÓç+LäÒº ÉÀo¹“ND[é
Ş`¡5ıÁÜDé·•³¨³¹­IçÂù.‡7„/Õw4[ô]µ:2XéÖ]n;*uÒQğ.Z˜øQH ày5éÕzë\¹kªq«?h^*Yí^ch}W;ÔlÂÌ˜;Ôé»UÑ`DÍß£gæi‡Oë‡®÷m^?ÇZm«¯·¿3hŞÃoòü›»çv$ü¢Q˜ˆbö£Ìw¢¤ãqª
»»»>t¾yDƒŸá©şİİİ{tàìíïî‡{x´wàìÂßv¿qf°;Jo¨©éåïMÇRFWôÓ”Ãæ¦½ÇNÏöwìî>~òèŞş®ãcöñg{‡<~ˆß‰ú»Ã½£}üîĞ9}ñãÉ›¿(;y¶pøøñŞîşã{ûÕ÷a’>Û{²¿¯ïŞ@æë3J<Û¿wÛC¿{¾YŞÿõ®ßá„Qíÿÿ†¿ÿqöÿßòşÇ­ı¿wt´ğó‰Ëñı÷Ü=wÏİs÷Ü=wÏİs÷Ü=wÏİs÷Ü=wÏİs÷Ü=wÏİs÷Ü=wÏİs÷Ü=wÏİs÷Ü=wÏİs÷Ü=wÏİs÷üÏ|ş?MU·   
