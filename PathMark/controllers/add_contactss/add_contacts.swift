//
//  add_contacts.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 11/08/23.
//

import UIKit
import Alamofire

class add_contacts: UIViewController , UITextFieldDelegate {

    var dict_emergency:NSDictionary!
    var arr_country_array:NSArray!
    @IBOutlet weak var btn_back:UIButton! {
        didSet {
            btn_back.tintColor = .white
        }
    }
    
    @IBOutlet weak var view_navigation_bar:UIView! {
        didSet {
            view_navigation_bar.applyGradient()
        }
    }
    
    @IBOutlet weak var view_navigation_title:UILabel! {
        didSet {
            view_navigation_title.textColor = .white
        }
    }
    @IBOutlet weak var btn_country:UIButton!
    @IBOutlet weak var txt_full_name:UITextField! {
        didSet {
            // shadow
            txt_full_name.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_full_name.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_full_name.layer.shadowOpacity = 1.0
            txt_full_name.layer.shadowRadius = 10.0
            txt_full_name.layer.masksToBounds = false
            txt_full_name.layer.cornerRadius = 12
            txt_full_name.backgroundColor = .white
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_full_name.frame.height))
            txt_full_name.leftView = paddingView
            txt_full_name.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var txt_email:UITextField! {
        didSet {
            // shadow
            txt_email.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_email.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_email.layer.shadowOpacity = 1.0
            txt_email.layer.shadowRadius = 10.0
            txt_email.layer.masksToBounds = false
            txt_email.layer.cornerRadius = 12
            txt_email.backgroundColor = .white
            txt_email.keyboardType = .emailAddress
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_email.frame.height))
            txt_email.leftView = paddingView
            txt_email.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var txt_phone:UITextField! {
        didSet {
            // shadow
            txt_phone.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_phone.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_phone.layer.shadowOpacity = 1.0
            txt_phone.layer.shadowRadius = 10.0
            txt_phone.layer.masksToBounds = false
            txt_phone.layer.cornerRadius = 12
            txt_phone.backgroundColor = .white
            txt_phone.keyboardType = .numberPad
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_phone.frame.height))
            txt_phone.leftView = paddingView
            txt_phone.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    var str_relation_text:String!
    @IBOutlet weak var btn_relation:UIButton!
    @IBOutlet weak var txt_relation:UITextField! {
        didSet {
            // shadow
            txt_relation.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_relation.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_relation.layer.shadowOpacity = 1.0
            txt_relation.layer.shadowRadius = 10.0
            txt_relation.layer.masksToBounds = false
            txt_relation.layer.cornerRadius = 12
            txt_relation.backgroundColor = .white
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_relation.frame.height))
            txt_relation.leftView = paddingView
            txt_relation.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var txt_country:UITextField! {
        didSet {
            // shadow
            txt_country.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_country.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_country.layer.shadowOpacity = 1.0
            txt_country.layer.shadowRadius = 10.0
            txt_country.layer.masksToBounds = false
            txt_country.layer.cornerRadius = 12
            txt_country.backgroundColor = .white
            txt_country.keyboardType = .numberPad
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_country.frame.height))
            txt_country.leftView = paddingView
            txt_country.leftViewMode = UITextField.ViewMode.always
        }
    }
    @IBOutlet weak var txt_phone_code:UITextField! {
        didSet {
            // shadow
            txt_phone_code.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_phone_code.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_phone_code.layer.shadowOpacity = 1.0
            txt_phone_code.layer.shadowRadius = 10.0
            txt_phone_code.layer.masksToBounds = false
            txt_phone_code.layer.cornerRadius = 12
            txt_phone_code.backgroundColor = .white
            txt_phone_code.keyboardType = .numberPad
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_phone_code.frame.height))
            txt_phone_code.leftView = paddingView
            txt_phone_code.leftViewMode = UITextField.ViewMode.always
        }
    }
    @IBOutlet weak var btn_submit:UIButton! {
        didSet {
            btn_submit.setTitle("SUBMIT", for: .normal)
            btn_submit.setTitleColor(.white, for: .normal)
            btn_submit.layer.cornerRadius = 6
            btn_submit.clipsToBounds = true
            btn_submit.backgroundColor = UIColor.init(red: 104.0/255.0, green: 218.0/255.0, blue: 134.0/255.0, alpha: 1)
            
            // shadow
            btn_submit.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_submit.layer.shadowOffset = CGSize(width: 0, height: 3)
            btn_submit.layer.shadowOpacity = 1.0
            btn_submit.layer.shadowRadius = 10.0
            btn_submit.layer.masksToBounds = false
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.btn_back.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        self.btn_submit.addTarget(self, action: #selector(check_validate), for: .touchUpInside)
        
        self.btn_country.addTarget(self, action: #selector(before_open_popup), for: .touchUpInside)
        self.txt_country.text = "Bangladesh"
        self.txt_phone_code.text = "+880"
        self.txt_phone.delegate = self
        
        if (self.dict_emergency == nil) {
            print("add contact")
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    view_navigation_title.text = "NEW CONTACTS"
                    btn_submit.setTitle("SUBMIT", for: .normal)
                    
                    self.txt_full_name.placeholder = "Full name"
                    self.txt_email.placeholder = "Email address"
                    self.txt_phone.placeholder = "Phone number"
                    self.txt_relation.placeholder = "Relation"
                    
                } else {
                    view_navigation_title.text = "নতুন পরিচিতি যোগ করুন"
                    btn_submit.setTitle("জমা দিন", for: .normal)
                    
                    self.txt_full_name.placeholder = "পুরো নাম"
                    self.txt_email.placeholder = "ইমেইল ঠিকানা"
                    self.txt_phone.placeholder = "ফোন নম্বর"
                    self.txt_relation.placeholder = "সম্পর্ক"
                    
                }
                
            }
            
        } else {
            print("edit contact")
            
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    self.view_navigation_title.text = "EDIT CONTACTS"
                    btn_submit.setTitle("SUBMIT", for: .normal)
                    
                    self.txt_full_name.placeholder = "Full name"
                    self.txt_email.placeholder = "Email address"
                    self.txt_phone.placeholder = "Phone number"
                    self.txt_relation.placeholder = "Relation"
                    
                } else {
                    self.view_navigation_title.text = "নতুন পরিচিতি যোগ করুন"
                    btn_submit.setTitle("জমা দিন", for: .normal)
                    
                    self.txt_full_name.placeholder = "পুরো নাম"
                    self.txt_email.placeholder = "ইমেইল ঠিকানা"
                    self.txt_phone.placeholder = "ফোন নম্বর"
                    self.txt_relation.placeholder = "সম্পর্ক"
                    
                }
                
            }
            
            
            self.txt_full_name.text = (self.dict_emergency["Name"] as! String)
            self.txt_email.text = (self.dict_emergency["email"] as! String)
            self.txt_phone.text = (self.dict_emergency["phone"] as! String)
            
            
            
            if ("\(self.dict_emergency["relation"]!)" == "0") {
                
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        self.txt_relation.text = "Friend"
                        
                    } else {
                        self.txt_relation.text = "বন্ধু"
                        
                    }
                    
                }
                
                
                self.str_relation_text = "0"
            } else if ("\(self.dict_emergency["relation"]!)" == "1") {
                 
                
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        self.txt_relation.text = "Family"
                        
                    } else {
                        self.txt_relation.text = "পরিবার"
                        
                    }
                    
                }
                
                self.str_relation_text = "1"
            } else {
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        self.txt_relation.text = "Other"
                        
                    } else {
                        self.txt_relation.text = "অন্যান্য"
                        
                    }
                    
                }
                self.str_relation_text = "2"
            }
            
        }
        
        self.btn_relation.addTarget(self, action: #selector(open_relation_drop_down), for: .touchUpInside)
        
    }
    @objc func before_open_popup() {
        self.get_country_list_WB()
    }
    @objc func country_click_method() {
         
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
                self.txt_country.text = String(selctedText)
                
                //
                for indexx in 0..<self.arr_country_array.count {
                    
                    let item = self.arr_country_array[indexx] as? [String:Any]
                    // print(item as Any)
                    
                    if (self.txt_country.text! == (item!["name"] as! String)) {
                        print("yes matched")
                        self.txt_phone_code.text = (item!["phonecode"] as! String)
                    }
                    
                }
                
                
            }
            
        }
        
    }
    @objc func open_relation_drop_down() {
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                let arr_relation = ["Friend", "Family", "Other"]
                RPicker.selectOption(title: "Select", cancelText: "Cancel", dataArray: arr_relation, selectedIndex: 0) { (selctedText, atIndex) in
                    self.txt_relation.text = String(selctedText)
                    
                }
            } else {
                let arr_relation = ["বন্ধু", "পরিবার", "অন্য"]
                RPicker.selectOption(title: "নির্বাচন করুন", cancelText: "বাতিল করুন", dataArray: arr_relation, selectedIndex: 0) { (selctedText, atIndex) in
                    self.txt_relation.text = String(selctedText)
                    
                }
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    
    @objc func check_validate() {
        if (self.dict_emergency == nil) {
            print("add contact")
            
            if (self.txt_phone.text!.count == 11) {
                self.add_emergency_phone()
            }/* else if (self.txt_phone.text!.count == 11) {
                self.add_emergency_phone()
            } */else {
                
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        let alert = NewYorkAlertController(title: nil, message: String("Please enter valid phone number"), style: .alert)
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                        ERProgressHud.sharedInstance.hide()
                        
                    } else {
                        let alert = NewYorkAlertController(title: nil, message: String("দয়া করে সঠিক ফোন নম্বর লিখুন"), style: .alert)
                        let cancel = NewYorkButton(title: "বরখাস্ত করা", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                        ERProgressHud.sharedInstance.hide()
                        
                    }
                    
                }
                
                
            }
            
        } else {
            print("edit contact")
            
            if (self.txt_phone.text!.count == 11) {
                self.check_edit_or_add_contact_WB()
            }/* else if (self.txt_phone.text!.count == 11) {
                self.check_edit_or_add_contact_WB()
            } */else {
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        let alert = NewYorkAlertController(title: nil, message: String("Please enter valid phone number"), style: .alert)
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                        ERProgressHud.sharedInstance.hide()
                        
                    } else {
                        let alert = NewYorkAlertController(title: nil, message: String("দয়া করে সঠিক ফোন নম্বর লিখুন"), style: .alert)
                        let cancel = NewYorkButton(title: "বরখাস্ত করা", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                        ERProgressHud.sharedInstance.hide()
                        
                    }
                    
                }
                 
            }
        }
    }
    @objc func check_edit_or_add_contact_WB() {
        
        // self.show_loading_UI()
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "editing...")
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                print(token_id_is as Any)
                
                let headers: HTTPHeaders = [
                     "token":String(token_id_is),
                ]
                
                //
                if (self.txt_relation.text! == "Friend") {
                    self.str_relation_text = "0"
                } else if (self.txt_relation.text! == "Family") {
                    self.str_relation_text = "1"
                } else if (self.txt_relation.text! == "Other") {
                    self.str_relation_text = "2"
                } else if (self.txt_relation.text! == "বন্ধু") {
                    self.str_relation_text = "0"
                } else if (self.txt_relation.text! == "পরিবার") {
                    self.str_relation_text = "1"
                } else {
                    self.str_relation_text = "2"
                }
                
                
                var lan:String!
                
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        lan = "en"
                    } else {
                        lan = "bn"
                    }
                }
                
                
                parameters = [
                    "action"    : "emergencyadd",
                    "addressId" : "\(self.dict_emergency["emergencyId"]!)",
                    "userId"    : String(myString),
                    "Name"      : String(self.txt_full_name.text!),
                    "phone"     : String(self.txt_phone.text!),
                    "relation"  : String(self.str_relation_text),
                    "email"     : String(self.txt_email.text!),
                    "language"  : String(lan)
                ]
                
                print(headers)
                print("parameters-------\(String(describing: parameters))")
                
                AF.request(application_base_url, method: .post, parameters: parameters as? Parameters,headers: headers).responseJSON {
                    response in
                    
                    switch(response.result) {
                    case .success(_):
                        if let data = response.value {
                            
                            let JSON = data as! NSDictionary
                            print(JSON)
                            
                            var strSuccess : String!
                            strSuccess = JSON["status"] as? String
                            // self.hide_loading_UI()
                            
                            if strSuccess.lowercased() == "success" {
                                
                                let str_token = (JSON["AuthToken"] as! String)
                                UserDefaults.standard.set("", forKey: str_save_last_api_token)
                                UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                                
                                ERProgressHud.sharedInstance.hide()
                                self.back_click_method()

                            }
                            else {
                                print("two")
                                ERProgressHud.sharedInstance.hide()
                                self.hide_loading_UI()
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
        }
    }
    
    @objc func add_emergency_phone() {
        
        // self.show_loading_UI()
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            } else {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "ড্রাইভার খোঁজা হচ্ছে")
            }
            
        }
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                print(token_id_is as Any)
                
                let headers: HTTPHeaders = [
                     "token":String(token_id_is),
                ]
                
                //
                if (self.txt_relation.text! == "Friend") {
                    self.str_relation_text = "0"
                } else if (self.txt_relation.text! == "Family") {
                    self.str_relation_text = "1"
                } else if (self.txt_relation.text! == "Other") {
                    self.str_relation_text = "2"
                } else if (self.txt_relation.text! == "বন্ধু") {
                    self.str_relation_text = "0"
                } else if (self.txt_relation.text! == "পরিবার") {
                    self.str_relation_text = "1"
                } else {
                    self.str_relation_text = "2"
                }
                
                var lan:String!
                
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        lan = "en"
                    } else {
                        lan = "bn"
                    }
                }
                
                parameters = [
                    "action"    : "emergencyadd",
                    "userId"    : String(myString),
                    "Name"      : String(self.txt_full_name.text!),
                    "phone"     : String(self.txt_phone.text!),
                    "relation"  : String(self.str_relation_text),
                    "email"     : String(self.txt_email.text!),
                    "language"  : String(lan)
                ]
                
                print(headers)
                print("parameters-------\(String(describing: parameters))")
                
                AF.request(application_base_url, method: .post, parameters: parameters as? Parameters,headers: headers).responseJSON {
                    response in
                    
                    switch(response.result) {
                    case .success(_):
                        if let data = response.value {
                            
                            let JSON = data as! NSDictionary
                            print(JSON)
                            
                            var strSuccess : String!
                            strSuccess = JSON["status"] as? String
                            // self.hide_loading_UI()
                            
                            if strSuccess.lowercased() == "success" {
                                
                                let str_token = (JSON["AuthToken"] as! String)
                                UserDefaults.standard.set("", forKey: str_save_last_api_token)
                                UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                                
                                ERProgressHud.sharedInstance.hide()
                                self.back_click_method()

                            }
                            else {
                                print("two")
                                ERProgressHud.sharedInstance.hide()
                                self.hide_loading_UI()
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
        }
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == self.txt_phone) {
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // make sure the result is under 16 characters
            return updatedText.count <= 11
            
        
        }  else {
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // make sure the result is under 16 characters
            return updatedText.count <= 30
            
        }
        
    }
}

