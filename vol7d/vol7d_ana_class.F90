! Copyright (C) 2010  ARPA-SIM <urpsim@smr.arpa.emr.it>
! authors:
! Davide Cesari <dcesari@arpa.emr.it>
! Paolo Patruno <ppatruno@arpa.emr.it>

! This program is free software; you can redistribute it and/or
! modify it under the terms of the GNU General Public License as
! published by the Free Software Foundation; either version 2 of 
! the License, or (at your option) any later version.

! This program is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.

! You should have received a copy of the GNU General Public License
! along with this program.  If not, see <http://www.gnu.org/licenses/>.
#include "config.h"

!> Classe per la gestione dell'anagrafica di stazioni meteo e affini.
!! Questo modulo definisce una classe in grado di rappresentare
!! le caratteristiche di una stazione meteo fissa o mobile.
!! \ingroup vol7d
MODULE vol7d_ana_class
USE kinds
USE missing_values
USE geo_coord_class
IMPLICIT NONE

!> Lunghezza della stringa che indica l'identificativo del volo.
INTEGER,PARAMETER :: vol7d_ana_lenident=20

!> Definisce l'anagrafica di una stazione.
!! I membri di \a vol7d_ana sono pubblici e quindi liberamente
!! accessibili e scrivibili, ma � comunque consigliato assegnarli tramite
!! il costruttore ::init.
TYPE vol7d_ana
  TYPE(geo_coord) :: coord !< coordinata per una stazione fissa
  CHARACTER(len=vol7d_ana_lenident) :: ident !< identificativo per una stazione mobile (es. aereo)
END TYPE  vol7d_ana

!> Valore mancante per vo7d_ana.
TYPE(vol7d_ana),PARAMETER :: vol7d_ana_miss=vol7d_ana(geo_coord_miss,cmiss)

!> Costruttore per la classe vol7d_ana.
!! Deve essere richiamato 
!! per tutti gli oggetti di questo tipo definiti in un programma.
INTERFACE init
  MODULE PROCEDURE vol7d_ana_init
END INTERFACE

!> Distruttore per la classe vol7d_ana.
!! Distrugge l'oggetto in maniera pulita, assegnandogli un valore mancante.
INTERFACE delete
  MODULE PROCEDURE vol7d_ana_delete
END INTERFACE

!> Logical equality operator for objects of \a vol7d_ana class.
!! It is defined as \a ELEMENTAL thus it works also with conformal arrays
!! of any shape.
INTERFACE OPERATOR (==)
  MODULE PROCEDURE vol7d_ana_eq
END INTERFACE

!> Logical inequality operator for objects of \a vol7d_ana class.
!! It is defined as \a ELEMENTAL thus it works also with conformal arrays
!! of any shape.
INTERFACE OPERATOR (/=)
  MODULE PROCEDURE vol7d_ana_ne
END INTERFACE


!> Logical greater-than operator for objects of \a vol7d_ana class.
!! It is defined as \a ELEMENTAL thus it works also with conformal arrays
!! of any shape.
!! Comparison is performed first on \a ident, then on coord
INTERFACE OPERATOR (>)
  MODULE PROCEDURE vol7d_ana_gt
END INTERFACE

!> Logical less-than operator for objects of \a vol7d_ana class.
!! It is defined as \a ELEMENTAL thus it works also with conformal arrays
!! of any shape.
!! Comparison is performed first on \a ident, then on coord
INTERFACE OPERATOR (<)
  MODULE PROCEDURE vol7d_ana_lt
END INTERFACE

!> Logical greater-equal operator for objects of \a vol7d_ana class.
!! It is defined as \a ELEMENTAL thus it works also with conformal arrays
!! of any shape.
!! Comparison is performed first on \a ident, then on coord
INTERFACE OPERATOR (>=)
  MODULE PROCEDURE vol7d_ana_ge
END INTERFACE

!> Logical less-equal operator for objects of \a vol7d_ana class.
!! It is defined as \a ELEMENTAL thus it works also with conformal arrays
!! of any shape.
!! Comparison is performed first on \a ident, then on coord
INTERFACE OPERATOR (<=)
  MODULE PROCEDURE vol7d_ana_le
END INTERFACE


!> check for missing value
INTERFACE c_e
  MODULE PROCEDURE vol7d_ana_c_e
END INTERFACE

!> Legge un oggetto vol7d_ana o un vettore di oggetti vol7d_ana da
!! un file \c FORMATTED o \c UNFORMATTED.
INTERFACE read_unit
  MODULE PROCEDURE vol7d_ana_read_unit, vol7d_ana_vect_read_unit
END INTERFACE

!> Scrive un oggetto vol7d_ana o un vettore di oggetti vol7d_ana su
!! un file \c FORMATTED o \c UNFORMATTED.
INTERFACE write_unit
  MODULE PROCEDURE vol7d_ana_write_unit, vol7d_ana_vect_write_unit
END INTERFACE

#define VOL7D_POLY_TYPE TYPE(vol7d_ana)
#define VOL7D_POLY_TYPES _ana
#define ENABLE_SORT
#include "array_utilities_pre.F90"

!> Represent ana object in a pretty string
INTERFACE to_char
  MODULE PROCEDURE to_char_ana
END INTERFACE

!> Print object
INTERFACE display
  MODULE PROCEDURE display_ana
END INTERFACE

CONTAINS

!> Inizializza un oggetto \a vol7d_ana con i parametri opzionali forniti.
!! Se non viene passato nessun parametro opzionale l'oggetto �
!! inizializzato a valore mancante.
SUBROUTINE vol7d_ana_init(this, lon, lat, ident, ilon, ilat)
TYPE(vol7d_ana),INTENT(INOUT) :: this !< oggetto da inizializzare
REAL(kind=fp_geo),INTENT(in),OPTIONAL :: lon !< longitudine
REAL(kind=fp_geo),INTENT(in),OPTIONAL :: lat !< latitudine
CHARACTER(len=*),INTENT(in),OPTIONAL :: ident !< identificativo del volo
INTEGER(kind=int_l),INTENT(in),OPTIONAL :: ilon !< integer longitude (nint(lon*1.d5)
INTEGER(kind=int_l),INTENT(in),OPTIONAL :: ilat !< integer latitude (nint(lat*1.d5)

CALL init(this%coord, lon=lon, lat=lat , ilon=ilon, ilat=ilat)
IF (PRESENT(ident)) THEN
  this%ident = ident
ELSE
  this%ident = cmiss
ENDIF

END SUBROUTINE vol7d_ana_init


!> Distrugge l'oggetto in maniera pulita, assegnandogli un valore mancante.
SUBROUTINE vol7d_ana_delete(this)
TYPE(vol7d_ana),INTENT(INOUT) :: this !< oggetto da distruggre

CALL delete(this%coord)
this%ident = cmiss

END SUBROUTINE vol7d_ana_delete



character(len=80) function to_char_ana(this)

TYPE(vol7d_ana),INTENT(in) :: this

to_char_ana="ANA: "//&
 to_char(getlon(this%coord),miss="Missing lon",form="(f11.5)")//&
 to_char(getlat(this%coord),miss="Missing lat",form="(f11.5)")//&
 t2c(this%ident,miss="Missing ident")

return

end function to_char_ana


subroutine display_ana(this)

TYPE(vol7d_ana),INTENT(in) :: this

print*, trim(to_char(this))

end subroutine display_ana


ELEMENTAL FUNCTION vol7d_ana_eq(this, that) RESULT(res)
TYPE(vol7d_ana),INTENT(IN) :: this, that
LOGICAL :: res

res = this%coord == that%coord .AND. this%ident == that%ident

END FUNCTION vol7d_ana_eq


ELEMENTAL FUNCTION vol7d_ana_ne(this, that) RESULT(res)
TYPE(vol7d_ana),INTENT(IN) :: this, that
LOGICAL :: res

res = .NOT.(this == that)

END FUNCTION vol7d_ana_ne


ELEMENTAL FUNCTION vol7d_ana_gt(this, that) RESULT(res)
TYPE(vol7d_ana),INTENT(IN) :: this, that
LOGICAL :: res

res = this%ident > that%ident

if ( this%ident == that%ident) then
  res =this%coord > that%coord
end if

END FUNCTION vol7d_ana_gt


ELEMENTAL FUNCTION vol7d_ana_ge(this, that) RESULT(res)
TYPE(vol7d_ana),INTENT(IN) :: this, that
LOGICAL :: res

res = .not. this < that

END FUNCTION vol7d_ana_ge


ELEMENTAL FUNCTION vol7d_ana_lt(this, that) RESULT(res)
TYPE(vol7d_ana),INTENT(IN) :: this, that
LOGICAL :: res

res = this%ident < that%ident

if ( this%ident == that%ident) then
  res = this%coord < that%coord
end if

END FUNCTION vol7d_ana_lt


ELEMENTAL FUNCTION vol7d_ana_le(this, that) RESULT(res)
TYPE(vol7d_ana),INTENT(IN) :: this, that
LOGICAL :: res

res = .not. (this > that)

END FUNCTION vol7d_ana_le



ELEMENTAL FUNCTION vol7d_ana_c_e(this) RESULT(c_e)
TYPE(vol7d_ana),INTENT(IN) :: this
LOGICAL :: c_e
c_e = this /= vol7d_ana_miss
END FUNCTION vol7d_ana_c_e


!> This method reads from a Fortran file unit the contents of the
!! object \a this.  The record to be read must have been written with
!! the ::write_unit method.  The method works both on formatted and
!! unformatted files.
SUBROUTINE vol7d_ana_read_unit(this, unit)
TYPE(vol7d_ana),INTENT(out) :: this !< object to be read
INTEGER, INTENT(in) :: unit !< unit from which to read, it must be an opened Fortran file unit

CALL vol7d_ana_vect_read_unit((/this/), unit)

END SUBROUTINE vol7d_ana_read_unit


!> This method reads from a Fortran file unit the contents of the
!! object \a this.  The record to be read must have been written with
!! the ::write_unit method.  The method works both on formatted and
!! unformatted files.
SUBROUTINE vol7d_ana_vect_read_unit(this, unit)
TYPE(vol7d_ana) :: this(:) !< object to be read
INTEGER, INTENT(in) :: unit !< unit from which to read, it must be an opened Fortran file unit

CHARACTER(len=40) :: form

CALL read_unit(this%coord, unit)
INQUIRE(unit, form=form)
IF (form == 'FORMATTED') THEN
  READ(unit,'(A)')this(:)%ident
ELSE
  READ(unit)this(:)%ident
ENDIF

END SUBROUTINE vol7d_ana_vect_read_unit


!> This method writes on a Fortran file unit the contents of the
!! object \a this.  The record can successively be read by the
!! ::read_unit method.  The method works both on formatted and
!! unformatted files.
SUBROUTINE vol7d_ana_write_unit(this, unit)
TYPE(vol7d_ana),INTENT(in) :: this !< object to be written
INTEGER, INTENT(in) :: unit !< unit where to write, it must be an opened Fortran file unit

CALL vol7d_ana_vect_write_unit((/this/), unit)

END SUBROUTINE vol7d_ana_write_unit


!> This method writes on a Fortran file unit the contents of the
!! object \a this.  The record can successively be read by the
!! ::read_unit method.  The method works both on formatted and
!! unformatted files.
SUBROUTINE vol7d_ana_vect_write_unit(this, unit)
TYPE(vol7d_ana),INTENT(in) :: this(:) !< object to be written
INTEGER, INTENT(in) :: unit !< unit where to write, it must be an opened Fortran file unit

CHARACTER(len=40) :: form

CALL write_unit(this%coord, unit)
INQUIRE(unit, form=form)
IF (form == 'FORMATTED') THEN
  WRITE(unit,'(A)')this(:)%ident
ELSE
  WRITE(unit)this(:)%ident
ENDIF

END SUBROUTINE vol7d_ana_vect_write_unit


#include "array_utilities_inc.F90"


END MODULE vol7d_ana_class
