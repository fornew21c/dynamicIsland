

import SwiftUI
import Foundation

@main
struct GroceryDeliveryApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    let center = UNUserNotificationCenter.current()
    
    init() {
        
    }

    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.1, *) {
                ContentView().onOpenURL { url in
                    guard let url = URLComponents(string: url.absoluteString) else { return }
                    if let contacNumber = url.queryItems?.first(where: { $0.name == "contacNumber" })?.value {
                       
                        let tel = "tel:\(contacNumber)"
                        if let url = URL(string: tel),
                           UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            }
            
        }
        
    }
    
    //*** Implement App delegate ***//
    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            registerForNotification()
            return true
        }
        
        func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
            print(error.localizedDescription)
        }
        
        func registerForNotification() {
            UIApplication.shared.registerForRemoteNotifications()
            let center : UNUserNotificationCenter = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.sound , .alert , .badge ], completionHandler: { (granted, error) in
                if ((error != nil)) { UIApplication.shared.registerForRemoteNotifications() }
                else {
                    
                }
            })
        }
        
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            
            let tokenParts = deviceToken.map { data -> String in
                return String(format: "%02.2hhx", data)
            }
            
            let token = tokenParts.joined()
            
            print("device token: \(token)")
            // process token
        }
    }
    
}


