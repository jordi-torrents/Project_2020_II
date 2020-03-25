program vectors

implicit none
include 'mpif.h'

integer                ::   ierror, workerid, numproc
real(8),dimension(23)  ::   Va, Vb, Vc
integer                ::   i, master
integer                ::   stat(MPI_STATUS_SIZE)
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
enddo

!call MPI_BARRIER(MPI_COMM_WORLD,ierror)


if (workerid /= master) then
   call MPI_SEND(Vc(workerid+1:size(Vc):numproc),size(Vc(workerid+1:size(Vc):numproc)),MPI_DOUBLE_PRECISION,master,1,MPI_COMM_WORLD,ierror)
endif

if (workerid == master) then
   do i=1,numproc-1
      call MPI_RECV(Vc(i+1:size(Vc):numproc),size(Vc(i+1:size(Vc):numproc)),MPI_DOUBLE_PRECISION,i,1,MPI_COMM_WORLD,stat,ierror)
   enddo
   print*,'Vc master:',Vc(:)
endif

call MPI_FINALIZE(ierror)

end program vectors
