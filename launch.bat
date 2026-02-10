@echo off
title Lumina Orchestrator Launcher

echo [Launcher] A iniciar o ecossistema Lumina...

:: 1. Iniciar o Lemonade Server (LLM Provider)
echo [1/3] A iniciar Lemonade Server...
start "Lemonade AI Server" cmd /k "lemonade-server serve"

:: 2. Iniciar o Lumina Engine (Python)
echo [2/3] A iniciar Lumina Engine (Python)...
cd src\Lumina.Engine

if exist venv\Scripts\activate.bat (
    call venv\Scripts\activate.bat
) else (
    echo [AVISO] Ambiente virtual nao encontrado. Execute setup_python.bat primeiro.
)

:: Inicia o servidor na porta 5001
start "Lumina Engine Python" cmd /k "uvicorn main:app --port 5001"

:: Retorna a raiz
cd ..\..

:: 3. Iniciar a Lumina API (.NET)
echo [3/3] A iniciar Lumina API (.NET)...
cd src\Lumina.Server\Lumina.Api
:: Inicia o servidor (porta 5006 definida em launchSettings.json)
start "Lumina API .NET" cmd /k "dotnet run"

:: Retorna a raiz
cd ..\..\..

echo.
echo [A aguardar] A esperar que os servicos fiquem online...
timeout /t 7 /nobreak >nul

echo [Browser] A abrir documentacao...
:: Abre o Swagger do Engine (Python)
start http://localhost:5001/docs

:: Abre o Swagger da API (.NET)
start http://localhost:5006/swagger

echo.
echo [Sucesso] Todos os servicos iniciados e documentacao aberta.
pause