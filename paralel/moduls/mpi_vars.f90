module mpi_vars

include 'mpif.h'

integer               :: ierror, workerid, numproc
integer,parameter     :: master=0
integer               :: mida, N
integer               :: first_part, last_part
integer , allocatable :: sizes_part(:), displs_part(:)
integer               :: first_pair, last_pair
integer , allocatable :: sizes_pair(:), displs_pair(:)
integer , allocatable :: pair_indx(:,:)
real(8) , allocatable :: pair_forces(:,:)

contains

subroutine init_mpi(Npart)

integer               :: Npart, Npairs
integer               :: chunksize, remainder, counter
integer               :: i, j
Npairs = ((Npart -1)*Npart)/2

!! Definition of particles partition

chunksize = Npart/numproc
remainder = mod(Npart,numproc)

if (workerid<remainder) then
  first_part = workerid*(chunksize+1)+1
  last_part = first_part + chunksize
else
  first_part = workerid*chunksize+remainder+1
  last_part = first_part + chunksize -1
endif

if (workerid==master) then
   allocate(sizes_part(numproc))
   allocate(displs_part(numproc))

  counter=0
  do i=1,numproc
     displs_part(i) = counter
     if ((i-1)<remainder) then
       sizes_part(i)= chunksize+1
     else
       sizes_part(i)= chunksize
     end if
     counter = counter + sizes_part(i)
   end do
endif

!! Definition of particles pair

chunksize = Npairs/numproc
remainder = mod(Npairs, numproc)

if (workerid<remainder) then
   first_pair = workerid*(chunksize+1)+1
   last_pair= first_pair + chunksize
 else
   first_pair = workerid*chunksize+remainder+1
   last_pair= first_pair + chunksize-1
end if

allocate(pair_indx(Npairs,2))
allocate(pair_forces(Npairs,3))
counter=0
do i=1,Npart
   do j=i+1,Npart
       counter = counter + 1
       pair_indx(counter,:) = (/i, j/)
   end do
end do
if (workerid==master) then
   allocate(sizes_pair(numproc))
   allocate(displs_pair(numproc))

   counter=0
   do i=1,numproc
     displs_pair(i) = counter
     if ((i-1)<remainder) then
       sizes_pair(i)= chunksize+1
     else
       sizes_pair(i)= chunksize
     end if
     counter = counter + sizes_pair(i)
   end do
end if

print*,'Workerid / first-last particle', workerid,'/', first_part,'-',last_part
print*,'Workerid / first-last pair', workerid,'/', first_pair,'-',last_pair
end subroutine init_mpi

end module mpi_vars
