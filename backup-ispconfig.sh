#!/bin/bash

#database root password
export username=c1_ccstudio
export password=1q2w3eASD!@
NOW=$(date +”%d-%m-%Y”)

ssh root@IP_OLD rm -rf /root/BACKUP_SERVER/vmail.tar.gz
ssh root@IP_OLD tar -zcvf /root/BACKUP_SERVER/vmail.tar.gz /var/vmail
scp root@IP_OLD:/root/BACKUP_SERVER/vmail.tar.gz ./BACKUP_SERVER/
cd ./BACKUP_SERVER
tar -zxvf vmail.tar.gz
cd ..
rm -rf /var/vmail
mv ./BACKUP_SERVER/var/vmail /var/

ssh root@IP_OLD rm -rf /root/BACKUP_SERVER/www.tar.gz
ssh root@IP_OLD tar -zcvf /root/BACKUP_SERVER/www.tar.gz /var/www
scp root@IP_OLD:/root/BACKUP_SERVER/www.tar.gz ./BACKUP_SERVER/
cd ./BACKUP_SERVER
tar -zxvf www.tar.gz
cd ..
rm -rf /var/www
mv ./BACKUP_SERVER/var/www /var/

ssh root@IP_OLD rm -rf /root/BACKUP_SERVER/log.tar.gz
ssh root@IP_OLD tar -zcvf /root/BACKUP_SERVER/log.tar.gz /var/log
scp root@IP_OLD:/root/BACKUP_SERVER/log.tar.gz ./BACKUP_SERVER/
cd ./BACKUP_SERVER
tar -zxvf log.tar.gz
cd ..
rm -rf /var/log
mv ./BACKUP_SERVER/var/log /var/

ssh root@IP_OLD rm -rf /root/BACKUP_SERVER/opt.tar.gz
ssh root@IP_OLD tar -zcvf /root/BACKUP_SERVER/opt.tar.gz /var/opt
scp root@IP_OLD:/root/BACKUP_SERVER/opt.tar.gz ./BACKUP_SERVER/
cd ./BACKUP_SERVER
tar -zxvf opt.tar.gz
cd ..
rm -rf /var/opt
mv ./BACKUP_SERVER/var/opt /var/

NOW=”03-12-2017″
export NOW

array=(mydb1 mydb2)
for DATABASE in “${array[@]}”
do

export DATABASE

echo “BACKUP MYSQL OF $DATABASE for $NOW”

echo “COPY FILE”
scp root@IP_OLD:/root/BACKUP_SQL/$DATABASE$NOW.sql ./BACKUP_SQL/

echo “DROP DB $DATABASE”
mysql -u $username -p”$password” -e “DROP DATABASE IF EXISTS $DATABASE”

echo “CREATE DB $DATABASE”
mysql -u $username -p”$password” -e “CREATE DATABASE $DATABASE”

echo “RESTORE”
mysql -u $username -p”$password” $DATABASE < ./BACKUP_SQL/$DATABASE$NOW.sql

echo “FINE”
done

export password=”

export PGPASSWORD=”

array=( pgdb1 pgdb2 )

for DATABASE in “${array[@]}”
do

export DATABASE

echo “BACKUP POSTGRES OF $DATABASE for $NOW”

echo “COPY FILE”

scp root@IP_OLD:/root/BACKUP_SQL/$DATABASE$NOW.backup ./BACKUP_SQL/

dropdb –host 127.0.0.1 –port 5432 –username “postgres” –no-password $DATABASE

createdb –host 127.0.0.1 –port 5432 –username “postgres” –no-password $DATABASE

pg_restore –host 127.0.0.1 -U postgres -d $DATABASE –verbose ./BACKUP_SQL/$DATABASE$NOW.backup
done