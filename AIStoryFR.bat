@echo off

set PYTHONIOENCODING=utf-8

set PY="venv\python.exe"

for %%X in (wt.exe) do (set FOUNDWT=%%~$PATH:X)
if not defined FOUNDWT (
    start "AIStoryFR" %PY% main.py
) else (
    wt.exe --title "AIStoryFR" -d "%~dp0/" -p "Windows PowerShell" %PY% main.py
)
