#███╗   ███╗███████╗ ██████╗  █████╗ 
#████╗ ████║██╔════╝██╔════╝ ██╔══██╗
#██╔████╔██║█████╗  ██║  ███╗███████║
#██║╚██╔╝██║██╔══╝  ██║   ██║██╔══██║
#██║ ╚═╝ ██║███████╗╚██████╔╝██║  ██║
#╚═╝     ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
############################################################################################################                                                                                                                

# 
#▒███████▒ ▒█████   ███▄ ▄███▓ ▄▄▄▄    ██▓▓█████    ▄▄▄█████▓ ██░ ██ ▓█████    ▒███████▒▓█████  ██▀███   ▒█████  
#▒ ▒ ▒ ▄▀░▒██▒  ██▒▓██▒▀█▀ ██▒▓█████▄ ▓██▒▓█   ▀    ▓  ██▒ ▓▒▓██░ ██▒▓█   ▀    ▒ ▒ ▒ ▄▀░▓█   ▀ ▓██ ▒ ██▒▒██▒  ██▒
#░ ▒ ▄▀▒░ ▒██░  ██▒▓██    ▓██░▒██▒ ▄██▒██▒▒███      ▒ ▓██░ ▒░▒██▀▀██░▒███      ░ ▒ ▄▀▒░ ▒███   ▓██ ░▄█ ▒▒██░  ██▒
#  ▄▀▒   ░▒██   ██░▒██    ▒██ ▒██░█▀  ░██░▒▓█  ▄    ░ ▓██▓ ░ ░▓█ ░██ ▒▓█  ▄      ▄▀▒   ░▒▓█  ▄ ▒██▀▀█▄  ▒██   ██░
#▒███████▒░ ████▓▒░▒██▒   ░██▒░▓█  ▀█▓░██░░▒████▒     ▒██▒ ░ ░▓█▒░██▓░▒████▒   ▒███████▒░▒████▒░██▓ ▒██▒░ ████▓▒░
#░▒▒ ▓░▒░▒░ ▒░▒░▒░ ░ ▒░   ░  ░░▒▓███▀▒░▓  ░░ ▒░ ░     ▒ ░░    ▒ ░░▒░▒░░ ▒░ ░   ░▒▒ ▓░▒░▒░░ ▒░ ░░ ▒▓ ░▒▓░░ ▒░▒░▒░ 
#░░▒ ▒ ░ ▒  ░ ▒ ▒░ ░  ░      ░▒░▒   ░  ▒ ░ ░ ░  ░       ░     ▒ ░▒░ ░ ░ ░  ░   ░░▒ ▒ ░ ▒ ░ ░  ░  ░▒ ░ ▒░  ░ ▒ ▒░ 
#░ ░ ░ ░ ░░ ░ ░ ▒  ░      ░    ░    ░  ▒ ░   ░        ░       ░  ░░ ░   ░      ░ ░ ░ ░ ░   ░     ░░   ░ ░ ░ ░ ▒  
#  ░ ░        ░ ░         ░    ░       ░     ░  ░             ░  ░  ░   ░  ░     ░ ░       ░  ░   ░         ░ ░  
#░                                  ░                                          ░                                 
############################################################################################################


 
 #!/bin/bash
#
#Cria uma copia compactada com o nome Dados_.tar.gz no diretorio /tmp/backup
#contendo o diretorio /home/publica
#
#
#Variaveis de configuração do script

echo ""
echo ""
echo ""
echo "Inciando Procedimento de Back-up"
echo "..."
echo "..."
echo "..."
echo "..."
echo "Aguarde Alguns Instantes para a Finalização"

#CONFIGURATIONS
#DATE
DATA=$(date +'%d-%m-%y');
#Hour
HOUR=$(date +"%T");
#Script initiate as
START=$(date +%s);
#Directory to save backup
DIR_BACKUP="/mnt/cloud/bck-ccstudio-server";
#filename to zip ans send zipped files
FILENAME="websites_";
#Directory to get files
DIR_ARQUIVAR="/var/www/clients";
#directory to mega folder
DIR_MEGA="/Root/webserver-backup";
#Time to delete files in directory backup ex 1-30 days
FILETIMETODELETE="5"
#mail
MAILFROM="servidor@ccstudio.com.br";
MAILTO="contato@ccstudio.com.br";
MAILSUBJECT="BACKUP_WEBSERVER_CCSTUDIO";
MAILBODY="Backup de arquivos de $FILENAME enviado para o Mega.nz as $HOUR";

ARQUIVO="$DIR_BACKUP/$FILENAME$DATA.tar.gz";

#verifica se o diretorio exise, se o diretorio não existir cria o diretorio. -d verifica se existe, !-d verifica 
#se não existe.

if [ ! -d $DIR_BACKUP ]; then
mkdir $DIR_BACKUP;
chmod 777 "$DIR_BACKUP"
fi
#fim do if;
#Compacta o arquivo e salva na pasta /tmp/backup.
tar -cvzf "$ARQUIVO" $DIR_ARQUIVAR;
#Envia o Arquivo para o Mega.
megaput  "$ARQUIVO".tar.gz --path=$DIR_MEGA

if [ ! -d $ARQUIVO ]; then
 echo $MAILBODY | mailx -r $MAILFROM -s $MAILSUBJECT $MAILTO
fi
#verifica se os aruivos estao a mais de um dia e deleta
echo "Removendo os backups, deixando sempre dos ultimos +$FILETIMETODELETE dias"
find  $DIR_BACKUP -name "*.gz" -ctime +$FILETIMETODELETE -exec rm {} \;
#find $DIR_DESTINO -type f -mtime $TIME -delete

END=$(date +%s);
DIFF=$(( $END - $START ));
echo "......."
echo "O script terminou no tempo de $DIFF seconds";

############################################################################################################
# use crontab -e 
# 0 */6 * * * /path-to-script //a cada seis horas
# service cron reload
