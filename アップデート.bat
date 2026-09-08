@echo off
chcp 65001 > nul
cd /d "%~dp0"

echo ============================================
echo   Hoda Seminar Plugin - Update to GitHub
echo ============================================
echo.

git rev-parse --is-inside-work-tree > nul 2>&1
if errorlevel 1 (
  echo [ERROR] This folder is not a git repository.
  echo         Run the setup steps in PUSH tejun.txt first.
  echo.
  pause
  exit /b 1
)

echo --- Changed files ---
git status --short
echo.

set "MSG="
set /p MSG=Commit message (press Enter for default): 
if "%MSG%"=="" set "MSG=update"

echo.
echo --- Staging ---
git add -A

echo --- Committing ---
git commit -m "%MSG%"

echo.
echo --- Pushing ---
git push

echo.
if errorlevel 1 (
  echo [FAILED] Push did not complete. See the message above.
) else (
  echo [DONE] Pushed to GitHub.
  echo        https://github.com/81gemini-gif/hoda-seminar-plugin
)
echo.
pause
