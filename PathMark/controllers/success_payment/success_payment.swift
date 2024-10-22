//
//  success_payment.swift
//  PathMark
//
//  Created by Dishant Rajput on 06/09/23.
//

import UIKit
import Alamofire

class success_payment: UIViewController {

    var str_show_total_price:String!
    
    var get_booking_details:NSDictionary!
    
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
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    view_navigation_title.text = "Payment Successful"
                } else {
                    view_navigation_title.text = "পেমেন্ট সফল হয়েছে"
                }
                
            }
            
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var view_price:UIView! {
        didSet {
            view_price.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_date_time: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("===================================")
        print("===================================")
        print(self.get_booking_details as Any)
        print("===================================")
        print("===================================")
        
        self.btn_back.isHidden = true
        self.btn_back.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard2))
        view.addGestureRecognizer(tap)
        
        if (self.str_show_total_price == nil) {
            self.lbl_price.text = "\(str_bangladesh_currency_symbol)\(self.get_booking_details["FinalFare"]!)"
        } else {
            self.lbl_price.text = "\(str_bangladesh_currency_symbol)\(self.str_show_total_price!)"
        }
        // self.lbl_price.text = "\(str_bangladesh_currency_symbol)\(self.str_show_total_price!)"
        
        if (self.get_booking_details["created"]) == nil {
            self.lbl_date_time.text = ""
        } else {
            self.lbl_date_time.text = "\(self.get_booking_details["created"]!)"
        }
      
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard2() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func validate_before_submit_wb() {
        /*let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! success_payment_table_cell
        if (cell.lbl_star_count.text != "5") {
            
            if (cell.txt_view.text == "") {
                
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        let alert = NewYorkAlertController(title: nil, message: String("Please enter some comment"), style: .alert)
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                    } else {
                        let alert = NewYorkAlertController(title: nil, message: String("আপনার মন্তব্য লিখুন"), style: .alert)
                        let cancel = NewYorkButton(title: "ঠিক আছে", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                    }
                    
                    
                }
                
                
            } else {
                self.submit_review_WB(str_show_loader: "yes")
            }
            
            
            
        } else {*/
            self.submit_review_WB(str_show_loader: "yes")
        // }
        
        
    }
    
    @objc func submit_review_WB(str_show_loader:String) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! success_payment_table_cell
        
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
                
//                if (self.get_booking_details["created"]) == nil {
//                    self.lbl_date_time.text = ""
//                } else {
//                    self.lbl_date_time.text = "\(self.get_booking_details["created"]!)"
//                }
                
                var reviewTo:String!
                
                if (self.get_booking_details["driverId"] == nil) {
                    reviewTo = "\(self.get_booking_details["userId"]!)"
                } else {
                    reviewTo = "\(self.get_booking_details["driverId"]!)"
                }
                
                parameters = [
                    "action"        : "submitreview",
                    "reviewFrom"    : String(myString),
                    "reviewTo"      : String(reviewTo),
                    "star"          : String(cell.lbl_star_count.text!),
                    "message"       : String(cell.txt_view.text!),
                    "bookingId"     : "\(self.get_booking_details["bookingId"]!)"
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
                            self.dismiss(animated: true)
                            
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ride_history_id") as? ride_history
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
                            
                            self.submit_review_WB(str_show_loader: "no")
                            
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

extension success_payment: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:success_payment_table_cell = tableView.dequeueReusableCell(withIdentifier: "success_payment_table_cell") as! success_payment_table_cell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView

        cell.backgroundColor = .clear
        
        cell.lbl_from.text = (self.get_booking_details["RequestPickupAddress"] as! String)
        cell.lbl_to.text = (self.get_booking_details["RequestDropAddress"] as! String)
        
        cell.btn_star_one.addTarget(self, action: #selector(one_click_method), for: .touchUpInside)
        cell.btn_star_two.addTarget(self, action: #selector(two_click_method), for: .touchUpInside)
        cell.btn_star_three.addTarget(self, action: #selector(three_click_method), for: .touchUpInside)
        cell.btn_star_four.addTarget(self, action: #selector(four_click_method), for: .touchUpInside)
        cell.btn_star_five.addTarget(self, action: #selector(five_click_method), for: .touchUpInside)
        
        cell.btn_submit.addTarget(self, action: #selector(validate_before_submit_wb), for: .touchUpInside)
        
        return cell
        
    }
    
    @objc func one_click_method() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! success_payment_table_cell
        
        cell.btn_star_one.setImage(UIImage(systemName: "star.fill"), for: .normal)
        cell.btn_star_two.setImage(UIImage(systemName: "star"), for: .normal)
        cell.btn_star_three.setImage(UIImage(systemName: "star"), for: .normal)
        cell.btn_star_four.setImage(UIImage(systemName: "star"), for: .normal)
        cell.btn_star_five.setImage(UIImage(systemName: "star"), for: .normal)
        
        cell.lbl_star_count.text = "1"
    }
    
    @objc func two_click_method() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! success_payment_table_cell
        
        cell.btn_star_one.setImage(UIImage(systemName: "star.fill"), for: .normal)
        cell.btn_star_two.setImage(UIImage(systemName: "star.fill"), for: .normal)
        cell.btn_star_three.setImage(UIImage(systemName: "star"), for: .normal)
        cell.btn_star_four.setImage(UIImage(systemName: "star"), for: .normal)
        cell.btn_star_five.setImage(UIImage(systemName: "star"), for: .normal)
        
        cell.lbl_star_count.text = "2"
    }
    
    @objc func three_click_method() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! success_payment_table_cell
        
        cell.btn_star_one.setImage(UIImage(systemName: "star.fill"), for: .normal)
        cell.btn_star_two.setImage(UIImage(systemName: "star.fill"), for: .normal)
        cell.btn_star_three.setImage(UIImage(systemName: "star.fill"), for: .normal)
        cell.btn_star_four.setImage(UIImage(systemName: "star"), for: .normal)
        cell.btn_star_five.setImage(UIImage(systemName: "star"), for: .normal)
        
        cell.lbl_star_count.text = "3"
    }
    
    @objc func four_click_method() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! success_payment_table_cell
        
        cell.btn_star_one.setImage(UIImage(systemName: "star.fill"), for: .normal)
        cell.btn_star_two.setImage(UIImage(systemName: "star.fill"), for: .normal)
        cell.btn_star_three.setImage(UIImage(systemName: "star.fill"), for: .normal)
        cell.btn_star_four.setImage(UIImage(systemName: "star.fill"), for: .normal)
        cell.btn_star_five.setImage(UIImage(systemName: "star"), for: .normal)
        
        cell.lbl_star_count.text = "4"
    }
    
    @objc func five_click_method() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! success_payment_table_cell
        
        cell.btn_star_one.setImage(UIImage(systemName: "star.fill"), for: .normal)
        cell.btn_star_two.setImage(UIImage(systemName: "star.fill"), for: .normal)
        cell.btn_star_three.setImage(UIImage(systemName: "star.fill"), for: .normal)
        cell.btn_star_four.setImage(UIImage(systemName: "star.fill"), for: .normal)
        cell.btn_star_five.setImage(UIImage(systemName: "star.fill"), for: .normal)
        
        cell.lbl_star_count.text = "5"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           
        return 800
    }
    
}


class success_payment_table_cell: UITableViewCell {
    
    @IBOutlet weak var lbl_write_your_comment_text:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_write_your_comment_text.text = "Write your comment"
                } else {
                    lbl_write_your_comment_text.text = "আপনার মন্তব্য লিখুন"
                }
                
                
            }
            
            
        }
    }
    
    @IBOutlet weak var view_from_to:UIView! {
        didSet {
            view_from_to.backgroundColor = .white
            
            // shadow
            view_from_to.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_from_to.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_from_to.layer.shadowOpacity = 1.0
            view_from_to.layer.shadowRadius = 10.0
            view_from_to.layer.masksToBounds = false
            view_from_to.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var lbl_from:UILabel!
    @IBOutlet weak var lbl_to:UILabel!
    
    @IBOutlet weak var view_fare:UIView! {
        didSet {
            view_fare.backgroundColor = .white
            
            // shadow
            view_fare.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_fare.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_fare.layer.shadowOpacity = 1.0
            view_fare.layer.shadowRadius = 10.0
            view_fare.layer.masksToBounds = false
            view_fare.layer.cornerRadius = 12
        }
    }
   
    @IBOutlet weak var lbl_star_count:UILabel! {
        didSet {
            lbl_star_count.text = "1"
        }
    }
    
    @IBOutlet weak var btn_star_one:UIButton!
    @IBOutlet weak var btn_star_two:UIButton!
    @IBOutlet weak var btn_star_three:UIButton!
    @IBOutlet weak var btn_star_four:UIButton!
    @IBOutlet weak var btn_star_five:UIButton!
    
    @IBOutlet weak var view_star_rating:UIView!
    
    @IBOutlet weak var txt_view:UITextView! {
        didSet {
            txt_view.backgroundColor = .clear
            txt_view.text = ""
        }
    }
    
    @IBOutlet weak var btn_submit:UIButton! {
        didSet {
             
            Utils.buttonStyle(button: btn_submit,
                              bCornerRadius: 12,
                              bBackgroundColor: UIColor(red: 246.0/255.0, green: 200.0/255.0, blue: 68.0/255.0, alpha: 1),
                              bTitle: "Submit",
                              bTitleColor: .black)
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_submit.setTitle("Submit", for: .normal)
                } else {
                    btn_submit.setTitle("জমা দিন", for: .normal)
                }
                
                
            }
            
            btn_submit.layer.masksToBounds = false
            btn_submit.layer.shadowColor = UIColor.black.cgColor
            btn_submit.layer.shadowOffset =  CGSize.zero
            btn_submit.layer.shadowOpacity = 0.5
            btn_submit.layer.shadowRadius = 2
            
        }
    }
    
}
