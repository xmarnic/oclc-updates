#!/bin/bash

# SFTP to OCLC
sftp fx_wyzbl@filex-m1.oclc.org <<EOF
cd /xfer/metacoll/in/bib
put /software/WYLD/Unicorn/Xfer/1030040.WYZBL.wyld.1.mrc
put /software/WYLD/Unicorn/Xfer/1040840.WYZBL.wyld.1.mrc
exit
