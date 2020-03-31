COMP=mpif90
OPT=-O3
#FLAGS=-Wall  -fbounds-check
INP=input_file.dat
FLAGS=-g 
#FLAGS=-Wall




## dynamics.exe  Programa calculo Modulo y Distancia de dos vectores
dynamics.exe :  moduls/def_variables.o moduls/mpi_vars.o moduls/Forces_LJ.o moduls/pbc.o moduls/init.o moduls/integration.o  moduls/read_input.o moduls/stadistics.o moduls/gdr.o main.o
	$(COMP) $(OPT) $(FLAGS)  moduls/def_variables.o moduls/mpi_vars.o moduls/pbc.o moduls/Forces_LJ.o moduls/init.o moduls/integration.o  moduls/read_input.o moduls/stadistics.o moduls/gdr.o main.o -o dynamics.exe

moduls/mpi_vars.o : moduls/mpi_vars.f90
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

moduls/def_variables.o : moduls/def_variables.f90 moduls/mpi_vars.o
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

moduls/pbc.o : moduls/pbc.f90 moduls/def_variables.o moduls/mpi_vars.o
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

moduls/Forces_LJ.o : moduls/Forces_LJ.f90 moduls/def_variables.o moduls/pbc.o moduls/mpi_vars.o
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

moduls/init.o : moduls/init.f90 moduls/def_variables.o moduls/Forces_LJ.o moduls/mpi_vars.o
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

moduls/integration.o : moduls/integration.f90 moduls/def_variables.o moduls/Forces_LJ.o moduls/pbc.o moduls/mpi_vars.o
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

moduls/read_input.o : moduls/read_input.f90 moduls/def_variables.o moduls/mpi_vars.o
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

moduls/stadistics.o : moduls/stadistics.f90 moduls/def_variables.o moduls/Forces_LJ.o moduls/mpi_vars.o
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

moduls/gdr.o : moduls/gdr.f90 moduls/def_variables.o moduls/mpi_vars.o
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@

main.o : main.f90 moduls/def_variables.o moduls/mpi_vars.o moduls/pbc.o moduls/Forces_LJ.o moduls/init.o moduls/integration.o moduls/read_input.o moduls/stadistics.o moduls/gdr.o
	$(COMP) $(OPT) $(FLAGS) -c  $< -o $@


## run : Run the program vectors.x
.PHONY: run
run:
	mpirun -np 2 dynamics.exe $(INP)

## clean : rm  *.o *.mod
.PHONY: clean
clean:
	@echo Borrando archivos *.o *.mod
	@rm *.o
	@rm *.mod
	@rm moduls/*.o

## cleanAll : rm  *.o *.mod *.x
.PHONY: cleanAll
cleanAll:
	@echo Borrando archivos *.o *.mod *.exe
	@rm *.exe
	@rm *.o
	@rm *.mod
	@rm moduls/*.o

## help : ayuda
.PHONY: help
help:
	@grep '^##' Makefile


## vabs : imprime valor de variables
.PHONY: vars
vars :
	@echo COMP:  $(COMP)
	@echo OPT:   $(OPT)
	@echo FLAGS: $(FLAGS)

## tar.gz : Genera un tar.gz con todos los archivos .f90 y el Makefile
.PHONY: tar.gz
tar.gz :
	#tar -cvzf SimulationEIA.tar.gz *.f90 Makefile
	tar -cvzf SimulationEIA.$(shell date +%d_%m_%y).tar.gz *f90 moduls/*.f90 *.dat *.md gnuplot_scripts/*.gp Makefile

## plots : hace las gráficas png de GRD y energías en función del tiempo
.PHONY: plots
plots:
	@echo Generando gráficas
	@gnuplot gnuplot_scripts/graphsim.gp
