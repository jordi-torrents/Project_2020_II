reset

set term png
set output GraphsSim.png
set multiplot

set x label 'Time'
set y label 'Temperature'
set autoscale

p "results.log" u 1:2 w l title "Temperature"

set x label 'Time'
set y label 'Temperature'
set autoscale

p "results.log" u 1:2 w l title "Kinetic Energy"

set x label 'Time'
set y label 'Temperature'
set autoscale

p "results.log" u 1:2 w l title "Potential"

set x label 'Time'
set y label 'Temperature'
set autoscale

p "results.log" u 1:2 w l title "Total Energy"

set x label 'Time'
set y label 'Temperature'
set autoscale

p "results.log" u 1:2 w l title "Pressure"

unset multiplot
unset output
