@echo off
cd /d "%~dp0"
echo ==========================================
echo   Hoda Seminar Plugin - push to GitHub
echo ==========================================
echo.
echo --- status ---
git status --short
echo.
echo --- add ---
git add -A
echo --- commit ---
git commit -m "v0.2.0 member-assistant and sheet templates"
echo.
echo --- push ---
git push
echo.
echo ==========================================
echo   finished. check the messages above.
echo ==========================================
pause
