program dynamics

use def_variables
use read_input
use init
use integration
use stadistics
use gdr_funcs
use mpi_vars

call MPI_INIT(ierror)
call MPI_COMM_RANK(MPI_COMM_WORLD,workerid,ierror)
call MPI_COMM_SIZE(MPI_COMM_WORLD,numproc,ierror)
call cpu_time(start)
call open_input()
call read_parameters()
call init_mpi(Npart)
call allocate_arrays(Nsteps, Nprint, Npart)
call initialize()

if (workerid==master) then
open(unit=un_mag,file='output/results.log')
write(un_mag,'(6a16)' ) '#Time_(ps)','Temp_(K)','E_kin_(kJ/mol)','E_pot_(kJ/mol)','E_tot_(kJ/mol)','Pressure_(MPa)'
endif

do step=1,Nterm
  call vverlet()
  call andersen_termo()
enddo
step=0
call gdr_step()
call results()

do step = 1, Nsteps/Nprint
  do step_print = 1, Nprint
    time = time + dt
    call vverlet()
    call andersen_termo()
  enddo
  call gdr_step()
  call results()
enddo

if (workerid==master) then
close(un_mag)
endif
call gdr_final()
call statistics()

call cpu_time(finish)
if (workerid==master) then
print*,'CPU time:',finish-start,'s'
endif
call MPI_FINALIZE(ierror)
end program dynamics
