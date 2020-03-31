#!/bin/bash

for (( i=1; i<=32; i=$i*2 )) ; do
	cp sub2.sh plantilla.sh
	sed -i 's/n_proc/'$i'/g' plantilla.sh
	echo "Launchins $i processor/s"
	bsub -q training < plantilla.sh
done
rm plantilla.sh
