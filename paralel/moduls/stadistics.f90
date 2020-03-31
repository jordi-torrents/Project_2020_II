module stadistics
  use def_variables
  use Forces_LJ
  use mpi_vars

  contains

  subroutine results()
    real(8) ::      kinetic

    call pressure_e_pot()
    kinetic      =     0.5d0*sum(vel(first_part:last_part,:)**2)/dble(Npart)
    call MPI_REDUCE(kinetic,kinetic,1,MPI_DOUBLE_PRECISION,MPI_SUM,master,MPI_COMM_WORLD,ierror)

    if (workerid==master) then
    temp_inst(step+1)= kinetic*2.0d0/(3.0d0)
    kin(step+1)  =     kinetic*0.001
    pot(step+1)  =     e_pot/dble(Npart)*0.001
    E_tot(step+1)=     kin(step+1)+pot(step+1)
    press(step+1)=     pressure

    write(un_mag,'(6e16.8)') time*timef,temp_inst(step+1)*temperaturef,kin(step+1)*epsLJ, pot(step+1)*epsLJ,&
    E_tot(step+1)*epsLJ, press(step+1)*pressuref
    endif
  end subroutine results

  subroutine statistics()
    real(8):: Tav, Tstd, kinav, kinstd, potav, potstd, etotav, etotstd, pressav, pressstd
    if (workerid==master) then
    open(unit=un_stats,file='output/stats.log')
    write(un_stats,'(a5,5a17)' ) '','#Temp(K)','Kin(kJ/mol)','Potential(kJ/mol)','E_tot(kJ/mol)','Pressure(Pa)'

    Tav    = mean(temp_inst); Tstd    = std(temp_inst)
    kinav  = mean(kin)      ; kinstd  = std(kin)
    potav  = mean(pot)      ; potstd  = std(pot)
    etotav = mean(E_tot)    ; etotstd = std(E_tot)
    pressav= mean(press)    ; pressstd= std(press)
    write(un_stats,'(a5,5e17.8)' ) "Mean",Tav*temperaturef, kinav*epsLJ, potav*epsLJ, etotav*epsLJ, pressav*pressuref
    write(un_stats,'(a5,5e17.8)' ) "Std", Tstd*temperaturef,  kinstd*epsLJ,potstd*epsLJ,etotstd*epsLJ,  pressstd*pressuref
    close(un_stats)
    endif
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
