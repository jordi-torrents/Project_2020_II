COMP=gfortran
OPT=-O3
FLAGS=-Wall  -fbounds-check
INP=input_file.dat
#FLAGS=-Wall




## SimulacioEIA.exe  Programa calculo Modulo y Distancia de dos vectores
SimulacioEIA.exe :  def_variables.o Forces_LJ.o pbc.o init.o integration.o  read_input.o stadistics.o gdr.o main.o
	$(COMP) $(OPT) $(FLAGS)  def_variables.o pbc.o Forces_LJ.o init.o integration.o  read_input.o stadistics.o gdr.o main.o -o SimulacioEIA.exe

#r1279.o : r1279.f90
#	$(COMP) $(OPT)  -c  $< -o $@
#
#ran2.o : ran2.f
#	$(COMP) $(OPT) -c  $< -o $@

# secs.o : secs.c
# 	gcc $(OPT)  -c  $< -o $@

def_variables.o : def_variables.f90
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

pbc.o : pbc.f90 def_variables.o
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

Forces_LJ.o : Forces_LJ.f90 def_variables.o pbc.o
	$(COMP) $(OPT) $(FLAGS) -c $< -o $@

init.o : init.f90 def_variables.o Forces_LJ.o
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

integration.o : integration.f90 def_variables.o Forces_LJ.o pbc.o
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

read_input.o : read_input.f90 def_variables.o
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

stadistics.o : stadistics.f90 def_variables.o Forces_LJ.o
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

gdr.o : gdr.f90 def_variables.o
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

main.o : main.f90 def_variables.o pbc.o Forces_LJ.o init.o integration.o read_input.o stadistics.o gdr.o
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

# SimulacioEIA_directe: r1279.f90 ran2.f90 secs.f90 secs.o def_variables.f90 Forces_LJ.f90 pbc.f90 init.f90o integration.f90 read_input.f90 stadistics.f90  main.of90 SimulacioEIA_directe.x

## run : Run the program vectors.x
.PHONY: run_directe
run_directe:
	./SimulacioEIA_directe.x $(INP)

## run : Run the program vectors.x
.PHONY: run
run:
	./SimulacioEIA.exe $(INP)

## clean : rm  *.o *.mod
.PHONY: clean
clean:
	@echo Borrando archivos *.o *.mod
	@rm -f *.o
	@rm -f *.mod

## cleanAll : rm  *.o *.mod *.x
.PHONY: cleanAll
cleanAll:
	@echo Borrando archivos *.o *.mod *.x
	@rm -f *.o
	@rm -f *.mod
	@rm -f *.x

## help : ayuda
.PHONY: help
help:
	@grep '^##' Makefile


## vabs : imprime valor de variables
.PHONY: vabs
vabs :
	@echo COMP:  $(COMP)
	@echo OPT:   $(OPT)
	@echo FLAGS: $(FLAGS)

## tar.gz : Genera un tar.gz con todos los archivos .f90 y el Makefile
.PHONY: tar.gz
tar.gz :
	#tar -cvzf SimulationEIA.tar.gz *.f90 Makefile
	tar -cvzf SimulationEIA.$(shell date +%d_%m_%y).tar.gz *.f90 *.dat *.md *.gp Makefile

## plots : hace las gráficas png de GRD y energías en función del tiempo
.PHONY: plots
plots:
	@echo Generando gráficas
	@gnuplot graphsim.gp
