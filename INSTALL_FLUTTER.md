# 🚀 Flutter 설치 가이드 (초간단)

## ⚠️ Flutter가 설치되지 않았습니다!

빌드를 위해 먼저 Flutter를 설치해야 합니다.

---

## 📥 빠른 설치 (5분)

### 1️⃣ Flutter SDK 다운로드

**다운로드 링크**: https://docs.flutter.dev/get-started/install/windows

또는 직접 다운로드:
- https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.29.2-stable.zip

### 2️⃣ 압축 해제

```
다운로드한 ZIP 파일을 C:\src 폴더에 압축 해제

결과:
C:\src\flutter\
├── bin\
│   └── flutter.bat
├── packages\
└── ...
```

**중요**:
- `C:\Program Files` 같은 관리자 권한 필요한 곳은 피하세요
- 경로에 공백이 없는 곳을 선택하세요 (예: C:\src\flutter ✅, C:\Program Files\flutter ❌)

### 3️⃣ 환경변수 PATH 추가

#### 방법 A: GUI 사용 (권장)

1. **시작 메뉴** → "환경 변수" 검색
2. **"시스템 환경 변수 편집"** 클릭
3. **"환경 변수"** 버튼 클릭
4. **시스템 변수** 섹션에서 **Path** 선택
5. **"편집"** 클릭
6. **"새로 만들기"** 클릭
7. `C:\src\flutter\bin` 입력
8. **"확인"** → **"확인"** → **"확인"**

#### 방법 B: PowerShell 사용

```powershell
# PowerShell을 관리자 권한으로 실행
[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", "Machine") + ";C:\src\flutter\bin",
    "Machine"
)
```

### 4️⃣ 확인

**새 Command Prompt 또는 PowerShell 열기** (중요!)

```bash
flutter --version
```

**예상 출력**:
```
Flutter 3.29.2 • channel stable
Tools • Dart 3.7.2 • DevTools 2.xx.x
```

### 5️⃣ Flutter Doctor 실행

```bash
flutter doctor
```

**예상 출력**:
```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.29.2, on Windows 11)
[!] Windows Version (Installed version of Windows is version 10 or higher)
[!] Visual Studio - develop Windows apps
    ✗ Visual Studio not installed
[✓] VS Code (version 1.xx)
[✓] Connected device (1 available)
[✓] Network resources
```

---

## 🛠️ Visual Studio 2022 설치 (빌드 필수)

### 다운로드

https://visualstudio.microsoft.com/downloads/

**Visual Studio Community 2022** 선택 (무료)

### 설치 중 선택사항

**워크로드** 탭에서:
- ✅ **"C++를 사용한 데스크톱 개발"** (Desktop development with C++)

**개별 구성 요소** 탭에서 (자동 선택됨):
- ✅ MSVC v143 - VS 2022 C++ x64/x86 빌드 도구
- ✅ Windows 10/11 SDK

### 설치 후 확인

```bash
flutter doctor
```

Visual Studio 항목이 ✓로 표시되어야 함

---

## ✅ 설치 완료 확인

모든 설치 후:

```bash
# 새 터미널 열기
flutter doctor -v
```

**필수 항목**:
- ✓ Flutter
- ✓ Windows Version
- ✓ Visual Studio

**선택 항목** (없어도 됨):
- Android toolchain (Android 빌드용)
- Chrome (웹 빌드용)

---

## 🎯 설치 완료 후

### 1단계: 의존성 설치

```bash
cd C:\Users\USER\Desktop\code\EZPHOTO-1.2.32\EZPHOTO-1.2.32
flutter pub get
```

### 2단계: 빌드

```bash
flutter build windows --release
```

또는

```bash
build_windows.bat
```

---

## ⏱️ 예상 소요 시간

| 항목 | 시간 |
|------|------|
| Flutter SDK 다운로드 | 2-3분 |
| 압축 해제 및 PATH 설정 | 2-3분 |
| Visual Studio 다운로드 | 5-10분 |
| Visual Studio 설치 | 20-30분 |
| 첫 빌드 | 5-10분 |
| **총합** | **약 40-60분** |

---

## 🐛 문제 해결

### "flutter는 내부 또는 외부 명령이 아닙니다"

- PATH 설정을 다시 확인하세요
- **새 터미널을 열어야 합니다** (기존 터미널은 PATH 갱신 안 됨)
- 재부팅 후 다시 시도

### Visual Studio 설치했는데 flutter doctor에서 안 보임

```bash
# Visual Studio Build Tools 확인
flutter doctor -v

# "C++ 데스크톱 개발" 워크로드 재확인
# Visual Studio Installer에서 수정
```

### 빌드 중 CMake 오류

```bash
flutter clean
flutter pub get
flutter build windows --release
```

---

## 🔗 유용한 링크

- **Flutter 공식 문서**: https://docs.flutter.dev/get-started/install/windows
- **Flutter YouTube**: https://www.youtube.com/c/flutterdev
- **한글 가이드**: https://flutter-ko.dev/docs/get-started/install/windows

---

## 📞 다음 단계

1. ✅ Flutter 설치 완료
2. ✅ Visual Studio 설치 완료
3. ✅ `flutter doctor` 통과
4. ➡️ **프로젝트 폴더로 이동**
5. ➡️ **`build_windows.bat` 실행**

---

**설치가 완료되면 `build_windows.bat`를 더블클릭하세요!** 🚀
