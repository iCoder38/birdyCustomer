//
//  decline_request.swift
//  PathMark
//
//  Created by Dishant Rajput on 22/11/23.
//

import UIKit
import Alamofire

class decline_request: UIViewController {

    /*
     
     */
    var counter = 2
    var timer:Timer!
    var dict_booking_details:NSDictionary!
    var window: UIWindow?
    @IBOutlet weak var view_bg:UIView! {
        didSet {
            view_bg.layer.cornerRadius = 12
            view_bg.clipsToBounds = true
            view_bg.backgroundColor = .white
            view_bg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_bg.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_bg.layer.shadowOpacity = 1.0
            view_bg.layer.shadowRadius = 15.0
            view_bg.layer.masksToBounds = false
        }
    }
    
    @IBOutlet weak var txt_view:UITextView! {
        didSet {
            txt_view.layer.cornerRadius = 12
            txt_view.clipsToBounds = true
            txt_view.layer.borderColor = UIColor.gray.cgColor
            txt_view.layer.borderWidth = 1
            txt_view.text = ""
        }
    }
    
    @IBOutlet weak var lbl_one:UILabel! {
        didSet {
            lbl_one.layer.cornerRadius = 12
            lbl_one.clipsToBounds = true
            lbl_one.backgroundColor = .gray
            lbl_one.layer.borderColor = UIColor.gray.cgColor
            lbl_one.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var lbl_two:UILabel! {
        didSet {
            lbl_two.layer.cornerRadius = 12
            lbl_two.clipsToBounds = true
            lbl_two.backgroundColor = .gray
            lbl_two.layer.borderColor = UIColor.gray.cgColor
            lbl_two.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var lbl_three:UILabel! {
        didSet {
            lbl_three.layer.cornerRadius = 12
            lbl_three.clipsToBounds = true
            lbl_three.backgroundColor = .gray
            lbl_three.layer.borderColor = UIColor.gray.cgColor
            lbl_three.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var lbl_four:UILabel! {
        didSet {
            lbl_four.layer.cornerRadius = 12
            lbl_four.clipsToBounds = true
            lbl_four.backgroundColor = .gray
            lbl_four.layer.borderColor = UIColor.gray.cgColor
            lbl_four.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var lbl_five:UILabel! {
        didSet {
            lbl_five.layer.cornerRadius = 12
            lbl_five.clipsToBounds = true
            lbl_five.backgroundColor = .gray
            lbl_five.layer.borderColor = UIColor.gray.cgColor
            lbl_five.layer.borderWidth = 1
        }
    }
    
    @IBOutlet weak var btn_dismiss:UIButton!
    @IBOutlet weak var btn_cancel_ride:UIButton!
    
    var str_reason_select = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*// keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)*/
        
        print(self.dict_booking_details as Any)
        
        // dismiss popup
        self.btn_dismiss.addTarget(self, action: #selector(dismiss_click_method), for: .touchUpInside)
        self.btn_cancel_ride.addTarget(self, action: #selector(cancel_ride_click_method), for: .touchUpInside)
        
        // outside
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        // label one
        let tap_label_one = UITapGestureRecognizer(target: self, action: #selector(lbl_one_click_method))
        self.lbl_one.isUserInteractionEnabled = true
        self.lbl_one.addGestureRecognizer(tap_label_one)
        
        // label one
        let tap_label_two = UITapGestureRecognizer(target: self, action: #selector(lbl_two_click_method))
        self.lbl_two.isUserInteractionEnabled = true
        self.lbl_two.addGestureRecognizer(tap_label_two)
        
        // label one
        let tap_label_three = UITapGestureRecognizer(target: self, action: #selector(lbl_three_click_method))
        self.lbl_three.isUserInteractionEnabled = true
        self.lbl_three.addGestureRecognizer(tap_label_three)
        
        // label one
        let tap_label_four = UITapGestureRecognizer(target: self, action: #selector(lbl_four_click_method))
        self.lbl_four.isUserInteractionEnabled = true
        self.lbl_four.addGestureRecognizer(tap_label_four)
        
        // label one
        let tap_label_five = UITapGestureRecognizer(target: self, action: #selector(lbl_five_click_method))
        self.lbl_five.isUserInteractionEnabled = true
        self.lbl_five.addGestureRecognizer(tap_label_five)
        
    }
    
    @objc override func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func dismiss_click_method() {
        self.dismiss(animated: true)
    }
    
    @objc func lbl_one_click_method() {
        self.str_reason_select = "Diver denied to go to destination"
        // one
        lbl_one.layer.cornerRadius = 12
        lbl_one.clipsToBounds = true
        lbl_one.backgroundColor = .systemRed
        lbl_one.layer.borderColor = UIColor.gray.cgColor
        lbl_one.layer.borderWidth = 1
        
        // two
        lbl_two.layer.cornerRadius = 12
        lbl_two.clipsToBounds = true
        lbl_two.backgroundColor = .gray
        lbl_two.layer.borderColor = UIColor.gray.cgColor
        lbl_two.layer.borderWidth = 1
        
        // three
        lbl_three.layer.cornerRadius = 12
        lbl_three.clipsToBounds = true
        lbl_three.backgroundColor = .gray
        lbl_three.layer.borderColor = UIColor.gray.cgColor
        lbl_three.layer.borderWidth = 1
        
        // four
        lbl_four.layer.cornerRadius = 12
        lbl_four.clipsToBounds = true
        lbl_four.backgroundColor = .gray
        lbl_four.layer.borderColor = UIColor.gray.cgColor
        lbl_four.layer.borderWidth = 1
        
        // five
        lbl_five.layer.cornerRadius = 12
        lbl_five.clipsToBounds = true
        lbl_five.backgroundColor = .gray
        lbl_five.layer.borderColor = UIColor.gray.cgColor
        lbl_five.layer.borderWidth = 1
    }
    
    @objc func lbl_two_click_method() {
        self.str_reason_select = "Diver denied to come to pickup"
        // one
        lbl_one.layer.cornerRadius = 12
        lbl_one.clipsToBounds = true
        lbl_one.backgroundColor = .gray
        lbl_one.layer.borderColor = UIColor.gray.cgColor
        lbl_one.layer.borderWidth = 1
        
        // two
        lbl_two.layer.cornerRadius = 12
        lbl_two.clipsToBounds = true
        lbl_two.backgroundColor = .systemRed
        lbl_two.layer.borderColor = UIColor.gray.cgColor
        lbl_two.layer.borderWidth = 1
        
        // three
        lbl_three.layer.cornerRadius = 12
        lbl_three.clipsToBounds = true
        lbl_three.backgroundColor = .gray
        lbl_three.layer.borderColor = UIColor.gray.cgColor
        lbl_three.layer.borderWidth = 1
        
        // four
        lbl_four.layer.cornerRadius = 12
        lbl_four.clipsToBounds = true
        lbl_four.backgroundColor = .gray
        lbl_four.layer.borderColor = UIColor.gray.cgColor
        lbl_four.layer.borderWidth = 1
        
        // five
        lbl_five.layer.cornerRadius = 12
        lbl_five.clipsToBounds = true
        lbl_five.backgroundColor = .gray
        lbl_five.layer.borderColor = UIColor.gray.cgColor
        lbl_five.layer.borderWidth = 1
    }
    
    @objc func lbl_three_click_method() {
        self.str_reason_select = "Expected a shorter wait time"
        // one
        lbl_one.layer.cornerRadius = 12
        lbl_one.clipsToBounds = true
        lbl_one.backgroundColor = .gray
        lbl_one.layer.borderColor = UIColor.gray.cgColor
        lbl_one.layer.borderWidth = 1
        
        // two
        lbl_two.layer.cornerRadius = 12
        lbl_two.clipsToBounds = true
        lbl_two.backgroundColor = .gray
        lbl_two.layer.borderColor = UIColor.gray.cgColor
        lbl_two.layer.borderWidth = 1
        
        // three
        lbl_three.layer.cornerRadius = 12
        lbl_three.clipsToBounds = true
        lbl_three.backgroundColor = .systemRed
        lbl_three.layer.borderColor = UIColor.gray.cgColor
        lbl_three.layer.borderWidth = 1
        
        // four
        lbl_four.layer.cornerRadius = 12
        lbl_four.clipsToBounds = true
        lbl_four.backgroundColor = .gray
        lbl_four.layer.borderColor = UIColor.gray.cgColor
        lbl_four.layer.borderWidth = 1
        
        // five
        lbl_five.layer.cornerRadius = 12
        lbl_five.clipsToBounds = true
        lbl_five.backgroundColor = .gray
        lbl_five.layer.borderColor = UIColor.gray.cgColor
        lbl_five.layer.borderWidth = 1
    }
    
    @objc func lbl_four_click_method() {
        self.str_reason_select = "unable to contact driver"
        // one
        lbl_one.layer.cornerRadius = 12
        lbl_one.clipsToBounds = true
        lbl_one.backgroundColor = .gray
        lbl_one.layer.borderColor = UIColor.gray.cgColor
        lbl_one.layer.borderWidth = 1
        
        // two
        lbl_two.layer.cornerRadius = 12
        lbl_two.clipsToBounds = true
        lbl_two.backgroundColor = .gray
        lbl_two.layer.borderColor = UIColor.gray.cgColor
        lbl_two.layer.borderWidth = 1
        
        // three
        lbl_three.layer.cornerRadius = 12
        lbl_three.clipsToBounds = true
        lbl_three.backgroundColor = .gray
        lbl_three.layer.borderColor = UIColor.gray.cgColor
        lbl_three.layer.borderWidth = 1
        
        // four
        lbl_four.layer.cornerRadius = 12
        lbl_four.clipsToBounds = true
        lbl_four.backgroundColor = .systemRed
        lbl_four.layer.borderColor = UIColor.gray.cgColor
        lbl_four.layer.borderWidth = 1
        
        // five
        lbl_five.layer.cornerRadius = 12
        lbl_five.clipsToBounds = true
        lbl_five.backgroundColor = .gray
        lbl_five.layer.borderColor = UIColor.gray.cgColor
        lbl_five.layer.borderWidth = 1
    }
    
    @objc func lbl_five_click_method() {
        self.str_reason_select = "My reason is not listed"
        // one
        lbl_one.layer.cornerRadius = 12
        lbl_one.clipsToBounds = true
        lbl_one.backgroundColor = .gray
        lbl_one.layer.borderColor = UIColor.gray.cgColor
        lbl_one.layer.borderWidth = 1
        
        // two
        lbl_two.layer.cornerRadius = 12
        lbl_two.clipsToBounds = true
        lbl_two.backgroundColor = .gray
        lbl_two.layer.borderColor = UIColor.gray.cgColor
        lbl_two.layer.borderWidth = 1
        
        // three
        lbl_three.layer.cornerRadius = 12
        lbl_three.clipsToBounds = true
        lbl_three.backgroundColor = .gray
        lbl_three.layer.borderColor = UIColor.gray.cgColor
        lbl_three.layer.borderWidth = 1
        
        // four
        lbl_four.layer.cornerRadius = 12
        lbl_four.clipsToBounds = true
        lbl_four.backgroundColor = .gray
        lbl_four.layer.borderColor = UIColor.gray.cgColor
        lbl_four.layer.borderWidth = 1
        
        // five
        lbl_five.layer.cornerRadius = 12
        lbl_five.clipsToBounds = true
        lbl_five.backgroundColor = .systemRed
        lbl_five.layer.borderColor = UIColor.gray.cgColor
        lbl_five.layer.borderWidth = 1
    }
    
    @objc func cancel_ride_click_method() {
        if(self.str_reason_select == "My reason is not listed") {
            
            if (self.txt_view.text == "") {
                let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please enter reason behind cancellation"), style: .alert)
                let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                alert.addButtons([cancel])
                self.present(alert, animated: true)
            } else {
                self.decline_ride_WB(str_show_loader: "yes")
            }
            
        } else {
            //
            self.decline_ride_WB(str_show_loader: "yes")
        }
    }
    
    @objc func decline_ride_WB(str_show_loader:String) {
         if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                } else {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "ড্রাইভার খোঁজা হচ্ছে")
                }
                
             
            }
        // self.dismiss(animated: true)
        
        // self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
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
                
                /*
                 [action] => ridecancel
                     [userId] => 71
                     [bookingId] => 195
                     [userType] => Driver
                     [cancelReason] => My reason is not listed
                     [cancelComment] => hmm
                 */
                parameters = [
                    "action"        : "ridecancel",
                    "userId"        : String(myString),
                    "bookingId"     : "\(self.dict_booking_details["bookingId"]!)",
                    "userType"      : String("Member"),
                    "cancelReason"  : String(self.str_reason_select),
                    "cancelComment" : String(self.txt_view.text)
                ]
                
                print(parameters as Any)
                
                AF.request(application_base_url, method: .post, parameters: parameters as? Parameters,headers: headers).responseJSON { [self]
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
                            
                            let str_token = (JSON["AuthToken"] as! String)
                            UserDefaults.standard.set("", forKey: str_save_last_api_token)
                            UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                            
                            ERProgressHud.sharedInstance.hide()
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)

                            let destinationController = storyboard.instantiateViewController(withIdentifier:"dashboard_id") as? dashboard
                                
                            // destinationController?.str_booking_id =  "\(self.dict_booking_details["bookingId"]!)"
                               
                            // destinationController?.str_reason_select2 = String(self.str_reason_select)
                            // destinationController?.txt_view2 = String(self.txt_view.text)
                            
                            let frontNavigationController = UINavigationController(rootViewController: destinationController!)

                            let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC

                            let mainRevealController = SWRevealViewController()

                            mainRevealController.rearViewController = rearViewController
                            mainRevealController.frontViewController = frontNavigationController
                            
                            DispatchQueue.main.async {
                                UIApplication.shared.keyWindow?.rootViewController = mainRevealController
                            }
                            
                            window?.makeKeyAndVisible()
                            
                            
                             
                            
                            
                            
                            
                        } else if message == String(not_authorize_api) {
                            self.login_refresh_token_wb()
                            
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
                            
                            self.decline_ride_WB(str_show_loader: "no")
                            
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
    
    @objc func updateCounter() {
        
        if (counter == 2) {
            counter -= 1
        } else if (counter == 1) {
            counter -= 1
            timer.invalidate()
             
            
            
            
            
            
            
            /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as? dashboard
            self.navigationController?.pushViewController(push!, animated: true)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //show window
            appDelegate.window?.rootViewController = push*/
            
            
            
            
            
            
            /*let refreshAlert = UIAlertController(title: "Cancelled", message: "Ride has been cancelled successfully.", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                  print("Handle Ok logic here")
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as? dashboard
                self.navigationController?.pushViewController(push!, animated: true)
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                //show window
                appDelegate.window?.rootViewController = push
                
                
                
                
                
                
            }))
            self.present(refreshAlert, animated: true, completion: nil)*/
            
        } else if (counter == 0) {
            timer.invalidate()
        }

    }
    
    
}
