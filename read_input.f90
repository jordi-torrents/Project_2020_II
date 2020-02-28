module read_input
  implicit none

  contains

  subroutine open_input(un_input)
    implicit none
    character(24)           ::      fName
    integer                 ::      fStat
    integer, intent(in)     ::      un_input

    call get_command_argument(1,fName, status=fStat)
    if (fStat /= 0) then
      print*,'Failed at reading input file. Exitting program...'
    endif
    open(unit=un_input,file=trim(fName), status='old')
  end subroutine open_input

  subroutine read_parameters(un_input,Npart,dens,Nsteps,temp,dt,Nprint,sigmaLJ,epsLJ,mass,seed, L)

    implicit none
    integer, intent(in)     ::      un_input
    integer, intent(out)    ::      Npart, Nsteps, Nprint
    integer, intent(out)    ::      seed
    real(8), intent(out)    ::      dens, temp, dt, sigmaLJ, epsLJ, mass, L


    read(un_input,*) Npart
    read(un_input,*) dens
    read(un_input,*) Nsteps
    read(un_input,*) temp
    read(un_input,*) dt
    read(un_input,*) Nprint
    read(un_input,*) sigmaLJ
    read(un_input,*) epsLJ
    read(un_input,*) mass
    read(un_input,*) seed
    read(un_input,*) Ngdr
    L = (dble(Npart)/dens)**(1.d0/3.d0)
    close(un_input)
  end subroutine read_parameters

end module read_input
