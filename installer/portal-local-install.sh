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
   if [ -f ~/.portal-local-install.env ]; then
      . ~/.portal-local-install.env
   fi
   if [ ${INTERACTIVE} == 1 ]; then
      dialog --title "liferay git repo" --backtitle "Portal Local Install: 1 of 9" --nocancel --inputbox "Enter location of liferay git repo directory" 8 80 ${LIFERAY_HOME} 2>/tmp/portal-install.${PID}
      LIFERAY_HOME=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}
   
      dialog --title "sli git repo" --backtitle "Portal Local Install: 2 of 9" --nocancel --inputbox "Enter location of portal git repo directory" 8 80 ${SLI_HOME} 2>/tmp/portal-install.${PID}
      SLI_HOME=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}

      dialog --title "Encryption directory" --backtitle "Portal Local Install: 3 of 9" --nocancel --inputbox "Enter ciEncryption directory to install" 8 80 ${ENCRYPTION_DIR} 2>/tmp/portal-install.${PID}
      ENCRYPTION_DIR=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}
   
      dialog --title "TOMCAT version" --backtitle "Portal Local Install: 4 of 9" --nocancel --inputbox "Enter Tomcat version you want to install" 8 80 ${TOMCAT_VERSION} 2>/tmp/portal-install.${PID}
      TOMCAT_VERSION=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}
   
      dialog --title "client id" --backtitle "Portal Local Install: 5 of 9" --nocancel --inputbox "Enter your client id for Portal" 8 80 ${CLIENT_ID} 2>/tmp/portal-install.${PID}
      CLIENT_ID=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}
   
      dialog --title "client secret" --backtitle "Portal Local Install: 6 of 9" --nocancel --inputbox "Enter your client secret for Portal" 8 80 ${CLIENT_SECRET} 2>/tmp/portal-install.${PID}
      CLIENT_SECRET=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}
   
      dialog --title "API Server" --backtitle "Portal Local Install: 7 of 9" --nocancel --inputbox "Enter your API Server" 8 80 ${API} 2>/tmp/portal-install.${PID}
      API=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}
   
      dialog --title "Portal Server Port" --backtitle "Portal Local Install: 8 of 9" --nocancel --inputbox "Enter Portal Server Listening Port" 8 80 ${PORTAL_PORT} 2>/tmp/portal-install.${PID}
      PORTAL_PORT=`cat /tmp/portal-install.${PID}`
      rm -f /tmp/portal-install.${PID}

#TODO
#update build.xml
      #dialog --title "Portal Deployment Directory" --backtitle "Portal Local Install: 9 of 9" --nocancel --inputbox "Enter Portal Deployment Directory" 8 80 ${DEPLOY_DIR} 2>/tmp/portal-install.${PID}
      #DEPLOY_DIR=`cat /tmp/portal-install.${PID}`
      #rm -f /tmp/portal-install.${PID}
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
      dialog --title "Deleting ${OPT} directory"  --backtitle "Portal Local Install"  --yesno "Are you sure you want to permanetly delete \"${OPT}\"?" 8 80
      YES_NO=$?
      case $YES_NO in
         0) sudo rm -rf ${OPT};;
         1) echo "${OPT} directory not deleted";;
         255) echo "[ESC] key pressed. I am exiting out"; exit;;
      esac
   fi
}

function check_opt() {
#shell commands to prepare portal environment
   if [ ! -d ${OPT} ]; then
      sudo mkdir ${OPT}
      sudo chown -R ${USER} ${OPT}
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
      wget -O /opt/apache-tomcat.tar.gz http://apache.mirrors.hoobly.com/tomcat/tomcat-7/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
      tar -C /opt -zxvf /opt/apache-tomcat.tar.gz
      rm -f /opt/apache-tomcat.tar.gz
      if [ -f ${PORTAL_TOMCAT}/conf/server.xml.template ]; then
         sed -e "s/{PORTAL_PORT}/${PORTAL_PORT}/g" ${PORTAL_TOMCAT}/conf/server.xml.template > ${PORTAL_TOMCAT}/conf/server.xml
         rm -f ${PORTAL_TOMCAT}/conf/server.xml.template
      fi
      ln -sf ${TOMCAT_HOME}/bin/catalina.sh ${PORTAL_TOMCAT}/bin/catalina.sh
   else
      echo "################################"
      echo "${TOMCAT_HOME} exists"
      echo "Skipping downloading apache-tomcat-${TOMCAT_VERSION}.tar.gz"
      echo "################################"
   fi
}

function set_portal_env() {

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
      echo "api.client=apiClient
api.server.url=${API}
security.server.url=${API}
oauth.client.id=${CLIENT_ID}
oauth.client.secret=${CLIENT_SECRET}
oauth.redirect=http://local.slidev.org:${PORTAL_PORT}/portal/c/portal/login
oauth.encryption=false" > ${PORTAL_TOMCAT}/conf/sli.properties
      grep -v security.server.url ${LIFERAY_HOME}/config/properties/sli.properties.template |grep -v api.server.url |grep -v oauth.client.id|grep -v oauth.client.secret|grep -v oauth.redirect |grep -v oauth.encryption|grep -v api.client >> ${PORTAL_TOMCAT}/conf/sli.properties
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
   else
      echo "################################"
      echo "${PORTAL_TOMCAT}/webapps/portal.war  exists"
      echo "Skipping downloading ${PORTAL_TOMCAT}/webapps/portal.war "
      echo "################################"
   fi
   if [ ! -f ${PORTAL_TOMCAT}/bin/setenv.sh ]; then
      echo "CATALINA_OPTS='-Dwtp.deploy=\"/opt/tomcat/webapps\" -Djava.endorsed.dirs=\"/opt/apache-tomcat-7.0.29/endorsed\" -Dorg.apache.catalina.loader.WebappClassLoader.ENABLE_CLEAR_REFERENCES=false -Xmx1024m -XX:+CMSClassUnloadingEnabled -XX:+CMSPermGenSweepingEnabled -XX:MaxPermSize=512m -Dsli.encryption.keyStore=${ENCRYPTION_DIR}/ciKeyStore.jks -Dsli.encryption.properties=${ENCRYPTION_DIR}/ciEncryption.properties -Dsli.trust.certificates=${ENCRYPTION_DIR}/trustedCertificates -Dsli.conf=${PORTAL_TOMCAT}/conf/sli.properties'" > ${PORTAL_TOMCAT}/bin/setenv.sh
   fi
}

function deploy_all() {
   CLASSPATH=${LIFERAY_HOME}/lib/ecj.jar ant deploy
   #temporary until DE1385 is fix.
   rm -f ${DEPLOY_DIR}/Analytics-hook*.war
}

function deploy_individual() {
   COUNT=0
   LIST=""
   LISTS=`find portlets hooks -type d -depth 1`
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
   if [ ${NUM} == 1 ]; then
      deploy_all
   elif [ ${NUM} == 2 ]; then
      deploy_individual
   fi
}

function deploy_portal_apps() {
   if [ ${SKIP_DEPLOY} == 0 ]; then
      RM_PORTAL=0
      if [ ! -d ${PORTAL_TOMCAT}/webapps/portal ]; then
         cd ${PORTAL_TOMCAT}/webapps/
         unzip -d ${PORTAL_TOMCAT}/webapps/portal portal.war
         RM_PORTAL=1
      fi
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
   rm -rf /opt/portal/
}

function update_json() {
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
}

function start_tomcat() {
   export CATALINA_HOME=${TOMCAT_HOME}
   export CATALINA_BASE=${PORTAL_TOMCAT}
   ${TOMCAT_HOME}/bin/catalina.sh start
   unset CATALINA_HOME
   unset CATALINA_BASE
}

function starting_tomcat() {
   TOMCAT=`ps aux |grep "/opt/tomcat"|grep -v jetty|grep -v tomcat`
   if [ -z "${TOMCAT}" ]; then
      dialog --title "Starting Portal Tomcat?"  --backtitle "Starting Tomcat"  --yesno "Start Portal Tomcat?" 8 80
      YES_NO=$?
      case $YES_NO in
         0) start_tomcat;;
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

check_dependancy
set_env
check_SLI_HOME
purge_opt
check_opt
database_init
setup_tomcat
set_portal_env
deploy_portal_apps
update_json
starting_tomcat

echo "#####################"
echo "IF you need to setup Tomcat for Eclipse"
echo "Append following line to Eclipse Tomcat 'General Information'->'Open launch configuration'->'Arguments' tab->'VM arguments:'"
echo "Please make sure you select 'Use custom location (does not modify Tomcat installation)' and set '/opt/tomcat' for 'Server path:' and set 'webapps' for 'Deploy path:' before saving it"
echo "https://thesli.onconfluence.com/display/sli/Checkout+and+Build+Portal and refer 'Option 2. Script Driven Install'"
if [ ${DATABASE_INIT} == 1 ]; then
   echo "Your lportal database has been newly created.  This is very important that Tomcat server needs to start \"TWICE\" before you login to portal"
fi
echo "############# BEGIN ###########"
echo "-Dorg.apache.catalina.loader.WebappClassLoader.ENABLE_CLEAR_REFERENCES=false -Xmx1024m -XX:+CMSClassUnloadingEnabled -XX:+CMSPermGenSweepingEnabled -XX:MaxPermSize=512m -Dsli.encryption.keyStore=${ENCRYPTION_DIR}/ciKeyStore.jks -Dsli.encryption.properties=${ENCRYPTION_DIR}/ciEncryption.properties -Dsli.trust.certificates=${ENCRYPTION_DIR}/trustedCertificates -Dsli.conf=${PORTAL_TOMCAT}/sli.properties"
echo "############# END #############"
exit








#### END OF SCRIPT #####
‹ áçP í}isä¸‘è|î_AkÖÏÝc‘:ûôt;4}x4ÛW´43öz7&P$ªŠ¯&È:Úáˆýï¼ú2 ‹¬*‰„”%õ®Å°§UU2$y!ó£˜ý(E ó?M†ßläÙÝÝ}üð¡óÍczüOõïîîþáž³·¿»{øðÑÁãÝ‡ÎîÞáÁ£Çß8³Í Ó~JUˆP)R%ÎÓ‹ß›Ž¥Œ.é§=(‡ÍM={Oœ2žïï>zºw¸ûäéã{û»Ž_„±|¾wpxp¸÷hÿÑ~'Zß=Ü¿wðÄy{üÃÑ§—?ÿòÚós	o¤IýÖþáá“§îí:'ðÆÛ¿yœ<ß?8|òdowÿÉ½ýƒêû0IŸïÁ²ï?zòø c¾N¢09þôÞmOÐÿòwýÎ†aTûÿ¿áïœþßÿ·¼ÿñC{ÿìí?úÆy¸a¼èùßÿ´þëCà¥(l<Á
£‹ÿï=>Ðë°w ëÿhow÷ŽÿßÄÓÉÿwŸ<\æÿ»÷í8û“Î~pÇÙ¿†‡öµë7tôæÿõþ?|tppÇÿoâYâÿ¾¡/K£ÐŸóÀ€ùxtxØ—ÿïÂú?><¸ãÿ7ò\…ÿï=Ú=Ø³ãÿOWøÿÞÿÿÚÿÙõ‹§ÚÿÿýÍ:þ¿ÿøááîÒþ´·¿÷³ËÈºç_|ÿïì8oC_&JN‘:ÅX:G™ðáŸ“tXLE.7i™¤Ü;÷NÞ<pà£Ì4‘Nš;qšË{ÐR‘‡ƒ²€ï"Ý£#F¹”±L
å9Î‰”Ôýû§Ç/_;Ã0’N*Ý OÃbŒãP9Ó4?w†Ð•‚A‹È	ø"Öˆär$ò LF 7›çáh\8é4‘¹‡™‡ÝœâHNÞT¸(Ý/A…qþ--Í0#6±íüý ”}o»ºïl™_·üÉ™CëXÌ$-œRÉF×ræË¬ T¯8‹B‘ø²1²ÌÇßL'é ð¾ ‘8é°ùp]hˆmñEölgg:z‚0öÒ|´Spç-Lëû“×®ÆýœDR)˜¬Ïe˜ÃæŽÈ +_ ×HLqi‘hñ‹i³Œ¶eV»i®ÒbÒ*aèÍ`ÚDâl8Ç'[ÎG'Ç'ÛØÉ¯Ç§?~øùÔùõèÓ§£÷§Ç¯OœŸœ—Þ¿:>=þð>½qŽÞÿÍù÷ã÷¯¶	Spä,Ëq€fˆÓ)ZÛŠ”*Pð³Ê¤C†–ŒJ1’Î(È<A:Éd‡
—U‚v…qX=©Õqy÷ð•çŒí’6§u\‹_Â¤Ïú›<q\§iœÇfIOkRÃ„£q9eT8JH@ªê’€„Hû©3 âÄäÃÝB€¡b?ýòî¼-q*% TÎ ‹jSÒ¬l¹U¯[Nšáœ	'õþ$úÖü£9Ó£\$Ø,&ì+üu˜FQ:ÅilíÖâh¢«ZB§hÝ™ÊAE¼Øè™™ïœO ¹:Â÷‘NKïþ(4õKdDNžÂž`7øÀ¨æ‹¶‰ô%’Lg$ñÏŽ>‘Gá8š½a‡ÿv<[Yhœï>qöw÷öÝÝGð?gïÉ³ÃÇÏvwÿØ@~^8ÿÆNpK$ìœüíäôõ;Øt¯^;_zw|rB[Ï²G`­ª½Ì81sœ©31þ=Z; Ð@þ àÍ-¤×gÿöüÑ§±ü'0­ÁŽ»åüãžcžEoÔ‡WQ›wE‹-ñ§{ÿüS
"Š5ÈïÔ\2j.`Gã[=0;Ë%a6…!M’ÞtÐÿÛ5„£x¾óo?ýrôÛÞ½F|z`íy·5¥4"û>×Êµ'‰è_½=~te²ï$zdqšÐÀ.cÍô8a²B´R®ní‰|3ˆFéh„ìêèã1¾ý>-ä3çÄ:`Ü³2
dÿ!fî ñObŒ(ï´£¡Ðù^f #Q%)8hJRZ4§sÛéšE3³„L‹çýÓbfWÛ_8­aê½~3Z¿él5)óßþà`2‘à÷ÿJ]ýNÏ²—å)À)àðÝÚv¶r8a¶`•®†B{zV@¢
g‡ÇFÐ ˆ5sšnÔÊ—ß­¿:Ê‡Þ§’¼•œ-5.‹ ôˆÓô\]‚ýEíG²x	¥Þ¦hM»B Á½¹ø_»Ÿ;*‹0òªÅ~«ÿmvHjYuvñQÓÉ¼Ùv ’Zÿ n=èÉ¾g\ÓëtÜ"œ«wÔ FP±*m‹˜I…ðÏJæ¯ Ú2‚Æ(2oŽÿr“O~þøñÓk:Ê~;=~÷zŸ©ùü)HÑ	i}Ð”T ±úHÐ“_æ$Ùnk”ATn	ÖÍ>ñ8³‘‡Èôi':?€VæxÀ±ß<qZÝÃùÒìŠÎ4	Ú	¨&RãˆMT	"¿†í5_í¼ZÝ“3J!¨7K²¹s¿LðdEy­2™æ"[ÀBÑÚžWŽÂÃ
0ùàY³E'ÿêÁ¶šý!Î€ò*«µòÃ¯¯pß¿iu²zàÎ\ÓøÒã Ÿü Ôº´ƒæ²¢Ìl%è]ª€eØ¬ƒH‚ò†BŽcæ[!ãTâD«–‘g…Ÿ§@ß(áÒû@´Èr©U”Â@àyH†ó~«¡íõüµÄrÄD´R‘¾L{4þ‚¬JÐñ™m'ô`®ˆRðÒ¶1=%KTßÀcÂðc‚­PoÔªx§ÔVÔX«lÆ
MÖHî@ñ°ßƒ\Î^v¿Pr‡õ¯ìƒym>1šÎ7!RhX:¶a!–M LÜ(œHd#Ä:—äC†?%AØàdã„Æ8§J[Ìš¢Ý(/,–¬ž!<MQÐë§Ê¼‡}ýôþÕ1nz[4:‰ˆá‡Ÿ^ýðÒÁ£ã$-s_þA[ÀLs\˜X„‘y÷J$°Åï£“HCIÀß½gÚãnX:í: ôƒ}wNfžúµº¨fáÃ‰sRYLÒD:m†v`S…˜_yèÐ|¢­Ñ×èAäþøªÍÛÉU{ÉD1¾~/x,¯í¥ZÅŸ~yÇ»zôë5Àô‘Wx£¯Ì£kuCÇË˜*s;ñÀôxí9kw¸´¯²ñF½¦ÓëËrŸ×aBULƒåÞºÅ\>?d2ùéÝ_×¸D‡?*Œ;«ÑïÑ‚‘À¹úÓÑ_?Ö.¾Âùë»·p%>A˜”#ÛÍ2Ú­Àu~:ù¨šò)rð'aC7PÏÅHZTóC²3'u^CùÔ&´*A0!Ã4Pj¹IPÐÒ=½™3¡Pé•ÑärÍ~sÝÒªs-Ñ[B áÃvBÉ}q®­ŸÙK[#ôCÌÉæ”Ç@ÏÞÛãwÇ§¿ýðó›7¯?]m®‚”‘§·‡÷òÃëO/_ÿvúá·ÿxýéÃzG¿½òk(Iã )Qz&®9îZ_99ýtüòô·“×Ÿ~yûúô·—ÞŽqôþåk®áê£ßG§½wBºóKVþýÑ»ã÷Ë£|óë«ßNÞüøÛñ	ŒûãÑ§£ÓŸÖq›†ÞcÔÎ— ¸ë¸OE§›â?õzùˆÁåHþ*'©~Ëˆ‚Z¨‹­…úŽôüN$Ð$o©Œš®Û>æ†rn˜(i]e–¥yQyì•Ôh¡Ê"1w† ­k7:*ÖFÛU²À8Õl¼èÞÄë,Œr
ÝéŽ[kÂ•ÏŒüvNÃ‰öÛG'¯õ»íw~·ôÎvÛXQÍ (´WèÊØjÖu‚-:-1Ú@a,n;±îfa•á¦æ#jaPB
5Ú35îž¸Ô¦`˜¾aûõ³ÏÝQÅ¿U ÇÁÐ;_$4GÉEHÀzAh)B¿ŒD¾bt=„mÛ±L[Dw[ŽÄxHàà:ô	YÇc#Øà7Æ•AQ~ÍÞ·cîß1Vìm‚«¿Ec«ƒÞz²z&òèU84 úæ8p¤Ù¨Y†ÇËve$×foPšò4®BWPhš›ÑfYÃ¯,ä-ôtä`Ý °—h¥8Ã œ„A)ººX´¯Fø&]*Û¸~eÜp8á÷Èg«ò¢l5g;?*q¤B[Eƒ<œH½t$›ˆ3èi…j¯%² hT80× k}Šæ¹TYš@n´¬äu"£)båç",ÅMöÐ4LR&(Ê±9éï?­iwK'J®tÇ:_!±(<×‘UTÜéaxFÎ¨üí`¸…'¥¦¯¿ù¿â£ÕÌ·}Ë&ÕÓ[s;ƒqª
/ž£V$’9J~Ïì£¤jæëO–~ç%©Þ(<{²»ÒÑ?ÿd7eK{¢JxÅ™ZÞgÕÌ]€[µyZæMB^‡ì±g–˜àæÓ¢»îw›]Kæ%c\ÙCŒƒÔý^y´õÕ_r¹ðþWmm¸>ëû_û»ûïîÝÄs3÷¿žîÞÝÿú:Ÿ¥û_Œ»~ñ\~ÿkoÿpõþçîÞÃ»û_7ñ|Ëqýë[¦Û_ß²\þú–íî×·<W¿¾½âÍ¯o¡%>÷¾°	Ç­¯o.}}Ëwçë[–+_ßvÞøÂé{ãÂÅÀ(ášhãÂ$‹º"…ÁéëQ¨Ù~FeVÇ¾Ã¤$#è‡b‚|D"W²4•%r€cÊtõ%Šo†2;VÙ?7#m$.õº¢æùí’â¹j¹¿Þ6²õG3ŒÎX(èg e-l{÷Ìžnû\•‰·½ÎœÒú2§…l}eœÛ«N§¯t†_Éa˜«±å [J»YÆ9X„m/Y9.€„!ú…qb5rÛæ²Þ¡a+­¨E2÷ã–Y\ÜûéÕ¿ÃáD­/bS­ú^yR|˜×)	ceFŒ‘¹•æ—‰ƒÜÒ—f¶pypìzè:S‡á¦PÓ2
(ŽÑ,µ^$  «Öæ8KUHfb ôö`_àÏ°‰‰¬Å¶‡¥å¡ ´‰«TGÄîŽ‡N$‡…#”3 æt¾M«ñË»ÊŸ«ñ®C	Wx·º†ùÕ©$üõÚ¨±ÏÌá°5LÓ­gÎQ`"†i„Ý
¼ªic1ÔF“ï(W7Dò ìŽ>ÕÓl+Ñ`Õ#õg:i=5›@"o€1Ÿ.ÀMÖÓ#}¾6’umÌ)d{]ÜíÚ/õû]¬¾›
µ}î¶öP"\ô_€ÕÕ!•çò–¨d=Q¬’„9I¬ˆBë_$`²#‰6Fù¯OesSÚ)]ñZŠéf›t† øþüé-¾C?$Ñ ©ÐáLÖJïžžÉÅÕô£6¾-iRAÅc€Q‘$F@Xº_³Ð”&]¤ÑWd†¹‘>¶íœ¾}eú–…$Q81(Â4¡éÜYÐy¤ñÎ*Œ(T\Uš­¾„º†Ä(9ãdARp«?T@èýæ/xW£þ®ÎBPóI+­-ˆjQ*r—:)’ê/0rD.¾jÍà„z¯´Hö“ÈOh~iAÕizrfÏÿó^ëËöêåÝí¥[§ÛÿyzIÆáŠL+£úÏ3•Õ›»+õçÿ¼WŸ^Î|pAŠl1^zÕ2XÝ‡¼ýéÊHcáŸ¹ß™—Þdó‘æ¥ñÙHzo‚Ÿµ»8KZ]¨,˜·_÷ž$®lM—þJ­|5ÌW¾:Kà`¦]ˆ¬ é·=gñÌÍaeÆõ÷SµÔ¢šo³¢)¼ú®µÐèmð—¿Š"íTß-u‚sÓ~9AÂDÛßâ†*3ÜÿË= Þïƒ4ŸíaÚþŒªïÒ7úº×r‡ÀÆí³4ª·ÎT™?G2O“0N]ä¶0é³<3Ÿª :<«šT¤ÿÂR€î @:óó¬ý;Þ×ŸÇ@œyœÅ|\$àW ^zÎ
¡€1U€ñ
ŠþKEÃ63™ƒÚJAŒøÅ,Ž>RÐ!0U}ƒ4^@¨Dÿià€º$Ñ•«!”É™/Ëòtf#Áw1ð‹zŸÂçìÜW{{ã1œ[†r«QÐ;À—0Vß¢af©sâQ'~fÅëd„7ðÛ—i.Ê Lé`þ›
ªù:Dý| ¥UV›Íþ¶ø…>²"üc¼#	ìá7ø¾}÷é§SÀÿ<ÔK<‘>’O[w…F‚d‰2…/_HÙ'¤¯ƒêk	iqVy-<(‡ž~÷%©Œƒ9l]}k5x^ä%(ä—½îÃAjñ:°ñ09ƒ®=9âùC2Ûv@Àÿž„_$½ý¿Ã±ìÿÓnnv
ûüîÝùÿnâ¹!ÿßÞÿïë|´ÿo»~ñ\îÿÛÝøh9ÿãCòÿßùÿ6ÿ|ÿgXtÇ\ìz¾µçíbXÈpê=ßúùôûdëÏ/î}ÿ;×½çpø
&_¡Ãâ+tØ|…¯Ð¹¢¯Ð¤°pBO¡Ãà)tø<…‹§ÐéòºîÜæ¶RÓèW-qe=«kÑ‡µ&¡ƒ=™”?/ô*RÇ¯Ú)AYCkt#¦Kù
[ê÷¬tðÉüò¢
pPÈÒ¿ßY~¡çç:S
¡ŽÈPÑòW÷L2$rP[‘DM¶cgA?•È‹&šKÀÕU´>¢±èùÖ–³£_Â—/ƒoòÔèkGÍ [áSºÅûF[RO\,²É mUHi„ÆFÆ/Xmƒ©‡µJîGòÁÌÑÄxÕÞâëü_|Iy„ãËE3hê¡=Üïwª%¾m~¿ü,ÉÿÆþTãö¨é×‡Ñ[þøèàÑcÿ·w—ÿýFžõŸŸ¬ÖÂïzÊÿ{»AÄ»“ÿ¿Î‡öÿFvýâéˆÿ;<8Økïÿ½GÜÉÿ7ñÜÉÿwòÿüeù_gWtŽœ-}ß~ÇKir%£!ÞÕz©ó´KLx¢Ò&Qè53U`« *Q¹m·H˜ÄklF@Ž@èLJÄW&-˜‘sg'H}µ£MìSqt´¡ƒ×ÁŸo=ÙÝ}¸åTùNŸoüøóé«¿¾ßB©•†V'¦'×.úB; Vï)Óùþ­ù¦Kœ®ÓÂU0«†FŠÖR:buôñ&¾ËE>¯b.ÂJdzðUë™““·Ú±È$[]¸‘Ïä(ËßVJCÛN…Ô1ÍÁÛ_då¬Îò©.­²<RXŸÖ/Ä×xgÇé´H×#ÞSÀ*Žr‚ê’ËI")Îag–Äå9KiÜvÅÐ¿Ê˜†îyu%LrùŽ`½P:x	µ¾]Æè“UÞ_¢t ¢J‘U-Š¢èÁ[tû]Œj5f¯VÅ+ô¢•M‚Ð­_n¬ð‚´u·ï)Å]=º…jê¼†Ã˜rI9†ª{¦B7™#•Ö±:ƒùB'®’ÆâëŸ¤ˆbJˆQb>ÈMºGU«ª±Â€^|Þà`À¬y&IXøy=.ˆ%(\U‰	F
]“\¿„ƒ§É¥‰ñÝhËÑ6„æO[Û	±UÐuBÍK­‡×êH“ÌÎKP-¼añp Çƒ¸rýãÞiˆ8Äòº
ŒÛÄîè£’ž:ËlsbÛIåÂ“¤ê«} \ã,ésš VÙVtk5ëSïl5,<ÆBfæƒÄlë¤ºÔHjÂ¦ðg3ˆæŒêÔ”mTcÔªáæµéÈà¢ÉAïíÐBÓ¼{^ç‰v¼»Uï—XÌt²ðC…N€/ÊúÛÃ­¦ag±CË¾…ñc°áiúaD2	¨ 
XÓqË"—TEïíË6Éb×â¾ÑçªŽ	/Ê<Y{|,òÃñ3Î§§—gíu¤Ü@tºÜD©¶¨ý
žª>>Xêîè§Î…Ý‰³¬&	ýà	}QØ†VVÇò¢Å+½Þ‚°€Ã™°³çí-£ØHilžì>ÙmóªÅ;[áiË´)gu±-#òüãã‡O§GoÃþ¹…ù´Š6ñó­
.›¾ÏýQËH‡‡Õj¯YcyˆDKMÊú\%ÏžÅ¯¡ÑÅ¤è§’Õžì®Åwùõg`ùÅ5ãlÚ+ë×KÓµ,ÐÃÕ(ª÷<nwÇúÓÉÉëå\ãTEÏ$PE'ß[F[6âd«YÇä~ˆ—*æÑR`É¢}`Yœ‘>ƒÖºl­²Æ­#’%uÈÉÆœ¬Ìô
CQp!Â¼Xç?¿ ±Ž‹:¢CxG<
JEk<Nßž\`V¯.¡í»ç¬ÝK»O×í£ZAxÚ3ôC>¸h49aâhùºÉ)_;èýs]Æ¹Ún¸¨:õ@” oÉ†U)he¦§vÓ?j}r±rY”	¤"8Dš\UDó/†‰KŽ¥¾6Sg©¯ÍxúÆM¦s=À÷qËÛ`¬ ÍTø?¦
7	óï+a
„^ƒÕ]zÆJîUËþ‹)E+€Ùè:›ÄŸ`wËfv0Ô.\`Dâã™„šs‡Òœß›9[:©«[Hˆ÷ó-Š}C¤·jÏ·à¯½­%æ`:»¨ñzq@S¸Àlc $Y2]]ˆsd4˜º'&Xš©Æ!WMšî£©09÷‘ÌûææÁj=Ñ¦©9A$À¤9 Å´€.œCÖ€E7îR-ÆÂ+üÌ;!„NýÌ4«Î“Æ†­<aÊØ-àþPµ°žÅMh›-ÈG6*éB "›RÓ4T“yàêgÃú¹Tó[ÿ¼9$ c9¾ä5QÚzQ2P`öº¯šÑ7Åëš1/Xðh¡Cµ9ÞÂ·¹0¹œË¹Óü%sØP¡Úíëäþ £	5ÖÈ3o/|/ŒáÜ·Ñ¼Ý>aD
×PŸ`Ž.™§Gê9‰´›Ê}l«õûU§&–ïwèåÅŸÆƒÙOžo3Ã*lé+™EéÜ)f+6öf™à}¿_>)óÊ‹{í=!íä$%‡<&_SoÄ]9Å/6®$ÌoMå2Ï[’ 	@ÓÞ±²ãú:eØ¥¹×E}H.í»êÀÒ÷k£t´8èî‰Iã]q@íf¦¦¹Á­œ'ZYÇj‹ŸËZ‘<5Žyçy})§596Nj=º·éÈø¥ëŒEH#µµ õû±óûÈù}éü¾pþÏç2-þôû\ÿëü^9¿ 8 Õ§šœ~Ó7…ƒž<NÊ!ýì³ÂM]ãüFþªéu'Í
£°×ùy>}øpª•zÈ%h¸+ÑgçÅ÷;HõæÚÑGÖÝúâžþSæ/î¼‹ýž%ÿÿ²…†}üïãG»wþÿ›xn(þ÷àÎÿÿu>kM§Ì0ºâ?^©ÿ¾ÿxÿÎÿÏÿÿÎÿçÿ¿’ÿ¿É5ë4ûú™ãüÐNïBšzØ°3U%åLîcwT† ó¦‘¬)!u0›.«/×9ªQ¹ØZV»°ûhnŠ‰k[—hÞÂI&zÄkÞµ›C9—@àŸ¨0ÖV/´,¦,òAX ÛÆ¾4ZÜCŠT%Ý¹/p0U‚Z}-ûÑ·iôMsxåžc
ô•Ú×:…:“mm§Úâk6z@hKÁÂR&]¬ƒÃR’§ÎóÏ{a¼než#CÒ–»âßë¹†ÿ4½EÆ¸ôþµg~¢áU³T7«§jñ6RKý.5¤Å¸³éö%ÐõO÷P7¥·Nù:yIþ7!ã¼gŒ½üÿðñÁþüÏÉÿ‡wòÿ×ùÐþßÈ®_<—Êÿ‡÷÷w/íÿÃÃ»û7óÜÉÿwòÿü%ù¸¦‹×ÉêÍs€›¶S¢´{B¡,Ì~¿?í$Š¾“Ò¼ùl¦Âúm\¶é-°Ã½¿¾{{‚áÂ­j^@+>£‹:¯˜³þél·cÆøÛÁo»ÞL[‹x¸‹j.;Ç°»Ó Ô‘q—×gnöj?b]èXk(ª.H5Q)­åw"Š¾[-ÇRûvLæÞe˜«"ÝËÔ¢‚Í££Ð‘¨ô­ÌæÌPÕÔè/ ¯š¶Ûë‰‡|¯Ëkém„Ä²æiô·µ³tMsË€0ã×q–©®¢ë<`ÓûkN†wÁzw>þXžF°³ß¿ÿË3§Rßj¿pu·Þ¥_0ÐùÝJÀ·çULÄ(­êÕYÕ+•è)lëËußíüP†@|Ç‰sbêÊ/§ªµ´ÝîÏ– ¾È«{¨
~/ð¶ÑYÑ}…9ná[yÌõœ ®_,9+ëÂÚŽ³kuM	Ä3[ýœ”{©0Ä&T;î¾Þ…AÅoq!ˆÙ&Mzlôgæœ¦ügÁªnM ŠŽXTº«ày½ùZýaºXbj/Â¥É	ÈN8ês‰r¥9Ôƒg7JÓŽ®öºôÂ+ünDõ€d…Õ)Î–>†å¢4¿˜ &¶~ÄN	óú÷Ýÿê‰ÃÓêWöµ«êÏEÚLdI±†Ž›¹~Çˆ(ÁU{ç’Ánz¼a’•ÅÒÇôÝ ÄZ[ŽÂ[÷1[•zÐ¶YõÃo19z‰¸Ìû»‡OV¿ÑñâÚûçD3ÙE¨ú%@6£³ZIa/vâGqíx'ëzÖì™H¼†ñg=¹ýÿ«»¿údy[áEY³MWh~$ö‹dÞkþ*£¥¹Ë Èt™$†Ã¡E%Ç.š¿uÖ˜£:Ü	±ld‚t~€¢ïhµøúf×7-‹‚þ ¿»Œ Øßo¼_=ãNL“hÞ|áØèxUI¯-]ÔÞÒ7ô(2Ô?Ê—ŠVf*Ãö´¤–W¯ß¾>}Mç”åxsy&1ù;îÐºœým~þbù÷hý¼1ºqU€¶HG’äƒ:xvÁ*úàWåOñœ¿'euw³ãU2	#a–¿ê…ãa•ÛyÐ,Ä™ª‰Qú¬o+*:	(ZhÒ»6ß¿ÿ@L¬×xõ’
VÚf¢J±†áH§ˆîÓIXtM,šŠ¹j$„Ñp'7öñF×ñkYñ	”v©%s‘A†~sÍ:šÇ^ûÙúà&»6S:ÃÝ^Þ„›ï›ÆÁUŸ³Ž_ª"„ì9/±Š¾ˆþª¢â!>™¬ô§#m—^2R±g8ARH0c1	Ó|UuÜ¬¼Ñ„yáF‚¯‘6à8þë»·h# Û?ô™˜~…DeÐ÷FÔXJJe‘­½Šµ(Nª´&å”˜èâñ®{Ì9TÏ®½p-¾¸ÑõXÆŸÛXÍÓÂ^úÂrþûfuÓ5KÓÙß%sß9O«¿6.ú…“°@.,Ýyªì(WZá×Þƒ4_"i;F'Ï2Gz÷§¥>ádã¹©72^û‹&r£óÇÔŸ96
x#»JÙŽþø†¯~¿Óúvõe
Û~±>‚¶ÇTyèÕiÑ£nºè'.YI_Òô]…Ö }¿ÓøfÝ«tè¿Ø­ÞÓ€vÖAê¾b=1 ¥Ïºù„¦CLFWf/ö¾ßYþÊ„Œ×Ø²ÐUÕŽÉ¤ªãWô-ÍrÊQ«íS"±Múc‘„*nQœ¹_]CkÜÏZÔTvœÓ\TÎªh¾Ý²îTgúƒ¼ªœDu`ë;ïLe[—Ú–ú»ÐîÖÛÔÖîï2Ã[ïg³'JKÇp"ä0óHôÚäÒ¬brDv´îí÷û@#*ÌMUÄç‹ÌS¬÷îŸ(úÈ•qSˆ>“ÅÜ[E—1hA$ðÿ ÆQ]ÔñµäˆT)%ZlÄ‚øïãàÃ¢×x™.€SG5DPµêW×£1	@–ÊÍ®/²DâqèöÕ/44]Î…£A½ÃÍ=Ïµý­oeÑm¸–/VÏ7?^*ê³x~¥Ô4RúÅ¸EŽÉë\+ªFÞSÂaÖJàQH8Ø—DåÌ‡ãÁ^™UºéO(íú¥)óIgÉÒ˜ÆK¸†É7ž_‰±×¿%uµrÛ§ÕO´[zI¸šÏW®hÚgéNë°JnÑGã¨©®kïFæï„l|¿¼Ã^V3gÒÆüòvþž÷è±ùFð;º„_A_Þ*~Íƒ§zŽU•8J_	LZoÅi ÿLV(à6Û}ð#ùŽ·©µäÔ« :LRâ>ýdÀ&º5UÇu¸ð²qËßmÕß©TE}ÂÕRˆ×ä­›]mÅÔäüÆTÈºFës‰jT…¸Z¦ª0éÝß¢ÄiåP\±RYágù´ç¯Œ³Q×Œ‰âäÝÑGâ_Dl?|:|Ø8Ný,’C‹À‚Žò?×Î¡«÷I{ ÿ ¨Œ!D4 ¯`¯ÐŸåÓêOËz˜ýeáR}…[ ¦ ˜éXÛÖ1r@º"Êà§_W£^Ö?µ<Iz‚É^U¥Nšé“å¸ÐÆãÎþ0°@D…	Š2¦CjCæ1øRöÄODèg˜ë2¹áñ’Þðzàµâ4%ºz²ã¡Ò¤Ë›/òÏh‘^^•Û»~‹ÐÍö©&#Nªqè"•ÖÝßëx à!Æ^P!ÖöÜÔüåyšH~Vò)’ãØzÐ<&
Ðª¿uá/æÌ•*)ÕÖKœ?íÇ šìu^êU5Ž!*–zŽð¡aýö‡C#w0o¡îüB…a³ »ôœb>ü#n€~7{N™¬Xô…ÒNîÞ¿uµH*pšÝ 9~Û¸ÒK¿¤7\6¦è4/“D+amÞ°Y¬Lt°#õr,ò£<óÎ.éoÝS—hµÖÕÍ)¶b¡†aS Þ·?HbDYŠ±y:©3¢P $Ú0ôÂµ©²;"ç²Óö
ãµ|Ú9¦ØzÐxá´Ú¿.l¸Ú}I¡šÈIÀLdÑ¿×³,Í,of'ûþLeÏ²Í/ð4nYvÏŸ©0xöäèÕÓ—OwÝÝÃÃ×îÞÞ«=÷‡ƒ×OÝÝÝ'»ß>}úêéÁõéÏòiõ‡½Ë\”çO¦7b¹J<mÈ¿ÅÆ}"^Œ˜‹û¶êÏ§oVÃ>.Â{¼çRf‹¤³ß¦’~Õ9‰êWh2Ì°Fb~Uw!N‡ÆQ‚VF8Ž‰e	}£ãÕæâa+bc1Þj˜U`ž‰½Ðö0ä¶+ý­{²S¸atgÃ¡S˜¢â@.•Äw(§×:üÖ=µBÐ/äeÃó7{K¡ã?©¬òä"ïÃ¸Œ¤akIÔ]ªõÓ‹^ÄêýÝã¡6‘Y“ôïN‹dÓZÄkeM
´ÙuöG§7uU‹‰[%`¿lwb¦ONæDndËR©SÝ¢^ÛgþtöZ¼¡á9G9-ïŸL—ZÂ$ üÆ}ìãIZõöww¯û˜Û,VÙ1hy&§~éOÄi™P-¨eû¿6â›hÅ^ø…™Ã‡Hl!‰VÕú®ÎgŸþVç<Á¬¦×•YÝìþ½È¶tÅþÖ=/¥ºÓ_;NV¼"…¾èÐÇ?Ó2ÉµÌmA™W
goü¶9C+f
î/¨æÁBÈî!€üƒº*Œ¿tJiËŠh1Í¶(nW3_”j«oÄA…–ÿ¢œ¡:7Ù"š~¾À
KA¢@Î‡ÿe×Ÿå³i4§É¼L€Ïqå¹kZq†ð«ªüLöØÁ"ƒÎÐÐÏ^— "£gßuf„•àŒÄmâkòYöÑ?.]Â,¬Ãƒ>û­ÎÎAšU)cÜÆ˜—DaLvÞÃžƒs¡Ð‡¢ÏŽ«Hh8PA0¬	ñ”¾¥ü«ac““¿ÑüÐˆSµ˜©ýŽ& ±ÏüUÎÉÚø€’`µFtÇ·SÜK¾êçjì‡ŸåÓž¿¦‰Ù<ûx¥\é¸­uÖr+ÿ4ê¼  _GI/ì÷ø$~3²Ò?Æ¹¦ôEijiÃG¤ÐÇ¾á›U´l8¡$3<^øFÇ;ËÒ©ùCÃ*´Æ~ÿW÷£~Ïýa^‡¯ëoÝc›Ñpf^ä_+.z¯}cFG<uD¬¬i­¦ÙU¬šjK˜Ú!7#ÖƒÅJÞ\¬ÚE¬šN¶t”8''Çx	£0$¥_ùŠæ’w&Ña±øzý4cËZÙÓõUsÓ“<w&œÌðRp :	 â`ò¢ßV2õªN0ÒõX{IëûÖÈë–âò·a›nô×`À|~<}÷ÖØ¹ñR•ú1vº AªB÷Bâx¹?}yË\ûÑ©!:bûV¢ùZý-…ö)ÊòÕóíÚõ½b„_+¦o£¼S_9“MSnuV˜‹jFIiL pùªÙŸûàw÷9íÓmgï9š–\~}vÃ±ÿZ·…©
óÒ}ˆÓ…áˆ.@j†1FmA¥]¨wq·ì³ØÕ¤;j˜8ì÷éšÄ›õM¨_tá‡_)§õ§êbÂUû[÷˜ý±eJLèŒÙJG’ÀæÑÏ8ŒzöwÙí‰í¦-»g”jÅ\k….:B56¼h“^rvœŽÛ^TðB/î7¤¸ÅåÕpØ?´bšJ]¢•m¥êÎB÷ûøõÜ~×L¸=ËóW6RìÐæ%ó°¾ÚÓÇöZOÎþât×n#wÅo´Ññ
<N±ŽXã…cU•G¤6ø£¯/üVa5-'Ù»ë%€ÃP{
à)tíÍz0FfkH¡v"yS®NÙ‹„á–(¼Ç!Ž÷¾µÂg¥	ÚœZ½€?zôˆü‡H/t4’Ãn„h¼Ú5/©>…óÐE§b¾Ôï¿üËñƒKÄõZÅ§±÷n`ËÁA„jLÔNõ¤+M¦][ ÌÞÎr&¹Y•[îtžéÐõ.Ñ¼)7ûÛÚñG¡;“ï¶ª±ÄX›ÔäÝIæ„Ë*ÂÍL +ã¸”™—2jP˜c
d!.«™~OÛW†šZI¯4;—(KøõO´sÉ³Q®ëñd ]Ú±zã´¢	)rrÌƒDIò!5º íðƒ%8‚ÍÍ«0wþHI<õ”âDMº>Š×£¿¿Wyª û[ö8®ÓJ,Õ’nüìÔ’k%¸ãHN[<XF§yÈ—u¹]Ì¨Lš>•nütú6b2™w¦´Øìxë½ÞäªñÖ?¶„º*SuMª?½×ªµ½þxÿ~2Í#öF²ø˜côb~‹.Wxnm›ô¤zä²|–æO©“±Œ¢×	(]iBî§†	_áo0}‹'"‘|€¹öÔ"ðÜx@ÜK­S(éÏ7gÑVE ó¼€ ù)y€Ñ‡#kG2–9aQk½ð«Rd¡€àU×¬€€êØ„õø­}´Á]G©U3g„íî.G ô—ÒEs\ê”®h)ÿJãÖAÛ…Æ!g…ÌªXúÐR,íNåø®JsxyzÒÖUñ•‰Í¨÷°¾,®œ*w¢¤Tÿ±ü[‹Q(Ün¸¢·kºEÝµáº/”¼¾KÒâ;#£š¼ÀíAòc™øº¦v¦d#—£N‘L•p«-gÃüƒ¢tŽþªdŽk³’Ò®×ú¯d
„¯I~¢×©šBƒQ=sËù15e\´9»².”yä9þÅÎ÷;ÍmZ Z‹ðb­ÑG}Ul/ó¸5Q£›ýk°]ÿâìãª‡Õ 8Ö
{ìÛeÆŒ6ÊäÚè‡s7áŽ©´Ï&þö¸ŒÏ·È¨Ö -Æpcj²&ãcëJ2û¼ÚVÔá†›™ì¸
}W@øm¡n¬ïPTm )¶¹±ß*!%ÿøáä´J*»D`cvô†dñ²‚_Iœz`ßï4ß[i}ñª_PÞIw×Wq=W“ÔÓíKR§ÝÙ*Ô<ñ]£šËà:¢¾ßYþÖÐO5»/²‰©Rõò4Öþ$sÕà¡L‚jTV5Ä;x¤ÑúÀu’1d u,žÖ¨cºeE±kú£üuÜéV™¨-ˆƒÝdðICµ ®3jEhoV»o,ñ¤võE®f±åá¯ä[ÿÿ"¿ž¤Ëü_‡‡X‡c,;ø;=üØCZŽÆ‰m‚¸}l}·…Ëš;+øEz¼ÑÜc;U²Æ¶7e‘#¦(Þy†sÞ¤KùÀi(¨ÎaÀ®$@Sþ¡%[:ûEk×£>È ýTäºRV‘ÆÚÚRõêC/§•2)N$v®Y—vÝ(Bz ØÎ—ç ¾GÑ­uäqlÓ­&-ØnSÁ¼›@›¤ºSU«¯fµWéåº¶×¥ì@×¶».áÇò´m¯Õ¨ž#,º"g5¥Ó‘UY·cŒ¥ƒ¥Òð»=ÞíeÔõì¨ÚÇÕÆûwôoïÌ\½»ñ¬†½á"5ßÿ“÷Ýƒ?ßd´ä]DÈ]DˆMëž»ˆKŸ{ø/×…P%¾¾Xj¼û}Ñ–¼ÛîeÇëà˜wÎÿÿyÎÿTµæ†eE‡é´ežXkj¥£VäõCLïëÔÀ5¦›ëÙZöœõvœeÈ]£ÒJ£c´ÆkŒÆB¹ÝÀ0ÑåWY‰‹9^_àZ„/¥O“.èŠj¸9/[y‘×Ó§éíè¨u)Y,™£uW…qƒi·WRRMŒª†S"§”±ÑŸo’$šö
¥/º^W§Ò—©"òEZOóuãêŒA-Ã¥þÁà÷â`íïj{d»ËK¸Õ“ùîøÝk‡ûË¶{sì¿â/ò`¸ÏRåŸí*‘Éd¢_ ,’uV‚ö\
gë¥>¨\Äc«NðßL'YøƒV$©z5†%8æíVÍvß–[¬ÍýF×7n¨*À}LïÔÄ´L*”°ZÏëÁör©¬¶·¥r¯´Ôå5žÛZnÚAÕ|Ín­'çÅÞþÁ÷;‹‹W¨%*õ/8ïL’À‹Ò¢Tîž»ïBÓÅk†ÒV!v#q ¸?|˜žnÁ|´ß{2Ý9eÙ>Ð¬?P&˜¿Ø¬ôÌ}ü…îêê{„L81°C˜Ä8Í±Ê(z[Ø°ð;±(ƒ0Eøø*ÐøÊC‡~Ù°PWÆBÉƒn,ÌÄ#Ô©åØá4ÍÙh¿›èÐ³ó(
Píd^°¡`…²[8Ks¬[f2>+ú`ÂFZ®‡/7À’üÒzNüÒO)×	Ýöë‚8äll!è<ô†„ý˜¨ìº<jDb”‹lÌ…ÃÐ’+A¥ï÷Ø0°ž…p{ Pø|§JÕÖk<ºÊÏ…FhÅ!SUh	™ü°·X‡|PûK#¬`og´¶RPÈÆnÂÜšÄƒt =hè6~Ñ…Ø£ˆ¬ þ¹É?~	ÙvbXØ"L5ãA ¶Ú„ZDGÂ£†<($3D’¤œqÏÎ­ÇŸyž¡o›Á–	¡šÝÎ‰•ÛjË„õ&Òöå…Ïvnçû$Œa1`ÎØôe'Á2ëþŠ¢ÌÙˆAu2mm7ÐË¯ØØ¶êdÛÆ?Do2ÁLí…b6¡§0èiîQL¨tr¤ÍLû­ëEju^ãûœ±Ùæ°;èÙø“	5±ZÓ„	«3QKE8óF À“Òœ&2aºUfB…lÖ‚I§`²ØƒôàÞ›?*‰”	Ö“á‚oeµ¢¿gh¯ã?=M¼rØlÒoÖ™Á~éÖŠ–÷Y˜ƒüïQÂWéÃYïQ'LèX™k/BG±¡cE‹Z9_ÒÄ“ƒ4=gÂb`w" ?Ò)å!æÂÀÏB+ádæš&<à+"5F+jÅßJ(@2Àø8ò‚øÓß©8ÖV«\Šh’øÞ€Í€<w:—‘–ga¡J/j®²œk{’‡¬?&©_ÈÂUL	—Ì>°·Øìƒ¸Ó’ªuBz‘dÌ{)F:Ò…	fjm¢b¸y,Î1Šˆ		ky4Ëå$”SE—ú•G=0ábéÙÀÉåÉØÙ‹6±çŠn»µ¦{à4ž~›ð¦´Ïå]òNUÐ˜B¸4oOÄÖ† ?*e‘—ªð|‘ƒ>š@"4`œˆYAbnvÎ†Ü¡µlàGirîù‡X´›‹RýCk…b3hŒ¾4¬›AÃÚç¿4ì¢¡X¹ÐŠ?
‚|Év¨~†EY½ŒÏÁz]Ê<ò¨Öþ7X’ì<ô@Ù¦Æ<hÜøã[êÔU-6ø³îÐ&Ô€ÑÀê?VöL4káÃQFm™0±Ôî}6ÅÞÎe§>³Bÿ2…2÷ËMLØÄa·í±IÐ Øc&@¢N4¬¤/F˜°)\Ø©•@CXi,ØÂf±G+«¡0#
Ÿ­Qø\Ê’ËîŠ¯?–1Þj ­É¥äBOv’¸`äbÊÊ'­„&Ìe	.¤•˜@¡´ŒQ´þ¨Óü©õmz‘äØÖæ­[0·6÷‚L„¯±ŒØDÃqwÄÇ2çôÎ1ÛLt[Zš›ŸÍÒâ‡öAY‰’¹;•¢|]ÚMºT'ÝÕÉ(£‚üÐš5aœD^ŒD”³Ó‘•° •:1Çr«|(+faƒ}nmöóÐ¾;—¹‚Û l× !{]¿…P&"Y|‹snÍ@ÚøTµÊø²ö¦¶ÂË)‘pùU!k£~!6<¬ý»€ ÛAsSkªâÔ§`6$º•ÀæIó©€ÝRf0›\Ùí¼[žö¹ÄLyˆù(üRiìÆ2)ÙêÜU„)½Ê4µwh‡±GÍ˜°ŒÏg­@G@/ãðb>ÕÖ:žƒ1œÃÏ:IŸÛÚ—Y…±ðÉâ,ü"ËÙF[‘:qyN0®‰+©U«‘9Ã³ÓgfîìáîS×¬šl>ÏŠ4I«‹˜šëŒ¼fktÔØr*®û¾²;÷ßÁ§ìÅdª·ÃyóÎïÖ[ˆÑ{LoÙá :ãKÍˆ'\­|Ž~é*)c¶.»™]bC¿Ìwj¥ã`„
5á>»e›uŠÌ{ :9yœ22l$ŠD Ã°vÀðRyÔ’	‡BDÒÎC!rJ<Ør\rl &qZ&VXµá\ßÊVÎ¾kÎãŒü'¬ƒsÓXxÐŒsk­#„g2Og5æACZ&ß¡Hª[ÎlXÜ¼z§³jÝrœf`çµÚˆÀí²ÐÐýrœh<ËT„”È©tûð¹Ïb»|üœ7´>«Ã8ä’ò¡'«pÛP°ŠQÝgÊ†¦wÚog.¦îê6 GV¦•˜ƒØ*–k‹noÑÞ@He[qMÌCbí—¥&<ÀS«ó.VŒ	ß öU'Ú–˜Ô‹…Ÿ§&¹·Çu…º·võ¥™L@&ÆŠË¢Pn:†¾¬ñD¬ðªŸù…c;“5ïBW^ÈÊi¼±…´O`¹Ìnï™æ–ñU£ÐØbfäMSÎyÏõZøfã„ÝÙk´Þ•+/
©¼Bp…4Ê.u¾ÿÇ€Í›¶Šo—,9- …³+Ž\jÂ¼g¶U"¸‚Mö/Ô¸{ÔMÀÞ˜mÈ¥ðµ	±§gþ
 6.C0é¤s³JÇèLºÓ³,í±	×½ï`ÚiQZ½ée&°IC·š²ñÒYÏÛ¾vÆ6Ú™õ¹­²´bÙ%jË„ÅíÚT¤/£ìðÉîn¾–”2^£!"_Ý‘§®8#º!"±•ž‰ï³¦•öYQ’t"‚p{Ô–	k} W›öÈ¥»œ"ô•ä¸døÈþ4¡"®cIFV2ïDÙÓbª	îäCÿÉ>—R*cË­ï3
Û2í6>.ÄÎp"r§apI¾ÒÎVaÌ˜¤‰õ²œÌ¬Lìù´eVZé]ø>c*e©¬KÛHõ%%é'1vgl]Á"S˜1-‹¨,¾Š‰è6TÕ%ñ.°3«ØÆMpá™•fD¯3¶fCQ€o¬œo˜K[N1ÅºäCÀ:D~É°úJ4(Ùˆà‹ý$$xƒ/ú…^`ÂÀ¼ÈWøÅð°·-„^åúøñíöi§*´¸Ý5•v¡PÅ ÔX²m³¡on*á{ÔŽ»Ä:èëÊß"Q&¾U;	 ˜nŠÓ #1OËÂB¶+}ÃÑÃ«DžÕ¹)G\ÂØpdyÛƒÙp3ì\—ê2×0—rÇàÃ[ƒÜ¹öƒÜÉz7¹SçÞäÐÊ­8sg|yø†Qß‚†úM& ½ó±Ùl*ÃÈº&Dú9–Î<jÍ„G‰&b“h"ëûâ”#œ°]UFý”8:Hâf\Î#úeÛ%ðW´ª]‰¸¤Û&Öa»C z‘(šò ‘v:_6#Ùf=obÓ°3.6-âí¯¼]äá |o*•8Ê„FÏzK6¥Â¾ Î0*gXýÜcÌ	1,®‘gX&rq?¨!|Åž|g8é\š…×Ÿ^ækïÖåô†lÞ`èÉ:ï;ö:†å—/sNÕ{´o-ŒdšElzÔiÜÒÌat0\ìytp•As^šÙß¥åi:‘®ð}}5UPDž‡îhœªbPªB²UŸÝÞÆ:‡^æ+­U¬e=b«5’Öw Ë"Ÿ»8Xš³	£‘uBi@e$¹àŒ¬5EÊVW{4¶¶šýÉ˜·pÔ·8Ãˆ-[àÈ®ÆncÜ &$EXÌ]À…Pw*¥„ØR*’’JØÛYg­xÈ¬íÂÃH:g«ì;ú|…í †ò3|kI‰~.¬ö…ÊGlGcn­HnìˆÈ;-W1‡äŒÓ"?Ê-ãz0Æ#Œì3L5’›X£dF…]ÑàM[¹ƒ‘ýÅ&CxNsE§Dß ®,1£~‰€?ÊÆ“ðdû `‰d‹ÍYVpñEguž‡Ì·ñÇûöú™Iô›\@;5ãèÐN—cô¨°¶Ä@Fv>øÖ6:Ý†¼mÑŽ1[äÁøÆ·’]~Þi˜ŒÙÔ©q6²'´ÌÕÍ˜0°«ÃQcr¹šÇvq½5\Òìø³•:‡ÙC@rvÈu×cÜí¨hž¹òù¸8·åÏe"b)DÆ¶	º¥6î¢£º«†9±Þhs‹±ðÆ7`ÓÝÇûÌÔ5“4d³7'Öû~«Îî[ß¡“Bæ|F×°»BÚ
¾Ÿå)£™“VörfT×Ræ2ñ)Q8(M…ˆ¸¢ûBûü"˜„Nó{q¯r9œÂî`S½UD2	ØÔå°;w,½ÈrØiÒßÈHíƒ^ÔX$ö9æ‘‡ÿ`.N.„F²sÉµu@¿ÉÔZØ„&©àK]v×šZå´*Í•²Ÿ
G·1óÖ.ƒF µæÁÃþëÒ> ƒÏ‡ïØìd¡}b1l_øž‚¦ÑÜÙ²*†vÙÅÌMGjÅ?éÅ9s‰Rp~ÿ!Ãë¬uJ©¿[E -¬ó¹	UäB
W¥Ãb*rééNxðÉ†¡¯0˜€[ÝZb¼÷»ÂÜþ¸ÄXÍa\(èã"“¶…¹5§
s™¥*Äd³ÕÜp¯²
ÙÀmÐ°°Ï£²*X1çdíUÜ0Že>	ñ}—š3!b]˜½WÓ3Ñi{¨½BªL¼³ýXzÐŸH­i³ùIÏì¼ÖˆÐµžÙù&±ž¡+@Ú	'\¤©K$ö²õt•–9›Åå,´/Î¢Ûð€¬ýƒãÌ=‹æ\üû,±-ÅGk€Í\FÃYX‹giª
[rdÖiõÑ6 x‘ë‚—îêÆÞ
ÌNn§}—gËº# *˜Œ½ùqZ—¦eµŸuÇÛ°ëjg*íT[ƒVlÊ3•ÝüxÏ{×t4.Ï7ÀØÍr}1Ñ´äAchN8 4]²U¦?­ªó0PY˜sÞ²´P\QšŽ"éJ‘c×`p[E­Á†+Þê<±÷Ý†	›Mý<±&YÁ_q—bZ²’‰ÌJ¡¨‘Èr©$ZRÙð°­7ƒ‡½‚Ax(@„­VÆya¿(bœ¦ÛÆìÎ¦EMz‘	¤5WbóÔ:ºVž±®Áùôj›€…H(Ë0pÄZáÿ)4¦YY‘g®iÂ~`MQ$`KÐ3ö¥;‘H|éR)—"XŸš—à&gÚÆ¹vÝžá3ÉXzX$2M\¿çlì<[É°/cò¨GÖ¹oó´,ä£GžnÍ¹6=
€±«AôàÉ~wJê5®8øŠ/!"bho[gÇ#í4åð/Bª
KÖŽM8i/·òÝob3Ú»ãbåR+ø…}F<“6†šò ÑÃ¹T§cŽJ‹q†MFSë¥E©ë7e9WÄbôÅê
è¨1Þ³ÊAŠEùb„bJ®»Vñ^çÕ”Í£ÐÓÚóY{ãýÎ»GÍaÇÙ>×¤x¿g±)ÖÑÞÂÜÂ8ºÕÈ òµÀO¬Cpà³ô˜ñ8ì=é\÷ÌâÃîì ûÕAvRÖ"¥÷šöÞ¼l£µÒ™bQŒ%ü>³Áï4^Í@Dæò‰Å"°R]ñ}F9Ö×8¤ŸNÃÄž­&¹É–g+¦2çÙ‹E¿PÒ"O‡\’1’²†¤[p’€UÂ ì½u ¥)RN-™pHí.4Òû< }+Á†/_D>ãÕŠØ·6>R&àtvõØy_öLðeiÐX	kã²Áï¼µ¾È«+7NÙ÷ÝÉMùžTJ°¾J¢ßdZ+­ !ô“ÏÊEXÛ8°žôö×¹ 	—ù1Zù™(A!œÇáP²%’GW);-S:• ð2êÇv©W¨>]ž>1_Â„“é¸c†tW7Ô2EGÌ–‘_èä{›¨ÄŸuÖ>2ÚÜÈìæaÚ…)SÐ4Ì½˜-1I[Qþ8Ì’²P'Òsè?f“ªbûk‹±`#÷¸SŸk$/ÏÂ™ÌÓA}qb6.é,°bmNÉU7 KøÐ"KýsY¸+Ð³!bifHyÍiO“Òç2ôÏâ•\€ÃN¾[ÕéP#:tàY·jÇn‘îf½›€ykÎì6¼Y·fÏŒnŒFÙìŒûÙ¡Ÿâ„|ófïì6ˆ×:mNœfã2ñ|™áàc=y3ëø»/RmhÏ¥ÖžB6¸·1ÖÑ-°ª¾ÓË:Ðskç‰ l˜¨BD‘Ì9E¬îëdËÈ¢R†¾ôâ2*ÂLðY43ëk†Å4¾fÃÅZ/Œ•›å)cöØþ¦Áp˜ôÕÉa‡°iå™•úUG>†	Ð#›öÙ‰ÊÁô™‡ÜêÔEÎ•» [æê„¼Æ~‰ÚX½Ê·ôªbˆ™’ùDæ~š *¼ ¥µih¨Ä3-¹°ølÏ†Øj/ÄvÉö)Ò S)ÎUÜ‚ëIÙ€TNÌ Ç†õåšŠý)¾PØóàr"¥Ù’HÄÝ¸Euz™liŸ!­T¡²g£î®pÉ*—~š˜­«ê“+N¬ýîìÀSkžùâfVÐéu&À”À†‹YÎ&œ$8³Þ™E*_d036þ0»µPÏÄ‘CÛn’ô<žnë©y< NUé´\ˆuZXIfL¸*f$·—¬ÕÔia¤Çz{Ñ®ÈôÌMdá³•±Hì4•™hÃÈ’Q ¬uõÖv`ÊK"ëLx‰,AuÉ¨D\¨Tìe™DáDrI0Ib­@%é ’@ŸnæTµŒK—OëS£ÆEIñmÖÄºþmÈT¸°°©ÍŽ ùê³'ö:¥¾×—¤[žêTt{\—uûò,,Té¥BÍ—­-VwûVðà:J¡³káÁ…†]>T/aÂ—¶Ý2a!½~À¿s]çC&“W©_bú^çD¡¤ãºàg](–'T^
P…Ž;„Â‹ûK¼[r1âÖÌ5ˆ_ÿúÊ
Öot±‹ñ¶fVkðæMV8Y‹;#å²ä$^¥ä\Lá•‹çÕÚ·fUª^Ôñà»qëruk§³•ëw‹Â;õçñ·ö8®Áõ8@J]7¡ÖÊ(>ê<]üâ!ØÇ„¯!k@âÃ	åøRc)/YëãvÍÔïNµ‹Qç`>H@\ì°oA:â
" žndÏ@§ë‚Db˜…ÙØÁßìC]H
vÅ^'#‘–aXK0e‚Þ
»b.üðS+jð­4(fº“ô¶€ËA¦\þ²if!@×DÄ•&Í­…(­ICC‘„_øÔ&{•ÞT8ÄCAùi.QlG‚fë¹Y’§;ã¤šî*¨}u!á½‰šå]«ašnzÍœS*§ft@§Á§	ýxúî­Ó¦ºFa•aê2‘œÏ@˜lzÎ†4Ì–ªÐ=ÇÜ:Ã†FÕTºÅ¬ElhL¤Nt†K¯`gŠ3»ÂÝú}&Ðö“Ó‘‡¡/á”÷ê¶Luî"SÓ'Ê\f¶g•4;÷ÕWÉòlÏJÌ…‘#t.÷@öØ2Ü¡?v—>¸(1{l%´h<ð76øVv«À·ÊuÔ\‰\~†sƒëÂröØŠi4T8JDQæl³a•ÇqxÂ¹ÛQµ$¬½¶ÐDÆjZ™}®ñ,Ê|P†Q óGlhtnÄ*ëZ–æ…DÒ„EÌ–9£üÊvQøYPÆ™—ñåfÎü«¨JÔŠ	¾utÇ8s©|ûˆDÁŒ‡NñHÓb²ÝÉÉú$¾Z7å¿Êó_eÝQWõ.ô¹"72{ï3£µ+³sÅflnÙÐ*(ÀìtüžëÂ|6´7€•øµ¬0? VLð-ãyîúŠ+§î(sÆcwdu?tæúc©”KÍ˜°:öáuW&~>Ï
¶ÛXpŒÜüyÞÆ!gé]ãOzŸ[Ùáõ™Ï–øzË„Upëv<XDÖÇíÁ(!7ôÝÁÔDÎ–ö.‹®‚®£QK&¬L:'S$EÎÆ„¢níÛd„P>½ÌÖ>”Û/|8
›×*Kz–¦™@Úz"á<ó’ž¬—=Ã8Žç
™*h	Û®jÏ„Í•r! õ!K9'¥¸J]ž^åÀ‰ÊS™ ÉŸ”–vD\Fíõ³8ÒÎfåjÓýZSyÌž,×œPa²©ÙÌìS3–ç‘±É{ÝéYVPÎçic/S×¤…Tãtº1ZQ›Ýyõ Øþ:Xjv]–Úœ§-î†Ù*[,pçÏÖÅ9mevqiË`šåö5H)Bm˜KI…GÙ±3b8P^F|îS;§]ª
åçaÆ¶ÍÕµTIó]ÏTç©¾¸y(‚t ½lœ)ð^¶SÕ.\Ñ3£0)áœgKl“©sÛôØ„11+zä_fR“ÐÃvlfÝÒ:¡4‰B5f‹^Íìrš,oŽ‰`Cdj‚ï öY¸aÁz=6›÷¼SQÉ‘˜cÙÜ£l/µgÂ¤ç½‡1™0aòÙ^WÒ¹°(=¶HB¶X”ÏƒÔÔJÚñ``çY`0äòE~¶×Œß¹tÂ-@ÈàB§SšßLªôÏÝaº•†ºÐÇèÆ`O­®Ï¥ÈÏõg(ïs±ÊÏSkEnc¨Ì¬²Í¡òõ,}˜ÊæPùjh%ïÙ:K\8P#úÈ¼û(Ý$tËPNhàúiLÓÏæKÎ»+îéÇ%àpíËÖØ~–§:4ÑòÏÊ$‹ÊÑH^£¤ìâ{àuFU(¬ëzawâû5çADZ7J&@šé SO³1i%`Q^/h“–¹ÏyÅ2užiÕ6¡Wy€Ú•Ëå(L†)ç¨Ãn*¨õ/z™¬ÕIY­¶R5kÕÃ¼;Úà’:T9[ÄAY	1íùpƒpÈÊ¡¬µÏ\¤³!qóõÿò7í×.žS!—9?ïÎ‡¾<ýg~æ‰‰ˆ¥³ÉÂ¥NxÐ±Kù˜ËHÌÜdDRŒðWÍ“Bp©âyjåê 2¡Ô†	ú°“Y³§ªÏ³§Ö®é(I‘zÔ”		u…œ†˜ö2´AÐëÅ'/dêŠI8›Øp!c•4_e"ÿ¹ŸKÉ–n2·Z™<R.Ö1}ÉzŽv»ZZX¨€¸Ý(Ö‘Ûå1È¯™À 	¸Ó0JÌ(ý1c¤¾wâ„âò0+qÕ”X°ÔåÔçÕÀÎ‹†ï3Òš²Åj9Júe.]¬["@{ãÒì•o@Sùc”lj¼ò­UíòW~.eâ³E+ßîð'™ëO@€„s€­~¹ò­¸à	•¥É53t6±èqgXD}YM1^VSvYU©ªq!ò 4Ö• \aWÊ>i_°i—*°6‘·P	cN{°
ÎíÑI#J œÇœüºûZ0±²ÅÑëL€­o›·Hcš‡|Æb%­ÍÄÐ$!Û2\µc.²Ÿ…˜KÉ…®ìw§d+K]Ù×¥§6Là­6htAu*QøE®¶‹³áRP‘C¶ š`Ü©&ar†™BçywiÜetÐ`­Š\ç±âÇi¸ã@ÙÇìŽçAž*ÃGºŒe9ÔÐÚTX1séQ[,FÖ®è5|ÝEé€-³‰ê¾YL’!¼Ç²Ÿ4Ê	Óê6çÌe«%ˆG¶ Ù"
ÕØŠoÃëýÅ§ß¹no,Šž>su9O`˜¹Ö­öÀ¦J*×™ÐŠ]â5rîìI*Œ:øØkZªÐžn¤J b}2l
+‹5gQ‡!›(Ú‘5|.Ç²WùÎS¶ú–Ê^Íc…ngÁ
ÝÚWÂ	=²/±æ:ß†n{v7p•Yë…ÔAáJDl|ÄÞ\RÈ,I(è¯ëWÕiâb¯(6%Ü˜/}†ê«Ð”}âÕ+‡vN	nð_z„]H&U>2=ê RÇ@¨Í¼š\å’µâouGctTfytc¹c•]µ†e_a6Î¯[¬¬‰‹]åbwX¢äÍŸ(Þ#ŸFí	“m‹`ngÔFüÛ#•Ù;çVç\wLî2>ÊöböT„ÊÕq…l(XU¨…×9Ï¥ÜJ¶3‘9@|eÄbª”µSã<Ä¹H}1;e3ÑØ×N1$ÛMd¥,(o …µ­DAoEbŠÌ=ú—{q™x0äæÎÐ£
{¿A½æüèXë´E¶ð*e_•¤šã.çŸ‘sŒÆðE®
Îè§ÂÚ§€ºüyèQK&¬LÜtwä±–|R…½ËÜP†öª°FwbƒZÆ&ÀfP„_Vioî-•<L&Ÿÿ¡TöZèÐ˜úYh¥ÍÜº
¶²_Õ†	ëƒÈR‡%³!aœMØ¢ºKÂékEŠµÜôÖy·p#p§–iËƒ0—>£`;µ4À¨qêŸOÅDºCNe{j-2ˆ<T…Hd1MósåQ<¸Ì®%\²aq-™’ëì¦K6oÄìº’%"öæ|ƒ§ñ|vMqŠ	~v2Î«]…EÒ>7ã<ríÏBX§÷&˜`CÌâƒù]‘ûãpÂun¶1,›ìV\¡Ü¦çÚ÷
¾b?…]±?[B
l I»19æ;6™P±â‘ð:£8½ùižÙ©5Ü(XÆkP.ÐVsO°1)#|êíVQèw€Ïvï»Ú‘ü8%ç-ÊÂ¶îÌ€KxÀcëXŒ¸Š¿(Æ’-áWï\cð"›$vß,çÛþ˜¼7Â´Ype;=0—ÝåÚÄ7‹ºvÞZœQž¦ Biq.ìsvyÿaËãÛmgå—‡{d
[t)EÆ&{Ùe>Á+­ ÄaÂ¦v÷è1Ï¡*DœÉ€ó
C¡:3¡êÅWÉLä@ø;QÉÈQØ9Çª*plîŸÂÎý´øýÂØ‹2ç³äö¹.UÒ»°	ìšO˜ön…!coÇÉ$é~QQÎdÀ&šÎ¬Ý¢¦<µdÂáæ¥ãòÀ²8º(‹qšO1ï€‹@Zæ‡¡H\Þ(ÇrhMŽÐ„ëŒÒ]Ýø¨Û^ÈâYÆgÖCŽÅá%a1ŸÚ!í¸pHíKÃaFµÌ;udâ<ð¥ÆãÛ/í;Üî€«¬­°¦	øÂ:Cj~ö8 egà¢¹DX–2ñS¶KåÄ¢B }éq¦7*í}æ„£êQN¬å~z:ïkà£\dc¾³fÒyxQ‡‚à¹âÊIÏÿz§¾4tmbßéÿYÏVÿ¯œtrú%ÐŠ´µ­‰(
Þ³}ÒÉs3PN&¥g‡l°-J¿Ðàé#ôÛåú_Ûÿøþ­3þÛäü·Îúo›÷ß&ó¿Mîÿµ°ÿÛåÿ·| Xû>	‰2Q™ôÃaÈ–}P±/O¨|a+P~E“qÛs1ñEÞy8ëà~ý&TËÔ®~…	×½¨‰ß/ËúÌå³u¨ñÿòbÑ7¿ò„ùâÂÄ·ÞuÔ„¸}Æ ÅA°¥QŸ„' ¼ÌÅû'©}ÀÝÆpNRË°³xY&y·¡Y'­Òoò µó¼×$ÈÞZÿ™°ÝÊØWwà»µÊÞ: |Ñ)÷bGÀø2XË‚Ð“4ôåŒUäŸXŠÌ×†¦Â~šr…;NEçqS•¢W™€öÌB‘Mîôše{~çºÎ¯°b‘TÊù!,à:yâ2bƒîÊKëÃTdžnÁ3+kîçÃ¡Ÿ#ýS€g¾ˆéÀvgÖSÂˆ„}i¤¼ÄÆ…A`íìæÆ@zšeáM6¾@]õ‘CyöÜ~úM ÖúV‡Þ4Flµ›¦#+Áƒö¹5×á¦ïž„¦6Zë‘Ý¾q±åµŸÚ¥µ7Ð¹ôú©]²B„ËB\»æ-ÁïÞ:'”ÖéÂã·gÎäú¤¹æ9ƒX½LãFzãe}‹Ùàw=·D=m”€©{öúmèéÌN¼“h½Ë«N¦Æ–ËÓ3{ZZÌd“~»/µàr·¦±•Ù@çªò<íQ´²ž"Ù§|×:¦™µeŽ¹ “ù¯˜ÆÔþz.CÆ&Pg·~Ü¶_†Ïlç_wàæò Ã&ø›7(N•]˜4¾Ï©Fª,…¾­êÇTm8Ñ(¬Õ8Ð1Š2pÙ×¦ÝîÄ&ÛŸp±ýÙWqcafgc£Ú8_÷ pý<U
1&vÉf®
£‰Ì£p4.\ÁvÇofÙŒM¸´ÙÀv€&u#&øöõÍêª÷˜å^ç)úØœN³n‹‡6>Ì`&ÈŒÈ8°“Œ|‘¹A8´(\Óû<óÄÇüHœågvå)sU¤YÑPv:
¾Ï
ßÚ´fwp!#»+°ð>ç\Ø%‚ÉDáÝ4S®Ìó4çDdh·MÄI-¹°Öf|wÞfc»ôcÞØ¼YŸªZ›E`b‰À„zßŒ ´ê|	:f‘u>äÌ—l#ÄUü@„lÂ L6T¹gfodŸš+ÏW1)0cp'&5–²@IRäóQ‰}Á¢%ü6†sá)•åR„slpgÃÕ>E!7™W_Æ*1ÏÆVÒ¾ø¬ÍJ2çšõ¸<¿áÅ´<ÈùNqëlWi”ù®*Gl1¶³ÔNùOY•«ÌÒXk`Î²þz~ÎõüÌÚä*—Z1Á¿ÊA­*žÀ†‡õæÇL¯¹Ÿ&TA!á;Sz”Cº!LÔm±#ËzŽø>'7¸B)G2<±â`W­ßç_Ú»Ó/a	šr"Ò}óqsºí­*ÖÝùÆêa&A:J¶°ÏÙ¼Ó-ïeŒažÎåŸ‹Ä*òM¿ÏÝJÃ„q±-ƒ ü”5×ýÜ*ô/Âú"áhó¯žs®]¥V¾{Œ_BkìKÉ7êÜ~úù ÇÖ'íX$ÁXF+Qè)D˜ Ø‹àKŠ{¾æq^É¡(£ÂùUF@àÒyFÒyªbíëÏM(™Ž†ËÄŽ©ŠéüüéþÊ\9E
ßW73æÛN1–N` aIŸHN”¦çÊiöR4ÛšL0ÐqË™†Å8L Q,zt`2¶pè˜ÚÚÛ´úó10Ö` 5]Ç’ðDPAˆeUçžséÓèïxè$©ÓDO9"—$ÖSþ2§øz³¿Åp0Oâx_ÉÕ@À†£2'ZpàãtŠã]ÁÏ/U‘ÆáùÀáå²(óAî: ´¥Ú†Î3©ç#M_ÊÐê¤C3}ÍþV
0)ðŽ™êœ?–§½ó´Äù
¹´.@2ð[î¤S ÑÅVúƒ‚÷X(dM07Q:Çmå,êlnkÒÃ¹p¾ËááKõÍ}W­ŽVúƒu—ÛŽJt¼‹&~Tx^MzµÞ:W®‡ãš†jÜêš—JV;‚†×ZßÕÁ5›03æuúnU4Qó·èÙŸyÚáÓú¡ë}›×Ï°VÛêëíïš÷ðÛF€¼øæî¹	ç¥(D&bç£˜ý(E ó(éxœª‚Æîîîã‡oÓãàgxªww÷8{û»»Àá>Ú;pváïÇ»ß83Ø¥7TŠT‰óôâ÷¦c)£KúiÊáFsSÏÞ§ƒçû»žîî>yúøÞþ®ãcöñç{‡‡{»Oîáw¢ñÝ£ý'ïí:'/<~û7e'Ï÷Ÿ<ÙÛÝroÿ ú>LÒç{wî?zúð 2_'˜Qâùþ½ÛúÝóÍòþ¯wý'Œjÿÿ7üýÓÿûÿ–÷?~híÿ½Gö¾qr"qÑó/¾ÿïž»çî¹{îž»çî¹{îž»çî¹{îž»çî¹{îž»çî¹{îž»çî¹{îž»çî¹{îž»çî¹{îž»çî¹{îž»çîùŸ÷üq÷   
