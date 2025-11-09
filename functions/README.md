# Tago Driver Cloud Functions

드라이버용 앱 푸시 알림을 위한 Firebase Cloud Functions

## 📋 기능

### 1. 새로운 라이드 요청 알림 (`onNewRideRequest`)
- **트리거**: `rideRequests/{rideType}/items/{rideId}` 문서 생성 시
- **대상**: role이 'driver'인 모든 사용자
- **조건**: status가 'pending'인 경우만
- **내용**: 라이드 타입, 출발지, 도착지, 출발 시간

### 2. 채팅 메시지 알림 (`onNewChatMessage`)
- **트리거**: `rideRequests/{rideType}/items/{rideId}/Chats/{chatId}` 문서 생성 시
- **대상**: 해당 라이드의 드라이버만
- **조건**: senderId가 userId(승객)인 경우만
- **내용**: 발신자 이름, 메시지 내용

⚠️ **중요**: 승객에게는 알림을 보내지 않습니다 (승객 앱에서 자체 처리)

## 🚀 배포 방법

### 1. 초기 설정

```bash
# Firebase CLI 설치 (아직 안 했다면)
npm install -g firebase-tools

# Firebase 로그인
firebase login

# 프로젝트 루트에서 Firebase 초기화
cd /Users/kim/TAGOREV/drivernoti/tago_driver
firebase init

# 선택 사항:
# - Functions: Configure a Cloud Functions directory and its files
# - 기존 프로젝트 선택
# - TypeScript 선택
# - ESLint는 선호에 따라
# - 의존성 설치 Yes
```

### 2. 의존성 설치

```bash
cd functions
npm install
```

### 3. 빌드 및 배포

```bash
# TypeScript 컴파일
npm run build

# Firebase에 배포
npm run deploy
```

### 4. 배포 확인

배포 후 Firebase Console에서 확인:
1. Firebase Console → Functions 탭
2. 다음 두 함수가 표시되어야 함:
   - `onNewRideRequest`
   - `onNewChatMessage`

## 🧪 테스트

### 로컬 에뮬레이터로 테스트

```bash
# 에뮬레이터 시작
npm run serve

# 다른 터미널에서 Firestore 데이터 생성하여 트리거 테스트
```

### 프로덕션 테스트

1. 드라이버 계정으로 앱 로그인 → FCM 토큰 저장 확인
2. 승객 앱에서 새 라이드 요청 생성 → 드라이버에게 알림 도착 확인
3. 승객이 채팅 메시지 전송 → 드라이버에게 알림 도착 확인

## 📊 로그 확인

```bash
# 실시간 로그 확인
npm run logs

# 또는 Firebase Console → Functions → 로그 탭
```

## ⚠️ 주의사항

1. **iOS APNS 설정**: Firebase Console → Project Settings → Cloud Messaging에서 APNS 인증 키나 인증서 등록 필수

2. **Firestore 인덱스**: 복합 쿼리를 사용하므로 인덱스가 필요할 수 있음. 첫 배포 후 로그에서 인덱스 생성 링크 확인

3. **과금**: Cloud Functions는 무료 할당량 초과 시 과금됨. Firebase Console에서 사용량 모니터링 권장

4. **토큰 관리**: 무효한 FCM 토큰은 자동으로 삭제됨

## 🔧 문제 해결

### 알림이 오지 않는 경우

1. **FCM 토큰 확인**
   ```
   Firestore → users → {userId} → fcmTokens 컬렉션 확인
   ```

2. **Functions 로그 확인**
   ```bash
   firebase functions:log
   ```

3. **iOS 설정 확인**
   - Info.plist에 알림 권한 설정
   - Runner.entitlements에 Push Notifications 추가
   - Firebase Console에 APNS 키 등록

### 배포 실패 시

```bash
# 권한 확인
firebase login --reauth

# 프로젝트 확인
firebase projects:list
firebase use [project-id]

# 재배포
cd functions
npm run build
npm run deploy
```

## 📝 코드 구조

```
functions/
├── src/
│   └── index.ts          # Cloud Functions 메인 파일
├── package.json          # 의존성 및 스크립트
├── tsconfig.json         # TypeScript 설정
├── .gitignore           # Git 제외 파일
└── README.md            # 이 문서
```

## 🔄 업데이트

코드 수정 후:

```bash
cd functions
npm run build
npm run deploy
```

특정 함수만 배포:

```bash
firebase deploy --only functions:onNewRideRequest
firebase deploy --only functions:onNewChatMessage
```

