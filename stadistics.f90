module stadistics
use def_variables
use Forces_LJ

contains

subroutine results()
real(8) ::      kinetic

        call pressure_e_pot()
        kinetic=0.5d0*sum(vel**2)/dble(Npart)
        temp_inst(step)=kinetic**2.0d0/(3.0d0)
        kin(step)=kinetic
        pot(step)=e_pot/dble(Npart)
        E_tot(step)=kinetic+pot(step)
        press(step)=pressure
        write(unit=un_mag, fmt=*) time, temp_inst(step),kin(step),pot(step),E_tot(step), press(step)
end subroutine results

subroutine statistics()
real(8):: Tav, Tstd,kinav,kinstd,potav,potstd,etotav,etotstd, pressav, pressstd

        open(unit=un_stats,file='stats.log')
        write(unit=un_stats, fmt=*) 'Temp      Kin     Potencial       E_tot        Pressure'

        Tav=mean(temp_inst); Tstd=std(temp_inst)
        kinav=mean(kin); kinstd=std(kin)
        potav=mean(pot); potstd=std(pot)
        etotav=mean(E_tot); etotstd=std(E_tot)
        pressav=mean(press); pressstd=std(press)

        write(unit=un_stats, fmt=*) Tav,Tstd, kinav, kinstd, potav, potstd, etotav,etotstv, pressav, pressstd
        close(un_stats)
end subroutine statistics


function mean(x)

real(8),dimension(:), intent(in):: x
real(8) ::      mean
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

        std=dsqrt(suma/(size(x)-1.0d0))

end function std

end module stadistics
