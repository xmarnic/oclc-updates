## Scripts
- 'oclcmonthly.sh': updates OCLC records
- 'oclcmonthlywsl.sh': updates WSL serial records only (not presently scheduled)
- 'originalcatologingmonthly.sh': add original catalog records to OCLC
- 'orginalmonthlywsl.sh': adds original serial catalog records to OCLC (not presently scheduled)
## Task
### Minimal
Automate the process of sending original records to OCLC

#### Solution
1. Schedule all scripts to run
2. Modify the scripts to use distinct temporary files for updated and original records. The WSL solutions should append to the final output file, instead of clobber it.
3. Create a single script responsible for adding records to OCLC and schedule in the crontab.

### Better
1. Rename the scripts more semantically
2. Refactor the scripts for improved readability
3. Integrate the WSL SERIALS into a single script for maintainability
4. Combine `oclcmonthly.sh` and `originalcatalogingmonthly.sh` into a single script since the are working off the same data set.

## Results
`oclc-integrated.sh` creates the files that will be uploaded to OCLC. Before we were building the same dataset twice and filtering based only on whether or not an OCLC number existed. Additionally, the WSL unique scripts weren't even scheduled so this issue has been uncovered and resolved.

`oclc-sftp.sh` SFTPs the files created by `oclc-integrated.sh` on the 5th of each month.