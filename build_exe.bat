@echo off
setlocal

set "DEFAULT_OUTPUT_DIR=%~dp0dist"
set /p OUTPUT_DIR=Enter output folder for the executable [default: %DEFAULT_OUTPUT_DIR%]: 
if "%OUTPUT_DIR%"=="" set "OUTPUT_DIR=%DEFAULT_OUTPUT_DIR%"

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

python -m pip install --upgrade pip
python -m pip install -r requirements.txt
python -m pip install pyinstaller

pyinstaller --noconfirm --onefile --windowed --name WordToPdfConverter --distpath "%OUTPUT_DIR%" app.py

if errorlevel 1 (
    echo Build failed.
    exit /b 1
)

echo Build complete. Executable is in "%OUTPUT_DIR%\WordToPdfConverter.exe"
