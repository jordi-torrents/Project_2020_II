#!/bin/bash

failed=( 54 106 132 148 154 180 222 260 262 270 274 288 296 298 326 338 342 356 366 374 398 400 )

for i in "${failed[@]}" ; do
##for (( i=2; i<=400; i=$i+2 )) ; do
	cp sub2.sh plantilla.sh
	sed -i 's/n_proc/'$i'/g' plantilla.sh
	echo "Launching $i processor/s"
        sleep 10
	bsub -x < plantilla.sh
done
rm plantilla.sh
