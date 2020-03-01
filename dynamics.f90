program dinamica

implicit none
real            ::      start, finish
character(30)   ::      fName, hist_init, hist_fin
integer         ::      fStat, uninp=101, unpos=102, undata_red=103
integer         ::      undata_real=104, unhist_init=105, unhist_fin=106
integer         ::      N, M, step, maxsteps, Nprint, i, seed, melt_steps, bins
real*8          ::      L, dens, cutoff, pot, KE, ML, r, dt, time=0.0, sig, eps
real*8          ::      T, nu, T_melt, nu_melt, mass, t0, p, Dcoef
real*8          ::      timec, KEc, potc, t0c, pc, MLc, Dcoefc, densc
real*8          ::      time_f, temp_f, dens_f, p_f, energy_f, NA, kb
real*8,allocatable,dimension(:,:) ::      pos, pos_ini, forces, old_pos, vel
        
call cpu_time(start)
call get_command_argument(1, fName, status=fStat)

if (fStat == 0) then
     open(unit=uninp, file=trim(fName), status='old')
else
     print*, 'Fail at reading input file'
     print*, 'Exitting program'
     call exit()
end if
!! LLEGIM PARÀMETRES D'ENTRADA
call read_input(uninp,dens,N,  maxsteps, dt, Nprint, sig, eps,mass, seed, T,nu,T_melt,nu_melt,melt_steps,bins)
close(uninp)
!! Calculem els factors per a la conversió d'unitats
NA = 6.022137d23 ! part/mol
kb= 0.008314465 ! kJ/mol*K

time_f = 0.1*(sig*dsqrt(mass/eps)) ! PICOSECONDS 
temp_f = kb/eps ! KELVINS
dens_f = (mass/(NA*sig**3))*1d24 ! G/CM**3
p_f = eps/(NA*sig**3)*1d33 ! PASCALS
energy_f = eps ! KJ/MOL
Dcoef_f = sigma**2/time_f

densc = dens*dens_f

!! Calculem paràmetres L, M i cutoff
L = (N/dens)**(1./3)
M=(N/4)**(1./3)
cutoff = 0.5*L
!! Definim vector amb el nombre de partícules
allocate(pos(N,3), forces(N,3), old_pos(N,3), vel(N,3),pos_ini(N,3))
!! Inicialitzem la cel·la
call initialize_fcc(M,L,pos)
!! impimim la configuracio del sistema
open(unit=unpos, file='positions.xyz')
call print_pos(unpos,pos,N)
!! Inicialitzem les velocitats a zero ( de moment)
vel(:,:)=0
call srand(seed)
call initialize_vel_unif(vel,N,T_melt,seed)
! Activem el primer pas
old_pos = pos

open(unit=undata_red, file='data_reduced_units.log')
write(undata_red,*) '# time  ,      kinetic  ,      potential  ,      total_energy &
     ,      T_inst  ,       pressure  ,       momentum,    difusion_coef'
open(unit=undata_real, file='data_real_units.log')
write(undata_real,*) '# time  ,      kinetic  ,      potential  ,      total_energy &
     ,      T_inst  ,       pressure  ,       momentum,    difusion_coef'
call melt_crystall(T_melt,melt_steps,N,L,cutoff,pot,pos,vel,nu_melt,dt,seed)
!call initialize_vel_unif(vel,N,T,seed)
hist_init = 'hist_init.log'
call histogram( vel,N, bins,unhist_init,hist_init )

! Integre, eq. de moviment
do step= 1, maxsteps, 1
        time = time + dt
        call velocity_verlet(pos, N, L, cutoff, pot, vel, dt)
        call andersen(N,vel,seed,nu,T)
        if (mod(step,Nprint)== 0) then
                call print_pos(unpos,pos,N)
                KE = kinetic(vel, N)
                t0 = t_inst(KE,N)
                p = pressure(pos,T,dens,L,N)
                ML = momentum(vel,N)
                Dcoef =  difusion_coef(pos_ini,pos,time,N,L)
                write(undata_red,*) time, KE, pot, KE + pot, t0, p, ML, &
                Dcoef, dens
                timec = time*time_f
                KEc = KE*energy_f
                potc = pot*energy_f
                t0c = t0*temp_f
                pc = p*p_f
                Dcoefc = Dcoef*Dcoef_f
                write(undata_real,*) timec, KEc, potc, KEc + potc, t0c, pc, &
                MLc, Dcoefc, densc
        endif
enddo
hist_fin = 'hist_fin.log'
call histogram( vel,N, bins,unhist_fin,hist_fin )

close(unpos);  close(undata_red); close(undata_real)

call cpu_time(finish)
print*, 'CPU time:',finish-start,'seconds'

contains

!! Subrutine per inicialitzar els posicions del sistema
subroutine read_input(un,dens,N, maxsteps, dt, Nprint, sig, eps,mass, seed, T, nu, T_melt,nu_melt,melt_steps,bins)

implicit none
real*8          :: dens, dt, sig, eps, T, mass, nu, nu_melt, T_melt
integer         :: un, N, maxsteps, Nprint, seed, melt_steps,bins

read(un,*) dens
read(un,*) N
read(un,*) maxsteps
read(un,*) dt
read(un,*) Nprint
read(un,*) sig
read(un,*) eps
read(un,*) mass
read(un,*) seed
read(un,*) T
read(un,*) nu
read(un,*) T_melt
read(un,*) nu_melt
read(un,*) melt_steps
read(un,*) bins
close(un)

end subroutine read_input

subroutine print_pos(un,pos,N)

implicit none
integer                         ::      N, indx, un
real*8, dimension(N,3)     ::      pos

write(un,*) N
write(un,*)
do indx=1,N, 1
        write(un,*) 'C' , pos(indx,:)
enddo

end subroutine print_pos

subroutine initialize_fcc( M ,L, pos)

implicit none
integer                        ::      M, d, indx, nx,ny,nz, N
real*8                         ::      L, a
real*8,dimension(3)            ::      origen
real*8,dimension(4*M**3,3)     ::      pos
real*8,dimension(M**3,3)       ::      pos_ini

!calculem a
a=L/M
!definim l'origen de la caixa al centre
do d=1,3,1
        origen(d)=-L/2
enddo
indx=0
!! Creem el vector amb tots els possibles nx, ny, nz
do nx=1,M,1; do ny=1,M,1; do nz=1,M,1
        indx=indx+1
        pos_ini(indx,1)= nx-1
        pos_ini(indx,2)=ny-1
        pos_ini(indx,3)= nz-1
enddo; enddo; enddo
N=M**3
!! Coloquem totes les cel·les
do indx=1, N, 1
! Partícula al vertex
         pos(indx,:)=pos_ini(indx,:)*a
! Partícula a 1a cara
         pos(indx+N,1)=pos(indx,1)+a/2
         pos(indx+N,2)=pos(indx,2)+a/2
         pos(indx+N,3)=pos(indx,3)
! Partícula a 2a cara
         pos(indx+2*N,1)=pos(indx,1)+a/2
         pos(indx+2*N,2)=pos(indx,2)
         pos(indx+2*N,3)=pos(indx,3)+a/2
! Partícula a 3a cara
         pos(indx+3*N,1)=pos(indx,1)
         pos(indx+3*N,2)=pos(indx,2)+a/2
         pos(indx+3*N,3)=pos(indx,3)+a/2
enddo

!! Reescalem les partícules
do indx=1,4*N,1
        pos(indx,:) = pos(indx,:) + origen(:)
enddo

end subroutine initialize_fcc

!! Subroutina per inicialitzar les velocitats seguint una distribució de MB

subroutine initialize_vel_normal(vel,N, T, seed)

implicit none
real*8,dimension(N,3)   ::     vel
integer         ::      N , indx, seed, iter_needed, d
real*8          ::      pi, T, sigma, rand1, rand2

pi = acos(-1.)
sigma = T**0.5
iter_needed = N/2
do d= 1, 3, 1
       indx = 0 
        do i=1, iter_needed, 1
                rand1 = rand()
                rand2 = rand()
                indx = indx + 1
                vel(indx,d) = sigma*sqrt(-2*log(rand1))*cos(2*pi*rand2)
                indx = indx +1
                vel(indx,d) = sigma*sqrt(-2*log(rand1))*sin(2*pi*rand2)
         enddo
enddo

end subroutine initialize_vel_normal

!! Subroutina per inicialitzar les velocitats seguint una distribucio uniforme

subroutine initialize_vel_unif(vel,N,T,seed)

implicit none
real*8,dimension(N,3)           ::      vel
integer         ::      N,indx, seed, d
real*8          ::      KE,T

!! Creem el rectangle inicial d'amplada 1 centrat al 0
do indx=1,N,1
        do d=1,3
                vel(indx,d) = rand() - 0.5
        enddo
enddo
KE = kinetic(vel,N)
!! Rescalem a la temperatura donada
vel(:,:) = vel(:,:)*dsqrt(N*3*T/(2*KE))
print*,'Velocity mean', sum(vel)/N

end subroutine initialize_vel_unif

!! Funció per evaluar les condicions periodiques de contorn

function pbc(coord,L)

implicit none
real*8  ::      coord,L,pbc

if (coord>L/2) then
        coord = coord - L
else if (coord<-L/2) then
             coord = coord + L
else
       coord = coord 
endif
pbc = coord

end function pbc

function kinetic(vel, N)

implicit none
real*8          ::      kinetic
real*8, dimension(N,3)    ::      vel
integer                 ::      i,d, N

kinetic=0.0

do i=1,N,1
        do d=1,3
        kinetic = kinetic + (vel(i,d)**2)
        enddo
enddo
kinetic = kinetic*0.5

end function kinetic

function momentum(vel,N)

implicit none
integer         ::      i, N
real*8          ::      momentum, px, py, pz
real*8, dimension(N,3)    ::      vel

px=0.0; py=0.0; pz= 0.0

do i=1, N, 1
        px = px + vel(i,1)
        py = py + vel(i,1)
        pz = pz + vel(i,1)
enddo
momentum = (px**2 + py**2 + pz**2)**0.5

end function momentum

function t_inst(KE,N)

implicit none
real*8          ::      KE,t_inst
integer         ::      N

t_inst = 2.*KE/(2*N)
end function t_inst

function distance(pos)

implicit none
real*8, dimension(N,3)    ::      pos
real*8                  ::      distance, r2, dx ,dy, dz

!! Apliquem les condicions periodiques de contorn
dx = pos(1,1)-pos(2,1)
dx = pbc(dx,L) 
dy = pos(1,2)-pos(2,2)
dy = pbc(dy,L) 
dz = pos(1,3)-pos(2,3)
dz = pbc(dz,L)
!! Calculem la distancia ara que ja hem aplicat les condicions periodiques de
!!contorn
r2 = r2 + dx**2
r2 = r2 + dy**2
r2 = r2 + dz**2
distance = r2**0.5

end function distance

function difusion_coef(pos_ini,pos,time,N,L)

implicit none
real*8,dimension(N,3)   ::      pos_ini, pos, mov
integer         ::      i,j, N
real*8          ::      time, difusion_coef, L, dx, dy ,dz, diff

mov(:,:) = pos(:,:) - pos_ini(:,:)

diff = 0.
do i=1,N,1
        dx = pbc(mov(i,1),L)
        dy = pbc(mov(i,2),L)
        dz = pbc(mov(i,3),L)
        diff = diff + dx**2 + dy**2 + dz**2
enddo

difusion_coef = diff/(N*6*t)

end function difusion_coef

subroutine LJ_forces(pos,N,L,cutoff, forces, pot)

implicit none
real*8            ::      r, r2, pot, cutoff
real*8            ::      dx,dy,dz, L, ff
integer           ::      i,j,N
real*8, dimension(N,3)    ::      pos, forces

forces(:,:) = 0
!! Inicialitzem el potencial
pot=0.0

do i=1, N, 1
        do j=i+1, N, 1
                r2=0
!! Apliquem les condicions periodiques de contorn
                dx = pos(i,1)-pos(j,1)
                dx = pbc(dx,L) 
                dy = pos(i,2)-pos(j,2)
                dy = pbc(dy,L) 
                dz = pos(i,3)-pos(j,3)
                dz = pbc(dz,L)

!! Calculem la distancia ara que ja hem aplicat les condicions periodiques de
!!contorn
                r2 = r2 + dx**2
                r2 = r2 + dy**2
                r2 = r2 + dz**2
                r = r2**0.5
!! Apliquem el cutoff
        if (r < cutoff) then
                ff = (48/r**14-24/r**8)
                forces(i,1)=forces(i,1) + ff*dx
                forces(i,2)=forces(i,2) + ff*dy
                forces(i,3)=forces(i,3) + ff*dz

                forces(j,1)=forces(j,1) - ff*dx
                forces(j,2)=forces(j,2) - ff*dy
                forces(j,3)=forces(j,3) - ff*dz

                pot = pot + 4*((1./r)**12-(1./r)**6)
        endif
        enddo
enddo

end subroutine LJ_forces

function pressure(pos,T,dens,L,N)

implicit none
real*8  ::      pressure,T, dens,L, suma,dx,dy,dz, ff, r2, r
integer         ::      i,j,N
real*8,dimension(N,3)   ::      pos

suma = 0.
do i=1,N,1
        do j=i+1, N, 1
                dx = pos(i,1)-pos(j,1)
                dx = pbc(dx,L) 
                dy = pos(i,2)-pos(j,2)
                dy = pbc(dy,L) 
                dz = pos(i,3)-pos(j,3)
                dz = pbc(dz,L)
                r2 = r2 + dx**2
                r2 = r2 + dy**2
                r2 = r2 + dz**2
                r = r2**0.5
                ff = (48/r**14-24/r**8)
                suma = suma + (ff*dx**2 + ff*dy**2 + ff*dz**2)
        enddo
enddo
pressure = dens*T + suma/(3*L**3)

end function pressure

subroutine verlet(pos, old_pos, N, L, cutoff, pot, vel, dt)

implicit none
integer         ::      i , N
real*8          ::      L, cutoff, dt, pot
real*8, dimension(N,3)          ::      pos, old_pos, forces, copia_pos, vel

copia_pos = pos

call LJ_forces(pos, N, L, cutoff, forces, pot)

do i=1, N, 1
        pos(i,1) = 2*pos(i,1)-old_pos(i,1) + forces(i,1)*dt**2
        pos(i,2) = 2*pos(i,2)-old_pos(i,2) + forces(i,2)*dt**2
        pos(i,3) = 2*pos(i,3)-old_pos(i,3) + forces(i,3)*dt**2
        
        pos(i,1) = pbc(pos(i,1),L)
        pos(i,2) = pbc(pos(i,2),L)
        pos(i,3) = pbc(pos(i,3),L)

        vel(i,1) = (pos(i,1)-old_pos(i,1))/(2*dt) 
        vel(i,2) = (pos(i,2)-old_pos(i,2))/(2*dt) 
        vel(i,3) = (pos(i,3)-old_pos(i,3))/(2*dt)
enddo
old_pos = copia_pos

end subroutine verlet

subroutine velocity_verlet(pos, N, L, cutoff, pot, vel, dt)

implicit none
integer         ::      i , N
real*8          ::      L, cutoff, dt, pot, sig, eps
real*8, dimension(N,3)          ::      pos, forces, vel

call LJ_forces(pos, N, L, cutoff, forces, pot)

do i=1, N, 1
        pos(i,1) = pos(i,1) + vel(i,1)*dt + forces(i,1)*dt**2/2
        pos(i,2) = pos(i,2) + vel(i,2)*dt + forces(i,2)*dt**2/2
        pos(i,3) = pos(i,3) + vel(i,3)*dt + forces(i,3)*dt**2/2
        
        pos(i,1) = pbc(pos(i,1),L)
        pos(i,2) = pbc(pos(i,2),L)
        pos(i,3) = pbc(pos(i,3),L)

        vel(i,1) = vel(i,1) + forces(i,1)*dt/2 
        vel(i,2) = vel(i,2) + forces(i,2)*dt/2 
        vel(i,3) = vel(i,3) + forces(i,3)*dt/2 
enddo

call LJ_forces(pos, N, L, cutoff, forces, pot)

do i=1,N,1
        vel(i,1) = vel(i,1) + forces(i,1)*dt/2 
        vel(i,2) = vel(i,2) + forces(i,2)*dt/2 
        vel(i,3) = vel(i,3) + forces(i,3)*dt/2 
enddo

end subroutine velocity_verlet

subroutine andersen(N,vel,seed,nu,T)

implicit none
integer         ::      indx,d,N,seed
real*8          ::      pi, sigma, T,nu, rand1, rand2
real*8,dimension(N,3)   ::      vel

pi = acos(-1.)
sigma = dsqrt(T)

do i=1, N, 1
        if (rand() < nu) then
                rand1 = rand()
                rand2 = rand()
                vel(indx,1) = sigma*sqrt(-2*log(rand1))*cos(2*pi*rand2)
                vel(indx,2) = sigma*sqrt(-2*log(rand1))*sin(2*pi*rand2)
                rand1 = rand()
                rand2 = rand()
                vel(indx,3) = sigma*sqrt(-2*log(rand1))*cos(2*pi*rand2)
        endif
enddo

end subroutine andersen

subroutine melt_crystall(T,steps,N,L,cutoff,pot,pos,vel,nu,dt,seed)

implicit none
real*8, dimension(N,3)          ::      pos, vel
real*8                  ::      T, nu, sigma, dt, time, cutoff,sig,eps,L,pot
integer                 ::      steps, i, N,seed

sigma = dsqrt(T)
time = 0.
do i=1,steps,1
        time = time +dt
        call velocity_verlet(pos, N, L, cutoff, pot, vel, dt)
        call andersen(N,vel,seed,nu,T)
enddo
open(unit=200,file='melted_positions.xyz')
call print_pos(200,pos,N)
close(200)
print*, 'Crystall melted'
end subroutine melt_crystall

subroutine histogram( vel,L, bins,un, outname )

implicit none
integer         ::       L, bins, un
real*8    ::  x_start, x_end
real*8,dimension(L,3)          ::      vel
real*8,dimension(3*L)       :: A
real*8,dimension(N)       :: hist_x, hist_y
integer          :: i, j, tot
real*8           :: dx, left, right
character(30)    ::     outname

!! Passem la matriu a vector, serà més fàcil de tractar
do j=1,3
        do i=1,L
                A(i+(j-1)*L) = vel(i,j)   
        enddo
enddo

!! Busquem el màxim i mínim elemet del array i  els inicialitzem
x_start= A(1); x_end = A(1)

do i=2,3*L
        if ( A(i) .gt. x_end) then
                x_end = A(i)
        else if (A(i) .lt. x_start) then
                x_start = A(i)
        endif        

enddo

!! Bin Width	
dx = (x_end - x_start)/dble(bins)
!! Loop over all bins	
do i=1,bins
        !! Set up hist_x, evenly spaced bin array with values of the bin centers
        hist_x(i) = x_start + (i-1)*dx + dx/2.0D0
        !! bin left value
        left      = hist_x(i) - dx/2.0D0
        !! bin right value
        right     = hist_x(i) + dx/2.0D0
        !! initialize counter for bin to 0
        tot       = 0
        !! Loop over entire array A
        do j=1,3*L
        !! Increment counter if value is within bin left and right
                if ( A(j) .gt. left .and. A(j) .lt. right ) tot = tot+1
        enddo
        !! Set hist_y to bin counte
        hist_y(i) = dble(tot)
enddo

open(unit=un,file=outname)
do i =1,bins
        write(un,*) hist_x(i) , hist_y(i)
enddo
close(un)
end subroutine histogram

subroutine reduced_units_to_real(time,KE,pot,t0,p,ML,timec,KEc,potc,t0c,pc,MLc, sigma, eps, mass)
implicit none
real*8  ::      time,KE,pot,t0,p,ML,timec,KEc,potc,t0c,pc,MLc
real*8  ::      sigma, eps, mass
real*8  ::      kb, NA

kb= 0.008314462 ! kJ/mol*K
NA= 6.022d23    

timec = time*1d-13*sigma*dsqrt(mass/eps) ! Seconds
KEc = KE*eps
potc = pot*eps
t0c = t0*eps/kb
pc = p*1d27*eps/(NA*sigma*3) ! Pascals
MLc = ML
end subroutine reduced_units_to_real
end program dinamica
