@echo off
echo ========================================
echo 다운로드 폴더에서 Flutter 설정
echo ========================================
echo.

set DOWNLOADS=%USERPROFILE%\Downloads

echo [1] 다운로드 폴더 확인 중: %DOWNLOADS%
echo.

REM Check for flutter folder
if exist "%DOWNLOADS%\flutter\bin\flutter.bat" (
    echo [찾음] Flutter가 다운로드 폴더에 있습니다!
    set FLUTTER_PATH=%DOWNLOADS%\flutter
    goto :setup
)

REM Check for flutter zip
if exist "%DOWNLOADS%\flutter_windows_*.zip" (
    echo [!] Flutter ZIP 파일을 찾았습니다!
    echo [!] 먼저 압축을 해제해야 합니다.
    echo.
    echo 압축 해제 방법:
    echo 1. %DOWNLOADS% 폴더 열기
    echo 2. flutter_windows_*.zip 파일 찾기
    echo 3. 마우스 오른쪽 클릭 ^> "압축 풀기"
    echo 4. 압축 풀기 위치: C:\src\flutter (권장)
    echo.
    pause
    exit /b 1
)

echo [!] 다운로드 폴더에서 Flutter를 찾을 수 없습니다.
echo.
echo 다운로드 폴더 내용:
dir "%DOWNLOADS%\flutter*" 2>nul
echo.
echo Flutter 위치를 확인해주세요.
echo.
pause
exit /b 1

:setup
echo.
echo ========================================
echo Flutter 경로: %FLUTTER_PATH%
echo ========================================
echo.

echo [2] Flutter 버전 확인 중...
"%FLUTTER_PATH%\bin\flutter.bat" --version
if %errorlevel% neq 0 (
    echo [오류] Flutter 실행에 실패했습니다.
    pause
    exit /b 1
)
echo.

echo [3] 다운로드 폴더는 임시 위치입니다!
echo.
echo 권장사항: Flutter를 C:\src\flutter로 이동
echo.
echo 옵션 1: 수동으로 이동 (권장)
echo   1. %FLUTTER_PATH% 폴더를 복사
echo   2. C:\src 폴더에 붙여넣기 (없으면 만들기)
echo   3. 결과: C:\src\flutter
echo   4. PATH에 C:\src\flutter\bin 추가
echo.
echo 옵션 2: 현재 위치에서 사용
echo   PATH에 %FLUTTER_PATH%\bin 추가
echo.
choice /C 12 /M "어떻게 하시겠습니까? 1=이동 안내, 2=현재 위치 사용"

if errorlevel 2 goto :use_current
if errorlevel 1 goto :move_guide

:move_guide
echo.
echo ========================================
echo Flutter 이동 가이드
echo ========================================
echo.
echo 1. Windows 탐색기 열기
echo 2. %FLUTTER_PATH% 폴더 찾기
echo 3. flutter 폴더를 복사 (Ctrl+C)
echo 4. C:\ 드라이브 열기
echo 5. "src" 폴더 만들기 (없으면)
echo 6. C:\src 안에 붙여넣기 (Ctrl+V)
echo 7. 완료 후 이 스크립트를 다시 실행하세요
echo.
echo 탐색기 열기 중...
explorer "%DOWNLOADS%"
pause
exit /b 0

:use_current
echo.
echo [4] PATH 환경변수 설정 중...
echo.
echo 현재 위치에서 사용하려면 PATH에 추가해야 합니다:
echo %FLUTTER_PATH%\bin
echo.
echo 자동으로 PATH에 추가하시겠습니까?
echo (관리자 권한이 필요할 수 있습니다)
echo.
choice /C YN /M "PATH에 자동 추가하시겠습니까?"

if errorlevel 2 goto :manual_path
if errorlevel 1 goto :auto_path

:auto_path
echo.
echo PATH 추가 시도 중...
setx PATH "%FLUTTER_PATH%\bin;%PATH%" /M 2>nul
if %errorlevel% equ 0 (
    echo [성공] PATH에 추가되었습니다!
    echo.
    echo *** 중요 ***
    echo 새 Command Prompt를 열어야 적용됩니다!
) else (
    echo [실패] 관리자 권한이 필요합니다.
    echo.
    goto :manual_path
)
echo.
pause
exit /b 0

:manual_path
echo.
echo ========================================
echo 수동 PATH 추가 방법
echo ========================================
echo.
echo 1. 시작 메뉴 ^> "환경 변수" 검색
echo 2. "시스템 환경 변수 편집" 클릭
echo 3. "환경 변수" 버튼 클릭
echo 4. "시스템 변수"에서 "Path" 선택
echo 5. "편집" 클릭
echo 6. "새로 만들기" 클릭
echo 7. 다음 경로 복사하여 붙여넣기:
echo.
echo    %FLUTTER_PATH%\bin
echo.
echo 8. "확인" 3번 클릭
echo 9. 새 Command Prompt 열기
echo.
pause
exit /b 0
