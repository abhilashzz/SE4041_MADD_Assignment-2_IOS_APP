# StudySpot - Interactive GitHub Push Script
$env:Path = "D:\MinGit\cmd;D:\MinGit\mingw64\bin;" + $env:Path
Set-Location -LiteralPath "D:\SE4041_MADD_Assignment 2_IOS_APP"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  StudySpot - Pushing Commits to GitHub" -ForegroundColor Cyan
Write-Host "  Remote: https://github.com/abhilashzz/SE4041_MADD_Assignment-2_IOS_APP.git" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

Write-Host "`nStep 1: Pushing feature branch 'feature/studyspot-implementation'..." -ForegroundColor Yellow
git push -u origin feature/studyspot-implementation

Write-Host "`nStep 2: Pushing 'main' branch..." -ForegroundColor Yellow
git push -u origin main

Write-Host "`nPush complete! You can close this window." -ForegroundColor Green
Read-Host -Prompt "Press Enter to exit"
