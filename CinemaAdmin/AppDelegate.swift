
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("🔵 AppDelegate: didFinishLaunchingWithOptions 開始")
        
        // 使用 GoogleSheetsService 作為 ticketService
        let ticketService = GoogleSheetsService()
        
        // 如果是 iOS 13 以前的版本，直接設置 window
        if #available(iOS 13.0, *) {
            print("🔵 AppDelegate: iOS 13+ 路徑")
        } else {
            print("🔵 AppDelegate: iOS 13 以下路徑")
            window = UIWindow(frame: UIScreen.main.bounds)
            
            // 使用 ticketService 初始化 CinemaAdminViewController
            let cinemaAdminVC = CinemaAdminViewController(ticketService: ticketService)
            let navigationController = UINavigationController(rootViewController: cinemaAdminVC)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
        print("✅ AppDelegate: didFinishLaunchingWithOptions 完成")
        return true
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print("🔵 AppDelegate: configurationForConnecting 開始")
        let sceneConfig = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        print("✅ AppDelegate: configurationForConnecting 完成")
        return sceneConfig
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print("🔵 AppDelegate: didDiscardSceneSessions")
    }
}

