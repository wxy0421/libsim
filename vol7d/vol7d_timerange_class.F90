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

!> Classe per la gestione degli intervalli temporali di osservazioni
!! meteo e affini.
!! Questo modulo definisce una classe in grado di rappresentare
!! l'intervallo di tempo a cui si riferisce un'osservazione meteo,
!! ad es. valore istantaneo, cumulato, medio, ecc., prendendo in prestito
!! concetti dal formato grib.
!! \ingroup vol7d
MODULE vol7d_timerange_class
USE kinds
USE missing_values
use char_utilities
IMPLICIT NONE

!> Definisce l'intervallo temporale di un'osservazione meteo.
!! I membri di \a vol7d_timerange sono pubblici e quindi liberamente
!! accessibili e scrivibili, ma � comunque consigliato assegnarli tramite
!! il costruttore ::init.
TYPE vol7d_timerange
  INTEGER :: timerange !< propriet� statistiche del dato (es. 0=media, 1=cumulazione, 2=massimo, 3=minimo, 4=differenza... 254=dato istantaneo) tratte dalla code table 4.10 del formato WMO grib edizione 2, vedi http://www.wmo.int/pages/prog/www/WMOCodes/WMO306_vI2/LatestVERSION/WMO306_vI2_GRIB2_CodeFlag_en.pdf
  INTEGER :: p1 !< termine del periodo di validit� del dato, in secondi, a partire dall'istante di riferimento (0 per dati osservati o analizzati)
  INTEGER :: p2 !< durata del periodo di validit� del dato, in secondi (0 per dati istantanei)
END TYPE vol7d_timerange

!> Valore mancante per vol7d_timerange.
TYPE(vol7d_timerange),PARAMETER :: vol7d_timerange_miss= &
 vol7d_timerange(imiss,imiss,imiss)

!> Costruttore per la classe vol7d_timerange.
!! Deve essere richiamato 
!! per tutti gli oggetti di questo tipo definiti in un programma.
INTERFACE init
  MODULE PROCEDURE vol7d_timerange_init
END INTERFACE

!> Distruttore per la classe vol7d_timerange.
!! Distrugge l'oggetto in maniera pulita, assegnandogli un valore mancante.
INTERFACE delete
  MODULE PROCEDURE vol7d_timerange_delete
END INTERFACE

!> Logical equality operator for objects of \a vol7d_timerange class.
!! It is defined as \a ELEMENTAL thus it works also with conformal arrays
!! of any shape.
INTERFACE OPERATOR (==)
  MODULE PROCEDURE vol7d_timerange_eq
END INTERFACE

!> Logical inequality operator for objects of \a vol7d_timerange class.
!! It is defined as \a ELEMENTAL thus it works also with conformal arrays
!! of any shape.
INTERFACE OPERATOR (/=)
  MODULE PROCEDURE vol7d_timerange_ne
END INTERFACE

!> Logical greater-than operator for objects of \a vol7d_timerange class.
!! It is defined as \a ELEMENTAL thus it works also with conformal arrays
!! of any shape.
INTERFACE OPERATOR (>)
  MODULE PROCEDURE vol7d_timerange_gt
END INTERFACE

!> Logical less-than operator for objects of \a vol7d_timerange class.
!! It is defined as \a ELEMENTAL thus it works also with conformal arrays
!! of any shape.
INTERFACE OPERATOR (<)
  MODULE PROCEDURE vol7d_timerange_lt
END INTERFACE

!> Logical greater-equal operator for objects of \a vol7d_timerange class.
!! It is defined as \a ELEMENTAL thus it works also with conformal arrays
!! of any shape.
INTERFACE OPERATOR (>=)
  MODULE PROCEDURE vol7d_timerange_ge
END INTERFACE

!> Logical less-equal operator for objects of \a vol7d_timerange class.
!! It is defined as \a ELEMENTAL thus it works also with conformal arrays
!! of any shape.
INTERFACE OPERATOR (<=)
  MODULE PROCEDURE vol7d_timerange_le
END INTERFACE

!> Logical almost equality operator for objects of \a vol7d_timerange class.
!! If one component is missing it is not used in comparison.
INTERFACE OPERATOR (.almosteq.)
  MODULE PROCEDURE vol7d_timerange_almost_eq
END INTERFACE


! da documentare in inglese assieme al resto
!> to be documented
INTERFACE c_e
  MODULE PROCEDURE vol7d_timerange_c_e
END INTERFACE

#define VOL7D_POLY_TYPE TYPE(vol7d_timerange)
#define VOL7D_POLY_TYPES _timerange
#define ENABLE_SORT
#include "array_utilities_pre.F90"

!>Print object
INTERFACE display
  MODULE PROCEDURE display_timerange
END INTERFACE

!>Represent timerange object in a pretty string
INTERFACE to_char
  MODULE PROCEDURE to_char_timerange
END INTERFACE

#define ARRAYOF_ORIGTYPE TYPE(vol7d_timerange)
#define ARRAYOF_TYPE arrayof_vol7d_timerange
#define ARRAYOF_ORIGEQ 1
#include "arrayof_pre.F90"


type(vol7d_timerange) :: almost_equal_timeranges(2)=(/&
 vol7d_timerange(254,0,imiss),&
 vol7d_timerange(3,0,3600)/)


! from arrayof
PUBLIC insert, append, remove, packarray
PUBLIC insert_unique, append_unique
PUBLIC almost_equal_timeranges

CONTAINS


!> Inizializza un oggetto \a vol7d_timerange con i parametri opzionali forniti.
!! Questa � la versione \c FUNCTION, in stile F2003, del costruttore, da preferire
!! rispetto alla versione \c SUBROUTINE \c init.
!! Se non viene passato nessun parametro opzionale l'oggetto �
!! inizializzato a valore mancante.
FUNCTION vol7d_timerange_new(timerange, p1, p2) RESULT(this)
INTEGER,INTENT(IN),OPTIONAL :: timerange !< tipo di intervallo temporale
INTEGER,INTENT(IN),OPTIONAL :: p1 !< valore per il primo istante temporale
INTEGER,INTENT(IN),OPTIONAL :: p2 !< valore per il secondo istante temporale

TYPE(vol7d_timerange) :: this !< oggetto da inizializzare

CALL init(this, timerange, p1, p2)

END FUNCTION vol7d_timerange_new


!> Inizializza un oggetto \a vol7d_timerange con i parametri opzionali forniti.
!! Se non viene passato nessun parametro opzionale l'oggetto �
!! inizializzato a valore mancante.
SUBROUTINE vol7d_timerange_init(this, timerange, p1, p2)
TYPE(vol7d_timerange),INTENT(INOUT) :: this !< oggetto da inizializzare
INTEGER,INTENT(IN),OPTIONAL :: timerange !< tipo di intervallo temporale
INTEGER,INTENT(IN),OPTIONAL :: p1 !< valore per il primo istante temporale
INTEGER,INTENT(IN),OPTIONAL :: p2 !< valore per il secondo istante temporale

IF (PRESENT(timerange)) THEN
  this%timerange = timerange
ELSE
  this%timerange = imiss
  this%p1 = imiss
  this%p2 = imiss
  RETURN
ENDIF
!!$IF (timerange == 1) THEN ! p1 sempre 0
!!$  this%p1 = 0
!!$  this%p2 = imiss
!!$ELSE IF (timerange == 0 .OR. timerange == 10) THEN ! solo p1
!!$  IF (PRESENT(p1)) THEN
!!$    this%p1 = p1
!!$  ELSE
!!$    this%p1 = 0
!!$  ENDIF
!!$  this%p2 = imiss
!!$ELSE ! tutti gli altri
  IF (PRESENT(p1)) THEN
    this%p1 = p1
  ELSE
    this%p1 = imiss
  ENDIF
  IF (PRESENT(p2)) THEN
    this%p2 = p2
  ELSE
    this%p2 = imiss
  ENDIF
!!$END IF

END SUBROUTINE vol7d_timerange_init


!> Distrugge l'oggetto in maniera pulita, assegnandogli un valore mancante.
SUBROUTINE vol7d_timerange_delete(this)
TYPE(vol7d_timerange),INTENT(INOUT) :: this

this%timerange = imiss
this%p1 = imiss
this%p2 = imiss

END SUBROUTINE vol7d_timerange_delete


SUBROUTINE display_timerange(this)
TYPE(vol7d_timerange),INTENT(in) :: this

print*,to_char_timerange(this)

END SUBROUTINE display_timerange


FUNCTION to_char_timerange(this)
#ifdef HAVE_DBALLE
#ifdef HAVE_DBALLEF_MOD
USE dballef
#else
include 'dballeff.h'
#endif
#endif
TYPE(vol7d_timerange),INTENT(in) :: this
CHARACTER(len=80) :: to_char_timerange

#ifdef HAVE_DBALLE
INTEGER :: handle, ier

handle = 0
ier = idba_messaggi(handle,"/dev/null", "w", "BUFR")
ier = idba_spiegat(handle,this%timerange,this%p1,this%p2,to_char_timerange)
ier = idba_fatto(handle)

to_char_timerange="Timerange: "//to_char_timerange

#else

to_char_timerange="Timerange: "//trim(to_char(this%timerange))//" P1: "//&
 trim(to_char(this%p1))//" P2: "//trim(to_char(this%p2))

#endif

END FUNCTION to_char_timerange


ELEMENTAL FUNCTION vol7d_timerange_eq(this, that) RESULT(res)
TYPE(vol7d_timerange),INTENT(IN) :: this, that
LOGICAL :: res


res = &
 this%timerange == that%timerange .AND. &
 this%p1 == that%p1 .AND. (this%p2 == that%p2 .OR. &
 this%timerange == 254)

END FUNCTION vol7d_timerange_eq


ELEMENTAL FUNCTION vol7d_timerange_almost_eq(this, that) RESULT(res)
TYPE(vol7d_timerange),INTENT(IN) :: this, that
LOGICAL :: res

IF (.not. c_e(this%timerange) .or. .not. c_e(that%timerange) .or. this%timerange == that%timerange .AND. &
    this%p1 == that%p1 .AND. &
    this%p2 == that%p2) THEN
  res = .TRUE.
ELSE
  res = .FALSE.
ENDIF

END FUNCTION vol7d_timerange_almost_eq


ELEMENTAL FUNCTION vol7d_timerange_ne(this, that) RESULT(res)
TYPE(vol7d_timerange),INTENT(IN) :: this, that
LOGICAL :: res

res = .NOT.(this == that)

END FUNCTION vol7d_timerange_ne


ELEMENTAL FUNCTION vol7d_timerange_gt(this, that) RESULT(res)
TYPE(vol7d_timerange),INTENT(IN) :: this, that
LOGICAL :: res

IF (this%timerange > that%timerange .OR. &
 (this%timerange == that%timerange .AND. this%p1 > that%p1) .OR. &
 (this%timerange == that%timerange .AND. this%p1 == that%p1 .AND. &
 this%p2 > that%p2)) THEN
  res = .TRUE.
ELSE
  res = .FALSE.
ENDIF

END FUNCTION vol7d_timerange_gt


ELEMENTAL FUNCTION vol7d_timerange_lt(this, that) RESULT(res)
TYPE(vol7d_timerange),INTENT(IN) :: this, that
LOGICAL :: res

IF (this%timerange < that%timerange .OR. &
 (this%timerange == that%timerange .AND. this%p1 < that%p1) .OR. &
 (this%timerange == that%timerange .AND. this%p1 == that%p1 .AND. &
 this%p2 < that%p2)) THEN
  res = .TRUE.
ELSE
  res = .FALSE.
ENDIF

END FUNCTION vol7d_timerange_lt


ELEMENTAL FUNCTION vol7d_timerange_ge(this, that) RESULT(res)
TYPE(vol7d_timerange),INTENT(IN) :: this, that
LOGICAL :: res

IF (this == that) THEN
  res = .TRUE.
ELSE IF (this > that) THEN
  res = .TRUE.
ELSE
  res = .FALSE.
ENDIF

END FUNCTION vol7d_timerange_ge


ELEMENTAL FUNCTION vol7d_timerange_le(this, that) RESULT(res)
TYPE(vol7d_timerange),INTENT(IN) :: this, that
LOGICAL :: res

IF (this == that) THEN
  res = .TRUE.
ELSE IF (this < that) THEN
  res = .TRUE.
ELSE
  res = .FALSE.
ENDIF

END FUNCTION vol7d_timerange_le


ELEMENTAL FUNCTION vol7d_timerange_c_e(this) RESULT(c_e)
TYPE(vol7d_timerange),INTENT(IN) :: this
LOGICAL :: c_e
c_e = this /= vol7d_timerange_miss
END FUNCTION vol7d_timerange_c_e


#include "array_utilities_inc.F90"

#include "arrayof_post.F90"


END MODULE vol7d_timerange_class
