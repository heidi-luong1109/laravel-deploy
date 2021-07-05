#!/bin/bash
#--------------------------------------------------------------------------------------------------
#@auther dreamingodd
#@20160226
#My project name is ocdp.
#1.git pull
#2.backup PHP
#3.deploy PHP.
#4.change config in PHP project.
#5.backup DB...
#6.deploy SQLs
#--------------------------------------------------------------------------------------------------

sys_time=`date "+%Y%m%d_%H%M%S"`
#Refresh git folder
echo "----1.git processing"
#Let's pretend your project is in /home/git/game
if [ -d /home/git ]
then
    echo "Git folder exists."
    cd /home/git/game
    git pull
else
    mkdir /home/git
    echo "created Git folder"
    cd /home/git
    git clone https://github.com/heidi-luong1109/game
fi

#Deploy game
echo "----2.backing up PHP"
cd /home/slot.heidi.net.au/public_html/
if [ -d /home/slot.heidi.net.au/public_html/game ]
then
    echo "game exists."
    if [ -d /home/back ]
    then
        echo "Backup folder exists."
    else
        mkdir /home/back
    fi
    mv /home/slot.heidi.net.au/public_html/game /home/back/game_${sys_time}
    mkdir /home/slot.heidi.net.au/public_html/game
else
    #some config file creation for the first time deployment.一些首次部署的config设置
    #...
    echo "game config files are created."
fi
echo "----3.deploying PHP."
cd /var/www/html
cp -r /home/git/game ./game
#config change.你的项目部署需要的config修改
#...

#MySQL backup
echo "----5.backing up DB..."
backupFile=/tmp/DB_backup${sys_time}.sql
mysqldump -uroot -p${pwd} game>${backupFile}

#MySQL script deployment
echo "----6.deploying SQLs"
if [ -f /home/git/game/sql/deployment/*.sql ]
then
    for FILE in /home/git/game/sql/deployment/*.sql
    do
        sys_time=`date "+%Y%m%d_%H%M%S"`
        mysql -uroot -p${pwd} -e "source $FILE" | tee /tmp/DB_log_${sys_time}.sql
    done
fi


