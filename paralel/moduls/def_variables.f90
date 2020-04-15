module def_variables
  use mpi_vars

  !  Definition of program general variables and allocate arrays

  implicit none
! external program time counters
  real(4)  ::   start, finish
! unit files
  integer  ::   fStat, un_input=101, un_gdr=102, un_mag=103, un_stats=104
! constants (pi, Avogadro, Boltzmann)
  real(8)  ::   pi,  na=6.0221409d23, kb=1.3806485279d-23
! number of particles, step counters (x2), total number of steps, steps between measures, gdr bins, initial termalizing steps, random seed
  integer  ::   Npart, step_print, step, Nsteps, Nprint, Ngdr, Nterm, seed
! density, temperature, time increment, lenard-Jones sigma, Lenard-Jones epsilon, paricle mass, box lenght
  real(8)  ::   dens, temp, dt, sigmaLJ, epsLJ, mass, L
! interaction cut-off, cut-off square, Potential enegy on cut-off, thermostat const
  real(8)  ::   cutoff, cutoff2, E_cut, nu
! unit transformation factors
  real(8)  ::   Temp_fact, Press_fact, time_fact
! system magnitudes
  real(8)  ::   E_kin, E_pot,  Press, time
! particles positions, velocities and forces
  real(8), allocatable, dimension(:,:) :: pos, vel, forces
! set of measurements and g(r)
  real(8), allocatable, dimension(:)   :: E_tot_array, E_kin_array, E_pot_array, Press_array, Temp_array, gdr
  integer, allocatable, dimension(:)   :: gdr_int

  contains

  subroutine allocate_arrays(Nsteps, Nprint, Npart)
    integer :: Nsteps, Nprint, Npart
    allocate(forces(Npart,3))
    allocate(   pos(Npart,3))
    allocate(   vel(Npart,3))
! we will do Nsteps/Nprints measures plus one measure at t=0
    allocate(E_tot_array(1+Nsteps/Nprint))
    allocate(E_kin_array(1+Nsteps/Nprint))
    allocate(E_pot_array(1+Nsteps/Nprint))
    allocate(Press_array(1+Nsteps/Nprint))
    allocate( Temp_array(1+Nsteps/Nprint))
    allocate(gdr_int(Ngdr))
    allocate(    gdr(Ngdr))
  end subroutine allocate_arrays

end module def_variables
