//
//  ride_history.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 11/08/23.
//

import UIKit
import Alamofire

class ride_history: UIViewController {

    var str_which_panel_select:String! = "0"
    
    var arr_mut_dashboard_data:NSMutableArray! = []
    
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
                    view_navigation_title.text = "Ride History"
                } else {
                    view_navigation_title.text = "ইতিহাস"
                }
                
                view_navigation_title.textColor = .white
            }
        }
    }
    
    
    
    
    // 250 218 78
    @IBOutlet weak var btn_upcoming_ride:UIButton! {
        didSet {
            btn_upcoming_ride.setTitleColor(.black, for: .normal)
            btn_upcoming_ride.tag = 0
            btn_upcoming_ride.backgroundColor = UIColor.init(red: 250.0/255.0, green: 218.0/255.0, blue: 78.0/255.0, alpha: 1)
            
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_upcoming_ride.setTitle("Upcoming", for: .normal)
                } else {
                    btn_upcoming_ride.setTitle("আসন্ন", for: .normal)
                }
                
                 
            }
            
        }
    }
    
    @IBOutlet weak var btn_completed_ride:UIButton! {
        didSet {
            btn_completed_ride.setTitleColor(.black, for: .normal)
            btn_completed_ride.tag = 0
            btn_completed_ride.backgroundColor = UIColor.init(red: 250.0/255.0, green: 218.0/255.0, blue: 78.0/255.0, alpha: 1)
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_completed_ride.setTitle("History", for: .normal)
                } else {
                    btn_completed_ride.setTitle("ইতিহাস", for: .normal)
                }
                
                 
            }
        }
    }
    
    @IBOutlet weak var lbl_upcoming_mark:UILabel! {
        didSet {
            lbl_upcoming_mark.backgroundColor = navigation_color
            lbl_upcoming_mark.isHidden = true
        }
    }
    
    @IBOutlet weak var lbl_complete_mark:UILabel! {
        didSet {
            lbl_complete_mark.backgroundColor = navigation_color
            lbl_complete_mark.isHidden = true
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            // tbleView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            //  tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var view_search:UIView! {
        didSet {
            view_search.isHidden = true
        }
    }
    @IBOutlet weak var lbl_search_name:UILabel! {
        didSet {
            lbl_search_name.layer.cornerRadius = 12
            lbl_search_name.clipsToBounds = true
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_search_name.text = "All"
                } else {
                    lbl_search_name.text = "সব"
                }
                
                 
            }
        }
    }
    @IBOutlet weak var btn_search:UIButton! {
        didSet {
            btn_search.setTitle("", for: .normal)
        }
    }
    var str_selected_item:String! = "All"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.sideBarMenu()
        
        self.tbleView.separatorColor = .clear
        
        self.lbl_upcoming_mark.isHidden = false
        self.btn_upcoming_ride.addTarget(self, action: #selector(upcoming_ride_click_method), for: .touchUpInside)
        self.btn_completed_ride.addTarget(self, action: #selector(completed_ride_click_method), for: .touchUpInside)
        
        self.arr_mut_dashboard_data.removeAllObjects()
        self.upcoming_ride_WB(str_show_loader: "yes")
        
        self.btn_search.addTarget(self, action: #selector(search_click_method), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // self.arr_mut_dashboard_data.removeAllObjects()
        // self.booking_history(str_show_loader: "yes")
    }
    
    @objc func search_click_method() {
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                let dummyList = ["All", "Completed", "Cancelled"]
                
                RPicker.selectOption(title: "Select", cancelText: "Cancel", dataArray: dummyList, selectedIndex: 0) { (selctedText, atIndex) in
                    
                    self.lbl_search_name.text = String(selctedText)
                    
                    self.booking_history(str_show_loader: "yes")
                }
            } else {
                let dummyList = ["সব", "সম্পন্ন বুকিং", "বাতিল"]
                
                RPicker.selectOption(title: "Select", cancelText: "Cancel", dataArray: dummyList, selectedIndex: 0) { (selctedText, atIndex) in
                    
                    
                    
                    if (String(selctedText) == "সব") {
                        self.lbl_search_name.text = "সব"
                        self.str_selected_item = "All"
                    } else if (String(selctedText) == "সম্পন্ন বুকিং") {
                        self.lbl_search_name.text = "সম্পন্ন বুকিং"
                        self.str_selected_item = "Completed"
                    } else {
                        self.lbl_search_name.text = "বাতিল"
                        self.str_selected_item = "Cancelled"
                    }
                    
                    self.booking_history(str_show_loader: "yes")
                }
            }
            
            
        }
        
       
        
        
    }
    
    @objc func sideBarMenu() {
        if revealViewController() != nil {
            btn_back.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @objc func upcoming_ride_click_method() {
        self.view_search.isHidden = true
        if (self.btn_upcoming_ride.tag == 0) {
            
            self.lbl_upcoming_mark.isHidden = false
            self.lbl_complete_mark.isHidden = true
            
            self.btn_upcoming_ride.tag = 1
        } else {
            
            self.btn_upcoming_ride.tag = 0
        }
        
        //
        self.str_which_panel_select = "0"
        // self.tbleView.reloadData()
        
        self.arr_mut_dashboard_data.removeAllObjects()
        self.upcoming_ride_WB(str_show_loader: "yes")
    }
    
    @objc func completed_ride_click_method() {
        self.validation_before_history()
        
        
    }
    
    @objc func validation_before_history() {
        self.view_search.isHidden = false
        if (self.btn_completed_ride.tag == 0) {
            
            self.lbl_upcoming_mark.isHidden = true
            self.lbl_complete_mark.isHidden = false
            
            self.btn_completed_ride.tag = 1
        } else {
            
            self.btn_completed_ride.tag = 0
        }
        
        //
        self.str_which_panel_select = "1"
        // self.tbleView.reloadData()
        
        self.arr_mut_dashboard_data.removeAllObjects()
        self.booking_history(str_show_loader: "yes")
    }
    
    @objc func booking_history(str_show_loader:String) {
        
        if (str_show_loader == "yes") {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                        print(language as Any)
                        
                        if (language == "en") {
                            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                        } else {
                            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "ড্রাইভার খোঁজা হচ্ছে")
                        }
                        
                        
                    }
                } else {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "ড্রাইভার খোঁজা হচ্ছে")
                }
                
                
            }
            
        }
        
        var lan:String!
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                lan = "en"
            } else {
                lan = "bn"
            }
            
        } else {
            print("=============================")
            print("LOGIN : Select language error")
            print("=============================")
            UserDefaults.standard.set("en", forKey: str_language_convert)
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
                
                if (self.str_selected_item == "All") {
                    parameters = [
                        "action"    : "bookinglist",
                        "userId"    : String(myString),
                        "usertype"  : String("Member"),
                        "language" : String(lan)
                    ]
                } else if (self.str_selected_item == "Completed") {
                    parameters = [
                        "action"    : "bookinglist",
                        "userId"    : String(myString),
                        "usertype"  : String("Member"),
                          "status"    : "5",
                        "language" : String(lan)
                    ]
                } else {
                    parameters = [
                        "action"    : "bookinglist",
                        "userId"    : String(myString),
                        "usertype"  : String("Member"),
                          "status"    : "7",
                        "language" : String(lan)
                    ]
                }
                
                
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
                            
                            self.arr_mut_dashboard_data.removeAllObjects()

                            ERProgressHud.sharedInstance.hide()
                            self.dismiss(animated: true)
                            
                            var ar : NSArray!
                            ar = (JSON["data"] as! Array<Any>) as NSArray
                            self.arr_mut_dashboard_data.addObjects(from: ar as! [Any])
                            
                            // print(self.arr_mut_dashboard_data.count as Any)
                            
                            self.tbleView.delegate = self
                            self.tbleView.dataSource = self
                            self.tbleView.reloadData()
                            
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
                            
                            self.booking_history(str_show_loader: "no")
                            
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
    
    // MARK: - PAYMENT IS PENDING POPUP -
    @objc func payment_is_pending_popup(fullData:NSDictionary) {
        
        let alert = NewYorkAlertController(title: String("Pending Payment").uppercased(), message: "Your payment of \(fullData["FinalFare"]!) is pending. Please pay and clear your all dues.", style: .alert)
        
        let pay = NewYorkButton(title: "pay", style: .default)  {_ in
            
        }
        
        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
        
        alert.addButtons([pay, cancel])
        self.present(alert, animated: true)
        
    }
    
}


extension ride_history: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arr_mut_dashboard_data.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.str_which_panel_select == "0" {
            
            let cell:ride_history_upcoming_table_cell = tableView.dequeueReusableCell(withIdentifier: "ride_history_upcoming_table_cell") as! ride_history_upcoming_table_cell
            
            cell.backgroundColor = .clear
            
            let item = self.arr_mut_dashboard_data[indexPath.row] as? [String:Any]
            print(item as Any)
            
            cell.lbl_name.text = (item!["fullName"] as! String)
            cell.lbl_car_model.text = (item!["CarName"] as! String)
            cell.lbl_car_number.text = (item!["vehicleNumber"] as! String)+" ("+(item!["VehicleColor"] as! String)+")"
            
            cell.lbl_from.text = (item!["RequestPickupAddress"] as! String)
            cell.lbl_to.text = (item!["RequestDropAddress"] as! String)
            
            cell.lbl_date.text = (item!["bookingDate"] as! String)
            
            if "\(item!["rideStatus"]!)" == "1" {
                cell.lbl_status.text = "Accepted"
                cell.lbl_status.textColor = .systemGreen
            }  else if "\(item!["rideStatus"]!)" == "3" {
                cell.lbl_status.text = "On Going"
                cell.lbl_status.textColor = .systemOrange
            }  else if "\(item!["rideStatus"]!)" == "5" {
                
                cell.lbl_status.text = "Completed"
                cell.lbl_status.textColor = .systemGreen
                
            } else if "\(item!["rideStatus"]!)" == "4" {
                
                if "\(item!["paymentStatus"]!)" == "" {
                    cell.lbl_status.backgroundColor = .systemOrange
                    
                    
                    if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                        print(language as Any)
                        
                        if (language == "en") {
                            cell.lbl_status.text = "Pay"
                            
                        } else {
                            cell.lbl_status.text = "এখন পরিশোধ করুন"
                        }
                        
                    } else {
                        print("=============================")
                        print("LOGIN : Select language error")
                        print("=============================")
                        UserDefaults.standard.set("en", forKey: str_language_convert)
                    }
                    
                    cell.lbl_status.textColor = .white
                } else {
                    cell.lbl_status.backgroundColor = .systemGreen
                    
                    if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                        print(language as Any)
                        
                        if (language == "en") {
                            cell.lbl_status.text = "Completed"
                            
                        } else {
                            cell.lbl_status.text = "সম্পূর্ণ হয়েছে "
                        }
                        
                    } else {
                        print("=============================")
                        print("LOGIN : Select language error")
                        print("=============================")
                        UserDefaults.standard.set("en", forKey: str_language_convert)
                    }
                    
                    
                    
                    cell.lbl_status.textColor = .white
                }
                
            }  else if "\(item!["rideStatus"]!)" == "7" {
                
                cell.lbl_status.text = "Cancelled"
                cell.lbl_status.textColor = .systemRed
                
            }  else {
                // compare date
                let dateString = (item!["bookingDate"] as! String)
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let stringDate = String(dateString)
                if let date = dateFormatter.date(from: stringDate) {
                    if date.isInThePast {
                        print("Date is past")
                        
                        cell.lbl_status.backgroundColor = .systemRed
                        cell.lbl_status.text = "Expired"
                        
                    } else if date.isInToday {
                        print("Date is today")
                        if "\(item!["rideStatus"]!)" == "1" {
                            cell.lbl_status.backgroundColor = .systemOrange
                            
                            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                                print(language as Any)
                                
                                if (language == "en") {
                                    cell.lbl_status.text = "Pending"
                                    
                                } else {
                                    cell.lbl_status.text = "অনিষ্পন্ন"
                                }
                                
                            } else {
                                print("=============================")
                                print("LOGIN : Select language error")
                                print("=============================")
                                UserDefaults.standard.set("en", forKey: str_language_convert)
                            }
                            
                            
                        }
                    } else {
                        print("Date is future")
                        if "\(item!["rideStatus"]!)" == "1" {
                            cell.lbl_status.backgroundColor = .systemOrange
                            
                            
                            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                                print(language as Any)
                                
                                if (language == "en") {
                                    cell.lbl_status.text = "Pending"
                                    
                                } else {
                                    cell.lbl_status.text = "অনিষ্পন্ন"
                                }
                                
                            } else {
                                print("=============================")
                                print("LOGIN : Select language error")
                                print("=============================")
                                UserDefaults.standard.set("en", forKey: str_language_convert)
                            }
                            
                            
                            
                        }
                    }
                }
            }
            return cell
        } else {
            
            let cell:ride_history_completed_table_cell = tableView.dequeueReusableCell(withIdentifier: "ride_history_completed_table_cell") as! ride_history_completed_table_cell
            
            cell.backgroundColor = .white
            
            
            let item = self.arr_mut_dashboard_data[indexPath.row] as? [String:Any]
            print(item as Any)
            
            cell.lbl_name_for_complete.text = (item!["fullName"] as! String)
            cell.lbl_car_model_for_complete.text = (item!["CarName"] as! String)
            cell.lbl_address_for_complete.text = (item!["RequestDropAddress"] as! String)
            
            if "\(item!["rideStatus"]!)" == "7" {
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        cell.lbl_status_for_complete.text = "Cancelled"
                    } else {
                        cell.lbl_status_for_complete.text = "যাত্রা বাতিল করুন"
                    }
                    
                 
                } else {
                    print("=============================")
                    print("LOGIN : Select language error")
                    print("=============================")
                    UserDefaults.standard.set("en", forKey: str_language_convert)
                }
                cell.lbl_status_for_complete.textColor = .systemRed
            } else {
                // if payment is empty
                if "\(item!["paymentStatus"]!)" == "" {
                    
                    if "\(item!["rideStatus"]!)" == "1" {
                        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                            print(language as Any)
                            
                            if (language == "en") {
                                cell.lbl_status_for_complete.text = "Driver accepted"
                            } else {
                                cell.lbl_status_for_complete.text = "ড্রাইভার অনুরোধ গ্রহণ করেছে !!"
                            }
                            
                         
                        } else {
                            print("=============================")
                            print("LOGIN : Select language error")
                            print("=============================")
                            UserDefaults.standard.set("en", forKey: str_language_convert)
                        }
                        
                        cell.lbl_status_for_complete.textColor = .systemGreen
                    } else if "\(item!["rideStatus"]!)" == "2" {
                        cell.lbl_status_for_complete.text = "Driver picked you up"
                        cell.lbl_status_for_complete.textColor = .systemYellow
                    } else if "\(item!["rideStatus"]!)" == "3" {
                        cell.lbl_status_for_complete.text = "On Going"
                        cell.lbl_status_for_complete.textColor = .systemOrange
                    } else if "\(item!["rideStatus"]!)" == "4" {
                        
                        if "\(item!["paymentStatus"]!)" == "" {
                            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                                print(language as Any)
                                
                                if (language == "en") {
                                    cell.lbl_status_for_complete.text = "Payment Pending"
                                } else {
                                    cell.lbl_status_for_complete.text = "অনিষ্পন্ন"
                                }
                                
                             
                            } else {
                                print("=============================")
                                print("LOGIN : Select language error")
                                print("=============================")
                                UserDefaults.standard.set("en", forKey: str_language_convert)
                            }
                            cell.lbl_status_for_complete.textColor = .systemBrown
                        } else {
                            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                                print(language as Any)
                                
                                if (language == "en") {
                                    cell.lbl_status_for_complete.text = "Completed"
                                } else {
                                    cell.lbl_status_for_complete.text = "সম্পূর্ণ হয়েছে"
                                }
                                
                             
                            } else {
                                print("=============================")
                                print("LOGIN : Select language error")
                                print("=============================")
                                UserDefaults.standard.set("en", forKey: str_language_convert)
                            }
                            cell.lbl_status_for_complete.textColor = .systemGreen
                        }
                        
                    }  else if "\(item!["rideStatus"]!)" == "5" {
                        
                        if "\(item!["paymentStatus"]!)" == "" {
                            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                                print(language as Any)
                                
                                if (language == "en") {
                                    cell.lbl_status_for_complete.text = "Payment Pending"
                                } else {
                                    cell.lbl_status_for_complete.text = "অনিষ্পন্ন"
                                }
                                
                             
                            } else {
                                print("=============================")
                                print("LOGIN : Select language error")
                                print("=============================")
                                UserDefaults.standard.set("en", forKey: str_language_convert)
                            }
                            cell.lbl_status_for_complete.textColor = .systemBrown
                        } else {
                            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                                print(language as Any)
                                
                                if (language == "en") {
                                    cell.lbl_status_for_complete.text = "Completed"
                                } else {
                                    cell.lbl_status_for_complete.text = "সম্পূর্ণ হয়েছে"
                                }
                                
                             
                            } else {
                                print("=============================")
                                print("LOGIN : Select language error")
                                print("=============================")
                                UserDefaults.standard.set("en", forKey: str_language_convert)
                            }
                            cell.lbl_status_for_complete.textColor = .systemGreen
                            
                        }
                        
                    }
                    
                } else {
                    // if payment done
                    if "\(item!["rideStatus"]!)" == "5" {
                        
                        if "\(item!["paymentStatus"]!)" == "" {
                            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                                print(language as Any)
                                
                                if (language == "en") {
                                    cell.lbl_status_for_complete.text = "Payment Pending"
                                } else {
                                    cell.lbl_status_for_complete.text = "অনিষ্পন্ন"
                                }
                                
                             
                            } else {
                                print("=============================")
                                print("LOGIN : Select language error")
                                print("=============================")
                                UserDefaults.standard.set("en", forKey: str_language_convert)
                            }
                            cell.lbl_status_for_complete.textColor = .systemBrown
                        } else {
                            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                                print(language as Any)
                                
                                if (language == "en") {
                                    cell.lbl_status_for_complete.text = "Completed"
                                } else {
                                    cell.lbl_status_for_complete.text = "সম্পূর্ণ হয়েছে"
                                }
                                
                             
                            } else {
                                print("=============================")
                                print("LOGIN : Select language error")
                                print("=============================")
                                UserDefaults.standard.set("en", forKey: str_language_convert)
                            }
                            cell.lbl_status_for_complete.textColor = .systemGreen
                            
                        }
                        
                    }
                    
                }
            }
            
            
            cell.lbl_status_for_complete.font = UIFont(name:"Poppins-SemiBold", size: 16.0)
            cell.lbl_date_for_complete.text = "\(item!["bookingDate"]!)"
            
            return cell
            
        }
        
    }
        
    @objc func upcoming_ride_WB(str_show_loader:String) {
        
        if (str_show_loader == "yes") {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                     if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                } else {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "ড্রাইভার খোঁজা হচ্ছে")
                }
                
             
            }
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
                    "action"    : "bookinglist",
                    "userId"    : String(myString),
                    "usertype"  : String("Member"),
                    "scheduled" : String("Yes"),
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
                            self.arr_mut_dashboard_data.addObjects(from: ar as! [Any])
                            
                            print(self.arr_mut_dashboard_data.count as Any)
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
                            
                            self.upcoming_ride_WB(str_show_loader: "no")
                            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        let item = self.arr_mut_dashboard_data[indexPath.row] as? [String:Any]
        print(item as Any)
        
        if self.str_which_panel_select == "0" {
            
            // bookingTime
            
            if "\(item!["bookingTime"]!)" != "" { // schedule
                
                if "\(item!["rideStatus"]!)" == "1" {
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "schedule_ride_details_id") as? schedule_ride_details
                    push!.dict_get_booking_details = (item! as NSDictionary)
                    push!.str_from_history = "yes"
                    self.navigationController?.pushViewController(push!, animated: true)
                } else if "\(item!["rideStatus"]!)" == "5" || "\(item!["rideStatus"]!)" == "4" {
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "invoice_id") as? invoice
                     push!.dict_all_details = (item! as NSDictionary)
                    self.navigationController?.pushViewController(push!, animated: true)
                } else if "\(item!["rideStatus"]!)" == "3" || "\(item!["rideStatus"]!)" == "2" {
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ride_status_id") as? ride_status
                    push!.dict_get_all_data_from_notification = (item! as NSDictionary)
                    push!.str_from_history = "yes"
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                }
            } else {
                if "\(item!["rideStatus"]!)" == "5" || "\(item!["rideStatus"]!)" == "4" {
                    
                    if "\(item!["paymentStatus"]!)" == "" {
                        
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "invoice_id") as? invoice
                         push!.dict_all_details = (item! as NSDictionary)
                        self.navigationController?.pushViewController(push!, animated: true)
                        
                        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "before_payment_id") as? before_payment
                        
                        push!.str_booking_id2 = "\(item!["bookingId"]!)"
                        push!.str_get_total_price2 = "\(item!["FinalFare"]!)"
                        push!.get_full_data_for_payment2 = (item! as NSDictionary)
                        
                        self.navigationController?.pushViewController(push!, animated: true)*/
                        
                    }
                } else if "\(item!["rideStatus"]!)" == "3" || "\(item!["rideStatus"]!)" == "1" || "\(item!["rideStatus"]!)" == "2" {
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ride_status_id") as? ride_status
                    push!.dict_get_all_data_from_notification = (item! as NSDictionary)
                    push!.str_from_history = "yes"
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                } else {
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "schedule_ride_details_id") as? schedule_ride_details
                    push!.dict_get_booking_details = (item! as NSDictionary)
                    push!.str_from_history = "yes"
                    self.navigationController?.pushViewController(push!, animated: true)
                }
            }
            
           
            
        } else {
            let item = self.arr_mut_dashboard_data[indexPath.row] as? [String:Any]
            
            if "\(item!["bookingTime"]!)" != "" { // schedule
                if "\(item!["rideStatus"]!)" == "1" {
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "schedule_ride_details_id") as? schedule_ride_details
                    push!.dict_get_booking_details = (item! as NSDictionary)
                    push!.str_from_history = "yes"
                    self.navigationController?.pushViewController(push!, animated: true)
                } else if "\(item!["rideStatus"]!)" == "5" || "\(item!["rideStatus"]!)" == "4" {
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "invoice_id") as? invoice
                     push!.dict_all_details = (item! as NSDictionary)
                    self.navigationController?.pushViewController(push!, animated: true)
                } else if "\(item!["rideStatus"]!)" == "3" || "\(item!["rideStatus"]!)" == "2" {
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ride_status_id") as? ride_status
                    push!.dict_get_all_data_from_notification = (item! as NSDictionary)
                    push!.str_from_history = "yes"
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                }
            } else {
                
            // RIDE IS COMPLETE BUT PAYMENT IS PENDING
            if "\(item!["rideStatus"]!)" == "5" || "\(item!["rideStatus"]!)" == "4" {
                
                if "\(item!["paymentStatus"]!)" == "" {
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "invoice_id") as? invoice
                    push!.dict_all_details = (item! as NSDictionary)
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                    /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "before_payment_id") as? before_payment
                     
                     push!.str_booking_id2 = "\(item!["bookingId"]!)"
                     push!.str_get_total_price2 = "\(item!["FinalFare"]!)"
                     push!.get_full_data_for_payment2 = (item! as NSDictionary)
                     
                     self.navigationController?.pushViewController(push!, animated: true)*/
                    
                    /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "payment_id") as? payment
                     
                     push!.str_booking_id = "\(item!["bookingId"]!)"
                     push!.str_get_total_price = "\(item!["FinalFare"]!)"
                     
                     push!.get_full_data_for_payment = (item! as NSDictionary)
                     push!.str_coupon_code = ""
                     
                     self.navigationController?.pushViewController(push!, animated: true)*/
                    
                } else {
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ride_history_details_id") as? ride_history_details
                    push!.dict_get_booking_details = (item! as NSDictionary)
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                }
                
            } else if "\(item!["rideStatus"]!)" == "3" || "\(item!["rideStatus"]!)" == "1" || "\(item!["rideStatus"]!)" == "2" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ride_status_id") as? ride_status
                push!.dict_get_all_data_from_notification = (item! as NSDictionary)
                push!.str_from_history = "yes"
                
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
        }
            
            
//            self.payment_is_pending_popup(message: )
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.str_which_panel_select == "0" {
            return 220
        } else {
            return UITableView.automaticDimension
        }
        
        
    }
    
}

class ride_history_upcoming_table_cell: UITableViewCell {
    
    @IBOutlet weak var view_bg_full:UIView! {
        didSet {
            view_bg_full.backgroundColor = .white
            
            // shadow
            view_bg_full.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_bg_full.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_bg_full.layer.shadowOpacity = 1.0
            view_bg_full.layer.shadowRadius = 10.0
            view_bg_full.layer.masksToBounds = false
            view_bg_full.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var img_profile:UIImageView! {
        didSet {
            img_profile.backgroundColor = .gray
            img_profile.layer.cornerRadius = 40
            img_profile.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lbl_name:UILabel!
    @IBOutlet weak var lbl_car_model:UILabel!
    @IBOutlet weak var lbl_car_number:UILabel!
    
    @IBOutlet weak var lbl_date:UILabel! {
        didSet {
            lbl_date.backgroundColor = navigation_color
            lbl_date.layer.cornerRadius = 12
            lbl_date.clipsToBounds = true
            lbl_date.text = "May 13th"
            lbl_date.textColor = .white
        }
    }
    
    @IBOutlet weak var lbl_to:UILabel!
    @IBOutlet weak var lbl_from:UILabel!
    
    @IBOutlet weak var lbl_status:UILabel! {
        didSet {
            lbl_status.layer.cornerRadius = 8
            lbl_status.clipsToBounds = true
        }
    }
    
}

class ride_history_completed_table_cell: UITableViewCell {
    
    @IBOutlet weak var img_profile_for_complete:UIImageView! {
        didSet {
            img_profile_for_complete.backgroundColor = .gray
            img_profile_for_complete.layer.cornerRadius = 40
            img_profile_for_complete.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lbl_name_for_complete:UILabel!
    @IBOutlet weak var lbl_car_model_for_complete:UILabel!
    @IBOutlet weak var lbl_address_for_complete:UILabel!
    
    @IBOutlet weak var lbl_status_for_complete:UILabel!
    @IBOutlet weak var lbl_date_for_complete:UILabel!
    
    
}

extension Date {
    static var noon: Date { Date().noon }
    var noon: Date { Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)! }
    var isInToday: Bool { Calendar.current.isDateInToday(self) }
    var isInThePast: Bool { noon < .noon }
    var isInTheFuture: Bool { noon > .noon }
}
