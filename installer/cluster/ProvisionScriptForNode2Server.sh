#!/bin/sh
#Before running this script,
#MAKE SURE TOMCAT_HOME is set correctly
 
#The setenv.sh has settings for the JVM that are used when tomcat starts
  scp /jenkins/workspace/ProvisionScriptNode2/installer/cluster/node2/setenv.sh tomcat@devlr1.slidev.org:/opt/cluster/boot1/
   
# Adding jars that liferay depends on to lib/ext
   
  scp -r /jenkins/workspace/ProvisionScriptNode2/installer/cluster/node2/ext tomcat@devlr1.slidev.org:/opt/cluster/boot1/
   

# Update catalina.properties to look for jars in the directory created above (lib/ext)
  scp /jenkins/workspace/ProvisionScriptNode2/installer/cluster/node2/catalina.properties tomcat@devlr1.slidev.org:/opt/cluster/boot1/
  
# Copy the localhost folder into tomcat 
   scp -r /jenkins/workspace/ProvisionScriptNode2/installer/cluster/node2/localhost tomcat@devlr1.slidev.org:/opt/cluster/boot1/
 # Copy the ehcache folder into tomcat 
   scp -r /jenkins/workspace/ProvisionScriptNode1/installer/cluster/node2/ehcache tomcat@devlr1.slidev.org:/opt/cluster/boot/ 
 

# Copy the portal-ext.properties file into tomcat
  scp /jenkins/workspace/ProvisionScriptNode2/installer/cluster/node2/portal-ext.properties tomcat@devlr1.slidev.org:/opt/cluster/boot1/
# Copy the web.xml file into tomcat
  scp /jenkins/workspace/ProvisionScriptNode2/installer/cluster/node2/web.xml tomcat@devlr1.slidev.org:/opt/cluster/boot1/
# Copy the server.xml file into tomcat
  scp /jenkins/workspace/ProvisionScriptNode2/installer/cluster/node2/server.xml tomcat@devlr1.slidev.org:/opt/cluster/boot1/
# Copy the repository.xml file into tomcat
  scp /jenkins/workspace/ProvisionScriptNode2/installer/cluster/node2/repository.xml tomcat@devlr1.slidev.org:/opt/cluster/boot1/

 