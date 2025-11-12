# 릴리스 노트 / Release Notes

## 버전 1.0.2+1

### 주요 변경 사항 / What's New

#### 🌐 다국어 지원 완전 구현 / Full Internationalization Support
- **한국어 및 영어 완전 지원** / Full Korean and English Support
  - 앱 전체 UI가 한국어와 영어를 완전히 지원합니다
  - 사용자 언어 설정에 따라 자동으로 언어가 변경됩니다
  - The entire app UI now fully supports both Korean and English
  - Language automatically changes based on user's device language settings

#### 💬 실시간 채팅 메시지 번역 기능 / Real-time Chat Message Translation
- **Google Translate API 통합** / Google Translate API Integration
  - 채팅방에서 한국어, 영어, 중국어, 스페인어 메시지를 실시간으로 번역합니다
  - 앱 언어 설정에 맞춰 자동으로 번역 방향이 결정됩니다
  - 원문 보기/번역 보기 토글 기능 제공
  - Real-time translation of Korean, English, Chinese, and Spanish messages in chat rooms
  - Translation direction automatically determined based on app language settings
  - Toggle between original and translated text

#### 🔧 UI 개선 사항 / UI Improvements
- **레이아웃 오버플로우 수정** / Fixed Layout Overflow Issues
  - 프로필 수정 화면 및 약관 화면의 레이아웃 겹침 문제 해결
  - 긴 텍스트가 잘리지 않도록 개선
  - Fixed layout overlap issues in profile edit and terms screens
  - Improved text display to prevent truncation

- **날짜/시간 포맷 개선** / Improved Date/Time Formatting
  - 로케일에 맞는 날짜 및 시간 표시 형식 적용
  - Locale-aware date and time formatting

#### 📱 시스템 안내 메시지 번역 / System Guide Message Translation
- 시스템 안내 메시지가 사용자 언어에 맞게 자동 번역됩니다
- System guide messages are automatically translated to match user's language

#### 🎯 버그 수정 / Bug Fixes
- 언어 설정 변경 시 즉시 반영되도록 개선
- Improved language setting changes to take effect immediately
- 상태 텍스트("active", "on progress" 등) 번역 추가
- Added translation for status texts ("active", "on progress", etc.)

---

### 기술적 개선 사항 / Technical Improvements
- Flutter Localization (l10n) 완전 구현
- Google Translate API를 통한 다국어 채팅 지원
- 레이아웃 반응형 개선

---

### 지원 언어 / Supported Languages
- 한국어 (Korean)
- 영어 (English)

### 번역 지원 언어 / Translation Supported Languages
- 한국어 (Korean)
- 영어 (English)
- 중국어 (Chinese)
- 스페인어 (Spanish)

