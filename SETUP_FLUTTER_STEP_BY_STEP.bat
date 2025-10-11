@echo off
color 0A
title Flutter 설치 마법사

:menu
cls
echo.
echo ========================================
echo    Flutter 설치 마법사
echo ========================================
echo.
echo 현재 상태: Flutter가 다운로드 폴더에 있습니다
echo 목표: C:\src\flutter로 이동 후 PATH 설정
echo.
echo ========================================
echo 단계별 가이드
echo ========================================
echo.
echo [1] 1단계: 다운로드 폴더 열기
echo [2] 2단계: Flutter 이동 방법 안내
echo [3] 3단계: PATH 환경변수 설정 방법
echo [4] 4단계: 설정 확인
echo [5] 5단계: 프로젝트 빌드
echo.
echo [Q] 종료
echo.
set /p choice="선택하세요 (1-5 또는 Q): "

if /i "%choice%"=="1" goto step1
if /i "%choice%"=="2" goto step2
if /i "%choice%"=="3" goto step3
if /i "%choice%"=="4" goto step4
if /i "%choice%"=="5" goto step5
if /i "%choice%"=="Q" goto end
goto menu

:step1
cls
echo.
echo ========================================
echo 1단계: 다운로드 폴더 열기
echo ========================================
echo.
echo 다운로드 폴더를 열고 있습니다...
echo.
echo 다운로드 폴더에서 "flutter" 폴더를 찾으세요.
echo (flutter_windows_xxx.zip 파일이 아닌 압축 해제된 flutter 폴더)
echo.

explorer "%USERPROFILE%\Downloads"

echo.
echo "flutter" 폴더가 보이나요?
echo.
echo [Y] 네, 보입니다 - 다음 단계로
echo [N] 아니요, 안 보입니다 - 압축 해제 필요
echo.
set /p found="선택하세요 (Y/N): "

if /i "%found%"=="Y" goto step2
if /i "%found%"=="N" goto unzip_guide

goto step1

:unzip_guide
cls
echo.
echo ========================================
echo ZIP 압축 해제 가이드
echo ========================================
echo.
echo Flutter ZIP 파일 압축 해제 방법:
echo.
echo 1. 다운로드 폴더에서 "flutter_windows_xxx.zip" 파일 찾기
echo 2. 파일에 마우스 오른쪽 클릭
echo 3. "압축 풀기" 또는 "Extract All" 선택
echo 4. 압축 풀기 위치: 현재 폴더 (Downloads)
echo 5. "압축 풀기" 버튼 클릭
echo 6. 완료될 때까지 기다리기 (1-2분)
echo.
echo 압축 해제가 완료되면 "flutter" 폴더가 생성됩니다.
echo.
pause
goto step1

:step2
cls
echo.
echo ========================================
echo 2단계: Flutter 이동
echo ========================================
echo.
echo 다운로드 폴더의 flutter를 C:\src로 이동합니다.
echo.
echo 방법 1: 복사-붙여넣기 (권장)
echo ----------------------------------------
echo 1. 다운로드 폴더에서 "flutter" 폴더 클릭
echo 2. Ctrl+C (복사)
echo 3. C:\ 드라이브 열기
echo 4. "src" 폴더 만들기 (없으면)
echo    - C:\ 드라이브에서 마우스 오른쪽 클릭
echo    - 새로 만들기 ^> 폴더
echo    - 이름: src
echo 5. C:\src 폴더 열기
echo 6. Ctrl+V (붙여넣기)
echo 7. 복사 완료 대기 (1-2분)
echo.
echo 결과: C:\src\flutter 폴더가 생성됨
echo.
echo.
echo 방법 2: 잘라내기-붙여넣기
echo ----------------------------------------
echo (위와 동일하지만 2번에서 Ctrl+X 사용)
echo (다운로드 폴더에서 flutter가 사라짐)
echo.
echo.

echo C:\src 폴더를 열겠습니까?
set /p open_src="C:\src 폴더 열기 (Y/N): "

if /i "%open_src%"=="Y" (
    if not exist "C:\src" mkdir "C:\src"
    explorer "C:\src"
)

echo.
echo.
echo Flutter 이동을 완료하셨나요?
echo.
set /p moved="Flutter를 C:\src\flutter로 이동 완료 (Y/N): "

if /i "%moved%"=="Y" goto verify_move
echo.
echo 이동을 완료한 후 다시 시도하세요.
pause
goto step2

:verify_move
if exist "C:\src\flutter\bin\flutter.bat" (
    echo.
    echo [확인] C:\src\flutter\bin\flutter.bat 파일이 존재합니다!
    echo [성공] Flutter 이동 완료!
    echo.
    pause
    goto step3
) else (
    echo.
    echo [오류] C:\src\flutter\bin\flutter.bat 파일을 찾을 수 없습니다.
    echo.
    echo 다시 확인하세요:
    echo - flutter 폴더 전체를 복사했나요?
    echo - C:\src\flutter 경로가 맞나요?
    echo.
    pause
    goto step2
)

:step3
cls
echo.
echo ========================================
echo 3단계: PATH 환경변수 설정
echo ========================================
echo.
echo Flutter를 시스템 어디서든 사용하려면 PATH에 추가해야 합니다.
echo.
echo 추가할 경로: C:\src\flutter\bin
echo.
echo.
echo 설정 방법 (이미지 가이드 포함):
echo ----------------------------------------
echo.
echo 1. 시작 메뉴 클릭
echo 2. "환경 변수" 입력하여 검색
echo 3. "시스템 환경 변수 편집" 클릭
echo    (또는 "환경 변수 편집" 클릭)
echo.
echo 4. "환경 변수" 버튼 클릭
echo.
echo 5. 시스템 변수 섹션에서 "Path" 찾기
echo    (위쪽 "사용자 변수" 말고 아래쪽 "시스템 변수")
echo.
echo 6. "Path" 선택 후 "편집" 버튼 클릭
echo.
echo 7. "새로 만들기" 버튼 클릭
echo.
echo 8. 다음 경로 입력:
echo    C:\src\flutter\bin
echo.
echo 9. "확인" 버튼 클릭 (3번)
echo    - Path 편집 창에서 "확인"
echo    - 환경 변수 창에서 "확인"
echo    - 시스템 속성 창에서 "확인"
echo.
echo 10. 완료!
echo.
echo.

echo 환경 변수 설정 창을 열겠습니까?
set /p open_env="환경 변수 설정 열기 (Y/N): "

if /i "%open_env%"=="Y" (
    echo.
    echo 시스템 속성 창을 여는 중...
    SystemPropertiesAdvanced.exe
    echo.
    echo 창이 열리면 "환경 변수" 버튼을 클릭하세요.
    echo.
)

echo.
echo.
echo ========================================
echo 중요!
echo ========================================
echo PATH 설정 후 반드시:
echo 1. 현재 Command Prompt 종료
echo 2. 새 Command Prompt 열기
echo 3. flutter --version 실행하여 확인
echo.
echo 새 창을 열지 않으면 PATH가 적용되지 않습니다!
echo ========================================
echo.
echo.
echo PATH 설정을 완료하셨나요?
set /p path_done="PATH 설정 완료 (Y/N): "

if /i "%path_done%"=="Y" goto step4
echo.
echo PATH 설정을 완료한 후 다시 시도하세요.
pause
goto step3

:step4
cls
echo.
echo ========================================
echo 4단계: 설정 확인
echo ========================================
echo.
echo Flutter가 제대로 설정되었는지 확인합니다.
echo.

echo [1] Flutter 실행 파일 확인...
if exist "C:\src\flutter\bin\flutter.bat" (
    echo [OK] C:\src\flutter\bin\flutter.bat 존재
) else (
    echo [오류] C:\src\flutter\bin\flutter.bat 없음
    echo Flutter를 다시 이동해주세요.
    pause
    goto step2
)

echo.
echo [2] Flutter 버전 확인...
echo 새 Command Prompt를 열어서 다음 명령어를 실행하세요:
echo.
echo    flutter --version
echo.
echo Flutter 버전이 출력되나요?
echo.
set /p version_ok="Flutter 버전이 정상 출력됨 (Y/N): "

if /i "%version_ok%"=="N" (
    echo.
    echo [!] PATH가 아직 적용되지 않았을 수 있습니다.
    echo.
    echo 해결 방법:
    echo 1. 현재 Command Prompt 완전 종료
    echo 2. 새 Command Prompt 열기
    echo 3. flutter --version 다시 실행
    echo.
    echo 여전히 안 되면:
    echo - PC 재부팅
    echo - PATH 설정 다시 확인
    echo.
    pause
    goto step3
)

echo.
echo [3] Flutter Doctor 실행...
echo.
echo 새 Command Prompt에서 다음 명령어를 실행하세요:
echo.
echo    flutter doctor
echo.
echo Visual Studio가 설치되어 있나요?
set /p vs_installed="Visual Studio 2022 설치됨 (Y/N): "

if /i "%vs_installed%"=="N" goto install_vs

echo.
echo [성공] Flutter 설정 완료!
echo.
pause
goto step5

:install_vs
cls
echo.
echo ========================================
echo Visual Studio 2022 설치 필요
echo ========================================
echo.
echo Windows 앱 빌드를 위해 Visual Studio가 필요합니다.
echo.
echo 다운로드: https://visualstudio.microsoft.com/downloads/
echo.
echo 설치 중 선택사항:
echo - "C++를 사용한 데스크톱 개발" 워크로드 선택 (필수)
echo.
echo Visual Studio 설치는 30-60분 소요됩니다.
echo.
echo.
set /p install_now="Visual Studio 다운로드 페이지 열기 (Y/N): "

if /i "%install_now%"=="Y" (
    start https://visualstudio.microsoft.com/downloads/
)

echo.
echo Visual Studio 설치 후 이 스크립트를 다시 실행하세요.
echo.
pause
goto end

:step5
cls
echo.
echo ========================================
echo 5단계: 프로젝트 빌드
echo ========================================
echo.
echo 이제 Flutter 프로젝트를 빌드할 준비가 되었습니다!
echo.
echo 프로젝트 위치:
echo %~dp0
echo.
echo.
echo 빌드 방법 선택:
echo [1] 자동 빌드 스크립트 실행 (권장)
echo [2] 수동 명령어 안내
echo [Q] 메인 메뉴로
echo.
set /p build_choice="선택하세요 (1/2/Q): "

if /i "%build_choice%"=="1" goto auto_build
if /i "%build_choice%"=="2" goto manual_build
if /i "%build_choice%"=="Q" goto menu
goto step5

:auto_build
cls
echo.
echo ========================================
echo 자동 빌드 시작
echo ========================================
echo.

cd /d "%~dp0"

echo [1/3] Flutter 버전 확인...
flutter --version
if %errorlevel% neq 0 (
    echo.
    echo [오류] Flutter를 찾을 수 없습니다.
    echo PATH 설정을 다시 확인하세요.
    pause
    goto step4
)

echo.
echo [2/3] 의존성 설치 중...
flutter pub get
if %errorlevel% neq 0 (
    echo.
    echo [오류] 의존성 설치 실패
    pause
    goto end
)

echo.
echo [3/3] Windows 릴리스 빌드 시작...
echo (5-10분 소요)
echo.
flutter build windows --release

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo 빌드 성공!
    echo ========================================
    echo.
    echo 실행 파일 위치:
    echo %~dp0build\windows\x64\runner\Release\pol_photo.exe
    echo.
    echo 빌드 폴더를 열겠습니까?
    set /p open_build="빌드 폴더 열기 (Y/N): "
    if /i "!open_build!"=="Y" (
        explorer "%~dp0build\windows\x64\runner\Release"
    )
) else (
    echo.
    echo [오류] 빌드 실패
    echo.
    echo 로그를 확인하고 오류를 해결하세요.
)

echo.
pause
goto menu

:manual_build
cls
echo.
echo ========================================
echo 수동 빌드 명령어
echo ========================================
echo.
echo 새 Command Prompt를 열고 다음 명령어를 순서대로 실행하세요:
echo.
echo 1. 프로젝트 폴더로 이동:
echo    cd /d %~dp0
echo.
echo 2. 의존성 설치:
echo    flutter pub get
echo.
echo 3. 빌드 실행:
echo    flutter build windows --release
echo.
echo 4. 빌드 결과 확인:
echo    빌드 완료 후 다음 위치에 실행 파일이 생성됩니다:
echo    build\windows\x64\runner\Release\pol_photo.exe
echo.
pause
goto menu

:end
cls
echo.
echo ========================================
echo Flutter 설치 마법사를 종료합니다.
echo ========================================
echo.
echo 도움이 필요하면 다음 파일을 참조하세요:
echo - INSTALL_FLUTTER.md
echo - WINDOWS_BUILD_GUIDE.md
echo - QUICK_START.md
echo.
pause
exit
