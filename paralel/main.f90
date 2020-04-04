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
call paralel_particle_distribution(Npart)
call allocate_arrays(Nsteps, Nprint, Npart)
call initialize()

! termalizing system
do step=1,Nterm
  call vverlet()
  call andersen_termo()
enddo

! first measurement at t=0
step=0
call gdr_step()
call results()

! simulation main loop
do step = 1, Nsteps/Nprint
  do step_print = 1, Nprint
    time = time + dt
    call vverlet()
    call andersen_termo()
  enddo
  call gdr_step()
  call results()
enddo

! final measures adjustments
call gdr_final()
call statistics()

call cpu_time(finish)
if (workerid==master) then
  print*,'CPU time:',finish-start,'s'
endif
call MPI_FINALIZE(ierror)
end program dynamics
