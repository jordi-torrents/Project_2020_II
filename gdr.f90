module gdr
  use def_variables
contains
  subroutine gdr_step()
    integer :: i, j

    do i=1,Npart
      do j=i+1,Npart
        diff = pos(i,:)-pos(j,:)
        dist = dsqrt(sum(pos**2))
        index = int(dist/dx) + 1
        gdr(index) = gdr(index) + 1
      end do
    end do

  end subroutine

  subroutine gdr_final()
    real(8) :: pi, dr
    real(8), dimension(Ngdr) :: radii, volume
    integer :: i

    pi = dacos(-1.d0)
    dr = (L/2.d0)/Ngdr
    do i=1,Ngdr
      volume(i)= (4.d0/3.d0)*pi*(dble(i)*dr)**3-(4.d0/3.d0)*pi*(dble(i-1)*dr)**3

    gdr = gdr/sum(gdr)
    gdr = gdr/volume
  end subroutine

end module
