# SafeWay (Safety-Map)

늦은 귀가나 낯선 길에서 쓰는 안전 지도 앱을 목표로 만든 Flutter 앱입니다. 현재 위치를 지도에 표시하고, 긴급 전화(112·1366·119) 연결과 자주 가는 장소 저장을 제공합니다.

- 상태: 지도·긴급 연락처·즐겨찾기는 동작하고, 로그인은 서버 없이 입력 형식만 확인합니다. 주변 안전시설 검색·비상벨·위치 공유는 화면만 있고 구현되지 않았습니다(아래 "한계").
- 대상: Android·iOS. 웹 빌드는 되지만 웹용 지도 키 설정이 없어 지도는 뜨지 않습니다.

## 화면

<img width="200" alt="Image" src="https://github.com/user-attachments/assets/1420e589-c0b1-4842-b11b-c7311cd27f4f" />
<img width="200" alt="Image" src="https://github.com/user-attachments/assets/066499eb-03f3-45d5-bd5a-d0609e094a9d" />
<img width="200" alt="Image" src="https://github.com/user-attachments/assets/ebbfd41a-b152-4c04-bf0e-bc1fec2ca78f" />
<img width="200" alt="Image" src="https://github.com/user-attachments/assets/7827e70a-170e-4e42-a0b6-1deeb7bab822" />

## 주요 기능

- 스플래시 → 로그인·회원가입(입력 검증) → 하단 탭 4개(설정·안전시설·홈·공유)
- 홈: Google 지도, 위치 권한 요청 후 현재 위치 마커와 카메라 이동
- 설정 → 긴급 연락처: 112·여성긴급전화 1366·119 카드를 누르면 전화 앱이 번호가 입력된 상태로 열림
- 설정 → 즐겨찾기: 집·직장 주소를 기기(SharedPreferences)에 저장
- 설정 → 개인정보 처리방침, 로그아웃

## 기술 스택

Flutter 3.35 (Dart 3.9), `google_maps_flutter`, `geolocator`, `url_launcher`, `shared_preferences`, `flutter_test`

## 문제와 해결

**1. 저장소를 새로 받으면 빌드·테스트가 실패**
`pubspec.yaml`이 `.env`를 Flutter 에셋으로 등록했는데 `.env`는 `.gitignore` 대상이라, `flutter test`·`flutter build`가 "No file or variants found for asset: .env"로 멈췄습니다. 에셋으로 넣으면 `.env` 파일이 앱 안에 그대로 들어가는 문제도 있었습니다. Dart 코드는 키를 쓰지 않아 에셋 등록과 `flutter_dotenv`를 없애고, 키는 플랫폼 빌드 설정으로만 넘깁니다.
관련: `pubspec.yaml`, `android/app/build.gradle.kts`

**2. iOS에서 지도 API 키가 전달되지 않던 구조**
`AppDelegate`가 앱 번들 루트에서 `.env`를 찾았지만 Xcode 프로젝트에는 `.env`가 없고 Flutter 에셋은 다른 경로에 들어가서, 키를 읽을 수 없었습니다. `Secrets.xcconfig` → `Info.plist`(`GMSApiKey`) → `AppDelegate` 순서로 바꿨습니다. 이 환경에 Xcode가 없어 iOS 빌드는 확인하지 못했습니다.
관련: `ios/Flutter/*.xcconfig`, `ios/Runner/Info.plist`, `ios/Runner/AppDelegate.swift`

**3. 화면을 떠난 뒤 늦게 실행되는 화면 전환**
로그인은 1초, 회원가입은 2초 뒤 `Future.delayed`에서 화면을 바꾸는데, 그 사이 뒤로 가면 이미 사라진 `context`로 `Navigator`를 찾다가 예외가 났습니다. 이동 직전에 `mounted`를 확인하고, 이 상황을 재현하는 위젯 테스트를 추가했습니다.
관련: `lib/screens/login_screen.dart`, `test/auth_flow_test.dart`

**4. 위치가 지도보다 먼저 오면 카메라가 움직이지 않음**
현재 위치를 받은 시점에 지도 컨트롤러가 아직 없으면 카메라 이동이 건너뛰어져, 마커가 화면 밖에 남을 수 있었습니다. 지도가 만들어질 때 이미 받은 위치로 옮기도록 했습니다.
관련: `lib/screens/home_screen.dart`

## 구조

```text
lib/
├── main.dart               # 라우트: /splash, /login, /signup, /home
├── screens/
│   ├── main_screen.dart    # 하단 탭 (IndexedStack)
│   ├── home_screen.dart    # 지도 + 현재 위치
│   ├── safespot_screen.dart, spot_share_screen.dart
│   ├── settings_screen.dart → favorites / emergency_contact / privacy_policy
│   └── splash / login / signup
└── widgets/logo_placeholder.dart
test/                       # 로그인·회원가입, 즐겨찾기, 긴급 전화, 로그아웃 흐름
```

## 실행

```bash
flutter pub get
cp .env.example .env                                              # Android: GOOGLE_MAPS_API_KEY
cp ios/Flutter/Secrets.xcconfig.example ios/Flutter/Secrets.xcconfig   # iOS: GOOGLE_MAPS_API_KEY
flutter run
flutter test
flutter analyze
```

## 환경변수

| 이름 | 위치 | 용도 |
|---|---|---|
| `GOOGLE_MAPS_API_KEY` | `.env` (Android), `ios/Flutter/Secrets.xcconfig` (iOS) | Google Maps SDK 키 |

두 파일 모두 `.gitignore` 대상입니다. 키는 앱 패키지명·번들 ID로 사용 제한을 걸어 두는 것을 권합니다.

## 한계와 다음 단계

- 안전시설 탭의 파출소·경찰서·해바라기센터 검색과 비상벨, 공유 탭의 위치 공유는 구현되지 않았습니다. 안전시설 함수들은 첫 커밋부터 비어 있었고, 지금은 버튼을 누르면 "준비 중" 안내를 보여줍니다.
- 로그인·회원가입은 서버가 없어 형식만 맞으면 통과합니다.
- 로고 자리는 외부 자리표시(placeholder) 이미지이고, 개인정보 처리방침의 연락처는 예시 값입니다.
- 하단 탭이 `IndexedStack`이라 홈과 안전시설 탭의 지도 두 개가 앱 시작 시 함께 만들어집니다.
- 지도·위치 화면은 플랫폼 플러그인이 필요해 위젯 테스트에서 제외했습니다.
