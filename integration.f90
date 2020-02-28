module integration

use init
use FF90
use boundary_conditions

contains

subroutine vverlet()
call initialize
real(8),dimension(:),intent(out) :: F, pot, kin

call ForcesLJ()
pos=pos+vel*dt +0.5d0*F*dt*dt !dt nos lo dara el prgrama de alberto y la posiision y velocidad inicial tmabien, la fuerza el modulo de jordi
call pbc(pos)
vel=vel+F*0.5d0*dt
call ForcesLJ()
vel=vel+F*0.5d0*dt
kin=0.5d0*dot_product(vel,vel)


end subroutine vverlet


end module verlet
