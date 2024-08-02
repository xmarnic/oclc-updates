#!/bin/bash
:                                                      
                                                       
. /software/WYLD/Unicorn/Config/environ                      
export PATH BRSConfig UPATH WINDIR TERMINFO TERMCAP TZ ORACLE_SID ORACLE_BASE ORACLE_HOME LD_LIBRARY_PATH TNS_ADMIN

## most recent recon was 06/28/2018
yesterdate=`transdate -m-1`
today=`transdate -m-0`
#yesterdate=`transdate -w-1`
selitem -y~ALBY-CENT,ALBY-ROCK,BHN-DEAV,BHN-FRAN,CARB-SINC,CCSD-ELEL,CCSD-ENSC,CCSD-HAEL,CCSD-HAHS,CCSD-MEDB,CCSD-SAEL,CCSD-SAHS,CRKSD-HUBR,CRKSD-MOEL,CRKSD-MOHS,CRKSD-SUEL,CRKSD-SUHS,FEW,FSDD,LARM-BKMBL,LARM-GEN,LCCC-ACC,NATR-BKMBL,NATR-EDGE,NEHS,NMWA,PLAT-CHUG,PLAT-GLEN,SWTR-BAIR,SWTR-FARSN,SWTR-GRAN,SWTR-RELI,SWTR-SUPER,SWTR-WAMS,WMC,WSL-ARC,WYLD,WYLD-SHARE -t~AV-EQUIP,ARCHIVES,BACKPACK,BOOKCLUB,BOUNDPER,CAMCORDER,CASSPLAYER,CHSTEAMKIT,CHTOYS,COPIES,DIGT_PLAYR,DISCARD,EBOOK,EQUIPMENT,FAXCARD,EREADER,GAME,GUESTPASS,HOTSPOT,ILL,ILL-BOOK,JUVKIT,JUV-LOCREQ,JUVMAG,KEY,KIT,KITCHTOOLS,LAPTOP,LAPTOP_AD,LAUNCHPAD,LEASEDBOOK,LIB_THINGS,LOCAL-REQ,MISC,NEWSPAPER,NONCIRC,ONLINEDOC,ONTHEFLY,PERIODICAL,PRINTOUT,PROJECTOR,PUZZLE,REALIA,RECD_PLAYR,REF-BOOK,REFUND,SCREEN,SOFTWARE,SPECIAL,TABLET,TELESCOPE,UNKNOWN,YACRAFTKIT,YAKIT,YAMAG,2HRLOAN -l~ON-ORDER -oC | selcatalog -iC "-r>$yesterdate<$today" -oC > /software/WYLD/WYLDtemp/oclc1.txt
sort -u /software/WYLD/WYLDtemp/oclc1.txt > /software/WYLD/WYLDtemp/oclc2.txt
cat /software/WYLD/WYLDtemp/oclc2.txt | selcatalog -iC -oCe -e001 -f~COMMINFO,DUBLINCORE,EQUIP,ONORDER,ONTHEFLY,ROOM,SERIAL | grep oc  >/software/WYLD/WYLDtemp/oclc3.txt
cat /software/WYLD/WYLDtemp/oclc2.txt | selcatalog -iC -oCe -e001 -f~COMMINFO,DUBLINCORE,EQUIP,ONORDER,ONTHEFLY,ROOM,SERIAL | grep on  >>/software/WYLD/WYLDtemp/oclc3.txt
cat /software/WYLD/WYLDtemp/oclc3.txt | catalogdump -om >/software/WYLD/Unicorn/Xfer/1030040.WYZBL.wyld.1.mrc
sftp -b /software/WYLD/Unicorn/Bincustom/oclcadd.bat fx_wyzbl@filex-m1.oclc.org