//
//  pay_after_cancel.swift
//  PathMark
//
//  Created by Dishant Rajput on 23/11/23.
//

import UIKit
import Alamofire

class cardPayment: UIViewController, UITextFieldDelegate, FullScreenPopupDelegate {
    
    var str_from_schedule:String!
    
    var get_full_data_for_payment:NSDictionary!
    var str_from_history:String!
    
    var str_get_total_price:String!
    var str_booking_id:String!
    
    var str_discounted_amount:String!
    
    var str_coupon_code:String!
    
    var str_final_price_to_pay:String!
    
    var str_reason_select2:String!
    var txt_view2:String!
    
    var isSaveCard:Bool! = false
    var isFromMenu:Bool!
    
    @IBOutlet weak var navigationBar:UIView! {
//        didSet {
//            navigationBar.backgroundColor = navigation_color
//            navigationBar.applyGradient()
//        }
        didSet {
            DispatchQueue.main.async {
                GradientViewHelper.apply(
                    to: self.navigationBar,
                    colors: [
                        UIColor(red: 255/255, green: 94/255, blue: 58/255, alpha: 1),
                        UIColor(red: 255/255, green: 185/255, blue: 0/255, alpha: 1)
                    ]
                )
            }
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = NAVIGATION_BACK_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if (isFromMenu == false) {
            lblNavigationTitle.text = "Payment"
            self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
            self.booking_history_details_WB(str_show_loader: "yes")
        } else {
            lblNavigationTitle.text = "Add / Saved card"
            sideBarMenuClick()
        }
        
    }
    
    @objc func sideBarMenuClick() {
        
        if revealViewController() != nil {
            
            self.btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    @objc func validation_before_submit() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! cardPayment_table_cell
        
        if (cell.txt_card_number.text == "") {
            self.alert_popup_appear()
        } else if (cell.txt_card_expiry_year.text == "") {
            self.alert_popup_appear()
        } else if (cell.txt_card_expiry_month.text == "") {
            self.alert_popup_appear()
        } else if (cell.txt_card_cvv.text == "") {
            self.alert_popup_appear()
        } else {
            if (self.isFromMenu == true) {
                self.addCardWB(str_show_loader: "yes")
            } else {
                self.payment_WB(str_show_loader: "yes")
            }
            
        }
    }
    
    @objc func alert_popup_appear() {
        ERProgressHud.sharedInstance.hide()
        let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Field should not be empty."), style: .alert)
        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
        alert.addButtons([cancel])
        self.present(alert, animated: true)
    }
    
    @objc func payment_WB(str_show_loader:String) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! cardPayment_table_cell
        
        if (str_show_loader == "yes") {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
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
                 [action] => updatepayment
                 [userId] => 275
                 [bookingId] => 918
                 [TIP] => 0
                 [discountAmount] =>
                 [couponCode] =>
                 [totalAmount] => 97
                 [paymentMethod] => Cash
                 [transactionId] => Cash_1726073132638
                 [paymentID] =>
                 [language] => bn
                 */
                parameters = [
                    "action"        : "updatepayment",
                    "userId"        : String(myString),
                    "bookingId"     : "\(self.get_full_data_for_payment["bookingId"]!)",
                    "transactionId"  : String("dummy_transaction_id"),
                    "totalAmount"   : "\(self.get_full_data_for_payment["estimatedPrice"]!)",
                    "TIP"           : String("0"),
                    "discountAmount"    : String("0"),
                    "couponCode"    : String(""),
                    "paymentMethod" : String("Card"),
                    "paymentID"     : String("payment_1234"),
                    "language"      : "en"
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
                            
                            if(self.str_from_schedule == "yes") {
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "schedule_ride_details_id") as? schedule_ride_details
                                push!.dict_get_booking_details = self.get_full_data_for_payment
                                push!.str_from_history = "no"
                                self.navigationController?.pushViewController(push!, animated: true)
                            } else {
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ride_status_id") as? ride_status
                                push!.dict_get_all_data_from_notification = self.get_full_data_for_payment
                                push!.str_from_history = "no"
                                self.navigationController?.pushViewController(push!, animated: true)
                            }
                            
                            
                            
                            /*let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String(message), style: .alert)
                            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                            alert.addButtons([cancel])
                            self.present(alert, animated: true)
                            
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as? dashboard
                            self.navigationController?.pushViewController(push!, animated: true)*/
                            
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
                            
                            self.payment_WB(str_show_loader: "no")
                            
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
    
    /*@objc func decline_ride_WB(str_show_loader:String) {
     if (str_show_loader == "yes") {
     // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
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
     "action"        : "ridecancel",
     "userId"        : String(myString),
     "bookingId"     : String(self.str_booking_id),
     "userType"      : String("Member"),
     "cancelReason"  : String(self.str_reason_select2),
     "cancelComment" : String(self.txt_view2)
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
     
     // ERProgressHud.sharedInstance.hide()
     let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as? dashboard
     self.navigationController?.pushViewController(push!, animated: true)
     
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
     
     }*/
    
    /*@objc func login_refresh_token_wb2() {
     
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
     
     }*/
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! cardPayment_table_cell
        
        
        if (textField == cell.txt_card_number) {
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            // make sure the result is under 16 characters
            return updatedText.count <= 16
            
        } else if (textField == cell.txt_card_expiry_month) {
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            // make sure the result is under 16 characters
            return updatedText.count <= 2
            
        } else if (textField == cell.txt_card_expiry_year) {
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            // make sure the result is under 16 characters
            return updatedText.count <= 2
            
        } else if (textField == cell.txt_card_cvv) {
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            // make sure the result is under 16 characters
            return updatedText.count <= 3
            
        }  else {
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            // make sure the result is under 16 characters
            return updatedText.count <= 30
            
        }
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! cardPayment_table_cell
        
        print(textField.text as Any)
        //
        if (textField.text == "") {
            self.str_final_price_to_pay = String(self.str_get_total_price)
            cell.btn_submit.setTitle("Pay: \(self.get_full_data_for_payment["estimatedPrice"]!)", for: .normal)
        } else {
            let double_total_price = Double(self.str_get_total_price)!
            let double_tip = Double(textField.text!)!
            //
            let calculate = double_total_price+double_tip
            print(calculate)
            //
            self.str_final_price_to_pay = "\(calculate)"
            cell.btn_submit.setTitle("Pay: \(self.get_full_data_for_payment["estimatedPrice"]!)", for: .normal)
        }
        
    }
    
    
    @objc func booking_history_details_WB(str_show_loader:String) {
        
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
        
        
        self.view.endEditing(true)
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                print(token_id_is as Any)
                
                let headers: HTTPHeaders = [
                    "token":String(token_id_is),
                ]
                
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
                    "action"        : "bookingdetail",
                    "bookingId"     : "\(self.self.get_full_data_for_payment["bookingId"]!)",
                    "userId"        : String(myString),
                    "language"      : String(lan),
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
                            
                            let str_token = (JSON["AuthToken"] as! String)
                            UserDefaults.standard.set("", forKey: str_save_last_api_token)
                            UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                            
                            ERProgressHud.sharedInstance.hide()
                            
                            var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            print(dict as Any)
                            
                            let amount:Double!
                            let bookingFee:Double!
                            let cancellationFees:Double!
                            let discountAmount:Double!
                            let promotionalDiscount:Double!
                            let complete_cal:Double!
                            
                            if "\(self.get_full_data_for_payment["estimatedPrice"]!)" == "" {
                                amount = self.convertToDouble("0.0")
                            } else if "\(self.get_full_data_for_payment["estimatedPrice"]!)" == "0" {
                                amount = self.convertToDouble("0.0")
                            } else {
                                amount = self.convertToDouble("\(self.get_full_data_for_payment["estimatedPrice"]!)")
                            }
                            
                            
                            if (self.get_full_data_for_payment["bookingFee"] == nil) {
                                bookingFee = self.convertToDouble("0.0")
                            } else {
                                if "\(self.get_full_data_for_payment["bookingFee"]!)" == "" {
                                    bookingFee = self.convertToDouble("0.0")
                                } else if "\(self.get_full_data_for_payment["bookingFee"]!)" == "0" {
                                    bookingFee = self.convertToDouble("0.0")
                                } else {
                                    bookingFee = self.convertToDouble("\(self.get_full_data_for_payment["bookingFee"]!)")
                                }
                            }
                            
                            
                            
                            if (self.get_full_data_for_payment["last_cancel_amount"] == nil) {
                                cancellationFees = self.convertToDouble("0.0")
                            } else {
                                if "\(self.get_full_data_for_payment["last_cancel_amount"]!)" == "" {
                                    cancellationFees = self.convertToDouble("0.0")
                                } else if "\(self.get_full_data_for_payment["last_cancel_amount"]!)" == "0" {
                                    cancellationFees = self.convertToDouble("0.0")
                                } else {
                                    cancellationFees = self.convertToDouble("\(self.get_full_data_for_payment["last_cancel_amount"]!)")
                                }
                            }
                            
                            
                            
                            
                            if (self.get_full_data_for_payment["discountAmount"] == nil) {
                                discountAmount = self.convertToDouble("0.0")
                            } else {
                                
                                if "\(self.get_full_data_for_payment["discountAmount"]!)" == "" {
                                    discountAmount = self.convertToDouble("0.0")
                                } else if "\(self.get_full_data_for_payment["discountAmount"]!)" == "0" {
                                    discountAmount = self.convertToDouble("0.0")
                                } else {
                                    discountAmount = self.convertToDouble("\(self.get_full_data_for_payment["discountAmount"]!)")
                                }
                            }
                            
                            
                            
                            if (self.get_full_data_for_payment["promotional_discount"] == nil) {
                                promotionalDiscount = self.convertToDouble("0.0")
                            } else {
                                if "\(self.get_full_data_for_payment["promotional_discount"]!)" == "" {
                                    promotionalDiscount = self.convertToDouble("0.0")
                                } else if "\(self.get_full_data_for_payment["promotional_discount"]!)" == "0" {
                                    promotionalDiscount = self.convertToDouble("0.0")
                                } else {
                                    promotionalDiscount = self.convertToDouble("\(self.get_full_data_for_payment["promotional_discount"]!)")
                                }
                            }
                            
                            
                            
                            
                            
                            
                            
                            print(amount as Any)
                            print(bookingFee as Any)
                            print(cancellationFees as Any)
                            print(discountAmount as Any)
                            print(promotionalDiscount as Any)
                            //                            print(complete_cal as Any)
                            
                            let totalAmount =  amount + bookingFee + cancellationFees! - discountAmount! - promotionalDiscount!
                            print(totalAmount as Any)
                            print(totalAmount as Any)
                            
                            // let pro_dis = convertToDouble("\(self.dict_get_booking_details["promotional_discount"]!)")
                            // print(pro_dis as Any)
                            // complete_cal = totalAmount - pro_dis!
                            // print("Complete cal: \(complete_cal!)")
                            
                            // let final_fare = self.convertToDouble("\(self.get_full_data_for_payment["FinalFare"]!)")
                            // print("Final fare: \(final_fare!)")
                            
                            // let f_f_total = final_fare! - pro_dis!
                            // print("total: \(f_f_total)")
                            // self.lbl_trip_fare.text = "\(str_bangladesh_currency_symbol) \(f_f_total)"
                            
                            
                            // cell.lbl_fare.text = "\(str_bangladesh_currency_symbol) \(f_f_total)"
                            
                            
                            //                                let doubleStr = String(format: "%.2f", totalAmount)
                            //                                self.lbl_price.text = "\(str_bangladesh_currency_symbol) \(doubleStr)"
                            //                                cell.lbl_total_amount.text = "\(str_bangladesh_currency_symbol) \(doubleStr)"
                            //
                            //                                if "\(self.dict_get_booking_details["discountAmount"]!)" == "" {
                            //                                    cell.lbl_promotion.text = "\(str_bangladesh_currency_symbol) 0"
                            //                                } else if "\(self.dict_get_booking_details["discountAmount"]!)" == "0" {
                            //                                    cell.lbl_promotion.text = "\(str_bangladesh_currency_symbol) 0"
                            //                                } else {
                            //                                    cell.lbl_promotion.text = "\(str_bangladesh_currency_symbol) \(self.dict_get_booking_details["discountAmount"]!)"
                            //                                }
                            
                            /*if "\(self.dict_get_booking_details["promotional_discount"]!)" != "" {
                             
                             
                             } else {
                             print("NO promotional_discount")
                             
                             self.lbl_price.text = "\(str_bangladesh_currency_symbol) \(totalAmount)"
                             cell.lbl_fare.text = "\(str_bangladesh_currency_symbol) \(totalAmount)"
                             cell.lbl_total_amount.text = "\(str_bangladesh_currency_symbol) \(totalAmount)"
                             
                             let doubleStr = String(format: "%.2f", totalAmount)
                             self.lbl_price.text = "\(str_bangladesh_currency_symbol) \(doubleStr)"
                             cell.lbl_fare.text = "\(str_bangladesh_currency_symbol) \(doubleStr)"
                             cell.lbl_total_amount.text = "\(str_bangladesh_currency_symbol) \(doubleStr)"
                             
                             if "\(self.dict_get_booking_details["discountAmount"]!)" == "" {
                             cell.lbl_promotion.text = "\(str_bangladesh_currency_symbol) 0"
                             } else if "\(self.dict_get_booking_details["discountAmount"]!)" == "0" {
                             cell.lbl_promotion.text = "\(str_bangladesh_currency_symbol) 0"
                             } else {
                             cell.lbl_promotion.text = "\(str_bangladesh_currency_symbol) \(self.dict_get_booking_details["discountAmount"]!)"
                             }
                             
                             
                             }*/
                            
                            //                            }
                            
                            
                            
                            /*// self.dict_get_booking_details = JSON
                             self.str_starrating = "\(dict["bookingrating"]!)"
                             self.tbleView.delegate = self
                             self.tbleView.dataSource = self
                             self.tbleView.reloadData()*/
                            
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
                            
                            self.booking_history_details_WB(str_show_loader: "no")
                            
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
    
    @objc func checkBoxClickMethod() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! cardPayment_table_cell
        
        if (isFromMenu == true) {
            cell.btnCheckBox.tag = 1
            cell.btnCheckBox.backgroundColor = .systemGreen
            isSaveCard = true
        } else {
            if (cell.btnCheckBox.tag == 1) {
                cell.btnCheckBox.tag = 0
                cell.btnCheckBox.backgroundColor = .white
                isSaveCard = false
                debugPrint("off")
            } else {
                cell.btnCheckBox.tag = 1
                cell.btnCheckBox.backgroundColor = .systemGreen
                let generator = UIImpactFeedbackGenerator(style: .soft)
                generator.impactOccurred()
                isSaveCard = true
                debugPrint("on")
            }
        }
        
        
    }
    
    
    @objc func saveAndPay() {
        if (isSaveCard == false) {
            validation_before_submit()
        } else {
            self.addCardWB(str_show_loader: "yes")
        }
        
    }
    
    @objc func addCardWB(str_show_loader:String) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! cardPayment_table_cell
        
        if (str_show_loader == "yes") {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
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
                    "action"        : "cardadd",
                    "userId"        : String(myString),
                    "c_no"          : String(cell.txt_card_number.text!),
                    "exp_m"         : String(cell.txt_card_expiry_month.text!),
                    "exp_y"         : String(cell.txt_card_expiry_year.text!),
                    
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
                            
                            
                            if (isFromMenu == true) {
                                ERProgressHud.sharedInstance.hide()
                                cell.txt_card_cvv.text = ""
                                cell.txt_card_number.text = ""
                                cell.txt_card_expiry_year.text = ""
                                cell.txt_card_expiry_month.text = ""
                                // cell.txt_card_holder_name.text = ""
                                
                            } else {
                                self.validation_before_submit()
                            }
                            
                            
                        } else if message == String(not_authorize_api) {
                            self.login_refresh_token_wb3()
                            
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
    
    @objc func login_refresh_token_wb3() {
        
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
                            
                            self.addCardWB(str_show_loader: "yes")
                            
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
    
    @objc func btnSavedCard() {
        self.showFullScreenPopup()
    }
    
    @objc private func showFullScreenPopup() {
        let popupVC = FullScreenPopupViewController()
        popupVC.delegate = self
        let navController = UINavigationController(rootViewController: popupVC)
        navController.modalPresentationStyle = .fullScreen
        
        present(navController, animated: true, completion: nil)
    }
    
    // Delegate method implementation
    func didSelectCard(_ card: [String: Any]) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! cardPayment_table_cell
        // Handle the selected card data here
        debugPrint("Selected Card:", card)
        
        cell.txt_card_number.text = "\(card["c_no"]!)"
        cell.txt_card_expiry_month.text = "\(card["exp_m"]!)"
        cell.txt_card_expiry_year.text = "\(card["exp_y"]!)"
        
        // Example: Display card details in an alert
        if let cardNumber = card["c_no"] as? String,
           let expiryMonth = card["exp_m"] as? String,
           let expiryYear = card["exp_y"] as? String {
            // ["created": Nov 4th, 2024, 10:25 pm, "cardId": 12, "exp_y": 25, "exp_m": 12, "c_no": 5252525252525252]
            // cell.txt_card_number.text = String(cardNumber)
            // cell.txt_card_expiry_month.text = String(expiryMonth)
            // cell.txt_card_expiry_year.text = String(expiryYear)
            // print("inside")
            
            let message = "Card Number: \(cardNumber)\nExpiry: \(expiryMonth)/\(expiryYear)"
            showAlert(title: "Selected Card", message: message)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK:- TABLE VIEW -
extension cardPayment: UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:cardPayment_table_cell = tableView.dequeueReusableCell(withIdentifier: "cardPayment_table_cell") as! cardPayment_table_cell
        
        cell.backgroundColor = .white
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        // cell.txt_card_holder_name.delegate = self
        cell.txt_card_expiry_month.delegate = self
        cell.txt_card_expiry_year.delegate = self
        cell.txt_card_cvv.delegate = self
        cell.txt_card_number.delegate = self
        
        if (isFromMenu == true) {
            cell.btn_submit.setTitle("Add card", for: .normal)
            cell.btn_submit.addTarget(self, action: #selector(saveAndPay), for: .touchUpInside)
            cell.btnCheckBox.backgroundColor = .systemGreen
        } else {
            cell.btn_submit.setTitle("Pay: \(self.get_full_data_for_payment["estimatedPrice"]!)", for: .normal)
            cell.btn_submit.addTarget(self, action: #selector(saveAndPay), for: .touchUpInside)
            cell.btnCheckBox.addTarget(self, action: #selector(checkBoxClickMethod), for: .touchUpInside)
        }

        cell.btnSavedCard.addTarget(self, action: #selector(btnSavedCard), for: .touchUpInside)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }
    
}


class cardPayment_table_cell: UITableViewCell {
    
    @IBOutlet weak var btnCheckBox:UIButton! {
        didSet {
            btnCheckBox.tag = 0
            btnCheckBox.backgroundColor = .white
            btnCheckBox.layer.cornerRadius = 8
            btnCheckBox.clipsToBounds = true
            btnCheckBox.layer.borderColor = UIColor.black.cgColor
            btnCheckBox.layer.borderWidth = 0.8
        }
    }
    
    @IBOutlet weak var txt_card_holder_name:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_card_holder_name,
                              tfName: txt_card_holder_name.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Card Holder Name")
            
            txt_card_holder_name.layer.masksToBounds = false
            txt_card_holder_name.layer.shadowColor = UIColor.black.cgColor
            txt_card_holder_name.layer.shadowOffset =  CGSize.zero
            txt_card_holder_name.layer.shadowOpacity = 0.5
            txt_card_holder_name.layer.shadowRadius = 2
            txt_card_holder_name.isSecureTextEntry = false
        }
    }
    
    @IBOutlet weak var txt_card_number:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_card_number,
                              tfName: txt_card_number.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .numberPad,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Card Number")
            
            txt_card_number.layer.masksToBounds = false
            txt_card_number.layer.shadowColor = UIColor.black.cgColor
            txt_card_number.layer.shadowOffset =  CGSize.zero
            txt_card_number.layer.shadowOpacity = 0.5
            txt_card_number.layer.shadowRadius = 2
            txt_card_number.isSecureTextEntry = false
        }
    }
    
    @IBOutlet weak var txt_card_expiry_year:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_card_expiry_year,
                              tfName: txt_card_expiry_year.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .numberPad,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Card Expiry Year")
            
            txt_card_expiry_year.layer.masksToBounds = false
            txt_card_expiry_year.layer.shadowColor = UIColor.black.cgColor
            txt_card_expiry_year.layer.shadowOffset =  CGSize.zero
            txt_card_expiry_year.layer.shadowOpacity = 0.5
            txt_card_expiry_year.layer.shadowRadius = 2
            txt_card_expiry_year.isSecureTextEntry = false
        }
    }
    
    @IBOutlet weak var txt_card_expiry_month:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_card_expiry_month,
                              tfName: txt_card_expiry_month.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .numberPad,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Card Epiry Month")
            
            txt_card_expiry_month.layer.masksToBounds = false
            txt_card_expiry_month.layer.shadowColor = UIColor.black.cgColor
            txt_card_expiry_month.layer.shadowOffset =  CGSize.zero
            txt_card_expiry_month.layer.shadowOpacity = 0.5
            txt_card_expiry_month.layer.shadowRadius = 2
            txt_card_expiry_month.isSecureTextEntry = false
        }
    }
    
    @IBOutlet weak var txt_card_cvv:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_card_cvv,
                              tfName: txt_card_cvv.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .numberPad,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Card CVV")
            
            txt_card_cvv.layer.masksToBounds = false
            txt_card_cvv.layer.shadowColor = UIColor.black.cgColor
            txt_card_cvv.layer.shadowOffset =  CGSize.zero
            txt_card_cvv.layer.shadowOpacity = 0.5
            txt_card_cvv.layer.shadowRadius = 2
            txt_card_cvv.isSecureTextEntry = true
        }
    }
    
    @IBOutlet weak var txt_tip:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_tip,
                              tfName: txt_tip.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .numberPad,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Tip")
            
            txt_tip.layer.masksToBounds = false
            txt_tip.layer.shadowColor = UIColor.black.cgColor
            txt_tip.layer.shadowOffset =  CGSize.zero
            txt_tip.layer.shadowOpacity = 0.5
            txt_tip.layer.shadowRadius = 2
            txt_tip.isSecureTextEntry = false
        }
    }
    
    @IBOutlet weak var txt_coupon:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_coupon,
                              tfName: txt_coupon.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Coupon")
            
            txt_coupon.layer.masksToBounds = false
            txt_coupon.layer.shadowColor = UIColor.black.cgColor
            txt_coupon.layer.shadowOffset =  CGSize.zero
            txt_coupon.layer.shadowOpacity = 0.5
            txt_coupon.layer.shadowRadius = 2
            txt_coupon.isSecureTextEntry = false
            txt_coupon.text = ""
        }
    }
    
    @IBOutlet weak var btnSavedCard:UIButton! {
        didSet {
            Utils.buttonStyle(button: btnSavedCard,
                              bCornerRadius: 12,
                              bBackgroundColor: UIColor(red: 246.0/255.0, green: 200.0/255.0, blue: 68.0/255.0, alpha: 1),
                              bTitle: "Saved cards",
                              bTitleColor: .black)
            
            btnSavedCard.layer.masksToBounds = false
            btnSavedCard.layer.shadowColor = UIColor.black.cgColor
            btnSavedCard.layer.shadowOffset =  CGSize.zero
            btnSavedCard.layer.shadowOpacity = 0.5
            btnSavedCard.layer.shadowRadius = 2
            
            DispatchQueue.main.async { [self] in
                GradientViewHelper.apply(
                    to: btnSavedCard,
                    colors: [
                        UIColor(red: 255/255, green: 94/255, blue: 58/255, alpha: 1),
                        UIColor(red: 255/255, green: 185/255, blue: 0/255, alpha: 1)
                    ]
                )
            }
        }
    }
    
    @IBOutlet weak var btn_submit:UIButton! {
        didSet {
            Utils.buttonStyle(button: btn_submit,
                              bCornerRadius: 12,
                              bBackgroundColor: UIColor(red: 246.0/255.0, green: 200.0/255.0, blue: 68.0/255.0, alpha: 1),
                              bTitle: "Submit",
                              bTitleColor: .black)
            
            btn_submit.layer.masksToBounds = false
            btn_submit.layer.shadowColor = UIColor.black.cgColor
            btn_submit.layer.shadowOffset =  CGSize.zero
            btn_submit.layer.shadowOpacity = 0.5
            btn_submit.layer.shadowRadius = 2
        }
    }
    
    
    
}
