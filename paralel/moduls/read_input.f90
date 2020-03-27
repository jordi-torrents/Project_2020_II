module read_input
  use def_variables
  use mpi_vars

  contains

  subroutine open_input()
    character(24)    ::      fName

    call get_command_argument(1,fName, status=fStat)
    if (fStat /= 0) then
      print*,'Failed at reading input file. Exitting program...'
    endif
    open(unit=un_input,file=trim(fName), status='old')
  end subroutine open_input

  subroutine read_parameters()

    read(un_input,*) Npart
    read(un_input,*) dens
    read(un_input,*) Nsteps
    read(un_input,*) Nterm
    read(un_input,*) temp
    read(un_input,*) dt
    read(un_input,*) Nprint
    read(un_input,*) sigmaLJ
    read(un_input,*) epsLJ
    read(un_input,*) mass
    read(un_input,*) seed
    read(un_input,*) Ngdr
    read(un_input,*) cutoff
    read(un_input,*) nu
    cutoff2 = cutoff**2
    !conversion factors are computed
    temperaturef=epsLJ
    temp=temp/temperaturef
    epsLJ=epsLJ*kB*NA
    timef=sigmaLJ*1d2*sqrt(mass/(epsLJ*1000.d0))
    pressuref=epsLJ*1d30/(NA*sigmaLJ**3.d0)
    L = (dble(Npart)/dens)**(1.d0/3.d0)
    close(un_input)
    
  end subroutine read_parameters

end module read_input
