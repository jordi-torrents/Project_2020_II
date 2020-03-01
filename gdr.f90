module gdr_funcs
  use def_variables
  use pbc
contains
  subroutine gdr_step()
    integer :: i, j, indx
    real(8)     ::      dist, dr, dx, dy, dz
<<<<<<< HEAD
    dr = (dsqrt(3.d0)*L/2.d0)/dble(Ngdr)
=======
    dr = (L/2.d0)/dble(Ngdr)
>>>>>>> a2fcbd821a2fab69105477d1b4b83dac6f5da6be
    do i=1,Npart
      do j=i+1,Npart
        dx = pbc_dist(pos(i,1)-pos(j,1))
        dy = pbc_dist(pos(i,2)-pos(j,2))
        dz = pbc_dist(pos(i,3)-pos(j,3))
        dist = dsqrt(dx*dx+dy*dy+dz*dz)
        indx = int(dist/dr) + 1
<<<<<<< HEAD
        gdr(indx) = gdr(indx) + 1
=======
        if (indx<Ngdr+1) then
          gdr(indx) = gdr(indx) + 1
        end if
>>>>>>> a2fcbd821a2fab69105477d1b4b83dac6f5da6be
      end do
    end do

  end subroutine

  subroutine gdr_final()
    real(8) :: pi, dr
    real(8), dimension(Ngdr) :: volume
    integer :: i

    pi = dacos(-1.d0)
<<<<<<< HEAD
    dr = (dsqrt(3.d0)*L/2.d0)/dble(Ngdr)
    do i=1,Ngdr
      volume(i)= (4.d0/3.d0)*pi*(dble(i)*dr)**3-(4.d0/3.d0)*pi*(dble(i-1)*dr)**3
    enddo
    gdr = gdr*(dble(Npart)/(volume*dens*sum(gdr)))
=======
    dr = (L/2.d0)/dble(Ngdr)
    do i=1,Ngdr
      volume(i)= (4.d0/3.d0)*pi*(dble(i)*dr)**3-(4.d0/3.d0)*pi*(dble(i-1)*dr)**3
    enddo
    gdr = gdr*(2.d0/(volume*dens*Npart*(1+int(Nsteps/Nprint))))
>>>>>>> a2fcbd821a2fab69105477d1b4b83dac6f5da6be

    open(un_gdr, file='gdr.log')
    do i=1,Ngdr
      write(un_gdr, *) (dble(i)-0.5d0)*dr , gdr(i)
    end do
    close(un_gdr)
  end subroutine

end module gdr_funcs
