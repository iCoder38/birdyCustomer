//
//  login.swift
//  PathMark
//
//  Created by Dishant Rajput on 10/07/23.
//

import UIKit
//import CryptoSwift
//import JWT
import CommonCrypto
// import JWTDecode

// MARK:- LOCATION -
import CoreLocation
import Alamofire
import GoogleSignIn

import FacebookCore
import FacebookLogin

// apple
import AuthenticationServices

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

class login: UIViewController , UITextFieldDelegate , CLLocationManagerDelegate, ASAuthorizationControllerDelegate {
    
    
    var window: UIWindow?
    

    let locationManager = CLLocationManager()
    
    // MARK:- SAVE LOCATION STRING -
    var strSaveLatitude:String!
    var strSaveLongitude:String!
    var strSaveCountryName:String!
    var strSaveLocalAddress:String!
    var strSaveLocality:String!
    var strSaveLocalAddressMini:String!
    var strSaveStateName:String!
    var strSaveZipcodeName:String!
    
    var strPhoneNumber:String!
    
    @IBOutlet weak var view_navigation_bar:UIView! {
        didSet {
            view_navigation_bar.applyGradient()
        }
    }
    
    @IBOutlet weak var view_navigation_title:UILabel! {
        didSet {
            view_navigation_title.text = "Login"
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var tbleView:UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.reloadData()
            tbleView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var btn_back:UIButton!
    
    var dict:NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btn_back.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
         self.view.backgroundColor = viewBackgroundColor
        
//        let defaults = UserDefaults.standard
//        defaults.setValue("", forKey: str_save_login_user_data)
//        defaults.setValue("", forKey: str_save_last_api_token)
        
        
//        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "verify_phone_number_id") as? verify_phone_number
//        self.navigationController?.pushViewController(push!, animated: true)

        // set language
          // UserDefaults.standard.set("bg", forKey: str_language_convert)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
         
        self.language_convert()
        
    }
    
   
    
    @objc func language_convert() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! login_table_cell
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                cell.btnSignIn.setTitle("Sign In", for: .normal)
                cell.lbl_remember_me.text = "Remember me"
                // cell.lbl_login_with_social_media.text = "Login with Social media"
                // cell.btnForgotPassword.setTitle("Forgot password ? - Click here", for: .normal)
                cell.btnDontHaveAnAccount.setTitle("Not a member? Register Now", for: .normal)
                cell.lbl_login_to_continue.text = "Login to Continue"
                
            } else {
                cell.btnSignIn.setTitle("সাইন ইন করুন", for: .normal)
                cell.lbl_remember_me.text = "আমাকে মনে কর"
                cell.lbl_login_with_social_media.text = "সোশ্যাল মিডিয়া দিয়ে লগইন করুন"
                // cell.btnForgotPassword.setTitle("পাসওয়ার্ড ভুলে গেছেন? - এখানে ক্লিক করুন", for: .normal)
                cell.btnDontHaveAnAccount.setTitle("সদস্যা নন? এখনই নিবন্ধন করুন", for: .normal)
                cell.lbl_login_to_continue.text = "চালিয়ে যেতে লগইন করুন"
            }
            
        } else {
            print("=============================")
            print("LOGIN : Select language error")
            print("=============================")
            UserDefaults.standard.set("en", forKey: str_language_convert)
            self.tbleView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.iAmHereForLocationPermission()
            }
        }
        
        
    }
    
    @objc func signInViaGoogle() {
        // let gIdConfiguration = GIDConfiguration(clientID: "clientID", serverClientID: "serverClientID")
         let gIdConfiguration  = GIDConfiguration(clientID: "750959835757-m69poiuvdmji91uqku55em8o3cljarke.apps.googleusercontent.com")
        // ledt gIdConfiguration  = GIDConfiguration(clientID: "com.googleusercontent.apps.750959835757-m69poiuvdmji91uqku55em8o3cljarke")
        
        GIDSignIn.sharedInstance.configuration = gIdConfiguration
//
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            guard let signInResult = signInResult else { return }

            let user = signInResult.user

            let emailAddress = user.profile?.email

            let fullName = user.profile?.name
            let givenName = user.profile?.givenName
            let familyName = user.profile?.familyName
            let social_id = user.userID

            let profilePicUrl = user.profile?.imageURL(withDimension: 320)
            
            print(emailAddress as Any)
            print(fullName as Any)
            print(givenName as Any)
            print(familyName as Any)
            print(profilePicUrl as Any)
            
            
            
            self.socia_login_wb(name: fullName!, social_id: "\(social_id!)", email: emailAddress!, profile_picture: "\(profilePicUrl!)")
        }
        
        
    }
    
    @objc func socia_login_wb(name:String,social_id:String,email:String,profile_picture:String) {
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tbleView.cellForRow(at: indexPath) as! login_table_cell
        
        self.show_loading_UI()
        
        var parameters:Dictionary<AnyHashable, Any>!

            parameters = [
                "action"        :   "socialLoginAction",
                "email"         :   String(email),
                "socialId"      :   String(social_id),
                "fullName"      :   String(name),
                "socialType"    :   String("google"),
                "device"        :   String("iOS"),
                "deviceToken"   :   String(""),
                "image"         :   String(profile_picture)
            ]
//        }
        
        print("parameters-------\(String(describing: parameters))")
        
        AF.request(application_base_url, method: .post, parameters: parameters as? Parameters).responseJSON {
            response in
            
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    
                    let JSON = data as! NSDictionary
                    print(JSON)
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"] as? String
                    
                    if strSuccess.lowercased() == "success" {
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        
                        
                        // save token
                        // print("\(JSON["AuthToken"]!)")
                        // print(type(of: JSON["AuthToken"]))
                        
                        /*let str_token = (JSON["AuthToken"] as! String)
                        UserDefaults.standard.set("", forKey: str_save_last_api_token)
                        UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)*/
                        
                        // let indexPath = IndexPath.init(row: 0, section: 0)
                        // let cell = self.tbleView.cellForRow(at: indexPath) as! login_table_cell
                        
                        // save email and pass
                        // email
                        self.save_email(email: String(email))
                        //
                        
                        self.hide_loading_UI()
                        
                        if (dict["contactNumber"] as! String) == "" {
                            // save number
                            
                            //1. Create the alert controller.
                            let alert = UIAlertController(title: "Phone number", message: "Enter your phone number", preferredStyle: .alert)

                            //2. Add the text field. You can configure it however you need.
                            alert.addTextField { (textField) in
                                textField.delegate = self
                                textField.text = ""
                                textField.keyboardType = .numberPad
                            }

                            // 3. Grab the value from the text field, and print it when the user clicks OK.
                            alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { [weak alert] (_) in
                                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                                // print("Text field: \(textField!.text)")
                                
                                self.strPhoneNumber = String(textField!.text!)
                                self.update_number_WB(str_show_loader: "yes")
                                //
                            }))

                            // 4. Present the alert.
                            self.present(alert, animated: true, completion: nil)
                            
                            
                        } else {
                            self.hide_loading_UI()
                            let defaults = UserDefaults.standard
                            defaults.setValue(dict, forKey: str_save_login_user_data)
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
                        }
                        
                        
                    }
                    else {
                        
                        self.hide_loading_UI()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"] as? String
                        
                        let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String(strSuccess2), style: .alert)
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                        
                    }
                    
                }
                
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
                self.hide_loading_UI()
                self.please_check_your_internet_connection()
                
                break
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! login_table_cell
        
        if (textField != cell.txtEmailAddress) {
            let currentText = textField.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return updatedText.count <= 11
        }
        return true
    }
    
    @objc func update_number_WB(str_show_loader:String) {
        
        if (str_show_loader == "yes") {
             if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                } else {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "ড্রাইভার খোঁজা হচ্ছে")
                }
                
             
            }
        }
        
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            var ar : NSArray!
            ar = (person["carinfromation"] as! Array<Any>) as NSArray
            
            let arr_mut_order_history:NSMutableArray! = []
            arr_mut_order_history.addObjects(from: ar as! [Any])
            
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                print(token_id_is as Any)
                
                let headers: HTTPHeaders = [
                    "token":String(token_id_is),
                ]
                var parameters:Dictionary<AnyHashable, Any>!
                parameters = [
                    "action"        : "editprofile",
                    "userId"        : String(myString),
                    "contactNumber"   : String(self.strPhoneNumber),
                    
                ]
                
                print(parameters as Any)
                
                AF.request(application_base_url, method: .post, parameters: parameters as? Parameters,headers: headers).responseJSON {
                    response in
                    // debugPrint(response.result)
                    
                    switch response.result {
                    case let .success(value):
                        
                        let JSON = value as! NSDictionary
                        print(JSON as Any)
                        
                        var strSuccess : String!
                        strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                        
                        var message : String!
                        message = (JSON["msg"] as? String)
                        
                        print(strSuccess as Any)
                        if strSuccess == String("success") {
                            print("yes")
                            
                            let defaults = UserDefaults.standard
                            defaults.setValue(JSON["data"], forKey: str_save_login_user_data)
                            
                            let str_token = (JSON["AuthToken"] as! String)
                            UserDefaults.standard.set("", forKey: str_save_last_api_token)
                            UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                            ERProgressHud.sharedInstance.hide()
                            
                            self.hide_loading_UI()
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
                            
                        } else if message == String(not_authorize_api) {
                            self.login_refresh_token_wb()
                            
                        } else {
                            
                            print("no")
                            ERProgressHud.sharedInstance.hide()
                            self.hide_loading_UI()
                            
                            var strSuccess2 : String!
                            strSuccess2 = JSON["msg"]as Any as? String
                            
                            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String(strSuccess2), style: .alert)
                            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                            alert.addButtons([cancel])
                            self.present(alert, animated: true)
                            
                        }
                        
                    case let .failure(error):
                        print(error)
                        ERProgressHud.sharedInstance.hide()
                        
                        self.please_check_your_internet_connection()
                        
                    }
                }
            } else {
                print("no token found")
                self.login_refresh_token_wb()
            }
        }
    }
    
    @objc func login_refresh_token_wb() {
        
        var parameters:Dictionary<AnyHashable, Any>!
        if let get_login_details = UserDefaults.standard.value(forKey: str_save_email_password) as? [String:Any] {
            print(get_login_details as Any)
            
            if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
                
                let x : Int = person["userId"] as! Int
                let myString = String(x)
                
                parameters = [
                    "action"    : "gettoken",
                    "userId"    : String(myString),
                    "email"     : (get_login_details["email"] as! String),
                    "role"      : "Member"
                ]
            }
            
            print("parameters-------\(String(describing: parameters))")
            
            AF.request(application_base_url, method: .post, parameters: parameters as? Parameters).responseJSON {
                response in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.value {
                        
                        let JSON = data as! NSDictionary
                        print(JSON)
                        
                        var strSuccess : String!
                        strSuccess = JSON["status"] as? String
                        
                        if strSuccess.lowercased() == "success" {
                            
                            let str_token = (JSON["AuthToken"] as! String)
                            UserDefaults.standard.set("", forKey: str_save_last_api_token)
                            UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                            
                            self.update_number_WB(str_show_loader: "no")
                            
                        } else {
                            ERProgressHud.sharedInstance.hide()
                        }
                        
                    }
                    
                case .failure(_):
                    print("Error message:\(String(describing: response.error))")
                    ERProgressHud.sharedInstance.hide()
                    self.please_check_your_internet_connection()
                    
                    break
                }
            }
        }
        
    }
    
    

    @objc func iAmHereForLocationPermission() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
              
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                self.strSaveLatitude = "0"
                self.strSaveLongitude = "0"
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                          
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                      
            @unknown default:
                break
            }
        }
    }
    
    
    @objc func login_wb() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! login_table_cell
        
        self.show_loading_UI()
        
        var parameters:Dictionary<AnyHashable, Any>!
//        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
//            let x : Int = (person["userId"] as! Int)
//            let myString = String(x)
            
            parameters = [
                "action"    : "login",
                "email"     : String(cell.txtEmailAddress.text!),
                "password"  : String(cell.txtPassword.text!),
            ]
//        }
        
        print("parameters-------\(String(describing: parameters))")
        
        AF.request(application_base_url, method: .post, parameters: parameters as? Parameters).responseJSON {
            response in
            
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    
                    let JSON = data as! NSDictionary
                    print(JSON)
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"] as? String
                    
                    if strSuccess.lowercased() == "success" {
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        /*let defaults = UserDefaults.standard
                        defaults.setValue(dict, forKey: str_save_login_user_data)*/
                         
                        let str_token = (JSON["AuthToken"] as! String)
                        UserDefaults.standard.set("", forKey: str_save_last_api_token)
                        UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                        
                        // self.save_email(email: String(email))
                        //
                        let indexPath = IndexPath.init(row: 0, section: 0)
                        let cell = self.tbleView.cellForRow(at: indexPath) as! login_table_cell
                        
                        // save email and pass
                        // email
                        let custom_email_pass = ["email":String(cell.txtEmailAddress.text!)]
                        
                        UserDefaults.standard.setValue(custom_email_pass, forKey: str_save_email_password)
                        //
                        self.hide_loading_UI()
                        
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "verify_phone_number_id") as! verify_phone_number
                        
                        push.strGetLoginUserID = "\(dict["userId"]!)"
                        push.strGetLoginEmailAddress = "\(dict["email"]!)"
                        push.strGetLoginPassword = String(cell.txtPassword.text!)
                        push.getOPT = "" // "\(dict["OTP"]!)"
                        
                        self.navigationController?.pushViewController(push, animated: true)
                        
                    } else {
                        
                        self.hide_loading_UI()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"] as? String
                        
                        let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String(strSuccess2), style: .alert)
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                        
                    }
                    
                }
                
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
                self.hide_loading_UI()
                self.please_check_your_internet_connection()
                
                break
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
 
    @objc func signInViaFacebook() {
        // Settings.shared.appID = "fb1035864164317944"
        // Settings.shared.displayName = "Zarib"
        
        let fbLoginManager : LoginManager = LoginManager()
        
        fbLoginManager.logIn(permissions:["email","public_profile"], from: self, handler: {(result, error) -> Void in
            
            print("\n\n result: \(String(describing: result))")
            print("\n\n Error: \(String(describing: error))")
            
            if (error == nil)
            {
                if let fbloginresult = result
                {
                    if(fbloginresult.isCancelled)
                    {
                        //Show Cancel alert to the user
                        let alert = UIAlertController(title: "Facebook login", message: "User pressed cancel button", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {    (action:UIAlertAction!) in
                            //print("you have pressed the ok button")
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        print("going to getFBLoggedInUserData.. ")
                        // self.getFBLoggedInUserData()
                        /*print("\(Profile.current?.userID)")
                         print("\(Profile.current?.firstName)")
                         print("\(Profile.current?.email)")
                         print("\(Profile.current?.imageURL)")*/
                        
                        if let url = URL(string: "\(Profile.current?.imageURL!)") {
                            print(url)
                            // print(String(contentsOf: url))
                            var myUrlStr : String = url.absoluteString
                            print(url)
                            
                            self.socia_login_fb_wb(name: (Profile.current?.firstName)!, social_id: Profile.current!.userID, email: (Profile.current?.email)!, profile_picture: "")
                            
                        }
                        
                    }
                }
                
            }
        })
    }
    
    @objc func socia_login_fb_wb(name:String,social_id:String,email:String,profile_picture:String) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! login_table_cell
        
        self.show_loading_UI()
        
        var parameters:Dictionary<AnyHashable, Any>!
//        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
//            let x : Int = (person["userId"] as! Int)
//            let myString = String(x)
            
            parameters = [
                "action"        :   "socialLoginAction",
                "email"         :   String(email),
                "socialId"      :   String(social_id),
                "fullName"      :   String(name),
                "socialType"    :   String("facebook"),
                "device"        :   String("iOS"),
                "deviceToken"   :   String(""),
                "image"         :   String(profile_picture)
            ]
//        }
        
        print("parameters-------\(String(describing: parameters))")
        
        AF.request(application_base_url, method: .post, parameters: parameters as? Parameters).responseJSON {
            response in
            
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    
                    let JSON = data as! NSDictionary
                    print(JSON)
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"] as? String
                    
                    
                    
                    if strSuccess.lowercased() == "success" {
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue(dict, forKey: str_save_login_user_data)
                        
                        // save token
                        // print("\(JSON["AuthToken"]!)")
                        // print(type(of: JSON["AuthToken"]))
                        
                        /*let str_token = (JSON["AuthToken"] as! String)
                        UserDefaults.standard.set("", forKey: str_save_last_api_token)
                        UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)*/
                        
                        // let indexPath = IndexPath.init(row: 0, section: 0)
                        // let cell = self.tbleView.cellForRow(at: indexPath) as! login_table_cell
                        
                        self.save_email(email: String(email))
                        // save email and pass
                        // email
                        
                        //
                        
                        self.hide_loading_UI()
                        
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
                        
                    }
                    else {
                        
                        self.hide_loading_UI()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"] as? String
                        
                        let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String(strSuccess2), style: .alert)
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                        
                    }
                    
                }
                
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
                self.hide_loading_UI()
                self.please_check_your_internet_connection()
                
                break
            }
        }
    }
     
    @objc func save_email(email:String) {
        
        let custom_email_pass = ["email":String(email)]
        UserDefaults.standard.setValue(custom_email_pass, forKey: str_save_email_password)
    }
    
    
}

/*extension login: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
         //here is credentials .
        }
    }
}

extension login: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}*/

extension login: UITableViewDataSource  , UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:login_table_cell = tableView.dequeueReusableCell(withIdentifier: "login_table_cell") as! login_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.txtEmailAddress.delegate = self
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                Utils.textFieldUI(textField: cell.txtEmailAddress,
                                  tfName: cell.txtEmailAddress.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .emailAddress,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "E-mail/Mobile No.")
            } else {
                Utils.textFieldUI(textField: cell.txtEmailAddress,
                                  tfName: cell.txtEmailAddress.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .emailAddress,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "ই-মেইল/মোবাইল নম্বর")
            }
            
        }
        
        
        cell.txtEmailAddress.layer.masksToBounds = false
        cell.txtEmailAddress.layer.shadowColor = UIColor.black.cgColor
        cell.txtEmailAddress.layer.shadowOffset =  CGSize.zero
        cell.txtEmailAddress.layer.shadowOpacity = 0.5
        cell.txtEmailAddress.layer.shadowRadius = 2
        
        cell.btnSignIn.addTarget(self, action: #selector(home_click_method), for: .touchUpInside)
        cell.btnDontHaveAnAccount.addTarget(self, action: #selector(dontHaveAntAccountClickMethod), for: .touchUpInside)
        cell.btn_remember_me.addTarget(self, action: #selector(remember_me_click_method), for: .touchUpInside)
        // cell.btn_google.addTarget(self, action: #selector(signInViaGoogle), for: .touchUpInside)
        // cell.btn_facebook.addTarget(self, action: #selector(signInViaFacebook), for: .touchUpInside)
        
        // facebook
        /*let loginButton = FBLoginButton()
        loginButton.center = cell.center
        cell.addSubview(loginButton)*/
        
        /*if let token = AccessToken.current,
           !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        }*/
        
        // apple
         // func setUpSignInAppleButton() {
        /*let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        authorizationButton.cornerRadius = 10
        // authorizationButton.center = cell.view_apple.center
          //Add button on some view or stack
        cell.view_apple.addSubview(authorizationButton)*/
         // }
        
        return cell
    }
    
    @objc func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
            
            if (email == nil) {
                print("second")
                self.social_login_via_apple_two(social_id: userIdentifier)
            } else {
                self.social_login_via_apple_one(social_id: userIdentifier, email: "\(String(describing: email))", name: "\(String(describing: fullName))")
            }
            
        }
        /*
         User id is 001171.b152c5c0628f4f92b62199a247481a17.0707
          Full Name is Optional(givenName: Manju familyName: Rajput )
          Email id is Optional("tdx2mhbpfq@privaterelay.appleid.com")
         */
        
    }
    
    @objc func social_login_via_apple_two(social_id:String) {
        
        self.show_loading_UI()
        
        var parameters:Dictionary<AnyHashable, Any>!

            parameters = [
                "action"        :   "socialLoginAction",
            // "email"         :   String(""),
                "socialId"      :   String(social_id),
            // "fullName"      :   String(""),
                "socialType"    :   String("apple"),
                "device"        :   String("iOS"),
                "deviceToken"   :   String(""),
                "image"         :   String("")
            ]
//        }
        
        print("parameters-------\(String(describing: parameters))")
        
        AF.request(application_base_url, method: .post, parameters: parameters as? Parameters).responseJSON {
            response in
            
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    
                    let JSON = data as! NSDictionary
                    print(JSON)
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"] as? String
                    
                    
                    
                    if strSuccess.lowercased() == "success" {
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue(dict, forKey: str_save_login_user_data)
                        
                        // save token
                        // print("\(JSON["AuthToken"]!)")
                        // print(type(of: JSON["AuthToken"]))
                        
                        /*let str_token = (JSON["AuthToken"] as! String)
                        UserDefaults.standard.set("", forKey: str_save_last_api_token)
                        UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)*/
                        
                        // let indexPath = IndexPath.init(row: 0, section: 0)
                        // let cell = self.tbleView.cellForRow(at: indexPath) as! login_table_cell
                        
                        // save email and pass
                        // email
                        // self.save_email(email: String(email))
                        //
                        
                        self.hide_loading_UI()
                         
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
                    else {
                        
                        self.hide_loading_UI()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"] as? String
                        
                        let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String(strSuccess2), style: .alert)
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                        
                    }
                    
                }
                
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
                self.hide_loading_UI()
                self.please_check_your_internet_connection()
                
                break
            }
        }
    }
    
    @objc func social_login_via_apple_one(social_id:String,email:String,name:String) {
        
        self.show_loading_UI()
        
        var parameters:Dictionary<AnyHashable, Any>!

            parameters = [
                "action"        :   "socialLoginAction",
                "email"         :   String(email),
                "socialId"      :   String(social_id),
                "fullName"      :   String(name),
                "socialType"    :   String("apple"),
                "device"        :   String("iOS"),
                "deviceToken"   :   String(""),
                "image"         :   String("")
            ]
//        }
        
        print("parameters-------\(String(describing: parameters))")
        
        AF.request(application_base_url, method: .post, parameters: parameters as? Parameters).responseJSON {
            response in
            
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    
                    let JSON = data as! NSDictionary
                    print(JSON)
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"] as? String
                    
                    
                    
                    if strSuccess.lowercased() == "success" {
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue(dict, forKey: str_save_login_user_data)
                        
                        // save token
                        // print("\(JSON["AuthToken"]!)")
                        // print(type(of: JSON["AuthToken"]))
                        
                        /*let str_token = (JSON["AuthToken"] as! String)
                        UserDefaults.standard.set("", forKey: str_save_last_api_token)
                        UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)*/
                        
                        self.save_email(email: String(email))
                        
                        self.hide_loading_UI()
                        
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
                        
                    }
                    else {
                        
                        self.hide_loading_UI()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"] as? String
                        
                        let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String(strSuccess2), style: .alert)
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                        
                    }
                    
                }
                
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
                self.hide_loading_UI()
                self.please_check_your_internet_connection()
                
                break
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
    // 989013037178
    // VLMBIP
    
    @objc func remember_me_click_method() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! login_table_cell
        
        if cell.btn_remember_me.tag == 1 {
            
            cell.btn_remember_me.setImage(UIImage(named: "un_check"), for: .normal)
            cell.btn_remember_me.tag = 0
            
            UserDefaults.standard.set("no", forKey: "key_remember_me")
            
        } else {
            
            cell.btn_remember_me.tag = 1
            cell.btn_remember_me.setImage(UIImage(named: "check"), for: .normal)
            
            UserDefaults.standard.set("yes", forKey: "key_remember_me")
        }
        
    }
    
    @objc func home_click_method() {
        
         self.login_wb()
        
    }
    
    @objc func btnForgotPasswordPress() {
       
    }
    
    @objc func signInClickMethod() {
        
    }
    
    @objc func dontHaveAntAccountClickMethod() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "sign_up_id")
         self.navigationController?.pushViewController(push, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 900
    }
    
}

class login_table_cell: UITableViewCell {

    @IBOutlet weak var btn_google:UIButton!
    @IBOutlet weak var btn_facebook:UIButton!
    @IBOutlet weak var btn_apple:UIButton!
    
    @IBOutlet weak var view_apple:UIView!
    
    @IBOutlet weak var bgColor:UIImageView!
    
    @IBOutlet weak var viewBGForUpperImage:UIView! {
        didSet {
            viewBGForUpperImage.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var txtEmailAddress:UITextField! {
        didSet {
            
            
             
        }
    }
    
    @IBOutlet weak var txtPassword:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtPassword,
                              tfName: txtPassword.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Password")
            
            txtPassword.layer.masksToBounds = false
            txtPassword.layer.shadowColor = UIColor.black.cgColor
            txtPassword.layer.shadowOffset =  CGSize.zero
            txtPassword.layer.shadowOpacity = 0.5
            txtPassword.layer.shadowRadius = 2
            txtPassword.isSecureTextEntry = true
        }
    }
    
    @IBOutlet weak var btn_remember_me:UIButton! {
        didSet {
            btn_remember_me.tag = 0
            btn_remember_me.setImage(UIImage(named: "un_check"), for: .normal)
        }
    }
    
    @IBOutlet weak var btnSignIn:UIButton! {
        didSet {
             
            Utils.buttonStyle(button: btnSignIn,
                              bCornerRadius: 12,
                              bBackgroundColor: buttonColorRed,
                              bTitle: "Login",
                              bTitleColor: .black)
            
            btnSignIn.layer.masksToBounds = false
            btnSignIn.layer.shadowColor = UIColor.black.cgColor
            btnSignIn.layer.shadowOffset =  CGSize.zero
            btnSignIn.layer.shadowOpacity = 0.5
            btnSignIn.layer.shadowRadius = 2
        }
    }
    
    @IBOutlet weak var btnSignUp:UIButton! {
        didSet {
            Utils.buttonStyle(button: btnSignUp, bCornerRadius: 0, bBackgroundColor: .clear, bTitle: "Sign Up", bTitleColor: .white)
        }
    }
    
    @IBOutlet weak var btnSaveAndContinue:UIButton! {
        didSet {
            Utils.buttonStyle(button: btnSaveAndContinue, bCornerRadius: 6, bBackgroundColor: .black, bTitle: "Sign In", bTitleColor: .white)
        }
    }
   
    @IBOutlet weak var btnDontHaveAnAccount:UIButton! {
        didSet {
            Utils.buttonStyle(button: btnDontHaveAnAccount, bCornerRadius: 6, bBackgroundColor: .clear, bTitle: "Not a member? Register Now", bTitleColor: UIColor(red: 87.0/255.0, green: 77.0/255.0, blue: 112.0/255.0, alpha: 1))
            btnDontHaveAnAccount.setTitleColor(UIColor.yellow, for: .normal)
        }
    }
    
    @IBOutlet weak var lbl_remember_me:UILabel!
    @IBOutlet weak var lbl_login_with_social_media:UILabel!
    @IBOutlet weak var lbl_login_to_continue:UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    

}
