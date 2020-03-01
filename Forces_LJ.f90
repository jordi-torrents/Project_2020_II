module Forces_LJ
  use def_variables
  use pbc

contains
  subroutine ForcesLJ()
    real(8)          ::      r, r2, dx, dy, dz
    real(8)          ::      ff
    integer         ::      i, j

    forces = 0.d0

    do i=1, Npart
      do j=i+1, Npart
        r2=0.d0

        dx = pbc_dist(pos(i,1)-pos(j,1))
        dy = pbc_dist(pos(i,2)-pos(j,2))
        dz = pbc_dist(pos(i,3)-pos(j,3))

        r2 = dx*dx + dy*dy + dz*dz
        r = dsqrt(r2)

        if (r < cutoff) then
          ff = (48.d0/r2**7-24.d0/r2**4)

          forces(i,1)=forces(i,1) + ff*dx
          forces(i,2)=forces(i,2) + ff*dy
          forces(i,3)=forces(i,3) + ff*dz

          forces(j,1)=forces(j,1) - ff*dx
          forces(j,2)=forces(j,2) - ff*dy
          forces(j,3)=forces(j,3) - ff*dz
        end if
      end do
    end do

  end subroutine

  subroutine pressure_e_pot()
    real(8)          ::      r, r2, dx, dy, dz
    real(8)          ::      ff, suma
    integer         ::      i, j

    suma=0.d0
    e_pot=0.d0
    do i=1, Npart
      do j=i+1, Npart
        r2=0.d0

        dx = pbc_dist(pos(i,1)-pos(j,1))
        dy = pbc_dist(pos(i,2)-pos(j,2))
        dz = pbc_dist(pos(i,3)-pos(j,3))

        r2 = dx*dx + dy*dy + dz*dz
        r = dsqrt(r2)

        if (r < cutoff) then
          ff = (48.d0/r2**7-24.d0/r2**4)
          suma = suma + (ff*dx*dx + ff*dy*dy + ff*dz*dz)
          e_pot = e_pot + 4.d0*((1.d0/r2)**6-(1.d0/r2)**3)
        end if
      end do
    end do

    pressure = dens*temp + suma/(3.d0*L*L*L)
   end subroutine pressure_e_pot

end module Forces_LJ
