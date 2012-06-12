sudo touch /opt/environment.properties
sudo chown tomcat /opt/environment.properties
sudo touch /opt/portal-ext.properties
sudo chown tomcat /opt/portal-ext.properties
sudo ln -s /opt/environment.properties /opt/tomcat/environment.properties
sudo ln -s /opt/portal-ext.properties /opt/tomcat/portal-ext.properties
sudo mkdir /opt/deploy
sudo chown tomcat:tomcat /opt/deploy
sudo mkdir /opt/tomcat/lib/ext
sudo chown tomcat /opt/tomcat/conf/web.xml
sudo chown tomcat /opt/tomcat/conf/server.xml
sudo mkdir /opt/tomcat/lib/ext
sudo chown tomcat /opt/tomcat/lib/ext
