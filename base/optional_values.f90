module optional_values

use missing_values
IMPLICIT NONE


INTERFACE optio
  MODULE PROCEDURE soptio_b, soptio_s, soptio_l, soptio_r, soptio_d, soptio_c, soptio_log
END INTERFACE

PUBLIC

CONTAINS


!FUNCTION

!> Return the optional values if present or missing
integer(kind=int_b) function optio_b(var)

integer(kind=int_b),intent(in),optional  :: var !< variabile da controllare

if (present(var))then
  optio_b=var
else
  optio_b=ibmiss
end if

return
end function optio_b

!> Return the optional values if present or missing
integer(kind=int_s) function optio_s(var)

integer(kind=int_s),intent(in),optional  :: var !< variabile da controllare

if (present(var))then
  optio_s=var
else
  optio_s=ismiss
end if

return
end function optio_s




!> Return the optional values if present or missing
integer(kind=int_l) function optio_l(var)

integer(kind=int_l),intent(in),optional  :: var !< variabile da controllare

if (present(var))then
  optio_l=var
else
  optio_l=ilmiss
end if

return
end function optio_l



!> Return the optional values if present or missing
real function optio_r(var)

real,intent(in),optional  :: var !< variabile da controllare

if (present(var))then
  optio_r=var
else
  optio_r=rmiss
end if

return
end function optio_r



!> Return the optional values if present or missing
real (kind=fp_d)  function optio_d(var)

real (kind=fp_d),intent(in),optional  :: var !< variabile da controllare

if (present(var))then
  optio_d=var
else
  optio_d=rdmiss
end if

return
end function optio_d


!> Return the optional values if present or missing
character function optio_c(var,len) result(char)

character (len=*),intent(in),optional  :: var !< variabile da controllare
integer , intent(in) :: len
CHARACTER(len=LEN) :: char

if (present(var))then
  char=var
else
  char=cmiss
end if

return
end function optio_c



!> Return the optional values if present or missing
logical  function optio_log(var)

logical,intent(in),optional  :: var !< variabile da controllare

if (present(var))then
  optio_log=var
else
  optio_log=.false.
end if

return
end function optio_log




!SUBROUTINE

!> Return the optional values if present or missing
subroutine soptio_b(var,optio_b)

integer(kind=int_b),intent(in),optional  :: var !< variabile da controllare
integer(kind=int_b),intent(out) :: optio_b

if (present(var))then
  optio_b=var
else
  optio_b=ibmiss
end if

return
end subroutine soptio_b

!> Return the optional values if present or missing
subroutine soptio_s(var,optio_s)

integer(kind=int_s),intent(in),optional  :: var !< variabile da controllare
integer(kind=int_s),intent(out) :: optio_s

if (present(var))then
  optio_s=var
else
  optio_s=ismiss
end if

return
end subroutine soptio_s




!> Return the optional values if present or missing
subroutine soptio_l(var,optio_l)

integer(kind=int_l),intent(in),optional  :: var !< variabile da controllare
integer(kind=int_l),intent(out) :: optio_l

if (present(var))then
  optio_l=var
else
  optio_l=ilmiss
end if

return
end subroutine soptio_l



!> Return the optional values if present or missing
subroutine soptio_r(var,optio_r)

real,intent(in),optional  :: var !< variabile da controllare
real,intent(out) :: optio_r

if (present(var))then
  optio_r=var
else
  optio_r=rmiss
end if

return
end subroutine soptio_r



!> Return the optional values if present or missing
subroutine soptio_d(var,optio_d)

real (kind=fp_d),intent(in),optional  :: var !< variabile da controllare
real (kind=fp_d),intent(out) :: optio_d

if (present(var))then
  optio_d=var
else
  optio_d=rdmiss
end if

return
end subroutine soptio_d


!> Return the optional values if present or missing
subroutine soptio_c(var,optio_c)

character (len=*),intent(in),optional  :: var !< variabile da controllare
CHARACTER (len=*),intent(out) :: optio_c


if (present(var))then
  optio_c=var
else
  optio_c=cmiss
end if

return
end subroutine soptio_c


!> Return the optional values if present or missing
!assume .false. for default
subroutine soptio_log(var,optio_log)

logical,intent(in),optional  :: var !< variabile da controllare
logical,intent(out) :: optio_log

if (present(var))then
  optio_log=var
else
  optio_log=.false.
end if

return
end subroutine soptio_log



end module optional_values
