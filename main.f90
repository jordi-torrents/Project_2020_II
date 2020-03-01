program dynamics

use def_variables
use read_input
use init
use integration
use stadistics
use gdr_funcs

call cpu_time(start)
call open_input()
call read_parameters()
call setr1279(seed)

open(unit=un_mag,file='results.log')
call open_input()
call read_parameters()

call allocate_arrays(Nsteps, Nprint, Npart)
call initialize()

do i=1,Nterm
        call vverlet()
enddo


do step =1,int(Nsteps/Nprint),1
        do step_print=1, Nprint
                call vverlet()
        enddo
        call gdr_step()
        call results()
enddo
close(un_mag)

call gdr_final()
call statistics()
call cpu_time(finish)
print*,'CPU time:',finish-start,'s'

end program dynamics
