COMP=gfortran
OPT=-O3
FLAGS=-Wall  -fbounds-check
#FLAGS=-Wall  




## SimulacioEIA.x  Programa calculo Modulo y Distancia de dos vectores
SimulacioEIA.x :  Forces_LJ.o pbc.o def_variables.o init.o integration.o  read_input.o stadistics.o r1279.o ran2.o secs.o main.o 
	$(COMP) $(OPT) $(FLAGS)  Forces_LJ.o pbc.o def_variables.o init.o integration.o  read_input.o stadistics.o r1279.o ran2.o secs.o main.o SimulacioEIA.x


def_variables.o : def_variables.f90
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

Forces_LJ.o : Forces_LJ.f90
	$(COMP) $(OPT) $(FLAGS) -c $< -o $@

pbc.o : pbc.f90
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

init.o : init.f90
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

integration.o : integration.f90
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

read_input.o : read_input.f90 
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

stadistics.o : stadistics.f90 
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

r1279.o : r1279.f90
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

ran2.o : ran2.f
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

secs.o : secs.c
	gcc $(OPT) $(FLAGS) -c  $< -o $@

main.o : main.f90 def_variables.o
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

SimulacioEIA_directe: def_variables.f90 Forces_LJ.f90 pbc.f90 init.f90o integration.f90  read_input.f90 stadistics.f90 r1279.f90 ran2.f90 secs.f90 secs.o main.of90 SimulacioEIA_directe.x

## run : Run the program vectors.x
.PHONY: run_directe
run:
	./SimulacioEIA_directe.x

## run : Run the program vectors.x
.PHONY: run
run:
	./SimulacioEIA.x

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
.PHONE: tar.gz
tar.gz :
	#tar -cvzf vectors.tar.gz *.f90 Makefile
	tar -cvzf vectors.$(shell date +%d_%m_%y).tar.gz *.f90 Makefile
