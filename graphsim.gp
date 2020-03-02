reset

set term png
set output GraphsSimEnergies.png
set multiplot

set x label 'Time'
set y label 'Energy'
set autoscale

p "results.log" u 1:3 w l title "Kinetic Energy"

set x label 'Time'
set y label 'Energy'
set autoscale

p "results.log" u 1:4 w l title "Potential"

set x label 'Time'
set y label 'Energy'
set autoscale

p "results.log" u 1:5 w l title "Total Energy"

unset multiplot
unset output

set output GraphSimTemp.png

set x label 'Time'
set y label 'Temperature'
set autoscale

p "results.log" u 1:2 w l title "Temperature"

unset output

set output GraphSimPress.png

set x label 'Time'
set y label 'Pressure'
set autoscale

p "results.log" u 1:6 w l title "Pressure"

unset output

set output GraphSimGDR.png

set x label 'Time'
set y label 'Pressure'
set autoscale

p "gdr" u 1:2 w l title "GDR"

unset output

