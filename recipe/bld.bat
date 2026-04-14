@echo on
setlocal EnableExtensions EnableDelayedExpansion

set "INCLUDE=%LIBRARY_INC%;%INCLUDE%"
set "LIB=%LIBRARY_LIB%;%LIB%"
set "PATH=%LIBRARY_BIN%;%PREFIX%;%PATH%"
set "PKG_CONFIG_PATH=%LIBRARY_LIB%\pkgconfig;%PREFIX%\Library\lib\pkgconfig;%PKG_CONFIG_PATH%"

where python
where swig
where pkg-config

if not exist "%LIBRARY_INC%\gsl" (
    echo ERROR: GSL headers not found at %LIBRARY_INC%\gsl
    dir "%LIBRARY_INC%"
    exit /b 1
)

meson setup builddir --prefix="%PREFIX%" --buildtype=release
if errorlevel 1 exit /b 1

meson compile -C builddir -v
if errorlevel 1 exit /b 1

meson install -C builddir
if errorlevel 1 exit /b 1