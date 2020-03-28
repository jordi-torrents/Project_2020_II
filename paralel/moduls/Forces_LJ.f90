module Forces_LJ
  use def_variables
  use pbc
  use mpi_vars

! Defining useful variables for next subroutines
  real(8) :: r2, dxyz(3)
  integer :: i, j, counter

contains
  subroutine ForcesLJ()
    forces = 0.d0
    do i=first_pair,last_pair
        dxyz = (/pbc_dist(pos(pair_indx(i,1),1)-pos(pair_indx(i,2),1)),&
                &pbc_dist(pos(pair_indx(i,1),2)-pos(pair_indx(i,2),2)),&
                &pbc_dist(pos(pair_indx(i,1),3)-pos(pair_indx(i,2),3))/)
        r2 = sum(dxyz**2)
        if (r2 < cutoff2) then
          pair_forces(i,:) = (48.d0/r2**7-24.d0/r2**4)*dxyz ! L-J force
        else
          pair_forces(i,:) = 0
        endif
    end do
    do i=1,3
    call MPI_GATHERV(pair_forces(first_pair:last_pair,i),(last_pair-first_pair+1),MPI_DOUBLE_PRECISION, &
                 pair_forces(:,i),sizes_pair,displs_pair,MPI_DOUBLE_PRECISION, master,MPI_COMM_WORLD,ierror)
    end do
    if (workerid==master) then
      counter=0
      forces(:,:)=0.d0
      do i=1,Npart
        do j=i+1,Npart
           counter = counter + 1
           forces(i,:) = forces(i,:) + pair_forces(counter,:)
           forces(j,:) = forces(j,:) - pair_forces(counter,:)
        end do
      end do
    endif
  do i=1,3
  call MPI_SCATTERV(forces(:,i), sizes_part, displs_part, MPI_DOUBLE_PRECISION,&
                    forces(first_part:last_part,i),(last_part-first_part+1),   &
                    MPI_DOUBLE_PRECISION, master, MPI_COMM_WORLD,ierror)
  enddo

  end subroutine

  subroutine pressure_e_pot()
    ! calculates potential energy and pressure
    if (workerid==master) then
    suma=0.d0
    e_pot=0.d0
    do i=1, Npart-1 ! loop over pairs
      do j=i+1, Npart

        dxyz = (/pbc_dist(pos(i,1)-pos(j,1)),&
                &pbc_dist(pos(i,2)-pos(j,2)),&
                &pbc_dist(pos(i,3)-pos(j,3))/)
        r2 = sum(dxyz**2)

        if (r2 < cutoff2) then
          ff = 48.d0/r2**7 - 24.d0/r2**4
          suma  = suma  + ff*r2 ! sum to calculate pressure
          e_pot = e_pot + 4.d0/r2**6 - 4.d0/r2**3 ! L-J potential
        end if
      end do
    end do

    pressure = dens*temp + suma/(3.d0*L**3)
    endif
   end subroutine pressure_e_pot

end module Forces_LJ
