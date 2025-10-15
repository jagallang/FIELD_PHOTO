# POL PHOTO

POL PHOTO는 Flutter 기반의 데스크톱·웹용 사진 레이아웃 편집 도구입니다. 여러 장의 사진을 불러와 레이아웃을 구성하고 이미지 또는 PDF로 저장·공유할 수 있으며, 한글/영어 다국어 UI를 지원합니다.

**Version:** 1.2.34

## 주요 기능
- **사진 관리**: 단일/다중 사진 선택 및 드래그 앤 드롭 지원
- **다양한 레이아웃**: 1~4분할 레이아웃 자동 배치 및 커스터마이징
- **레이아웃 옵션**: 제목, 캡션, 페이지 번호 등 세부 설정
- **파일 저장**: PDF/PNG 형식으로 저장 및 공유
- **이미지 품질 최적화**: 저화질/중화질/고화질 선택 가능 (메모리 사용량 최적화)
- **사용자 설정**: 저장 폴더 기억, 언어 선택 (한글/English), 이미지 품질 설정
- **반응형 UI**: 데스크톱과 웹 환경에 최적화된 UI/UX
- **성능 최적화**: 비동기 이미지 로딩으로 UI 프리징 방지

## 시스템 요구사항

- **Flutter SDK**: 3.7.2 이상
- **Dart SDK**: 3.7.2 이상
- **지원 플랫폼**: Windows, macOS, Linux, Web

## 설치 및 실행

### 1. 저장소 클론
```bash
git clone https://github.com/jagallang/FIELD_PHOTO.git
cd FIELD_PHOTO
```

### 2. 의존성 설치
```bash
flutter pub get
```

### 3. 실행
```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux

# Web
flutter run -d chrome
```

## 빌드

### 릴리스 빌드
```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release

# Web
flutter build web --release
```

빌드 결과물은 다음 경로에 생성됩니다:
- Windows: `build/windows/x64/runner/Release/`
- macOS: `build/macos/Build/Products/Release/`
- Linux: `build/linux/x64/release/bundle/`
- Web: `build/web/`

## 프로젝트 구조

이 프로젝트는 Clean Architecture 패턴을 따릅니다:

```
lib/
├── core/               # 핵심 유틸리티 및 공통 기능
│   ├── di/            # 의존성 주입 (GetIt)
│   ├── errors/        # 에러 처리
│   ├── theme/         # 앱 테마 정의
│   └── utils/         # 유틸리티 함수
├── data/              # 데이터 레이어
│   ├── datasources/   # 로컬/원격 데이터 소스
│   └── repositories/  # Repository 구현체
├── domain/            # 도메인 레이어
│   ├── entities/      # 비즈니스 엔티티
│   ├── repositories/  # Repository 인터페이스
│   └── usecases/      # 비즈니스 로직 (Use Cases)
└── presentation/      # 프레젠테이션 레이어
    ├── bloc/          # 상태 관리 (BLoC 패턴)
    ├── screens/       # 화면 UI
    └── widgets/       # 재사용 가능한 위젯
```

## 주요 기술 스택

- **상태 관리**: Provider + ChangeNotifier (BLoC 패턴)
- **의존성 주입**: GetIt
- **이미지 처리**: image_picker
- **PDF 생성**: pdf, printing
- **다국어 지원**: easy_localization
- **파일 관리**: path_provider, file_picker

## 개발 가이드

### 파일 시스템 접근
- [lib/core/utils/io_helper.dart](lib/core/utils/io_helper.dart)는 파일 시스템 접근을 추상화하여 플랫폼별 예외를 최소화합니다
- 저장 경로는 `SettingsRepository`를 통해 지속적으로 관리됩니다

### 이미지 품질 설정
- **저화질 (기본값)**: 800x600 캐시 - 빠른 로딩, 메모리 사용량 97.6% 감소 (권장)
- **중화질**: 1200x900 캐시 - 균형잡힌 품질과 성능, 메모리 사용량 94.6% 감소
- **고화질**: 2000x1500 캐시 - 최고 품질, 메모리 사용량 85% 감소
- 설정 화면에서 언제든지 변경 가능하며, 앱 재시작 후에도 유지됩니다

### 상태 관리
- [lib/presentation/bloc/photo_editor_bloc.dart](lib/presentation/bloc/photo_editor_bloc.dart)가 사진 편집 상태를 관리합니다
- Provider 패턴을 통해 위젯 트리 전체에서 접근 가능합니다

### UI 컴포넌트
- 에디터 UI는 [lib/presentation/screens/editor/photo_editor_screen.dart](lib/presentation/screens/editor/photo_editor_screen.dart)에 구현되어 있습니다
- 레이아웃 그리드는 [lib/presentation/widgets/editor/photo_grid.dart](lib/presentation/widgets/editor/photo_grid.dart)에서 처리합니다

## 문제 해결

### 빌드 오류
빌드 중 오류가 발생하면 다음을 시도하세요:
```bash
flutter clean
flutter pub get
flutter build windows --release  # 또는 해당 플랫폼
```

### 분석 오류 확인
```bash
flutter analyze
```

## 릴리스 절차

1. 버전 업데이트: [pubspec.yaml](pubspec.yaml)의 `version` 수정
2. 변경 사항 확인:
   ```bash
   git status
   ```
3. 커밋:
   ```bash
   git add .
   git commit -m "chore: prepare vX.X.X release"
   ```
4. 태그 생성:
   ```bash
   git tag vX.X.X
   ```
5. 원격 저장소에 푸시:
   ```bash
   git push origin main --tags
   ```

## 라이선스

이 프로젝트의 라이선스 정보는 [LICENSE](LICENSE) 파일을 참조하세요.

## 기여

버그 리포트나 기능 제안은 GitHub Issues를 통해 제출해 주세요.
