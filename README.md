# 🚗 Tago Driver App

**Tago Driver**는 택시팟(Tago) 플랫폼의 운전자 전용 모바일 애플리케이션입니다.  
운전자는 이 앱을 통해 승객들의 요청을 확인하고, 배차를 수락하거나 채팅을 통해 승객과 소통할 수 있습니다.

---

## 🧱 프로젝트 구조
lib/                     # 공통 유틸리티 및 상수
├─ data/                     # Firebase 등 외부 데이터소스 관련 코드
│   ├─ models/               # 데이터 모델 정의
│   ├─ repositories/         # 데이터 접근 (Repository)
├─ presentation/             # UI 및 ViewModel 계층 (MVVM 구조)
│   ├─ pages/                # 각 화면 (예: login, home, chat)
│   ├─ viewmodels/           # 상태 관리 및 로직
│   └─ widgets/              # 재사용 가능한 UI 위젯
├─ services/                 # Firebase, Location, Notification 등
└─ main.dart                 # 앱 진입점---

## ⚙️ 개발 환경

- **Flutter SDK**: 3.x 이상  
- **Dart**: 3.x  
- **Firebase**:  
  - Authentication  
  - Cloud Firestore  
  - Cloud Messaging (푸시 알림)  
  - Storage  
- **State Management**: Provider  
- **Android minSdkVersion**: 23  

---

## 🔥 Firebase 설정

1. Firebase 콘솔에서 `tago_driver` 프로젝트 생성  
2. Android/iOS 앱 등록  
3. `google-services.json` (Android) → `/android/app/` 폴더에 추가  
   `GoogleService-Info.plist` (iOS) → `/ios/Runner/` 폴더에 추가  
4. `firebase_options.dart` 자동 생성:
   ```bash
   flutterfire configure