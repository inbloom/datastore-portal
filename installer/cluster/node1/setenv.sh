<<<<<<< HEAD
JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF8 -Dorg.apache.catalina.loader.WebappClassLoader.ENABLE_CLEAR_REFERENCES=false -Duser.timezone=GMT -Xmx1024m -XX:MaxPermSize=256m -Dsli.encryption.keyStore=/opt/tomcat/encryption/ciKeyStore.jks -Dsli.encryption.properties=/opt/tomcat/encryption/ciEncryption.properties -Dsli.trust.certificates=/opt/tomcat/trust/trustedCertificates -Djava.net.preferIPv6Addresses=true  -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv6Stack=true"
=======
JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF8 -Dorg.apache.catalina.loader.WebappClassLoader.ENABLE_CLEAR_REFERENCES=false -Duser.timezone=GMT -Xmx1024m -XX:+CMSClassUnloadingEnabled -XX:+CMSPermGenSweepingEnabled -XX:MaxPermSize=256m -Dsli.encryption.keyStore=/opt/tomcat/encryption/ciKeyStore.jks -Dsli.encryption.properties=/opt/tomcat/encryption/ciEncryption.properties -Dsli.trust.certificates=/opt/tomcat/trust/trustedCertificates -Djava.net.preferIPv6Addresses=true  -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv6Stack=true"
>>>>>>> 22a21a2baeb4c149f26bfca7741be1b9172bd238
