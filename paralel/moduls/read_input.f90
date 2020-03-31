module read_input
  use def_variables
  use mpi_vars

  contains

  subroutine open_input()
    character(24) :: fName

    call get_command_argument(1,fName, status=fStat)
    if (fStat /= 0) then
      print*,'Failed at reading input file. Exitting program...'
    endif
    open(unit=un_input,file=trim(fName), status='old')
  end subroutine open_input

  subroutine read_parameters()

    read(un_input,*) Npart
    read(un_input,*) dens   ! r.u.
    read(un_input,*) Nsteps
    read(un_input,*) Nterm
    read(un_input,*) temp   ! K
    read(un_input,*) dt     ! r.u.
    read(un_input,*) Nprint
    read(un_input,*) sigmaLJ! A
    read(un_input,*) epsLJ  ! K
    read(un_input,*) mass   ! g/mol
    read(un_input,*) seed
    read(un_input,*) Ngdr
    read(un_input,*) cutoff ! r.u.
    read(un_input,*) nu
    close(un_input)
    cutoff2 = cutoff**2
    E_cut   = 4.d0/cutoff2**6 - 4.d0/cutoff2**3
    L = (dble(Npart)/dens)**(1.d0/3.d0)
    !conversion factors are computed
    Temp_fact   = epsLJ  ! r.u. => K
    temp        = temp/epsLJ !  K => r.u.
    epsLJ       = epsLJ*kB*NA*1.d-3 ! K => kJ/mol
    time_fact   = (1.d2)*sigmaLJ*sqrt((mass*1.d-3)/(epsLJ-1.d3)) ! r.u. => ps
    Press_fact  = epsLJ/(NA*(sigmaLJ*1.d-10)**3) ! r.u. => Pa

  end subroutine read_parameters

end module read_input
