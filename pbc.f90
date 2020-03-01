module pbc
use def_variables

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

! subroutine pbc(vec,L_box)
!
! real(8),intent(in)::L_box
! real(8), dimension(:,:),intent(inout) ::vec
!
! do i=1,size(vec)
! 	do j=1,3
! 		if (vec(i,j)>L_box*0.5d0) then
! 			vec(i,j)=vec(i,j)-L_box
! 		end if
! 		if (vec(i,j)<-L_box*0.5d0) then
! 			vec(i,j)=vec(i,j)+L_box
! 		end if
! 	end do
! end do
!
! end subroutine pbc

end module pbc
