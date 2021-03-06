!******************************************************************************
! $Source: /long/munnich/CVSROOT/UCLA/qtcmf90/src/driver.f90,v $
! $Author: munnich $
! $Revision: 1.8 $
! $Date: 2002/07/25 00:02:00 $
!
! File: driver.f90
!
! Drives qtcm and ocean, structured like a coupled ocean-atmosphere
!   model
!
! Code history:
!   Original Version:                 Bill Weibel    Nov 1996
!   Partial revision for SST input :  Ning Zeng      Jan 1997
!   QTCM1 release (QTCM1 Version2.0)                 June 1998
!******************************************************************************


Subroutine Driver

  Use Calendar, only : dateofmodel
  !@@@ restore line after diagnostics done Use Input, only : lastday, interval
  Use Input

  Implicit none
  Integer   :: day      

  !
  ! Initializing 
  call qtcmInit                !atmo
  call oceanInit               !ocean
  call outpInit                !initialize output (open global files)      
  print'(a,i8.8)', 'Driver: Starting at model date ', dateofmodel
  !
  ! Main loop of ocean-atmosphere coupling
  print'(a,a)', '------------', outdir !@@@
  do day = 1, lastday, interval
     call timeManager(day)     ! set the calendar
     call ocean(interval,day)  ! ocean; generate SST for atmo
     call qtcm(interval)       ! atmo
     call outpAll              ! output all
     print '(a,i6,a,i8.8)', 'Driver: Running for',day, &
         &             ' days at model date ', dateofmodel

     ! call flush(6) ! flush not known on some machines
  enddo
  !
  ! Write Restart file

  call outrestart

  print*,'QTCM finished normally'
End Subroutine Driver
!
! =============================================================================

