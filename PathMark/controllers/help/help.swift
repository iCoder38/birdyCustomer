//
//  help.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 11/08/23.
//

import UIKit
import Alamofire

class help: UIViewController {

    var str_whats_app:String!
    var str_phone_number:String!
    var str_email_address:String!
    
    @IBOutlet weak var btn_back:UIButton! {
        didSet {
            btn_back.tintColor = .white
            btn_back.isUserInteractionEnabled = true
        }
    }
    
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
                   view_navigation_title.text = "HELP"
               } else {
                   view_navigation_title.text = "হেল্প"
               }
               
            
           }
            view_navigation_title.textColor = .white
        }
    }
    @IBOutlet weak var lbl_contact_us:UILabel! {
        didSet {
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
               print(language as Any)
               
               if (language == "en") {
                   lbl_contact_us.text = "Contact Us"
               } else {
                   lbl_contact_us.text = "যোগাযোগ করুন"
               }
               
            
           }
             
        }
    }
    @IBOutlet weak var lbl_whatsapp:UILabel!
    @IBOutlet weak var lbl_email:UILabel!
    @IBOutlet weak var lbl_contact_number:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sideBarMenu()
        
        self.help_wb(str_show_loader: "yes")
    }

    @objc func sideBarMenu() {
        
        if revealViewController() != nil {
            
            self.btn_back.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
    }
    
    @objc func help_wb(str_show_loader:String) {
        
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
                    "action"        : "help",
                    
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
                            
                            
                            
                            self.str_whats_app = ""
                            self.str_phone_number = (dict["eamil"] as! String)
                            self.str_email_address = (dict["phone"] as! String)
                            
                            self.lbl_whatsapp.text = "Whatsapp : "
                            
                            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                               print(language as Any)
                               
                               if (language == "en") {
                                   self.lbl_contact_number.text = "E-mail : "+(dict["eamil"] as! String)
                                   self.lbl_email.text = "Contact number : "+(dict["phone"] as! String)
                               } else {
                                   self.lbl_contact_number.text = "ইমেইল : "+(dict["eamil"] as! String)
                                   self.lbl_email.text = "যোগাযোগের নম্বর : "+(dict["phone"] as! String)
                               }
                               
                            
                           }
                            
                            
                            
                            
                            ERProgressHud.sharedInstance.hide()
                            self.dismiss(animated: true)
                            
                            
                            // self.get_todays_earning_WB(str_show_loader: "no")
                            
                        } else if message == String(not_authorize_api) {
                            // self.login_refresh_token_wb()
                            
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
    
}

