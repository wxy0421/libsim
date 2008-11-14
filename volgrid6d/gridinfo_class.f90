module gridinfo_class

USE grid_class
USE datetime_class
USE vol7d_timerange_class
USE vol7d_level_class
USE volgrid6d_var_class
use log4fortran


IMPLICIT NONE

character (len=255),parameter:: subcategory="gridinfo_class"


!> Definisce un oggetto contenente le informazioni relative a un grib
type gridinfo_type


!> descrittore del grigliato
  type(griddim_def) :: griddim
!> descrittore della dimensione tempo
  TYPE(datetime) :: time
!> descrittore della dimensione intervallo temporale (timerange)
  TYPE(vol7d_timerange) :: timerange
!> descrittore della dimensione livello verticale
  TYPE(vol7d_level) :: level
!> vettore descrittore della dimensione variabile di anagrafica
  TYPE(volgrid6d_var) :: var
!> id del grib come da grib_api
  integer ::  gaid
  logical ::  gaset   !<  determina se quando export devo settare le key delle grib_api
  integer :: category !< log4fortran

end type gridinfo_type



INTERFACE init
  MODULE PROCEDURE init_gridinfo
END INTERFACE

INTERFACE delete
  MODULE PROCEDURE delete_gridinfo
END INTERFACE


!> Import
!! Legge i valori dal grib e li imposta appropriatamente
INTERFACE import
  MODULE PROCEDURE import_time,import_timerange,import_level,import_gridinfo
END INTERFACE

!> Export
!! Imposta i valori nel grib
INTERFACE export
  MODULE PROCEDURE export_time,export_timerange,export_level,export_gridinfo
END INTERFACE


INTERFACE display
  MODULE PROCEDURE display_timerange,display_level,display_gridinfo,display_gridinfov,display_time
END INTERFACE


private

public gridinfo_type,init,delete,import,export,display,decode_gridinfo,encode_gridinfo

contains

!> Inizializza un oggetto di tipo gridinfo_type.
SUBROUTINE init_gridinfo(this,gaid,griddim,time,timerange,level,var,gaset,categoryappend)
TYPE(gridinfo_type),intent(out) :: this !< oggetto da inizializzare

!> id del grib come da grib_api
integer,intent(in),optional ::  gaid
!> descrittore del grigliato
type(griddim_def),intent(in),optional :: griddim
!> descrittore della dimensione tempo
TYPE(datetime),intent(in),optional :: time
!> descrittore della dimensione intervallo temporale (timerange)
TYPE(vol7d_timerange),intent(in),optional :: timerange
!> descrittore della dimensione livello verticale
TYPE(vol7d_level),intent(in),optional :: level
!> vettore descrittore della dimensione variabile di anagrafica
TYPE(volgrid6d_var),intent(in),optional :: var
logical,intent(in),optional :: gaset

character(len=*),INTENT(in),OPTIONAL :: categoryappend !< appennde questo suffisso al namespace category di log4fortran

character(len=512) :: a_name

if (present(categoryappend))then
   call l4f_launcher(a_name,a_name_append=trim(subcategory)//"."//trim(categoryappend))
else
   call l4f_launcher(a_name,a_name_append=trim(subcategory))
end if
this%category=l4f_category_get(a_name)


if (present(gaid))then
  this%gaid=gaid
else
  this%gaid=imiss
end if

call l4f_category_log(this%category,L4F_DEBUG,"init gridinfo gaid: "//to_char(this%gaid))


if (present(gaset))then
  this%gaset = gaset
else
  this%gaset = .false.
end if

if (present(griddim))then
  this%griddim=griddim
else
  call init(this%griddim)
end if

if (present(time))then
  this%time=time
else
  call init(this%time)
end if

if (present(timerange))then
  this%timerange=timerange
else
  call init(this%timerange)
end if

if (present(level))then
  this%level=level
else
  call init(this%level)
end if

if (present(var))then
  this%var=var
else
  call init(this%var)
end if

end SUBROUTINE init_gridinfo


subroutine delete_gridinfo (this)
TYPE(gridinfo_type),intent(out) :: this !< oggetto da eliminare


call delete(this%griddim)
call delete(this%time)
call delete(this%timerange)
call delete(this%level)
call delete(this%var)

call l4f_category_log(this%category,L4F_DEBUG,"cancello gaid" )
this%gaid=imiss

!chiudo il logger
call l4f_category_delete(this%category)


end subroutine delete_gridinfo



subroutine import_gridinfo (this)

TYPE(gridinfo_type),intent(out) :: this !< oggetto da importare


call l4f_category_log(this%category,L4F_DEBUG,"ora provo ad importare da grib " )


call import(this%griddim,this%gaid)
call import(this%time,this%gaid)
call import(this%timerange,this%gaid)
call import(this%level,this%gaid)
call import(this%var,this%gaid)


end subroutine import_gridinfo


subroutine export_gridinfo (this)

TYPE(gridinfo_type),intent(out) :: this !< oggetto da exportare

call l4f_category_log(this%category,L4F_DEBUG,"export to grib" )

if (this%gaset .and. c_e(this%gaid)) then
  call export(this%griddim,this%gaid)
  call export(this%time,this%gaid)
  call export(this%timerange,this%gaid)
  call export(this%level,this%gaid)
  call export(this%var,this%gaid)
end if

end subroutine export_gridinfo



subroutine import_time(this,gaid)

TYPE(datetime),INTENT(out) :: this
integer,INTENT(in)         :: gaid
integer                    :: EditionNumber
character(len=9)           :: date
character(len=10)           :: time


call grib_get(gaid,'GRIBEditionNumber',EditionNumber)

if (EditionNumber == 1 .or.EditionNumber == 2 )then

  call grib_get(gaid,'dataDate',date )
  call grib_get(gaid,'dataTime',time(:5) )

  call init (this,simpledate=date(:8)//time(:4))

else

  CALL raise_error('GribEditionNumber not supported')

end if

end subroutine import_time



subroutine export_time(this,gaid)

TYPE(datetime),INTENT(in) :: this
integer,INTENT(in)        :: gaid
integer                   :: EditionNumber
character(len=17)         :: date_time


call grib_get(gaid,'GRIBEditionNumber',EditionNumber)

if (EditionNumber == 1 .or.EditionNumber == 2 )then

! datetime is AAAAMMGGhhmmssmsc
  call getval (this,simpledate=date_time)
  call grib_set(gaid,'dataDate',date_time(:8))
  call grib_set(gaid,'dataTime',date_time(9:14))

else

  CALL raise_error('GribEditionNumber not supported')

end if


end subroutine export_time



subroutine import_level(this,gaid)

TYPE(vol7d_level),INTENT(out) :: this
integer,INTENT(in)          :: gaid
integer                     :: EditionNumber,level1,l1,level2,l2
integer :: ltype,ltype1,scalef1,scalev1,ltype2,scalef2,scalev2

call grib_get(gaid,'GRIBEditionNumber',EditionNumber)

if (EditionNumber == 1)then
  
  call grib_get(gaid,'indicatorOfTypeOfLevel',ltype)
  call grib_get(gaid,'topLevel',l1)
  call grib_get(gaid,'bottomLevel',l2)

  call cnvlevel(ltype,l1,l2,ltype1,scalef1,scalev1,ltype2,scalef1,scalev2)

else if (EditionNumber == 2)then

  call grib_get(gaid,'typeOfFirstFixedSurface',ltype1)
  call grib_get(gaid,'scaleFactorOfFirstFixedSurface',scalef1)
  call grib_get(gaid,'scaledValueOfFirstFixedSurface',scalev1)

  call grib_get(gaid,'typeOfSecondFixedSurface',ltype2)     ! (missing=255)
  call grib_get(gaid,'scaleFactorOfSecondFixedSurface',scalef2)
  call grib_get(gaid,'scaledValueOfSecondFixedSurface',scalev2)

else

  call raise_error('GribEditionNumber not supported')

end if


call level2dballe(ltype1,scalef1,scalev1,ltype2,scalef2,scalev2, level1,l1,level2,l2)

call init (this,level1,l1,level2,l2)


end subroutine import_level



subroutine export_level(this,gaid)

TYPE(vol7d_level),INTENT(in) :: this
integer,INTENT(in)         :: gaid
integer                     :: EditionNumber,level1,l1,level2,l2

call grib_get(gaid,'GRIBEditionNumber',EditionNumber)

if (EditionNumber == 1)then


!  call grib_set(gaid,'indicatorOfTypeOfLevel',this%level1)
!  call grib_set(gaid,'topLevel',this%l1)
!  call grib_set(gaid,'bottomLevel',this%l2)

! call l4f_category_log(category,L4F_ERROR,"conversione non gestita" )

  call raise_error("convert level from grib2 to grib1 not managed")

else if (EditionNumber == 2)then

  call grib_set(gaid,'typeOfFirstFixedSurface',this%level1)     ! (missing=255)

  call grib_set(gaid,'scaledValueOfFirstFixedSurface',this%l1)
  call grib_set(gaid,'typeOfSecondFixedSurface',this%level2)

  call grib_set(gaid,'scaledValueOfSecondFixedSurface',this%l2)

else

  call raise_error('GribEditionNumber not supported')

end if


end subroutine export_level



subroutine import_timerange(this,gaid)

TYPE(vol7d_timerange),INTENT(out) :: this
integer,INTENT(in)          :: gaid
integer ::EditionNumber,timerange,p1,p2,status

call grib_get(gaid,'GRIBEditionNumber',EditionNumber)

if (EditionNumber == 1 .or. EditionNumber == 2)then
  
  call grib_get(gaid,'typeOfStatisticalProcessing',timerange,status)
  if (status == GRIB_SUCCESS) then
     call grib_get(gaid,'endStepInHours',p1)
     call grib_get(gaid,'lengthOfTimeRange',p2)
  
     call init (this, timerange,p1,p2)
  else

! TODO
! qui forse bisogna capire meglio in quale template siamo
! e come mai grib1 va a finire qui

     call init (this)
     
  end if
else

  call raise_error('GribEditionNumber not supported')

end if

end subroutine import_timerange



subroutine export_timerange(this,gaid)

TYPE(vol7d_timerange),INTENT(in) :: this
integer,INTENT(in)         :: gaid
integer ::EditionNumber,timerange,p1,p2

call grib_get(gaid,'GRIBEditionNumber',EditionNumber)

if (EditionNumber == 1 .or. EditionNumber == 2)then

  call grib_set(gaid,'typeOfStatisticalProcessing',this%timerange)
  call grib_set(gaid,'endStepInHours',this%p1)
  call grib_set(gaid,'lengthOfTimeRange',this%p2)

else

  call raise_error('GribEditionNumber not supported')

end if



end subroutine export_timerange



subroutine display_gridinfo (this)

TYPE(gridinfo_type),intent(in) :: this !< oggetto da stampare


call l4f_category_log(this%category,L4F_DEBUG,"ora mostro gridinfo " )


print*,"----------------------- gridinfo display ---------------------"
call display(this%griddim)
call display(this%time)
call display(this%timerange)
call display(this%level)
call display(this%var)
print*,"--------------------------------------------------------------"


end subroutine display_gridinfo



subroutine display_gridinfov (this)

TYPE(gridinfo_type),intent(in) :: this(:) !< vettore di oggetti da stampare
integer :: i

print*,"----------------------- gridinfo  vector ---------------------"

do i=1, size(this)

  call l4f_category_log(this(i)%category,L4F_DEBUG,"ora mostro il vettore gridinfo " )

  call display(this(i))

end do
print*,"--------------------------------------------------------------"

end subroutine display_gridinfov



subroutine display_timerange(this)

TYPE(vol7d_timerange),INTENT(in) :: this
integer ::EditionNumber,timerange,p1,p2

print*,"TIMERANGE: ",this%timerange,this%p1,this%p2

end subroutine display_timerange



subroutine display_level(this)

TYPE(vol7d_level),INTENT(in) :: this

print*,"LEVEL: ",this%level1,this%l1,this%level2,this%l2
  
end subroutine display_level



subroutine display_time(this)

TYPE(datetime),INTENT(in) :: this
character(len=17)         :: date_time

call getval (this,simpledate=date_time)

print*,"TIME: ",date_time


end subroutine display_time




function decode_gridinfo(this) result (field)

TYPE(gridinfo_type),INTENT(in)  :: this      !< oggetto da decodificare
integer                     :: EditionNumber
integer  :: alternativeRowScanning,iScansNegatively,jScansPositively,jPointsAreConsecutive
integer :: numberOfValues,numberOfPoints
real  :: field (this%griddim%dim%nx,this%griddim%dim%ny)

!TODO costretto a usare doubleprecision in quanto float non va (riportato bug grib_api)
doubleprecision  :: vector (this%griddim%dim%nx * this%griddim%dim%ny)
doubleprecision,allocatable  :: lats (:),lons(:)
integer ::x1,x2,xs,y1,y2,ys,ord(2)


call grib_get(this%gaid,'GRIBEditionNumber',EditionNumber)

call l4f_category_log(this%category,L4F_INFO,'Edition Number: '//to_char(EditionNumber))

if (EditionNumber == 2)then

  call grib_get(this%gaid,'alternativeRowScanning',alternativeRowScanning)
  if (alternativeRowScanning /= 0)then
    call l4f_category_log(this%category,L4F_ERROR,"alternativeRowScanning not supported: "//trim(to_char(alternativeRowScanning)))
    call raise_error('alternativeRowScanning not supported')
  end if

else if( EditionNumber /= 1)then

  call l4f_category_log(this%category,L4F_ERROR,"GribEditionNumber not supported: "//trim(to_char(EditionNumber)))
  call raise_error('GribEditionNumber not supported')

end if


call grib_get(this%gaid,'iScansNegatively',iScansNegatively)
call grib_get(this%gaid,'jScansPositively',jScansPositively)
call grib_get(this%gaid,'jPointsAreConsecutive',jPointsAreConsecutive)

call grib_set(this%gaid,'missingValue',rmiss)
call grib_get(this%gaid,'numberOfPoints',numberOfPoints)
call grib_get(this%gaid,'numberOfValues',numberOfValues)


if (numberOfPoints /= (this%griddim%dim%nx * this%griddim%dim%ny))then
!if (numberOfValues /= (this%griddim%dim%nx * this%griddim%dim%ny))then

  call l4f_category_log(this%category,L4F_INFO,'nx: '//to_char(this%griddim%dim%nx)&
       //' ny: '//to_char(this%griddim%dim%ny)//to_char(this%griddim%dim%nx*this%griddim%dim%ny))
  call l4f_category_log(this%category,L4F_ERROR,'number of values disagree with nx,ny: '//to_char(numberOfPoints))
!  call l4f_category_log(this%category,L4F_ERROR,'number of values disagree with nx,ny: '//to_char(numberOfValues))
  call raise_error('number of values disagree with nx,ny')

end if

                            !     get data values
call l4f_category_log(this%category,L4F_INFO,'number of values: '//to_char(numberOfValues))
call l4f_category_log(this%category,L4F_INFO,'number of points: '//to_char(numberOfPoints))

allocate(lats(numberOfPoints))
allocate(lons(numberOfPoints))
call grib_get_data(this%gaid,lats,lons,vector)
call l4f_category_log(this%category,L4F_INFO,'decoded')

deallocate(lats)
deallocate(lons)

!call grib_get(this%gaid,'values',vector)


! Transfer data field changing scanning mode to 64
IF (iScansNegatively  == 0) THEN
  x1 = 1
  x2 = this%griddim%dim%nx
  xs = 1
ELSE
  x1 = this%griddim%dim%nx
  x2 = 1
  xs = -1
ENDIF
IF (jScansPositively == 0) THEN
  y1 = this%griddim%dim%ny
  y2 = 1
  ys = -1
ELSE
  y1 = 1
  y2 = this%griddim%dim%ny
  ys = 1
ENDIF

IF ( jPointsAreConsecutive == 0) THEN
  ord = (/1,2/)
ELSE
  ord = (/2,1/)
ENDIF


field(x1:x2:xs,y1:y2:ys) = &
 RESHAPE(vector, &
 (/this%griddim%dim%nx,this%griddim%dim%ny/), ORDER=ord)


end function decode_gridinfo



subroutine encode_gridinfo(this,field)

TYPE(gridinfo_type),INTENT(in)  :: this      !< oggetto in cui codificare
real  :: field (this%griddim%dim%nx,this%griddim%dim%ny) !< matrice dei dati da scrivere

integer                     :: EditionNumber
integer  :: alternativeRowScanning,iScansNegatively,jScansPositively,jPointsAreConsecutive
integer :: numberOfValues,nx,ny
real  :: vector (this%griddim%dim%nx * this%griddim%dim%ny)
integer ::x1,x2,xs,y1,y2,ys,ord(2)


if (.not. c_e(this%gaid))return


call grib_get(this%gaid,'GRIBEditionNumber',EditionNumber)


if (EditionNumber == 2)then

  call grib_get(this%gaid,'alternativeRowScanning',alternativeRowScanning)
  if (alternativeRowScanning /= 0)then
    call l4f_category_log(this%category,L4F_ERROR,"alternativeRowScanning not supported: "//trim(to_char(alternativeRowScanning)))
    call raise_error('alternativeRowScanning not supported')
  end if

else if( EditionNumber /= 1)then

  call l4f_category_log(this%category,L4F_ERROR,"GribEditionNumber not supported: "//trim(to_char(EditionNumber)))
  call raise_error('GribEditionNumber not supported')

end if


call grib_get(this%gaid,'iScansNegatively',iScansNegatively)
call grib_get(this%gaid,'jScansPositively',jScansPositively)
call grib_get(this%gaid,'jPointsAreConsecutive',jPointsAreConsecutive)

call grib_get(this%gaid,"numberOfPointsAlongAParallel", nx)
call grib_get(this%gaid,"numberOfPointsAlongAMeridian",ny)

numberOfValues=nx*ny

if (numberOfValues /= (this%griddim%dim%nx * this%griddim%dim%ny))then

  call l4f_category_log(this%category,L4F_INFO,'nx: '//to_char(this%griddim%dim%nx)&
       //' ny: '//to_char(this%griddim%dim%ny))
  call l4f_category_log(this%category,L4F_ERROR,'number of values different nx,ny: '//to_char(numberOfValues))
  call raise_error('number of values different nx,ny')

end if

call l4f_category_log(this%category,L4F_INFO,'number of values: '//to_char(numberOfValues))


! Transfer data field changing scanning mode to 64
IF (iScansNegatively  == 0) THEN
  x1 = 1
  x2 = this%griddim%dim%nx
  xs = 1
ELSE
  x1 = this%griddim%dim%nx
  x2 = 1
  xs = -1
ENDIF
IF (jScansPositively == 0) THEN
  y1 = this%griddim%dim%ny
  y2 = 1
  ys = -1
ELSE
  y1 = 1
  y2 = this%griddim%dim%ny
  ys = 1
ENDIF

IF ( jPointsAreConsecutive == 0) THEN
  ord = (/1,2/)
ELSE
  ord = (/2,1/)
ENDIF


field(x1:x2:xs,y1:y2:ys) = &
 RESHAPE(vector, &
 (/this%griddim%dim%nx,this%griddim%dim%ny/), ORDER=ord)

call grib_set(this%gaid,'missingValue',rmiss)
call grib_set(this%gaid,'values',pack(field,mask=.true.))


end subroutine encode_gridinfo




!derived from a work  Gilbert        ORG: W/NP11  SUBPROGRAM:    cnvlevel   DATE: 2003-06-12


subroutine level2dballe(ltype1,scalef1,scalev1,ltype2,scalef2,scalev2, lt1,l1,lt2,l2)

integer,intent(in) :: ltype1,scalef1,scalev1,ltype2,scalef2,scalev2
integer,intent(out) ::lt1,l1,lt2,l2

integer,parameter :: height(5)=(/102,103,106,117,160/)
doubleprecision:: sl1,sl2


if (ltype1 == 255 ) then
  lt1=imiss
  l1=imiss
else
  lt1=ltype1

  sl1=scalev1*(10.D00**(-scalef1))

  if ( any( ltype1 == height)) then

    l1=sl1*1000.

  else

    l1=sl1

  end if
end if



if (ltype2 == 255 ) then
  lt2=imiss
  l2=imiss
else
  lt2=ltype2

  sl2=scalev2*(10.D00**(-scalef2))

  if ( any( ltype2 == height)) then

    l2=sl2*1000.

  else

    l2=sl2

  end if
end if



return
end subroutine level2dballe



subroutine cnvlevel(ltype,l1,l2,ltype1,scalef1,scalev1,ltype2,scalef2,scalev2)

integer,intent(in) :: ltype,l1,l2
integer,intent(out) :: ltype1,scalef1,scalev1,ltype2,scalef2,scalev2


if (ltype > 0 .and. ltype < 6)then 
   ltype1=ltype
   scalef1=0
   scalev1=0
   ltype2=255
   scalef2=0
   scalev2=0
elseif (ltype.eq.100) then
  ltype1=100
  scalev1=l1*100
elseif (ltype.eq.101) then
  ltype1=100
  scalev1=l1*1000
  ltype2=100
  scalev2=l2*1000
elseif (ltype.eq.102) then
  ltype1=101
elseif (ltype.eq.103) then
  ltype1=102
  scalev1=l1
elseif (ltype.eq.104) then
  ltype1=102
  scalev1=l1
  ltype2=102
  scalev2=l2
elseif (ltype.eq.105) then
  ltype1=103
  scalev1=l1
elseif (ltype.eq.106) then
  ltype1=103
  scalev1=l1*100
  ltype2=103
  scalev2=l2*100
elseif (ltype.eq.107) then
  ltype1=104
  scalef1=4
  scalev1=l1
elseif (ltype.eq.108) then
  ltype1=104
  scalef1=2
  scalev1=l1
  ltype2=104
  scalef2=2
  scalev2=l2
elseif (ltype.eq.109) then
  ltype1=105
  scalev1=l1
elseif (ltype.eq.110) then
  ltype1=105
  scalev1=l1
  ltype2=105
  scalev2=l2
elseif (ltype.eq.111) then
  ltype1=106
  scalef1=2
  scalev1=l1
elseif (ltype.eq.112) then
  ltype1=106
  scalef1=2
  scalev1=l1
  ltype2=106
  scalef2=2
  scalev2=l2
elseif (ltype.eq.113) then
  ltype1=107
  scalev1=l1
elseif (ltype.eq.114) then
  ltype1=107
  scalev1=475+l1
  ltype2=107
  scalev2=475+l2
elseif (ltype.eq.115) then
  ltype1=108
  scalev1=l1*100
elseif (ltype.eq.116) then
  ltype1=108
  scalev1=l1*100
  ltype2=108
  scalev2=l2*100
elseif (ltype.eq.117) then
  ltype1=109
  scalef1=9
  scalev1=l1
  if ( btest(l1,15) ) then
    scalev1=-1*mod(l1,32768)
  endif
elseif (ltype.eq.119) then
  ltype1=111
  scalef1=4
  scalev1=l1
elseif (ltype.eq.120) then
  ltype1=111
  scalef1=2
  scalev1=l1
  ltype2=111
  scalef2=2
  scalev2=l2
elseif (ltype.eq.121) then
  ltype1=100
  scalev1=(1100+l1)*100
  ltype2=100
  scalev2=(1100+l2)*100
elseif (ltype.eq.125) then
  ltype1=103
  scalef1=2
  scalev1=l1
elseif (ltype.eq.128) then
  ltype1=104
  scalef1=3
  scalev1=1100+l1
  ltype2=104
  scalef2=3
  scalev2=1100+l2
elseif (ltype.eq.141) then
  ltype1=100
  scalev1=l1*100
  ltype2=100
  scalev2=(1100+l2)*100
elseif (ltype.eq.160) then
  ltype1=160
  scalev1=l1
else

  ltype1=255
  scalef1=0
  scalev1=0
  ltype2=255
  scalef2=0
  scalev2=0

  call raise_error('cnvlevel: GRIB1 Level '//to_char(ltype)//' not recognized.')

endif

return
end subroutine cnvlevel



end module gridinfo_class
