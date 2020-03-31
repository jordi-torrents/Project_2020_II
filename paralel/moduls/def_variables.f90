module def_variables
use mpi_vars

  implicit none
  real(8)  ::   start, finish
  integer  ::   fStat
  integer  ::   un_input=101, un_gdr=102, un_mag=103, un_stats=104
  integer  ::   Npart, step_print, step, Nsteps, Nprint, Ngdr, Nterm, seed
  real(8)  ::   dens, temp, dt, sigmaLJ, epsLJ, mass, L
  real(8)  ::   cutoff, dx, nu,pi, cutoff2, na=6.0221409d23, kb=1.3806485279d-23
  real(8)  ::   temperaturef, pressuref,timef
  real(8)  ::   e_pot, e_cut, pressure, time
  real(8), allocatable,dimension(:,:)     ::      pos, vel, forces
  real(8), allocatable,dimension(:)       ::      E_tot, kin, pot, press , temp_inst, gdr
  integer,allocatable,dimension(:)        ::      gdr_int

  contains

  subroutine allocate_arrays(Nsteps, Nprint, Npart)
    integer   ::   Nsteps, Nprint, Npart
    allocate(      pos(Npart,3))
    allocate(      vel(Npart,3))
    allocate(   forces(Npart,3))
    allocate(    E_tot(1+int(Nsteps/Nprint)))
    allocate(      kin(1+int(Nsteps/Nprint)))
    allocate(      pot(1+int(Nsteps/Nprint)))
    allocate(    press(1+int(Nsteps/Nprint)))
    allocate(temp_inst(1+int(Nsteps/Nprint)))
    allocate(      gdr(Ngdr))
    allocate(      gdr_int(Ngdr))
  end subroutine allocate_arrays

end module def_variables
