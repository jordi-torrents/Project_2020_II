module integration

  use def_variables
  use Forces_LJ
  use pbc
  use mpi_vars

contains

subroutine vverlet() ! velocity verlet algorithm
  
  integer :: i
   
  do i=first_part, last_part
     pos(i,:)=pos(i,:)+vel(i,:)*dt +0.5d0*forces(i,:)*dt*dt
     vel(i,:)=vel(i,:)+forces(i,:)*0.5d0*dt
  enddo
  
  call pbc_pos()

  do i=1,3
  call MPI_GATHERV(pos(first_part:last_part,i),(last_part-first_part+1),MPI_DOUBLE_PRECISION, &
                   pos(:,i),sizes_part,displs_part,MPI_DOUBLE_PRECISION, master,MPI_COMM_WORLD,ierror)
  end do

  call MPI_BCAST(pos, (Npart*3), MPI_DOUBLE_PRECISION, master, MPI_COMM_WORLD, IERROR)
  call ForcesLJ()
  do i=first_part, last_part
    vel(i,:)=vel(i,:)+forces(i,:)*0.5d0*dt
  enddo
end subroutine vverlet

subroutine andersen_termo() ! andersen thermostat
  integer :: i
  real(8) :: U0, U1, U2, U3, U4

  do i=first_part,last_part
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
end subroutine

end module integration
