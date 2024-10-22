//
//  sign_up.swift
//  PathMark
//
//  Created by Dishant Rajput on 10/07/23.
//

import UIKit
import Alamofire
import CryptoKit
import CommonCrypto
// import JWTDecode
import SDWebImage

// MARK:- LOCATION -
import CoreLocation

class edit_profile: UIViewController , UITextFieldDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

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
    
    var arr_country_array:NSArray!
    
    var str_user_select_image:String! = "0"
    var img_data_banner : Data!
    var img_Str_banner : String!
    
    // device token
    var str_token_id:String!
    
    var str_country_id:String!
    
    @IBOutlet weak var view_navigation_bar:UIView! {
        didSet {
            view_navigation_bar.applyGradient()
        }
    }
    
    @IBOutlet weak var view_navigation_title:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    view_navigation_title.text = "Edit Profile"
                } else {
                    view_navigation_title.text = "প্রোফাইল আপডেট করুন"
                }
                
                view_navigation_title.textColor = .white
            }
        }
    }
    
    @IBOutlet weak var tbleView:UITableView! {
        didSet {
            
            tbleView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var btn_back:UIButton! {
        didSet {
            btn_back.tintColor = .white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.sideBarMenuClick()

        self.get_country_list_WB()
        
        if let device_token = UserDefaults.standard.string(forKey: "key_my_device_token") {
            
            self.str_token_id = String(device_token)
        }
    }
    
    @objc func sideBarMenuClick() {
        
        self.view.endEditing(true)
        if revealViewController() != nil {
            self.btn_back.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @objc func back_click_method_3() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // get country list
    @objc func get_country_list_WB() {
        
        self.view.endEditing(true)
        
         if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                } else {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "ড্রাইভার খোঁজা হচ্ছে")
                }
                
             
            }
        
        let params = payload_country_list(action: "countrylist")
        
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
                    
                    self.arr_country_array = (JSON["data"] as! NSArray)
                    
                    self.tbleView.delegate = self
                    self.tbleView.dataSource = self
                    self.tbleView.reloadData()
                    
                    ERProgressHud.sharedInstance.hide()
                    
                    // self.country_click_method()
                    
                } else {
                    
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
    
    @objc func sign_up_WB(str_show_loader:String) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! edit_profile_table_cell
        
        self.view.endEditing(true)
        
        if (self.str_user_select_image == "0") {
            
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please upload Profile Picture"), style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            
            return
        }

        var phone_number_code : String!
        
        if (cell.txt_full_name.text! == "") {
            
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please enter full name"), style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            ERProgressHud.sharedInstance.hide()
            
            return
            
        } else if (cell.txtEmailAddress.text! == "") {
            
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please enter email address"), style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            ERProgressHud.sharedInstance.hide()
            
            return
            
        } else if (cell.txt_phone_number.text! == "") {
            
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please enter phone number"), style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            ERProgressHud.sharedInstance.hide()
            
            return
            
        } else if (cell.txt_country.text! == "") {
            
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please enter country name"), style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            ERProgressHud.sharedInstance.hide()
            
            return
            
        } else {
            
            for indexx in 0..<self.arr_country_array.count {
                
                let item = self.arr_country_array[indexx] as? [String:Any]
                print(item as Any)
                
                if (cell.txt_country.text! == (item!["name"] as! String)) {
                    print("yes matched")
                    phone_number_code = (item!["phonecode"] as! String)
                    self.str_country_id   = "\(item!["id"]!)"
                }
                
            }
            
        }
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                print(token_id_is as Any)
                
                let headers: HTTPHeaders = [
                    "token":String(token_id_is),
                ]
                
                let x : Int = person["userId"] as! Int
                let myString = String(x)
                // self.show_loading_UI()
                 if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                } else {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "ড্রাইভার খোঁজা হচ্ছে")
                }
                
             
            }
                
                //Set Your URL
                let api_url = application_base_url
                guard let url = URL(string: api_url) else {
                    return
                }
                
                var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
                urlRequest.httpMethod = "POST"
                urlRequest.allHTTPHeaderFields = ["token":String(token_id_is)]
                urlRequest.addValue("application/json",
                                    forHTTPHeaderField: "Accept")
                
                //Set Your Parameter
                let parameterDict = NSMutableDictionary()
                
                /*
                 (action: "registration",
                 fullName: String(cell.txt_full_name.text!),
                 email: String(cell.txtEmailAddress.text!),
                 countryCode: String(phone_number_code),
                 contactNumber: String(cell.txt_phone_number.text!),
                 password: String(cell.txtPassword.text!),
                 role: "Driver",
                 INDNo: String(cell.txt_nid_number.text!),
                 latitude: "",
                 longitude: "",
                 device: "iOS",
                 deviceToken: "")
                 */
                
                var str_device_token:String!
                
                if let device_token = UserDefaults.standard.string(forKey: "key_my_device_token") {
                    str_device_token = String(device_token)
                }
                
                // car information
                parameterDict.setValue("editProfile", forKey: "action")
                parameterDict.setValue(myString, forKey: "userId")
                
                parameterDict.setValue(String(cell.txt_full_name.text!), forKey: "fullName")
                parameterDict.setValue(String(phone_number_code), forKey: "countryCode")
                parameterDict.setValue(String(cell.txt_phone_number.text!), forKey: "contactNumber")
                parameterDict.setValue("iOS", forKey: "device")
                parameterDict.setValue(String(self.str_token_id), forKey: "deviceToken")
                
                parameterDict.setValue(String(self.str_country_id), forKey: "countryId")
                
                print(parameterDict as Any)
                
                // Now Execute
                AF.upload(multipartFormData: { multiPart in
                    for (key, value) in parameterDict {
                        if let temp = value as? String {
                            multiPart.append(temp.data(using: .utf8)!, withName: key as! String)
                        }
                        if let temp = value as? Int {
                            multiPart.append("\(temp)".data(using: .utf8)!, withName: key as! String)
                        }
                        if let temp = value as? NSArray {
                            temp.forEach({ element in
                                let keyObj = key as! String + "[]"
                                if let string = element as? String {
                                    multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                                } else
                                if let num = element as? Int {
                                    let value = "\(num)"
                                    multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                                }
                            })
                        }
                    }
                    multiPart.append(self.img_data_banner, withName: "image", fileName: "edit_profile.png", mimeType: "image/png")
                }, with: urlRequest)
                .uploadProgress(queue: .main, closure: { progress in
                    //Current upload progress of file
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                .responseJSON(completionHandler: { data in
                    
                    switch data.result {
                        
                    case .success(_):
                        do {
                            
                            let dictionary = try JSONSerialization.jsonObject(with: data.data!, options: .fragmentsAllowed) as! NSDictionary
                            print(dictionary)
                            
                            var message : String!
                            message = (dictionary["msg"] as? String)
                            
                            if (dictionary["status"] as! String) == "success" {
                                print("yes")
                                
                                var dict: Dictionary<AnyHashable, Any>
                                dict = dictionary["data"] as! Dictionary<AnyHashable, Any>
                                
                                let defaults = UserDefaults.standard
                                defaults.setValue(dict, forKey: str_save_login_user_data)
                                
                                // save email and password
                                /*let custom_email_pass = ["email":cell.txtEmailAddress.text!,
                                                         "password":cell.txtPassword.text!]
                                
                                UserDefaults.standard.setValue(custom_email_pass, forKey: str_save_email_password)*/
                                
                                let alert = NewYorkAlertController(title: String("Success").uppercased(), message: (dictionary["msg"] as! String), style: .alert)
                                let cancel = NewYorkButton(title: "Ok", style: .cancel)
                                alert.addButtons([cancel])
                                self.present(alert, animated: true)
                                
                                // self.hide_loading_UI()
                                ERProgressHud.sharedInstance.hide()
                                
                                self.navigationController?.popViewController(animated: true)
                                
                            } else if (dictionary["status"] as! String) == "Success" {
                                print("yes")
                                
                                var dict: Dictionary<AnyHashable, Any>
                                dict = dictionary["data"] as! Dictionary<AnyHashable, Any>
                                
                                let defaults = UserDefaults.standard
                                defaults.setValue(dict, forKey: str_save_login_user_data)
                                
                                // save email and password
                                /*let custom_email_pass = ["email":cell.txtEmailAddress.text!,
                                                         "password":cell.txtPassword.text!]
                                
                                UserDefaults.standard.setValue(custom_email_pass, forKey: str_save_email_password)*/
                                
                                let alert = NewYorkAlertController(title: String("Success").uppercased(), message: (dictionary["msg"] as! String), style: .alert)
                                let cancel = NewYorkButton(title: "Ok", style: .cancel)
                                alert.addButtons([cancel])
                                self.present(alert, animated: true)
                                
                                // self.hide_loading_UI()
                                ERProgressHud.sharedInstance.hide()
                                
                                self.navigationController?.popViewController(animated: true)
                                
                            } else if message == String(not_authorize_api) {
                                self.login_refresh_token_wb()
                                
                            } else {
                                let alert = NewYorkAlertController(title: String("Success").uppercased(), message: (dictionary["msg"] as! String), style: .alert)
                                let cancel = NewYorkButton(title: "Ok", style: .cancel)
                                alert.addButtons([cancel])
                                self.present(alert, animated: true)
                                ERProgressHud.sharedInstance.hide()
                            }
                            
                        }
                        catch {
                            // catch error.
                            print("catch error")
                            ERProgressHud.sharedInstance.hide()
                        }
                        break
                        
                    case .failure(_):
                        print("failure")
                        ERProgressHud.sharedInstance.hide()
                        break
                        
                    }
                    
                    
                })
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
                            
                            self.sign_up_WB(str_show_loader: "no")
                            
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
    
    @objc func alert_warning () {
        
        let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: "Field should not be empty.", style: .alert)
        let cancel = NewYorkButton(title: "Ok", style: .cancel)
        alert.addButtons([cancel])
        self.present(alert, animated: true)
        
    }
    
    @objc func before_open_popup() {
        
        self.country_click_method()
    }
    
    @objc func country_click_method() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! edit_profile_table_cell
        
        let arr_mut:NSMutableArray = []
        
        for index in 0..<self.arr_country_array.count {
            
            let item = self.arr_country_array[index] as? [String:Any]
            print(item as Any)
            
            arr_mut.add(item!["name"] as! String)
            
        }
        
        if let swiftArray = arr_mut as NSArray as? [String] {
            ERProgressHud.sharedInstance.hide()
            RPicker.selectOption(title: "Select", cancelText: "Cancel", dataArray: swiftArray, selectedIndex: 0) { (selctedText, atIndex) in
                cell.txt_country.text = String(selctedText)
                
                for indexx in 0..<self.arr_country_array.count {
                    
                    let item = self.arr_country_array[indexx] as? [String:Any]
                    
                    if (cell.txt_country.text! == (item!["name"] as! String)) {
                        print("yes matched")
                        cell.txt_phone_code.text = (item!["phonecode"] as! String)
                        self.str_country_id   = "\(item!["id"]!)"
                    }
                    
                }
                
            }
            
        }
        
    }
    
    @objc func eye_one_click_method() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! edit_profile_table_cell
        
        if (cell.btn_eyes_one.tag == 0) {
            cell.btn_eyes_one.setImage(UIImage(systemName: "eye"), for: .normal)
            cell.txtPassword.isSecureTextEntry = false
            cell.btn_eyes_one.tag = 1
        } else {
            cell.btn_eyes_one.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            cell.txtPassword.isSecureTextEntry = true
            cell.btn_eyes_one.tag = 0
        }
        
    }
    
    @objc func eye_two_click_method() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! edit_profile_table_cell
        
        if (cell.btn_eyes_two.tag == 0) {
            cell.btn_eyes_two.setImage(UIImage(systemName: "eye"), for: .normal)
            cell.txt_confirm_password.isSecureTextEntry = false
            cell.btn_eyes_two.tag = 1
        } else {
            cell.btn_eyes_two.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            cell.txt_confirm_password.isSecureTextEntry = true
            cell.btn_eyes_two.tag = 0
        }
        
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.open_camera_gallery()
    }
    
    @objc func sign_up_click_method() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! edit_profile_table_cell
        
        if (self.str_user_select_image != "1") {
            // Image
            
            if (cell.txt_phone_number.text!.count != 10) {
                
                let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please enter valid phone number"), style: .alert)
                let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                alert.addButtons([cancel])
                self.present(alert, animated: true)
                ERProgressHud.sharedInstance.hide()

                return
                
            } else {
                self.edit_without_image(str_show_loader: "yes")
            }
            
            
        } else {
            self.sign_up_WB(str_show_loader: "yes")
        }
        
    }
    
    @objc func edit_without_image(str_show_loader:String) {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! edit_profile_table_cell
        
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
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            print(myString as Any)
            
            var ar : NSArray!
            ar = (person["carinfromation"] as! Array<Any>) as NSArray
            
            let arr_mut_order_history:NSMutableArray! = []
            arr_mut_order_history.addObjects(from: ar as! [Any])
            
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                print(token_id_is as Any)
                
                let headers: HTTPHeaders = [
                    "token":String(token_id_is),
                ]
                
                parameters = [
                    "action"        : "editProfile",
                    "userId"        : String(myString),
                    "fullName"      : String(cell.txt_full_name.text!),
                    "countryCode"   : String(cell.txt_phone_code.text!),
                    "contactNumber" : String(cell.txt_phone_number.text!),
                    "countryId" : String(self.str_country_id),
                    
                    "role"          : "Member",
                    "device"        : "iOS",
                    "deviceToken"   : String(self.str_token_id)
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

                            var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            
                            let defaults = UserDefaults.standard
                            defaults.setValue(dict, forKey: str_save_login_user_data)
                            
                            // save email and password
                            /*let custom_email_pass = ["email":cell.txtEmailAddress.text!,
                                                     "password":cell.txtPassword.text!]
                            
                            UserDefaults.standard.setValue(custom_email_pass, forKey: str_save_email_password)*/
                            
                            let alert = NewYorkAlertController(title: String("Success").uppercased(), message: (JSON["msg"] as! String), style: .alert)
                            let cancel = NewYorkButton(title: "Ok", style: .cancel)
                            alert.addButtons([cancel])
                            self.present(alert, animated: true)
                            
                            // self.hide_loading_UI()
                            ERProgressHud.sharedInstance.hide()
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        } else if message == String(not_authorize_api) {
                            self.login_refresh_token_wb2()
                            
                        } else {
                            
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
        }
    }
    
    @objc func login_refresh_token_wb2() {
        
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
                            
                            self.edit_without_image(str_show_loader: "no")
                            
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
    
    
    
    
    
    
    // MARK: - OPEN CAMERA OR GALLERY -
    @objc func open_camera_gallery() {
        
        let actionSheet = NewYorkAlertController(title: "Upload pics", message: nil, style: .actionSheet)
        
        // actionSheet.addImage(UIImage(named: "camera"))
        
        let cameraa = NewYorkButton(title: "Camera", style: .default) { _ in
            // print("camera clicked done")
            
            self.open_camera_or_gallery(str_type: "c")
        }
        
        let gallery = NewYorkButton(title: "Gallery", style: .default) { _ in
            // print("camera clicked done")
            
            self.open_camera_or_gallery(str_type: "g")
        }
        
        let cancel = NewYorkButton(title: "Cancel", style: .cancel)
        
        actionSheet.addButtons([cameraa, gallery, cancel])
        
        self.present(actionSheet, animated: true)
        
    }
    
    // MARK: - OPEN CAMERA or GALLERY -
    @objc func open_camera_or_gallery(str_type:String) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if str_type == "c" {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! edit_profile_table_cell
        
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage

        cell.img_upload.image = image_data
        let imageData:Data = image_data!.pngData()!
        self.img_Str_banner = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
        self.img_data_banner = image_data!.jpegData(compressionQuality: 0.2)!
        self.dismiss(animated: true, completion: nil)
   
        self.str_user_select_image = "1"
    }
    
    
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! edit_profile_table_cell

        
        if (textField == cell.txt_phone_number) {
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // make sure the result is under 16 characters
            return updatedText.count <= 10
            
        
        }
        return true
        
    }
    
    
    
    
}

extension edit_profile: UITableViewDataSource  , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:edit_profile_table_cell = tableView.dequeueReusableCell(withIdentifier: "edit_profile_table_cell") as! edit_profile_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.txtEmailAddress.delegate = self
        cell.txt_full_name.delegate = self
        
         cell.txt_phone_number.delegate = self
        // cell.txt_address.delegate = self
        // cell.txt_address.delegate = self
        // cell.txt_nid_number.delegate = self
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)

            cell.txtEmailAddress.text   = (person["email"] as! String)
            cell.txtEmailAddress.isUserInteractionEnabled = false
            
            cell.txt_full_name.text     = (person["fullName"] as! String)
            cell.txt_phone_number.text  = (person["contactNumber"] as! String)
            cell.txt_phone_code.text    = "+\(person["countryCode"]!)"
            
            cell.txt_country.text  = (person["countryName"] as! String)
            
            // print(cell.txt_phone_code.text as Any)
            // print((person["countryCode"] as! String))
            
            for index in 0..<self.arr_country_array.count {
                
                let item = self.arr_country_array[index] as? [String:Any]
                // print(item as Any)
                 
                if (item!["phonecode"] as! String == "\(person["countryCode"]!)") {
                    // print("yes matched")
                    cell.txt_country.text   = (item!["name"] as! String)
                    self.str_country_id   = "\(item!["id"]!)"
                }
             
            }

            cell.img_upload.layer.borderColor = UIColor.white.cgColor
            cell.img_upload.layer.borderWidth = 1
            
            cell.img_upload.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.img_upload.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "1024"))
        }
        
        // cell.btn_accept_terms.addTarget(self, action: #selector(accept_terms_click_method), for: .touchUpInside)
        
        cell.btnSignUp.addTarget(self, action: #selector(sign_up_click_method), for: .touchUpInside)
        // cell.btn_accept_terms.setImage(UIImage(named: "check"), for: .normal)
        cell.btnSignUp.backgroundColor = UIColor(red: 246.0/255.0, green: 200.0/255.0, blue: 68.0/255.0, alpha: 1)
        cell.btnSignUp.isUserInteractionEnabled = true
        
        cell.btn_country.addTarget(self, action: #selector(before_open_popup), for: .touchUpInside)
        
        // cell.btn_eyes_one.addTarget(self, action: #selector(eye_one_click_method), for: .touchUpInside)
        // cell.btn_eyes_two.addTarget(self, action: #selector(eye_two_click_method), for: .touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.img_upload.isUserInteractionEnabled = true
        cell.img_upload.addGestureRecognizer(tapGestureRecognizer)
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                
                cell.btnSignUp.setTitle("Submit", for: .normal)
                
            } else {
                cell.btnSignUp.setTitle("জমা দিন", for: .normal)
            }
            
        } else {
            print("=============================")
            print("LOGIN : Select language error")
            print("=============================")
            UserDefaults.standard.set("en", forKey: str_language_convert)
        }
        
        return cell
    }
    
    // 989013037178
    // VLMBIP
    
    
    
    @objc func accept_terms_click_method() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! edit_profile_table_cell
        
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
        return 1200
    }
    
}

class edit_profile_table_cell: UITableViewCell {

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
    
    @IBOutlet weak var btn_country:UIButton!
    
    @IBOutlet weak var txt_country:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_country,
                              tfName: txt_country.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .emailAddress,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Country")
            
            txt_country.layer.masksToBounds = false
            txt_country.layer.shadowColor = UIColor.black.cgColor
            txt_country.layer.shadowOffset =  CGSize.zero
            txt_country.layer.shadowOpacity = 0.5
            txt_country.layer.shadowRadius = 2
            
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
            
            txtEmailAddress.layer.masksToBounds = false
            txtEmailAddress.layer.shadowColor = UIColor.black.cgColor
            txtEmailAddress.layer.shadowOffset =  CGSize.zero
            txtEmailAddress.layer.shadowOpacity = 0.5
            txtEmailAddress.layer.shadowRadius = 2
            
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
    
    @IBOutlet weak var txt_confirm_password:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_confirm_password,
                              tfName: txt_confirm_password.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Confirm Password")
            
            txt_confirm_password.layer.masksToBounds = false
            txt_confirm_password.layer.shadowColor = UIColor.black.cgColor
            txt_confirm_password.layer.shadowOffset =  CGSize.zero
            txt_confirm_password.layer.shadowOpacity = 0.5
            txt_confirm_password.layer.shadowRadius = 2
            txt_confirm_password.isSecureTextEntry = true
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
            
            txt_full_name.layer.masksToBounds = false
            txt_full_name.layer.shadowColor = UIColor.black.cgColor
            txt_full_name.layer.shadowOffset =  CGSize.zero
            txt_full_name.layer.shadowOpacity = 0.5
            txt_full_name.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var txt_phone_code:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_phone_code,
                              tfName: txt_phone_code.text!,
                              tfCornerRadius: 12,
                              tfpadding: 0,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .numberPad,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "+91")
            
            txt_phone_code.layer.masksToBounds = false
            txt_phone_code.layer.shadowColor = UIColor.black.cgColor
            txt_phone_code.layer.shadowOffset =  CGSize.zero
            txt_phone_code.layer.shadowOpacity = 0.5
            txt_phone_code.layer.shadowRadius = 2
            
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
                              tfKeyboardType: .numberPad,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Phone Number")
            
            txt_phone_number.layer.masksToBounds = false
            txt_phone_number.layer.shadowColor = UIColor.black.cgColor
            txt_phone_number.layer.shadowOffset =  CGSize.zero
            txt_phone_number.layer.shadowOpacity = 0.5
            txt_phone_number.layer.shadowRadius = 2
            
        }
    }
    
    /*@IBOutlet weak var txt_nid_number:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_nid_number,
                              tfName: txt_nid_number.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .numberPad,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "NID No.")
            
            txt_nid_number.layer.masksToBounds = false
            txt_nid_number.layer.shadowColor = UIColor.black.cgColor
            txt_nid_number.layer.shadowOffset =  CGSize.zero
            txt_nid_number.layer.shadowOpacity = 0.5
            txt_nid_number.layer.shadowRadius = 2
            
            txt_nid_number.attributedPlaceholder = NSAttributedString(
                string: "NID No.",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
            
        }
    }*/
    
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
            
            txt_address.layer.masksToBounds = false
            txt_address.layer.shadowColor = UIColor.black.cgColor
            txt_address.layer.shadowOffset =  CGSize.zero
            txt_address.layer.shadowOpacity = 0.5
            txt_address.layer.shadowRadius = 2
            
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
            btnSignUp.isUserInteractionEnabled = false
            Utils.buttonStyle(button: btnSignUp,
                              bCornerRadius: 12,
                              bBackgroundColor: .lightGray,
                              bTitle: "Submit",
                              bTitleColor: .black)
            
            btnSignUp.layer.masksToBounds = false
            btnSignUp.layer.shadowColor = UIColor.black.cgColor
            btnSignUp.layer.shadowOffset =  CGSize.zero
            btnSignUp.layer.shadowOpacity = 0.5
            btnSignUp.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var btnSaveAndContinue:UIButton! {
        didSet {
            Utils.buttonStyle(button: btnSaveAndContinue,
                              bCornerRadius: 6,
                              bBackgroundColor: .black,
                              bTitle: "Sign In",
                              bTitleColor: .white)
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
            Utils.buttonStyle(button: btnDontHaveAnAccount,
                              bCornerRadius: 6,
                              bBackgroundColor: .clear,
                              bTitle: "Don't have an Account - Sign Up", bTitleColor: UIColor(red: 87.0/255.0, green: 77.0/255.0, blue: 112.0/255.0, alpha: 1))
        }
    }
    
    @IBOutlet weak var btn_eyes_one:UIButton! {
        didSet {
            btn_eyes_one.tag = 0
            btn_eyes_one.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
    @IBOutlet weak var btn_eyes_two:UIButton! {
        didSet {
            btn_eyes_two.tag = 0
            btn_eyes_two.setImage(UIImage(systemName: "eye.slash"), for: .normal)
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



