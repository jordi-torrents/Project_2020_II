module gdr_funcs
  use def_variables
  use pbc
  use mpi_vars

contains
  subroutine gdr_step()
    integer :: i, j, indx
    real(8) :: r, dr, dxyz(3)

    if (workerid==master) then
    dr=(L/2.d0)/dble(Ngdr) ! size of gdr bin

    do i=1,Npart-1 ! loop over all pairs
      do j=i+1,Npart
        dxyz = (/pbc_dist(pos(i,1)-pos(j,1)),&
                &pbc_dist(pos(i,2)-pos(j,2)),&
                &pbc_dist(pos(i,3)-pos(j,3))/)
        r = sqrt(sum(dxyz**2))
        indx = int(r/dr) + 1
      ! if distance is lower than L/2, put it in the histogram
        if (indx<Ngdr+1) then
          gdr(indx) = gdr(indx) + 1.d0
        end if
      end do
    end do
    endif

  end subroutine

  subroutine gdr_final()
    real(8) :: dr, volume(Ngdr)
    integer :: i
    
    if (workerid==master) then 
    dr=(L/2.d0)/dble(Ngdr)

! computing volum of every bin
    do i=1,Ngdr
      volume(i)= (4.d0/3.d0)*pi*(  dble(i)*dr)**3-&
                &(4.d0/3.d0)*pi*(dble(i-1)*dr)**3
    enddo

! normalizing gdr
    gdr = gdr*(2.d0/(volume*dens*Npart*(1+int(Nsteps/Nprint))))

! writing gdr
    open(un_gdr, file='output/gdr.log')
    do i=1,Ngdr
      write(un_gdr, *) sigmaLJ*(dble(i)-0.5d0)*dr , gdr(i)
    end do
    close(un_gdr)
    endif
  end subroutine

end module gdr_funcs
