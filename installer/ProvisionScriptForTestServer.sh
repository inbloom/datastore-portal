#!/bin/sh
#Before running this script,
#git clone git@git.slidev.org:sli/liferay.git
#this script needs elevated privilidges
#MAKE SURE TOMCAT_HOME is set correctly
mkdir /opt/sli
cd /opt/sli
#export TOMCAT_HOME=/opt/test 

wget http://downloads.sourceforge.net/project/lportal/Liferay%20Portal/6.1.0%20GA1/liferay-portal-6.1.0-ce-ga1-20120106155615760.war
mv liferay-portal-6.1.0-ce-ga1-20120106155615760.war portal.war

scp /opt/sli/portal.war tomcat@devlr1.slidev.org:/opt/test/webapps
cd tomcat@devlr1.slidev.org:/opt/test/webapps/
ls tomcat@devlr1.slidev.org:/opt/test/webapps
 
sh tomcat@devlr1.slidev.org:/opt/test/bin/catalina.sh start
sleep 3
rm -rf tomcat@devlr1.slidev.org:/opt/test/webapps/portal.war
sh tomcat@devlr1.slidev.org:/opt/test/bin/catalina.sh stop


#The setenv.sh has settings for the JVM that are used when tomcat starts
  scp /jenkins/workspace/ProvisionScript/installer/conf/setenv.sh tomcat@devlr1.slidev.org:/opt/test/bin
  chown tomcat:tomcat tomcat@devlr1.slidev.org:/opt/test/bin/setenv.sh

# Adding jars that liferay depends on to lib/ext
  mkdir -p tomcat@devlr1.slidev.org:/opt/test/lib/ext
  chown tomcat:tomcat tomcat@devlr1.slidev.org:/opt/test/lib/ext
  scp /jenkins/workspace/ProvisionScript/installer/conf/ext/*.jar tomcat@devlr1.slidev.org:/opt/test/lib/ext
  chown tomcat:tomcat tomcat@devlr1.slidev.org:/opt/test/lib/ext
  chown tomcat:tomcat tomcat@devlr1.slidev.org:/opt/test/lib/ext/*.jar
  chmod 755 tomcat@devlr1.slidev.org:/opt/test/lib/ext
  chmod 755 tomcat@devlr1.slidev.org:/opt/test/lib/ext/*.jar

# Update catalina.properties to look for jars in the directory created above (lib/ext)
  scp /jenkins/workspace/ProvisionScript/installer/conf/catalina.properties tomcat@devlr1.slidev.org:/opt/test/conf
  chown tomcat:tomcat tomcat@devlr1.slidev.org:/opt/test/conf/catalina.properties
  chmod 600 tomcat@devlr1.slidev.org:/opt/test/conf/catalina.properties

# Copy the portal.xml file into tomcat 
mkdir tomcat@devlr1.slidev.org:/opt/test/conf/Catalina/localhost
  scp /jenkins/workspace/ProvisionScript/installer/conf/ROOT.xml tomcat@devlr1.slidev.org:/opt/test/conf/Catalina/localhost
  chown tomcat:tomcat tomcat@devlr1.slidev.org:/opt/test/conf/Catalina/localhost/portal.xml
  chmod 600 tomcat@devlr1.slidev.org:/opt/test/conf/Catalina/localhost/portal.xml


# Copy the portal-ext.properties file into tomcat
  scp /jenkins/workspace/ProvisionScript/installer/conf/portal-ext.properties tomcat@devlr1.slidev.org:/opt/test/portal-ext.properties

sh tomcat@devlr1.slidev.org:/opt/test/bin/catalina.sh start
tail -f tomcat@devlr1.slidev.org:/opt/test/logs/catalina.out