module init
  use def_variables
  use Forces_LJ

  contains

  subroutine initialize()
    integer :: side, i, j, k, count, size_seed
    real(8) :: dx, pi2, U1, U2, U3, U4
    integer, allocatable        ::      seed_array(:)
    
    time = 0.d0
    pi2 = 2.d0*acos(-1.d0)
    count=0
    side = int(dble(Npart)**(1.d0/3.d0))+1
    dx=L/dble(side)
    call random_seed(size=size_seed)
    allocate(seed_array(size_seed))
    seed_array(:) = seed
    call random_seed(put=seed_array)
    do i = 1, side
      do j = 1, side
        do k = 1, side
          if (count < Npart) then
            count = count+1
            pos(count, :) = dble((/i, j, k/)) * dx
            call random_number(U1)
            call random_number(U2)
            call random_number(U3)
            call random_number(U4)
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
    call ForcesLJ()
  end subroutine

end module
