# 🎯 Windows 환경변수 PATH 설정 완벽 가이드

## 📋 목차
1. [환경변수란?](#환경변수란)
2. [GUI 방법 (초보자용)](#gui-방법-초보자용)
3. [PowerShell 방법 (빠름)](#powershell-방법-빠름)
4. [확인 방법](#확인-방법)
5. [문제 해결](#문제-해결)

---

## 🤔 환경변수란?

**환경변수 PATH**는 Windows가 실행 파일을 찾는 경로 목록입니다.

### 예시:
```
PATH에 C:\src\flutter\bin이 없을 때:
❌ flutter --version
→ 오류: 'flutter'은(는) 내부 또는 외부 명령이 아닙니다.

PATH에 C:\src\flutter\bin을 추가한 후:
✅ flutter --version
→ Flutter 3.29.2 • channel stable
```

---

## 🖱️ GUI 방법 (초보자용)

### 전체 과정 (스크린샷 포함 설명)

#### 1단계: 시스템 속성 열기

**방법 A: 검색 사용 (가장 쉬움) ⭐**

```
1. 키보드에서 [Windows 키] 누르기 (시작 메뉴)
2. "환경 변수" 입력
3. 검색 결과에서 선택:
   "시스템 환경 변수 편집" 또는
   "Edit the system environment variables"
```

**방법 B: 제어판 사용**

```
1. [Windows 키 + R] 눌러서 실행 창 열기
2. "sysdm.cpl" 입력 후 Enter
3. "고급" 탭 클릭
```

**방법 C: 설정 앱 사용**

```
1. 시작 메뉴 > 설정 (톱니바퀴 아이콘)
2. "시스템 정보" 검색
3. "시스템 정보" 클릭
4. 왼쪽 하단 "고급 시스템 설정" 클릭
```

---

#### 2단계: 환경 변수 창 열기

```
┌─────────────────────────────────────┐
│  시스템 속성                         │
│  ─────────────────────────────────  │
│                                     │
│  [컴퓨터 이름] [하드웨어] [고급]...  │
│                                     │
│  성능:                              │
│  시각 효과, 프로세서 일정...         │
│  [설정]                             │
│                                     │
│  사용자 프로필:                      │
│  데스크톱 설정 관련...              │
│  [설정]                             │
│                                     │
│  시작 및 복구:                       │
│  시스템 시작...                     │
│  [설정]                             │
│                                     │
│  환경 변수:                          │
│  ┌───────────────────┐              │
│  │   환경 변수(E)...  │ ← 이 버튼!   │
│  └───────────────────┘              │
│                                     │
│  [확인]  [취소]  [적용]              │
└─────────────────────────────────────┘
```

**"환경 변수(E)..." 버튼을 클릭하세요!**

---

#### 3단계: Path 변수 찾기

환경 변수 창이 두 부분으로 나뉩니다:

```
┌─────────────────────────────────────────────┐
│  환경 변수                                   │
│  ─────────────────────────────────────────  │
│                                             │
│  ┌─ USER의 사용자 변수 ─────────────────┐   │
│  │ 변수        값                        │   │
│  │ ─────────  ─────────────────────────  │   │
│  │ OneDrive   C:\Users\USER\OneDrive     │   │
│  │ Path       C:\Users\USER\...          │   │
│  │ TEMP       C:\Users\USER\AppData\...  │   │
│  │                                       │   │
│  └───────────────────────────────────────┘   │
│       [새로 만들기]  [편집]  [삭제]           │
│                                             │
│  ┌─ 시스템 변수 ─────────────────────────┐   │
│  │ 변수        값                        │   │
│  │ ─────────  ─────────────────────────  │   │
│  │ OS         Windows_NT                 │   │
│  │ Path       C:\Windows\system32;...    │ ← 이것!
│  │ TEMP       C:\Windows\TEMP            │   │
│  │                                       │   │
│  └───────────────────────────────────────┘   │
│       [새로 만들기]  [편집]  [삭제]           │
│                                             │
│  [확인]  [취소]                              │
└─────────────────────────────────────────────┘
```

**중요!**
- 위쪽 "사용자 변수" 말고
- **아래쪽 "시스템 변수"의 "Path"를 선택하세요!**

---

#### 4단계: Path 편집

```
1. 시스템 변수 섹션에서 "Path" 클릭 (한 번)
2. "편집" 버튼 클릭
```

Path 편집 창이 열립니다:

```
┌─────────────────────────────────────────────┐
│  환경 변수 편집                              │
│  ─────────────────────────────────────────  │
│                                             │
│  ┌───────────────────────────────────────┐  │
│  │ C:\Windows\system32                   │  │
│  │ C:\Windows                            │  │
│  │ C:\Windows\System32\Wbem              │  │
│  │ C:\Program Files\Git\cmd              │  │
│  │ C:\Program Files\nodejs               │  │
│  │ ...                                   │  │
│  │                                       │  │
│  └───────────────────────────────────────┘  │
│                                             │
│  ┌─────────────┐  ┌──────┐  ┌──────┐       │
│  │ 새로 만들기  │  │ 편집 │  │ 삭제 │       │
│  └─────────────┘  └──────┘  └──────┘       │
│                                             │
│  [확인]  [취소]                              │
└─────────────────────────────────────────────┘
```

---

#### 5단계: Flutter 경로 추가

```
1. "새로 만들기" 버튼 클릭
2. 목록 맨 아래에 새 줄이 생성됩니다
3. 다음 경로를 정확히 입력:

   C:\src\flutter\bin

4. Enter 키 누르기
```

**입력 후:**

```
┌─────────────────────────────────────────────┐
│  환경 변수 편집                              │
│  ─────────────────────────────────────────  │
│                                             │
│  ┌───────────────────────────────────────┐  │
│  │ C:\Windows\system32                   │  │
│  │ C:\Windows                            │  │
│  │ C:\Windows\System32\Wbem              │  │
│  │ C:\Program Files\Git\cmd              │  │
│  │ C:\Program Files\nodejs               │  │
│  │ C:\src\flutter\bin          ← 새로 추가! │
│  └───────────────────────────────────────┘  │
│                                             │
│  [새로 만들기]  [편집]  [삭제]               │
│                                             │
│  [확인]  [취소]                              │
└─────────────────────────────────────────────┘
```

---

#### 6단계: 모든 창 닫기 (중요!)

**반드시 "확인" 버튼을 3번 눌러야 합니다!**

```
1. "환경 변수 편집" 창에서 [확인] 클릭
   ↓
2. "환경 변수" 창에서 [확인] 클릭
   ↓
3. "시스템 속성" 창에서 [확인] 클릭
```

**"취소"를 누르면 설정이 저장되지 않습니다!**

---

#### 7단계: 새 터미널 열기 (매우 중요!)

**PATH 변경 사항은 새 터미널에서만 적용됩니다!**

```
❌ 잘못된 방법:
기존 Command Prompt에서 flutter --version 실행
→ 여전히 오류 발생

✅ 올바른 방법:
1. 기존 Command Prompt 완전히 종료
2. 새 Command Prompt 열기
3. flutter --version 실행
→ 정상 작동!
```

---

## ⚡ PowerShell 방법 (빠름)

명령어 한 줄로 PATH에 추가하기:

### 관리자 권한 PowerShell 열기

```
1. 시작 메뉴에서 "PowerShell" 검색
2. "Windows PowerShell" 또는 "Terminal" 오른쪽 클릭
3. "관리자 권한으로 실행" 선택
```

### 명령어 실행

```powershell
# 현재 PATH 확인
$env:Path

# Flutter 경로 추가 (시스템 전체)
[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", "Machine") + ";C:\src\flutter\bin",
    "Machine"
)

# 성공 메시지 출력
Write-Host "PATH에 Flutter가 추가되었습니다!" -ForegroundColor Green
```

**주의**: 관리자 권한이 필요합니다!

### 확인

```powershell
# 새 PowerShell 열기 (중요!)
# 그 다음 확인:
flutter --version
```

---

## ✅ 확인 방법

### 1. PATH에 추가되었는지 확인

**Command Prompt 또는 PowerShell (새 창)**:

```bash
# 방법 1: PATH 전체 보기
echo %PATH%

# 방법 2: flutter 포함된 경로만 보기
echo %PATH% | findstr flutter

# 예상 결과:
# ...;C:\src\flutter\bin;...
```

**PowerShell**:

```powershell
# PATH를 보기 좋게 출력
$env:Path -split ';' | Select-String flutter

# 예상 결과:
C:\src\flutter\bin
```

---

### 2. Flutter 실행 확인

**새 Command Prompt에서**:

```bash
flutter --version
```

**예상 출력**:

```
Flutter 3.29.2 • channel stable • https://github.com/flutter/flutter.git
Framework • revision xxxx (x weeks ago) • 2025-xx-xx xx:xx:xx
Engine • revision xxxx
Tools • Dart 3.7.2 • DevTools 2.xx.x
```

---

### 3. Flutter 경로 확인

```bash
where flutter
```

**예상 출력**:

```
C:\src\flutter\bin\flutter
C:\src\flutter\bin\flutter.bat
```

---

## 🐛 문제 해결

### ❌ "flutter는 내부 또는 외부 명령이 아닙니다"

**원인 1: 새 터미널을 열지 않음**

```
해결:
1. 현재 Command Prompt 완전히 종료
2. 새로 열기
3. flutter --version 실행
```

**원인 2: PATH에 제대로 추가되지 않음**

```
확인:
echo %PATH% | findstr flutter

없으면:
1. 환경 변수 설정 다시 확인
2. C:\src\flutter\bin 정확히 입력했는지 확인
3. "확인" 버튼 3번 눌렀는지 확인
```

**원인 3: Flutter가 해당 경로에 없음**

```
확인:
dir C:\src\flutter\bin\flutter.bat

없으면:
Flutter를 제대로 이동했는지 확인
```

---

### ❌ PATH에 추가했는데도 안 됨

**해결 방법 순서대로 시도**:

#### 1. PC 재부팅
```
가장 확실한 방법
재부팅 후 새 터미널에서 확인
```

#### 2. 사용자 변수에도 추가
```
시스템 변수 말고
사용자 변수의 Path에도 동일하게 추가
```

#### 3. PowerShell 방법으로 재시도
```powershell
# 관리자 PowerShell
[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", "Machine") + ";C:\src\flutter\bin",
    "Machine"
)
```

#### 4. 경로에 공백이나 특수문자 확인
```
잘못된 예:
C:\Program Files\flutter\bin  (공백 있음, 권장 안 함)

올바른 예:
C:\src\flutter\bin
```

---

### ❌ 다른 프로그램이 작동 안 함

**원인: PATH에 잘못된 경로 추가**

```
확인:
echo %PATH%

해결:
1. 환경 변수 설정 다시 열기
2. Path 편집
3. 잘못된 항목 찾아서 삭제 또는 수정
4. 확인 3번
```

---

## 📝 체크리스트

설정 전:
- [ ] Flutter를 C:\src\flutter로 이동 완료
- [ ] C:\src\flutter\bin\flutter.bat 파일 존재 확인

설정 중:
- [ ] "시스템 변수"의 "Path" 선택 (사용자 변수 아님)
- [ ] "편집" 클릭
- [ ] "새로 만들기" 클릭
- [ ] `C:\src\flutter\bin` 정확히 입력
- [ ] "확인" 버튼 3번 클릭

설정 후:
- [ ] 기존 Command Prompt 모두 종료
- [ ] 새 Command Prompt 열기
- [ ] `flutter --version` 실행
- [ ] Flutter 버전 정보 출력됨

---

## 🎯 전체 과정 요약

```
1. Windows 키 누르기
   ↓
2. "환경 변수" 검색
   ↓
3. "시스템 환경 변수 편집" 클릭
   ↓
4. "환경 변수" 버튼 클릭
   ↓
5. 시스템 변수 → "Path" 선택
   ↓
6. "편집" 클릭
   ↓
7. "새로 만들기" 클릭
   ↓
8. "C:\src\flutter\bin" 입력
   ↓
9. "확인" 3번 클릭
   ↓
10. 새 Command Prompt 열기
   ↓
11. "flutter --version" 실행
   ↓
완료! ✅
```

---

## 💡 추가 팁

### 여러 버전의 Flutter 관리

```
C:\flutter-stable\bin  (안정 버전)
C:\flutter-beta\bin    (베타 버전)

PATH에는 하나만 추가하거나
사용할 때마다 변경
```

### PATH 순서 중요

```
PATH는 위에서 아래로 순서대로 검색
같은 이름의 프로그램이 여러 경로에 있으면
위쪽에 있는 것이 실행됨
```

### 백업

```
PATH 수정 전에 현재 PATH 복사해두기
echo %PATH% > path_backup.txt
```

---

## 📞 여전히 안 되면?

1. **PC 재부팅** (90% 해결)
2. **PowerShell 방법 사용**
3. **Flutter 재설치**
4. **다른 경로에 설치** (예: D:\flutter)

---

**설정이 완료되면 `build_windows.bat`를 실행하세요!** 🚀
