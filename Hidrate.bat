@echo off
setlocal enabledelayedexpansion
title Tracker de Hidratacao - C:\Historico_Agua
mode con: cols=60 lines=30
color 0B

:: --- CONFIGURACOES ---
set "META_CANECAS=11"
set "ML_CANECA=350"
set "PASTA_LOGS=C:\Historico_Agua"

:: Cria a pasta de logs no C: se nao existir
if not exist "%PASTA_LOGS%" mkdir "%PASTA_LOGS%"

:: Pega a data atual
set "DIA=%date:~0,2%"
set "MES=%date:~3,2%"
set "ANO=%date:~6,4%"
set "ARQUIVO_HOJE=%PASTA_LOGS%\%DIA%-%MES%-%ANO%.txt"

:: --- CARREGAMENTO ---
if exist "%ARQUIVO_HOJE%" (
    set /p CONTADOR=<"%ARQUIVO_HOJE%"
) else (
    set "CONTADOR=0"
    echo 0 > "%ARQUIVO_HOJE%"
)

:: Garante que o contador seja tratado como numero
set /a CONTADOR=%CONTADOR%

:MENU
cls
echo ==========================================================
echo               HIDRATACAO - %DIA%/%MES%/%ANO%
echo        Local: %ARQUIVO_HOJE%
echo        Meta: %META_CANECAS% canecas (aprox 3.8L)
echo ==========================================================
echo.
echo      [1] Caneca Concluida (+1)
echo      [2] Quantas ja foram?
echo      [3] Quantas faltam?
echo      [4] Quantos MLs ja foram?
echo      [5] Ver horarios de hoje
echo      [6] Sair
echo.
echo ==========================================================
set /p OPCAO=">> Escolha uma opcao: "

if "%OPCAO%"=="1" goto ADICIONAR
if "%OPCAO%"=="2" goto RELATORIO_QTD
if "%OPCAO%"=="3" goto RELATORIO_FALTA
if "%OPCAO%"=="4" goto RELATORIO_ML
if "%OPCAO%"=="5" goto RELATORIO_HORARIOS
if "%OPCAO%"=="6" exit

goto MENU

:ADICIONAR
set /a CONTADOR+=1
call :SALVAR_REGISTRO
cls
echo.
echo    __
echo   /  \
echo   ^|  ^|  BOA^! REGISTRADO AS %time:~0,5%
echo   \__/
echo.
echo   Total hoje: %CONTADOR%
echo.
pause
goto MENU

:RELATORIO_QTD
cls
echo.
echo ==========================================================
echo    VOCE JA BEBEU: %CONTADOR% CANECA(S) HOJE.
echo ==========================================================
echo.
pause
goto MENU

:RELATORIO_FALTA
cls
set /a FALTA=%META_CANECAS%-%CONTADOR%
if %FALTA% GTR 0 goto AINDA_FALTA
goto META_BATIDA

:AINDA_FALTA
echo.
echo ==========================================================
echo    FORCA^! AINDA FALTAM: %FALTA% CANECA(S).
echo ==========================================================
echo.
pause
goto MENU

:META_BATIDA
set /a EXTRA=%CONTADOR%-%META_CANECAS%
echo.
echo ==========================================================
echo    PARABENS^! META DO DIA ATINGIDA^!
if %EXTRA% GTR 0 echo    Voce ja bebeu %EXTRA% alem da meta.
echo ==========================================================
echo.
pause
goto MENU

:RELATORIO_ML
cls
set /a TOTAL_ML=%CONTADOR%*%ML_CANECA%
echo.
echo ==========================================================
echo    VOLUME TOTAL INGERIDO: %TOTAL_ML% ml
echo ==========================================================
echo.
pause
goto MENU

:RELATORIO_HORARIOS
cls
echo.
echo ==========================================================
echo              REGISTRO DE HOJE (%DIA%/%MES%)
echo ==========================================================
echo.
if %CONTADOR%==0 (
    echo    Nenhum registro ainda.
) else (
    more +1 "%ARQUIVO_HOJE%"
)
echo.
echo ==========================================================
pause
goto MENU

:SALVAR_REGISTRO
(
  echo %CONTADOR%
  if exist "%ARQUIVO_HOJE%" more +1 "%ARQUIVO_HOJE%"
  echo Caneca %CONTADOR% - %time:~0,5%
) > "%ARQUIVO_HOJE%.tmp"
move /y "%ARQUIVO_HOJE%.tmp" "%ARQUIVO_HOJE%" >nul
goto :eof