#!/bin/sh
#Before running this script,
#git clone git@git.slidev.org:sli/liferay.git
#this script needs elevated privilidges
#MAKE SURE TOMCAT_HOME is set correctly

cd /opt/boot
export TOMCAT_HOME=/opt/test 

wget http://downloads.sourceforge.net/project/lportal/Liferay%20Portal/6.1.0%20GA1/liferay-portal-6.1.0-ce-ga1-20120106155615760.war
mv liferay-portal-6.1.0-ce-ga1-20120106155615760.war portal.war

cp /opt/boot/portal.war TOMCAT_HOME/webapps
cd TOMCAT_HOME/webapps/
ls TOMCAT_HOME/webapps
 
#sh tomcat@devlr1.slidev.org:/opt/test/bin/catalina.sh start
/etc/init.d/test stop
/etc/init.d/test start
sleep 3
rm -rf TOMCAT_HOME/webapps/portal.war
/etc/init.d/test stop


#The setenv.sh has settings for the JVM that are used when tomcat starts
 # scp /jenkins/workspace/ProvisionScript/installer/conf/setenv.sh tomcat@devlr1.slidev.org:/opt/boot/
  #chown tomcat:tomcat tomcat@devlr1.slidev.org:/opt/test/bin/setenv.sh
   cp /opt/boot/setenv.sh TOMCAT_HOME/bin/
   
   
# Adding jars that liferay depends on to lib/ext
  #mkdir -p tomcat@devlr1.slidev.org:/opt/test/lib/ext
 # chown tomcat:tomcat tomcat@devlr1.slidev.org:/opt/test/lib/ext
  #scp -r /jenkins/workspace/ProvisionScript/installer/conf/ext tomcat@devlr1.slidev.org:/opt/boot/
  cp -r /opt/boot/ext TOMCAT_HOME/lib/
  #chown tomcat:tomcat tomcat@devlr1.slidev.org:/opt/test/lib/ext
 # chown tomcat:tomcat tomcat@devlr1.slidev.org:/opt/test/lib/ext/*.jar
 # chmod 755 tomcat@devlr1.slidev.org:/opt/test/lib/ext
 # chmod 755 tomcat@devlr1.slidev.org:/opt/test/lib/ext/*.jar

# Update catalina.properties to look for jars in the directory created above (lib/ext)
 # scp /jenkins/workspace/ProvisionScript/installer/conf/catalina.properties tomcat@devlr1.slidev.org:/opt/boot/
  cp /opt/boot/catalina.properties TOMCAT_HOME/conf/
  #chown tomcat:tomcat tomcat@devlr1.slidev.org:/opt/test/conf/catalina.properties
  #chmod 600 tomcat@devlr1.slidev.org:/opt/test/conf/catalina.properties

# Copy the portal.xml file into tomcat 
 #mkdir tomcat@devlr1.slidev.org:/opt/test/conf/Catalina/localhost
  #scp -r /jenkins/workspace/ProvisionScript/installer/conf/localhost tomcat@devlr1.slidev.org:/opt/boot/
  cp -r /opt/boot/localhost TOMCAT_HOME/conf/Catalina/
 # chown tomcat:tomcat tomcat@devlr1.slidev.org:/opt/test/conf/Catalina/localhost/portal.xml
 # chmod 600 tomcat@devlr1.slidev.org:/opt/test/conf/Catalina/localhost/ROOT.xml


# Copy the portal-ext.properties file into tomcat
  #scp /jenkins/workspace/ProvisionScript/installer/conf/portal-ext.properties tomcat@devlr1.slidev.org:/opt/boot/
    cp /opt/boot/portal-ext.properties /opt/
