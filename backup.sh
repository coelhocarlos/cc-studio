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

# Idade do arquivo em dias (+dias = acima de N dias)
#TIME="+10"

# Diretório de Destino
#DIR_DESTINO=/tmp/backup
#diretorio temporario 
#data do arquivo
DATA=$(date +'%d-%m-%y');
HOUR=(date +"%T");
START=$(date +%s);
DIR_BACKUP="/tmp/backup";
FILENAME="TESTE_ROOT_SCRIPT_";
DIR_ARQUIVAR=" /root/.scripts";

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

 echo "BACKUP." $FILENAME "Enviado para o mega as $HOUR" | mailx -r servidor@ccstudio.com.br -s AVISO contato@ccstudio.com.br
fi
#verifica se os aruivos estao a mais de um dia e deleta
echo "Removendo os backups, deixando sempre dos ultimos 5 dias"
find  $DIR_BACKUP -name "*.gz" -ctime +5 -exec rm {} \;
#find $DIR_DESTINO -type f -mtime $TIME -delete

END=$(date +%s);
DIFF=$(( $END - $START ));
echo "......."
echo "O script terminou no tempo de $DIFF seconds";

############################################################################################################
# use crontab -e 
# 0 */6 * * * /path-to-script //a cada seis horas
# service cron reload
