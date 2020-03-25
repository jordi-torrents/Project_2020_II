program vectors

implicit none
include 'mpif.h'

integer                ::   ierror, workerid, numproc
real(8)                ::   pos(5,3), Vc, forces(5,3)
real(8), allocatable   ::   pair_forces(:,:)
integer                ::   i, j, master, mida, N, N_pairs
integer                ::   start, finish, counter, chunksize, remainder
integer, allocatable   ::   sizes(:), displs(:), pair_indx(:,:)

call MPI_INIT(ierror)
call MPI_COMM_RANK(MPI_COMM_WORLD,workerid,ierror)
call MPI_COMM_SIZE(MPI_COMM_WORLD,numproc,ierror)

master = 0
N=size(pos(:,1))
N_pairs = (N*N-N)/2

chunksize = N_pairs/numproc
remainder = mod(N_pairs, numproc)

if (workerid<remainder) then
   start = workerid*(chunksize+1)+1
   finish= start + chunksize
 else
   start = workerid*chunksize+remainder+1
   finish= start + chunksize-1
end if
print*, 'worker',workerid,'start',start,'finish',finish

allocate(  pair_indx(N_pairs,2))
allocate(pair_forces(N_pairs,3))

counter=0
do i=1,N
   do j=i+1,N
       counter = counter + 1
       pair_indx(counter,:) = (/i, j/)
   end do
end do


if (workerid==master) then
   do i=1,N
      pos(i,:)=dble(i)
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
end if

call MPI_BCAST(pos, (N*3), MPI_DOUBLE_PRECISION, master, MPI_COMM_WORLD, IERROR)

do i=start,finish
    pair_forces(i,:)=(/pos(pair_indx(i,1),1) + pos(pair_indx(i,2),1),&
                       pos(pair_indx(i,1),2) - pos(pair_indx(i,2),2),&
                       pos(pair_indx(i,1),3) * pos(pair_indx(i,2),3)/)
end do

do i=1,3
call MPI_GATHERV(pair_forces(start:finish,i),(finish-start+1),MPI_DOUBLE_PRECISION, &
                 pair_forces(:,i),sizes,displs,MPI_DOUBLE_PRECISION, master,MPI_COMM_WORLD,ierror)
end do

if (workerid==master) then
   print*, 'Pair forces master'
   counter=0
   forces(:,:)=0.d0
   do i=1,N
      do j=i+1,N
         counter = counter + 1
         forces(i,:) = forces(i,:) + pair_forces(counter,:)
         forces(j,:) = forces(j,:) - pair_forces(counter,:)
      end do
   end do

   do i=1,N_pairs
      print*,pair_indx(i,:), pair_forces(i,:)
   end do
   print*, 'Forces master'
   do i=1,N
      print*, forces(i,:)
   end do
endif
call MPI_FINALIZE(ierror)
end program vectors
