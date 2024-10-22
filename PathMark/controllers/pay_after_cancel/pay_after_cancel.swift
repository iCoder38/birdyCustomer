//
//  pay_after_cancel.swift
//  PathMark
//
//  Created by Dishant Rajput on 23/11/23.
//

import UIKit
import Alamofire

class pay_after_cancel: UIViewController, UITextFieldDelegate {
    
    var get_full_data_for_payment:NSDictionary!
    
    var str_get_total_price:String!
    var str_booking_id:String!
    
    var str_discounted_amount:String!
    
    var str_coupon_code:String!
    
    var str_final_price_to_pay:String!
    
    var str_reason_select2:String!
    var txt_view2:String!
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = NAVIGATION_BACK_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Payment"
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
        
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
    }
    
    @objc func validation_before_submit() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! pay_after_cancel_table_cell
        
       if (cell.txt_card_number.text == "") {
            self.alert_popup_appear()
        } else if (cell.txt_card_expiry_year.text == "") {
            self.alert_popup_appear()
        } else if (cell.txt_card_expiry_month.text == "") {
            self.alert_popup_appear()
        } else if (cell.txt_card_cvv.text == "") {
            self.alert_popup_appear()
        } else {
            self.payment_WB(str_show_loader: "yes")
        }
    }
    
    @objc func alert_popup_appear() {
        let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Field should not be empty."), style: .alert)
        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
        alert.addButtons([cancel])
        self.present(alert, animated: true)
    }
    
    @objc func payment_WB(str_show_loader:String) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! pay_after_cancel_table_cell
        
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
                    "action"        : "updatepayment",
                    "userId"        : String(myString),
                    "bookingId"     : String(self.str_booking_id),
                    "transactionId"  : String("dummy_transaction_id"),
                    "totalAmount"   : String("5"),
                    "TIP"           : String("0"),
                    "discountAmount"    : String(""),
                    "couponCode"    : String(""),
                    "paymentMethod" : String("Credit Card"),
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
                            
                            // self.back_click_method()
                            self.decline_ride_WB(str_show_loader: "yes")
                            
                            
                            
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
    
    @objc func decline_ride_WB(str_show_loader:String) {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! pay_after_cancel_table_cell

        
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
        let cell = self.tbleView.cellForRow(at: indexPath) as! pay_after_cancel_table_cell
        
        print(textField.text as Any)
        //
        if (textField.text == "") {
            self.str_final_price_to_pay = String(self.str_get_total_price)
            cell.btn_submit.setTitle("Pay : \(self.str_final_price_to_pay!)", for: .normal)
        } else {
            let double_total_price = Double(self.str_get_total_price)!
            let double_tip = Double(textField.text!)!
            //
            let calculate = double_total_price+double_tip
            print(calculate)
            //
            self.str_final_price_to_pay = "\(calculate)"
            cell.btn_submit.setTitle("Pay : \(calculate)", for: .normal)
        }
        
    }
    
}

//MARK:- TABLE VIEW -
extension pay_after_cancel: UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:pay_after_cancel_table_cell = tableView.dequeueReusableCell(withIdentifier: "pay_after_cancel_table_cell") as! pay_after_cancel_table_cell
        
        cell.backgroundColor = .white
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        // cell.txt_card_holder_name.delegate = self
        cell.txt_card_expiry_month.delegate = self
        cell.txt_card_expiry_year.delegate = self
        cell.txt_card_cvv.delegate = self
        cell.txt_card_number.delegate = self
        // cell.txt_tip.delegate = self
        
//        self.str_discounted_amount = String(self.str_get_total_price)
        
//        self.str_final_price_to_pay = String(self.str_get_total_price)
        
        cell.btn_submit.setTitle("Pay 5", for: .normal)
        cell.btn_submit.addTarget(self, action: #selector(validation_before_submit), for: .touchUpInside)
        
        // cell.txt_tip.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }
    
}


class pay_after_cancel_table_cell: UITableViewCell {
    
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
