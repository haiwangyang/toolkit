#!/bin/bash
# usage:
# ./rsync_data_from_quest.sh /projects/b1080/zj/translation/fly pdf

base=$1 # e.g., /projects/b1080/zj/translation/fly
type=$2 # e.g., pdf

# rsync fetch folder info file
rsync -avh hyh5331@quest.northwestern.edu:${base}/folder.list .

# rsync folder structure only
for i in `cat folder.list`; do
	rsync -av -f"+ */" -f"- *" hyh5331@quest.northwestern.edu:${base}/$i/ $i/
done


# rsync pdf files in the secondary folder
for i in `cat folder.list`; do
	cd $i; 
	for ii in `ls | grep SRR`; do
		cd $ii;
		rsync -avh hyh5331@quest.northwestern.edu:${base}/$i/$ii/*.${type} .;
		cd ../
	done
        cd ..;
done

