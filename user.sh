log=/tmp/roboshop.log

echo -e  "\e[36m>>>>>> create user service file <<<<<<\e[0m"
cp user.service /etc/systemd/system/user.service &>>${log}

echo -e  "\e[36m>>>>>> create mongodb repo file <<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

echo -e  "\e[36m>>>>>> install node js repos <<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

echo -e  "\e[36m>>>>>> install node js <<<<<<\e[0m"
yum install nodejs -y &>>${log}

echo -e  "\e[36m>>>>>> create application user <<<<<<\e[0m"
useradd roboshop &>>${log}

echo -e  "\e[36m>>>>>> create application directory <<<<<<\e[0m"
mkdir /app &>>${log}

echo -e  "\e[36m>>>>>> download application content <<<<<<\e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${log}

echo -e  "\e[36m>>>>>> extract application content <<<<<<\e[0m" 
cd /app 
unzip /tmp/user.zip &>>${log}
cd /app 

echo -e  "\e[36m>>>>>> download nodejs dependencies <<<<<<\e[0m"
npm install &>>${log}

echo -e  "\e[36m>>>>>> install mongo client <<<<<<\e[0m"
yum install mongodb-org-shell -y &>>${log}

echo -e  "\e[36m>>>>>> load user schema <<<<<<\e[0m"
mongo --host mongodb.vyshu.online </app/schema/user.js &>>${log}

echo -e  "\e[36m>>>>>> start user service <<<<<<\e[0m"
systemctl daemon-reload &>>${log}
systemctl enable user &>>${log}
systemctl restart user &>>${log}
