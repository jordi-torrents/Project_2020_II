program vectors

implicit none
include 'mpif.h'

integer                ::   ierror, workerid, numproc
real(8),dimension(23)  ::   Va, Vb, Vc
integer                ::   i, master, mida

call MPI_INIT(ierror)
call MPI_COMM_RANK(MPI_COMM_WORLD,workerid,ierror)
call MPI_COMM_SIZE(MPI_COMM_WORLD,numproc,ierror)

master = 0

Va(:)=1.d0
do i=1,size(Vb)
    Vb(i)=dble(i)
enddo

do i=workerid+1,size(Vc),numproc  ! repartició de feina en índexs saltejats
    Vc(i)= Va(i) + Vb(i)
end do

mida = size(Vc(workerid+1:size(Vc):numproc))
call MPI_GATHER(Vc(workerid+1:size(Vc):numproc),mida,MPI_DOUBLE_PRECISION, &
                Vc(workerid+1:size(Vc):numproc),mida,MPI_DOUBLE_PRECISION, master,MPI_COMM_WORLD,ierror)
! entenem que aquesta forma de fer el GATHER no és correcte

if (workerid==master) then
   print*,'Vc master:',Vc(:)
endif
call MPI_FINALIZE(ierror)
end program vectors
