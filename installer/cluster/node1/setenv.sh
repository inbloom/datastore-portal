
JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF8 -Dorg.apache.catalina.loader.WebappClassLoader.ENABLE_CLEAR_REFERENCES=false -Duser.timezone=GMT -Xmx1024m -XX:+CMSClassUnloadingEnabled -XX:+CMSPermGenSweepingEnabled -XX:MaxPermSize=512m -Dsli.encryption.keyStore=/opt/tomcat/encryption/ciKeyStore.jks -Dsli.encryption.properties=/opt/tomcat/encryption/ciEncryption.properties -Dsli.trust.certificates=/opt/tomcat/trust/trustedCertificates -Djava.net.preferIPv6Addresses=true  -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv6Stack=true"
 
