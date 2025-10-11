@echo off
echo ========================================
echo REphoto Windows Build Script
echo ========================================
echo.

REM Check if Flutter is installed
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Flutter is not installed or not in PATH
    echo Please install Flutter from: https://flutter.dev/docs/get-started/install/windows
    pause
    exit /b 1
)

echo [1/5] Checking Flutter environment...
flutter doctor -v

echo.
echo [2/5] Getting dependencies...
flutter pub get

if %errorlevel% neq 0 (
    echo [ERROR] Failed to get dependencies
    pause
    exit /b 1
)

echo.
echo [3/5] Cleaning previous builds...
flutter clean

echo.
echo [4/5] Building Windows release...
echo This may take 5-10 minutes for the first build...
flutter build windows --release

if %errorlevel% neq 0 (
    echo [ERROR] Build failed
    pause
    exit /b 1
)

echo.
echo [5/5] Build completed successfully!
echo.
echo ========================================
echo Build Output Location:
echo build\windows\x64\runner\Release\
echo.
echo Executable: pol_photo.exe
echo ========================================
echo.
echo Opening build folder...
start build\windows\x64\runner\Release\

pause
