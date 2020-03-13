#!/bin/bash
# Download, unzip and zip it again, version 1
# Author: Leonardo Diegues
#
# This script must be executed inside odsp-files folder in order
# to find its children path folders, so it can do what it must do.

OD_YEARS=`seq 1977 10 2017`  # tr
URL_BASE='http://www.metro.sp.gov.br/pesquisa-od/arquivos'
DATA_PATH='data'

if ! test -d $DATA_PATH; then
    mkdir $DATA_PATH
fi

for i in $OD_YEARS; do
    echo "Downloading data from: $i survey...";
    if [ $i -eq 2017 ]; then
        DOWNLOAD_URL="$URL_BASE/Pesquisa-Origem-Destino-$i-Banco-Dados.zip"
    else
        DOWNLOAD_URL="$URL_BASE/Pesquisa_Origem_Destino-$i.zip"
    fi
    DOWNLOAD_PATH="$DATA_PATH/OD_$i.zip"
    OUTFILE="$DATA_PATH/OD_$i.sav"
    curl $DOWNLOAD_URL -o $DOWNLOAD_PATH
    ZIPFILE="$(zipinfo -1 $DOWNLOAD_PATH | egrep "\\.sav$")"
    OUTZIP="$DATA_PATH/$ZIPFILE"
    unzip $DOWNLOAD_PATH "$ZIPFILE" -d "$DATA_PATH"
    mv "$OUTZIP" "$OUTFILE"
    bzip2 -z $OUTFILE
    cd $DATA_PATH && rm -R -- */
    cd ../
    rm $DOWNLOAD_PATH
done