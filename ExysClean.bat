@echo off
setlocal
set "MODO_COMPLETO="

for /f "tokens=2 delims=:" %%a in ('chcp') do set "CP_ORIGINAL=%%a"
set "CP_ORIGINAL=%CP_ORIGINAL: =%"
chcp 65001 >nul
title ExysClean - Otimização de Sistema ☘️

net session >nul 2>&1
if "%errorLevel%"=="0" goto menu
mshta vbscript:msgbox("O ExysClean precisa ser executado como Administrador! Clique com o botao direito e selecione 'Executar como Administrador'.",16,"ExysClean - Falta de permissão.")(window.close) >nul 2>&1 || (
    echo [ERRO] Falta de privilegios!
    echo Clique com o botao direito no script e selecione 'Executar como Administrador'.
    pause
)
exit

:menu
cls
echo ======================================================
echo            ExysClean - By Exityy ☘️
echo ======================================================
echo.
echo [1] ⚡ Limpeza de Sistema   -  (Cache, Update e Temp) 
echo [2] 🛡️ Reparar Windows      -  (WinSxS, DISM e SFC) 
echo [3] 💾 Otimização de Disco  -  (SysMain e CHKDSK) 
echo [4] 🚀 Otimização Avançada  -  (Energia e IA)
echo [5] 🌐 Reparar Rede         -  (Reset TCP/IP e Winsock)
echo [6] ✨ Executar TUDO        -  (Reinicia em 60s)
echo [7] ❌ Sair
echo.
choice /c 1234567 /n /m "Escolha uma opção (1-7): "

if errorlevel 7 goto :eof
if errorlevel 6 goto completo
if errorlevel 5 goto call_rede
if errorlevel 4 goto call_avancada
if errorlevel 3 goto call_disco
if errorlevel 2 goto call_reparar
if errorlevel 1 goto call_limpeza
goto menu

:call_limpeza
call :limpeza_rapida
pause
goto menu

:call_reparar
call :manutencao_profunda
pause
goto menu

:call_disco
call :disco
pause
goto menu

:call_avancada
call :avancada
pause
goto menu

:call_rede
call :rede
pause
goto menu

:limpeza_rapida
echo.
echo 🌐 Limpando cache de DNS...
ipconfig /flushdns >nul 2>&1

echo ♻️ Esvaziando Reciclagem...
rd /s /q "%systemdrive%\$Recycle.bin" >nul 2>&1

echo 🔄 Limpando Cache do Windows Update...
net stop wuauserv /y >nul 2>&1
net stop bits /y >nul 2>&1
net stop dosvc /y >nul 2>&1

if defined WINDIR if exist "%WINDIR%\SoftwareDistribution\Download\" (
    del /s /q /f "%WINDIR%\SoftwareDistribution\Download\*.*" >nul 2>&1
)

net start wuauserv >nul 2>&1
net start bits >nul 2>&1
net start dosvc >nul 2>&1

echo 🗑️ Limpando ficheiros temporários... 
if defined temp if exist "%temp%\" (
    del /q /f /s "%temp%\*.*" >nul 2>&1
    for /d %%x in ("%temp%\*") do @rd /s /q "%%x" >nul 2>&1
)

if defined WINDIR if exist "%WINDIR%\Temp\" (
    del /q /f /s "%WINDIR%\Temp\*.*" >nul 2>&1
    for /d %%x in ("%WINDIR%\Temp\*") do @rd /s /q "%%x" >nul 2>&1
)

echo ✨ Limpeza concluída!
goto :eof

:manutencao_profunda
echo.
echo 🧹 1/3 Limpando atualizações antigas do sistema (WinSxS)...
echo Isto pode libertar gigabytes de espaço. Aguarde!
chcp %CP_ORIGINAL% >nul
dism /online /cleanup-image /startcomponentcleanup

echo 🛠️ 2/3 Restaurando imagem do sistema (DISM)...
echo Isto pode demorar alguns minutos. Não feche a janela!
sc config wuauserv start= demand >nul 2>&1
sc start wuauserv >nul 2>&1
dism /online /cleanup-image /restorehealth

echo 🔍 3/3 Verificando ficheiros de sistema (SFC)...
sfc /scannow
chcp 65001 >nul

echo ✅ Manutenção profunda concluída!
goto :eof

:disco
echo.
echo ⚙️ Otimização de Disco
if "%MODO_COMPLETO%"=="1" (
    echo ⏭️ Modo Completo: SysMain mantido ativado por padrão.
    goto bypass_disco
)

choice /c SN /n /t 10 /d S /m "Usa um SSD como disco principal? (S/N) [Padrão: S em 10s]: "
if errorlevel 2 (
    echo ⚙️ Parando e Desativando SysMain...
    net stop SysMain /y >nul 2>&1
    sc config SysMain start= disabled >nul 2>&1
) else (
    echo ⏭️ SysMain mantido ativado...
)

:bypass_disco
echo 💾 Agendando CHKDSK para o próximo boot...
(echo S& echo Y)| chkdsk %systemdrive% /f

echo ✅ Tentativa de agendamento concluída. Verifique possíveis alertas do disco acima!
goto :eof

:avancada
echo.
echo ⚡ Configurando Plano de Energia...
if "%MODO_COMPLETO%"=="1" (
    echo ⏭️ Modo Completo: Alteração de plano de energia ignorada por segurança.
    goto pular_energia
)

echo ⚠️ AVISO: Caso o seu computador seja um portatil/laptop, o plano de "Desempenho Maximo" 
echo pode reduzir drasticamente a autonomia da bateria e gerar aquecimento.
choice /c SN /n /t 10 /d N /m "Deseja aplicar este plano mesmo assim? (S/N) [Padrão: N em 10s]: "

if not "%errorlevel%"=="1" (
    echo ⏭️ Alteracao de plano de energia ignorada.
    goto pular_energia
)

set "GUID_PLANO="
for /f "tokens=2 delims=:" %%A in ('powercfg -list ^| findstr /i "ximo Ultimate"') do (
    for /f "tokens=1" %%B in ("%%A") do set "GUID_PLANO=%%B"
)
if "%GUID_PLANO%"=="" (
    for /f "tokens=2 delims=:" %%A in ('powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61') do (
        for /f "tokens=1" %%B in ("%%A") do set "GUID_PLANO=%%B"
    )
)

if not "%GUID_PLANO%"=="" (
    powercfg -setactive %GUID_PLANO% >nul 2>&1
    echo ✅ Plano de Energia configurado com sucesso!
) else (
    echo ⚠️ Nao foi possivel configurar o plano de energia.
)

:pular_energia
echo.
echo 🧠 Desativando integracoes de IA (Copilot)...
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d 1 /f >nul 2>&1

echo ✅ Otimizacoes Avancadas concluidas!
goto :eof

:rede
echo.
echo ⚠️ ATENÇÃO: Esta ação vai repor todas as configurações de rede.
echo Pode desconectar VPNs em curso ou apagar configurações de IP estático.
choice /c SN /n /t 10 /d N /m "Deseja continuar? (S/N): [Padrão: N em 10s]: "
if not "%errorlevel%"=="1" (
    echo ❌ Reposição de rede cancelada.
    goto :eof
)

echo 🌐 A repor configurações de Rede e TCP/IP...
ipconfig /release >nul 2>&1
netsh winsock reset >nul 2>&1
netsh int ip reset >nul 2>&1
echo ✅ Rede reposta! (Necessário reiniciar o computador para ter efeito)
goto :eof

:completo
set "MODO_COMPLETO=1"
cls
echo ⚠️ Iniciando manutenção completa...
call :limpeza_rapida
call :manutencao_profunda
call :disco
call :avancada
echo.
echo 💤 Manutenção finalizada. O sistema REINICIARÁ em 60 segundos.
echo ❌ Pressione [C] para CANCELAR o reinício.
shutdown /r /f /t 60

choice /c CX /n /t 59 /d X /m ">"
if "%errorlevel%"=="2" (
    exit
)
if "%errorlevel%"=="1" (
    goto cancel_reboot
)

shutdown /a >nul 2>&1
exit

:cancel_reboot
shutdown /a >nul 2>&1
echo ✅ Reinício cancelado pelo utilizador! A voltar ao menu...
timeout /t 3 >nul
set "MODO_COMPLETO="
goto menu