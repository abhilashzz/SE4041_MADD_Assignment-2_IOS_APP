@echo off
REM ==============================================================================
REM StudySpot - One-Click GitHub Push
REM Student: Abhilash K A T W - IT22081698
REM ==============================================================================
echo ==========================================================
echo   StudySpot - Pushing Commits to GitHub
echo ==========================================================
set "PATH=D:\MinGit\cmd;D:\MinGit\mingw64\bin;%PATH%"

echo 1. Pushing feature branch 'feature/studyspot-implementation'...
git push -u origin feature/studyspot-implementation

echo.
echo 2. Pushing main branch...
git push -u origin main

echo.
echo ==========================================================
echo   Push Complete!
echo ==========================================================
pause
