#!/bin/bash
                                                       
. /software/WYLD/Unicorn/Config/environ                      
export PATH BRSConfig UPATH WINDIR TERMINFO TERMCAP TZ ORACLE_SID ORACLE_BASE\
ORACLE_HOME LD_LIBRARY_PATH TNS_ADMIN

begin=$(transdate -m-1)
today=$(transdate -m-0)

library_codes="ALBY-CENT,ALBY-ROCK,BHN-DEAV,BHN-FRAN,CARB-SINC,CCSD-ELEL,\
CCSD-ENSC,CCSD-HAEL,CCSD-HAHS,CCSD-MEDB,CCSD-SAEL,CCSD-SAHS,CRKSD-HUBR,\
CRKSD-MOEL,CRKSD-MOHS,CRKSD-SUEL,CRKSD-SUHS,FEW,FSDD,LARM-BKMBL,LARM-GEN,\
LCCC-ACC,NATR-BKMBL,NATR-EDGE,NEHS,NMWA,PLAT-CHUG,PLAT-GLEN,SWTR-BAIR,\
SWTR-FARSN,SWTR-GRAN,SWTR-RELI,SWTR-SUPER,SWTR-WAMS,WMC,WSL-ARC,WYLD,WYLD-SHARE"

item_types="AV-EQUIP,ARCHIVES,BACKPACK,BOOKCLUB,BOUNDPER,CAMCORDER,CASSPLAYER,\
CHSTEAMKIT,CHTOYS,COPIES,DIGT_PLAYR,DISCARD,EBOOK,EQUIPMENT,FAXCARD,EREADER,\
GAME,GUESTPASS,HOTSPOT,ILL,ILL-BOOK,JUVKIT,JUV-LOCREQ,JUVMAG,KEY,KIT,\
KITCHTOOLS,LAPTOP,LAPTOP_AD,LAUNCHPAD,LEASEDBOOK,LIB_THINGS,LOCAL-REQ,MISC,\
NEWSPAPER,NONCIRC,ONLINEDOC,ONTHEFLY,PERIODICAL,PRINTOUT,PROJECTOR,PUZZLE,\
REALIA,RECD_PLAYR,REF-BOOK,REFUND,SCREEN,SOFTWARE,SPECIAL,TABLET,TELESCOPE,\
UNKNOWN,YACRAFTKIT,YAKIT,YAMAG,2HRLOAN"

catalog_formats="COMMINFO,DUBLINCORE,EQUIP,ONORDER,ONTHEFLY,ROOM,SERIAL"

temp_dir="/software/WYLD/WYLDtemp"
records="${temp_dir}/oclc-update-all.txt"
recent_records="${temp_dir}/oclc-update-recent.txt"
unique_records="${temp_dir}/oclc-update-unique.txt"
select_records="${temp_dir}/oclc-update-match.txt"
output_dir="/software/WYLD/Unicorn/Xfer"
update_file="${output_dir}/1030040.WYZBL.wyld.1.mrc"

# Build the standard list of catalog keys
selitem -y~"${library_codes}" -t~"${item_types}" -l~ON-ORDER -oC > "${records}"

# Append WSL SERIALs to the standard list of catalog keys
selitem -yWSL -t~"${item_types}" -l~ON-ORDER -oC >> "${records}"

# Filter for recent catalog key records (using date last modified)
cat "${records}" | selcatalog -iC "-r>$begin<$today" -oC > "${recent_records}"

# Remove duplicate records
sort -u "${recent_records}" > "${unique_records}"

# Filter out the excluded catalog formats and select only those records with OCLC number
cat "${unique_records}" | selcatalog -iC -oCe -e001 -f~"${catalog_formats}" | grep -E "oc|on"  > "${select_records}"

# Create the MARC file for our updates
cat "${select_records}" | catalogdump -om > "${update_file}"

# SFTP our updates to OCLC
sftp -b /software/WYLD/Unicorn/Bincustom/oclcadd.bat fx_wyzbl@filex-m1.oclc.org
