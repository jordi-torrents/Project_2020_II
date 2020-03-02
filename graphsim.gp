reset

set term png
set output "GraphsSimEnergies.png"

set xlabel 'Time {ps}'
set ylabel 'Energy {kJ/mol}'

p "results.log" u 1:3 w l title "Kinetic Energy", "results.log" u 1:4 w l title "Potential", "results.log" u 1:5 w l title "Total Energy"

unset output

set output "GraphSimTemp.png"

set xlabel 'Time {ps}'
set ylabel 'Temperature {K}'
set autoscale

p "results.log" u 1:2 w l title "Temperature"

unset output

set output "GraphSimPress.png"

set xlabel 'Time {ps}'
set ylabel 'Pressure {Pa}'
set autoscale

p "results.log" u 1:6 w l title "Pressure"

unset output

set output "GraphSimGDR.png"

set xlabel 'r / {\305}'
set ylabel 'g(r)'
set autoscale

p "gdr.log" u 1:2 w l title "GDR"

unset output
