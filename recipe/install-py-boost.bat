call "%PREFIX%\Scripts\activate.bat" "%PREFIX%"

b2 -q ^
      python=%PY_VER% ^
      -j%CPU_COUNT% ^
      --with-python ^
      install > b2.install-py-%PY_VER%.log 2>&1
