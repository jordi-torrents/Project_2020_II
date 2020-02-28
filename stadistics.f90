module estadistica

!use programa alberto
use verlet


contains

subroutine statistic()

real(8),dimension(Ntimesteps):: T, kins, pots
real(8) :: Tav,Tstd,kinav,kinstd,potav,potstd
real(8),dimension(Nsteps/Nprint),intent(out):: kinstot,postot, Ttot, Etot
integer :: iprint
open(unit=11, file="thermo.dat", status="replace", action="write")

iprint=0


do i=1,Ntimesteps
	call verlet(pos)

	T(i)=kin**2.0d0/(3.0d0*N)
	kins(i)=kin
	pots(i)=pot

	if (mod(i,Nprint)==0.0) then


		Tav=mean(T); Tstd=std(T)
		kinav=mean(kins); kinstd=std(kins)
		potav=mean(pots); potstd=std(pots)
		Ttot(iprint)=Tav
		kinstot(iprint)=kinav
		potstot(iprint)=potav
		Etot(iprint)=kinav+potav
	end if
	
	write(unit=11, fmt="(2f12.7)"), Tav,Tstd, kinav, kinstd, potav, potstd, Etot

end do
end subroutine statistic


function mean(x)

real(8),dimension(:), intent(in):: x
real(8):: mean

mean=sum(x)/size(x)

end function mean

function std(x)
real(8),dimension(:),intent(in)::x
real(8):: media, suma
real(8)::std


suma=0.0
media=mean(x)
do i=1,size(x)
	suma=suma+(x(i)-media)**2
end do

std=sqrt(suma/(size(x)-1.0d0))

end function std

end module estadistica
