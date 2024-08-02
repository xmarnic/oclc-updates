#!/bin/bash
:                                                      
                                                       
. /software/WYLD/Unicorn/Config/environ                      
export PATH BRSConfig UPATH WINDIR TERMINFO TERMCAP TZ ORACLE_SID ORACLE_BASE ORACLE_HOME LD_LIBRARY_PATH TNS_ADMIN

## most recent recon was 06/28/2018
yesterdate=`transdate -m-1`
today=`transdate -m-0`
#yesterdate=`transdate -w-1`
selitem -yWSL -t~AV-EQUIP,ARCHIVES,BACKPACK,BOOKCLUB,BOUNDPER,CAMCORDER,CASSPLAYER,CHSTEAMKIT,CHTOYS,COPIES,DIGT_PLAYR,DISCARD,EBOOK,EQUIPMENT,EREADER,FAXCARD,GAME,GUESTPASS,HOTSPOT,ILL,ILL-BOOK,JUVKIT,JUV-LOCREQ,JUVMAG,KEY,KIT,KITCHTOOLS,LAPTOP,LAPTOP_AD,LAUNCHPAD,LEASEDBOOK,LIB_THINGS,LOCAL-REQ,MISC,NEWSPAPER,NONCIRC,ONLINEDOC,ONTHEFLY,PERIODICAL,PRINTOUT,PROJECTOR,PUZZLE,REALIA,RECD_PLAYR,REF-BOOK,REFUND,SCREEN,SOFTWARE,SPECIAL,TABLET,TELESCOPE,UNKNOWN,YACRAFTKIT,YAKIT,YAMAG,2HRLOAN -l~ON-ORDER -oC | selcatalog -iC "-r>$yesterdate<$today" -oC > /software/WYLD/WYLDtemp/oclc1.txt
sort -u /software/WYLD/WYLDtemp/oclc1.txt > /software/WYLD/WYLDtemp/oclc2.txt
cat /software/WYLD/WYLDtemp/oclc2.txt | selcatalog -iC -oCe -e001 -fSERIAL| grep -v "o\(c\|n\)" >/software/WYLD/WYLDtemp/oclc3.txt
cat /software/WYLD/WYLDtemp/oclc3.txt | catalogdump -om >/software/WYLD/Unicorn/Xfer/1040840.WYZBL.wyld.1.mrc
