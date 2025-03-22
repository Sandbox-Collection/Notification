import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        print("NotificationService didReceive")
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // 특정 키("HIDE")가 포함된 경우 알림 숨기기
            if let userInfo = request.content.userInfo as? [String: Any] {
                if let aps = userInfo["aps"] as? [String: Any] {
                    if let alert = userInfo["alert"] as? [String: Any] {
                        let title = alert["title"] as? String ?? ""
                        let body = alert["body"] as? String ?? ""
                        print("title: \(title)")
                        print("body: \(body)")
                        return
                    }
                }
                if let hideFlag = userInfo["HIDE"] as? String,
                   hideFlag == "true" {
                    contentHandler(UNNotificationContent()) // 빈 알림 전달 (숨김)
                    return
                }
            }
            
            contentHandler(bestAttemptContent) // 기본 알림 유지
        }
    }
    
    // 시스템이 할당한 처리 시간(약 30초)이 만료되기 직전에 호출
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler {
            contentHandler(UNNotificationContent()) // 알림 숨기기
        }
    }
}

/*
 extension에서 slient Push를 받을 수 없음
 didReceiveRemoteNotification에서 처리
 Slient Push
 {
     "aps": {
         "content-available": 1,
         "apns-push-type": "background",
         "apns-priority": 5,
     },
     "data": {
         "title": "hello",
         "body": "??"
     },
 }
 */

/*
 mutable-Push
{
  "aps": {
    "alert": {
      "title": "Hi",
      "body": "This is an alert"
    },
    "sound": "default",
    // 이걸 포함해야지 extension에서 감지 가능
    "mutable-content": 1
  },
  "data": {
    "userId": "123"
  }
}
*/
