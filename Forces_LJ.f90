module Forces_LJ
  use def_variables
  use pbc

! Defining useful variables for next subroutines
  real(8) :: r2, dxyz(3), ff, suma
  integer :: i, j

contains
  subroutine ForcesLJ()
    forces = 0.d0

    do i=1, Npart-1 ! looping over all pairs
      do j=i+1, Npart

        ! defining usefull diference array
        dxyz = (/pbc_dist(pos(i,1)-pos(j,1)),&
                &pbc_dist(pos(i,2)-pos(j,2)),&
                &pbc_dist(pos(i,3)-pos(j,3))/)
        r2 = sum(dxyz**2)

        if (r2 < cutoff2) then
          ff = (48.d0/r2**7-24.d0/r2**4) ! L-J force

          ! forces_matrix(i,j,:) = ff*dxyz
          ! forces_matrix(j,i,:) =-ff*dxyz

          forces(i,:)=forces(i,:) + ff*dxyz
          forces(j,:)=forces(j,:) - ff*dxyz
        end if
      end do
    end do

    ! forces = sum(force_matrix, dim=2)

  end subroutine

  subroutine pressure_e_pot()
    ! calculates potential energy and pressure

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
   end subroutine pressure_e_pot

end module Forces_LJ
