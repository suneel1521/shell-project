#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
M="\e[35m"
N="\e[0m"

LOG_FOLDER=/var/log/shell_log
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"
mkdir -p $LOG_FOLDER

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
   echo -e " $R ERROR:please execute the script with root access $N" | tee -a "$LOG_FILE"
   exit 1
else
   echo -e "$B you are running with root access $N" | tee -a "$LOG_FILE"
fi

echo -e "$M script executed at:$(date) $N" | tee -a "$LOG_FILE"


VALIDATE(){

	if [ $1 -eq 0 ]
	then
	   echo -e "$G $2 successfully $N" | tee -a "$LOG_FILE"
	else
	   echo -e "$R $2 failure $N" | tee -a "$LOG_FILE"
	fi
}

dnf module disable nginx -y
VALIDATE $? "disabling nginx"
dnf module enable nginx:1.24 -y
VALIDATE $? "enabling nginx"
dnf install nginx -y
VALIDATE $? "installing nginx"

systemctl enable nginx 
systemctl start nginx 
VALIDATE $? "starting nginx"


rm -rf /usr/share/nginx/html/* 
VALIDATE $? "remove nginx default content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
VALIDATE $? "downloading the frontend content"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
VALIDATE $? "Extract the frontend content"

cp 02-nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "Create Nginx Reverse Proxy Configuration to reach backend services."

systemctl restart nginx 
VALIDATE $? "restarting nginx"