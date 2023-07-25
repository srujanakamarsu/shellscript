func_nodejs()
{
    log=/tmp/roboshop.log

    echo -e  "\e[36m>>>>>> create ${component} service file <<<<<<\e[0m"
    cp ${component}.service /etc/systemd/system/${component}.service &>>${log}

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
    curl -o /tmp/${component}zip https://roboshop-artifacts.s3.amazonaws.com/${component}zip &>>${log}

    echo -e  "\e[36m>>>>>> extract application content <<<<<<\e[0m" 
    cd /app 
    unzip /tmp/${component}zip &>>${log}
    cd /app 

    echo -e  "\e[36m>>>>>> download nodejs dependencies <<<<<<\e[0m"
    npm install &>>${log}

    echo -e  "\e[36m>>>>>> install mongo client <<<<<<\e[0m"
    yum install mongodb-org-shell -y &>>${log}

    echo -e  "\e[36m>>>>>> load ${component} schema <<<<<<\e[0m"
    mongo --host mongodb.vyshu.online </app/schema/${component}js &>>${log}

    echo -e  "\e[36m>>>>>> start ${component} service <<<<<<\e[0m"
    systemctl daemon-reload &>>${log}
    systemctl enable ${component} &>>${log}
    systemctl restart ${component} &>>${log}

}