module def_variables
  use mpi_vars

  implicit none
  real(8)  ::   start, finish
  integer  ::   fStat, un_input=101, un_gdr=102, un_mag=103, un_stats=104
  integer  ::   Npart, step_print, step, Nsteps, Nprint, Ngdr, Nterm, seed
  real(8)  ::   dens, temp, dt, sigmaLJ, epsLJ, mass, L
  real(8)  ::   cutoff, dx, nu,pi, cutoff2, na=6.0221409d23, kb=1.3806485279d-23
  real(8)  ::   Temp_fact, Press_fact, time_fact
  real(8)  ::   E_kin, E_pot, E_cut, Press, time
  real(8), allocatable, dimension(:,:) :: pos, vel, forces
  real(8), allocatable, dimension(:)   :: E_tot_array, E_kin_array, E_pot_array, Press_array, Temp_array, gdr
  integer, allocatable, dimension(:)   :: gdr_int

  contains

  subroutine allocate_arrays(Nsteps, Nprint, Npart)
    integer   ::   Nsteps, Nprint, Npart ! no calen aquestes definicions
    allocate(forces(Npart,3))
    allocate(   pos(Npart,3))
    allocate(   vel(Npart,3))
    allocate(E_tot_array(1+Nsteps/Nprint))
    allocate(E_kin_array(1+Nsteps/Nprint))
    allocate(E_pot_array(1+Nsteps/Nprint))
    allocate(Press_array(1+Nsteps/Nprint))
    allocate( Temp_array(1+Nsteps/Nprint))
    allocate(gdr_int(Ngdr))
    allocate(    gdr(Ngdr))
  end subroutine allocate_arrays

end module def_variables
