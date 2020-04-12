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
#mail
MAILFROM="xxxxxx@xxxx.com";
MAILTO="xxxxxx@xxxx.com";
MAILSUBJECT="AVISO";
MAILBODY="Enviado para o mega as";
#DATE
DATA=$(date +'%d-%m-%y');
#Hour
HOUR=(date +"%T");
#Script initiate as
START=$(date +%s);
#Directory to save backup
DIR_BACKUP="/tmp/backup";
#filename to zip ans send zipped files
FILENAME="TESTE_ROOT_SCRIPT_";
#Directory to get files
DIR_ARQUIVAR=" /root/.scripts";
#Time to delete files in directory backup ex 1-30 days
FILETIMETODELETE="+10"

ARQUIVO="$DIR_BACKUP/$FILENAME$DATA.tar.gz";

#verifica se o diretorio exise, se o diretorio não existir cria o diretorio. -d verifica se existe, !-d verifica 
#se não existe.
if [ ! -d $DIR_BACKUP ]; then
mkdir $DIR_BACKUP;
fi
#fim do if;
#Compacta o arquivo e salva na pasta /tmp/backup.
tar -cvzf "$ARQUIVO" $DIR_ARQUIVAR;
#Envia o Arquivo para o Mega.
megaput "$ARQUIVO"

if [ ! -d $ARQUIVO ]; then

 echo "BACKUP." $FILENAME $MAILBODY $HOUR | mailx -r $MAILFROM -s $MAILSUBJECT $MAILTO
fi
#verifica se os aruivos estao a mais de um dia e deleta
echo "Removendo os backups, deixando sempre dos ultimos 5 dias"
find  $DIR_BACKUP -name "*.gz" -ctime $FILETIMETODELETE -exec rm {} \;
#find $DIR_DESTINO -type f -mtime $TIME -delete

END=$(date +%s);
DIFF=$(( $END - $START ));
echo "......."
echo "O script terminou no tempo de $DIFF seconds";

############################################################################################################
# use crontab -e 
# 0 */6 * * * /path-to-script //a cada seis horas
# service cron reload
