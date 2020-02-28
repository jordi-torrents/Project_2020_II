module stadistics

contains

subroutine results()

        medida=medida+1
        kinetic=0.5*d.*dot_product(vel,vel)
        temp_inst(medida)=kin**2.0d0/(3.0d0*Npart)
        kin(medida)=kinetic
        pot(medida)=potential
        E_tot(medida)=kinetic+potential
        write(unit=un_mag, fmt=*),temp_inst(medida),kinetic,potential,E_tot
end subroutine results

subroutine statistics()
real(8):: Tav, Tstd,kinav,kinstd,potav,potstd,etotav,etotstv
real(8),dimension(:),intent(out)::kinstot,potstot,Etot
integer:: iav

        iav=iav+1
	Tav=mean(temp_inst); Tstd=std(temp_inst)
	kinav=mean(kin); kinstd=std(kin)
	potav=mean(pot); potstd=std(pot)
        etotav=mean(E_tot); etotstd=std(E_tot)
	Ttot(iav)=Tav
	kinstot(iav)=kinav
	potstot(iav)=potav
	Etot(iav)=etotav
	write(unit=un_stats, fmt=*), Tav,Tstd, kinav, kinstd, potav, potstd, etotav,etotstv

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

end module stadistics
