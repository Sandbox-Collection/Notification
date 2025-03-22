import FirebaseCore
import FirebaseMessaging
import SwiftUI
import UserNotifications

@main
struct NotificationApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

@MainActor
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
        return true
    }
}

extension AppDelegate {
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any]
    ) async -> UIBackgroundFetchResult {
        /*
         Silent Push를 무시하는 경우
         - 배터리 절약 모드 (Low Power Mode)
         - 앱이 최근에 사용되지 않음 (Background App Refresh 비활성화 포함)
         - 너무 자주 Silent Push 전송함 (throttling 발생)
         - 전송 우선순위가 낮거나 payload가 빈약함
         
         시스템 처리 방식
         - iOS는 Silent Push를 "낮은 우선순위"로 취급

         다음 상황에서 처리될 수 있음:
         - 앱이 백그라운드 상태
         - 앱이 중단되지 않은 상태

         다음 상황에서는 처리되지 않음:
         1.앱이 강제 종료(터미네이트) 되었을 경우
            → Silent Push가 도착해도 시스템이 무조건 무시함
            → 아예 앱을 깨우지 않음, didReceiveRemoteNotification 호출되지 않음
         2. 기존에 받은 Silent Push가 대기 중일 때 새로 도착한 푸시는 이전 것을 덮어씀
         3.Silent Push가 여러 개 오면 iOS가 throttling함 (1시간에 2~3회 권장)
         https://developer.apple.com/documentation/usernotifications/pushing-background-updates-to-your-app
         따라서, 앱이 죽었을 때, NotificationServiceExtension로 일반 push를 날려야 함
         */
        print("Silent Push received with userInfo: \(userInfo)")
        if let data = userInfo["data"] as? [String: Any],
           let value = data["key"] as? String {
            print("key: \(value)")
            return .newData
        }
        return .noData
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // MARK: - 앱 실행 중일때만 푸시 알림이 도착하면 willPresent 메서드 호출
    /*
     메서드를 통해 어떻게 보여줄지 선택할 수 있음
     - .list: 알림 센터에 표시됨
     - .banner: 상단 배너로 표시됨
     - .badge: 앱 아이콘에 빨간 숫자 뱃지 표시
     - .sound: 소리 재생
     */
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.list, .banner, .badge, .sound]
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Token: \(tokenString)")
    }
}

extension AppDelegate: MessagingDelegate {
    // MARK: - FCM 토큰 갱신 됐을 때
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken else { return }
        print("FCM 등록 토큰 갱신: \(fcmToken)")
    }
}
