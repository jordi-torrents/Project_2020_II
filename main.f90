program dynamics
use def_variables
use read_input
use init
integer ::      i
call cpu_time(start)

call open_input(un_input)
call read_parameters(un_input,Npart,dens,Nsteps,temp,dt,Nprint,sigmaLJ,epsLJ,mass,seed, L)
call allocate_arrays(Nsteps, Nprint, Npart)
call initialize()
!do step =1,Nsteps,1
!       !! call integrador()
!       if (mod(step,Nprint) == 0) then
!enddo
call cpu_time(finish)
print*,'CPU time:',finish-start,'s'
end program dynamics
