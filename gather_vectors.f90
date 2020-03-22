program vectors

implicit none
include 'mpif.h'

integer                ::   ierror, workerid, numproc
real(8),dimension(23)  ::   Va, Vb, Vc, V_pivot
integer                ::   i, master
!integer                ::   stat(MPI_STATUS_SIZE)
real(8)                ::   prova_recv

call MPI_INIT(ierror)
call MPI_COMM_RANK(MPI_COMM_WORLD,workerid,ierror)
call MPI_COMM_SIZE(MPI_COMM_WORLD,numproc,ierror)

master = 0

Va(:)=1.d0
do i=1,size(Vb)
    Vb(i)=dble(i)
enddo

do i=workerid+1,size(Vc),numproc
    Vc(i)= Va(i) + Vb(i)

!call MPI_BARRIER(MPI_COMM_WORLD,ierror)

!if (workerid /= master) then
call MPI_GATHER(Vc(i:size(Vc):numproc),size(Vc(i:size(Vc):numproc)),MPI_DOUBLE_PRECISION, &
                V_pivot(i:size(V_pivot):numproc),size(V_pivot(i:size(V_pivot):numproc)), &
                MPI_DOUBLE_PRECISION, master,MPI_COMM_WORLD,ierror)
enddo
!endif

!call MPI_GATHER(Vc(workerid+1:size(Vc):numproc),size(Vc(workerid+1:size(Vc):numproc)),MPI_DOUBLE_PRECISION, &
!                V_pivot(workerid+1:size(V_pivot):numproc),size(V_pivot(workerid+1:size(V_pivot):numproc)), &
!                MPI_DOUBLE_PRECISION, master,MPI_COMM_WORLD,ierror)

!call MPI_GATHER(Vc,size(Vc),MPI_DOUBLE_PRECISION,V_pivot,size(V_pivot), &
!                MPI_DOUBLE_PRECISION, master,MPI_COMM_WORLD,ierror)
if (workerid==master) then
   Vc(:) = V_pivot(:)
   print*,'Vc master:',Vc(:)
   print*,'V_pivot master:',V_pivot(:)
   print*, 'ierror',ierror
endif
print*, 'ierror',ierror
call MPI_FINALIZE(ierror)

end program vectors
