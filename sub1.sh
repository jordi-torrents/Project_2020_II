#!/bin/bash


for (( i=1; i<=27; i=$i+1 )) ; do
	cp subloop.sh plantilla.sh
	echo 'cpu '$i
	sed -i 's/aqui1/'$i'/g' plantilla.sh
	sed -i 's/aqui2/'$i'/g' plantilla.sh
	bsub -q training -U master < plantilla.sh
done

rm plantilla.sh
