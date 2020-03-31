module mpi_vars
  include 'mpif.h'

  integer              :: ierror, workerid, numproc
  integer,parameter    :: master=0
  integer              :: mida, N
  integer              :: first_part, last_part
  integer, allocatable :: sizes_part(:), displs_part(:)

  contains

  subroutine init_mpi(Npart)
  integer  :: Npart, chunksize, remainder, counter, i

  !! Definition of particles partition
  allocate(sizes_part(numproc))
  allocate(displs_part(numproc))

  chunksize = Npart/numproc
  remainder = mod(Npart,numproc)

  if (workerid<remainder) then
    first_part = workerid*(chunksize+1)+1
    last_part = first_part + chunksize
  else
    first_part = workerid*chunksize+remainder+1
    last_part = first_part + chunksize -1
  endif

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

  end subroutine init_mpi

end module mpi_vars
