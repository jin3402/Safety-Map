# 📍 Safety-Map (안전한 길찾기 및 안심 귀가 서비스)

> "사용자의 안전한 이동을 보장하고, 위급 상황 시 즉각적인 대응을 돕는 크로스 플랫폼 애플리케이션"

'Safety-Map'는 구글 맵 기반의 실시간 위치 추적과 긴급 구조 요청 기능을 통합하여, 늦은 밤 귀가하거나 낯선 길을 갈 때 사용자의 안전을 지켜주는 서비스입니다. 

<br>

## 📱 Screen Preview 스크린샷 이미지 

<img width="86" height="191" alt="Image" src="https://github.com/user-attachments/assets/1420e589-c0b1-4842-b11b-c7311cd27f4f" />
<img width="81" height="187" alt="Image" src="https://github.com/user-attachments/assets/066499eb-03f3-45d5-bd5a-d0609e094a9d" />
<img width="84" height="191" alt="Image" src="https://github.com/user-attachments/assets/ebbfd41a-b152-4c04-bf0e-bc1fec2ca78f" />
<img width="103" height="197" alt="Image" src="https://github.com/user-attachments/assets/7827e70a-170e-4e42-a0b6-1deeb7bab822" />

<br>

## ✨ Key Features (주요 기능)

* <<실시간 안전 지도 (Safety Map)>>
  * `Maps_flutter`와 `geolocator`를 활용하여 사용자의 실시간 위치를 추적합니다.
  * 주변의 안전 스팟(경찰서,소방서 등) 및 위험 구역을 지도 상에 시각화하여 제공합니다.
* **🚨 원터치 긴급 호출 (Quick SOS)**
  * 위급 상황 발생 시 단 한 번의 터치로 작동합니다.
  * `url_launcher`를 통해 사전에 등록된 비상 연락처 및 112/119로 즉시 전화 연결 및 위치 메시지를 전송합니다.
* **⚙️ 사용자 맞춤 설정 (Custom Settings)**
  * `shared_preferences`를 활용해 개인별 비상 연락망과 앱 알림 설정을 기기 로컬에 안전하게 저장합니다.

<br>

## 🛠 Tech Stack (기술 스택)

* Framework:** Flutter (Dart >= 3.4.3)
* Map & Location:** Google Maps API, `geolocator`
* Network & Storage:** REST API (`http`), `shared_preferences`
* **System & Security:** `flutter_dotenv`, `permission_handler`

<br>

## 🏗 Architecture & Highlights (개발 주안점)

**1. 방어적 프로그래밍 (Defensive Programming)**
* 보안을 위해 `.env` 파일(API Key 보관)을 Git에서 제외하여 관리하고 있습니다.
* 타 개발 환경에서 `.env` 파일 누락 시 앱이 강제 종료되는 현상을 방지하기 위해, 초기화 단계(`main.dart`)에 `try-catch` 예외 처리를 구현하여 안정성을 높였습니다.

**2. 유지보수를 고려한 라우팅 설계**
* 화면 전환을 하드코딩하지 않고, Named Route 방식을 채택하여 라우팅 로직을 중앙 집중화했습니다. (`/splash`, `/login`, `/home` 등)

**3. Material 3 기반의 일관된 UI/UX**
* 최신 Flutter 디자인 시스템인 `useMaterial3`를 적용했습니다.
* 신뢰감을 주는 푸른색 계열(`#2567E8`)을 `seedColor`로 지정하여 앱 전반에 통일감 있는 브랜드 컬러를 부여했습니다.

<br>

## 🚀 Getting Started (실행 방법)

본 프로젝트를 로컬 환경에서 실행하기 위한 가이드입니다.

### 1. Prerequisites
* Flutter SDK (버전 3.4.3 이상 권장)
* Google Maps API Key

### 2. Installation & Run
```bash
# 1. 패키지 다운로드
$ flutter pub get

# 2. 환경변수 세팅 (필수)
# 프로젝트 루트 경로에 .env 파일을 생성하고 아래 키를 입력하세요.
# GOOGLE_MAPS_API_KEY=당신의_API_키

# 3. 앱 실행 (macOS, Android, iOS, Web 지원)
$ flutter run
<<이상입니다>>