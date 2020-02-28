program dynamics

use def_variables
use read_input
use init
use Forces_LJ
use integrator
use stadistics
use gdr

call cpu_time(start)
call open_input()
call read_parameters()
call setr1279(seed)
call allocate_arrays(Nsteps, Nprint, Npart)
call initialize()

do step =1,int(Nsteps/Nprint),1
        do step_print=1, Nprint
                call vverlet()
        enddo
        call gdr_step()
        call magnitudes()
enddo

call gdr_final()
call stats()
call cpu_time(finish)
print*,'CPU time:',finish-start,'s'

end program dynamics
