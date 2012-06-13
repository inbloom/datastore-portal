#!/usr/bin/bash

if [ $# -eq 1 ]; then
    hostname=$1
else
    hostname=`hostname -s`
fi

#Update environment.properties
sed -i'' -e "s/https:\/\/ci.slidev.org/https:\/\/$Hostname.slidev.org/g" team.properties 
echo "Done.. ready to build and deploy!"
