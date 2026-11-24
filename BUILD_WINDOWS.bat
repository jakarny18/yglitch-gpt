@echo off
setlocal
echo ==========================================
echo YouGlitch SMP 1024 - Windows x64 build
echo ==========================================
cmake -S . -B build -A x64 -DCMAKE_BUILD_TYPE=Release
if errorlevel 1 goto :error
cmake --build build --config Release --parallel 2
if errorlevel 1 goto :error
echo.
echo Build complete. Check build\YouGlitchSMP1024_artefacts\Release\
pause
exit /b 0
:error
echo.
echo Build failed. Copy the complete error log before closing this window.
pause
exit /b 1
