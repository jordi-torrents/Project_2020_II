program dynamics

use def_variables
use read_input
use init
use Forces_LJ
use integrator
use stadistics
use gdr

call cpu_time(start)
call setr1279(seed)
open(unit=un_mag,file='results.log')
write(unit=un_stats, fmt=*), 'Temp      Kin     Potencial       E_tot        Pressure'
open(unit=un_stats,file='stats.log')
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

call gdr_final()
call stats()
close(un_mag); close(un_stats)
call cpu_time(finish)
print*,'CPU time:',finish-start,'s'

end program dynamics
