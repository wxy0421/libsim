
MODULE vol7d_netcdf_class

USE char_utilities
USE vol7d_class
USE vol7d_utilities
USE geo_coord_class
USE datetime_class
use netcdf

IMPLICIT NONE
PRIVATE
PUBLIC  import, export



!!$!>\brief importa
!!$INTERFACE import
!!$  MODULE PROCEDURE vol7d_netcdf_import
!!$END INTERFACE

!>\brief esporta
INTERFACE export
  MODULE PROCEDURE vol7d_netcdf_export
END INTERFACE



CONTAINS



subroutine vol7d_netcdf_export (this,ncconventions,ncunit,description,filename)

TYPE(vol7d),INTENT(IN) :: this !< volume vol7d da scrivere 
integer,optional,intent(inout) :: ncunit !< unit� netcdf su cui scrivere; se passata =0 ritorna il valore rielaborato (default =elaborato internamente da netcdf )
character(len=*),intent(in) :: ncconventions !< tipo di convenzione da utilizzare nella scrittura netcdf (per ora supportato "CF-1.1 vol7d")
character(len=*),intent(inout),optional :: filename !< nome del file su cui scrivere; se passato ="" ritorna il valore rielaborato
character(len=*),INTENT(IN),optional :: description !< descrizione del volume

integer :: lunit
character(len=254) :: ldescription,arg,lfilename
integer :: nana, ntime, ntimerange, nlevel, nnetwork, &
 ndativarr, ndativari, ndativarb, ndativard, ndativarc,&
 ndatiattrr, ndatiattri, ndatiattrb, ndatiattrd, ndatiattrc,&
 ndativarattrr, ndativarattri, ndativarattrb, ndativarattrd, ndativarattrc,&
 nanavarr, nanavari, nanavarb, nanavard, nanavarc,&
 nanaattrr, nanaattri, nanaattrb, nanaattrd, nanaattrc,&
 nanavarattrr, nanavarattri, nanavarattrb, nanavarattrd, nanavarattrc
!integer :: im,id,iy
integer :: tarray(8)
logical :: opened,exist

integer :: dativari_dimid,dativarb_dimid,ana_ident_varid,ana_dimid,ana_lon_varid,ana_lat_varid &
 ,dativarc_len_dimid,dativarc_dimid,dativard_dimid,dativarr_dimid,ident_len_dimid&
 ,level_dimid,level_vdim_dimid,level_vect_varid,network_dimid,network_id_varid,timerange_vdim_dimid &
 ,time_iminuti_varid,time_dimid,timerange_dimid,timerange_vect_varid
integer :: i

type(datetime) :: timeref 

if (ncconventions /= "CF-1.1 vol7d") then
  print *,"ncconventions not supported"
  call exit(1)
end if

!call idate(im,id,iy)
call date_and_time(values=tarray)
call getarg(0,arg)

if (present(description))then
  ldescription=description
else
  ldescription="Vol7d generated by: "//trim(arg)
end if

if (.not. present(ncunit))then
  lunit=getunit()
else
  if (ncunit==0)then
    lunit=getunit()
    ncunit=lunit
  else
    lunit=ncunit
  end if
end if

lfilename=trim(arg)//".nc"
if (index(arg,'/',back=.true.) > 0) lfilename=lfilename(index(arg,'/',back=.true.)+1 : )

if (present(filename))then
  if (filename == "")then
    filename=lfilename
  else
    lfilename=filename
  end if
end if


inquire(unit=lunit,opened=opened)
if (.not. opened) then 
  inquire(file=lfilename,EXIST=exist)
  if (exist) CALL raise_error('file exist; cannot open new file')
  if (.not.exist)   call check( "0",nf90_create(lfilename, nf90_clobber, lunit) )
  print *, "opened: ",lfilename
end if

call init(timeref,year=1,month=1,day=1,hour=00,minute=00)

nana=size(this%ana)
ntime=size(this%time)
ntimerange=size(this%timerange)
nlevel=size(this%level)
nnetwork=size(this%network)

ndativarr=size(this%dativar%r)
ndativari=size(this%dativar%i)
ndativarb=size(this%dativar%b)
ndativard=size(this%dativar%d)
ndativarc=size(this%dativar%c)

ndatiattrr=size(this%datiattr%r)
ndatiattri=size(this%datiattr%i)
ndatiattrb=size(this%datiattr%b)
ndatiattrd=size(this%datiattr%d)
ndatiattrc=size(this%datiattr%c)

ndativarattrr=size(this%dativarattr%r)
ndativarattri=size(this%dativarattr%i)
ndativarattrb=size(this%dativarattr%b)
ndativarattrd=size(this%dativarattr%d)
ndativarattrc=size(this%dativarattr%c)
 
nanavarr=size(this%anavar%r)
nanavari=size(this%anavar%i)
nanavarb=size(this%anavar%b)
nanavard=size(this%anavar%d)
nanavarc=size(this%anavar%c)

nanaattrr=size(this%anaattr%r)
nanaattri=size(this%anaattr%i)
nanaattrb=size(this%anaattr%b)
nanaattrd=size(this%anaattr%d)
nanaattrc=size(this%anaattr%c)

nanavarattrr=size(this%anavarattr%r)
nanavarattri=size(this%anavarattr%i)
nanavarattrb=size(this%anavarattr%b)
nanavarattrd=size(this%anavarattr%d)
nanavarattrc=size(this%anavarattr%c)


!write(unit=lunit)ldescription
!write(unit=lunit)tarray

call check( "1",nf90_def_dim(lunit,"ana", nana, ana_dimid) )
call check( "2",nf90_def_dim(lunit,"ident_len",vol7d_ana_lenident , ident_len_dimid) )

call check( "3",nf90_def_dim(lunit,"time", ntime, time_dimid) )

call check( "4",nf90_def_dim(lunit,"timerange", ntimerange, timerange_dimid) )
call check( "5",nf90_def_dim(lunit,"timerange_vdim", ntimerange, timerange_vdim_dimid) )

call check( "6",nf90_def_dim(lunit,"level", nlevel, level_dimid) )
call check( "7",nf90_def_dim(lunit,"level_vdim", nlevel, level_vdim_dimid) )

call check( "8",nf90_def_dim(lunit,"network", nnetwork, network_dimid) )



if (ndativarr /= 0) call check( "9" ,nf90_def_dim(lunit,"dativarr", ndativarr, dativarr_dimid) )
if (ndativari /= 0) call check( "10",nf90_def_dim(lunit,"dativari", ndativari, dativari_dimid) )
if (ndativarb /= 0) call check( "11",nf90_def_dim(lunit,"dativarb", ndativarb, dativarb_dimid) )
if (ndativard /= 0) call check( "12",nf90_def_dim(lunit,"dativard", ndativard, dativard_dimid) )
if (ndativarc /= 0) call check( "13",nf90_def_dim(lunit,"dativarc", ndativarc, dativarc_dimid) )

call check( "14",nf90_def_dim(lunit,"dativarc_len",vol7d_cdatalen, dativarc_len_dimid) )

! ripetere per datiattr anavar anaattr -- dativarattr anavarattr


call check( "15",nf90_def_var(lunit, "ana_lat", NF90_DOUBLE, ana_dimid, ana_lat_varid) )
call check( "16",nf90_def_var(lunit, "ana_lon", NF90_DOUBLE, ana_dimid, ana_lon_varid) )
call check( "17",nf90_def_var(lunit, "ana_ident", NF90_CHAR, (/ana_dimid, ident_len_dimid/), ana_ident_varid) )

call check( "18",nf90_def_var(lunit, "time_iminuti", NF90_INT, time_dimid, time_iminuti_varid) )

call check( "19",nf90_def_var(lunit, "timerange_vect", NF90_INT, (/timerange_dimid,timerange_vdim_dimid/), timerange_vect_varid) )
call check( "20",nf90_def_var(lunit, "level_vect", NF90_INT, (/level_dimid, level_vdim_dimid/), level_vect_varid) )
call check( "21",nf90_def_var(lunit, "network_id", NF90_INT, network_dimid, network_id_varid) )




! end definition
call check("22", nf90_enddef(lunit) )


if (associated(this%ana))       call check("23", nf90_put_var(lunit, ana_lat_varid, getlat(this%ana(:)%coord)))
if (associated(this%ana))       call check("24", nf90_put_var(lunit, ana_lon_varid, getlon(this%ana(:)%coord)))
print *, nana,vol7d_ana_lenident,shape(this%ana(:)%ident),len(this%ana(1)%ident)
if (associated(this%ana))       call check("25", nf90_put_var(lunit, ana_ident_varid, this%ana(:)%ident))
if (associated(this%time))      call check("26", nf90_put_var(lunit, time_iminuti_varid   , &
 int(timedelta_getamsec(this%time(1)-timeref)/1000)))

if (associated(this%level)) then
  do i=1,nlevel
    call check("27", nf90_put_var(lunit, level_vect_varid,&
     (/this%level(i)%level1,&
     this%level(i)%l1,&
     this%level(i)%level2,&
     this%level(i)%l2/),&
     start=(/i,1/),count=(/1,4/)))
  end do
end if

if (associated(this%timerange)) then
  do i=1,ntimerange
    call check( "28",nf90_put_var(lunit, timerange_vect_varid,&
     (/this%timerange(i)%timerange,&
     this%timerange(i)%p1,&
     this%timerange(i)%p2/),&
     start=(/i,1/),count=(/1,3/)))
  end do
end if

if (associated(this%network)) then
    call check( "29",nf90_put_var(lunit, timerange_vect_varid,this%network(:)%id))
end if

!!$write(unit=lunit)&
!!$ nana, ntime, ntimerange, nlevel, nnetwork, &
!!$ ndativarr, ndativari, ndativarb, ndativard, ndativarc,&
!!$ ndatiattrr, ndatiattri, ndatiattrb, ndatiattrd, ndatiattrc,&
!!$ ndativarattrr, ndativarattri, ndativarattrb, ndativarattrd, ndativarattrc,&
!!$ nanavarr, nanavari, nanavarb, nanavard, nanavarc,&
!!$ nanaattrr, nanaattri, nanaattrb, nanaattrd, nanaattrc,&
!!$ nanavarattrr, nanavarattri, nanavarattrb, nanavarattrd, nanavarattrc


!!$!! prime 5 dimensioni
!!$if (associated(this%ana))       write(unit=lunit)this%ana
!!$if (associated(this%time))      write(unit=lunit)this%time
!!$if (associated(this%level))     write(unit=lunit)this%level
!!$if (associated(this%timerange)) write(unit=lunit)this%timerange
!!$if (associated(this%network))   write(unit=lunit)this%network
!!$
!!$  !! 6a dimensione: variabile dell'anagrafica e dei dati
!!$  !! con relativi attributi e in 5 tipi diversi
!!$
!!$if (associated(this%anavar%r))      write(unit=lunit)this%anavar%r    
!!$if (associated(this%anavar%i))      write(unit=lunit)this%anavar%i    
!!$if (associated(this%anavar%b))      write(unit=lunit)this%anavar%b    
!!$if (associated(this%anavar%d))      write(unit=lunit)this%anavar%d    
!!$if (associated(this%anavar%c))      write(unit=lunit)this%anavar%c    
!!$
!!$if (associated(this%anaattr%r))     write(unit=lunit)this%anaattr%r
!!$if (associated(this%anaattr%i))     write(unit=lunit)this%anaattr%i
!!$if (associated(this%anaattr%b))     write(unit=lunit)this%anaattr%b
!!$if (associated(this%anaattr%d))     write(unit=lunit)this%anaattr%d
!!$if (associated(this%anaattr%c))     write(unit=lunit)this%anaattr%c
!!$
!!$if (associated(this%anavarattr%r))  write(unit=lunit)this%anavarattr%r
!!$if (associated(this%anavarattr%i))  write(unit=lunit)this%anavarattr%i
!!$if (associated(this%anavarattr%b))  write(unit=lunit)this%anavarattr%b
!!$if (associated(this%anavarattr%d))  write(unit=lunit)this%anavarattr%d
!!$if (associated(this%anavarattr%c))  write(unit=lunit)this%anavarattr%c
!!$
!!$if (associated(this%dativar%r))     write(unit=lunit)this%dativar%r
!!$if (associated(this%dativar%i))     write(unit=lunit)this%dativar%i
!!$if (associated(this%dativar%b))     write(unit=lunit)this%dativar%b
!!$if (associated(this%dativar%d))     write(unit=lunit)this%dativar%d
!!$if (associated(this%dativar%c))     write(unit=lunit)this%dativar%c
!!$
!!$if (associated(this%datiattr%r))    write(unit=lunit)this%datiattr%r
!!$if (associated(this%datiattr%i))    write(unit=lunit)this%datiattr%i
!!$if (associated(this%datiattr%b))    write(unit=lunit)this%datiattr%b
!!$if (associated(this%datiattr%d))    write(unit=lunit)this%datiattr%d
!!$if (associated(this%datiattr%c))    write(unit=lunit)this%datiattr%c
!!$
!!$if (associated(this%dativarattr%r)) write(unit=lunit)this%dativarattr%r
!!$if (associated(this%dativarattr%i)) write(unit=lunit)this%dativarattr%i
!!$if (associated(this%dativarattr%b)) write(unit=lunit)this%dativarattr%b
!!$if (associated(this%dativarattr%d)) write(unit=lunit)this%dativarattr%d
!!$if (associated(this%dativarattr%c)) write(unit=lunit)this%dativarattr%c
!!$
!!$!! Volumi di valori e attributi per anagrafica e dati
!!$
!!$if (associated(this%volanar))      write(unit=lunit)this%volanar
!!$if (associated(this%volanaattrr))  write(unit=lunit)this%volanaattrr
!!$if (associated(this%voldatir))     write(unit=lunit)this%voldatir
!!$if (associated(this%voldatiattrr)) write(unit=lunit)this%voldatiattrr
!!$
!!$if (associated(this%volanai))      write(unit=lunit)this%volanai
!!$if (associated(this%volanaattri))  write(unit=lunit)this%volanaattri
!!$if (associated(this%voldatii))     write(unit=lunit)this%voldatii
!!$if (associated(this%voldatiattri)) write(unit=lunit)this%voldatiattri
!!$
!!$if (associated(this%volanab))      write(unit=lunit)this%volanab
!!$if (associated(this%volanaattrb))  write(unit=lunit)this%volanaattrb
!!$if (associated(this%voldatib))     write(unit=lunit)this%voldatib
!!$if (associated(this%voldatiattrb)) write(unit=lunit)this%voldatiattrb
!!$
!!$if (associated(this%volanad))      write(unit=lunit)this%volanad
!!$if (associated(this%volanaattrd))  write(unit=lunit)this%volanaattrd
!!$if (associated(this%voldatid))     write(unit=lunit)this%voldatid
!!$if (associated(this%voldatiattrd)) write(unit=lunit)this%voldatiattrd
!!$
!!$if (associated(this%volanac))      write(unit=lunit)this%volanac
!!$if (associated(this%volanaattrc))  write(unit=lunit)this%volanaattrc
!!$if (associated(this%voldatic))     write(unit=lunit)this%voldatic
!!$if (associated(this%voldatiattrc)) write(unit=lunit)this%voldatiattrc
!!$
!!$if (.not. present(unit)) close(unit=lunit)


! close
if (.not. present(ncunit)) call check("90", nf90_close(lunit) )

end subroutine vol7d_netcdf_export



subroutine check(stringa,status)
integer, intent ( in) :: status
character (len=*) :: stringa

if(status /= nf90_noerr) then
  print *, stringa
  print *, trim(nf90_strerror(status))
  stop "Stopped"
end if
end subroutine check


end MODULE vol7d_netcdf_class
