#!/bin/bash

# Log file setup
logfile="/software/WYLD/Nic/Logs/oclc-sftp.log"
echo "[$(date)] Starting OCLC SFTP" >> $logfile

# Load environment variables from .env file if it exists
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

# SFTP to OCLC
sftp $SFTP_USER@filex-m1.oclc.org <<EOF
cd /xfer/metacoll/in/bib
put /software/WYLD/Unicorn/Xfer/1030040.WYZBL.wyld.1.mrc
put /software/WYLD/Unicorn/Xfer/1040840.WYZBL.wyld.1.mrc
exit
EOF

if [ $? -eq 0 ]; then
    echo "[$(date)] Successfully transferred files to OCLC." >> $logfile
else
    echo "[$(date)] Failed to transfer files to OCLC." >> $logfile
fi
