//
//  before_payment.swift
//  PathMark
//
//  Created by Dishant Rajput on 17/11/23.
//

import UIKit
import Alamofire
import AudioToolbox

class before_payment: UIViewController {
    var store_coupon_code:String!
    var discounted_amount:String!
    
    // parse
    var get_full_data_for_payment2:NSDictionary!
    
    var str_get_total_price2:String!
    var str_booking_id2:String!
    
    var str_user_select_offer:Int!
    var str_final_amount:String!
    
    var str_discount_amount2:String! = "0"
    
    var arr_coupon_list:NSMutableArray! = []
    
    var str_coupon_code2:String!
    
    var total_amount:String!
    
    @IBOutlet weak var view_navigation_bar:UIView! {
        didSet {
            view_navigation_bar.applyGradient()
        }
    }
    
    @IBOutlet weak var btn_back:UIButton!
    
    @IBOutlet weak var view_navigation_title:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    view_navigation_title.text = "Payment Method"
                } else {
                    view_navigation_title.text = "পেমেন্ট পদ্ধতি"
                }
                
                
            }
            
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var lbl_total_payable:UILabel!
    
    @IBOutlet weak var lbl_payment_method_text:UILabel!  {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_payment_method_text.text = "Choose your payment method"
                } else {
                    lbl_payment_method_text.text = "পেমেন্ট পদ্ধতি নির্বাচন করুন"
                }
                
                
            }
            
            // view_navigation_title.textColor = .white
        }
    }
    @IBOutlet weak var lbl_ava_vo_Text:UILabel!  {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_ava_vo_Text.text = "Vouchers available"
                } else {
                    lbl_ava_vo_Text.text = "ভাউচার উপলব্ধ"
                }
                
                
            }
            
            // view_navigation_title.textColor = .white
        }
    }

    
    @IBOutlet weak var btn_cash:UIButton! {
        didSet {
            btn_cash.layer.masksToBounds = false
            btn_cash.layer.shadowColor = UIColor.black.cgColor
            btn_cash.layer.shadowOffset =  CGSize.zero
            btn_cash.layer.shadowOpacity = 0.5
            btn_cash.layer.shadowRadius = 2
            btn_cash.backgroundColor = .white
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_cash.setTitle("Cash", for: .normal)
                } else {
                    btn_cash.setTitle("ক্যাশ", for: .normal)
                }
                
                
            }
        }
    }
    @IBOutlet weak var btn_bkash:UIButton! {
        didSet {
            btn_bkash.layer.masksToBounds = false
            btn_bkash.layer.shadowColor = UIColor.black.cgColor
            btn_bkash.layer.shadowOffset =  CGSize.zero
            btn_bkash.layer.shadowOpacity = 0.5
            btn_bkash.layer.shadowRadius = 2
            btn_bkash.backgroundColor = .white
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_bkash.setTitle("BKash", for: .normal)
                } else {
                    btn_bkash.setTitle("বিকাশ", for: .normal)
                }
                
                
            }
            
        }
    }
    
    @IBOutlet weak var btn_cash_tick:UIButton! {
        didSet {
            btn_cash_tick.isHidden = true
        }
    }
    @IBOutlet weak var btn_bkash_tick:UIButton! {
        didSet {
            btn_bkash_tick.isHidden = true
        }
    }
    
    @IBOutlet weak var tbleView:UITableView! {
        didSet {
            /*tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.reloadData()*/
            
            tbleView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var btn_submit:UIButton! {
        didSet {
            btn_submit.backgroundColor = .systemGreen
            btn_submit.layer.cornerRadius = 12
            btn_submit.clipsToBounds = true
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_submit.setTitle("Submit", for: .normal)
                } else {
                    btn_submit.setTitle("জমা দিন", for: .normal)
                }
                
                
            }
            
        }
    }
    
    var str_cash_type:String! = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.btn_back.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        self.btn_cash.addTarget(self, action: #selector(cash_click_method), for: .touchUpInside)
        self.btn_bkash.addTarget(self, action: #selector(bkash_click_method), for: .touchUpInside)
        
        self.btn_submit.addTarget(self, action: #selector(submit_click_method), for: .touchUpInside)
        
        self.total_amount = String(self.str_get_total_price2)
        
        let doublePrice2 = Double("\(str_get_total_price2!)")
        let formattedNumber2 = String(format: "%.2f", doublePrice2!)
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                self.lbl_total_payable.text = "Total Payment Amount : "+String(str_bangladesh_currency_symbol)+String(formattedNumber2)
            } else {
                self.lbl_total_payable.text = "মোট পরিশোধযোগ্য পরিমাণ : "+String(str_bangladesh_currency_symbol)+String(formattedNumber2)
            }
            
        }
        
        self.str_final_amount = String(self.str_get_total_price2)
        
        self.couponListWB(str_show_loader: "yes")
    }
    
    @objc func cash_click_method() {
        self.str_cash_type = "1"
        
        // AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        self.btn_cash_tick.setImage(UIImage(systemName: "checkmark"), for: .normal)
        self.btn_cash_tick.isHidden = false
        self.btn_bkash_tick.isHidden = true
    }
    
    @objc func bkash_click_method() {
        self.str_cash_type = "2"
        
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        
        self.btn_bkash_tick.setImage(UIImage(systemName: "checkmark"), for: .normal)
        self.btn_bkash_tick.isHidden = false
        self.btn_cash_tick.isHidden = true
    }

    @objc func couponListWB(str_show_loader:String) {
        
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
        
        
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                print(token_id_is as Any)
                
                let headers: HTTPHeaders = [
                    "token":String(token_id_is),
                ]
                
                parameters = [
                    "action"    : "couponlist",
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

                            /*let str_token = (JSON["AuthToken"] as! String)
                            UserDefaults.standard.set("", forKey: str_save_last_api_token)
                            UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)*/
                            
                            ERProgressHud.sharedInstance.hide()
                            self.dismiss(animated: true)
                            
                            var ar : NSArray!
                            ar = (JSON["data"] as! Array<Any>) as NSArray
                            self.arr_coupon_list.addObjects(from: ar as! [Any])
                            
                            print(self.arr_coupon_list.count as Any)
                            ERProgressHud.sharedInstance.hide()
                            
                            self.tbleView.delegate = self
                            self.tbleView.dataSource = self
                            self.tbleView.reloadData()
                            
                        } else if message == String(not_authorize_api) {
                            self.login_refresh_token_for_upcoming_ride_wb()
                            
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
    
    @objc func login_refresh_token_for_upcoming_ride_wb() {
        
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
                            
                            self.couponListWB(str_show_loader: "no")
                            
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
    
    @objc func submit_click_method() {
        print(self.str_cash_type as Any)
        
        if (self.str_cash_type == "0") {
            
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please select a payment option"), style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            
        } else if (self.str_cash_type == "1") {
            
            self.cash_payment_WB(str_show_loader: "yes")
            
        } else {
            
            if (self.discounted_amount == nil) {
                if (self.store_coupon_code == nil) {
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "bKash_payment_gateway_id") as? bKash_payment_gateway
                    push!.doublePayment = "\(self.str_final_amount!)"
                    push!.dict_full = self.get_full_data_for_payment2
                    push!.str_booking_id = String(self.str_booking_id2)
                    push!.getDiscountAmount = String("0")
                    push!.getCouponCode = String("0")
                    self.navigationController?.pushViewController(push!, animated: true)
                } else {
                    // discounted amount is nil but coupon code not
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "bKash_payment_gateway_id") as? bKash_payment_gateway
                    push!.doublePayment = "\(self.str_final_amount!)"
                    push!.dict_full = self.get_full_data_for_payment2
                    push!.str_booking_id = String(self.str_booking_id2)
                    push!.getDiscountAmount = String("0")
                    push!.getCouponCode = String(self.store_coupon_code)
                    self.navigationController?.pushViewController(push!, animated: true)
                }
                
            } else {
                // discounted amount is not nil
                if (self.store_coupon_code == nil) {
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "bKash_payment_gateway_id") as? bKash_payment_gateway
                    push!.doublePayment = "\(self.str_final_amount!)"
                    push!.dict_full = self.get_full_data_for_payment2
                    push!.str_booking_id = String(self.str_booking_id2)
                    push!.getDiscountAmount = String(self.discounted_amount)
                    push!.getCouponCode = String("0")
                    self.navigationController?.pushViewController(push!, animated: true)
                } else {
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "bKash_payment_gateway_id") as? bKash_payment_gateway
                    push!.doublePayment = "\(self.str_final_amount!)"
                    push!.dict_full = self.get_full_data_for_payment2
                    push!.str_booking_id = String(self.str_booking_id2)
                    push!.getDiscountAmount = String(self.discounted_amount)
                    push!.getCouponCode = String(self.store_coupon_code)
                    self.navigationController?.pushViewController(push!, animated: true)
                }
                
            }
//            else {
                
//            }
            
            
            
            
            /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "payment_id") as? payment
            
            push!.str_booking_id = self.str_booking_id2
            push!.str_get_total_price = String(self.str_final_amount)// self.str_get_total_price2
            push!.get_full_data_for_payment = self.get_full_data_for_payment2
            push!.str_discounted_amount = self.str_discount_amount2
            push!.str_coupon_code = self.str_coupon_code2
            
            self.navigationController?.pushViewController(push!, animated: true)*/
            
            
        }
        
    }
    
    @objc func cash_payment_WB(str_show_loader:String) {
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tbleView.cellForRow(at: indexPath) as! payment_table_cell
        
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
                
                print(self.discounted_amount as Any)
            
                
                
                if (self.discounted_amount == nil) {
                    self.discounted_amount = "0"
                }
                
                if (self.store_coupon_code == nil) {
                    self.store_coupon_code = "0"
                }
                
                parameters = [
                    "action"        : "updatepayment",
                    "userId"        : String(myString),
                    "bookingId"     : String(self.str_booking_id2),
                    "transactionId"  : String("cash_dummy_transaction_id"),
                    "totalAmount"   : String(self.str_final_amount),
                    "TIP"           : String("0"),
                    "discountAmount"    : String(self.discounted_amount),
                    "couponCode"    : String(self.store_coupon_code),
                    "paymentMethod" : String("Cash"),
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
                            
                            // self.back_click_method()
                            
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "success_payment_id") as? success_payment
                            
                            push!.str_show_total_price = String(self.str_final_amount)
                            push!.get_booking_details = self.get_full_data_for_payment2
                            
                            self.navigationController?.pushViewController(push!, animated: true)
                            
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
                            
                            self.cash_payment_WB(str_show_loader: "no")
                            
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
}

extension before_payment: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.arr_coupon_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:before_payment_table_cell = tableView.dequeueReusableCell(withIdentifier: "before_payment_table_cell") as! before_payment_table_cell
            
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.backgroundColor = .clear
         
        let item = self.arr_coupon_list[indexPath.row] as? [String:Any]
        // print(item as Any)

        cell.lbl_tag.text = " "+(item!["couponCode"] as! String)+" "
        cell.lbl_off.text = "\(item!["discount"]!) % off"
        cell.lbl_message.text = (item!["description"] as! String)
        cell.lbl_expire.text = (item!["endDate"] as! String)
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
     
        let item = self.arr_coupon_list[indexPath.row] as? [String:Any]
        print(item as Any)
        
        self.str_coupon_code2 = (item!["description"] as! String)
        
        let double_off = Double("\(item!["discount"]!)")!
        self.store_coupon_code = "\(double_off)"
        let double_total = Double(self.str_get_total_price2)!
        
        let cal = (double_off/100)*double_total
        print(cal)
        
        self.discounted_amount = "\(cal)"
        print(self.discounted_amount  as Any)
        self.str_discount_amount2 = "\(cal)"
        
        let final_cal = double_total - cal
        // print(final_cal)
        self.total_amount = "\(final_cal)"
        
        let doublePrice1 = Double("\(final_cal)")
        let formattedNumber = String(format: "%.2f", doublePrice1!)
        self.lbl_total_payable.text = "Total Payable Amount : \(str_bangladesh_currency_symbol)\(formattedNumber)"
        
        self.str_final_amount = "\(final_cal)"
        
        self.str_user_select_offer = indexPath.row
        self.tbleView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
}

class before_payment_table_cell: UITableViewCell {
    
    @IBOutlet weak var view_payment:UIView! {
        didSet {
            view_payment.layer.masksToBounds = false
            view_payment.layer.shadowColor = UIColor.black.cgColor
            view_payment.layer.shadowOffset =  CGSize.zero
            view_payment.layer.shadowOpacity = 0.5
            view_payment.layer.shadowRadius = 2
            view_payment.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var lbl_tag:UILabel! {
        didSet {
            //  lbl_tag.backgroundColor = .systemRed
            // lbl_tag.textColor = .red
        }
    }
    @IBOutlet weak var lbl_off:UILabel!
    @IBOutlet weak var lbl_message:UILabel!
    @IBOutlet weak var lbl_expire:UILabel!
}
