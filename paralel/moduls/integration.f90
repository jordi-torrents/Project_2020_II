module integration

  use def_variables
  use Forces_LJ
  use pbc
  use mpi_vars

contains

subroutine vverlet() ! velocity verlet algorithm
  if (workerid==master) then
  pos=pos+vel*dt +0.5d0*forces*dt*dt
  call pbc_pos()
  vel=vel+forces*0.5d0*dt
  endif
  call ForcesLJ()
  if (workerid==master) then
  vel=vel+forces*0.5d0*dt
  endif
  call MPI_BCAST(pos, (Npart*3), MPI_DOUBLE_PRECISION, master, MPI_COMM_WORLD, IERROR)
  call MPI_BCAST(vel, (Npart*3), MPI_DOUBLE_PRECISION, master, MPI_COMM_WORLD, IERROR)
end subroutine vverlet

subroutine andersen_termo() ! andersen thermostat
  integer :: i
  real(8) :: U0, U1, U2, U3, U4
  if (workerid==master) then

  do i=1,Npart
    call random_number(U0)
    if (U0<nu) then
      call random_number(U1)
      call random_number(U2)
      call random_number(U3)
      call random_number(U4)
      vel(i,1)=dsqrt(-2.d0*temp*dlog(U1))*dcos(2.d0*pi*U2)
      vel(i,2)=dsqrt(-2.d0*temp*dlog(U1))*dsin(2.d0*pi*U2)
      vel(i,3)=dsqrt(-2.d0*temp*dlog(U3))*dcos(2.d0*pi*U4)
    end if
  end do
  endif
  call MPI_BCAST(vel, (Npart*3), MPI_DOUBLE_PRECISION, master, MPI_COMM_WORLD, IERROR)
end subroutine

end module integration
