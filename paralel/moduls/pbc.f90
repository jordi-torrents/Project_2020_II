module pbc
  use def_variables
  use mpi_vars

! functions and subroutines to calculate Periodic Boundary Conditions (PBC)

  contains

  function pbc_dist(x) ! computes PBC of one distance
   real(8) :: pbc_dist, x
   pbc_dist = x - int(2.d0*x/L)*L
  end function pbc_dist

  subroutine pbc_pos() ! computes PBC for all particles position
    integer :: i

    do i=first_part, last_part
      pos(i,:) = pos(i,:) - int(2.d0*pos(i,:)/L)*L
    end do

  end subroutine pbc_pos

end module pbc
