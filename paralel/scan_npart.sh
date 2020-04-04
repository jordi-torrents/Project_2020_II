#!/bin/bash
cp input_file.dat temp.dat

for (( i=2500; i<=4500; i=$i+100 )) ; do
	cp temp.dat input_file.dat
	cp sub2.sh temp.sh
	sed -i 's/var_1/'$i'/g' input_file.dat
	sed -i 's/time/time'$i'/g' temp.sh
	echo "Launchins $i particules/s"
	head -1 input_file.dat
	bsub < temp.sh
        sleep 10
done
rm temp.dat
rm temp.sh
