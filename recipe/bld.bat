:: Start with bootstrap
call bootstrap.bat vc%VS_MAJOR%

if errorlevel 1 exit /b 1

:: Build step
.\b2 -d+2 ^
    --build-dir=buildboost ^
    --prefix=%LIBRARY_PREFIX% ^
    toolset=msvc-%VS_MAJOR%.0 ^
    address-model=%ARCH% ^
    variant=release ^
    threading=multi ^
    link=static,shared ^
    -j%CPU_COUNT% ^
    --without-python
if errorlevel 1 exit /b 1
