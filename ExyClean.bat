@echo off
chcp 65001 >nul
title ExyClean - Otimização de Sistema

:: Verifica Admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ❌ [ERRO] Execute como Administrador!
    pause
    exit
)

:menu
cls
echo ======================================================
echo           ☘️ ExyClean - By Exityy
echo ======================================================
echo.
echo [1] ⚡ Limpeza Rápida (DNS + Temporários) - INSTANTÂNEO
echo [2] 🛡️ Manutenção Profunda (DISM + SFC) - DEMORADO
echo [3] 💾 Agendar Verificação de Disco (CHKDSK)
echo [4] ✨ Executar TUDO e Desligar em 60s
echo [5] ❌ Sair
echo.
set /p opcao="Escolha uma opção (1-5): "

if "%opcao%"=="1" goto call_limpeza
if "%opcao%"=="2" goto call_profunda
if "%opcao%"=="3" goto call_disco
if "%opcao%"=="4" goto completo
if "%opcao%"=="5" exit
goto menu

:call_limpeza
call :limpeza_rapida
pause
goto menu

:call_profunda
call :manutencao_profunda
pause
goto menu

:call_disco
call :disco
pause
goto menu

:limpeza_rapida
echo.
echo 🌐 Limpando cache de rede...
ipconfig /flushdns >nul
echo 🗑️ Limpando arquivos temporários (Método Rápido)...
rmdir /s /q %temp% >nul 2>&1
mkdir %temp% >nul 2>&1
echo ✨ Limpeza concluída!
goto :eof

:manutencao_profunda
echo.
echo 🛠️ 1/2 Restaurando imagem do sistema (DISM)...
dism /online /cleanup-image /restorehealth
echo 🔍 2/2 Verificando arquivos de sistema (SFC)...
sfc /scannow
echo ✅ Manutenção concluída!
goto :eof

:disco
echo.
echo 💾 Agendando CHKDSK para o próximo boot...
echo s > %temp%\resp.txt
chkdsk /f < %temp%\resp.txt >nul 2>&1
del %temp%\resp.txt
echo ✅ Agendado! O Windows verificará o disco na próxima vez que ligar.
goto :eof

:completo
cls
echo ⚠️ Iniciando manutenção completa...
call :limpeza_rapida
call :manutencao_profunda
call :disco
echo.
echo 💤 Manutenção finalizada. O sistema desligará em 60s.
shutdown /s /f /t 60
pause
exit