module init
  use def_variables

  contains

  subroutine initialize()
    integer :: side, i, j, k, count
    real(8) :: dx, pi2, U1, U2, U3, U4

    pi2 = 2.d0*acos(-1.d0)
    count=0
    side = int(dble(Npart)**(1.d0/3.d0))+1
    dx=L/dble(side)
    do i = 1, side
      do j = 1, side
        do k = 1, side
          if (count < Npart) then
            count = count+1
            pos(count, :) = dble((/i, j, k/)) * dx
            ! U1 = r1279()
            ! U2 = r1279()
            ! U3 = r1279()
            ! U4 = r1279()
            U1 = 0.1d0
            U2 = 0.1d0
            U3 = 0.1d0
            U4 = 0.1d0
            vel(count,1)=dsqrt(-2.d0*temp*dlog(U1))*dcos(pi2*U2)
            vel(count,2)=dsqrt(-2.d0*temp*dlog(U1))*dsin(pi2*U2)
            vel(count,3)=dsqrt(-2.d0*temp*dlog(U3))*dcos(pi2*U4)
          end if
        end do
      end do
    end do

    vel(:,1) = vel(:,1) - sum(vel(:,1))/dble(Npart)
    vel(:,2) = vel(:,2) - sum(vel(:,2))/dble(Npart)
    vel(:,3) = vel(:,3) - sum(vel(:,3))/dble(Npart)
    pos = pos - L/2.d0
  end subroutine

end module
