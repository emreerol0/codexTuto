@echo off
setlocal

python -m pip install --upgrade pip
python -m pip install -r requirements.txt
python -m pip install pyinstaller

pyinstaller --noconfirm --onefile --windowed --name WordToPdfConverter app.py

echo Build complete. Executable is in dist\WordToPdfConverter.exe
