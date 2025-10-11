# 🪟 Windows 실행 파일 빌드 가이드

## 📋 목차
1. [사전 요구사항](#사전-요구사항)
2. [Flutter 설치](#flutter-설치)
3. [프로젝트 빌드](#프로젝트-빌드)
4. [배포 파일 준비](#배포-파일-준비)
5. [문제 해결](#문제-해결)

---

## 🎯 사전 요구사항

### 필수 소프트웨어

1. **Visual Studio 2022** (Community 에디션 무료)
   - C++ 데스크톱 개발 워크로드 필요
   - 다운로드: https://visualstudio.microsoft.com/downloads/

2. **Flutter SDK**
   - 다운로드: https://flutter.dev/docs/get-started/install/windows

3. **Git for Windows** (선택사항)
   - 다운로드: https://git-scm.com/download/win

---

## 🚀 Flutter 설치

### 1단계: Flutter SDK 다운로드

```powershell
# PowerShell에서 실행
# 1. Flutter 저장할 폴더 생성 (예: C:\src)
mkdir C:\src
cd C:\src

# 2. Flutter 다운로드 (수동 다운로드도 가능)
# https://docs.flutter.dev/get-started/install/windows
```

**또는 직접 다운로드**:
1. https://docs.flutter.dev/get-started/install/windows 방문
2. "flutter_windows_x.x.x-stable.zip" 다운로드
3. `C:\src\flutter`에 압축 해제

### 2단계: PATH 환경변수 설정

1. **시스템 환경 변수** 열기
   - Windows 검색 → "환경 변수" 입력
   - "시스템 환경 변수 편집" 클릭

2. **Path 변수 편집**
   - "환경 변수" 버튼 클릭
   - "시스템 변수" 섹션에서 "Path" 선택
   - "편집" 클릭
   - "새로 만들기" 클릭
   - `C:\src\flutter\bin` 입력 (Flutter 설치 경로에 맞게 수정)
   - "확인" 클릭

3. **새 터미널 열기** (중요!)

### 3단계: Flutter 설치 확인

```bash
# 새 Command Prompt 또는 PowerShell 열기
flutter --version

# Flutter Doctor 실행
flutter doctor -v
```

**예상 출력**:
```
Flutter 3.29.2 • channel stable
Tools • Dart 3.7.2 • DevTools 2.xx.x

[✓] Flutter (Channel stable, 3.29.2, on Windows 11)
[✓] Windows Version (Installed version of Windows is version 10 or higher)
[✓] Visual Studio - develop Windows apps (Visual Studio Community 2022)
[✓] VS Code (version 1.xx)
[✓] Connected device (1 available)
[✓] Network resources
```

### 4단계: Visual Studio 확인

Flutter doctor가 Visual Studio 관련 오류를 표시하면:

```bash
# Visual Studio 2022 설치 확인
flutter doctor

# C++ 워크로드 설치 필요 시:
# Visual Studio Installer 실행 → "데스크톱 개발(C++)" 체크 → 설치
```

---

## 🔨 프로젝트 빌드

### 방법 1: 자동 빌드 스크립트 사용 (권장 ⭐)

1. 프로젝트 폴더로 이동
2. `build_windows.bat` 더블클릭
3. 빌드 완료 대기 (첫 빌드는 5-10분 소요)

### 방법 2: 수동 빌드

```bash
# 1. 프로젝트 폴더로 이동
cd C:\Users\USER\Desktop\code\EZPHOTO-1.2.32\EZPHOTO-1.2.32

# 2. 의존성 설치
flutter pub get

# 3. 이전 빌드 정리 (선택사항)
flutter clean

# 4. Windows 릴리스 빌드
flutter build windows --release
```

### 빌드 진행 상황

```
[  +63 ms] executing: [C:\src\flutter\] git ...
[ +123 ms] Building Windows application...
[+1234 ms] Compiling C++ code...
[+2345 ms] Linking...
[+3456 ms] Built build\windows\x64\runner\Release\pol_photo.exe
```

---

## 📦 배포 파일 준비

### 빌드 결과 위치

```
프로젝트폴더\
└── build\
    └── windows\
        └── x64\
            └── runner\
                └── Release\
                    ├── pol_photo.exe          ← 실행 파일
                    ├── flutter_windows.dll
                    ├── data\
                    │   ├── icudtl.dat
                    │   └── app.so
                    └── [기타 DLL 파일들]
```

### 배포 패키지 만들기

**옵션 A: 전체 폴더 배포**
```
Release 폴더 전체를 압축 → 배포
(약 30-50MB)
```

**옵션 B: 설치 프로그램 생성** (고급)
```
Inno Setup 또는 NSIS 사용하여 인스톨러 제작
```

### 배포 패키지 구조

```
REphoto-Windows-v1.2.28\
├── pol_photo.exe
├── flutter_windows.dll
├── data\
│   ├── icudtl.dat
│   └── app.so
├── README.txt
└── [기타 필요한 DLL들]
```

---

## 🎮 실행 파일 테스트

### 테스트 방법

1. **빌드 폴더에서 직접 실행**
   ```
   build\windows\x64\runner\Release\pol_photo.exe
   ```

2. **다른 폴더로 복사 후 테스트**
   - Release 폴더 전체를 바탕화면으로 복사
   - pol_photo.exe 실행
   - 정상 작동 확인

### 체크리스트

- [ ] 앱이 정상적으로 실행됨
- [ ] "사진 추가" 버튼으로 파일 선택 가능
- [ ] "사진으로 PDF 만들기" 기능 작동
- [ ] PDF가 Documents 폴더에 저장됨
- [ ] 레이아웃 편집 기능 작동
- [ ] 다국어 전환 작동 (한국어/영어)

---

## 🐛 문제 해결

### 오류 1: Flutter not found

**증상**: `'flutter'은(는) 내부 또는 외부 명령...`

**해결**:
```bash
# PATH 확인
echo %PATH%

# Flutter 재설치 또는 PATH 재설정
# 새 터미널 열기
```

### 오류 2: Visual Studio not found

**증상**: `No Visual Studio installation found`

**해결**:
```bash
# Visual Studio 2022 설치
# "C++ 데스크톱 개발" 워크로드 선택

# 설치 후 flutter doctor 다시 실행
flutter doctor
```

### 오류 3: CMake error

**증상**: `CMake generation failed`

**해결**:
```bash
# 1. 이전 빌드 삭제
flutter clean

# 2. pub cache 정리
flutter pub cache repair

# 3. 다시 빌드
flutter pub get
flutter build windows --release
```

### 오류 4: 빌드는 성공했지만 실행 안 됨

**증상**: 더블클릭해도 앱이 안 열림

**해결**:
```bash
# Command Prompt에서 실행하여 에러 확인
cd build\windows\x64\runner\Release
pol_photo.exe

# 누락된 DLL 확인
# 필요시 Visual C++ Redistributable 설치
# https://aka.ms/vs/17/release/vc_redist.x64.exe
```

### 오류 5: gal 또는 permission_handler 관련

**증상**: `gal plugin not found` 또는 빌드 오류

**해결**:
```bash
# 이미 제거되었지만 캐시에 남아있을 수 있음
flutter clean
flutter pub get
flutter build windows --release
```

---

## 📝 빌드 로그 확인

상세한 빌드 로그가 필요한 경우:

```bash
# 상세 모드로 빌드
flutter build windows --release --verbose > build_log.txt 2>&1

# 로그 파일 확인
notepad build_log.txt
```

---

## 🎉 배포 전 체크리스트

빌드 완료 후 확인:

- [ ] **실행 파일 존재**: `build\windows\x64\runner\Release\pol_photo.exe`
- [ ] **파일 크기**: 약 15-30MB (exe 단독)
- [ ] **필요 DLL 포함**: flutter_windows.dll, 기타 DLL들
- [ ] **data 폴더 포함**: icudtl.dat, app.so
- [ ] **실행 테스트**: 다른 폴더에서도 작동 확인
- [ ] **기능 테스트**: 모든 주요 기능 작동 확인
- [ ] **버전 확인**: 앱 정보에 올바른 버전 표시

---

## 🔧 고급: 빌드 최적화

### 1. 앱 아이콘 변경

```
windows\runner\resources\app_icon.ico
```

### 2. 앱 이름 및 버전 변경

**pubspec.yaml**:
```yaml
version: 1.2.28+28
```

**windows/runner/Runner.rc**:
```cpp
VALUE "ProductName", "REphoto"
VALUE "FileDescription", "Photo Layout Editor"
```

### 3. 릴리스 빌드 최적화

```bash
# 최소 크기 빌드
flutter build windows --release --split-debug-info=debug-symbols

# obfuscate (난독화)
flutter build windows --release --obfuscate --split-debug-info=debug-symbols
```

---

## 📞 도움말

**Flutter 공식 문서**:
- https://docs.flutter.dev/deployment/windows

**문제 발생 시**:
1. `flutter doctor -v` 결과 확인
2. 빌드 로그 저장
3. GitHub Issues 또는 개발자에게 문의

---

**빌드 성공을 기원합니다! 🚀**
