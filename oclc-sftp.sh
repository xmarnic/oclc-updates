#!/bin/bash

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
