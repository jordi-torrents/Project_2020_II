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
if (workerid==master) then
call cpu_time(start)
endif
call open_input()
call read_parameters()
call init_mpi(Npart)
call allocate_arrays(Nsteps, Nprint, Npart)
step=-1
call initialize()

if (workerid==master) then
open(unit=un_mag,file='results.log')
write(unit=un_mag, fmt=*) '# Time         Temp      Kin     Potencial       E_tot        Pressure'
endif
do step=1,Nterm
  call vverlet()
  call andersen_termo()
enddo
!call MPI_BARRIER(MPI_COMM_WORLD,ierror)
step=0
call gdr_step()
call results()

do step =1,int(Nsteps/Nprint)
  time = time + dt
  do step_print=1, Nprint
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

if (workerid==master) then
call cpu_time(finish)
print*,'CPU time:',finish-start,'s'
endif
call MPI_FINALIZE(ierror)
end program dynamics
