module stadistics
  use def_variables
  use Forces_LJ
  use mpi_vars

  contains

  subroutine results()

    call Press_and_E_pot()
    E_kin=0.5d0*sum(vel(first_part:last_part,:)**2)/dble(Npart)
    call MPI_REDUCE(E_kin,E_kin,1,MPI_DOUBLE_PRECISION,MPI_SUM,master,MPI_COMM_WORLD,ierror)

    if (workerid==master) then
     Temp_array(step+1)  = E_kin*2.d0/(3.d0)
    E_kin_array(step+1)  = E_kin
    E_pot_array(step+1)  = E_pot
    E_tot_array(step+1)  = E_kin+E_pot
    Press_array(step+1)  = Press

    write(un_mag,'(6e16.8)') time*time_fact, E_kin*(2.d0/(3.d0))*Temp_fact, E_kin*epsLJ, E_pot*epsLJ,&
    (E_pot+E_kin)*epsLJ, Press*Press_fact
    endif
  end subroutine results

  subroutine statistics()
    if (workerid==master) then
    open(unit=un_stats,file='output/stats.log')
    write(un_stats,'(a5,5a17)' ) '#','Temp(K)','E_kin(kJ/mol)','E_pot(kJ/mol)','E_tot(kJ/mol)','Pressure(MPa)'

    write(un_stats,'(a5,5f17.8)') "Mean",mean( Temp_array)*Temp_fact,&
                                         mean(E_kin_array)*epsLJ,&
                                         mean(E_pot_array)*epsLJ,&
                                         mean(E_tot_array)*epsLJ,&
                                         mean(Press_array)*Press_fact
    write(un_stats,'(a5,5f17.8)') "Std",  std( Temp_array)*Temp_fact,&
                                          std(E_kin_array)*epsLJ,&
                                          std(E_pot_array)*epsLJ,&
                                          std(E_tot_array)*epsLJ,&
                                          std(Press_array)*Press_fact
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
    media= mean(x)
    suma = sum((x(:)-media)**2)
    std  = sqrt(suma/dble(size(x)-1))
  end function std

end module stadistics
