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
!> \defgroup qc Libsim package, qc library.
!! Procedures for data quality control.
!! At the moment only climatological quality control is implemented

!> Utilities and defines for quality control.
!! 
!! Concise, high-value definitions of Data Quality by expert users,
!! analysts, implementers and journalists. This is a great starting point
!! to learn about Data Quality.
!! 
!! Data Quality: The Accuracy Dimension
!! 
!! "Data quality is defined as follows: data has quality if it satisfies
!! the requirements of its intended use. It lacks quality to the extent
!! that it does not satisfy the requirement. In other words, data quality
!! depends as much on the intended use as it does on the data itself. To
!! satisfy the intended use, the data must be accurate, timely, relevant,
!! complete, understood, and trusted."  Jack E. Olson
!! 
!! No Data Left Behind: Federal Student Aid - A Case History
!! 
!! "Data quality institutionalizes a set of repeatable processes to
!! continuously monitor data and improve data accuracy, completeness,
!! timeliness and relevance."  Holly Hyland and Lisa Elliott, Federal
!! Student Aid
!! 
!! Data Quality: It's a Family Affair
!! 
!! Data Quality definition: "The state of completeness, consistency,
!! timeliness and accuracy that makes data appropriate for a specific
!! use."  Wim Helmer, Dun & Bradstreet
!! 
!! Data Quality and Quality Management - Examples of Quality Evaluation
!! Procedures and Quality Management in European National Mapping
!! Agencies
!! 
!! "Quality is defined as the totality of characteristics of a product
!! that bear on its ability to satisfy stated and implied needs (ISO
!! 8402, 1994). In the new ISO/DIS 9000:2000 standard (2000) the
!! definition of quality is: 'Ability of a set of inherent
!! characteristics of a product, system or process to fulfill
!! requirements of customers and other interested parties.' This
!! indicates that data quality and quality management are very closely
!! related. Data quality is part of the organisation's total quality
!! management." Antti Jakobsson
!! 
!! text below from Wikipedia
!! http://it.wikipedia.org/wiki/Test_di_verifica_d%27ipotesi
!! http://creativecommons.org/licenses/by-sa/3.0/deed.it
!!  L'ambito statistico
!! 
!! Nel secondo caso la situazione � modificata in quanto interviene un
!! elemento nuovo, ovvero il caso. Si supponga di avere una moneta
!! recante due facce contrassegnate con testa e croce. Volendo verificare
!! l'ipotesi di bilanciamento della moneta si eseguono 20 lanci e si
!! contano quelli che danno esito testa. La conseguenza del bilanciamento
!! consiste nell'osservare un valore di teste attorno a 10. Tuttavia
!! anche in ipotesi di bilanciamento non si pu� escludere di osservare 20
!! teste. D'altronde, l'ipotesi di bilanciamento � logicamente
!! compatibile con un numero di teste variante da 0 a 20. In tale
!! contesto una qualsiasi decisione in merito all'ipotesi da verificare
!! comporta un rischio di errore. Ad esempio rigettare l'ipotesi di
!! bilanciamento della moneta avendo osservato 20 teste su 20 lanci
!! comporta il rischio di prendere una decisione errata. Nel procedere
!! alla verifica dell'ipotesi di bilanciamento della moneta, si ricorre a
!! una variabile casuale X. Tale variabile casuale X � una variabile
!! aleatoria discreta con distribuzione binomiale B(20; 0,5), dove 20
!! indica il numero di lanci e 0,5 la probabilit� che si verifichi
!! l'evento "testa".
!! 
!! Il risultato sperimentale si deve quindi confrontare con tale
!! distribuzione: quanto � distante tale risultato dal valore medio della
!! distribuzione B(20; 0,5)? Per rispondere alla domanda si deve
!! individuare un valore caratteristico della distribuzione B(20;
!! 0,5). Nel nostro caso tale valore caratteristico � il valore medio
!! 20/2 = 10. Per valutare la distanza tra il valore sperimentale e
!! quello atteso si valuta la probabilit� di ottenere un valore
!! sperimentale lontano dal valore medio di B(20; 0,5), ossia nel caso
!! che dal nostro esperimento risulti X=15 (15 teste dopo 20 lanci), si
!! calcola P{|X-10|>=15-10} quindi P{X<=5 oppure X>=15}=0,041.
!! 
!! Quindi, usando una moneta ben bilanciata, la probabilit� di ottenere
!! un numero di teste X >= 15 (oppure X <= 5) dopo 20 lanci � pari a
!! 0,041 ossia al 4,1%. Giudicando bassa tale probabilit� si rifiuter�
!! l'ipotesi di bilanciamento della moneta in esame, accettando quindi il
!! rischio del 4,1% di compiere un errore nel rifiutarla. Di solito, il
!! valore della probabilit� adottato per rifiutare l'ipotesi nulla � <
!! 0,05. Tale valore � detto livello di significativit� ed � definibile
!! come segue: il livello di significativit� sotto l'ipotesi nulla � la
!! probabilit� di cadere nella zona di rifiuto quando l'ipotesi nulla �
!! vera. Tale livello di significativit� si indica convenzionalmente con
!! α. Il livello di significativit� osservato α del test per il quale si
!! rifiuterebbe l'ipotesi nulla � detto valore-p (p-value). Riprendendo
!! l'esempio sopra riportato il valore-p � pari a 0,041. Adottando
!! nell'esempio α = 0,05, si rifiuter� l'ipotesi se
!! P{|X-10|>=x}<0,05. Tale condizione si raggiunge appunto se X<6 oppure
!! X>14. Tale insieme di valori si definisce convenzionalmente come
!! regione di rifiuto. Viceversa l'insieme { 6,7...14} si definisce regione
!! di accettazione. In questo modo si � costruita una regola di
!! comportamento per verificare l'ipotesi di bilanciamento della
!! moneta. Tale regola definisce il test statistico.
!! 
!! In termini tecnici l'ipotesi da verificare si chiama ipotesi nulla e
!! si indica con H0, mentre l'ipotesi alternativa con H1. Nel caso della
!! moneta, se p � la probabilit� di ottenere testa in un lancio la
!! verifica di ipotesi si traduce nel seguente sistema:
!! 
!!     H_0: p = \frac{1}{2}
!!     H_1: p \ne \frac{1}{2}
!! 
!! Come gi� osservato, il modo di condurre un test statistico comporta un
!! rischio di errore. Nella pratica statistica si individuano due tipi di
!! errori:
!! 
!!    1. rifiutare H0 quando � vera, errore di primo tipo (α) (o errore di prima specie);
!!    2. accettare H0 quando � falsa, errore di secondo tipo (β) (o errore di seconda specie).
!! 
!! Tornando all'esempio della moneta in cui la regione di accettazione �
!! data dall'insieme di valori {6..14}, la probabilit� di rifiutare H0
!! quando � vera � stato calcolato pari a 0,041.Tale probabilit�
!! rappresenta il rischio di incorrere in un errore di primo tipo e si
!! indica con α. Per valutare la probabilit� di un errore di secondo tipo
!! � necessario specificare un valore di p in caso di verit� di H1. Si
!! supponga che p=0,80, in tal caso la distribuzione di X � una
!! B(20;0,80)
!! 
!! Con tale distribuzione di probabilit�, l'errore di tipo 2 si calcola
!! sommando le probabilit� relative ai valori di X della zona di
!! accettazione. Si trova quindi che la probabilit� cercata � pari a
!! circa 0,20. Tale probabilit� quantifica il rischio di incorrere
!! nell'errore di tipo 2. e si indica convenzionalmente con β. La
!! quantit� 1-β si chiama potenza del test ed esprime quindi la capacit�
!! di un test statistico riconoscere la falsit� di H0 quando questa �
!! effettivamente falsa. La potenza del test trova applicazione nella
!! pratica statistica in fase di pianificazione di un esperimento.
!!
!!Scope of quality checks on observation values
!!Checks applied to determine the quality of an observation can range from the very simple to the
!!very complex. In roughly increasing order of complexity they can include:
!! * Syntactic checks (e.g. an air temperature must be a number to at most 1 decimal
!!   place);
!! * Numeric ranges (e.g. the temperature must fall in the range -90 to +70);
!! * Climate range checks (i.e. is the datum consistent with climatology?)
!! * Intra-record consistency (e.g. the air temperature must not be less than the dew
!!   point);
!! * Time-series consistency (e.g. the difference between two successive temperatures at
!!   a site must be 'plausible'); and
!! * Spatial consistency (e.g. the station-dependent limits of plausible difference between
!!   the temperatures at a station and its neighbours must not be violated).
!!\ingroup qc
module modqc
use kinds
use missing_values
use optional_values
use vol7d_class


implicit none


!> Definisce il livello di attendibilit� per i dati validi
type :: qcpartype
  integer (kind=int_b):: att !< confidence for "*B33192" "*B33193" "*B33194"
  integer (kind=int_b):: gross_error ! special valuer for "*B33192" when gross error check failed
  integer (kind=int_b):: invalidated ! special valuer for "*B33196" when manual invalidation happen
end type qcpartype

!> Default: data with confidence less or equal 10 are rejected
type(qcpartype)  :: qcpar=qcpartype(10_int_b,0_int_b,1_int_b)

integer, parameter :: nqcattrvars=4
CHARACTER(len=10),parameter :: qcattrvarsbtables(nqcattrvars)=(/"*B33196","*B33192","*B33193","*B33194"/)

type :: qcattrvars
  TYPE(vol7d_var) :: vars(nqcattrvars)
  CHARACTER(len=10)   :: btables(nqcattrvars)
end type qcattrvars

!> Variables user in Quality Control
interface init
  module procedure init_qcattrvars
end interface

!> Remove data under a defined grade of confidence.
interface peeled
  module procedure peeledrb, peeleddb, peeledbb, peeledib, peeledcb &
                  ,peeledri, peeleddi, peeledbi, peeledii, peeledci &
                  ,peeledrr, peeleddr, peeledbr, peeledir, peeledcr &
                  ,peeledrd, peeleddd, peeledbd, peeledid, peeledcd &
                  ,peeledrc, peeleddc, peeledbc, peeledic, peeledcc
end interface


!> Check data validity based on single confidence
interface vd
  module procedure vdi,vdb,vdr,vdd,vdc
end interface

!> Check data validity based on gross error check
interface vdge
  module procedure vdgei,vdgeb,vdger,vdged,vdgec
end interface

!> Test di dato invalidato
interface invalidated
  module procedure invalidatedi,invalidatedb,invalidatedr,invalidatedd,invalidatedc
end interface

private

public vd, vdge, init, qcattrvars_new, invalidated, peeled, vol7d_peeling
public qcattrvars, nqcattrvars, qcattrvarsbtables
public qcpar, qcpartype, qcsummaryflagb ! ,qcsummaryflagi

contains


! peeled routines
#undef VOL7D_POLY_SUBTYPE
#undef VOL7D_POLY_SUBTYPES
#undef VOL7D_POLY_ISC
#define VOL7D_POLY_SUBTYPE REAL
#define VOL7D_POLY_SUBTYPES r

#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_ISC
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE REAL
#define VOL7D_POLY_TYPES r
#define VOL7D_POLY_TYPES_SUBTYPES rr
#include "modqc_peeled_include.F90"
#include "modqc_peel_util_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE DOUBLE PRECISION
#define VOL7D_POLY_TYPES d
#define VOL7D_POLY_TYPES_SUBTYPES dr
#include "modqc_peeled_include.F90"
#include "modqc_peel_util_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE INTEGER
#define VOL7D_POLY_TYPES i
#define VOL7D_POLY_TYPES_SUBTYPES ir
#include "modqc_peeled_include.F90"
#include "modqc_peel_util_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE INTEGER(kind=int_b)
#define VOL7D_POLY_TYPES b
#define VOL7D_POLY_TYPES_SUBTYPES br
#include "modqc_peeled_include.F90"
#include "modqc_peel_util_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE CHARACTER(len=vol7d_cdatalen)
#define VOL7D_POLY_TYPES c
#define VOL7D_POLY_ISC = 1
#define VOL7D_POLY_TYPES_SUBTYPES cr
#include "modqc_peeled_include.F90"
#include "modqc_peel_util_include.F90"


#undef VOL7D_POLY_SUBTYPE
#undef VOL7D_POLY_SUBTYPES
#undef VOL7D_POLY_ISC
#define VOL7D_POLY_SUBTYPE DOUBLE PRECISION
#define VOL7D_POLY_SUBTYPES d

#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE REAL
#define VOL7D_POLY_TYPES r
#define VOL7D_POLY_TYPES_SUBTYPES rd
#include "modqc_peeled_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE DOUBLE PRECISION
#define VOL7D_POLY_TYPES d
#define VOL7D_POLY_TYPES_SUBTYPES dd
#include "modqc_peeled_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE INTEGER
#define VOL7D_POLY_TYPES i
#define VOL7D_POLY_TYPES_SUBTYPES id
#include "modqc_peeled_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE INTEGER(kind=int_b)
#define VOL7D_POLY_TYPES b
#define VOL7D_POLY_TYPES_SUBTYPES bd
#include "modqc_peeled_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE CHARACTER(len=vol7d_cdatalen)
#define VOL7D_POLY_TYPES c
#define VOL7D_POLY_TYPES_SUBTYPES cd
#include "modqc_peeled_include.F90"


#undef VOL7D_POLY_SUBTYPE
#undef VOL7D_POLY_SUBTYPES
#undef VOL7D_POLY_ISC
#define VOL7D_POLY_SUBTYPE INTEGER
#define VOL7D_POLY_SUBTYPES i

#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE REAL
#define VOL7D_POLY_TYPES r
#define VOL7D_POLY_TYPES_SUBTYPES ri
#include "modqc_peeled_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE DOUBLE PRECISION
#define VOL7D_POLY_TYPES d
#define VOL7D_POLY_TYPES_SUBTYPES di
#include "modqc_peeled_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE INTEGER
#define VOL7D_POLY_TYPES i
#define VOL7D_POLY_TYPES_SUBTYPES ii
#include "modqc_peeled_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE INTEGER(kind=int_b)
#define VOL7D_POLY_TYPES b
#define VOL7D_POLY_TYPES_SUBTYPES bi
#include "modqc_peeled_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE CHARACTER(len=vol7d_cdatalen)
#define VOL7D_POLY_TYPES c
#define VOL7D_POLY_ISC = 1
#define VOL7D_POLY_TYPES_SUBTYPES ci
#include "modqc_peeled_include.F90"


#undef VOL7D_POLY_SUBTYPE
#undef VOL7D_POLY_SUBTYPES
#undef VOL7D_POLY_ISC
#define VOL7D_POLY_SUBTYPE INTEGER(kind=int_b)
#define VOL7D_POLY_SUBTYPES b

#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE REAL
#define VOL7D_POLY_TYPES r
#define VOL7D_POLY_TYPES_SUBTYPES rb
#include "modqc_peeled_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE DOUBLE PRECISION
#define VOL7D_POLY_TYPES d
#define VOL7D_POLY_TYPES_SUBTYPES db
#include "modqc_peeled_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE INTEGER
#define VOL7D_POLY_TYPES i
#define VOL7D_POLY_TYPES_SUBTYPES ib
#include "modqc_peeled_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE INTEGER(kind=int_b)
#define VOL7D_POLY_TYPES b
#define VOL7D_POLY_TYPES_SUBTYPES bb
#include "modqc_peeled_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE CHARACTER(len=vol7d_cdatalen)
#define VOL7D_POLY_TYPES c
#define VOL7D_POLY_ISC = 1
#define VOL7D_POLY_TYPES_SUBTYPES cb
#include "modqc_peeled_include.F90"


#undef VOL7D_POLY_SUBTYPE
#undef VOL7D_POLY_SUBTYPES
#undef VOL7D_POLY_ISC
#define VOL7D_POLY_SUBTYPE CHARACTER(len=vol7d_cdatalen)
#define VOL7D_POLY_SUBTYPES c

#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE REAL
#define VOL7D_POLY_TYPES r
#define VOL7D_POLY_TYPES_SUBTYPES rc
#include "modqc_peeled_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE DOUBLE PRECISION
#define VOL7D_POLY_TYPES d
#define VOL7D_POLY_TYPES_SUBTYPES dc
#include "modqc_peeled_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE INTEGER
#define VOL7D_POLY_TYPES i
#define VOL7D_POLY_TYPES_SUBTYPES ic
#include "modqc_peeled_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE INTEGER(kind=int_b)
#define VOL7D_POLY_TYPES b
#define VOL7D_POLY_TYPES_SUBTYPES bc
#include "modqc_peeled_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#undef VOL7D_POLY_TYPES_SUBTYPES
#define VOL7D_POLY_TYPE CHARACTER(len=vol7d_cdatalen)
#define VOL7D_POLY_TYPES c
#define VOL7D_POLY_ISC = 1
#define VOL7D_POLY_TYPES_SUBTYPES cc
#include "modqc_peeled_include.F90"


subroutine init_qcattrvars(this)

type(qcattrvars),intent(inout) :: this
integer :: i

this%btables(:) =qcattrvarsbtables
do i =1, nqcattrvars
  call init(this%vars(i),this%btables(i))
end do

end subroutine init_qcattrvars


type(qcattrvars) function  qcattrvars_new()

call init(qcattrvars_new)

end function qcattrvars_new


!> Remove data under the predefined grade of confidence.
!! If neither \a keep_attr nor \a delete_attr are passed, all the
!! attributes will be deleted after peeling; if \a keep_attr is
!! provided, only attributed listed in \a keep_attr will be kept in
!! output, (\a delete_attr will be ignored); if \a delete_attr is
!! provided, attributed listed in \a delete_attr will be deleted from
!! output.
SUBROUTINE vol7d_peeling(this, data_id, keep_attr, delete_attr, preserve, purgeana)
TYPE(vol7d),INTENT(INOUT)  :: this !< object that has to be peeled
integer,INTENT(inout),pointer,OPTIONAL :: data_id(:,:,:,:,:) !< data ID to use with dballe DB (for fast write of attributes)
CHARACTER(len=*),INTENT(in),OPTIONAL :: keep_attr(:) !< Btable of attributes that should be kept after removing data
CHARACTER(len=*),INTENT(in),OPTIONAL :: delete_attr(:) !< Btable of attributes that should be deleted after removing data
logical,intent(in),optional :: preserve !< preserve all attributes if true (alternative to keep_attr and delete_attr)
logical,intent(in),optional :: purgeana !< if true remove ana with all data missing

integer :: inddativar,inddatiattrinv,inddatiattrcli,inddatiattrtem,inddatiattrspa,inddativarattr
type(qcattrvars) :: attrvars

INTEGER(kind=int_b),pointer :: invbb(:,:,:,:,:),clibb(:,:,:,:,:),tembb(:,:,:,:,:),spabb(:,:,:,:,:)
INTEGER,pointer             :: invbi(:,:,:,:,:),clibi(:,:,:,:,:),tembi(:,:,:,:,:),spabi(:,:,:,:,:)
REAL,pointer                :: invbr(:,:,:,:,:),clibr(:,:,:,:,:),tembr(:,:,:,:,:),spabr(:,:,:,:,:)
DOUBLE PRECISION,pointer    :: invbd(:,:,:,:,:),clibd(:,:,:,:,:),tembd(:,:,:,:,:),spabd(:,:,:,:,:)
CHARACTER(len=vol7d_cdatalen),pointer :: invbc(:,:,:,:,:),clibc(:,:,:,:,:),tembc(:,:,:,:,:),spabc(:,:,:,:,:)

call l4f_log(L4F_INFO,'starting peeling')

call init(attrvars)

! generate code per i vari tipi di dati di v7d
! tramite un template e il preprocessore


#undef VOL7D_POLY_SUBTYPE
#undef VOL7D_POLY_SUBTYPES
#define VOL7D_POLY_SUBTYPE REAL
#define VOL7D_POLY_SUBTYPES r

#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE REAL
#define VOL7D_POLY_TYPES r
#include "modqc_peeling_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE DOUBLE PRECISION
#define VOL7D_POLY_TYPES d
#include "modqc_peeling_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE INTEGER
#define VOL7D_POLY_TYPES i
#include "modqc_peeling_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE INTEGER(kind=int_b)
#define VOL7D_POLY_TYPES b
#include "modqc_peeling_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE CHARACTER(len=vol7d_cdatalen)
#define VOL7D_POLY_TYPES c
#include "modqc_peeling_include.F90"


#undef VOL7D_POLY_SUBTYPE
#undef VOL7D_POLY_SUBTYPES
#define VOL7D_POLY_SUBTYPE DOUBLE PRECISION
#define VOL7D_POLY_SUBTYPES d

#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE REAL
#define VOL7D_POLY_TYPES r
#include "modqc_peeling_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE DOUBLE PRECISION
#define VOL7D_POLY_TYPES d
#include "modqc_peeling_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE INTEGER
#define VOL7D_POLY_TYPES i
#include "modqc_peeling_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE INTEGER(kind=int_b)
#define VOL7D_POLY_TYPES b
#include "modqc_peeling_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE CHARACTER(len=vol7d_cdatalen)
#define VOL7D_POLY_TYPES c
#include "modqc_peeling_include.F90"


#undef VOL7D_POLY_SUBTYPE
#undef VOL7D_POLY_SUBTYPES
#define VOL7D_POLY_SUBTYPE INTEGER
#define VOL7D_POLY_SUBTYPES i

#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE REAL
#define VOL7D_POLY_TYPES r
#include "modqc_peeling_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE DOUBLE PRECISION
#define VOL7D_POLY_TYPES d
#include "modqc_peeling_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE INTEGER
#define VOL7D_POLY_TYPES i
#include "modqc_peeling_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE INTEGER(kind=int_b)
#define VOL7D_POLY_TYPES b
#include "modqc_peeling_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE CHARACTER(len=vol7d_cdatalen)
#define VOL7D_POLY_TYPES c
#include "modqc_peeling_include.F90"


#undef VOL7D_POLY_SUBTYPE
#undef VOL7D_POLY_SUBTYPES
#define VOL7D_POLY_SUBTYPE INTEGER(kind=int_b)
#define VOL7D_POLY_SUBTYPES b

#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE REAL
#define VOL7D_POLY_TYPES r
#include "modqc_peeling_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE DOUBLE PRECISION
#define VOL7D_POLY_TYPES d
#include "modqc_peeling_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE INTEGER
#define VOL7D_POLY_TYPES i
#include "modqc_peeling_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE INTEGER(kind=int_b)
#define VOL7D_POLY_TYPES b
#include "modqc_peeling_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE CHARACTER(len=vol7d_cdatalen)
#define VOL7D_POLY_TYPES c
#include "modqc_peeling_include.F90"



#undef VOL7D_POLY_SUBTYPE
#undef VOL7D_POLY_SUBTYPES
#define VOL7D_POLY_SUBTYPE CHARACTER(len=vol7d_cdatalen)
#define VOL7D_POLY_SUBTYPES c

#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE REAL
#define VOL7D_POLY_TYPES r
#include "modqc_peeling_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE DOUBLE PRECISION
#define VOL7D_POLY_TYPES d
#include "modqc_peeling_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE INTEGER
#define VOL7D_POLY_TYPES i
#include "modqc_peeling_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE INTEGER(kind=int_b)
#define VOL7D_POLY_TYPES b
#include "modqc_peeling_include.F90"
#undef VOL7D_POLY_TYPE
#undef VOL7D_POLY_TYPES
#define VOL7D_POLY_TYPE CHARACTER(len=vol7d_cdatalen)
#define VOL7D_POLY_TYPES c
#include "modqc_peeling_include.F90"



IF (.NOT.PRESENT(keep_attr) .AND. .NOT.PRESENT(delete_attr) .and. .not. optio_log(preserve)) THEN ! destroy all attributes
  IF (ASSOCIATED(this%voldatiattrr)) DEALLOCATE(this%voldatiattrr)
  IF (ASSOCIATED(this%voldatiattrd)) DEALLOCATE(this%voldatiattrd)
  IF (ASSOCIATED(this%voldatiattri)) DEALLOCATE(this%voldatiattri)
  IF (ASSOCIATED(this%voldatiattrb)) DEALLOCATE(this%voldatiattrb)
  IF (ASSOCIATED(this%voldatiattrc)) DEALLOCATE(this%voldatiattrc)

  CALL delete(this%datiattr)
  CALL delete(this%dativarattr)
END IF

IF (PRESENT(keep_attr)) THEN ! set to missing non requested attributes and reform

  if (optio_log(preserve)) call l4f_log(L4F_WARN,"preserve parameter ignored: keep_attr passed")
  CALL keep_var(this%datiattr%r)
  CALL keep_var(this%datiattr%d)
  CALL keep_var(this%datiattr%i)
  CALL keep_var(this%datiattr%b)
  CALL keep_var(this%datiattr%c)
  CALL qc_reform(this,data_id, miss=.TRUE., purgeana=purgeana)

ELSE IF (PRESENT(delete_attr)) THEN ! set to missing requested attributes and reform

  if (optio_log(preserve)) call l4f_log(L4F_WARN,"preserve parameter ignored: delete_attr passed")
  CALL delete_var(this%datiattr%r)
  CALL delete_var(this%datiattr%d)
  CALL delete_var(this%datiattr%i)
  CALL delete_var(this%datiattr%b)
  CALL delete_var(this%datiattr%c)
  CALL qc_reform(this,data_id, miss=.TRUE., purgeana=purgeana)

ELSE IF (PRESENT(purgeana)) THEN

  CALL qc_reform(this,data_id, purgeana=purgeana)

ENDIF


CONTAINS


!> Like vol7d_reform but manage data_id and have less options
subroutine qc_reform(this,data_id,miss, purgeana)
TYPE(vol7d),INTENT(INOUT)  :: this !< object that has to be reformed
integer,INTENT(inout),pointer,OPTIONAL :: data_id(:,:,:,:,:) !< data ID to use with dballe DB (for fast write of attributes)
logical,intent(in),optional :: miss !< remove everithing related with missing position in description vector 
logical,intent(in),optional :: purgeana !< if true remove ana with all data missing

integer,pointer :: data_idtmp(:,:,:,:,:)
logical,allocatable :: llana(:)
integer,allocatable :: anaind(:)
integer :: i,j,nana

if (optio_log(purgeana)) then
  allocate(llana(size(this%ana)))
  llana =.false.
  do i =1,size(this%ana)
    if (associated(this%voldatii)) llana(i)= llana(i) .or. any(c_e(this%voldatii(i,:,:,:,:,:)))
    if (associated(this%voldatir)) llana(i)= llana(i) .or. any(c_e(this%voldatir(i,:,:,:,:,:)))
    if (associated(this%voldatid)) llana(i)= llana(i) .or. any(c_e(this%voldatid(i,:,:,:,:,:)))
    if (associated(this%voldatib)) llana(i)= llana(i) .or. any(c_e(this%voldatib(i,:,:,:,:,:)))
    if (associated(this%voldatic)) llana(i)= llana(i) .or. any(c_e(this%voldatic(i,:,:,:,:,:)))

#ifdef DEBUG
    if (.not. llana(i)) call l4f_log(L4F_DEBUG,"remove station"//t2c(i))
#endif

  end do

  nana=count(llana)


  allocate(anaind(nana))

  J=0
  do i=1,size(this%ana)
    if (llana(i)) then
      j=j+1
      anaind(j)=i
    end if
  end do

 
  if(present(data_id)) then
    allocate(data_idtmp(nana,size(data_id,2),size(data_id,3),size(data_id,4),size(data_id,5)))
    data_idtmp=data_id(anaind,:,:,:,:)
    if (associated(data_id))deallocate(data_id)
    data_id=>data_idtmp
  end if 
  
  call vol7d_reform(this,miss=miss,lana=llana)

  deallocate(llana,anaind)

else

  call vol7d_reform(this,miss=miss)

end if

end subroutine qc_reform


SUBROUTINE keep_var(var)
TYPE(vol7d_var),intent(inout),POINTER :: var(:)

INTEGER :: i

IF (ASSOCIATED(var)) THEN
  if (size(var) == 0) then
    var%btable = vol7d_var_miss%btable
  else
    DO i = 1, SIZE(var)
      IF (ALL(var(i)%btable /= keep_attr(:))) THEN ! n.b. ALL((//)) = .TRUE.
        var(i)%btable = vol7d_var_miss%btable
      ENDIF
    ENDDO
  end if
ENDIF

END SUBROUTINE keep_var

SUBROUTINE delete_var(var)
TYPE(vol7d_var),intent(inout),POINTER :: var(:)

INTEGER :: i

IF (ASSOCIATED(var)) THEN
  if (size(var) == 0) then
    var%btable = vol7d_var_miss%btable
  else
    DO i = 1, SIZE(var)
      IF (ANY(var(i)%btable == delete_attr(:))) THEN ! n.b. ANY((//)) = .FALSE.
        var(i) = vol7d_var_miss
      ENDIF
    ENDDO
  end if
ENDIF

END SUBROUTINE delete_var

END SUBROUTINE vol7d_peeling


end module modqc
