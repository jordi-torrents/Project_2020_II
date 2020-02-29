module def_variables

  implicit none
  real(8)                 ::      start, finish
  integer                 ::      fStat

  integer                 ::      un_input=101, un_gdr=102, un_mag=103, un_stats=104 

  integer                 ::      Npart, step_print, step, Nsteps, Nprint, Ngdr
  integer                 ::      seed
  real(8)                 ::      dens, temp, dt, sigmaLJ, epsLJ, mass, L
  real(8)                 ::      cutoff
  real(8)                 ::      r1279
  real(8)                 ::      e_pot, pressure

  real(8), allocatable,dimension(:,:)     ::      pos, vel, forces
  real(8), allocatable,dimension(:)       ::      E_tot, kin, pot, press , temp_inst, gdr

  contains

  subroutine allocate_arrays(Nsteps, Nprint, Npart)
    implicit none
    integer         ::      Nsteps, Nprint, Npart
    allocate(pos(Npart,3))
    allocate(vel(Npart,3))
    allocate(forces(Npart,3))
    allocate(E_tot(int(Nsteps/Nprint)))
    allocate(kin(int(Nsteps/Nprint)))
    allocate(pot(int(Nsteps/Nprint)))
    allocate(press(int(Nsteps/Nprint)))
    allocate(temp_inst(int(Nsteps/Nprint)))
    allocate(gdr(Ngdr))
  end subroutine allocate_arrays

end module def_variables
