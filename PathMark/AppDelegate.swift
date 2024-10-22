//
//  AppDelegate.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 17/07/23.
//
// 0=send, 1=accepted, 2=PickupArrived, 3=RideStart,4=dropStatus,5=PaymentDone,6=Driver Not available

import UIKit
import Firebase

import UserNotifications
import GoogleMaps
import GooglePlaces

import GoogleSignIn
import FacebookCore
import AuthenticationServices
import SwiftyJSON

@available(iOS 14.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    var dict:NSDictionary!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // firebase
        FirebaseApp.configure()
        
        GMSPlacesClient.provideAPIKey(GOOGLE_MAP_API)
        GMSServices.provideAPIKey(GOOGLE_MAP_API)
        
         

        
        // facebook
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        // Settings.shared.appID = "fb1035864164317944"
        // Settings.shared.displayName = "Zarib"
        
        // google : login
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
                
                let token = AccessToken.current?.tokenString
                print(token as Any)
                if (token != nil) {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
          
                    let destinationController = storyboard.instantiateViewController(withIdentifier:"dashboard_id") as? dashboard
                        
                    let frontNavigationController = UINavigationController(rootViewController: destinationController!)

                    let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC

                    let mainRevealController = SWRevealViewController()

                    mainRevealController.rearViewController = rearViewController
                    mainRevealController.frontViewController = frontNavigationController
                    
                    DispatchQueue.main.async {
                        UIApplication.shared.keyWindow?.rootViewController = mainRevealController
                    }
                    
                    self.window?.makeKeyAndVisible()
                }
            } else {
                // Show the app's signed-in state.
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
      
                let destinationController = storyboard.instantiateViewController(withIdentifier:"dashboard_id") as? dashboard
                    
                let frontNavigationController = UINavigationController(rootViewController: destinationController!)

                let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC

                let mainRevealController = SWRevealViewController()

                mainRevealController.rearViewController = rearViewController
                mainRevealController.frontViewController = frontNavigationController
                
                DispatchQueue.main.async {
                    UIApplication.shared.keyWindow?.rootViewController = mainRevealController
                }
                
                self.window?.makeKeyAndVisible()
            }
        }
        
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//         appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
//             switch credentialState {
//             case .authorized:
//                 // The Apple ID credential is valid.
//                 break
//             case .revoked:
//                 // The Apple ID credential is revoked.
//                 break
//             case .notFound:
//                 // No credential was found, so show the sign-in UI.
//                 break
//             default:
//                 break
//             }
//         }
        
        // notification
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        self.fetchDeviceToken()
        
        return true
    }
    
    
   
    
    // MARK:- FIREBASE NOTIFICATION -
    @objc func fetchDeviceToken() {
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                // self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
                
                let defaults = UserDefaults.standard
                defaults.set("\(token)", forKey: "key_my_device_token")
                
                
            }
        }
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error = ",error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    /*func registerForRemoteNotification() {
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
        UIApplication.shared.registerForRemoteNotifications()
    }*/

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        let defaults = UserDefaults.standard
        // deviceToken
//                defaults.set("\(token)", forKey: "deviceToken")
        defaults.set("\(fcmToken!)", forKey: "key_my_device_token")
        
         print("\(fcmToken!)")
        
        
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
    
    // MARK:- WHEN APP IS IN FOREGROUND - ( after click popup ) -
    // @available(iOS 13.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //print("User Info = ",notification.request.content.userInfo)
        // completionHandler([.alert, .badge, .sound])
         completionHandler([.alert, .badge, .sound,.banner])
        
        // print("User Info dishu = ",notification.request.content.userInfo)
        
        let dictFromNotification = notification.request.content.userInfo
        
        if let jsonString = dictFromNotification[AnyHashable("data")] as? String {
            // Convert the JSON string to Data
            if let jsonData = jsonString.data(using: .utf8) {
                do {
                    // Deserialize JSON data to NSDictionary
                    if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                        // Successfully converted to NSDictionary
                        print("Data dictionary: \(jsonDict)")
                        print(type(of: jsonDict))
                        
                        dict = jsonDict as NSDictionary
                        print(self.dict as Any)
                        
                        
                        // Handle optional values safely
                        
                    } else {
                        print("Failed to convert JSON to NSDictionary")
                    }
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
            } else {
                print("Failed to convert JSON string to Data")
            }
        } else {
            print("No valid JSON string found for 'data' key")
        }
       
        
        handleNotification()
        
    }
    
    func handleNotification() {
        print(dict as Any)
        
        if (dict["type"] as! String) == "confirm" {
           
            if let bookingTime = dict["bookingTime"] as? String {
                print("Booking Time: \(bookingTime)")
                self.handleConfirmNotificationTimeNotNil()
            } else {
                print("Booking Time is nil")
                self.handleConfirmNotificationTimeNil()
            }
            
        } else if (dict["type"] as! String) == "arrived" {
            self.handleNotificationWhenDriverArrived()
        } else if (dict["type"] as! String) == "ridestart" {
            self.handleNotificationWhenDriverRideStart()
        } else if (dict["type"] as! String) == "rideend" {
            self.handleNotificationWhenDriverRideEnd()
        } else if (dict["type"] as! String) == "cancel" {
            self.handleNotificationWhenDriverCancel()
        } else if (dict["type"] as! String) == "Chat" {
            self.handleNotificationWhenDriverChat()
        }/* else if (dict["type"] as! String) == "Payment" {
            self.handleNotificationWhenDriverChat()
        }*/
    
    }
    
    @objc func handleNotificationWhenDriverRideStart() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let destinationController = storyboard.instantiateViewController(withIdentifier:"ride_status_id") as? ride_status
        
        destinationController?.dict_get_all_data_from_notification = dict as NSDictionary
        
        let frontNavigationController = UINavigationController(rootViewController: destinationController!)
        
        let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC
        
        let mainRevealController = SWRevealViewController()
        
        mainRevealController.rearViewController = rearViewController
        mainRevealController.frontViewController = frontNavigationController
        
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController = mainRevealController
        }
        
        window?.makeKeyAndVisible()
    }
    
    @objc func handleNotificationWhenDriverRideEnd() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let destinationController = storyboard.instantiateViewController(withIdentifier:"ride_status_id") as? ride_status
        
        destinationController?.dict_get_all_data_from_notification = dict as NSDictionary
        
        let frontNavigationController = UINavigationController(rootViewController: destinationController!)
        
        let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC
        
        let mainRevealController = SWRevealViewController()
        
        mainRevealController.rearViewController = rearViewController
        mainRevealController.frontViewController = frontNavigationController
        
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController = mainRevealController
        }
        
        window?.makeKeyAndVisible()
    }
    
    @objc func handleNotificationWhenDriverCancel() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let destinationController = storyboard.instantiateViewController(withIdentifier:"cancel_your_ride_id") as? cancel_your_ride
        destinationController?.dict_get_data_from_notification = dict as NSDictionary
        let frontNavigationController = UINavigationController(rootViewController: destinationController!)
        
        let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC
        
        let mainRevealController = SWRevealViewController()
        
        mainRevealController.rearViewController = rearViewController
        mainRevealController.frontViewController = frontNavigationController
        
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController = mainRevealController
        }
        
        window?.makeKeyAndVisible()
    }
    
    @objc func handleNotificationWhenDriverChat() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let destinationController = storyboard.instantiateViewController(withIdentifier:"BooCheckChatId") as? BooCheckChat
        
        destinationController?.str_back_home = "home"
        destinationController?.str_booking_id = "\(dict["bookingId"]!)"
        destinationController?.get_all_data = dict as NSDictionary
        let frontNavigationController = UINavigationController(rootViewController: destinationController!)
        
        let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC
        
        let mainRevealController = SWRevealViewController()
        
        mainRevealController.rearViewController = rearViewController
        mainRevealController.frontViewController = frontNavigationController
        
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController = mainRevealController
        }
        
        window?.makeKeyAndVisible()
    }
    
    @objc func handleNotificationWhenDriverArrived() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let destinationController = storyboard.instantiateViewController(withIdentifier:"ride_status_id") as? ride_status
        
        destinationController?.dict_get_all_data_from_notification = dict as NSDictionary
        
        let frontNavigationController = UINavigationController(rootViewController: destinationController!)
        
        let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC
        
        let mainRevealController = SWRevealViewController()
        
        mainRevealController.rearViewController = rearViewController
        mainRevealController.frontViewController = frontNavigationController
        
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController = mainRevealController
        }
        
        window?.makeKeyAndVisible()
    }
    
    @objc func handleConfirmNotificationTimeNotNil() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let destinationController = storyboard.instantiateViewController(withIdentifier:"schedule_ride_details_id") as? schedule_ride_details
        
        destinationController?.dict_get_booking_details = dict as NSDictionary
        destinationController?.str_from_history = "no"
        let frontNavigationController = UINavigationController(rootViewController: destinationController!)
        
        let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC
        
        let mainRevealController = SWRevealViewController()
        
        mainRevealController.rearViewController = rearViewController
        mainRevealController.frontViewController = frontNavigationController
        
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController = mainRevealController
        }
        
        window?.makeKeyAndVisible()
    }
    
    @objc func handleConfirmNotificationTimeNil() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let destinationController = storyboard.instantiateViewController(withIdentifier:"ride_status_id") as? ride_status
        
        destinationController?.dict_get_all_data_from_notification = dict
        destinationController?.str_from_history = "no"
        
        let frontNavigationController = UINavigationController(rootViewController: destinationController!)
        
        let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC
        
        let mainRevealController = SWRevealViewController()
        
        mainRevealController.rearViewController = rearViewController
        mainRevealController.frontViewController = frontNavigationController
        
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController = mainRevealController
        }
        
        window?.makeKeyAndVisible()
    }
    
    @objc func pushWithData() {
        
    }

    
    /*@objc func confirmNotificationSetup() {
        if (dict["type"] as! String) == "confirm" { // when driver confirm booking
            
            // bookingTime
            if (dict["bookingTime"] != nil) {
                // open schedule screen
                print(dict as Any)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
      
                let destinationController = storyboard.instantiateViewController(withIdentifier:"schedule_ride_details_id") as? schedule_ride_details
                    
                destinationController?.dict_get_booking_details = dict as NSDictionary
                destinationController?.str_from_history = "no"
                let frontNavigationController = UINavigationController(rootViewController: destinationController!)

                let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC

                let mainRevealController = SWRevealViewController()

                mainRevealController.rearViewController = rearViewController
                mainRevealController.frontViewController = frontNavigationController
                
                DispatchQueue.main.async {
                    UIApplication.shared.keyWindow?.rootViewController = mainRevealController
                }
                
                window?.makeKeyAndVisible()
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
      
                let destinationController = storyboard.instantiateViewController(withIdentifier:"ride_status_id") as? ride_status
                    
                destinationController?.dict_get_all_data_from_notification = dict as NSDictionary
                destinationController?.str_from_history = "no"
                
                let frontNavigationController = UINavigationController(rootViewController: destinationController!)

                let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC

                let mainRevealController = SWRevealViewController()

                mainRevealController.rearViewController = rearViewController
                mainRevealController.frontViewController = frontNavigationController
                
                DispatchQueue.main.async {
                    UIApplication.shared.keyWindow?.rootViewController = mainRevealController
                }
                
                window?.makeKeyAndVisible()
            }
            
            
            
            
            
        }
    }*/
    
    
    
    // MARK:- WHEN APP IS IN BACKGROUND - ( after click popup ) -
    // @available(iOS 13.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User Info = ",response.notification.request.content.userInfo)
        
        let dictFromNotification = response.notification.request.content.userInfo
        
        if let jsonString = dictFromNotification[AnyHashable("data")] as? String {
            // Convert the JSON string to Data
            if let jsonData = jsonString.data(using: .utf8) {
                do {
                    // Deserialize JSON data to NSDictionary
                    if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                        // Successfully converted to NSDictionary
                        print("Data dictionary: \(jsonDict)")
                        print(type(of: jsonDict))
                        
                        dict = jsonDict as NSDictionary
                        print(self.dict as Any)
                        
                        // Handle optional values safely
                        
                    } else {
                        print("Failed to convert JSON to NSDictionary")
                    }
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
            } else {
                print("Failed to convert JSON string to Data")
            }
        } else {
            print("No valid JSON string found for 'data' key")
        }
       
        
        handleNotification()
        
        
        // if user send request
        /*if (dict["type"] == nil) {
            print("NOTIFICATION FROM SOMEWHERE ELSE")
        } else if (dict["type"] as! String) == "confirm" { // when driver confirm booking
            
            // bookingTime
            if (dict["bookingTime"] != nil) {
                // open schedule screen
                print(dict as Any)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
      
                let destinationController = storyboard.instantiateViewController(withIdentifier:"schedule_ride_details_id") as? schedule_ride_details
                    
                destinationController?.dict_get_booking_details = dict as NSDictionary
                destinationController?.str_from_history = "no"
                let frontNavigationController = UINavigationController(rootViewController: destinationController!)

                let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC

                let mainRevealController = SWRevealViewController()

                mainRevealController.rearViewController = rearViewController
                mainRevealController.frontViewController = frontNavigationController
                
                DispatchQueue.main.async {
                    UIApplication.shared.keyWindow?.rootViewController = mainRevealController
                }
                
                window?.makeKeyAndVisible()
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
      
                let destinationController = storyboard.instantiateViewController(withIdentifier:"ride_status_id") as? ride_status
                    
                destinationController?.dict_get_all_data_from_notification = dict as NSDictionary
                destinationController?.str_from_history = "no"
                
                let frontNavigationController = UINavigationController(rootViewController: destinationController!)

                let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC

                let mainRevealController = SWRevealViewController()

                mainRevealController.rearViewController = rearViewController
                mainRevealController.frontViewController = frontNavigationController
                
                DispatchQueue.main.async {
                    UIApplication.shared.keyWindow?.rootViewController = mainRevealController
                }
                
                window?.makeKeyAndVisible()
            }
            
            
            
            
            
        }  else if (dict["type"] as! String) == "arrived" { // when driver arrived at your location
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
  
            let destinationController = storyboard.instantiateViewController(withIdentifier:"ride_status_id") as? ride_status
                
            destinationController?.dict_get_all_data_from_notification = dict as NSDictionary
                
            let frontNavigationController = UINavigationController(rootViewController: destinationController!)

            let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC

            let mainRevealController = SWRevealViewController()

            mainRevealController.rearViewController = rearViewController
            mainRevealController.frontViewController = frontNavigationController
            
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.rootViewController = mainRevealController
            }
            
            window?.makeKeyAndVisible()
            
        }  else if (dict["type"] as! String) == "ridestart" { // when driver start your ride
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
  
            let destinationController = storyboard.instantiateViewController(withIdentifier:"ride_status_id") as? ride_status
                
            destinationController?.dict_get_all_data_from_notification = dict as NSDictionary
                
            let frontNavigationController = UINavigationController(rootViewController: destinationController!)

            let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC

            let mainRevealController = SWRevealViewController()

            mainRevealController.rearViewController = rearViewController
            mainRevealController.frontViewController = frontNavigationController
            
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.rootViewController = mainRevealController
            }
            
            window?.makeKeyAndVisible()
            
        }  else if (dict["type"] as! String) == "rideend" { // when driver end your ride
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
  
            let destinationController = storyboard.instantiateViewController(withIdentifier:"ride_status_id") as? ride_status
                
            destinationController?.dict_get_all_data_from_notification = dict as NSDictionary
                
            let frontNavigationController = UINavigationController(rootViewController: destinationController!)

            let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC

            let mainRevealController = SWRevealViewController()

            mainRevealController.rearViewController = rearViewController
            mainRevealController.frontViewController = frontNavigationController
            
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.rootViewController = mainRevealController
            }
            
            window?.makeKeyAndVisible()
            
        }
        else if (dict["type"] as! String) == "cancel" { // when driver cancel your ride
          
          let storyboard = UIStoryboard(name: "Main", bundle: nil)

          let destinationController = storyboard.instantiateViewController(withIdentifier:"cancel_your_ride_id") as? cancel_your_ride
            destinationController?.dict_get_data_from_notification = dict as NSDictionary
          let frontNavigationController = UINavigationController(rootViewController: destinationController!)

          let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC

          let mainRevealController = SWRevealViewController()

          mainRevealController.rearViewController = rearViewController
          mainRevealController.frontViewController = frontNavigationController
          
          DispatchQueue.main.async {
              UIApplication.shared.keyWindow?.rootViewController = mainRevealController
          }
          
          window?.makeKeyAndVisible()
          
      }  else if (dict["type"] as! String) == "Chat" {
          
          let storyboard = UIStoryboard(name: "Main", bundle: nil)

          let destinationController = storyboard.instantiateViewController(withIdentifier:"BooCheckChatId") as? BooCheckChat
          
          destinationController?.str_back_home = "home"
          destinationController?.str_booking_id = "\(dict["bookingId"]!)"
          destinationController?.get_all_data = dict as NSDictionary
          let frontNavigationController = UINavigationController(rootViewController: destinationController!)

          let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC

          let mainRevealController = SWRevealViewController()

          mainRevealController.rearViewController = rearViewController
          mainRevealController.frontViewController = frontNavigationController
          
          DispatchQueue.main.async {
              UIApplication.shared.keyWindow?.rootViewController = mainRevealController
          }
          
          window?.makeKeyAndVisible()
          
      }
        */
    }
   
    // MARK: UISceneSession Lifecycle

    
    
        
    
    
    
    
    
    
    
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (GIDSignIn.sharedInstance.handle(url)) {
                return true
            } else if (ApplicationDelegate.shared.application(app, open: url, options: options)) {
                return true
            } else {
                if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                   let queryItems = components.queryItems {
                    for item in queryItems {
                        if item.name == "payment_status" && item.value == "success" {
                            // Payment was successful
                            if let transactionID = queryItems.first(where: { $0.name == "transaction_id" })?.value {
                                // Update UI, notify user, etc.
                                print("Payment successful. Transaction ID: \(transactionID)")
                            }
                            break
                        }
                    }
                }
                return true
            }

            return false
        }

}

/*
 func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
         // Handle the redirect URL or deep link here
         if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems {
             for item in queryItems {
                 if item.name == "payment_status" && item.value == "success" {
                     // Payment was successful
                     if let transactionID = queryItems.first(where: { $0.name == "transaction_id" })?.value {
                         // Update UI, notify user, etc.
                         print("Payment successful. Transaction ID: \(transactionID)")
                     }
                     break
                 }
             }
         }
         return true
     }
 */
