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
      exit
   fi
   
   DIALOG=`which dialog`
   if [ -z "${DIALOG}" ]; then
      echo "dialog is required"
      echo "hint for OSX: brew install dialog"
      echo "hint for RedHat: yum install dialog"
      echo "hint for Ubuntu: apt-get install dialog"
      echo "Windows? ..... format your hard drive and install Linux"
      exit
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
   
      dialog --title "client id" --backtitle "Portal Local Install: 6 of 10" --nocancel --inputbox "Enter your client id for Portal" 8 80 ${CLIENT_ID} 2>/tmp/portal-install.${PID}
      CLIENT_ID=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}
   
      dialog --title "client secret" --backtitle "Portal Local Install: 7 of 10" --nocancel --inputbox "Enter your client secret for Portal" 8 80 ${CLIENT_SECRET} 2>/tmp/portal-install.${PID}
      CLIENT_SECRET=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}
   
      dialog --title "API Server" --backtitle "Portal Local Install: 8 of 10" --nocancel --inputbox "Enter your API Server" 8 80 ${API} 2>/tmp/portal-install.${PID}
      API=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}
   
      dialog --title "Portal Server Port" --backtitle "Portal Local Install: 9 of 10" --nocancel --inputbox "Enter Portal Server Listening Port" 8 80 ${PORTAL_PORT} 2>/tmp/portal-install.${PID}
      PORTAL_PORT=`cat /tmp/portal-install.${PID}`
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
         exit
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
      exit
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
   mkdir -p ${PORTAL_TOMCAT}/{webapps,logs,bin} ${DEPLOY_DIR}
   if [ ! -d ${PORTAL_TOMCAT}/conf ]; then
      NUM=`grep --binary-files=text -n "# END OF SCRIPT #" $0|grep -v cut|cut -d':' -f1`
      NUM=`expr $NUM + 1`
      tail -n+${NUM} $0 > ${PORTAL_TOMCAT}/tomcat-conf.tar.gz
      tar -C ${PORTAL_TOMCAT} -zxf ${PORTAL_TOMCAT}/tomcat-conf.tar.gz
      rm -f ${PORTAL_TOMCAT}/tomcat-conf.tar.gz
   fi
#   find ${PORTAL_TOMCAT}/webapps -type d -depth 1|grep -v portal |xargs rm -rf
   if [ ! -d ${TOMCAT_HOME} ]; then
      wget -O ${OPT}/apache-tomcat.tar.gz http://apache.mirrors.hoobly.com/tomcat/tomcat-7/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
      RET=$?
      if [ ${RET} != 0 ]; then
         echo "Failed to doanload apache-tomcat.  Exiting out..."
         exit 1
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
oauth.client.id=${CLIENT_ID}
oauth.client.secret=${CLIENT_SECRET}
oauth.redirect=http://local.slidev.org:${PORTAL_PORT}/portal/c/portal/login
sli.encryption.keyStorePass=changeit
oauth.encryption=false" > ${PORTAL_TOMCAT}/conf/sli.properties
      grep -v security.server.url ${LIFERAY_HOME}/config/properties/sli.properties.template |grep -v api.server.url |grep -v oauth.client.id|grep -v oauth.client.secret|grep -v oauth.redirect |grep -v oauth.encryption|grep -v api.client |grep -v sli.encryption.keyStore >> ${PORTAL_TOMCAT}/conf/sli.properties
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
      wget -O ${PORTAL_TOMCAT}/webapps/portal.war http://downloads.sourceforge.net/project/lportal/Liferay%20Portal/6.1.0%20GA1/liferay-portal-6.1.0-ce-ga1-20120106155615760.war
      RET=$?
      if [ ${RET} != 0 ]; then
         echo "Failed to doanload Liferay.  Exiting out..."
         exit 1
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
      exit
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
         exit
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
      echo "######## REQURED if this is your first time installing Portal on your computer ########"
      echo "Please run bundle exec rake realmInitNoPeople"
      echo
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








####################
## Main functinon ##
####################
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
      [?])   echo "-a Fresh Install (equivalent of -p -d -j)"
             echo "-i (interactive mode to setup Tomcat and Portal)"
             echo "-p (purge opt directory before install)"
             echo "-d (drop and create loption database)"
             echo "-j (update JSON fixture file then update mongo)"
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
   echo "Your lportal database has been newly created.  This is very important that Tomcat server needs to start \"TWICE\" before you login to portal"
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
echo " Location of Tomcat Web Apss Dir    : ${PORTAL_TOMCAT}/webapps"
exit




















#### DO NOT DELETE LINES BELOW #####
#### IT CONTAINS BINARY FILES (TOMCAT CONFIGURATIONS) #####
#### END OF SCRIPT #####
� ��P �}is丑�|�_Ak���c�:��t;4}x4�W�43�z7&P$���&�:������2 ��*���%��Ű�UU2$y!��(E �?M��l����}����cz�O�����ឳ���{�����݇��������8�͠�~JU�P)R%�Ӌߛ���.�=(��M={O�2���>z�w�����{���_��|�wpxp��h��~'Z�=ܿw��y{��ѧ�?����s	o�I����ᓧ���:'��ۿy��<�?8|�dow�ɽ����0I�����?z���c�N�09���mO���w�ΆaT�������������C{���?��y�a��������C�(l<�
����=>���w ��how��������w�<\�����8���~p�ٿ�����7t�����?|tpp��o�Y����/K�П����xtxؗ����?><���7�\���=�=س��OW����������������:���������������ˍȺ�_|���8oC_&JN�:�X:G��៓tXLE.�7i���;��N�<p�̝4�N�;q��{�R������"ݣ#F���L
�9Ή������/_;�0�N*��O�b��P9�4?w�Е�A��	�"ֈ�r$� LF 7���h\8�4�����ݜ�HN�T�(�/A�q�--�0#6���� �}o����l�_��əC�X̝$-�R�F�r�ˬ T�8�B���1����L'�𾠑8��p]h�m�E�lgg:�z�0��|�S
�U�v�qX=��qy����6�u\�_¤ϝ����
"�5���\2j.`G�[=0;�%a�6�!M��t
d�!f�� �Ob�(�����^f #Q%)
g��F� �5s�n�ʗ߭�:ʇާ����-5.� ���\]��E�G�x	�ަhM�B ����_��;*�0��~��mvHjYuv�Q�ɼ�v �Z� n=�ɾg\��t�"��w� FP�*m��I���J� ڏ2��(2o��r�O~����k:�~;=~�z����)H�	i}ДT ��HГ_�$�nk�ATn	��>�8������i':?�V�x���<qZ������4	�	�&R�MT	"���5_퍼Zݓ3J!�7K��s�L�dEy��2��"[�B���W���
0��Y�E'������!΀�*���ï�p�߿iu�z��\���㠟� ����沢�l%��]��eج��H��B�c�[!�T�D���g���@�(���@��r�U��@�yH��~�������r�D�R��L{4���J���m'�`��R�Ҷ1=%KT��c��c��PoԪx��V�X�l�
M�H�@���\�^v�Pr�����ym>1��7!RhX:�a!�M L�(�Hd#�:��C�?%A��d��8�J[̚��(/,���!<MQ��ʼ�}����1nz[4:��ᇟ^������$-s_�A[�Ls\�X��y�J$���HCI�߽g��nX:�: ���}w�Nf�����f�ÉsRYLҐD:m�v`S��_y��|�����A�������U{�D1�~/x,���Zş~yǻz��5���Wx��̣kuC�˘*s;����x�9kw�����F�����r��aBU�L��޺�\>
��[kό�vNÉ��G'����w~���v�XQ� (�W���j�u�-:-1�@a,n;��fa���#jaPB
5�35Ԧ`��a�����QſU ���;_$4G�E�H�zAh)B��D�bt=�m۱L[Dw[��xH��:�	Y�c#��7ƕAQ~�޷�c��1V�m���Ec���z�z&��U84���8p���Y���ve$�foP��4�BWPh���fYï,�-�t�`� ��h�8� ��A)��X��F�&]*۸~e�p8����g��l5g;?*q�B[E�<�H�t$��3�i�j�%��hT80נ�k}��TY�@n���u"�)b��",�M��4LR&(ʱ9��?�iwK'J�t�:_!�(<בUT��axFΨ��`��'��������̷}�&��[s;�q�
/��V$�9J~�죤j��O��~�%��(�<{����?�d7eK{�JxřZ�g��]�[�yZ�MB^��g��������w�]K�%c\�C����^y�����_r���Wmm�>��_�������s3��������:���_��~�\~�ko�p�����û�_7�|�q��[��_߲\�����׷<W����ͯo�%>���	ǭ�o.}}�w��[�+_�v����{����(�h��$��"����Q��~FeVǾä$#�b�|�D"W�4�%r�cʁt�%�o�2;V�?7�#m$.�������j���6��G3��X(�g e-l{�̏�n�\����Μ��2���l}e�۫N��t�_�a����� [J�Y�9X��m/Y9.��!��qb5r���ޡa+��E2��Y\���տ��D�/bS���^yR|��)	ceF����捗���җf�pyp�z�:S���P��2
(��,�^$  ����8KUHf�b ��`_������Ŷ��� ���TG�N$��#�3 �t�M��˻ʟ��C	Wx������$��ڨ����5Lӭg�Q`"�i��
��ic1�F���(W7D� �>��l+�`�#�g:i=5��@"o�1�.�M��#}�6�um�)
�}���P"\�_����!����d=Q���9I��B��_�$`�#�6F���OesS�)]�Z��f�t� ����-�C?$� ���L�J�����6�-iRA�c�Q�$F@X�_�Д&]��Wd���>�휾}e���$Q81(�4���Y�y���*�(T\U�������(9�dARp�?T@���/xW����BP�I+�-�jQ*r�:)��/0rD.�j���z��H���Oh~iA�izrf���^��������[���yzI���L+���3����+����W�^�|pA�l1^z�2X݇����Hc៹ߙ��d����Hz�o�����8KZ]�,��_��$�lM��J�|5�W�:K�`�]�� �=g���ae���S����o��)������m𗿊"�T�-u�s�~9A�D���*3���=���4��a������7���r�����4����T�?G2O�0N]�0�<3�� :<��T���R��@:����;�ן�@�y��|\$�W ^z��
��1U��
��KE�63���JA���,�>R�!0U}�4^@��D��i���$ѕ�!�ə/��tf#�w1��z�����W{{�1�[�r�Q�;��0Vߢaf�s�Q'~f��d�7�ۗi.�� L�`��
��:D�| �UV������>�"�c�#	��7���}��S��<�K<�>�O[w�F�d�2�/_H�'����k	iqVy-<(��~�%���9l]}k5x^�%(䗽��Aj�:��09��=9��C2�v@����_$��������nnv
��������n�!��ޝ���|��o�~�\�����h9��C�����6�|�gXt�\�z����bX�p�=�����d��/�}�;׽�p�
&_���+t�|���й��Ф�pBO���)t�<����������R��W-qe=�kч�&���=��?/�*Rǯ�)AYCkt#�K�
[���t����
pP�ҿ�Y~���:S
���P��W�L2$rP[�DM�cgA?�ȋ&�K��U

����裒�:�lsb�I���}�\�,�s� V�Vtk�5�S�l5,<�Bf��l���Hj¦�g3���ԔmTcԪ������A���BӐ�{^�v��U�X�t��C���N�/���í�ag�C�˾��c��i�aD2	� 
X�qˁ"�TE���6�b��с窎	/�<Y{|,���3Ώ����g�u��@t��D����
��>>X��觏΅݉��&	��	}Q؁�VV���+�ނ��Ù����-��Hil��>�m��;[�i˴)gu�-#����O�Go�������6��
.����Q�H���j�Yc�y�DKM�
CQp!�X�?�����:�CxG<
JEk<Nߞ\`V�.������K�O���ZAx�3�C>�h�49a�h���)_;��s]ƹ��n��:�@� oɆU)he��v�?j}r���rY�	�"8D�\UD�/��K���6Sg���x��M�s=��q��`� �T�?�
7	��+a
�^��]z�J�U���)E+���:�ğ`w�fv0�.\`D�����s�Ҝߛ9[:��[H���-�}C��jϷ௽�%�`:���zq@S��lc $Y2]]�sd4��'&X���!WM�09�������j=Ѧ�9A$��9 Ŵ�.�C
�P�`�.��G�9�����}l���U�&��w����ƃ�O�o3�*l�+�E��)f+6�f��}�_�>)�ʋ{�=!��$%�<�&_So�]9��/6�$�oM�2�[� 	@�ޱ���:eإ��E}H.������k�t�8��I�]q@�f������'ZY�j���Z�<5�y�y})�596Nj=�������EH#�� �������}���p���2-���\���^9��8�է��~�7���<N�!����M]��F���u'�
����y>}�p��z�%h�+�g���;H����G��ݍ���S�/��%�����}���G�w���xn(������u>kM��0��?^����x���ϝ�����������5�4������N�B�zذ3U%�L�cwT� 󦑬)!u0�.�/�9�Q��ZV����hn��k�[�h��I&z�k޵�C9�@���0�V/�,��,�AX�۝ƾ4Z�C�T%��/p0U�Z}-�ѷi�Msx�c
����:�:�mm���k6z@hK��R&]���R�����{a�ne�#CҖ���빆�4�E�����g~��U�T7��j�
~/��Y�}�9n�[y�����_,9+�����kuM	�3[���{�0�&T;�ޅA�oq!��&Mzl�g朦��g��nM���XT���y��Z�a�Xbj/¥�	�N�8�s�
�V�f��J���H����IXtM,���j$��p'7��F���kY�	�v��%s�A�~s͏:��^����&��6S:��^ބ����U���_�"����9/����������!>����#m�^2R�g8ARH0c1	�|Uuܬ���y�F���6�8�뻷h# �?􏙘~�De��F�XJJe������(N��&唘���{�9T���p-����X���X���^��r��fu�5K���%s�9O��6.����@.,�y��(WZ��ރ4_"i;F'�2Gz���>�d��72^��&r���ԟ96
x#�Jَ����~���v�e
�~�>���Ty��iѣn���'.YI_��]�֠}���fݫt�ح���v�A��b=1 ������CLFWf/���Y�ʄ��ز�UՎ����W�-͐r�Q��S"�M�c��*nQ��_]Ck��Z�Tv��\TΪh�ݲ�Tg�����Du`�;�Le[�ږ����������2�[�g�'JK�p"�0�H���ҬbrDv������@#*�MU���S��(�Ȑ�qS�>���[E�1hA$�����Q]���T)%ZlĂ����â�x��.�SG5DP��Wף1	@��ͮ/�D�q���/44]΅�A���=ϵ��oe�m��/V�7?^*�x~��4R�ŸE���\+�F�S�a�J�Q�H8ؗD�́���^�U��O(���)�Ig�Ҙ�
Ъ�u��/���*)�
�|�9��z�x�ڿ.l��}I���I�Ld��׳,�,of'��Leϲ�/�4nYvϟ�0x����ӗOw�������ޫ=����O���'��>}��������i�����\��O�7b�J<m����}"^������ϧoV�>.{��Rf����ߦ�~�9��Wh2��Fb~Uw!N���Q�VF8��e
��u�G�7uU���[%`�lwb�ON�Dnd�R�Sݢ^�g�t�Z���9G9-��L�Z�$���}��IZ��ww����,V�1hy&��~�O�i�P-�e��6�h�^���ÇHl!�V����g��V�<����וY����ȶt���=/���_;NV�"�����?�2ɵ�mA�W
go��9C+f
�/���B��!����*��tJiˊh1��(nW3_�j�o�A������:7�"�~��
KA�@·�eן��i4���L��q�kZq���L���"�����^��"�g�uf�����m�k�Y��?.]�,���>����A�U)c�Ƙ�DaLv�Þ�s�Ї�����Hh8PA0�	������ac�����ЈS�����& ���U������`�FtǷS�K���j쇟�Ӟ����<
��}�Ӆ�.@j�1FmA�]�wq���դ;j�8���ě�M�_t�_)����b�U�[����eJL��JG�����8�z�w����-�g�j�\k�.:B56�h�^rv���^�T�B/�7�����p�?�b�J]���m���B�����~�L�=���W6R���%�����ZO���t�n#w�o���
<N��X�cU�G�6���/�Va5-'���%��P{
�
d!.��~O�W��ZI�4;�(K��O�sɳQ�
��I~�ש�B�Q=s��15��e\�9��.�y�9����;͏mZ Z��b��G}Ul/�5Q���k�]���㪇ՠ8�
{��eƌ6����s7Ꭹ��&����ϷȨ� -�pcj�&�c�J2���V��������
}W@�m�n��PTm )����*!%����J*�D`cv��d�_I�z`��4�[i}��_P�Iw�Wq=W����KR���*�<�]����:���Y���O5�/���R��4��$s��L�j�TV5�;�x����u�1d u,���c�eE�k���u���V��-���d�IC���3jEhoV�o,��v�E�f����[��"�����_��X�c,;�;=��CZ���m��}l}����;+�Ez���c;U�ƶ7e��#�(�y�sޤK��i(��a���$@S��%[:�Ekף>Ƞ�T�RV����R��C/��2)N$v�Y�v�(B�z �Η� �Gѭu�qlӭ&-�nS���@���SU��f�W�庶ץ�@׶�.���m��ը�#,�"g5�ӑUY�c������=��e��������w�o��\��񬆽�"5����݃?�d��]D�]D�M랻��K�
�/�^W�
g�>�\�c�N��L'Y��V$�z5�
P�d^��`��[8Ks�[f2>+��`�FZ��/7����zN��O)�	���8�ll!�<�������<jDb��l̅�В+A����0���p{�P�|�J��k��<��υFh�!SUh	�
�|�v�~�EY���
��Q�\ʒ�����?�1�j��ɥ�BOv��`�b��'��&��e	.���@���Q�������mz�����[0�6��L�����D�qw��2���1�Lt[Z�������AY���;��|]�M�T'���(���К5a�D^�D���ӑ����:1�r�|(+fa�}nm�����;���� l� !{]��P&"Y|�sn�@��T���������)�p�U!k�~!6<���� �AsSk��ԧ�`6$����I��Rf0�\���[����Ly��(�Ri��2)���U�)��4�wh��G͘���g��@G@/��b>��:��1���:I��ڗY�����,�"��F�[�:qy�N0��
5�>�e�u���{ :9y�22l$�D �Á�v���RyԒ	�BD��C!r�J<�r\rl &qZ&VX��\��Vξk����'��s�XxЌs
��Bp�4�.u��ǀ͛��o��,9- ���+�\j��g�U"��M�/Ը{�M�ޘmȥ��	��g�
�6.C0�s
�2�6>.��p"r�apI���Va�������̬L���eVZ�]�>c*e��K�H�%%�'1vgl]�"S�1�-��,����6T�%�.�3���MpᙕfD�3�fCQ�o��o�K[N1ź�C�:D~ɰ�J4(و���$$x�/��^`����W���-�^������i�*���5�v��P� �X�m��on*�{Ԏ��:����"Q&�U;	��n�� #1O�B�+}��ëD�չ)G\��pdyۃ�p3�\��2�0�r���[�ܹ����z7�S����ʭ8sg|y��Q߂��M&����l*�Ⱥ&D�9��<j̈́G�&b�h"���#��]UF��8:H�f\�#��e�%�W��]�����&�a�C�z�(��� �v:_6#�f=obӰ3.6-����]��|o*�8ʄF�zK6�¾ �0*gX��c�	1,��gX&�rq?�!|Ş|g8�\��ן^�k����l�`��:�;�:��/sN�{�o-�d�Elz�i���at0\�ytp�As^��ߥ�i:���}}5���UPD����h��bP�B�U����:�^�+�U�e=b�5��w �"��8X��	��uBi@e$�����5E�VW{4����ɘ�pԷ8È-[�Ȯ�nc� &$EX�]��Pw*���R*���J��Yg�x�Ȭ���H:g��;�|�� ��3|kI�~.����GlGcn�Hn��;-W1���"?�-�z0�#��3L5��X�dF�]��M[�����&C
���)���V�rfT�R�2�)Q8(M�����B��"��N�{q�r9���`S��UD2	���;w�,��r�i���H�^�X$�9�����`.N.�F�sɵu@���Z؄&��K]vךZ�*͕��
G�1��.�F��������>��χ���d�}b1l_������ٲ*�v���MGj�?��9s�Rp~�!��uJ��[E -��	U�B
W��b*r��Nx�Ɇ��0
s��*�d���p��
��mа�ϣ�*X1�d�U�0�e>	�}��3!b]���W�3�i{��B�L���XzПH�i��I��ֈ�����&���+@�	'\��K$���t��9���,�/΢���������=��\��,�-�Gk��\F�YX�gi�
[rd�i��6 x�낗��Ɓ�
�Nn�}�g�˺# *����qZ��e��u�۰�jg*�T[�Vl�3���x�{�t4.�7���r}1Ѵ�AchN8�4]�U�?���0PY�s���P\Q��"�J�c��`p[E���+��<��݆	�M�<�&Y�_q�bZ��
���A���~wJ�5��8
K֎M8i/���ob3ڻ�b�R+��}F<�6��� �ùT�c�J�q�MFS�
��1޳�A�E�b�bJ��V�^�Քͣ����Y{��λG�a��>�
P��;��K�[r1���5�_���
�ot���fVk��MV8Y�;#��$^��\Lᕋ����fU�^ԏ��q�ruk����w��;����8���8@J]7���(>�<]��!�Ǆ�!k@��	��Rc)/Y��v���N��Q�`>H@\�oA:�
"��nd�@��Db�������C]H
v�^'#��aXK0e���
�b.��S+�j�4(f������A�\��if!@ׁDĕ&ͭ�(�ICC��_��&{��T8�CA�i.QlG�f�Y���;㤚�*�}u!Ὁ��]�a�nz͜S*�ft@���	�x��Ӑ��Fa�a�2���@�lzΆ4̖��=��:ÆF�T�ŬElhL�Nt�K�`g�3����}&���ӑ��/���Lu�"S�'�\f�g�4;��W��l�J̅�#t.�@��2��?v�>�(1{l%�h<�76�Vv�
��Xp���y��!g�]�Oz��[����ϖ�z˄�Up�v<XD����(!7���ԍDΖ�.������QK&��L:'S$E�Ƅ�n��d�P>���>��/|8
��*Kz���@�z"�<󒞬�=�8��
�*h	ۮjτ͕r!��!K9'��J]�^����S� ����vD\F���8��f�j��Z�Sy̞�,לPa�����S3�瑱�{��YVP����ic/Sפ��T�t�1ZQ��y� ��:Xjv]�ڜ��-��*[,p����9mevqi�`���5H)Bm�KI�G��3b8P^F|�S;�]�
��aƶ�յTI�]�T穾�y(�t �l�)�^�S�.\�3�0)�gKl��s��؄11+z�_fR���vlf��:�4�B5f�^��r�,o��`Cdj��� ��Y�a�z=6���SQ���c�ܣl/�g¤罇1�0a��^Wҹ�(=�HB�X�σ���J���``�Y`0��E~�׌��t�-@��B�S��L����a����Н���`O��ϥ���g(�s���SkEnc�̬�͡��,�}���P�jh%��:K\8P#����(�$t�PNh��iL���Kλ+���%�p���
���I#J �ǜ���Z0�����L��o��Hc��|�b%����$!�2\�c.����KɅ��w�d+K]�ץ�6L�6htAu*Q�E�����RP�C� �`ܩ&ar��B�ywi�et�`��\���i��@����A�*ÝG��e9���TX1s�Q[,F֮�5|�E�-���YL�!����4�	��6��e�%�G���"
�؊o���ŧ߹no,��>su9O`��֭���J*��Њ]�5r��I*�:��kZ�Оn�J b}2l
+�5gQ�!�(��5|.Ǎ�W��S����^�c�ng�
��W�	=�/��:߆n{v7p��
{��A����X��E��*e_����.矑s���E�
���ڧ���y�QK&�L�tw䱖|R����P����Fwb�Z�&�fP�_Vio�-�<L&���T�Z�И�Yh���ܺ
��_Ն	냍�R�%�!a�Mآ�K��kE�����y�p#p��i˃0�>�`;�4��q�O�D�CNe{j-2�<T�Hd1M�s�Q<�̮%\�aq-��
�b?�]�?[��B
l I�19�;6��P���:�8��i�٩5�(X�kP.�VsO�1)#|��VQ�w��v�ڑ�8%�-�¶�̀K�x��c�X����(ƒ-�W�\c�"�$v�,�����7´Ype;=0�����7��v�Z��Q���Biq.�svy�a���mg嗇{d
[t)E�&{�e>�+���a¦v��1ϡ*D�ɀ�
C�:3���W�L�@��;Q��Q�9Ǫ*pl��������؋2����.U���	�O��n��!co��$��~QQ�d�&�άݢ�<�d�������8�(�q�O1��@Z���H\�(�rhM�Є��]����^��Y�g�C���%a1��!���pH�K�aF��;ud�<�����/�
޳}��s3PN&�g�l�-J����#����_�����3�������o���&�M���������| X�>	�2Q���aȖ}P�/O��|a+
1&v�f�
��̣p4.\�v�ofٌM�����v�&u#&��������^�)�؜N�n��6>�`&Ȍ�8���|��A8�(\��<����H��gv�)sU��
��
���fwp!#�+��>�\�%��D��4S���4�Ddh�M�I-����f|w�fc��c�ؼY��Z�E`b���zߌ ��|	:f�u>��̗l#��U�@�l� L6T�gfod��+�W1)0cp'�&5��@IR��Q�}��%�6�s�)��R�slpg��>E!7�W_�*1��VҾ���J2����<��Ŵ<��Nq�lWi���*Gl1���N�OY����
�W73��N1�N` aI�HN����i�R4ۚL0�q˙��8L�Q,zt`2��p��������10�
0)�����?������
��.@2�[�S ��V����X(dM07Q:�m�,�lnk�ùp���