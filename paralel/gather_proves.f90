program vectors

implicit none
include 'mpif.h'

integer                ::   ierror, workerid, numproc
real(8),dimension(23)  ::   Va, Vb, Vc
integer                ::   i, indx, mida
integer,parameter      ::   master=0
real(8),allocatable,dimension(:,:)  :: V_p
!integer                ::   stat(MPI_STATUS_SIZE)

call MPI_INIT(ierror)
call MPI_COMM_RANK(MPI_COMM_WORLD,workerid,ierror)
call MPI_COMM_SIZE(MPI_COMM_WORLD,numproc,ierror)

allocate(V_p(23,numproc))
Va(:)=1.d0
do i=1,size(Vb)
    Vb(i)=dble(i)
enddo

do i=workerid+1,size(Vc),numproc
    Vc(i)= Va(i) + Vb(i)

!call MPI_BARRIER(MPI_COMM_WORLD,ierror)

!if (workerid /= master) then
enddo
!endif

V_p(:,:)=-1.d0

indx = workerid+1

mida = size(Vc(indx:size(Vc):numproc))
!call MPI_GATHER(Vc(workerid+1:size(Vc):numproc),size(Vc(workerid+1:size(Vc):numproc)),MPI_DOUBLE_PRECISION, &
!                V_p(indx:size(V_p):indx),size(V_p(indx:size(V_p):indx)),MPI_DOUBLE_PRECISION, &
!                master,MPI_COMM_WORLD,ierror)
call MPI_GATHER(Vc(indx:size(Vc):numproc),mida,MPI_DOUBLE_PRECISION, &
                V_p(3:mida+2,2),mida,MPI_DOUBLE_PRECISION, &
                master,MPI_COMM_WORLD,ierror)

!call MPI_GATHER(Vc,size(Vc),MPI_DOUBLE_PRECISION,V_p,size(V_p), &
!                MPI_DOUBLE_PRECISION, master,MPI_COMM_WORLD,ierror)
if (workerid==master) then
   !Vc(:) = V_p(:)
   !print*,'Vc master:',Vc(:)
   print*,''
   do i=1,numproc
   print*,'V pivot i:',i,V_p(:,i)
   print*,''
   enddo
   print*, 'ierror',ierror
endif
print*, 'ierror',ierror
call MPI_FINALIZE(ierror)

end program vectors
