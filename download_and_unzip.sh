#!/bin/bash
# Download, unzip and zip it again, version 1
# Author: Leonardo Diegues
#
# This script must be executed inside odsp-files folder in order
# to find its children path folders, so it can do what it must do.

OD_YEARS=`seq 1977 10 2007`  # tr

URL_BASE='http://www.metro.sp.gov.br/pesquisa-od/arquivos/Pesquisa_Origem_Destino-'

DATA_PATH='microdados'

if ! test -d $DATA_PATH; then
    mkdir $DATA_PATH
fi

for i in $OD_YEARS; do
    echo "Downloading data from: $i survey...";
    
    DOWNLOAD_URL="$URL_BASE$i.zip";

    DOWNLOAD_PATH="$DATA_PATH/OD_$i.zip";

    OUTFILE="$DATA_PATH/OD_$i.dbf"

    if test -f "$DOWNLOAD_PATH"; then
        echo "File already exists: $DOWNLOAD_PATH"

    else
        wget $DOWNLOAD_URL -O $DOWNLOAD_PATH;
        
        ZIPFILE="$(zipinfo -1 $DOWNLOAD_PATH | egrep "Banco de Dados\\/(.*?)\\.dbf")";

        OUTZIP="$DATA_PATH/$ZIPFILE";

        unzip $DOWNLOAD_PATH "$ZIPFILE" -d "$DATA_PATH";

        mv "$OUTZIP" "$OUTFILE";
        
        bzip2 -z $OUTFILE;

        rm -rf "$DATA_PATH/$(ls $DATA_PATH | grep "^Pesquisa")"

        rm $DOWNLOAD_PATH;
    fi
done