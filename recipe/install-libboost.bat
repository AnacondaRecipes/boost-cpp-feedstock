call "%PREFIX%\Scripts\activate.bat" "%PREFIX%"

b2 -q ^
     install > b2.install.log 2>&1

:: Get the major_minor_patch version info, e.g. `1_61_1`. In
:: the past this has been just major_minor, so we do not just
:: replace all dots with underscores in case it changes again
for /F "tokens=1,2,3 delims=." %%a in ("%PKG_VERSION%") do (
   set MAJ=%%a
   set MIN=%%b
   set PAT=%%c
)
set MAJ_MIN_PAT_VER=%MAJ%_%MIN%_%PAT%

:: Install fix-up for a non version-specific boost include
move %LIBRARY_INC%\boost-%MAJ_MIN_PAT_VER%\boost %LIBRARY_INC%
if errorlevel 1 exit /b 1

:: Remove Python headers as we don't build Boost.Python.
del %LIBRARY_INC%\boost\python.hpp
rmdir /s /q %LIBRARY_INC%\boost\python

:: Move DLLs to LIBRARY_BIN
move %LIBRARY_LIB%\*vc%VS_MAJOR%0-mt-%MAJ_MIN_PAT_VER%.dll "%LIBRARY_BIN%"
if errorlevel 1 exit /b 1
