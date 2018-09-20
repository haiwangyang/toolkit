#!/bin/bash

# download GSM, des, SRX, SRA info by GSE

# usage: 
# ./fetch_SRRs_by_GSE.sh GSE49197

gse=$1
wget https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=$gse

# collect des and GSM from GSE page
cat acc.cgi?acc=$gse | grep "<td valign=\"top\">" | grep -v href | awk -F">" '{print $2}' | awk -F"<" '{print $1}' | sed "1d" >des.txt
cat acc.cgi\?acc\=$gse | grep "acc=GSM"  | awk -F"href=\"" '{print $2}' | awk -F\" '{print $1}' | awk -F"acc=" '{print $2}' >GSM.txt

# download GSM pages
cat GSM.txt | awk '{print "wget https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc="$1}' | bash


# collect SRX for each GSM page
for gsm in `cat GSM.txt`; do
    cat acc.cgi\?acc\=$gsm | grep SRX | awk -F"href=\"" '{print $2}' | awk -F\" '{print $1}' | awk -F"term=" '{print $2}'
    cat acc.cgi\?acc\=$gsm | grep SRX | awk -F"href=\"" '{print $2}' | awk -F\" '{print "wget "$1}' | bash
done >SRX.txt

# collect SRR for each SRX
for srx in `cat SRX.txt`; do
    cat sra\?term=$srx | grep SRR | awk -F"run=" '{print $2}' | awk -F\" '{print $1}'
done >SRA.txt


paste GSM.txt SRX.txt SRA.txt des.txt >$gse.txt

rm acc* sra* GSM.txt SRX.txt SRA.txt des.txt

