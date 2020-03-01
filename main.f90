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
!call setr1279(seed)
call srand(seed)

open(unit=un_mag,file='results.log')
write(unit=un_mag, fmt=*) 'Time         Temp      Kin     Potencial       E_tot        Pressure'
call open_input()
call read_parameters()

call allocate_arrays(Nsteps, Nprint, Npart)
call initialize()
open(unit=100,file='initial_vel.xyz')
do i=1, Npart
write(100,*) vel(i,:)
enddo
close(100)

do i=1,Nterm
        call vverlet()
enddo


do step =1,int(Nsteps/Nprint),1
        time = time + dt
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
