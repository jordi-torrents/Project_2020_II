program vectors

implicit none
include 'mpif.h'

integer                ::   ierror, workerid, numproc
real(8),dimension(10,3)  ::   Va, Vb, Vc
integer                ::   i, master, mida, N
integer                ::   start, finish, counter, chunksize, remainder
integer, allocatable   ::   sizes(:), displs(:)

call MPI_INIT(ierror)
call MPI_COMM_RANK(MPI_COMM_WORLD,workerid,ierror)
call MPI_COMM_SIZE(MPI_COMM_WORLD,numproc,ierror)

master = 0
N=size(Va(:,1))

chunksize= N/numproc
remainder= mod(N, numproc)
if (workerid<remainder) then
   start = workerid*(chunksize+1)+1
   finish= start + chunksize
 else
   start = workerid*chunksize+remainder+1
   finish= start + chunksize-1
end if
print*, 'worker',workerid,'start',start,'finish',finish

if (workerid==master) then
   do i=1,N
      Va(i,:)=dble(i)
      Vb(i,:)=(/9.,19.,29./)
   end do
   print*, 'Va master'
   do i=1,N
      print*, Va(i,:)
   end do

   print*, 'Vb master'
   do i=1,N
      print*, Vb(i,:)
   end do

   allocate(sizes(numproc))
   allocate(displs(numproc))

   counter=0
   do i=1,numproc 
     displs(i) = counter
     if ((i-1)<remainder) then
       sizes(i)= chunksize+1
     else
       sizes(i)= chunksize
     end if
     counter = counter + sizes(i)
   end do
   print*, 'sizes',sizes
   print*, 'displacement',displs
end if

do i=1,3
  call MPI_SCATTERV(Va(:,i), sizes, displs, MPI_DOUBLE_PRECISION,&
                    Va(start:finish,i),(finish-start+1), MPI_DOUBLE_PRECISION, master, MPI_COMM_WORLD,ierror)
  call MPI_SCATTERV(Vb(:,i), sizes, displs, MPI_DOUBLE_PRECISION,&
                    Vb(start:finish,i),(finish-start+1), MPI_DOUBLE_PRECISION, master, MPI_COMM_WORLD,ierror)
end do

do i=start,finish
    Vc(i,:)= Va(i,:) + Vb(i,:)
end do

do i=1,3
  call MPI_GATHERV(Vc(start:finish,i),(finish-start+1),MPI_DOUBLE_PRECISION, &
                   Vc(:,i),sizes,displs,MPI_DOUBLE_PRECISION, master,MPI_COMM_WORLD,ierror)
end do

if (workerid==master) then
   print*, 'Vc master'
   do i=1,10
      print*,Vc(i,:)
   end do
endif
call MPI_FINALIZE(ierror)
end program vectors
