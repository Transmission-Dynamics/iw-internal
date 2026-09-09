@echo off
REM ---------------------------------------------------------------------
REM  internal.jrdltd.co.uk - server self-update
REM
REM  Pulls the "live" branch from GitHub. Apache serves public\ straight
REM  off the disk, so there is no service to restart: the next person to
REM  load the page gets the new one.
REM
REM  Safe to run every minute from Task Scheduler. A run that finds
REM  nothing does nothing and logs nothing.
REM
REM  NOTE: this makes the server an exact mirror of origin/live. Anything
REM  edited directly on the server is DISCARDED on the next run. That is
REM  deliberate - the repository is the only source of truth.
REM ---------------------------------------------------------------------
setlocal
cd /d "%~dp0"

set BRANCH=live
set LOG=logs\update.log

if not exist logs mkdir logs

REM --- keep the log from growing forever (it is polled every minute) ---
for %%A in ("%LOG%") do if %%~zA GTR 1048576 (
  move /y "%LOG%" "%LOG%.old" >nul 2>&1
)

for /f %%i in ('git rev-parse HEAD 2^>nul') do set BEFORE=%%i
if not defined BEFORE (
  echo %date% %time%  not a git checkout - stopping >>"%LOG%"
  exit /b 1
)

git fetch origin %BRANCH% >>"%LOG%" 2>&1
if errorlevel 1 (
  echo %date% %time%  fetch failed ^(network? credentials?^) - left as it was >>"%LOG%"
  exit /b 1
)

for /f %%i in ('git rev-parse origin/%BRANCH% 2^>nul') do set AFTER=%%i
if "%BEFORE%"=="%AFTER%" exit /b 0

git reset --hard origin/%BRANCH% >>"%LOG%" 2>&1
if errorlevel 1 (
  echo %date% %time%  reset failed - left as it was >>"%LOG%"
  exit /b 1
)

echo %date% %time%  updated %BEFORE:~0,7% -^> %AFTER:~0,7% >>"%LOG%"
exit /b 0
