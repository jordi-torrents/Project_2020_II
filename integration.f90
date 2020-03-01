module integration

use def_variables
use Forces_LJ
use pbc

contains

subroutine vverlet()

pos=pos+vel*dt +0.5d0*forces*dt*dt
call pbc_pos()
vel=vel+forces*0.5d0*dt
call ForcesLJ()
vel=vel+forces*0.5d0*dt


end subroutine vverlet


end module integration
