import UIKit
import UserNotifications
import FacebookCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // MARK: - Scene Setup
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {

        guard let _ = (scene as? UIWindowScene) else { return }

        /*
         IMPORTANT NOTE:
         Notification handling (foreground / background)
         AppDelegate me hoti hai.

         SceneDelegate me notification ke liye
         KISI EXTRA CODE ki zarurat nahi hoti.
        */
    }

    // MARK: - Scene Lifecycle (Safe to keep empty)
    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }

    // MARK: - URL / Deep Link Handling (Facebook / Google etc.)
    func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        guard let url = URLContexts.first?.url else { return }

        // Facebook / deep link support
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            options: [:]
        )
    }
}

