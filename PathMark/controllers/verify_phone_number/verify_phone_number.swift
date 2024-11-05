//
//  verify_phone_number.swift
//  PathMark
//
//  Created by Dishant Rajput on 10/07/23.
//

import UIKit
import OTPFieldView
import Alamofire

//import CommonCrypto
// import JWTDecode
import CryptoKit

enum DisplayType: Int {
    case circular
    case roundedCorner
    case square
    case diamond
    case underlinedBottom
}

class verify_phone_number: UIViewController , UITextFieldDelegate {
    
    var window: UIWindow?
    var getOPT:String!
    var strGetLoginUserID:String!
    var strGetLoginEmailAddress:String!
    var strGetLoginPassword:String!
    var str_save_otp:String!
    
    @IBOutlet weak var view_navigation_bar:UIView! {
        didSet {
            view_navigation_bar.applyGradient()
        }
    }
    
    @IBOutlet weak var view_navigation_title:UILabel! {
        didSet {
            view_navigation_title.text = "Verify Phone Number"
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var tbleView:UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.strGetLoginUserID as Any)
        print(self.strGetLoginEmailAddress as Any)
        
        let defaults = UserDefaults.standard
        defaults.setValue("", forKey: str_save_login_user_data)
        defaults.setValue("", forKey: str_save_last_api_token)
        
        // UserDefaults.standard.set("no", forKey: "key_remember_me")
    }
    
    /*@objc func convert_verify_OTP_params_into_encode(otp:String) {
     //        let indexPath = IndexPath.init(row: 0, section: 0)
     //        let cell = self.tbleView.cellForRow(at: indexPath) as! verify_phone_number_table_cell
     
     if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
     // let str:String = person["role"] as! String
     
     let x : Int = person["userId"] as! Int
     let myString = String(x)
     
     let params = payload_verify_OTP(action: "verifyOTP",
     userId: String(myString),
     OTP:String(otp))
     
     print(params as Any)
     
     let secret = sha_token_api_key
     let privateKey = SymmetricKey(data: Data(secret.utf8))
     
     let headerJSONData = try! JSONEncoder().encode(Header())
     let headerBase64String = headerJSONData.urlSafeBase64EncodedString()
     
     let payloadJSONData = try! JSONEncoder().encode(params)
     let payloadBase64String = payloadJSONData.urlSafeBase64EncodedString()
     
     let toSign = Data((headerBase64String + "." + payloadBase64String).utf8)
     
     let signature = HMAC<SHA512>.authenticationCode(for: toSign, using: privateKey)
     let signatureBase64String = Data(signature).urlSafeBase64EncodedString()
     // print(signatureBase64String)
     
     let token = [headerBase64String, payloadBase64String, signatureBase64String].joined(separator: ".")
     print(token)
     
     
     
     // decode for testing
     // decode
     do {
     let jwt = try decode(jwt: token)
     print(jwt)
     
     print(type(of: jwt))
     
     print(jwt["body"])
     } catch {
     print("The file could not be loaded")
     }
     }
     // send this token to server
     // sign_up_WB(get_encrpyt_token: token)
     
     
     }*/
    
    @objc func verify_OTP_WB(str_show_loader:String) {
        
        self.view.endEditing(true)
        
        if (str_show_loader == "yes") {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                } else {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "অপেক্ষা করুন")
                }
            }
        }
        
        
        let params = payload_verify_OTP(action: "verifyOTP",
                                        userId: String(self.strGetLoginUserID),
                                        OTP:String(self.str_save_otp))
        
        print(params as Any)
        
        AF.request(application_base_url,
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder.default).responseJSON { response in
            // debugPrint(response.result)
            
            switch response.result {
            case let .success(value):
                
                let JSON = value as! NSDictionary
                print(JSON as Any)
                
                var strSuccess : String!
                strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                
                var message : String!
                message = (JSON["msg"]as Any as? String)?.lowercased()
                
                print(strSuccess as Any)
                if strSuccess == String("success") {
                    print("yes")
                    
                    self.signInAfterLogin(email: String(self.strGetLoginEmailAddress))
                    
                } else if message == String(not_authorize_api) {
                    self.login_refresh_token_wb()
                    
                } else {
                    
                    let defaults = UserDefaults.standard
                    defaults.setValue("", forKey: str_save_login_user_data)
                    defaults.setValue("", forKey: str_save_last_api_token)
                    
                    UserDefaults.standard.set("no", forKey: "key_remember_me")
                    
                    print("no")
                    ERProgressHud.sharedInstance.hide()
                    
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
                    "email"     : String(self.strGetLoginEmailAddress),
                    "role"      : (person["role"] as! String)
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
                            
                            self.verify_OTP_WB(str_show_loader: "no")
                            
                        }
                        else {
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
    
    @objc func signInAfterLogin(email:String) {
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            } else {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "অপেক্ষা করুন")
            }
        }
        
        self.view.endEditing(true)
        
        let params = payload_login(action: "login",
                                   email: String(email),
                                   password: String(self.strGetLoginPassword))
        
        print(params as Any)
        
        AF.request(application_base_url,
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder.default).responseJSON { response in
            // debugPrint(response.result)
            
            switch response.result {
            case let .success(value):
                
                let JSON = value as! NSDictionary
                print(JSON as Any)
                
                var strSuccess : String!
                strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                
                print(strSuccess as Any)
                if strSuccess == String("success") {
                    print("yes")
                    
                    let defaults = UserDefaults.standard
                    defaults.setValue(JSON["data"], forKey: str_save_login_user_data)
                    
                    let str_token = (JSON["AuthToken"] as! String)
                    UserDefaults.standard.set("", forKey: str_save_last_api_token)
                    UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                    
                    let custom_email_pass = ["email":String(self.strGetLoginEmailAddress),
                                             "password":""]
                    
                    UserDefaults.standard.setValue(custom_email_pass, forKey: str_save_email_password)
                    
                    self.hide_loading_UI()
                    ERProgressHud.sharedInstance.hide()
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as! dashboard
                    self.navigationController?.pushViewController(push, animated: true)
                    
                } else {
                    
                    print("no")
                    self.dismiss(animated: true)
                    ERProgressHud.sharedInstance.hide()
                    
                    var strSuccess2 : String!
                    strSuccess2 = JSON["msg"]as Any as? String
                    
                    let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String(strSuccess2), style: .alert)
                    let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                    alert.addButtons([cancel])
                    self.present(alert, animated: true)
                    
                }
                
            case let .failure(error):
                print(error)
                self.dismiss(animated: true)
                ERProgressHud.sharedInstance.hide()
                
                self.please_check_your_internet_connection()
                
            }
        }
    }
    
    
    @objc func push_to_dashboard() {
        // let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as? dashboard
        // self.navigationController?.pushViewController(push!, animated: true)
        
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
        
        window?.makeKeyAndVisible()
    }
    
}

extension verify_phone_number: UITableViewDataSource  , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:verify_phone_number_table_cell = tableView.dequeueReusableCell(withIdentifier: "verify_phone_number_table_cell") as! verify_phone_number_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView

        cell.otpTextFieldView.backgroundColor = .clear
        cell.otpTextFieldView.fieldsCount = 6
        cell.otpTextFieldView.fieldBorderWidth = 2
        cell.otpTextFieldView.defaultBorderColor = UIColor.black
        cell.otpTextFieldView.filledBorderColor = UIColor.green
        cell.otpTextFieldView.cursorColor = UIColor.red
        cell.otpTextFieldView.displayType = .square
        cell.otpTextFieldView.fieldSize = 60
        cell.otpTextFieldView.separatorSpace = 8
        cell.otpTextFieldView.shouldAllowIntermediateEditing = false
        cell.otpTextFieldView.delegate = self
        cell.otpTextFieldView.initializeUI()
        
        cell.lblDummyOTP.text = String(self.getOPT)
        
        return cell
    }
    
    // 989013037178
    // VLMBIP
    
    @objc func sign_up_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "verify_phone_number_id") as? verify_phone_number
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func accept_terms_click_method() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! verify_phone_number_table_cell
        
        if cell.btn_accept_terms.tag == 1 {
            
            cell.btn_accept_terms.setImage(UIImage(named: "un_check"), for: .normal)
            cell.btn_accept_terms.tag = 0
            cell.btnSignUp.backgroundColor = .lightGray
            cell.btnSignUp.isUserInteractionEnabled = false
            
        } else {
            
            cell.btn_accept_terms.tag = 1
            cell.btn_accept_terms.setImage(UIImage(named: "check"), for: .normal)
            cell.btnSignUp.backgroundColor = UIColor(red: 246.0/255.0, green: 200.0/255.0, blue: 68.0/255.0, alpha: 1)
            cell.btnSignUp.isUserInteractionEnabled = true
            
        }
        
    }
    
    @objc func btnForgotPasswordPress() {
        
//        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForgotPassword") as? ForgotPassword
//        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func signInClickMethod() {
        
//        self.login_WB()
        
        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UPDSAddressId")
         self.navigationController?.pushViewController(push, animated: true)*/
    }
    
    @objc func dontHaveAntAccountClickMethod() {
        
//        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RegistraitonId") as? Registraiton
//        self.navigationController?.pushViewController(settingsVCId!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 900
    }
    
}


class verify_phone_number_table_cell: UITableViewCell {
    @IBOutlet weak var lblDummyOTP:UILabel!
    @IBOutlet var otpTextFieldView: OTPFieldView!

    
    
    @IBOutlet weak var header_full_view_navigation_bar:UIView! {
        didSet {
            header_full_view_navigation_bar.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var header_half_view_navigation_bar:UIView! {
        didSet {
            header_half_view_navigation_bar.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var img_upload:UIImageView! {
        didSet {
            img_upload.layer.cornerRadius = 12
            img_upload.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var bgColor:UIImageView!
    
    @IBOutlet weak var viewBGForUpperImage:UIView! {
        didSet {
            viewBGForUpperImage.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var txtEmailAddress:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtEmailAddress,
                              tfName: txtEmailAddress.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .emailAddress,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Email Address")
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
        }
    }
    
    //
    @IBOutlet weak var txt_full_name:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_full_name,
                              tfName: txt_full_name.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Full name")
        }
    }
    
    @IBOutlet weak var txt_phone_number:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_phone_number,
                              tfName: txt_phone_number.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Phone Number")
        }
    }
    
    @IBOutlet weak var txt_address:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_address,
                              tfName: txt_address.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Address")
        }
    }
    
    
    @IBOutlet weak var btn_accept_terms:UIButton! {
        didSet {
            btn_accept_terms.backgroundColor = .clear
            btn_accept_terms.tag = 0
            btn_accept_terms.setImage(UIImage(named: "un_check"), for: .normal)
        }
    }
    
    @IBOutlet weak var btnSignIn:UIButton! {
        didSet {
             
            Utils.buttonStyle(button: btnSignIn,
                              bCornerRadius: 12,
                              bBackgroundColor: .lightGray,
                              bTitle: "Sign In",
                              bTitleColor: .black)
        }
    }
    
    @IBOutlet weak var btnSignUp:UIButton! {
        didSet {
            Utils.buttonStyle(button: btnSignUp,
                              bCornerRadius: 12,
                              bBackgroundColor: .lightGray,
                              bTitle: "Sign Up",
                              bTitleColor: .black)
        }
    }
    
    @IBOutlet weak var btnSaveAndContinue:UIButton! {
        didSet {
            Utils.buttonStyle(button: btnSaveAndContinue, bCornerRadius: 6, bBackgroundColor: .black, bTitle: "Sign In", bTitleColor: .white)
        }
    }
    
    @IBOutlet weak var btn_disclaimer:UIButton! {
        didSet {
            Utils.buttonStyle(button: btn_disclaimer,
                              bCornerRadius: 17,
                              bBackgroundColor: navigation_color,
                              bTitle: "Disclaimer", bTitleColor: .white)
        }
    }
    
    
    @IBOutlet weak var btnForgotPassword:UIButton! {
        didSet {
            Utils.buttonStyle(button: btnForgotPassword,
                              bCornerRadius: 6,
                              bBackgroundColor: .clear,
                              bTitle: "Forgot Password ? - Click here",
                              bTitleColor: navigation_color)
        }
    }
    
    @IBOutlet weak var btnDontHaveAnAccount:UIButton! {
        didSet {
            Utils.buttonStyle(button: btnDontHaveAnAccount, bCornerRadius: 6, bBackgroundColor: .clear, bTitle: "Don't have an Account - Sign Up", bTitleColor: UIColor(red: 87.0/255.0, green: 77.0/255.0, blue: 112.0/255.0, alpha: 1))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UIViewController {
    func hideKeyBoard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
//    @objc func dismissKeyboard(){
//        self.view.endEditing(true)
//    }
}

extension verify_phone_number: OTPFieldViewDelegate {
    
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        print("OTPString: \(otpString)")
        //
        self.str_save_otp = "\(otpString)"
        self.verify_OTP_WB(str_show_loader: "yes")
    }
}

