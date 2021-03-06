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
!> Module for basic statistical computations taking into account missing data.
!! The functions provided are average, variance, linear correlation
!! coefficient and percentile for a population. Missing data are
!! excluded from computations and from weighing. Both \a REAL and \a
!! DOUBLE \a PRECISION functions are available.
!!
!! \ingroup base
MODULE simple_stat
USE missing_values
USE optional_values
USE array_utilities
IMPLICIT NONE

!> Compute the average of the random variable provided,
!! taking into account missing data. The result is of type \a REAL or
!! \a DOUBLE \a PRECISION according to the type of \a sample.
!!
!! REAL or DOUBLE PRECISION FUNCTION stat_average()
!! \param sample(:) REAL,INTENT(in) or DOUBLE PRECISION,INTENT(in) the variable to be averaged
!! \param mask(:) LOGICAL,OPTIONAL,INTENT(in) additional mask to be and'ed with missing values
!! \param nomiss LOGICAL,OPTIONAL,INTENT(in) if provided and \a .TRUE. it disables all the checks for missing data and empty sample and enables the use of a fast algorithm
INTERFACE stat_average
  MODULE PROCEDURE stat_averager, stat_averaged
END INTERFACE

!> Compute the variance of the random variable provided, taking into
!! account missing data.  The average can be returned as an optional
!! parameter since it is computed anyway. The result is of type \a REAL or
!! \a DOUBLE \a PRECISION according to the type of \a sample.
!!
!! REAL or DOUBLE PRECISION FUNCTION stat_variance()
!! \param sample(:) REAL,INTENT(in) or DOUBLE PRECISION,INTENT(in) the variable for which variance has to be computed
!! \param average REAL,OPTIONAL,INTENT(out) or DOUBLE PRECISION,OPTIONAL,INTENT(out) the average of the variable can optionally be returned
!! \param mask(:) LOGICAL,OPTIONAL,INTENT(in) additional mask to be and'ed with missing values
!! \param nomiss LOGICAL,OPTIONAL,INTENT(in) if provided and \a .TRUE. it disables all the checks for missing data and empty sample and enables the use of a fast algorithm
!! \param nm1 LOGICAL,OPTIONAL,INTENT(in) if provided and \a .TRUE. it computes the variance dividing by \a n - 1 rather than by \a n
INTERFACE stat_variance
  MODULE PROCEDURE stat_variancer, stat_varianced
END INTERFACE

!> Compute the standard deviation of the random variable provided, taking into
!! account missing data.  The average can be returned as an optional
!! parameter since it is computed anyway. The result is of type \a REAL or
!! \a DOUBLE \a PRECISION according to the type of \a sample.
!!
!! REAL or DOUBLE PRECISION FUNCTION stat_stddev()
!! \param sample(:) REAL,INTENT(in) or DOUBLE PRECISION,INTENT(in) the variable for which standard deviation has to be computed
!! \param average REAL,OPTIONAL,INTENT(out) or DOUBLE PRECISION,OPTIONAL,INTENT(out) the average of the variable can optionally be returned
!! \param mask(:) LOGICAL,OPTIONAL,INTENT(in) additional mask to be and'ed with missing values
!! \param nomiss LOGICAL,OPTIONAL,INTENT(in) if provided and \a .TRUE. it disables all the checks for missing data and empty sample and enables the use of a fast algorithm
!! \param nm1 LOGICAL,OPTIONAL,INTENT(in) if provided and \a .TRUE. it computes the variance dividing by \a n - 1 rather than by \a n
INTERFACE stat_stddev
  MODULE PROCEDURE stat_stddevr, stat_stddevd
END INTERFACE

!> Compute the linear correlation coefficient between the two random
!! variables provided, taking into account missing data. Data are
!! considered missing when at least one variable has a missing value.
!! The average and the variance of each variable can be returned as
!! optional parameters since they are computed anyway. The result is
!! of type \a REAL or \a DOUBLE \a PRECISION according to the type of
!! \a sample1 and \a sample2.
!!
!! REAL or DOUBLE PRECISION FUNCTION stat_linear_corr()
!! \param sample1(:) REAL,INTENT(in) or DOUBLE PRECISION,INTENT(in) the first variable
!! \param sample2(:) REAL,INTENT(in) or DOUBLE PRECISION,INTENT(in) the second variable
!! \param average1 REAL,OPTIONAL,INTENT(out) or DOUBLE PRECISION,OPTIONAL,INTENT(out) the average of the first variable can optionally be returned
!! \param average2 REAL,OPTIONAL,INTENT(out) or DOUBLE PRECISION,OPTIONAL,INTENT(out) the average of the second variable can optionally be returned
!! \param variance1 REAL,OPTIONAL,INTENT(out) or DOUBLE PRECISION,OPTIONAL,INTENT(out) the variance of the first variable can optionally be returned
!! \param variance2 REAL,OPTIONAL,INTENT(out) or DOUBLE PRECISION,OPTIONAL,INTENT(out) the variance of the second variable can optionally be returned
!! \param mask(:) LOGICAL,OPTIONAL,INTENT(in) additional mask to be and'ed with missing values
INTERFACE stat_linear_corr
  MODULE PROCEDURE stat_linear_corrr, stat_linear_corrd
END INTERFACE

!> Compute the linear regression coefficients between the two random
!! variables provided, taking into account missing data. Data are
!! considered missing when at least one variable has a missing value.
!! The regression is computed using the method of linear least
!! squares. The input and output parameters are either \a REAL or \a
!! DOUBLE \a PRECISION.
!!
!! SUBROUTINE stat_linear_regression()
!! \param sample1(:) REAL,INTENT(in) or DOUBLE PRECISION,INTENT(in) the first variable
!! \param sample2(:) REAL,INTENT(in) or DOUBLE PRECISION,INTENT(in) the second variable
!! \param alpha0 REAL,INTENT(out) or DOUBLE PRECISION,INTENT(out) the 0-th order coefficient of the regression computed
!! \param alpha1 REAL,INTENT(out) or DOUBLE PRECISION,INTENT(out) the first order coefficient of the regression computed
!! \param mask(:) LOGICAL,OPTIONAL,INTENT(in) additional mask to be and'ed with missing values
!! \param nomiss LOGICAL,OPTIONAL,INTENT(in) if provided and \a .TRUE. it disables all the checks for missing data and empty sample and enables the use of a fast algorithm
INTERFACE stat_linear_regression
  MODULE PROCEDURE stat_linear_regressionr, stat_linear_regressiond
END INTERFACE

!> Compute a set of percentiles for a random variable.
!! The result is a 1-d array of the same size as the array of
!! percentile values provided. Percentiles are computed by linear
!! interpolation. The result is of type \a REAL or \a DOUBLE \a
!! PRECISION according to the type of \a sample.
!!
!! REAL or DOUBLE PRECISION FUNCTION stat_percentile()
!! \param sample(:) REAL,INTENT(in) or DOUBLE PRECISION,INTENT(in) the variable for which percentiles have to be computed
!! \param perc_vals(:) REAL,INTENT(in) or DOUBLE PRECISION,INTENT(in) the percentiles values to be computed, between 0. and 100.
!! \param mask(:) LOGICAL,OPTIONAL,INTENT(in) additional mask to be and'ed with missing values
INTERFACE stat_percentile
  MODULE PROCEDURE stat_percentiler, stat_percentiled
END INTERFACE

!> Bin a sample into equally spaced intervals to form a histogram.
!! The sample is binned into the requested number of intervals (bins)
!! and the population of each bin is returned in the allocatable array
!! \a bin(:).  If the operation cannot be performed \a bin is not
!! allocated. If the lower and upper bound of the histogram are not
!! provided, they are computed as the minimum and maximum of the
!! sample.
!!
!! SUBROUTINE stat_bin()
!! \param sample(:) REAL or DOUBLE PRECISION,INTENT(in) the variable to be binned
!! \param bin(:) INTEGER,INTENT(out),ALLOCATABLE the array with the population of each bin, dimensioned as (nbin)
!! \param nbin INTEGER,INTENT(in) the number of bins requested
!! \param start REAL or DOUBLE PRECISION,INTENT(in),OPTIONAL the start of the overall histogram interval
!! \param finish REAL or DOUBLE PRECISION,INTENT(in),OPTIONAL the end of the overall histogram interval
!! \param mask(:) LOGICAL,OPTIONAL,INTENT(in) additional mask to be and'ed with missing values
!! \param binbounds(:) REAL or DOUBLE PRECISION,INTENT(out),ALLOCATABLE,OPTIONAL the boundary of each bin, dimensioned as (nbin+1)
INTERFACE stat_bin
  MODULE PROCEDURE stat_binr, stat_bind
END INTERFACE stat_bin

!> Compute the mode of the random variable provided
!! taking into account missing data.
!! The mode is computed by binning the sample into the requested
!! number of intervals (bins) and the mode is computed as the midpoint
!! of the most populated bin; in case of multi-modality, the smallest
!! value is returned. If the operation cannot be performed a missing
!! value is returned. See the description of simple_stat::stat_bin
!! subroutine for details about the binning procedure.
!!
!! REAL or DOUBLE PRECISION FUNCTION stat_mode_histogram()
!! \param sample(:) REAL or DOUBLE PRECISION,INTENT(in) the variable for which the mode has to be computed
!! \param nbin INTEGER,INTENT(in) the number of bins requested
!! \param start REAL or DOUBLE PRECISION,INTENT(in),OPTIONAL the start of the overall histogram interval
!! \param finish REAL or DOUBLE PRECISION,INTENT(in),OPTIONAL the end of the overall histogram interval
!! \param mask(:) LOGICAL,OPTIONAL,INTENT(in) additional mask to be and'ed with missing values
INTERFACE stat_mode_histogram
  MODULE PROCEDURE stat_mode_histogramr, stat_mode_histogramd
END INTERFACE stat_mode_histogram

PRIVATE
PUBLIC stat_average, stat_variance, stat_stddev, stat_linear_corr, &
 stat_linear_regression, stat_percentile, stat_mode_histogram, stat_bin, &
 NormalizedDensityIndex

CONTAINS


FUNCTION stat_averager(sample, mask, nomiss) RESULT(average)
REAL,INTENT(in) :: sample(:)
LOGICAL,OPTIONAL,INTENT(in) :: mask(:)
LOGICAL,OPTIONAL,INTENT(in) :: nomiss ! informs that the sample does not contain missing data and is not of zero length (for speedup)

REAL :: average

INTEGER :: sample_count
LOGICAL :: sample_mask(SIZE(sample))

IF (optio_log(nomiss)) THEN
  average = SUM(sample)/SIZE(sample)
ELSE
  sample_mask = (sample /= rmiss)
  IF (PRESENT(mask)) sample_mask = sample_mask .AND. mask
  sample_count = COUNT(sample_mask)

  IF (sample_count > 0) THEN
! compute average
    average = SUM(sample, mask=sample_mask)/sample_count
  ELSE
    average = rmiss
  ENDIF
ENDIF

END FUNCTION stat_averager


FUNCTION stat_averaged(sample, mask, nomiss) RESULT(average)
DOUBLE PRECISION,INTENT(in) :: sample(:)
LOGICAL,OPTIONAL,INTENT(in) :: mask(:)
LOGICAL,OPTIONAL,INTENT(in) :: nomiss ! informs that the sample does not contain missing data and is not of zero length (for speedup)

DOUBLE PRECISION :: average

INTEGER :: sample_count
LOGICAL :: sample_mask(SIZE(sample))

IF (optio_log(nomiss)) THEN
  average = SUM(sample)/SIZE(sample)
ELSE
  sample_mask = (sample /= dmiss)
  IF (PRESENT(mask)) sample_mask = sample_mask .AND. mask
  sample_count = COUNT(sample_mask)

  IF (sample_count > 0) THEN
! compute average
    average = SUM(sample, mask=sample_mask)/sample_count
  ELSE
    average = dmiss
  ENDIF
ENDIF

END FUNCTION stat_averaged


FUNCTION stat_variancer(sample, average, mask, nomiss, nm1) RESULT(variance)
REAL,INTENT(in) :: sample(:)
REAL,OPTIONAL,INTENT(out) :: average
LOGICAL,OPTIONAL,INTENT(in) :: mask(:)
LOGICAL,OPTIONAL,INTENT(in) :: nomiss
LOGICAL,OPTIONAL,INTENT(in) :: nm1

REAL :: variance

REAL :: laverage
INTEGER :: sample_count, i
LOGICAL :: sample_mask(SIZE(sample))

IF (optio_log(nomiss)) THEN
! compute average
  laverage = SUM(sample)/SIZE(sample)
  IF (PRESENT(average)) average = laverage
  IF (optio_log(nm1)) THEN
    variance = SUM((sample-laverage)**2)/MAX(SIZE(sample)-1,1)
  ELSE
    variance = SUM((sample-laverage)**2)/SIZE(sample)
  ENDIF

ELSE
  sample_mask = (sample /= rmiss)
  IF (PRESENT(mask)) sample_mask = sample_mask .AND. mask
  sample_count = COUNT(sample_mask)

  IF (sample_count > 0) THEN
! compute average
    laverage = SUM(sample, mask=sample_mask)/sample_count
    IF (PRESENT(average)) average = laverage
! compute sum of squares and variance
    variance = 0.
    DO i = 1, SIZE(sample)
      IF (sample_mask(i)) variance = variance + (sample(i)-laverage)**2
    ENDDO
    IF (optio_log(nm1)) THEN
      variance = variance/MAX(sample_count-1,1)
    ELSE
      variance = variance/sample_count
    ENDIF
  ELSE
    IF (PRESENT(average)) average = rmiss
    variance = rmiss
  ENDIF

ENDIF

END FUNCTION stat_variancer


FUNCTION stat_varianced(sample, average, mask, nomiss, nm1) RESULT(variance)
DOUBLE PRECISION,INTENT(in) :: sample(:)
DOUBLE PRECISION,OPTIONAL,INTENT(out) :: average
LOGICAL,OPTIONAL,INTENT(in) :: mask(:)
LOGICAL,OPTIONAL,INTENT(in) :: nomiss
LOGICAL,OPTIONAL,INTENT(in) :: nm1

DOUBLE PRECISION :: variance

DOUBLE PRECISION :: laverage
INTEGER :: sample_count, i
LOGICAL :: sample_mask(SIZE(sample))

IF (optio_log(nomiss)) THEN
! compute average
  laverage = SUM(sample)/SIZE(sample)
  IF (PRESENT(average)) average = laverage
  IF (optio_log(nm1)) THEN
    variance = SUM((sample-laverage)**2)/MAX(SIZE(sample)-1,1)
  ELSE
    variance = SUM((sample-laverage)**2)/SIZE(sample)
  ENDIF

ELSE
  sample_mask = (sample /= dmiss)
  IF (PRESENT(mask)) sample_mask = sample_mask .AND. mask
  sample_count = COUNT(sample_mask)

  IF (sample_count > 0) THEN
! compute average
    laverage = SUM(sample, mask=sample_mask)/sample_count
    IF (PRESENT(average)) average = laverage
! compute sum of squares and variance
    variance = 0.
    DO i = 1, SIZE(sample)
      IF (sample_mask(i)) variance = variance + (sample(i)-laverage)**2
    ENDDO
    IF (optio_log(nm1)) THEN
      variance = variance/MAX(sample_count-1,1)
    ELSE
      variance = variance/sample_count
    ENDIF
  ELSE
    IF (PRESENT(average)) average = dmiss
    variance = dmiss
  ENDIF

ENDIF

END FUNCTION stat_varianced


FUNCTION stat_stddevr(sample, average, mask, nomiss, nm1) RESULT(stddev)
REAL,INTENT(in) :: sample(:)
REAL,OPTIONAL,INTENT(out) :: average
LOGICAL,OPTIONAL,INTENT(in) :: mask(:)
LOGICAL,OPTIONAL,INTENT(in) :: nomiss
LOGICAL,OPTIONAL,INTENT(in) :: nm1

REAL :: stddev

stddev = stat_variance(sample, average, mask, nomiss, nm1)
IF (c_e(stddev)) stddev = SQRT(stddev)
 
END FUNCTION stat_stddevr


FUNCTION stat_stddevd(sample, average, mask, nomiss, nm1) RESULT(stddev)
DOUBLE PRECISION,INTENT(in) :: sample(:)
DOUBLE PRECISION,OPTIONAL,INTENT(out) :: average
LOGICAL,OPTIONAL,INTENT(in) :: mask(:)
LOGICAL,OPTIONAL,INTENT(in) :: nomiss
LOGICAL,OPTIONAL,INTENT(in) :: nm1

DOUBLE PRECISION :: stddev

stddev = stat_variance(sample, average, mask, nomiss, nm1)
IF (c_e(stddev)) stddev = SQRT(stddev)

END FUNCTION stat_stddevd


FUNCTION stat_linear_corrr(sample1, sample2, average1, average2, &
 variance1, variance2, mask, nomiss) RESULT(linear_corr)
REAL,INTENT(in) :: sample1(:)
REAL,INTENT(in) :: sample2(:)
REAL,OPTIONAL,INTENT(out) :: average1
REAL,OPTIONAL,INTENT(out) :: average2
REAL,OPTIONAL,INTENT(out) :: variance1
REAL,OPTIONAL,INTENT(out) :: variance2
LOGICAL,OPTIONAL,INTENT(in) :: mask(:)
LOGICAL,OPTIONAL,INTENT(in) :: nomiss

REAL :: linear_corr

REAL :: laverage1, laverage2, lvariance1, lvariance2
INTEGER :: sample_count, i
LOGICAL :: sample_mask(SIZE(sample1))

IF (SIZE(sample1) /= SIZE(sample2)) THEN
  IF (PRESENT(average1)) average1 = rmiss
  IF (PRESENT(average2)) average2 = rmiss
  IF (PRESENT(variance1)) variance1 = rmiss
  IF (PRESENT(variance2)) variance2 = rmiss
  linear_corr = rmiss
  RETURN
ENDIF

sample_mask = (sample1 /= rmiss .AND. sample2 /= rmiss)
IF (PRESENT(mask)) sample_mask = sample_mask .AND. mask
sample_count = COUNT(sample_mask)
IF (sample_count > 0) THEN
! compute averages
  laverage1 = SUM(sample1, mask=sample_mask)/sample_count
  laverage2 = SUM(sample2, mask=sample_mask)/sample_count
  IF (PRESENT(average1)) average1 = laverage1
  IF (PRESENT(average2)) average2 = laverage2
! compute sum of squares and variances
  lvariance1 = 0.
  lvariance2 = 0.
  DO i = 1, SIZE(sample1)
    IF (sample_mask(i))THEN
      lvariance1 = lvariance1 + (sample1(i)-laverage1)**2
      lvariance2 = lvariance2 + (sample2(i)-laverage2)**2
    ENDIF
  ENDDO
  lvariance1 = lvariance1/sample_count
  lvariance2 = lvariance2/sample_count
  IF (PRESENT(variance1)) variance1 = lvariance1
  IF (PRESENT(variance2)) variance2 = lvariance2
! compute correlation
  linear_corr = 0.
  DO i = 1, SIZE(sample1)
    IF (sample_mask(i)) linear_corr = linear_corr + &
     (sample1(i)-laverage1)*(sample2(i)-laverage2)
  ENDDO
  linear_corr = linear_corr/sample_count / SQRT(lvariance1*lvariance2)
ELSE
  IF (PRESENT(average1)) average1 = rmiss
  IF (PRESENT(average2)) average2 = rmiss
  IF (PRESENT(variance1)) variance1 = rmiss
  IF (PRESENT(variance2)) variance2 = rmiss
  linear_corr = rmiss
ENDIF

END FUNCTION stat_linear_corrr


FUNCTION stat_linear_corrd(sample1, sample2, average1, average2, &
 variance1, variance2, mask, nomiss) RESULT(linear_corr)
DOUBLE PRECISION, INTENT(in) :: sample1(:)
DOUBLE PRECISION, INTENT(in) :: sample2(:)
DOUBLE PRECISION, OPTIONAL, INTENT(out) :: average1
DOUBLE PRECISION, OPTIONAL, INTENT(out) :: average2
DOUBLE PRECISION, OPTIONAL, INTENT(out) :: variance1
DOUBLE PRECISION, OPTIONAL, INTENT(out) :: variance2
LOGICAL, OPTIONAL, INTENT(in) :: mask(:)
LOGICAL, OPTIONAL, INTENT(in) :: nomiss

DOUBLE PRECISION :: linear_corr

DOUBLE PRECISION :: laverage1, laverage2, lvariance1, lvariance2
INTEGER :: sample_count, i
LOGICAL :: sample_mask(SIZE(sample1))

IF (SIZE(sample1) /= SIZE(sample2)) THEN
  IF (PRESENT(average1)) average1 = dmiss
  IF (PRESENT(average2)) average2 = dmiss
  IF (PRESENT(variance1)) variance1 = dmiss
  IF (PRESENT(variance2)) variance2 = dmiss
  linear_corr = dmiss
  RETURN
ENDIF

sample_mask = (sample1 /= dmiss .AND. sample2 /= dmiss)
IF (PRESENT(mask)) sample_mask = sample_mask .AND. mask
sample_count = COUNT(sample_mask)
IF (sample_count > 0) THEN
! compute averages
  laverage1 = SUM(sample1, mask=sample_mask)/sample_count
  laverage2 = SUM(sample2, mask=sample_mask)/sample_count
  IF (PRESENT(average1)) average1 = laverage1
  IF (PRESENT(average2)) average2 = laverage2
! compute sum of squares and variances
  lvariance1 = 0.
  lvariance2 = 0.
  DO i = 1, SIZE(sample1)
    IF (sample_mask(i))THEN
      lvariance1 = lvariance1 + (sample1(i)-laverage1)**2
      lvariance2 = lvariance2 + (sample2(i)-laverage2)**2
    ENDIF
  ENDDO
  lvariance1 = lvariance1/sample_count
  lvariance2 = lvariance2/sample_count
  IF (PRESENT(variance1)) variance1 = lvariance1
  IF (PRESENT(variance2)) variance2 = lvariance2
! compute correlation
  linear_corr = 0.0D0
  DO i = 1, SIZE(sample1)
    IF (sample_mask(i)) linear_corr = linear_corr + &
     (sample1(i)-laverage1)*(sample2(i)-laverage2)
  ENDDO
  linear_corr = linear_corr/sample_count / SQRT(lvariance1*lvariance2)
ELSE
  IF (PRESENT(average1)) average1 = dmiss
  IF (PRESENT(average2)) average2 = dmiss
  IF (PRESENT(variance1)) variance1 = dmiss
  IF (PRESENT(variance2)) variance2 = dmiss
  linear_corr = dmiss
ENDIF

END FUNCTION stat_linear_corrd


SUBROUTINE stat_linear_regressionr(sample1, sample2, alpha0, alpha1, mask)
REAL,INTENT(in) :: sample1(:)
REAL,INTENT(in) :: sample2(:)
REAL,INTENT(out) :: alpha0
REAL,INTENT(out) :: alpha1
LOGICAL,OPTIONAL,INTENT(in) :: mask(:)

REAL :: laverage1, laverage2
INTEGER :: sample_count
LOGICAL :: sample_mask(SIZE(sample1))

IF (SIZE(sample1) /= SIZE(sample2)) THEN
  alpha0 = rmiss
  alpha1 = rmiss
  RETURN
ENDIF

sample_mask = (sample1 /= rmiss .AND. sample2 /= rmiss)
IF (PRESENT(mask)) sample_mask = sample_mask .AND. mask
sample_count = COUNT(sample_mask)

IF (sample_count > 0) THEN
  laverage1 = SUM(sample1, mask=sample_mask)/sample_count
  laverage2 = SUM(sample2, mask=sample_mask)/sample_count
  alpha1 = SUM((sample1-laverage1)*(sample2-laverage2), mask=sample_mask)/ &
   SUM((sample1-laverage1)**2, mask=sample_mask)
  alpha0 = laverage1 - alpha1*laverage2

ELSE
  alpha0 = rmiss
  alpha1 = rmiss
ENDIF

END SUBROUTINE stat_linear_regressionr


SUBROUTINE stat_linear_regressiond(sample1, sample2, alpha0, alpha1, mask)
DOUBLE PRECISION,INTENT(in) :: sample1(:)
DOUBLE PRECISION,INTENT(in) :: sample2(:)
DOUBLE PRECISION,INTENT(out) :: alpha0
DOUBLE PRECISION,INTENT(out) :: alpha1
LOGICAL,OPTIONAL,INTENT(in) :: mask(:)

DOUBLE PRECISION :: laverage1, laverage2
INTEGER :: sample_count
LOGICAL :: sample_mask(SIZE(sample1))

IF (SIZE(sample1) /= SIZE(sample2)) THEN
  alpha0 = dmiss
  alpha1 = dmiss
  RETURN
ENDIF

sample_mask = (sample1 /= dmiss .AND. sample2 /= dmiss)
IF (PRESENT(mask)) sample_mask = sample_mask .AND. mask
sample_count = COUNT(sample_mask)

IF (sample_count > 0) THEN
  laverage1 = SUM(sample1, mask=sample_mask)/sample_count
  laverage2 = SUM(sample2, mask=sample_mask)/sample_count
  alpha1 = SUM((sample1-laverage1)*(sample2-laverage2), mask=sample_mask)/ &
   SUM((sample1-laverage1)**2, mask=sample_mask)
  alpha0 = laverage1 - alpha1*laverage2

ELSE
  alpha0 = dmiss
  alpha1 = dmiss
ENDIF

END SUBROUTINE stat_linear_regressiond


FUNCTION stat_percentiler(sample, perc_vals, mask, nomiss) RESULT(percentile)
REAL,INTENT(in) :: sample(:)
REAL,INTENT(in) :: perc_vals(:)
LOGICAL,OPTIONAL,INTENT(in) :: mask(:)
LOGICAL,OPTIONAL,INTENT(in) :: nomiss
REAL :: percentile(SIZE(perc_vals))

REAL :: lsample(SIZE(sample)), rindex
INTEGER :: sample_count, j, iindex
LOGICAL :: sample_mask(SIZE(sample))

percentile(:) = rmiss
IF (.NOT.optio_log(nomiss)) THEN
  sample_mask = c_e(sample)
  IF (PRESENT(mask)) sample_mask = sample_mask .AND. mask
  sample_count = COUNT(sample_mask)
  IF (sample_count == 0) RETURN ! special case
ELSE
  sample_count = SIZE(sample)
ENDIF

IF (sample_count == SIZE(sample)) THEN
  lsample = sample
ELSE
  lsample(1:sample_count) = PACK(sample, mask=sample_mask)
ENDIF

IF (sample_count == 1) THEN ! other special case
  percentile(:) = lsample(1)
  RETURN
ENDIF


! this sort is very fast but with a lot of equal values it is very slow and fails
CALL sort(lsample(1:sample_count))

! this sort is very very slow
!!$DO j = 2, sample_count
!!$  v = lsample(j)
!!$  DO i = j-1, 1, -1
!!$    IF (v >= lsample(i)) EXIT
!!$    lsample(i+1) = lsample(i)
!!$  ENDDO
!!$  lsample(i+1) = v
!!$ENDDO

DO j = 1, SIZE(perc_vals)
  IF (perc_vals(j) >= 0. .AND. perc_vals(j) <= 100.) THEN
! compute real index of requested percentile in sample
    rindex = REAL(sample_count-1, kind=KIND(rindex))*perc_vals(j)/100.+1.
! compute integer index of previous element in sample, beware of corner cases
    iindex = MIN(MAX(INT(rindex), 1), sample_count-1)
! compute linearly interpolated percentile

    percentile(j) = lsample(iindex)*(REAL(iindex+1, kind=KIND(rindex))-rindex) &
     + lsample(iindex+1)*(rindex-REAL(iindex, kind=KIND(rindex)))

  ENDIF
ENDDO

END FUNCTION stat_percentiler


FUNCTION stat_percentiled(sample, perc_vals, mask, nomiss) RESULT(percentile)
DOUBLE PRECISION, INTENT(in) :: sample(:)
DOUBLE PRECISION, INTENT(in) :: perc_vals(:)
LOGICAL, OPTIONAL, INTENT(in) :: mask(:)
LOGICAL, OPTIONAL, INTENT(in) :: nomiss
DOUBLE PRECISION :: percentile(SIZE(perc_vals))

DOUBLE PRECISION :: lsample(SIZE(sample)), rindex
INTEGER :: sample_count, j, iindex
LOGICAL :: sample_mask(SIZE(sample))


percentile(:) = dmiss
IF (.NOT.optio_log(nomiss)) THEN
  sample_mask = (sample /= dmiss)
  IF (PRESENT(mask)) sample_mask = sample_mask .AND. mask
  sample_count = COUNT(sample_mask)
  IF (sample_count == 0) RETURN ! particular case
ELSE
  sample_count = SIZE(sample)
ENDIF

IF (sample_count == SIZE(sample)) THEN
  lsample = sample
ELSE
  lsample(1:sample_count) = PACK(sample, mask=sample_mask)
ENDIF

IF (sample_count == 1) THEN ! other particular case
  percentile(:) = lsample(1)
  RETURN
ENDIF

! this sort is very fast but with a lot of equal values it is very slow and fails
CALL sort(lsample(1:sample_count))

! this sort is very very slow
!DO j = 2, sample_count
!  v = lsample(j)
!  DO i = j-1, 1, -1
!    IF (v >= lsample(i)) EXIT
!    lsample(i+1) = lsample(i)
!  ENDDO
!  lsample(i+1) = v
!ENDDO

DO j = 1, SIZE(perc_vals)
  IF (perc_vals(j) >= 0.D0 .AND. perc_vals(j) <= 100.D0) THEN
! compute real index of requested percentile in sample
    rindex = REAL(sample_count-1, kind=KIND(rindex))*perc_vals(j)/100.D0+1.D0
! compute integer index of previous element in sample, beware of corner cases
    iindex = MIN(MAX(INT(rindex), 1), sample_count-1)
! compute linearly interpolated percentile
    percentile(j) = lsample(iindex)*(REAL(iindex+1, kind=KIND(rindex))-rindex) &
     + lsample(iindex+1)*(rindex-REAL(iindex, kind=KIND(rindex)))
  ENDIF
ENDDO

END FUNCTION stat_percentiled


SUBROUTINE stat_binr(sample, bin, nbin, start, finish, mask, binbounds)
REAL,INTENT(in) :: sample(:)
INTEGER,INTENT(out),ALLOCATABLE :: bin(:)
INTEGER,INTENT(in) :: nbin
REAL,INTENT(in),OPTIONAL :: start
REAL,INTENT(in),OPTIONAL :: finish
LOGICAL,INTENT(in),OPTIONAL :: mask(:)
REAL,INTENT(out),ALLOCATABLE,OPTIONAL :: binbounds(:)

INTEGER :: i, ind
REAL :: lstart, lfinish, incr
REAL,ALLOCATABLE :: lbinbounds(:)
LOGICAL :: lmask(SIZE(sample))

! safety checks
IF (nbin < 1) RETURN
IF (PRESENT(mask)) THEN
  lmask = mask
ELSE
  lmask =.TRUE.
ENDIF
lmask = lmask .AND. c_e(sample)
IF (COUNT(lmask) < 1) RETURN

lstart = optio_r(start)
IF (.NOT.c_e(lstart)) lstart = MINVAL(sample, mask=lmask)
lfinish = optio_r(finish)
IF (.NOT.c_e(lfinish)) lfinish = MAXVAL(sample, mask=lmask)
IF (lfinish <= lstart) RETURN

incr = (lfinish-lstart)/nbin
ALLOCATE(bin(nbin))

ALLOCATE(lbinbounds(nbin+1))

DO i = 1, nbin
  lbinbounds(i) = lstart + (i-1)*incr
ENDDO  
lbinbounds(nbin+1) = lfinish ! set exact value to avoid truncation error

DO i = 1, nbin-1
  bin(i) = COUNT(sample >= lbinbounds(i) .AND. sample < lbinbounds(i+1) .AND. lmask)
!, .AND. c_e(sample))
ENDDO
bin(nbin) = COUNT(sample >= lbinbounds(nbin) .AND. sample <= lbinbounds(nbin+1) .AND. lmask)
!, .AND. c_e(sample)) ! special case, include upper limit

IF (PRESENT(binbounds)) binbounds = lbinbounds

END SUBROUTINE stat_binr


! alternative algorithm, probably faster with big samples, to be tested
SUBROUTINE stat_binr2(sample, bin, nbin, start, finish, mask, binbounds)
REAL,INTENT(in) :: sample(:)
INTEGER,INTENT(out),ALLOCATABLE :: bin(:)
INTEGER,INTENT(in) :: nbin
REAL,INTENT(in),OPTIONAL :: start
REAL,INTENT(in),OPTIONAL :: finish
LOGICAL,INTENT(in),OPTIONAL :: mask(:)
REAL,INTENT(out),ALLOCATABLE,OPTIONAL :: binbounds(:)

INTEGER :: i, ind
REAL :: lstart, lfinish, incr
LOGICAL :: lmask(SIZE(sample))

! safety checks
IF (nbin < 1) RETURN
IF (PRESENT(mask)) THEN
  lmask = mask
ELSE
  lmask =.TRUE.
ENDIF
lmask = lmask .AND. c_e(sample)
IF (COUNT(lmask) < 1) RETURN

lstart = optio_r(start)
IF (.NOT.c_e(lstart)) lstart = MINVAL(sample, mask=c_e(sample))
lfinish = optio_r(finish)
IF (.NOT.c_e(lfinish)) lfinish = MAXVAL(sample, mask=c_e(sample))
IF (lfinish <= lstart) RETURN

incr = (lfinish-lstart)/nbin
ALLOCATE(bin(nbin))

bin(:) = 0

DO i = 1, SIZE(sample)
  IF (lmask(i)) THEN
    ind = INT((sample(i)-lstart)/incr) + 1
    IF (ind > 0 .AND. ind <= nbin) THEN
      bin(ind) = bin(ind) + 1
    ELSE
      IF (sample(i) == finish) bin(nbin) = bin(nbin) + 1 ! special case, include upper limit
    ENDIF
  ENDIF
ENDDO

IF (PRESENT(binbounds)) THEN
  ALLOCATE(binbounds(nbin+1))
  DO i = 1, nbin
    binbounds(i) = lstart + (i-1)*incr
  ENDDO
  binbounds(nbin+1) = lfinish ! set exact value to avoid truncation error
ENDIF

END SUBROUTINE stat_binr2


SUBROUTINE stat_bind(sample, bin, nbin, start, finish, mask, binbounds)
DOUBLE PRECISION,INTENT(in) :: sample(:)
INTEGER,INTENT(out),ALLOCATABLE :: bin(:)
INTEGER,INTENT(in) :: nbin
DOUBLE PRECISION,INTENT(in),OPTIONAL :: start
DOUBLE PRECISION,INTENT(in),OPTIONAL :: finish
LOGICAL,INTENT(in),OPTIONAL :: mask(:)
DOUBLE PRECISION,INTENT(out),ALLOCATABLE,OPTIONAL :: binbounds(:)

INTEGER :: i, ind
DOUBLE PRECISION :: lstart, lfinish, incr
DOUBLE PRECISION,ALLOCATABLE :: lbinbounds(:)
LOGICAL :: lmask(SIZE(sample))

! safety checks
IF (nbin < 1) RETURN
IF (PRESENT(mask)) THEN
  lmask = mask
ELSE
  lmask =.TRUE.
ENDIF
lmask = lmask .AND. c_e(sample)
IF (COUNT(lmask) < 1) RETURN

lstart = optio_d(start)
IF (.NOT.c_e(lstart)) lstart = MINVAL(sample, mask=lmask)
lfinish = optio_d(finish)
IF (.NOT.c_e(lfinish)) lfinish = MAXVAL(sample, mask=lmask)
IF (lfinish <= lstart) RETURN

incr = (lfinish-lstart)/nbin
ALLOCATE(bin(nbin))

ALLOCATE(lbinbounds(nbin+1))

DO i = 1, nbin
  lbinbounds(i) = lstart + (i-1)*incr
ENDDO  
lbinbounds(nbin+1) = lfinish ! set exact value to avoid truncation error

DO i = 1, nbin-1
  bin(i) = COUNT(sample >= lbinbounds(i) .AND. sample < lbinbounds(i+1) .AND. lmask)
!, .AND. c_e(sample))
ENDDO
bin(nbin) = COUNT(sample >= lbinbounds(nbin) .AND. sample <= lbinbounds(nbin+1) .AND. lmask)
!, .AND. c_e(sample)) ! special case, include upper limit

IF (PRESENT(binbounds)) binbounds = lbinbounds

END SUBROUTINE stat_bind


FUNCTION stat_mode_histogramr(sample, nbin, start, finish, mask) RESULT(mode)
REAL,INTENT(in) :: sample(:)
INTEGER,INTENT(in) :: nbin
REAL,INTENT(in),OPTIONAL :: start
REAL,INTENT(in),OPTIONAL :: finish
LOGICAL,INTENT(in),OPTIONAL :: mask(:)

REAL :: mode

INTEGER :: loc(1)
INTEGER,ALLOCATABLE :: bin(:)
REAL,ALLOCATABLE :: binbounds(:)

CALL stat_bin(sample, bin, nbin, start, finish, mask, binbounds)
mode = rmiss
IF (ALLOCATED(bin)) THEN
  loc = MAXLOC(bin)
  mode = (binbounds(loc(1)) + binbounds(loc(1)+1))*0.5
ENDIF

END FUNCTION stat_mode_histogramr


FUNCTION stat_mode_histogramd(sample, nbin, start, finish, mask) RESULT(mode)
DOUBLE PRECISION,INTENT(in) :: sample(:)
INTEGER,INTENT(in) :: nbin
DOUBLE PRECISION,INTENT(in),OPTIONAL :: start
DOUBLE PRECISION,INTENT(in),OPTIONAL :: finish
LOGICAL,INTENT(in),OPTIONAL :: mask(:)

DOUBLE PRECISION :: mode

INTEGER :: loc(1)
INTEGER,ALLOCATABLE :: bin(:)
DOUBLE PRECISION,ALLOCATABLE :: binbounds(:)

CALL stat_bin(sample, bin, nbin, start, finish, mask, binbounds)
mode = rmiss
IF (ALLOCATED(bin)) THEN
  loc = MAXLOC(bin)
  mode = (binbounds(loc(1)) + binbounds(loc(1)+1))*0.5D0
ENDIF

END FUNCTION stat_mode_histogramd

!!$ Calcolo degli NDI calcolati
!!$
!!$ Gli NDI vengono calcolati all’interno degli intervalli dei percentili.
!!$ Questo significa che il numero di NDI è pari al numero di percentili
!!$ non degeneri meno 1; il metodo di calcolo è il seguente:
!!$
!!$ si calcola il Density Index (DI) per ogni intervallo di percentili
!!$ come rapporto fra quanti intervalli di percentile vengono utilizzati
!!$ per definire la larghezza dell’intervallo, più di uno se si hanno
!!$ percentili degeneri, e la larghezza dell’intervallo stesso.
!!$
!!$ Si calcola il valore dell’ADI (Actual Density Index) dividendo i DI
!!$ ottenuti in intervalli aventi percentili degeneri per il numero di
!!$ intervalli che hanno contribuito a definire quell’intervallo.
!!$
!!$ si calcola il valore del 50-esimo percentile dei valori degli ADI
!!$ precedentemente ottenuti;
!!$
!!$ si divide il valore degli ADI per il 50-percentile degli ADI in
!!$ maniera tale da normalizzarli ottenendo così gli NADI (Normalized
!!$ Actual Density Index) calcolati
!!$
!!$ Si sommano i NADI relativi ad intervalli di percentili degeneri
!!$ ottenendo gli NDI



!!$! Sobroutine calculating the number of NDI values
!!$SUBROUTINE NOFNDI_old(npclint, pcl0, pclint, pcl100, nndi) 
!!$
!!$INTEGER, INTENT(IN) :: npclint !< number of pclint
!!$REAL, INTENT(IN) :: pcl0     !< the 0-th percentile = min(sample)
!!$REAL, DIMENSION(npclint), INTENT(IN) :: pclint !< the percentiles between the 0-th percentile and the 100-th percentile
!!$REAL, INTENT(IN) :: pcl100   !< the 100-th percentile = max(sample)
!!$INTEGER, INTENT(OUT) :: nndi     !< number of NDI
!!$
!!$REAL, DIMENSION(:), allocatable :: pcl      !< array inglobing in itself pcl0, pclint and pcl100 
!!$INTEGER :: &
!!$     npcl,&
!!$     ipclint,&! integer loop variable on npclint
!!$     ipcl, &  ! integer loop variable on npcl=2+npclint
!!$     npcl_act ! number of non redundant values in pcl equal to the number of 
!!$              ! pcl_act values                                     
!!$
!!$! Calculation of npcl
!!$npcl=SIZE(pclint)+2
!!$
!!$! Allocation of pcl and its initialisation
!!$ALLOCATE(pcl(npcl))
!!$pcl(1)=pcl0
!!$DO ipclint=1,npclint
!!$  pcl(ipclint+1)=pclint(ipclint)
!!$ENDDO
!!$pcl(SIZE(pclint)+2)=pcl100
!!$
!!$IF ( ANY(pcl == rmiss) ) THEN
!!$  
!!$  nndi=0
!!$  
!!$ELSE
!!$  
!!$                                ! Calculation of npcl_act
!!$  npcl_act=1
!!$  DO ipcl=2,npcl
!!$    IF (pcl(ipcl) /= pcl(ipcl-1)) THEN
!!$      npcl_act=npcl_act+1
!!$    ENDIF
!!$  ENDDO
!!$  
!!$                                ! Definition of number of ndi that is the wanted output value
!!$  nndi=npcl_act-1
!!$      
!!$ENDIF
!!$
!!$
!!$END SUBROUTINE NOFNDI_old
!!$
!!$
!!$
!!$! Sobroutine calculating the ndi values
!!$SUBROUTINE NDIC_old(npclint, pcl0, pclint, pcl100, nndi, ndi, limbins) 
!!$
!!$INTEGER, INTENT(IN) :: npclint !< number of pclint
!!$REAL, INTENT(IN) :: pcl0   !< the 0-th percentile = min(sample)  
!!$REAL, DIMENSION(npclint), INTENT(IN) ::  pclint  !< the percentiles between the 0-th percentile and the 100-th percentile
!!$REAL, INTENT(IN) :: pcl100 !< the 100-th percentile = max(sample)
!!$INTEGER, INTENT(IN) ::  nndi      !< number of ndi 
!!$REAL, DIMENSION(nndi), INTENT(OUT) ::  ndi       !< ndi that I want to calculate
!!$REAL, DIMENSION(nndi+1), INTENT(OUT) :: limbins   !< ndi that I want to calculate
!!$    
!!$REAL, DIMENSION(:), allocatable :: &
!!$     pcl, &      ! array inglobing in itself pcl0, pclint and pcl100 
!!$     pcl_act, &  ! actual values of pcls removing redundat information
!!$     ranges, &   ! distances between the different pcl_act(s)
!!$     di, &       ! density indexes
!!$     adi, &      ! actual density indexes
!!$     nadi        ! normalized actual density indexes                      
!!$
!!$INTEGER, DIMENSION(:), allocatable ::  weights     ! weights = number of redundance times of a certain values
!!$                                                   ! in pcl values
!!$
!!$REAL, DIMENSION(1) :: &
!!$ perc_vals, & ! perc_vals contains the percentile position (0-100)
!!$ med          ! mediana value
!!$
!!$REAL, DIMENSION(:), allocatable :: infopclval
!!$INTEGER, DIMENSION(:), allocatable :: infopclnum
!!$
!!$INTEGER :: &
!!$ nbins,&       ! number of intervals
!!$ ibins,&       ! integer loop variable on nbins_act
!!$ nbins_act,&   ! number of non redundant intervals
!!$ ibins_act,&   ! integer loop variable on nbins_act
!!$ ipclint,&     ! integer loop variable on npclint
!!$ npcl, &       ! number of percentiles 
!!$ ipcl, &       ! integer loop variable on npcl
!!$ npcl_act,&    ! number of non redundant percentiles
!!$ ipcl_act,&    ! integer loop variable on npcl_act
!!$ npclplus, &   ! plus number information
!!$ ncount        ! number of redundant percentiles values
!!$    
!!$
!!$! Actual number of percentiles
!!$npcl=SIZE(pclint)+2
!!$    
!!$! Allocation of infopclval and infopclnum
!!$ALLOCATE(infopclval(npcl))
!!$ALLOCATE(infopclnum(npcl))
!!$infopclval(:)=0
!!$infopclnum(:)=0
!!$    
!!$! Allocation of pcl
!!$ALLOCATE(pcl(npcl))
!!$! and storing of pcl values
!!$pcl(1)=pcl0
!!$DO ipclint=1,npclint
!!$  pcl(ipclint+1)=pclint(ipclint)
!!$ENDDO
!!$pcl(SIZE(pclint)+2)=pcl100
!!$
!!$                                ! Calculation of non redundant values of percentiles    
!!$
!!$npcl_act=1
!!$infopclval(1) = pcl(1)
!!$infopclnum(1) = 1
!!$
!!$DO ipcl=2,npcl
!!$  infopclval(ipcl) = pcl(ipcl)
!!$  IF ( pcl(ipcl) /= pcl(ipcl-1) ) THEN
!!$    npcl_act = npcl_act + 1
!!$  ENDIF
!!$  infopclnum(ipcl) = npcl_act
!!$ENDDO
!!$
!!$                                ! Allocation of pcl_act
!!$ALLOCATE(pcl_act(npcl_act))
!!$                                ! and storing in pcl_act of percentiles values
!!$DO ipcl_act=1,npcl_act
!!$  DO ipcl=1,npcl
!!$    IF (ipcl_act == infopclnum(ipcl)) THEN
!!$      pcl_act(ipcl_act) = pcl(ipcl)
!!$      CYCLE
!!$    ENDIF
!!$  ENDDO
!!$ENDDO
!!$
!!$
!!$                                ! Allocation of ranges, weights and di and their initialisation
!!$ALLOCATE(ranges(npcl_act-1))
!!$ALLOCATE(weights(npcl_act-1))
!!$ALLOCATE(di(npcl_act-1))
!!$ranges(:)=0
!!$di(:)=0
!!$weights(:)=0
!!$
!!$                                ! Definition of nbins_act
!!$nbins_act=npcl_act-1
!!$                                ! Cycle on ibins_act for calculating ranges and weights
!!$                                ! and consequently the di values
!!$DO ibins_act=1,nbins_act
!!$  ranges(ibins_act)=pcl_act(ibins_act+1) - pcl_act(ibins_act)
!!$
!!$  IF ( pcl_act(ibins_act+1) ==  pcl_act(npcl_act) ) THEN
!!$    weights(ibins_act) =  COUNT( ibins_act == infopclnum ) + &
!!$     COUNT( ibins_act+1 == infopclnum ) - 1
!!$  ELSE
!!$    weights(ibins_act) =  COUNT ( ibins_act == infopclnum )
!!$  ENDIF
!!$  di(ibins_act) = weights(ibins_act)/ranges(ibins_act)
!!$ENDDO
!!$    
!!$                                ! Allocation of adi and its initialisation
!!$ALLOCATE(adi(npcl-1))
!!$adi(:)=0
!!$npclplus=0
!!$DO ibins_act=1,nbins_act
!!$  ncount=weights(ibins_act)
!!$                                ! Calculation of adi
!!$  DO ibins=npclplus + 1,npclplus + ncount
!!$    adi(ibins)=di(ibins_act)/ncount
!!$  ENDDO
!!$  npclplus=npclplus+ncount
!!$ENDDO
!!$    
!!$                                ! Mediana calculation for perc_vals
!!$perc_vals(1)=50
!!$med = stat_percentile(sample=adi, perc_vals=perc_vals)
!!$                                ! Allocation of nadi and its initialisation 
!!$ALLOCATE(nadi(npcl-1))
!!$nadi(:)=0
!!$                                ! Definition of values of nadi
!!$nadi(:) = adi(:)/med(1)
!!$
!!$                                ! Initialisation of ndi
!!$ndi(:)=0
!!$                                ! Calculation of the ndi values
!!$ipcl_act=1
!!$nbins=npcl-1
!!$DO ibins=1,nbins
!!$  ndi(ipcl_act)=nadi(ibins)+ndi(ipcl_act)
!!$  IF ( ( pcl(ibins+1) /= pcl(ibins) ) .AND. &
!!$   ( pcl(ibins+1) /= pcl(npcl) ) ) THEN
!!$    ipcl_act=ipcl_act+1
!!$  ENDIF
!!$ENDDO
!!$
!!$DO ipcl_act=1,npcl_act
!!$  limbins(ipcl_act)=pcl_act(ipcl_act)
!!$ENDDO
!!$
!!$                                ! Deallocation part
!!$DEALLOCATE(infopclval)
!!$DEALLOCATE(infopclnum)
!!$DEALLOCATE(pcl)
!!$DEALLOCATE(pcl_act)
!!$DEALLOCATE(ranges)
!!$DEALLOCATE(weights)
!!$DEALLOCATE(di)
!!$DEALLOCATE(adi)
!!$DEALLOCATE(nadi)
!!$
!!$END SUBROUTINE NDIC_old
!!$
!!$
!!$!> Calculate the number of NDI values
!!$SUBROUTINE NOFNDI(pcl, nndi) 
!!$
!!$REAL, DIMENSION(:), INTENT(IN) :: pcl !< the percentiles between the 0-th percentile and the 100-th percentile
!!$INTEGER, INTENT(OUT) :: nndi     !< number of NDI
!!$
!!$IF ( ANY(pcl == rmiss) ) then
!!$  nndi=0
!!$else
!!$  nndi=count_distinct(pcl)-1
!!$end IF
!!$
!!$END SUBROUTINE NOFNDI



!!$!example to manage exceptions
!!$
!!$use,intrinsic :: IEEE_EXCEPTIONS
!!$
!!$logical fail_o,fail_zero
!!$
!!$a=10.
!!$b=tiny(0.)
!!$
!!$call safe_divide(a,b,c,fail_o,fail_zero)
!!$
!!$print*,fail_o,fail_zero
!!$print *,a,b,c
!!$
!!$b=0.
!!$call safe_divide(a,b,c,fail_o,fail_zero)
!!$
!!$print*,fail_o,fail_zero
!!$print *,a,b,c
!!$
!!$contains
!!$
!!$subroutine safe_divide(a, b, c, fail_o,fail_zero)
!!$
!!$real a, b, c
!!$logical fail_o,fail_zero
!!$type(IEEE_STATUS_TYPE) status
!!$! save the current floating-point environment, turn halting for
!!$! divide-by-zero off, and clear any previous divide-by-zero flag
!!$call IEEE_GET_STATUS(status)
!!$call IEEE_SET_HALTING_MODE(IEEE_DIVIDE_BY_ZERO, .false.)
!!$call IEEE_SET_HALTING_MODE(ieee_overflow, .false.)
!!$
!!$call IEEE_SET_FLAG(ieee_overflow, .false.)
!!$call IEEE_SET_FLAG(IEEE_DIVIDE_BY_ZERO, .false.)
!!$! perform the operation
!!$c = a/b
!!$! determine if a failure occurred and restore the floating-point environment
!!$call IEEE_GET_FLAG(ieee_overflow, fail_o)
!!$call IEEE_GET_FLAG(IEEE_DIVIDE_BY_ZERO, fail_zero)
!!$call IEEE_SET_STATUS(status)
!!$end subroutine safe_divide
!!$end program 
!!$


! here you have to adopt the example above in the code below the use the wrong logic isnan()

!!$!check NaN
!!$if (any(isnan(di)) .and. .not. all(isnan(di))) then
!!$
!!$! from left
!!$  do i=2,size(delta)
!!$    if (isnan(di(i)) .and. .not. isnan(di(i-1))) then
!!$      delta(i) = delta(i-1)
!!$      w(i)     = w(i) + w(i-1)
!!$    end if
!!$  end do
!!$  
!!$! recompute
!!$  print *,"WW=",w
!!$  di = w/delta 
!!$
!!$  if (any(isnan(di)) .and. .not. all(isnan(di))) then
!!$
!!$! from right
!!$    do i=size(delta)-1,1,-1
!!$      if (isnan(di(i)) .and. .not. isnan(di(i+1))) then
!!$        delta(i) = delta(i+1)
!!$        w(i)     = w(i) + w(i+1)
!!$      end if
!!$    end do
!!$
!!$! one more step
!!$    call DensityIndex(di,perc_vals,limbins)
!!$  end if
!!$end if


!!$subroutine DensityIndex_old(di,perc_vals,limbins)
!!$real,intent(inout)          :: di(:)
!!$real,intent(in)             :: perc_vals(:)
!!$real,intent(in)             :: limbins(:)
!!$
!!$real :: delta(size(di)),w(size(di))
!!$integer :: i
!!$
!!$do i=1,size(delta)
!!$  delta(i) = limbins(i+1)   - limbins(i)
!!$  w(i)     = perc_vals(i+1) - perc_vals(i)
!!$end do
!!$
!!$di=rmiss
!!$
!!$if ( .not. all(delta == 0.)) then
!!$  call DensityIndex_recurse(delta,w)
!!$  di = w/delta 
!!$end if
!!$
!!$end subroutine DensityIndex_old
!!$
!!$recursive subroutine DensityIndex_recurse(delta,w)
!!$real :: delta(:),w(:)
!!$integer :: i
!!$
!!$!check divide by 0
!!$if (any(delta == 0.0)) then
!!$
!!$! from left
!!$  do i=2,size(delta)
!!$    if (delta(i) == 0.0 .and. delta(i-1) > 0.0 ) then
!!$      delta(i) = delta(i-1)
!!$      w(i)     = w(i) + w(i-1)
!!$    end if
!!$  end do
!!$
!!$! from right
!!$  do i=size(delta)-1,1,-1
!!$    if (delta(i) == 0.0 .and. delta(i+1) > 0.0 )then
!!$      delta(i) = delta(i+1)
!!$      w(i)     = w(i) + w(i+1)
!!$    end if
!!$  end do
!!$
!!$end if
!!$
!!$! one more step
!!$if (any(delta == 0.0)) then
!!$  call DensityIndex_recurse(delta,w)
!!$end if
!!$
!!$end subroutine DensityIndex_recurse
!!$

subroutine DensityIndex(di,nlimbins,occu,rnum,limbins)
real,intent(out)                :: di(:)
real,intent(out)                :: nlimbins(:)
integer,intent(out)             :: occu(:)
REAL, DIMENSION(:), INTENT(IN)  :: rnum  !< data to analize
real,intent(in)                 :: limbins(:)

real :: nnum(size(rnum))
integer :: i,k,sample_count
logical :: sample_mask(size(rnum))

di=rmiss
occu=imiss
nlimbins=rmiss

nlimbins(1)=limbins(1)               ! compute unique limits
k=1
do i=2,size(limbins)
  if (limbins(i) /= limbins(k)) then
    k=k+1
    nlimbins(k)= limbins(i)
  end if
end do

di=rmiss
if (k == 1) return

sample_mask = (rnum /= rmiss)        ! remove missing values
sample_count = COUNT(sample_mask)
IF (sample_count == 0) RETURN 
nnum(1:sample_count) = PACK(rnum, mask=sample_mask)

do i=1,k-2                           ! compute occorrence and density index
  occu(i)=count(nnum>=nlimbins(i) .and. nnum<nlimbins(i+1))
  di(i) = float(occu(i)) / (nlimbins(i+1) - nlimbins(i))
end do

i=k-1                  ! the last if is <=
occu(i)=count(nnum>=nlimbins(i) .and. nnum<=nlimbins(i+1))
di(i) = float(occu(i)) / (nlimbins(i+1) - nlimbins(i))

end subroutine DensityIndex


!> Compute Normalized Density Index
SUBROUTINE NormalizedDensityIndex(rnum, perc_vals, ndi, nlimbins)

REAL, DIMENSION(:), INTENT(IN)  :: rnum  !< data to analize
REAL, DIMENSION(:), INTENT(IN)  :: perc_vals  !<the percentiles values to be computed, between 0. and 100.
REAL, DIMENSION(:), INTENT(OUT) :: ndi       !< normalized density index
REAL, DIMENSION(:), INTENT(OUT) :: nlimbins   !< the extreme values of data taken in account for ndi computation
    
REAL, DIMENSION(size(ndi)) :: di
INTEGER, DIMENSION(size(ndi)) :: occu
REAL, DIMENSION(size(nlimbins)) :: limbins
real    :: med
integer :: i,k,middle

ndi=rmiss
limbins = stat_percentile(rnum,perc_vals)     ! compute percentile

call DensityIndex(di,nlimbins,occu,rnum,limbins)

! Mediana calculation for density index
k=0
middle=count(c_e(rnum))/2

do i=1,count(c_e(occu))
  k=k+occu(i)
  if (k > middle) then
    if (k > 1 .and. (k - occu(i)) == middle) then
      med = (di(i-1) + di(i)) / 2.
    else
      med = di(i)
    end if
    exit
  end if
end do

!weighted density index
ndi(:count(c_e(di))) = min(pack(di,mask=c_e(di))/med,1.0)

END SUBROUTINE NormalizedDensityIndex


!! TODO translate from python

!!$def gauss(x, A=1, mu=1, sigma=1):
!!$    """
!!$    Evaluate Gaussian.
!!$    
!!$    Parameters
!!$    ----------
!!$    A : float
!!$        Amplitude.
!!$    mu : float
!!$        Mean.
!!$    std : float
!!$        Standard deviation.
!!$
!!$    """
!!$    return np.real(A * np.exp(-(x - mu)**2 / (2 * sigma**2)))
!!$
!!$def fit_direct(x, y, F=0, weighted=True, _weights=None):
!!$    """Fit a Gaussian to the given data.
!!$
!!$    Returns a fit so that y ~ gauss(x, A, mu, sigma)
!!$
!!$    Parameters
!!$    ----------
!!$    x : ndarray
!!$        Sampling positions.
!!$    y : ndarray
!!$        Sampled values.
!!$    F : float
!!$        Ignore values of y <= F.
!!$    weighted : bool
!!$        Whether to use weighted least squares.  If True, weigh
!!$        the error function by y, ensuring that small values
!!$        has less influence on the outcome.
!!$
!!$    Additional Parameters
!!$    ---------------------
!!$    _weights : ndarray
!!$        Weights used in weighted least squares.  For internal use
!!$        by fit_iterative.
!!$
!!$    Returns
!!$    -------
!!$    A : float
!!$        Amplitude.
!!$    mu : float
!!$        Mean.
!!$    std : float
!!$        Standard deviation.
!!$
!!$    """
!!$    mask = (y > F)
!!$    x = x[mask]
!!$    y = y[mask]
!!$
!!$    if _weights is None:
!!$        _weights = y
!!$    else:
!!$        _weights = _weights[mask]
!!$
!!$    # We do not want to risk working with negative values
!!$    np.clip(y, 1e-10, np.inf, y)
!!$
!!$    e = np.ones(len(x))
!!$    if weighted:
!!$        e = e * (_weights**2)
!!$    
!!$    v = (np.sum(np.vander(x, 5) * e[:, None], axis=0))[::-1]
!!$    A = v[sl.hankel([0, 1, 2], [2, 3, 4])]
!!$
!!$    ly = e * np.log(y)
!!$    ls = np.sum(ly)
!!$    x_ls = np.sum(ly * x)
!!$    xx_ls = np.sum(ly * x**2)
!!$    B = np.array([ls, x_ls, xx_ls])
!!$
!!$    (a, b, c), res, rank, s = np.linalg.lstsq(A, B)
!!$
!!$    A = np.exp(a - (b**2 / (4 * c)))
!!$    mu = -b / (2 * c)
!!$    sigma = sp.sqrt(-1 / (2 * c))
!!$
!!$    return A, mu, sigma
!!$
!!$def fit_iterative(x, y, F=0, weighted=True, N=10):
!!$    """Fit a Gaussian to the given data.
!!$
!!$    Returns a fit so that y ~ gauss(x, A, mu, sigma)
!!$
!!$    This function iteratively fits using fit_direct.
!!$    
!!$    Parameters
!!$    ----------
!!$    x : ndarray
!!$        Sampling positions.
!!$    y : ndarray
!!$        Sampled values.
!!$    F : float
!!$        Ignore values of y <= F.
!!$    weighted : bool
!!$        Whether to use weighted least squares.  If True, weigh
!!$        the error function by y, ensuring that small values
!!$        has less influence on the outcome.
!!$    N : int
!!$        Number of iterations.
!!$
!!$    Returns
!!$    -------
!!$    A : float
!!$        Amplitude.
!!$    mu : float
!!$        Mean.
!!$    std : float
!!$        Standard deviation.
!!$
!!$    """
!!$    y_ = y
!!$    for i in range(N):
!!$        p = fit_direct(x, y, weighted=True, _weights=y_)
!!$        A, mu, sigma = p
!!$        y_ = gauss(x, A, mu, sigma)
!!$
!!$    return np.real(A), np.real(mu), np.real(sigma)
!!$



END MODULE simple_stat
