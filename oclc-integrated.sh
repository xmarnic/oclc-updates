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

temp_dir="/software/WYLD/WYLDtemp/oclc"
records="${temp_dir}/all.txt"
unique_records="${temp_dir}/unique.txt"
filtered_records="${temp_dir}/filtered.txt"
existing_records="${temp_dir}/existing.txt"
original_records="${temp_dir}/original.txt"

output_dir="/software/WYLD/Unicorn/Xfer"
oclc_updates="${output_dir}/1030040.WYZBL.wyld.1.mrc"
oclc_originals="${output_dir}/1040840.WYZBL.wyld.1.mrc"

# Build the standard list of catalog keys
selitem -y~"${library_codes}" -t~"${item_types}" -l~ON-ORDER -oC > "${records}"

# Append WSL SERIALs to the standard list of catalog keys
selitem -yWSL -t~"${item_types}" -l~ON-ORDER -oC >> "${records}"

# Remove duplicate records
sort -u "${records}" > "${unique_records}"

# Select only recently modified records, filter out the excluded catalog formats and records without subfield 001
cat "${unique_records}" | selcatalog -iC -f~"${catalog_formats}" "-r>$begin<$today" -e001 -oCe > "${filtered_records}"

# Select only those records with OCLC number
grep -E "oc|on" "${filtered_records}"  > "${existing_records}"

# Select only those records without an OCLC number
grep -vE "oc|on" "${filtered_records}"  > "${original_records}"

# Create an output file for oclc updates
cat "${existing_records}" | catalogdump -om > "${oclc_updates}"

# Create an output file of the oclc original records 
cat "${original_records}" | catalogdump -om > "${oclc_originals}"
