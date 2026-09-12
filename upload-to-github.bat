@echo off
setlocal enabledelayedexpansion

set "REPO_URL=https://github.com/mike000123/World_Macro_Dashboard.git"
set "BRANCH=main"
set "REPO_DIR=%~dp0"

cd /d "%REPO_DIR%"
echo ================================================
echo   Uploading dashboard to GitHub
echo   Folder: %REPO_DIR%
echo ================================================
echo.

where git >nul 2>nul
if errorlevel 1 (
    echo [ERROR] Git was not found on this computer.
    echo Download it from git-scm.com/download/win
    pause
    exit /b 1
)

if not exist ".git" (
    echo No git repository here yet - initializing...
    git init
    git branch -M %BRANCH%
    git remote add origin "%REPO_URL%"
) else (
    git remote get-url origin >nul 2>nul
    if errorlevel 1 (
        echo Adding remote origin...
        git remote add origin "%REPO_URL%"
    )
)
echo.

echo Staging files...
git add -A

git diff --cached --quiet
if errorlevel 1 (
    set "COMMIT_MSG=Update dashboard - %date% %time%"
    echo Creating commit: !COMMIT_MSG!
    git commit -m "!COMMIT_MSG!"
    echo.
) else (
    echo No new changes to commit - will still try to push any
    echo existing local commits that have not reached GitHub yet.
    echo.
)

echo Pushing to GitHub...
echo %REPO_URL%
git push -u origin %BRANCH%

if errorlevel 1 (
    echo.
    echo Direct push failed. The remote repository probably already has
    echo some content, such as a README created on GitHub. Trying to sync...
    git pull origin %BRANCH% --allow-unrelated-histories --no-edit
    if errorlevel 1 (
        echo.
        echo [ERROR] Sync failed. Check the messages above, fix any
        echo conflicts manually, then run this script again.
        pause
        exit /b 1
    )
    echo Pushing again...
    git push -u origin %BRANCH%
    if errorlevel 1 (
        echo.
        echo [ERROR] Push failed again. Scroll up in this window and read
        echo the exact error text from git above this message. That line
        echo tells us what is wrong - a login problem, wrong repo name,
        echo or a network issue.
        pause
        exit /b 1
    )
)

echo.
echo ================================================
echo   Done! Check your changes at:
echo   github.com/mike000123/World_Macro_Dashboard
echo ================================================
pause
