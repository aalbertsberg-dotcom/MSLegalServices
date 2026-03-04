@echo off
setlocal

:: ============================================================
::  MS Legal Service - GitHub Push Script
::  Place this file in: C:\Users\aalbe\Documents\Dev\MSLegal
::  Run it ONCE to initialize, then again anytime to push updates
:: ============================================================

:: --- CONFIGURE THESE ---
set REPO_URL=https://github.com/aalbertsberg-dotcom/MSLegalServices.git
set BRANCH=main
set COMMIT_MSG=Update MS Legal site
:: -----------------------

echo.
echo  MS Legal Service -- GitHub Deploy
echo  ==================================
echo.

:: Change to the script's own directory
cd /d "%~dp0"

:: Check if git is installed
where git >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Git is not installed or not in PATH.
    echo         Download it from https://git-scm.com
    pause
    exit /b 1
)

:: Check if this is already a git repo
if not exist ".git" (
    echo [INIT] No git repo found. Initializing...
    git init
    git branch -M %BRANCH%
    echo.
    echo [REMOTE] Adding remote origin...
    git remote add origin %REPO_URL%
) else (
    echo [OK] Git repo already initialized.
    :: Make sure remote is set correctly
    git remote set-url origin %REPO_URL% 2>nul
    if errorlevel 1 (
        git remote add origin %REPO_URL%
    )
)

:: Create a .gitignore if it doesn't exist
if not exist ".gitignore" (
    echo [CREATE] Writing .gitignore...
    (
        echo .DS_Store
        echo Thumbs.db
        echo desktop.ini
        echo *.bak
        echo *.tmp
        echo node_modules/
    ) > .gitignore
)

echo.
echo [STATUS] Current file status:
git status --short
echo.

:: Stage all files
echo [ADD] Staging all files...
git add -A

:: Commit
echo [COMMIT] Committing: "%COMMIT_MSG%"
git commit -m "%COMMIT_MSG%"

if errorlevel 1 (
    echo.
    echo [INFO] Nothing new to commit, or commit failed.
    echo        If this is your first push, make sure you've created
    echo        the repo on GitHub first at https://github.com/new
    pause
    exit /b 0
)

:: Push
echo.
echo [PUSH] Pushing to GitHub...
git push -u origin %BRANCH%

if errorlevel 1 (
    echo.
    echo [ERROR] Push failed. Common causes:
    echo   1. Repo doesn't exist yet -- go create it at https://github.com/new
    echo      Name it: MSLegalServices  (no README, no .gitignore)
    echo   2. Wrong username in REPO_URL at top of this script
    echo   3. Not authenticated -- run: git config --global credential.helper manager
    echo.
) else (
    echo.
    echo [DONE] Successfully pushed to GitHub!
    echo.
    echo  Next step -- enable GitHub Pages:
    echo   1. Go to your repo on GitHub
    echo   2. Settings ^> Pages
    echo   3. Source: Deploy from branch ^> main ^> / (root) ^> Save
    echo   4. Site will be live at:
    echo      https://aalbertsberg-dotcom.github.io/MSLegalServices
    echo.
)

pause
endlocal
