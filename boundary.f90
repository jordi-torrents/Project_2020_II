module boundary_conditions


contains

subroutine pbc(vec,L_box)

real,intent(in)::L_box
real, dimension(:,:),intent(inout) ::vec

do i=1,size(vec)
	do j=1,3
		if (vec(i,j)>L_box*0.5) then
			vec(i,j)=vec(i,j)-L_box
		end if
		if (vec(i,j)<-L_box*0.5) then
			vec(i,j)=vec(i,j)+L_box	
		end if
	end do
end do

end subroutine pbc 

end module boundary_conditions
