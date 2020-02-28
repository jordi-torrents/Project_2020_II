program verlet

!use programa alberto(inicializacion)
!use programa jordi
use boundary_connditions

contains

subroutine vverlet(pos,vel)

real, dimension(:,:),intent(inout) :: pos,vel
real,dimension(:),intent(out) :: F, pot, kin

!call find forces de jordi(pos)
pos=pos+vel*dt +0.5*F*dt*dt !dt nos lo dara el prgrama de alberto y la posiision y velocidad inicial tmabien, la fuerza el modulo de jordi
call pbc(pos)
vel=vel+F*0.5*dt
!call fins forces jordi(pos)
vel=vel+F*0.5*dt
kin=0.5*dot_product(vel,vel)


end subrotine vverlet


end program verlet
