module gdr_funcs
  use def_variables
  use pbc
  use mpi_vars

contains
  ! single cumulative step of g(r)
  subroutine gdr_step()
    integer :: i, j, indx
    real(8) :: r, dr, dxyz(3)

    dr=(4.d0)/dble(Ngdr) ! size of one gdr bin

    do i=first_part,last_part
      do j=1,Npart ! loop over all pairs
        dxyz = (/pbc_dist(pos(i,1)-pos(j,1)),&
                &pbc_dist(pos(i,2)-pos(j,2)),&
                &pbc_dist(pos(i,3)-pos(j,3))/)
        r = dsqrt(sum(dxyz**2))
        indx = int(r/dr) + 1
      ! if distance is lower than L/2, put it in the gdr histogram
        if (indx<Ngdr+1) then
          gdr_int(indx) = gdr_int(indx) + 1
        end if
      end do
    end do

  end subroutine
! final calculation and normalizations of g(r)
  subroutine gdr_final()
    real(8) :: dr, volume(Ngdr)
    integer :: i

    dr=(4.d0)/dble(Ngdr) ! size of one gdr bin
    ! sum of all worker's g(r)
    call MPI_REDUCE(gdr_int,gdr_int,Ngdr,MPI_INTEGER,MPI_SUM,master,MPI_COMM_WORLD,ierror)
    if (workerid==master) then
      gdr_int(1)=0 ! eliminate distance of particles with themselves
      gdr(:) = dble(gdr_int(:))
! computing volum of each bin
      do i=1,Ngdr
        volume(i)= (4.d0/3.d0)*pi*(  dble(i)*dr)**3-&
                  &(4.d0/3.d0)*pi*(dble(i-1)*dr)**3
      enddo

! normalizing gdr
      gdr = gdr/(volume*dens*Npart*(1+int(Nsteps/Nprint)))

! writing gdr
      open(un_gdr, file='output/gdr.log')
      do i=1,Ngdr
        write(un_gdr, *) sigmaLJ*(dble(i)-0.5d0)*dr , gdr(i)
      end do
      close(un_gdr)
    endif
  end subroutine

end module gdr_funcs
