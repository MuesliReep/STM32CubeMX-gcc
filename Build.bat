@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
cls
CD /D %~dp0

set BIN=F4Discovery
set CUBENAME=F4Discovery
set EXECUTABLE=%CUBENAME%.elf
set BIN_IMAGE=%CUBENAME%.bin

:: Compiler
set CC=arm-none-eabi-gcc
set CP=arm-none-eabi-objcopy
set OPT=0

set CHIP_ID=STM32F407
set SUB_ID=VG
set STARTUP_NAME=startup_stm32f407xx

:: Includes
set INCLUDES=-IInc/ -IDrivers/STM32F4xx_HAL_Driver/Inc/ -IDrivers/CMSIS/Include/ -IDrivers/CMSIS/Device/ST/STM32F4xx/Include/

:: Defines
set CFLAGS_DEFINE=-D %CHIP_ID%xx -D USE_HAL_DRIVER -D "__weak = __attribute__((weak))" -D "__packed = __attribute__((__packed__))"

:: MCFLAGS
set MCFLAGS=-mlittle-endian -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16

:: NANO
set CFLAGS_NANO_NEW_LIB=--specs=nano.specs --specs=nosys.specs

:: LD script
::set LDSCRIPT=/Projects/TrueSTUDIO/%CUBENAME% Configuration/%CHIP_ID%%SUB_ID%_FLASH.ld
IF NOT EXIST %CHIP_ID%%SUB_ID%_FLASH.ld echo ERROR: MISSING LD SCRIPT & EXIT /B
set LDSCRIPT=%CHIP_ID%%SUB_ID%_FLASH.ld

:: CFLAGS
set CFLAGS=-O%OPT% %MCFLAGS% -ffreestanding -Wall -Wl,-T,%LDSCRIPT% -mlong-calls %INCLUDES% %CFLAGS_DEFINE% %CFLAGS_NANO_NEW_LIB%

:: Libraries
set LIBS=-Llib -lSTM32F4_CUBE -lm -lc -lgcc

:: Dirs & Files
set SRCDIR=Src
set BLDDIR=bld
set LIBDIR=lib
set OBJ=
set SRCFILES=

set STARTUP=Drivers/CMSIS/Device/ST/STM32F4xx/Source/Templates/gcc/%STARTUP_NAME%.s

set SRC_FILES=Drivers/CMSIS/Device/ST/STM32F4xx/Source/Templates/system_stm32f4xx.c %SRCDIR%/main.c %SRCDIR%/stm32f4xx_hal_msp.c %SRCDIR%/stm32f4xx_it.c
::set SRC_FILES=(Drivers/CMSIS/Device/ST/STM32F4xx/Source/Templates/system_stm32f4xx %SRCDIR%/main %SRCDIR%/stm32f4xx_hal_msp %SRCDIR%/stm32f4xx_it)
::CD %SRCDIR%
::for %%f in (*) do set SRC_FILES=!SRC_FILES! %SRCDIR%/%%~nf
::CD /D %~dp0

IF NOT EXIST %LIBDIR%/libSTM32F4_CUBE.a echo ERROR:  LIBS MUST BE BUILT BEFORE BUILDING EXECUTABLE & EXIT /B
IF NOT EXIST %BLDDIR% mkdir %BLDDIR%

:: Execute

set STARTUP_OBJ=%STARTUP_NAME%.o
echo  CC   %STARTUP_OBJ% & %CC% %CFLAGS% %STARTUP% -c %STARTUP%

echo  CC   %EXECUTABLE% & %CC% %CFLAGS% %SRC_FILES% %STARTUP_OBJ% -o %EXECUTABLE% %LIBS%

echo  OBJCOPY   %BIN_IMAGE% & %CP% -O binary %EXECUTABLE% %BIN_IMAGE%
