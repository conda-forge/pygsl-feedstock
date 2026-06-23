@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "INCLUDE=%LIBRARY_INC%;%INCLUDE%"
set "LIB=%LIBRARY_LIB%;%LIB%"
set "PATH=%LIBRARY_BIN%;%PREFIX%;%PATH%"

set "PKG_CONFIG=%LIBRARY_BIN%\pkg-config.exe"
set "PKG_CONFIG_PATH=%LIBRARY_LIB%\pkgconfig;%PKG_CONFIG_PATH%"

REM Activate the conda-forge VS2022 compiler environment explicitly.
if exist "%BUILD_PREFIX%\etc\conda\activate.d\vs2022_compiler_vars.bat" (
    call "%BUILD_PREFIX%\etc\conda\activate.d\vs2022_compiler_vars.bat"
) else (
    echo ERROR: compiler activation script not found:
    echo %BUILD_PREFIX%\etc\conda\activate.d\vs2022_compiler_vars.bat
    exit /b 1
)

set "CC=cl"
set "CXX=cl"

meson setup builddir --prefix="%PREFIX%" --buildtype=release
if errorlevel 1 exit /b 1

meson compile -C builddir
if errorlevel 1 exit /b 1

meson install -C builddir
if errorlevel 1 exit /b 1
