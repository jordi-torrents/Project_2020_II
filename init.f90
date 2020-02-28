module init
  use def_variables

  contains

  subroutine initialize()
    integer :: side, i, j, k, count
    real(8) :: dx

    count=0
    side = int(dble(Npart)**(1.d0/3.d0))+1
    dx=L/dble(side)
    do i = 1, side
      do j = 1, side
        do k = 1, side
          if (count < Npart) then
            count = count+1
            pos(count, :) = dble((/i, j, k/)) * dx
          end if
        end do
      end do
    end do

    vel=1.d0 ! pendent de fer

  end subroutine

end module
