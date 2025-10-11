@echo off
echo ========================================
echo Flutter 설치 위치 찾기
echo ========================================
echo.

echo [1] PATH 환경변수 확인 중...
echo %PATH% | findstr /I "flutter"
if %errorlevel% equ 0 (
    echo [OK] PATH에 Flutter가 포함되어 있습니다.
) else (
    echo [!] PATH에 Flutter가 없습니다.
)
echo.

echo [2] 일반적인 설치 경로 확인 중...
echo.

if exist "C:\flutter\bin\flutter.bat" (
    echo [찾음] C:\flutter\bin\flutter.bat
    set FLUTTER_PATH=C:\flutter\bin
    goto :found
)

if exist "C:\src\flutter\bin\flutter.bat" (
    echo [찾음] C:\src\flutter\bin\flutter.bat
    set FLUTTER_PATH=C:\src\flutter\bin
    goto :found
)

if exist "%USERPROFILE%\flutter\bin\flutter.bat" (
    echo [찾음] %USERPROFILE%\flutter\bin\flutter.bat
    set FLUTTER_PATH=%USERPROFILE%\flutter\bin
    goto :found
)

if exist "%LOCALAPPDATA%\flutter\bin\flutter.bat" (
    echo [찾음] %LOCALAPPDATA%\flutter\bin\flutter.bat
    set FLUTTER_PATH=%LOCALAPPDATA%\flutter\bin
    goto :found
)

if exist "D:\flutter\bin\flutter.bat" (
    echo [찾음] D:\flutter\bin\flutter.bat
    set FLUTTER_PATH=D:\flutter\bin
    goto :found
)

echo [!] 일반적인 경로에서 Flutter를 찾을 수 없습니다.
echo.
echo [3] 전체 디스크 검색 중... (시간이 걸릴 수 있습니다)
for %%D in (C D E F) do (
    if exist %%D:\ (
        echo %%D 드라이브 검색 중...
        dir /s /b "%%D:\flutter.bat" 2>nul | findstr /I "bin\\flutter.bat"
    )
)
echo.
echo ========================================
echo Flutter를 찾을 수 없습니다!
echo.
echo Flutter를 설치하셨나요?
echo 설치 위치를 기억하시나요?
echo.
echo 다시 확인해주세요:
echo 1. Flutter 다운로드: https://flutter.dev/docs/get-started/install/windows
echo 2. ZIP 파일을 압축 해제한 위치 확인
echo 3. 해당 경로의 bin 폴더를 PATH에 추가
echo.
pause
goto :end

:found
echo.
echo ========================================
echo Flutter 발견!
echo 위치: %FLUTTER_PATH%
echo ========================================
echo.

echo [4] Flutter 버전 확인 중...
"%FLUTTER_PATH%\flutter.bat" --version
echo.

echo [5] Flutter Doctor 실행 중...
"%FLUTTER_PATH%\flutter.bat" doctor
echo.

echo ========================================
echo 해결 방법
echo ========================================
echo.
echo Flutter가 발견되었지만 PATH에 추가되지 않았습니다.
echo.
echo 옵션 1: 시스템 환경변수에 추가 (권장)
echo   1. 시작 메뉴에서 "환경 변수" 검색
echo   2. "시스템 환경 변수 편집" 클릭
echo   3. "환경 변수" 버튼 클릭
echo   4. "시스템 변수"에서 "Path" 선택
echo   5. "편집" 클릭
echo   6. "새로 만들기" 클릭
echo   7. 다음 경로 입력: %FLUTTER_PATH%
echo   8. "확인" 3번 클릭
echo   9. 새 Command Prompt 열기
echo.
echo 옵션 2: 임시로 이 세션에서만 사용
echo   다음 명령어 실행:
echo   set PATH=%FLUTTER_PATH%;%%PATH%%
echo.
echo 옵션 3: 이 터미널에서 바로 빌드
echo   cd /d "%~dp0"
echo   "%FLUTTER_PATH%\flutter.bat" pub get
echo   "%FLUTTER_PATH%\flutter.bat" build windows --release
echo.
pause

:end
