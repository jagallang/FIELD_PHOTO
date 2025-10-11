# ⚡ 빠른 시작 가이드

## 🎯 Windows 실행 파일 만들기 (3단계)

### 1️⃣ Flutter 설치 (처음 1회만)

**다운로드**: https://docs.flutter.dev/get-started/install/windows

1. Flutter SDK 다운로드 (.zip 파일)
2. `C:\src\flutter`에 압축 해제
3. 시스템 환경변수 PATH에 `C:\src\flutter\bin` 추가
4. 새 Command Prompt 열기
5. 확인: `flutter doctor`

### 2️⃣ Visual Studio 2022 설치 (처음 1회만)

**다운로드**: https://visualstudio.microsoft.com/downloads/

1. Visual Studio Community 2022 다운로드 (무료)
2. 설치 시 **"C++ 데스크톱 개발"** 워크로드 선택
3. 설치 완료
4. 확인: `flutter doctor`

### 3️⃣ 빌드 실행

**방법 A: 자동 스크립트** (권장 ⭐)
```
build_windows.bat 더블클릭
```

**방법 B: 수동 명령어**
```bash
cd C:\Users\USER\Desktop\code\EZPHOTO-1.2.32\EZPHOTO-1.2.32
flutter pub get
flutter build windows --release
```

---

## 📂 빌드 결과

**실행 파일 위치**:
```
build\windows\x64\runner\Release\pol_photo.exe
```

**배포 방법**:
- Release 폴더 전체를 압축하여 배포
- 다른 PC에서 압축 해제 후 pol_photo.exe 실행

---

## ⚠️ 문제 발생 시

### Flutter가 인식 안 됨
```bash
# PATH 재확인
echo %PATH%

# 새 터미널 열기
```

### Visual Studio 관련 오류
```bash
# "C++ 데스크톱 개발" 워크로드 설치 확인
flutter doctor -v
```

### 빌드 실패
```bash
flutter clean
flutter pub get
flutter build windows --release --verbose
```

---

## 📞 자세한 가이드

전체 가이드는 `WINDOWS_BUILD_GUIDE.md` 참조

---

**예상 소요 시간**:
- Flutter 설치: 10-15분
- Visual Studio 설치: 30-60분
- 첫 빌드: 5-10분
- 이후 빌드: 2-3분
