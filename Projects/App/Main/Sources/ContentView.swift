import FirebaseMessaging
import SwiftUI

public struct ContentView: View {
    @StateObject private var viewModel: ContentViewModel = .init()

    public var body: some View {
        Button {
            viewModel.buttonTapped()
        } label: {
            Text("Hello, World!")
                .padding()
        }
    }
}

final class ContentViewModel: ObservableObject {
    func buttonTapped() {
        Task {
            await requestNotificationAuth()
            await requestFCMToken()
        }
    }
    
    func requestNotificationAuth() async {
        do {
            // 권한 요청
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            let isAuthorized = try await UNUserNotificationCenter.current().requestAuthorization(options: authOptions)
            print(isAuthorized)
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    // FCM 토큰은 APNs 토큰을 받은 다음 요청할 수 있기 때문에
    // registerForRemoteNotifications가 먼저 호출되어 있는 상태여야 함
    func requestFCMToken() async {
        do {
            // FCM 현재 등록 토큰 확인
            let token = try await Messaging.messaging().token()
            print("token: \(token)")
        }
        catch {
            print("error: \(error.localizedDescription)")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
