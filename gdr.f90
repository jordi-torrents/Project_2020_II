module gdr_funcs
  use def_variables
contains
  subroutine gdr_step()
    integer :: i, j
    real(8)     ::      dist
    real(8),dimension(3)     ::  diff    

    do i=1,Npart
      do j=i+1,Npart
        diff = pos(i,:)-pos(j,:)
        dist = dsqrt(sum(diff**2))
        index = int(dist/dx) + 1
        gdr(index) = gdr(index) + 1
      end do
    end do

  end subroutine

  subroutine gdr_final()
    real(8) :: pi, dr
    real(8), dimension(Ngdr) :: volume
    integer :: i

    pi = dacos(-1.d0)
    dr = (L/2.d0)/Ngdr
    do i=1,Ngdr
      volume(i)= (4.d0/3.d0)*pi*(dble(i)*dr)**3-(4.d0/3.d0)*pi*(dble(i-1)*dr)**3
    enddo
    gdr = gdr/sum(gdr)
    gdr = gdr/volume

    open(un_gdr, file='gdr.dat')
    do i=1,Ngdr
      write(un_gdr, *) (dble(i)-0.5d0)*dr , gdr(i)
    end do
    close(un_gdr)
  end subroutine

end module gdr_funcs
