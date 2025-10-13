# FIELD PHOTO

FIELD PHOTO는 Flutter 기반의 데스크톱·웹용 사진 레이아웃 편집 도구입니다. 여러 장의 사진을 불러와 레이아웃을 구성하고 이미지 또는 PDF로 저장·공유할 수 있으며, 한글/영어 다국어 UI를 지원합니다.

## 주요 기능
- 사진 단일/다중 선택 및 레이아웃 자동 배치
- 제목, 캡션, 페이지 번호 등 레이아웃 세부 옵션 제공
- PDF/PNG 저장 및 공유 (윈도우·맥·리눅스, 웹)
- 사용자 지정 저장 폴더 기억 및 빠른 접근
- 다크 모드와 반응형 UI

## 설치 및 실행
```bash
git clone https://github.com/jagallang/FIELD_PHOTO.git
cd FIELD_PHOTO
flutter pub get
flutter run -d windows   # macOS: -d macos, Linux: -d linux, Web: -d chrome
```

## 빌드
```bash
flutter build windows  # 또는 macos / linux / web
```

## 개발 가이드
- `lib/core/utils/io_helper.dart`는 파일 시스템 접근을 추상화하여 플랫폼별 예외를 최소화합니다.
- 저장 경로는 `SettingsRepository`를 통해 지속적으로 관리됩니다.
- 에디터 UI는 `PhotoEditorScreen`, `PhotoGrid` 위젯을 중심으로 구현되어 있습니다.

## 릴리스 절차
1. 변경 사항을 `git status`로 확인 후 스테이징
2. `git commit -m "feat: ..."`으로 커밋
3. `git tag v1.1.0`
4. 원격 저장소에 push: `git push origin main --tags`
