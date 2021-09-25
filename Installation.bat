:: Windows installer

@echo off

setlocal EnableDelayedExpansion

rem  Define some useful colorcode vars:
for /F "delims=#" %%E in ('"prompt #$E# & for %%E in (1) do rem"') do set "ESCchar=%%E"
set "green=%ESCchar%[92m"
set "yellow=%ESCchar%[93m"
set "magenta=%ESCchar%[95m"
set "cyan=%ESCchar%[96m"
set "white=%ESCchar%[97m"
set "black=%ESCchar%[30m"

::create save folder
mkdir save

:: update embeddable package from https://www.python.org/downloads/windows/
set PythonURL=https://www.python.org/ftp/python/3.9.7/python-3.9.7-embed-amd64.zip
set PythonPathFile=python39._pth

:: update from https://github.com/microsoft/terminal/releases
set WindowsTerminalURL=https://github.com/microsoft/terminal/releases/download/v1.7.1091.0/Microsoft.WindowsTerminal_1.7.1091.0_8wekyb3d8bbwe.msixbundle

:: Checking if the user has curl and tar installed
for %%X in (curl.exe) do (set HasCurl=%%~$PATH:X)
for %%X in (tar.exe) do (set HasTar=%%~$PATH:X)

echo %cyan%
echo AIStoryFR Installation pour Windows 64 bits
echo -------------------------------------------
echo.
echo D‚sactivez votre anti-virus pour l'installation
echo Utiliser une carte Graphique NVidia poss‚dant 8GB de VRAM si vous utilisez le mode GPU
echo.
:: console bell
echo 

:selectcuda
echo.
echo %yellow%
echo 1) Installer la version Nvidia GPU (CUDA).
echo 2) Installer la version CPU.
echo 0) Annuler
echo.
echo %white%
set /p usecuda="Entrez votre choix: "
echo.
if %usecuda%==1 (goto install)
if %usecuda%==2 (goto install)
if %usecuda%==0 (exit) else (goto selectcuda)
:install
:: Create /venv/
echo.
echo %green%Cr‚ation de l'environnement virtuel ./venv/
echo.
if not exist "./venv" mkdir venv

cd venv

:: Download Python
echo.
echo %white%T‚l‚chargement de Python...%green%
echo.
if defined HasCurl (
  curl "%PythonURL%" -o "%cd%\python.zip"
) else (

	powershell Invoke-WebRequest -Uri "%PythonURL%" -OutFile "%cd%\python.zip"  -TimeoutSec 30

)
echo.
echo %white%T‚l‚chargement de Python t‚rmin‚.%green%
echo.

:: Extract Python
echo.
echo %white%Installation de Python...%green%
echo.
if defined HasTar (
  tar -xf "python.zip"
) else (
  powershell Expand-Archive python.zip ./ -Force
)
echo.
echo %white%Installation de Python t‚rmin‚.%green%
echo.

:: Get pip
echo.
echo %white%T‚l‚chargement de Pip...%green%
echo.
if defined HasCurl (
  curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
) else (
  powershell Invoke-WebRequest -Uri "https://bootstrap.pypa.io/get-pip.py" -OutFile "%cd%\get-pip.py"
)
echo.
echo %white%Installation de Pip...%green%
echo.
python.exe get-pip.py --no-warn-script-location
echo.
echo Lib\site-packages>>%PythonPathFile%
echo ..>>%PythonPathFile%

:: For lazy use down below
SET PY="%CD%\python.exe"

:: Delete zip
echo.
echo Removing temporary files
echo.
del python.zip
del get-pip.py

cd ..
echo.
echo %white%Installation de Pip t‚rmin‚.%green%
echo.

:: Install Requirements
echo.
echo %white%Installation des d‚pendances.%green%
echo.
%PY% -m pip --no-cache-dir install -r requirements/requirements.txt --no-color --no-warn-script-location
echo.
echo %white%Installation de d‚pendances t‚rmin‚.%green%
echo.
:: Install Torch
echo.
echo %white%Installation de PyTorch.%green%
echo.
if %usecuda%==1 (
  %PY% -m pip install -r requirements/cuda_requirements.txt --no-color --no-warn-script-location
)
if %usecuda%==2 (
  %PY% -m pip install -r requirements/cpu_requirements.txt --no-color --no-warn-script-location
)
echo.
echo %white%Instalation de Pytorch t‚rmin‚.%green%
echo.
:: Check for and offer to help install Windows Terminal
for %%X in (wt.exe) do (set HasWT=%%~$PATH:X)
if defined HasWT (goto models)
echo.
echo %white%Microsoft Windows Terminal n'a pas ‚t‚ trouv‚.
echo Il est fortement recommand‚ de l'installer.
echo.
:: console bell
echo 
:selectwt
echo.
set /p openwt="Voulez-vous installer Microsoft Windows Terminal maintenant? (o/n) "
echo.
if "%openwt%"=="o (
  if defined HasCurl (
    curl -L "%WindowsTerminalURL%" -o wt.msixbundle
  ) else (
    powershell Invoke-WebRequest -Uri "%WindowsTerminalURL%" -OutFile "%cd%\wt.msixbundle"
  )
  start "" /wait /b wt.msixbundle
  pause
  del wt.msixbundle
  goto selectmodel
)
if "%openwt%"=="n" (goto selectmodel) else (goto selectwt)

:models

:selectmodel
echo.
echo %yellow%
echo 0) Installer la version du modŠle "Light" (486 Mb).
echo 1) Installer la version du modŠle "Large" (3.81 Go) --recommand‚.
echo.
echo.
echo %white%
set /p usemodel="Entrez votre choix: "
echo %green%
echo.

if %usemodel%==0 (goto installmodel)
if %usemodel%==1 (goto installmodel)

:installmodel
if %usemodel%==0 (

	mkdir models\gpt-fr-cased-small
	
	if defined HasCurl (
	
		echo.
		echo %white%T‚l‚chargement de: pytorch_model.bin...%green%
		echo.
		curl -L "https://huggingface.co/asi/gpt-fr-cased-small/resolve/main/pytorch_model.bin" -o models\gpt-fr-cased-small\pytorch_model.bin
		echo %white%T‚l‚chargement de: config.json...%green%
		curl -L "https://huggingface.co/asi/gpt-fr-cased-small/resolve/main/config.json" -o models\gpt-fr-cased-small\config.json
		echo %white%T‚l‚chargement de: merges.txt...%green%
		curl -L "https://huggingface.co/asi/gpt-fr-cased-small/resolve/main/merges.txt" -o models\gpt-fr-cased-small\merges.txt
		echo %white%T‚l‚chargement de special_tokens_map.json...%green%
		curl -L "https://huggingface.co/asi/gpt-fr-cased-small/resolve/main/special_tokens_map.json" -o models\gpt-fr-cased-small\special_tokens_map.json
		echo %white%T‚l‚chargement de: vocab.json...%green%
		curl -L "https://huggingface.co/asi/gpt-fr-cased-small/resolve/main/vocab.json" -o models\gpt-fr-cased-small\vocab.json

	) else (
	
		echo.
		echo %white%T‚l‚chargement de: pytorch_model.bin...%green%
		echo.
		powershell Invoke-WebRequest -Uri "https://huggingface.co/asi/gpt-fr-cased-small/resolve/main/pytorch_model.bin" -OutFile "models\gpt-fr-cased-small\pytorch_model.bin"
		echo %white%T‚l‚chargement de: config.json...%green%
		powershell Invoke-WebRequest -Uri "https://huggingface.co/asi/gpt-fr-cased-small/resolve/main/config.json" -OutFile "models\gpt-fr-cased-small\config.json"
		echo %white%T‚l‚chargement de: merges.txt...%green%
		powershell Invoke-WebRequest -Uri "https://huggingface.co/asi/gpt-fr-cased-small/resolve/main/merges.txt" -OutFile "models\gpt-fr-cased-small\merges.txt"
		echo %white%T‚l‚chargement de special_tokens_map.json...%green%
		powershell Invoke-WebRequest -Uri "https://huggingface.co/asi/gpt-fr-cased-small/resolve/main/special_tokens_map.json" -OutFile "models\gpt-fr-cased-small\special_tokens_map.json"
		echo %white%T‚l‚chargement de: vocab.json...%green%
		powershell Invoke-WebRequest -Uri "https://huggingface.co/asi/gpt-fr-cased-small/resolve/main/vocab.json" -OutFile "models\gpt-fr-cased-small\vocab.json"
	)

	echo.
	echo %white%Installation du modŠle t‚rmin‚.%green%
	echo.
	
	goto end
	
)

if %usemodel%==1 (

	mkdir models\gpt-fr-cased-base

	if defined HasCurl (
	
		echo %white%T‚l‚chargement de: pytorch_model.bin...%green%
		curl -L "https://huggingface.co/asi/gpt-fr-cased-base/resolve/main/pytorch_model.bin" -o models\gpt-fr-cased-base\pytorch_model.bin
		echo %white%T‚l‚chargement de: config.json...%green%
		curl -L "https://huggingface.co/asi/gpt-fr-cased-base/resolve/main/config.json" -o models\gpt-fr-cased-base\config.json
		echo %white%T‚l‚chargement de: merges.txt...%green%
		curl -L "https://huggingface.co/asi/gpt-fr-cased-base/resolve/main/merges.txt" -o models\gpt-fr-cased-base\merges.txt
		echo %white%T‚l‚chargement de special_tokens_map.json...%green%
		curl -L "https://huggingface.co/asi/gpt-fr-cased-base/resolve/main/special_tokens_map.json" -o models\gpt-fr-cased-base\special_tokens_map.json
		echo %white%T‚l‚chargement de: vocab.json...%green%
		curl -L "https://huggingface.co/asi/gpt-fr-cased-base/resolve/main/vocab.json" -o models\gpt-fr-cased-base\vocab.json

	) else (

		echo %white%T‚l‚chargement de: pytorch_model.bin...%green%
		powershell Invoke-WebRequest -Uri "https://huggingface.co/asi/gpt-fr-cased-base/resolve/main/pytorch_model.bin" -OutFile "models\gpt-fr-cased-base\pytorch_model.bin"
		echo %white%T‚l‚chargement de: config.json...%green%
		powershell Invoke-WebRequest -Uri "https://huggingface.co/asi/gpt-fr-cased-base/resolve/main/config.json" -OutFile "models\gpt-fr-cased-base\config.json"
		echo %white%T‚l‚chargement de: merges.txt...%green%
		powershell Invoke-WebRequest -Uri "https://huggingface.co/asi/gpt-fr-cased-base/resolve/main/merges.txt" -OutFile "models\gpt-fr-cased-base\merges.txt"
		echo %white%T‚l‚chargement de special_tokens_map.json...%green%
		powershell Invoke-WebRequest -Uri "https://huggingface.co/asi/gpt-fr-cased-base/resolve/main/special_tokens_map.json" -OutFile "models\gpt-fr-cased-base\special_tokens_map.json"
		echo %white%T‚l‚chargement de: vocab.json...%green%
		powershell Invoke-WebRequest -Uri "https://huggingface.co/asi/gpt-fr-cased-base/resolve/main/vocab.json" -OutFile "models\gpt-fr-cased-base\vocab.json"
	)

	echo.
	echo %white%Installation du modŠle t‚rmin‚.%green%
	echo.
	
	goto end
	
)

:end

echo.
echo %yellow%L'installation est t‚rmin‚!
echo Vous pouvez maintenant jouer en cliquant sur AIStoryFR.bat.%green%
echo.
:: console bell
echo 

pause
