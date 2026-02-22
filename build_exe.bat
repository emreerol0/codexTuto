@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "DEFAULT_OUTPUT_DIR=%SCRIPT_DIR%dist"
set /p OUTPUT_DIR=Enter output folder for the executable [default: %DEFAULT_OUTPUT_DIR%]: 
if "%OUTPUT_DIR%"=="" set "OUTPUT_DIR=%DEFAULT_OUTPUT_DIR%"

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

python -m pip install --upgrade pip
if errorlevel 1 goto :build_failed

python -m pip install -r "%SCRIPT_DIR%requirements.txt"
if errorlevel 1 goto :build_failed

python -m pip install pyinstaller
if errorlevel 1 goto :build_failed

pyinstaller --noconfirm --clean --onefile --windowed ^
  --name WordToPdfConverter ^
  --distpath "%OUTPUT_DIR%" ^
  --hidden-import pythoncom ^
  --hidden-import pywintypes ^
  --collect-submodules win32com ^
  "%SCRIPT_DIR%app.py"

if errorlevel 1 goto :build_failed

set "EXE_PATH=%OUTPUT_DIR%\WordToPdfConverter.exe"
if exist "%EXE_PATH%" goto :build_success

for /f "delims=" %%F in ('dir /b /s "%OUTPUT_DIR%\WordToPdfConverter*.exe" 2^>nul') do (
    set "EXE_PATH=%%F"
    goto :build_success
)

for /f "delims=" %%F in ('dir /b /s "%SCRIPT_DIR%dist\WordToPdfConverter*.exe" 2^>nul') do (
    set "EXE_PATH=%%F"
    goto :build_success
)

echo Build finished, but no executable was found.
echo Check the PyInstaller output above for errors.
exit /b 1

:build_success
echo Build complete. Executable is at "%EXE_PATH%"
exit /b 0

:build_failed
echo Build failed.
exit /b 1
