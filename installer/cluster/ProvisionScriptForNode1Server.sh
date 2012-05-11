#!/bin/sh
#Before running this script,
#MAKE SURE TOMCAT_HOME is set correctly
 
#The setenv.sh has settings for the JVM that are used when tomcat starts
  scp /jenkins/workspace/ProvisionScriptNode1/installer/cluster/node1/setenv.sh tomcat@devlr1.slidev.org:/opt/cluster/boot/
   
# Adding jars that liferay depends on to lib/ext
  scp -r /jenkins/workspace/ProvisionScriptNode1/installer/cluster/node1/ext tomcat@devlr1.slidev.org:/opt/cluster/boot/
   
# Update catalina.properties to look for jars in the directory created above (lib/ext)
  scp /jenkins/workspace/ProvisionScriptNode1/installer/cluster/node1/catalina.properties tomcat@devlr1.slidev.org:/opt/cluster/boot/
  
# Copy the portal.xml file into tomcat 
   scp -r /jenkins/workspace/ProvisionScriptNode1/installer/cluster/node1/localhost tomcat@devlr1.slidev.org:/opt/cluster/boot/ 

# Copy the portal-ext.properties file into tomcat
  scp /jenkins/workspace/ProvisionScriptNode1/installer/cluster/node1/portal-ext.properties tomcat@devlr1.slidev.org:/opt/cluster/boot/
  
# Copy the portal-ext.properties file into tomcat      
  scp /jenkins/workspace/ProvisionScriptNode1/installer/cluster/node1/web.xml tomcat@devlr1.slidev.org:/opt/cluster/boot/
  
# Copy the portal-ext.properties file into tomcat
  scp /jenkins/workspace/ProvisionScriptNode1/installer/cluster/node1/server.xml tomcat@devlr1.slidev.org:/opt/cluster/boot/
  
# Copy the portal-ext.properties file into tomcat
  scp /jenkins/workspace/ProvisionScriptNode1/installer/cluster/node1/repository.xml tomcat@devlr1.slidev.org:/opt/cluster/boot/
 