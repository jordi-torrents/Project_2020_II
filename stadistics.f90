program estadistica

!use programa alberto
use verlet

contains

subroutine statistic(pos,vel)

real,dimension(:,:),intent(in) :: pos,vel
real,dimension(Ntimesteps):: T, kins, pots
real,allocatable,intent(out):: kinstot,postot

open(unit=11, file="thermo.dat", status="replace", action="write")

do i=1,Ntimesteps
	call verlet(pos,vel)
	
	T(i)=kin**2.0/(3.0*N)
	kins(i)=kin
	pots(i)=pot

	if (mod(i,Ntraj)==0.0) then
		

	end if
	
	if (mod(i,Nthermo)==0.0) then

	end if

end subroutine statistic



end program estadistica
