module stadistics
  use def_variables
  use Forces_LJ

  contains

  subroutine results()
    real(8) ::      kinetic

    call pressure_e_pot()
    kinetic      =     0.5d0*sum(vel**2)/dble(Npart)
    temp_inst(step+1)= kinetic*2.0d0/(3.0d0)
    kin(step+1)  =     kinetic*0.001
    pot(step+1)  =     e_pot/dble(Npart)*0.001
    E_tot(step+1)=     kin(step+1)+pot(step+1)
    press(step+1)=     pressure

    write(unit=un_mag, fmt=*) time*timef,temp_inst(step+1)*temperaturef,kin(step+1)*epsLJ, pot(step+1)*epsLJ,&
    E_tot(step+1)*epsLJ, press(step+1)*pressuref
  end subroutine results

  subroutine statistics()
    real(8):: Tav, Tstd, kinav, kinstd, potav, potstd, etotav, etotstd, pressav, pressstd

    open(unit=un_stats,file='output/stats.log')
    write(unit=un_stats, fmt=*) '# 		Temp (K)      	Kin (kJ/mol)  '&
    &'  Potential (kJ/mol)       E_tot (kJ/mol)      Pressure (Pa)'

    Tav    = mean(temp_inst); Tstd    = std(temp_inst)
    kinav  = mean(kin)      ; kinstd  = std(kin)
    potav  = mean(pot)      ; potstd  = std(pot)
    etotav = mean(E_tot)    ; etotstd = std(E_tot)
    pressav= mean(press)    ; pressstd= std(press)
    write(unit=un_stats, fmt=*) "Mean",Tav*temperaturef, kinav*epsLJ, potav*epsLJ, etotav*epsLJ, pressav*pressuref
    write(unit=un_stats, fmt=*) "Std", Tstd*temperaturef,  kinstd*epsLJ,&
    potstd*epsLJ,etotstd*epsLJ,  pressstd*pressuref
    close(un_stats)
  end subroutine statistics


  function mean(x)

  real(8),dimension(:), intent(in):: x
    real(8) ::   mean
            mean=sum(x)/size(x)

  end function mean

  function std(x)
    real(8),dimension(:),intent(in)::x
    real(8):: media, suma, std

            media=mean(x)
            suma=sum((x(:)-media)**2)
            std=sqrt(suma/(size(x)-1.0d0))

  end function std

end module stadistics
