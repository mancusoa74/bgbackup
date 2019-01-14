#!/bin/bash

# **********************************************************************
# * Project           : bgbackup
# *
# * Author            : Antonio Mancuso
# *
# * Date created      : 2019-01-12
# *
# * Version           : 0.1
# *
# * Purpose           : automatic optimized network backup
# *
# * Revision History  
# *
# * Date        Version    Changes
# * 2019-01-12    0.1      Initial version
# *
# **********************************************************************


BACKUP_HOST=<IP of backup server>
BACKUP_USER="<backup server username>"
LOG_FILE="/path/to/your/bgbackup/log/bgbackup.log"

DATE_TIME=`date +%Y-%m-%dT%H:%M:%S`

declare -A src_dst
src_dst=(["/path/to/local/dir1/"]="/path/to/remote/dir1"
         ["/path/to/local/dir2/"]="/path/to/remote/dir2"
        )

process=`ps u | awk -F" " '{print $11}' | grep rsync`
if [ ! -z $process ]; then
    echo "${DATE_TIME} - ERROR - BACKUP process already running [ABORTING]" >> $LOG_FILE
    exit 1
fi

/bin/ping $BACKUP_HOST -q -c 3 -w 5

if [ ! $? -eq 0 ]; then
    echo "${DATE_TIME} - ERROR - BACKUP HOST [${BACKUP_HOST}] unreachable" >> $LOG_FILE 
else
    echo "${DATE_TIME} - SUCCESS - BACKUP HOST [${BACKUP_HOST}] reachable" >> $LOG_FILE 
    for src_file in "${!src_dst[@]}";do
        DATE_TIME=`date +%Y-%m-%dT%H:%M:%S`
        echo "${DATE_TIME} - SUCCESS - START BACKUP of ${src_file}" >> $LOG_FILE 
        rsync -avzh --progress ${src_file} $BACKUP_USER@$BACKUP_HOST:${src_dst[$src_file]}
        DATE_TIME=`date +%Y-%m-%dT%H:%M:%S`
        if [ $? -eq 0 ]; then
            echo "${DATE_TIME} - SUCCESS - END BACKUP of ${src_file}" >> $LOG_FILE 
        else
            echo "${DATE_TIME} - ERROR - BACKUP of ${src_file}" >> $LOG_FILE 
        fi
    done
    echo "${DATE_TIME} ===========================================================================" >> $LOG_FILE
fi

