# Remote Notification (원격 푸시 알림)

- Remote Notification은 외부 서버에서 Apple Push Notification service(APNs)를 통해 iOS 기기로 전송하는 알림 
- 앱이 실행 중이지 않더라도 사용자에게 정보를 전달할 수 있어, 사용자 재방문 유도나 실시간 알림 전송에 효과적

### 동작 흐름

#### 디바이스 등록
1. 앱이 사용자에게 알림 권한 요청
2. 시스템이 APNs로부터 디바이스 토큰 발급하여 앱으로 전달
3. 앱의 디바이스 토큰을 앱 서버(푸시 서버)로 전달

#### 메세지 전송
4. 앱 서버가 APNs에 알림 전송 요청
5. APNs가 대상 디바이스로 알림 전달

### 페이로드 예시
```json
{
  "aps": {
    "alert": {
      "title": "알림 제목",
      "body": "알림 내용"
    },
    "sound": "default",
    "badge": 1
  }
}
```
# APNs (Apple Push Notification service)
- APNs는 Apple이 제공하는 글로벌 푸시 알림 전송 시스템
- iOS, iPadOS, macOS 등의 Apple 디바이스에 보안적으로 알림을 전달
- TLS를 통한 안전한 통신
    - TLS(Transport Layer Security)는 온라인 네트워크에서 데이터를 안전하게 주고받기 위한 암호화 프로토콜
    - 컴퓨터 네트워크에서 통신 보안을 제공하기 위해 설계되었으며, TCP/IP 네트워크를 사용하는 통신에 적용
- 낮은 지연 시간의 글로벌 분산 시스템
- 디바이스 토큰을 기반으로 개별 사용자 식별

## APNs 인증 키 (Authentication Key)
- APNs를 사용하기 위해선 Apple Developer 계정에서 인증 키(키 파일: .p8)를 생성해야 함
- 해당 키를 통해 서버는 APNs와 JWT 기반 인증을 사용해 안전하게 통신할 수 있음

#### 구성 요소
- Key ID (키 식별자)
- Team ID (Apple Developer 팀 ID)
- Auth Key (.p8 파일)

## 서버 인증 방식 (JWT 기반)
- APNs는 전통적인 인증서 방식 외에도 JWT(Json Web Token) 기반 인증을 지원
- Auth Key 방식은 인증서보다 설정이 간단하고 관리가 편리해 선호

```txt
Authorization: bearer <JWT>
apns-topic: com.example.app
```
인증 키는 민감한 정보로 외부에 노출되지 않도록 주의

---

# FCM (Firebase Cloud Messaging)
- FCM은 Google에서 제공하는 크로스 플랫폼 푸시 알림 서비스로, iOS, Android, Web에 푸시 메시지를 전송할 수 있음
- iOS에서는 **FCM이 내부적으로 APNs를 사용**하여 메시지를 전달함
- 개발자는 Firebase를 통해 푸시 전송 로직을 단순화하고, **알림 분석 및 타겟팅 기능을 함께 활용**할 수 있음

### 동작 방식
1. 앱이 Firebase SDK를 통해 FCM 등록 요청
2. Firebase SDK가 APNs로부터 디바이스 토큰을 받아 FCM 토큰과 매핑
3. Firebase가 자체 푸시 서버 역할 수행
4. 개발자는 Firebase Console 또는 서버에서 FCM 토큰으로 메시지 전송
5. FCM이 내부적으로 APNs를 호출해 디바이스로 메시지 전달

---

### APNs vs FCM 비교

| 항목 | APNs | FCM (iOS 기준) |
|------|------|----------------|
| 제공자 | Apple | Google (APNs 위에서 작동) |
| 플랫폼 | iOS, macOS 등 Apple 생태계 | iOS, Android, Web 등 다중 플랫폼 |
| 인증 방식 | 인증서 / 인증 키 (.p8) + JWT | Firebase 프로젝트 기반 인증 |
| 메시지 전송 | 직접 HTTP/2 요청 필요 | Firebase SDK or REST API 사용 |
| 고급 기능 | 없음 (순수 전송) | 타겟팅, A/B 테스트, 알림 분석, 주제 구독 등 |
| 설정 복잡도 | 높음 | 상대적으로 간단 |

---

### FCM 사용 시 주의사항

- iOS에서는 **FCM이 내부적으로 APNs를 사용**하므로, Apple Developer 계정에서 **APNs 인증 키(.p8)**를 Firebase console 내에 설정해야 함
- **Firebase 프로젝트에 APNs 인증 키 등록 필수**
- iOS 앱에 Firebase SDK 설치 필요 (`FirebaseMessaging`, `FirebaseCore`)
- 사용자의 **FCM 토큰 관리(등록/삭제)**는 서버에서 수행해야 하며, 로그아웃 시에도 삭제 권장

---

### 요약
- **APNs**는 iOS에 푸시를 전송하기 위한 **기본 인프라**  
- **FCM**은 APNs를 기반으로 작동하면서 **추가 기능(Firebase 콘솔, 통계, 타겟팅 등)**을 제공하는 **추상화된 푸시 플랫폼**


# 참고 사항
- APNs는 푸시 전송 성공 여부를 즉시 보장하지 않음 (전송 실패 시 응답 확인 필수)
- 디바이스 토큰은 앱 삭제 및 재설치 시 변경될 수 있음
- 알림 권한은 사용자 설정에서 거부될 수 있으므로 상태 확인 필요
