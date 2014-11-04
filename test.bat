@echo off
SETLOCAL ENABLEDELAYEDEXPANSION enableextensions
cls
CD /D %~dp0

::CD Drivers/STM32F4xx_HAL_Driver/Src
::for %%i in (*) do echo %%~ni

set SRCDIR=Drivers/STM32F4xx_HAL_Driver/Src
CD %SRCDIR%

::set DRIVER_FILES=
::for %%f in (*) do set DRIVER_FILES=!DRIVER_FILES! %%~nf
::set DRIVER_FILES=%DRIVER_FILES:~1%

set LIST=
for %%x in (*) do set LIST=!LIST! %%x
set LIST=%LIST:~1%

for %%i in !LIST! do echo %%i.c

CD /D %~dp0


::for %%i in %DRIVER_FILES% do echo  %SRCDIR%/%%i.c


http://stackoverflow.com/questions/3238433/batch-file-write-list-of-files-to-variable
