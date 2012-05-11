#!/bin/sh
#Before running this script,
#git clone git@git.slidev.org:sli/liferay.git
#this script needs elevated privilidges
#MAKE SURE TOMCAT_HOME is set correctly

 
export TOMCAT_HOME=/opt/cluster/test

wget http://downloads.sourceforge.net/project/lportal/Liferay%20Portal/6.1.0%20GA1/liferay-portal-6.1.0-ce-ga1-20120106155615760.war
mv liferay-portal-6.1.0-ce-ga1-20120106155615760.war portal.war

cp /opt/cluster/boot/portal.war /opt/cluster/test/webapps
cd /opt/cluster/test/webapps/
ls /opt/cluster/test/webapps
 
#sh tomcat@devlr1.slidev.org:/opt/test/bin/catalina.sh start
#/etc/init.d/test2 stop
#/etc/init.d/test2 start
sleep 3
rm -rf /opt/cluster/test2/webapps/portal.war
/etc/init.d/test2 stop


#The setenv.sh has settings for the JVM that are used when tomcat starts
 # scp /jenkins/workspace/ProvisionScript/installer/conf/setenv.sh tomcat@devlr1.slidev.org:/opt/boot/
  #chown tomcat:tomcat tomcat@devlr1.slidev.org:/opt/test/bin/setenv.sh
   cp /opt/cluster/boot/setenv.sh /opt/cluster/test/bin/
   
   
# Adding jars that liferay depends on to lib/ext
  #mkdir -p tomcat@devlr1.slidev.org:/opt/test/lib/ext
 # chown tomcat:tomcat tomcat@devlr1.slidev.org:/opt/test/lib/ext
  #scp -r /jenkins/workspace/ProvisionScript/installer/conf/ext tomcat@devlr1.slidev.org:/opt/boot/
  cp -r /opt/cluster/boot/ext /opt/cluster/test/lib/
  #chown tomcat:tomcat tomcat@devlr1.slidev.org:/opt/test/lib/ext
 # chown tomcat:tomcat tomcat@devlr1.slidev.org:/opt/test/lib/ext/*.jar
 # chmod 755 tomcat@devlr1.slidev.org:/opt/test/lib/ext
 # chmod 755 tomcat@devlr1.slidev.org:/opt/test/lib/ext/*.jar

# Update catalina.properties to look for jars in the directory created above (lib/ext)
 # scp /jenkins/workspace/ProvisionScript/installer/conf/catalina.properties tomcat@devlr1.slidev.org:/opt/boot/
  cp /opt/cluster/boot/catalina.properties /opt/cluster/test/conf/
  #chown tomcat:tomcat tomcat@devlr1.slidev.org:/opt/test/conf/catalina.properties
  #chmod 600 tomcat@devlr1.slidev.org:/opt/test/conf/catalina.properties

# Copy the localhost file into tomcat 
 #mkdir tomcat@devlr1.slidev.org:/opt/test/conf/Catalina/localhost
  #scp -r /jenkins/workspace/ProvisionScript/installer/conf/localhost tomcat@devlr1.slidev.org:/opt/boot/
  cp -r /opt/cluster/boot/localhost /opt/cluster/test/conf/Catalina/
 # chown tomcat:tomcat tomcat@devlr1.slidev.org:/opt/test/conf/Catalina/localhost/portal.xml
 # chmod 600 tomcat@devlr1.slidev.org:/opt/test/conf/Catalina/localhost/ROOT.xml

 # Copy the ehcache directory into tomcat 
  
  cp -r /opt/cluster/boot/ehcache /opt/cluster/test/webapps/portal/WEB-INF/classes
  

# Copy the portal-ext.properties file into tomcat
  #scp /jenkins/workspace/ProvisionScript/installer/conf/portal-ext.properties tomcat@devlr1.slidev.org:/opt/boot/
    cp /opt/cluster/boot/portal-ext.properties /opt/
# Copy the server.xml file into tomcat
cp -r /opt/cluster/boot/server.xml /opt/cluster/test/conf/	
# Copy the web.xml file into tomcat
cp -r /opt/cluster/boot/web.xml /opt/cluster/test/webapps/portal/WEB-INF/
# Copy the repository.xml file into tomcat
cp -r /opt/cluster/boot/repository.xml /opt/data/jackrabbit
