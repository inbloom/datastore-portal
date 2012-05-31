#! bin/bash
cv1=`date +%Y%m%d`
cv2="tomcat_"
cv3="$cv2$cv1"
cp -r /opt/data/ /opt/backup/$cv3
