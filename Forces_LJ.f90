module Forces_LJ
IMPLICIT NONE
use def_variables

contains 
        subroutine ForcesLJ()
        
        IMPLICIT NONE
        real(8)          ::      r, r2, dx, dy, dz
        real(8)          ::      ff, suma, potential
        integer         ::      i, j

                forces = 0.d0
                potential = 0.d0

                do i=1, N
                        do j=i+1, N
                               r2=0.d0

                               dx = pos(i,1)-pos(j,1)
                               dx = pbc(dx,L)
                               dy = pos(i,2)-pos(j,2)
                               dy = pbc(dy,L)
                               dz = pos(i,3)-pos(j,3)
                               dz = pbc(dz,L)

                               r2 = r2 +dx**2
                               r2 = r2 +dy**2
                               r2 = r2 +dz**2
                               r = r2**0.5d0

                               if (r < cutoff) then
                                       ff = (48/r**14-24/r**8)

                                       forces(i,1)=forces(i,1) + ff*dx
                                       forces(i,2)=forces(i,2) + ff*dy
                                       forces(i,3)=forces(i,3) + ff*dz

                                       forces(j,1)=forces(j,1) + ff*dx
                                       forces(j,2)=forces(j,2) + ff*dy
                                       forces(j,3)=forces(j,3) + ff*dz

                                       suma = suma + (ff*dx**2 + ff*dy**2 + ff*dz**2)

                                       potential = potential + 4*((1./r)**12-(1./r)**6)
                               end if
                        end do
                end do

        pressure = density*T + suma/(3*L**3)

        end subroutine                                              
                              
end module Forces_LJ

