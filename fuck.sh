#!/bin/bash

download() {
	curl -o test.xml http://10.104.0.225/plugin.php?id=xj_event:event_list_ajax&action=&choose=new&pc=1&offlineclass=&onlineclass=&inajax=1&ajaxtarget=event1
	sleep 1
	file="./test.html"
	if test -f $file
	then
		echo "test.html not exits!!" >> log.txt
		exit 1
	else
		echo "test.html exits!!" >> log.txt
	fi
}

sendmail() {
	echo "http://10.104.0.225/plugin.php?id=xj_event:event_list&pc=1" | heirloom-mailx -s "学习活动" 邮箱地址
}

cd /root/activity
download

tmpfile="./tmp.txt"

if test -f $tmpfile
	then
		echo "tmp.txt exits!!" >> log.txt
	else
		echo "tmp.txt not exits!!" >> log.txt
		echo "init" > tmp.txt
fi

sleep 1
lasttime=`awk 'END {print $0}' tmp.txt`

count=`awk '/<span class=\"xj_hll\">活动时间:/{print $0;}' test.xml | awk 'NR==1'`
count1=${count##*>}
count2=${count1%%&*}
#echo $count2

echo $count2 >> tmp.txt
if [ $lasttime == $count2 ];
then
	printf "%s,%s\n" `date +%F--%T`,"not find news" >> log.txt
	#echo $count
	#echo $lasttime
else
	printf "%s,%s\n" `date +%F--%T`,"find news" >> log.txt
	#echo $count
	#echo $lasttime
	sendmail
fi
