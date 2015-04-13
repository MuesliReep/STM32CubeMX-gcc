@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
cls
CD /D %~dp0

set LIB=libSTM32F4_CUBE.a
set CC=arm-none-eabi-gcc
set AR=arm-none-eabi-ar
set RANLIB=arm-none-eabi-ranlib
set BLDDIR=bld
set LIBDIR=lib

set CHIP_ID=STM32F427xx
set SUB_ID=VI
set STARTUP_NAME=startup_stm32f427xx

:: Include Dirs
set INCLUDES=-IInc/ -Iinclude/ -IDrivers/STM32F4xx_HAL_Driver/Inc/ -IDrivers/CMSIS/Include/ -IDrivers/CMSIS/Device/ST/STM32F4xx/Include/

:: MCFLAGS
set MCFLAGS=-mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16

:: CFLAGS
set CFLAGS=-g %MCFLAGS% -ffreestanding -Wall -mlong-calls -nostdlib -O1 %INCLUDES% -D %CHIP_ID% -D USE_HAL_DRIVER

:: Source files
set SRCDIR=Drivers/STM32F4xx_HAL_Driver/Src
set DRIVER_FILES=(stm32f4xx_hal stm32f4xx_hal_adc stm32f4xx_hal_adc_ex stm32f4xx_hal_can stm32f4xx_hal_cortex stm32f4xx_hal_crc stm32f4xx_hal_cryp stm32f4xx_hal_cryp_ex stm32f4xx_hal_dac stm32f4xx_hal_dac_ex stm32f4xx_hal_dcmi stm32f4xx_hal_dma stm32f4xx_hal_dma2d stm32f4xx_hal_dma_ex stm32f4xx_hal_eth stm32f4xx_hal_flash stm32f4xx_hal_flash_ex stm32f4xx_hal_flash_ramfunc stm32f4xx_hal_gpio stm32f4xx_hal_hash stm32f4xx_hal_hash_ex stm32f4xx_hal_hcd stm32f4xx_hal_i2c stm32f4xx_hal_i2c_ex stm32f4xx_hal_i2s stm32f4xx_hal_i2s_ex stm32f4xx_hal_irda stm32f4xx_hal_iwdg stm32f4xx_hal_ltdc stm32f4xx_hal_msp_template stm32f4xx_hal_nand stm32f4xx_hal_nor stm32f4xx_hal_pccard stm32f4xx_hal_pcd stm32f4xx_hal_pcd_ex stm32f4xx_hal_pwr stm32f4xx_hal_pwr_ex stm32f4xx_hal_rcc stm32f4xx_hal_rcc_ex stm32f4xx_hal_rng stm32f4xx_hal_rtc stm32f4xx_hal_rtc_ex stm32f4xx_hal_sai stm32f4xx_hal_sd stm32f4xx_hal_sdram stm32f4xx_hal_smartcard stm32f4xx_hal_spi stm32f4xx_hal_sram stm32f4xx_hal_tim stm32f4xx_hal_tim_ex stm32f4xx_hal_uart stm32f4xx_hal_usart stm32f4xx_hal_wwdg stm32f4xx_ll_fmc stm32f4xx_ll_fsmc stm32f4xx_ll_sdmmc stm32f4xx_ll_usb)
::CD Drivers/STM32F4xx_HAL_Driver/Src
::for %%f in (*) do set DRIVER_FILES=%DRIVER_FILES% Drivers/STM32F4xx_HAL_Driver/Src/%%~nf
::CD /D %~dp0

IF NOT EXIST %BLDDIR% mkdir %BLDDIR%
IF NOT EXIST %LIBDIR% mkdir %LIBDIR%

:: Execute

for %%i in %DRIVER_FILES% do echo  CC   %SRCDIR%/%%i.c & %CC% %CFLAGS% -c %SRCDIR%/%%i.c -o %BLDDIR%/%%i.o

for %%i in %DRIVER_FILES% do set OBJ=!OBJ! %BLDDIR%/%%i.o
echo  AR  %LIB% & %AR% -r %LIBDIR%/%LIB% %OBJ%
echo  RANLIB %LIB% & %RANLIB% %LIBDIR%/%LIB%
