module Forces_LJ
  use def_variables

contains
  subroutine ForcesLJ()
    real(8)          ::      r, r2, dx, dy, dz
    real(8)          ::      ff
    integer         ::      i, j

    forces = 0.d0

    do i=1, Npart
      do j=i+1, Npart
        r2=0.d0

        dx = pbc_dist(pos(i,1)-pos(j,1),L)
        dy = pbc_dist(pos(i,2)-pos(j,2))
        dz = pbc_dist(pos(i,3)-pos(j,3))

        r2 = dx**2 + dy**2 + dz**2
        r = r2**0.5d0

        if (r < cutoff) then
          ff = (48.d0/r**14-24.d0/r**8)

          forces(i,1)=forces(i,1) + ff*dx
          forces(i,2)=forces(i,2) + ff*dy
          forces(i,3)=forces(i,3) + ff*dz

          forces(j,1)=forces(j,1) + ff*dx
          forces(j,2)=forces(j,2) + ff*dy
          forces(j,3)=forces(j,3) + ff*dz
        end if
      end do
    end do

  end subroutine
  Function pressure_fun()
    real(8)          ::      r, r2, dx, dy, dz
    real(8)          ::      ff, suma,pressure_fun
    integer         ::      i, j

    forces = 0.d0

    do i=1, Npart
      do j=i+1, Npart
        r2=0.d0

        dx = pbc_dist(pos(i,1)-pos(j,1))
        dy = pbc_dist(pos(i,2)-pos(j,2))
        dz = pbc_dist(pos(i,3)-pos(j,3))

        r2 = dx**2 + dy**2 + dz**2
        r = r2**0.5d0

        if (r < cutoff) then
          ff = (48.d0/r**14-24.d0/r**8)
          suma = suma + (ff*dx**2 + ff*dy**2 + ff*dz**2)
        end if
      end do
    end do

    pressure_fun = dens*temp + suma/(3*L**3)
   end function pressure_fun
   function e_pot()
    real(8)          ::      r, r2, 
    real(8)          ::      e_pot
    integer         ::      i, j

    potential = 0.d0

    do i=1, Npart
      do j=i+1, Npart
        r2=0.d0
        r2 = dx**2 + dy**2 + dz**2
        r = r2**0.5d0

        if (r < cutoff) then
          e_pot = e_pot + 4.d0*((1.d0/r)**12-(1.d0/r)**6)
        end if
      end do
    end do
   end function e_pot

end module Forces_LJ
