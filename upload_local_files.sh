#!/usr/bin/env bash

# Help function
help_function(){
    echo "Usage: ./upload_local_files.sh <IP_ADDRESS> <IMAGE_DIRECTORY> <WILDCARD> <FILE_PORT> <LS_PORT> <OUTPUT_FILE>"
    echo
    echo "    IP_ADDRESS        : IP address of the machine."
    echo "    IMAGE_DIRECTORY   : Directory containing images."
    echo "    WILDCARD          : File wildcard for filtering files."
    echo "    FILE_PORT         : File serving port number."
    echo "    LS_PORT           : Label Studio port number."
    echo "    OUTPUT_FILE       : Output file location."
}

# Check for help argument
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    help_function
    exit 0
fi

# Input Arguments
IP=$1
IMG_DIR=$2
WILDCARD=$3
FILE_PORT=$4
LS_PORT=$5
OUTPUT_FILE=$6

# Generate file list
echo "Scanning files in ${IMG_DIR} ..."
FIND_CMD="find ${IMG_DIR} -type f"
[ ! -z "$WILDCARD" ] && FIND_CMD="${FIND_CMD} -name ${WILDCARD}"
eval $FIND_CMD | sed "s|^${IMG_DIR}|http://${IP}:${FILE_PORT}/|" > $OUTPUT_FILE

# Start Label Studio
echo "Starting Label Studio on port ${LS_PORT} ..."
label-studio --port $LS_PORT &

# Start file server
echo "Starting file server on port ${FILE_PORT} ..."

cp server.py "$IMG_DIR"
cd "$IMG_DIR"

python3 server.py $FILE_PORT

