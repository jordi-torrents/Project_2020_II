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

subroutine initialize_vel_normal(vel,N, T, seed)

implicit none
real*8,dimension(N,3)   ::     vel
integer         ::      N , indx, seed, iter_needed, d
real*8          ::      pi, T, sigma, rand1, rand2

pi = acos(-1.)
sigma = T**0.5
iter_needed = N/2
do d= 1, 3, 1
       indx = 0 
        do i=1, iter_needed, 1
                rand1 = rand()
                rand2 = rand()
                indx = indx + 1
                vel(indx,d) = sigma*sqrt(-2*log(rand1))*cos(2*pi*rand2)
                indx = indx +1
                vel(indx,d) = sigma*sqrt(-2*log(rand1))*sin(2*pi*rand2)
         enddo
enddo

end subroutine initialize_vel_normal

end module
