reset

set terminal pngcairo size 800,600 enhanced font 'Verdana,13'
set output "GraphsSimEnergies.png"

set autoscale
set xlabel 'Time / ps'
set ylabel 'Energy / kJ/mol'
set key title 'Energies'
set key center right
set key box
plot "results.log" u 1:3 w l title "Kinetic Energy", "results.log" u 1:4 w l title "Potential", "results.log" u 1:5 w l title "Total Energy"
unset key
set output "GraphSimTemp.png"

set xlabel 'Time / ps'
set ylabel 'Temperature / K'


plot "results.log" u 1:2 w l title "Temperature"

set output "GraphSimPress.png"

set xlabel 'Time / ps'
set ylabel 'Pressure / Pa'


plot "results.log" u 1:6 w l title "Pressure"


set output "GraphSimGDR.png"

set xlabel 'r / {\305}'
set ylabel 'g(r)'


p "gdr.log" u 1:2 w l title "GDR"
