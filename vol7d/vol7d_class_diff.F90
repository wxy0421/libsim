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

#undef VOL7D_POLY_TYPES_V
#undef VOL7D_POLY_TYPES_MISS
#define VOL7D_POLY_TYPES_V r
#define VOL7D_POLY_TYPES_MISS rmiss
#include "vol7d_class_diff_only.F90"
#undef VOL7D_POLY_TYPES_V
#undef VOL7D_POLY_TYPES_MISS
#define VOL7D_POLY_TYPES_V i
#define VOL7D_POLY_TYPES_MISS imiss
#include "vol7d_class_diff_only.F90"
#undef VOL7D_POLY_TYPES_V
#undef VOL7D_POLY_TYPES_MISS
#define VOL7D_POLY_TYPES_V b
#define VOL7D_POLY_TYPES_MISS ibmiss
#include "vol7d_class_diff_only.F90"
#undef VOL7D_POLY_TYPES_V
#undef VOL7D_POLY_TYPES_MISS
#define VOL7D_POLY_TYPES_V d
#define VOL7D_POLY_TYPES_MISS dmiss
#include "vol7d_class_diff_only.F90"
#undef VOL7D_POLY_TYPES_V
#undef VOL7D_POLY_TYPES_MISS
#define VOL7D_POLY_TYPES_V c
#define VOL7D_POLY_TYPES_MISS cmiss
#include "vol7d_class_diff_only.F90"
#undef VOL7D_POLY_TYPES_V
#undef VOL7D_POLY_TYPES_MISS

