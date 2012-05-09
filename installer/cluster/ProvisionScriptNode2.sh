#!/bin/sh
#Before running this script,
#MAKE SURE TOMCAT_HOME is set correctly

SOURCE_HOME=/opt/cluster/boot1
TOMCAT_HOME=/opt/cluster/test1 

cd SOURCE_HOME
pwd
wget http://downloads.sourceforge.net/project/lportal/Liferay%20Portal/6.1.0%20GA1/liferay-portal-6.1.0-ce-ga1-20120106155615760.war
mv liferay-portal-6.1.0-ce-ga1-20120106155615760.war portal.war

cp SOURCE_HOME/portal.war TOMCAT_HOME/webapps
cd TOMCAT_HOME/webapps/
ls TOMCAT_HOME/webapps
 
#sh tomcat@devlr1.slidev.org:/opt/test/bin/catalina.sh start
/etc/init.d/test stop
/etc/init.d/test start
sleep 3
rm -rf TOMCAT_HOME/webapps/portal.war
/etc/init.d/test stop


#The setenv.sh has settings for the JVM that are used when tomcat starts
  
   cp SOURCE_HOME/setenv.sh TOMCAT_HOME/bin/
   
   
# Adding jars that liferay depends on to lib/ext
   
  cp -r SOURCE_HOME/ext TOMCAT_HOME/lib/
  

# Update catalina.properties to look for jars in the directory created above (lib/ext)
  
  cp SOURCE_HOME/catalina.properties TOMCAT_HOME/conf/
   

# Copy the portal.xml file into tomcat 
  
  cp -r SOURCE_HOME/localhost TOMCAT_HOME/conf/Catalina/
  

# Copy the portal-ext.properties file into tomcat
   
    cp SOURCE_HOME/portal-ext.properties /opt/

# Copy the server.xml file into tomcat
   
    cp SOURCE_HOME/server.xml TOMCAT_HOME/conf/
	
# Copy the web.xml file into tomcat
   
    cp SOURCE_HOME/web.xml TOMCAT_HOME/webapps/portal/WEB-INF/

# Copy the repository.xml file into tomcat
   
    cp SOURCE_HOME/repository.xml /opt/data/jackrabbit

