module pbc
use def_variables
use mpi_vars

contains

function pbc_dist(x)
 real(8) :: pbc_dist, x
 pbc_dist = x - int(2.d0*x/L)*L
end function pbc_dist

subroutine pbc_pos()
  integer :: i, j

  do i=1,Npart
    do j=1,3
      pos(i,j) = pos(i,j) - int(2.d0*pos(i,j)/L)*L
    end do
  end do

end subroutine pbc_pos

end module pbc
