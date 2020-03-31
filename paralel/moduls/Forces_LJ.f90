module Forces_LJ
  use def_variables
  use pbc
  use mpi_vars

! Defining useful variables for next subroutines
  real(8) :: r2, dxyz(3)
  integer :: i, j, counter

contains
  subroutine ForcesLJ()

    forces(first_part:last_part,:) = 0.d0
    do i=first_part,last_part
       do j=1,i-1
        dxyz = (/pbc_dist(pos(i,1)-pos(j,1)),&
                &pbc_dist(pos(i,2)-pos(j,2)),&
                &pbc_dist(pos(i,3)-pos(j,3))/)
        r2 = sum(dxyz**2)
        if (r2 < cutoff2) then
          forces(i,:) = forces(i,:) + (48.d0/r2**7-24.d0/r2**4)*dxyz ! L-J force
        endif
       end do
       do j=i+1,Npart
        dxyz = (/pbc_dist(pos(i,1)-pos(j,1)),&
                &pbc_dist(pos(i,2)-pos(j,2)),&
                &pbc_dist(pos(i,3)-pos(j,3))/)
        r2 = sum(dxyz**2)
        if (r2 < cutoff2) then
          forces(i,:) = forces(i,:) + (48.d0/r2**7-24.d0/r2**4)*dxyz ! L-J force
        endif
       end do
    end do

  end subroutine

  subroutine pressure_e_pot()
    ! calculates potential energy and pressure
    suma=0.d0
    e_pot=0.d0
    do i=first_part, last_part ! loop over pairs
      do j=1, i-1

        dxyz = (/pbc_dist(pos(i,1)-pos(j,1)),&
                &pbc_dist(pos(i,2)-pos(j,2)),&
                &pbc_dist(pos(i,3)-pos(j,3))/)
        r2 = sum(dxyz**2)

        if (r2 < cutoff2) then
          suma  = suma  + (48.d0/r2**6 - 24.d0/r2**3) ! sum to calculate pressure
          e_pot = e_pot + 4.d0/r2**6 - 4.d0/r2**3  - e_cut! L-J potential
        end if
      end do
      do j=i+1, Npart

        dxyz = (/pbc_dist(pos(i,1)-pos(j,1)),&
                &pbc_dist(pos(i,2)-pos(j,2)),&
                &pbc_dist(pos(i,3)-pos(j,3))/)
        r2 = sum(dxyz**2)

        if (r2 < cutoff2) then
          suma  = suma  + (48.d0/r2**6 - 24.d0/r2**3) ! sum to calculate pressure
          e_pot = e_pot + 4.d0/r2**6 - 4.d0/r2**3 - e_cut! L-J potential
        end if
      end do
    end do
    call MPI_REDUCE(suma,suma,1,MPI_DOUBLE_PRECISION,MPI_SUM,master,MPI_COMM_WORLD,ierror)  
    call MPI_REDUCE(e_pot,e_pot,1,MPI_DOUBLE_PRECISION,MPI_SUM,master,MPI_COMM_WORLD,ierror)  
    if (workerid==master) then
      suma = suma/2.d0
      e_pot= e_pot/2.d0
      pressure = dens*temp + suma/(3.d0*L**3)
    endif
   end subroutine pressure_e_pot

end module Forces_LJ
