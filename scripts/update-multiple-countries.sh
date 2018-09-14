#!/bin/bash

USERNAME="nominatim"
NOMINATIM_HOME="/srv/nominatim"
PBF_DIR="${NOMINATIM_HOME}/pbf"
PBF_ALL="${PBF_DIR}/data.pbf"
COUNTRY_LIST="${NOMINATIM_HOME}/data/countries.txt"

### Foreach country check if configuration exists (if not create one) and then import the diff
while read -r COUNTRY; do
	DIR="${NOMINATIM_HOME}/updates/$COUNTRY"
    FILE="$DIR/configuration.txt"
    if [ ! -f ${FILE} ]; then
        sudo -u $USERNAME mkdir -p ${DIR}
        echo "Running: osmosis --rrii workingDirectory=${DIR}/." 
        sudo -u $USERNAME osmosis --rrii workingDirectory=${DIR}/.
        sudo -u $USERNAME echo "baseUrl=http://download.geofabrik.de/${COUNTRY}-updates" > ${FILE}
        sudo -u $USERNAME echo "maxInterval = 0" >> ${FILE}
        cd ${DIR}
        sudo -u $USERNAME wget -q "http://download.geofabrik.de/${COUNTRY}-updates/state.txt"
        echo "$COUNTRY state.txt content:"
        cat state.txt
    fi
    FILENAME=${COUNTRY//[\/]/_}
    echo "Running: osmosis --rri workingDirectory=${DIR}/. --wxc ${FILENAME}.osc.gz" 
    sudo -u $USERNAME osmosis --rri workingDirectory=${DIR}/. --wxc ${FILENAME}.osc.gz
done < $COUNTRY_LIST

INDEX=0 # false

### Foreach diff files do the import
cd "${NOMINATIM_HOME}/updates"
for OSC in *.osc.gz; do
	echo "Running: utils/update.php --import-diff updates/${OSC} --no-npi" 
    sudo -u $USERNAME ${NOMINATIM_HOME}/utils/update.php --import-diff ${NOMINATIM_HOME}/updates/${OSC} --no-npi
    INDEX=1
done

### Re-index if needed
if ((${INDEX})); then
	echo "Re-indexing"
    sudo -u $USERNAME ${NOMINATIM}/utils/update.php --index
fi

### Remove all diff files
sudo -u $USERNAME rm -f ${NOMINATIM}/updates/*.osc.gz
