module FF90
IMPLICIT NONE
contains 

        subroutine ForcesLJ(pos,N,L,cutoff,forces,potential,T,density)
        
        IMPLICIT NONE
        real*8          ::      r, r2, potential, cutoff, dx, dy, dz, L
        real*8          ::      ff, pressure, T, density, suma
        integer         ::      i, j, N
        real*8, dimension(N,3)          ::      pos, forces

                forces(:,:) = 0
                potential = 0.0

                do i=1, N, 1
                        do j=i+1, N, 1
                               r2=0

                               dx = pos(i,1)-pos(j,1)
                               dx = pbc(dx,L)
                               dy = pos(i,2)-pos(j,2)
                               dy = pbc(dy,L)
                               dz = pos(i,3)-pos(j,3)
                               dz = pbc(dz,L)

                               r2 = r2 +dx**2
                               r2 = r2 +dy**2
                               r2 = r2 +dz**2
                               r = r2**0.5

                               if (r < cutoff) then
                                       ff = (48/r**14-24/r**8)

                                       forces(i,1)=forces(i,1) + ff*dx
                                       forces(i,2)=forces(i,2) + ff*dy
                                       forces(i,3)=forces(i,3) + ff*dz

                                       forces(i,1)=forces(i,1) + ff*dx
                                       forces(i,2)=forces(i,2) + ff*dy
                                       forces(i,3)=forces(i,3) + ff*dz

                                       suma = suma + (ff*dx**2 + ff*dy**2 + ff*dz**2)

                                       potential = potential + 4*((1./r)**12-(1./r)**6)
                               end if
                        end do
                end do

        pressure = density*T + suma/(3*L**3)

        end subroutine                                              
                              
end module FF90

