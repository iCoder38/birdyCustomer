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

// MARK:- LOCATION -
import CoreLocation

import GoogleSignIn

import FacebookCore
import FacebookLogin

// apple
import AuthenticationServices

class sign_up: UIViewController , UITextFieldDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ASAuthorizationControllerDelegate {
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
    
    var arr_country_array:NSArray!
    
    var str_user_select_image:String! = "0"
    var img_data_banner : Data!
    var img_Str_banner : String!
    
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
                    view_navigation_title.text = "Create an account"
                } else {
                    view_navigation_title.text = "অ্যাকাউন্ট তৈরি করুন"
                }
                
                view_navigation_title.textColor = .white
            }
        }
    }
    
    @IBOutlet weak var tbleView:UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.backgroundColor = .clear
        }
    }
    
    
    @IBOutlet weak var btn_back:UIButton!
    
    var str_country_id:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.btn_back.addTarget(self, action: #selector(back_click_method_3), for: .touchUpInside)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tbleView.cellForRow(at: indexPath) as! sign_up_table_cell
        self.tbleView.reloadData()
        
    }
    
    @objc func terms_condition_click_method() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "terms_and_conditions_id") as? terms_and_conditions
        self.navigationController?.pushViewController(push!, animated: true)
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
                    
                    self.country_click_method()
                    
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
    
    @objc func sign_up_WB() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! sign_up_table_cell
        
        self.view.endEditing(true)
        
        /*if (self.str_user_select_image == "0") {
            
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please upload Profile Picture"), style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            
            return
        }*/
        
        
        
        var phone_number_code : String!
        print(cell.txt_phone_number.text!.count)
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
            
        }/*  else if (cell.txt_address.text! == "") {
            
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please enter address"), style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            ERProgressHud.sharedInstance.hide()
            
            return
            
        }*/  else if (cell.txtPassword.text! == "") {
            
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please enter password"), style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            ERProgressHud.sharedInstance.hide()
            
            return
            
        }  else if (cell.txt_confirm_password.text! == "") {
            
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please enter confirm password"), style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            ERProgressHud.sharedInstance.hide()
            
            return
            
        }  else if (cell.txt_confirm_password.text! != cell.txtPassword.text!) {
            
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Password not matched"), style: .alert)
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
            
        }/* else if (cell.txt_phone_number.text!.count != 10) {
            
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please enter valid phone number"), style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            ERProgressHud.sharedInstance.hide()
            
            return
            
        } */else {
            
            /*if (cell.txt_phone_number.text!.count == 10) {
                
                if (self.arr_country_array == nil) {
                    phone_number_code = "+880"
                    self.str_country_id = "18"
                    
                } else {
                    for indexx in 0..<self.arr_country_array.count {
                        
                        let item = self.arr_country_array[indexx] as? [String:Any]
                        print(item as Any)
                        
                        if (cell.txt_country.text! == (item!["name"] as! String)) {
                            print("yes matched")
                            phone_number_code = (item!["phonecode"] as! String)
                            self.str_country_id = "\(item!["id"]!)"
                        }
                        
                    }
                }
                
            }  else */if (cell.txt_phone_number.text!.count == 10) {
                
                if (self.arr_country_array == nil) {
                    phone_number_code = "+880"
                    self.str_country_id = "18"
                } else {
                    for indexx in 0..<self.arr_country_array.count {
                        
                        let item = self.arr_country_array[indexx] as? [String:Any]
                        print(item as Any)
                        
                        if (cell.txt_country.text! == (item!["name"] as! String)) {
                            print("yes matched")
                            phone_number_code = (item!["phonecode"] as! String)
                            self.str_country_id = "\(item!["id"]!)"
                        }
                        
                    }
                }
                
            } else {
                
                let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please enter valid phone number"), style: .alert)
                let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                alert.addButtons([cancel])
                self.present(alert, animated: true)
                ERProgressHud.sharedInstance.hide()

                return
                
            }
            
        }
        
        // self.show_loading_UI()
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            } else {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "ড্রাইভার খোঁজা হচ্ছে")
            }
            
            
        }
        
        
        if (self.str_user_select_image == "0") {
             
            var str_device_token:String! = ""
            
            if let device_token = UserDefaults.standard.string(forKey: "key_my_device_token") {
                
                str_device_token = String(device_token)
            }
            
            // self.show_loading_UI()
            
            var parameters:Dictionary<AnyHashable, Any>!
  
                parameters = [
                    "action"        : "registration",
                    "fullName"      : String(cell.txt_full_name.text!),
                    "email"         : String(cell.txtEmailAddress.text!),
                    "countryCode"   : String(phone_number_code),
                    "contactNumber" : String(cell.txt_phone_number.text!),
                    "password"      : String(cell.txtPassword.text!),
                    "countryName"   : String(cell.txt_country.text!),
                   
                    "countryId"     : String(self.str_country_id),
                    "role"          : String("Member"),
                    // "address"  : String(""),
                    "longitude"     : String(""),
                    "device"        : String(""),
                    "deviceToken"   : String(str_device_token),
                ]
            
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
                        
                        if (JSON["status"] as! String) == "success" {
                            print("yes")
                            
                            var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            
                            let defaults = UserDefaults.standard
                            defaults.setValue(dict, forKey: str_save_login_user_data)
                            
                            // save email and password
                            let custom_email_pass = ["email"    : cell.txtEmailAddress.text!,
                                                     "password" : cell.txtPassword.text!]
                            
                            UserDefaults.standard.setValue(custom_email_pass, forKey: str_save_email_password)
                            
                            let alert = NewYorkAlertController(title: String("Success").uppercased(), message: (JSON["msg"] as! String), style: .alert)
                            let cancel = NewYorkButton(title: "Ok", style: .cancel)
                            alert.addButtons([cancel])
                            self.present(alert, animated: true)
                            
                            // self.hide_loading_UI()
                            ERProgressHud.sharedInstance.hide()
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        } else if (JSON["status"] as! String) == "Success" {
                            print("yes")
                            
                            var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            
                            let defaults = UserDefaults.standard
                            defaults.setValue(dict, forKey: str_save_login_user_data)
                            
                            // save email and password
                            let custom_email_pass = ["email"    : cell.txtEmailAddress.text!,
                                                     "password" : cell.txtPassword.text!]
                            
                            UserDefaults.standard.setValue(custom_email_pass, forKey: str_save_email_password)
                            
                            let alert = NewYorkAlertController(title: String("Success").uppercased(), message: (JSON["msg"] as! String), style: .alert)
                            let cancel = NewYorkButton(title: "Ok", style: .cancel)
                            alert.addButtons([cancel])
                            self.present(alert, animated: true)
                            
                            // self.hide_loading_UI()
                            ERProgressHud.sharedInstance.hide()
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        } else {
                            let alert = NewYorkAlertController(title: String("Success").uppercased(), message: (JSON["msg"] as! String), style: .alert)
                            let cancel = NewYorkButton(title: "Ok", style: .cancel)
                            alert.addButtons([cancel])
                            self.present(alert, animated: true)
                            ERProgressHud.sharedInstance.hide()
                        }
                        
                    }
                    
                case .failure(_):
                    print("Error message:\(String(describing: response.error))")
                    self.hide_loading_UI()
                    self.please_check_your_internet_connection()
                    
                    break
                }
            }
        } else {
            
            //Set Your URL
            let api_url = application_base_url
            guard let url = URL(string: api_url) else {
                return
            }
            
            var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "POST"
            // urlRequest.allHTTPHeaderFields = ["token":String(token_id_is)]
            urlRequest.addValue("application/json",
                                forHTTPHeaderField: "Accept")
            
            //Set Your Parameter
            let parameterDict = NSMutableDictionary()
            
            var str_device_token:String! = ""
            
            if let device_token = UserDefaults.standard.string(forKey: "key_my_device_token") {
                
                str_device_token = String(device_token)
            }
            
            // car information
            parameterDict.setValue("registration", forKey: "action")
            parameterDict.setValue(String(cell.txt_full_name.text!), forKey: "fullName")
            parameterDict.setValue(String(cell.txtEmailAddress.text!), forKey: "email")
            parameterDict.setValue(String(phone_number_code), forKey: "countryCode")
            parameterDict.setValue(String(cell.txt_phone_number.text!), forKey: "contactNumber")
            parameterDict.setValue(String(cell.txtPassword.text!), forKey: "password")
            parameterDict.setValue(String(cell.txt_country.text!), forKey: "countryName")
            parameterDict.setValue(String(self.str_country_id), forKey: "countryId")
            parameterDict.setValue("Member", forKey: "role")
            
            // parameterDict.setValue(String(cell.txt_address.text!), forKey: "address")
            parameterDict.setValue("", forKey: "latitude")
            parameterDict.setValue("", forKey: "longitude")
            parameterDict.setValue("iOS", forKey: "device")
            parameterDict.setValue(String(str_device_token), forKey: "deviceToken")
            
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
                multiPart.append(self.img_data_banner, withName: "image", fileName: "register.png", mimeType: "image/png")
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
                            let custom_email_pass = ["email"    : cell.txtEmailAddress.text!,
                                                     "password" : cell.txtPassword.text!]
                            
                            UserDefaults.standard.setValue(custom_email_pass, forKey: str_save_email_password)
                            
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
                            let custom_email_pass = ["email"    : cell.txtEmailAddress.text!,
                                                     "password" : cell.txtPassword.text!]
                            
                            UserDefaults.standard.setValue(custom_email_pass, forKey: str_save_email_password)
                            
                            let alert = NewYorkAlertController(title: String("Success").uppercased(), message: (dictionary["msg"] as! String), style: .alert)
                            let cancel = NewYorkButton(title: "Ok", style: .cancel)
                            alert.addButtons([cancel])
                            self.present(alert, animated: true)
                            
                            // self.hide_loading_UI()
                            ERProgressHud.sharedInstance.hide()
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        } else {
                            let alert = NewYorkAlertController(title: String("Success").uppercased(), message: (dictionary["msg"] as! String), style: .alert)
                            let cancel = NewYorkButton(title: "Ok", style: .cancel)
                            alert.addButtons([cancel])
                            self.present(alert, animated: true)
                            ERProgressHud.sharedInstance.hide()
                        }
                        
                    } catch {
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
        
        // }
    }
    
    @objc func upload_sign_up_data_without_image() {
        
    }
    
    
    @objc func alert_warning () {
        
        let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: "Field should not be empty.", style: .alert)
        let cancel = NewYorkButton(title: "Ok", style: .cancel)
        alert.addButtons([cancel])
        self.present(alert, animated: true)
        
    }
    
    @objc func before_open_popup() {
        self.get_country_list_WB()
    }
    @objc func country_click_method() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! sign_up_table_cell
        
        print(self.arr_country_array as Any)
        
        var arr_mut:NSMutableArray = []
        
        for index in 0..<self.arr_country_array.count {
            
            // print(self.arr_country_array[index])
            
            let item = self.arr_country_array[index] as? [String:Any]
            print(item as Any)
            
            arr_mut.add(item!["name"] as! String)
            
        }
        
        if let swiftArray = arr_mut as NSArray as? [String] {
            ERProgressHud.sharedInstance.hide()
            RPicker.selectOption(title: "Select", cancelText: "Cancel", dataArray: swiftArray, selectedIndex: 0) { (selctedText, atIndex) in
                cell.txt_country.text = String(selctedText)
                
                //
                for indexx in 0..<self.arr_country_array.count {
                    
                    let item = self.arr_country_array[indexx] as? [String:Any]
                    // print(item as Any)
                    
                    if (cell.txt_country.text! == (item!["name"] as! String)) {
                        print("yes matched")
                        cell.txt_phone_code.text = (item!["phonecode"] as! String)
                    }
                    
                }
                
                
            }
            
        }
        
    }

    @objc func eye_one_click_method() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! sign_up_table_cell
        
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
        let cell = self.tbleView.cellForRow(at: indexPath) as! sign_up_table_cell
        
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
        let cell = self.tbleView.cellForRow(at: indexPath) as! sign_up_table_cell
        
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
        let cell = self.tbleView.cellForRow(at: indexPath) as! sign_up_table_cell

        
        if (textField == cell.txt_phone_number) {
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // make sure the result is under 16 characters
            return updatedText.count <= 10
            
        
        }  else {
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // make sure the result is under 16 characters
            return updatedText.count <= 30
            
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
                        self.save_email(email: String(email))
                        //
                        
                        self.hide_loading_UI()
                        
                        self.push_to_dashboard()
                        
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
                        
                        self.push_to_dashboard()
                        
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

extension sign_up: UITableViewDataSource  , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:sign_up_table_cell = tableView.dequeueReusableCell(withIdentifier: "sign_up_table_cell") as! sign_up_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.txtEmailAddress.delegate = self
        cell.txtPassword.delegate = self
        // cell.txt_address.delegate = self
        cell.txt_full_name.delegate = self
         
        cell.txt_phone_number.delegate = self
        // cell.txt_nid_number.delegate = self
        
        cell.txt_country.delegate = self
        cell.txt_country.text = "Bangladesh"
        
        cell.txt_phone_code.text = "+880"
        
        //  cell.btn_accept_terms.addTarget(self, action: #selector(accept_terms_click_method), for: .touchUpInside)
        
        cell.btnSignUp.addTarget(self, action: #selector(sign_up_click_method), for: .touchUpInside)
        
        cell.btn_country.addTarget(self, action: #selector(before_open_popup), for: .touchUpInside)
        
        cell.btn_eyes_one.addTarget(self, action: #selector(eye_one_click_method), for: .touchUpInside)
        cell.btn_eyes_two.addTarget(self, action: #selector(eye_two_click_method), for: .touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.img_upload.isUserInteractionEnabled = true
        cell.img_upload.addGestureRecognizer(tapGestureRecognizer)
        
        cell.btn_terms_and_condition.addTarget(self, action: #selector(terms_condition_click_method), for: .touchUpInside)
        cell.btn_disclaimer.isHidden = true
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                cell.btn_terms_and_condition.setTitle("Terms and Conditions", for: .normal)
                cell.btn_disclaimer.setTitle("", for: .normal)
                cell.btnSignUp.setTitle("Create an account", for: .normal)
                
                Utils.textFieldUI(textField: cell.txt_country,
                                  tfName: cell.txt_country.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .emailAddress,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "Bangladesh")
                
                
                Utils.textFieldUI(textField: cell.txtEmailAddress,
                                  tfName: cell.txtEmailAddress.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .emailAddress,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "Email Address")
                
                Utils.textFieldUI(textField: cell.txtPassword,
                                  tfName: cell.txtPassword.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .default,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "Password")
                
                Utils.textFieldUI(textField: cell.txt_confirm_password,
                                  tfName: cell.txt_confirm_password.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .default,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "Confirm Password")
                
                Utils.textFieldUI(textField: cell.txt_full_name,
                                  tfName: cell.txt_full_name.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .default,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "Full name")
                
                Utils.textFieldUI(textField: cell.txt_phone_code,
                                  tfName: cell.txt_phone_code.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 0,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .numberPad,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "+880")
                
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        Utils.textFieldUI(textField: cell.txt_phone_number,
                                          tfName: cell.txt_phone_number.text!,
                                          tfCornerRadius: 12,
                                          tfpadding: 20,
                                          tfBorderWidth: 0,
                                          tfBorderColor: .clear,
                                          tfAppearance: .dark,
                                          tfKeyboardType: .numberPad,
                                          tfBackgroundColor: .white,
                                          tfPlaceholderText: "Mobile number")
                    } else {
                        Utils.textFieldUI(textField: cell.txt_phone_number,
                                          tfName: cell.txt_phone_number.text!,
                                          tfCornerRadius: 12,
                                          tfpadding: 20,
                                          tfBorderWidth: 0,
                                          tfBorderColor: .clear,
                                          tfAppearance: .dark,
                                          tfKeyboardType: .numberPad,
                                          tfBackgroundColor: .white,
                                          tfPlaceholderText: "মোবাইল নম্বর")
                    }
                    
                }
                
                
                
                /*Utils.textFieldUI(textField: cell.txt_address,
                                  tfName: cell.txt_address.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .default,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "Address")*/
                
                
            } else {
                cell.btn_terms_and_condition.setTitle("শর্তাদি ও নীতিমালাসমূহ", for: .normal)
                cell.btnSignUp.setTitle("অ্যাকাউন্ট তৈরি করুন", for: .normal)
                
                Utils.textFieldUI(textField: cell.txt_country,
                                  tfName: cell.txt_country.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .emailAddress,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "Bangladesh")
                
                
                Utils.textFieldUI(textField: cell.txtEmailAddress,
                                  tfName: cell.txtEmailAddress.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .emailAddress,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "ই-মেইল")
                
                Utils.textFieldUI(textField: cell.txtPassword,
                                  tfName: cell.txtPassword.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .default,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "পাসওয়ার্ড")
                
                Utils.textFieldUI(textField: cell.txt_confirm_password,
                                  tfName: cell.txt_confirm_password.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .default,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "পাসওয়ার্ড নিশ্চিত করুন")
                
                Utils.textFieldUI(textField: cell.txt_full_name,
                                  tfName: cell.txt_full_name.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .default,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "পুরো নাম")
                
                Utils.textFieldUI(textField: cell.txt_phone_code,
                                  tfName: cell.txt_phone_code.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 0,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .numberPad,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "+880")
                
                Utils.textFieldUI(textField: cell.txt_phone_number,
                                  tfName: cell.txt_phone_number.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .numberPad,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "ফোন নম্বর")
                
                /*Utils.textFieldUI(textField: cell.txt_address,
                                  tfName: cell.txt_address.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .default,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "ঠিকানা")*/
                
            }
            
        } else {
            print("=============================")
            print("LOGIN : Select language error")
            print("=============================")
            UserDefaults.standard.set("en", forKey: str_language_convert)
        }
        
        
        
        
        
        
        if let loadedString = UserDefaults.standard.string(forKey: "key_accept_term") {
            print(loadedString)
            
            // let string = "yes_terms"
            UserDefaults.standard.set("", forKey: "key_accept_term")
            UserDefaults.standard.set(nil, forKey: "key_accept_term")
            
            // cell.btn_accept_terms.tag = 1
            cell.btn_accept_terms.setImage(UIImage(named: "rem"), for: .normal)
            cell.btn_accept_terms.backgroundColor = .clear
            cell.btnSignUp.backgroundColor = UIColor(red: 246.0/255.0, green: 200.0/255.0, blue: 68.0/255.0, alpha: 1)
            cell.btnSignUp.isUserInteractionEnabled = true
        } else {
            // cell.btn_accept_terms.setImage(UIImage(named: "rem1"), for: .normal)
            cell.btn_accept_terms.backgroundColor = .systemGray4
            // cell.btn_accept_terms.tag = 0
            cell.btnSignUp.backgroundColor = .lightGray
            cell.btnSignUp.isUserInteractionEnabled = false
        }
        
        // cell.btn_google.addTarget(self, action: #selector(signInViaGoogle), for: .touchUpInside)
        // cell.btn_facebook.addTarget(self, action: #selector(signInViaFacebook), for: .touchUpInside)
        
        // apple
         // func setUpSignInAppleButton() {
        /*let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        authorizationButton.cornerRadius = 10
        // authorizationButton.center = cell.view_apple.center
          //Add button on some view or stack
        cell.view_apple.addSubview(authorizationButton)*/
        
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
                         
                        self.push_to_dashboard()
                        
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
                        
                        self.push_to_dashboard()
                        
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
    
    @objc func sign_up_click_method() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! sign_up_table_cell
        
        
        
        self.sign_up_WB()
    }
    
    @objc func accept_terms_click_method() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! sign_up_table_cell
        
        if cell.btn_accept_terms.tag == 1 {
            
            cell.btn_accept_terms.setImage(UIImage(named: "rem1"), for: .normal)
            cell.btn_accept_terms.tag = 0
            cell.btnSignUp.backgroundColor = .lightGray
            cell.btnSignUp.isUserInteractionEnabled = false
            
        } else {
            
            cell.btn_accept_terms.tag = 1
            cell.btn_accept_terms.setImage(UIImage(named: "rem"), for: .normal)
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

class sign_up_table_cell: UITableViewCell {

    @IBOutlet weak var header_full_view_navigation_bar:UIView! {
        didSet {
            header_full_view_navigation_bar.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var header_half_view_navigation_bar:UIView! {
        didSet {
            header_half_view_navigation_bar.backgroundColor = navigation_color
            header_half_view_navigation_bar.applyGradient()
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
            
            
            txt_country.layer.masksToBounds = false
            txt_country.layer.shadowColor = UIColor.black.cgColor
            txt_country.layer.shadowOffset =  CGSize.zero
            txt_country.layer.shadowOpacity = 0.5
            txt_country.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var txtEmailAddress:UITextField! {
        didSet {
            
            
            txtEmailAddress.layer.masksToBounds = false
            txtEmailAddress.layer.shadowColor = UIColor.black.cgColor
            txtEmailAddress.layer.shadowOffset =  CGSize.zero
            txtEmailAddress.layer.shadowOpacity = 0.5
            txtEmailAddress.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var txtPassword:UITextField! {
        didSet {
            
            
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
            
           
            
            txt_full_name.layer.masksToBounds = false
            txt_full_name.layer.shadowColor = UIColor.black.cgColor
            txt_full_name.layer.shadowOffset =  CGSize.zero
            txt_full_name.layer.shadowOpacity = 0.5
            txt_full_name.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var txt_phone_code:UITextField! {
        didSet {
            
            
            
            txt_phone_code.layer.masksToBounds = false
            txt_phone_code.layer.shadowColor = UIColor.black.cgColor
            txt_phone_code.layer.shadowOffset =  CGSize.zero
            txt_phone_code.layer.shadowOpacity = 0.5
            txt_phone_code.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var txt_phone_number:UITextField! {
        didSet {
            
           
            
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
    
    /*@IBOutlet weak var txt_address:UITextField! {
        didSet {
           
            
            txt_address.layer.masksToBounds = false
            txt_address.layer.shadowColor = UIColor.black.cgColor
            txt_address.layer.shadowOffset =  CGSize.zero
            txt_address.layer.shadowOpacity = 0.5
            txt_address.layer.shadowRadius = 2
            
        }
    }*/
    @IBOutlet weak var view_apple:UIView!
    @IBOutlet weak var btn_google:UIButton!
    @IBOutlet weak var btn_facebook:UIButton!
    @IBOutlet weak var btn_accept_terms:UIButton! {
        didSet {
            btn_accept_terms.backgroundColor = .systemGray4
            btn_accept_terms.tag = 0
            btn_accept_terms.layer.cornerRadius = 12
            btn_accept_terms.clipsToBounds = true
            // btn_accept_terms.setImage(UIImage(named: "rem1"), for: .normal)
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
                              bTitle: "Create an account",
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
    
    @IBOutlet weak var btn_terms_and_condition:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


