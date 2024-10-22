//
//  schedule_ride_details.swift
//  PathMark
//
//  Created by Dishant Rajput on 16/11/23.
//

import UIKit
import Alamofire

class schedule_ride_details: UIViewController {
    
    var str_from_history:String!
    
    var dict_get_booking_details:NSDictionary!
    
    var str_total_distance:String! = ""
    var str_total_duration:String! = ""
    var str_total_rupees:String! = ""
    
    @IBOutlet weak var lbl_total_fare_head:UILabel!
    @IBOutlet weak var lbl_distance_head:UILabel!
    
    @IBOutlet weak var view_driver_info:UIView! {
        didSet {
            view_driver_info.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var lbl_price:UILabel! {
        didSet {
            lbl_price.textColor = .white
        }
    }
    @IBOutlet weak var lbl_distance:UILabel! {
        didSet {
            lbl_distance.textColor = .white
        }
    }
    
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
                    view_navigation_title.text = "Schedule ride details"
                } else {
                    view_navigation_title.text = "শিডিউল রাইডের বিবরণ"
                }
                
                view_navigation_title.textColor = .white
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
    
    @IBOutlet weak var btn_chat:UIButton!
    @IBOutlet weak var btn_home:UIButton! {
        didSet {
            btn_home.tintColor = .white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbleView.separatorColor = .clear
        
        print("===================================")
        print("===================================")
        print(self.dict_get_booking_details as Any)
        
        //
        if (self.str_from_history == "yes") {
            self.btn_home.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        } else {
            self.btn_home.addTarget(self, action: #selector(home_click_methodd), for: .touchUpInside)
        }
            
        
        /*
         DriverImage = "https://demo4.evirtualservices.net/pathmark/img/uploads/users/1698962672PLUDIN_1698930400026.png";
         RequestDropAddress = "Anand Vihar ISBT Anand Vihar ISBT";
         RequestDropLatLong = "28.648769385019264,77.31538319058018";
         RequestPickupAddress = "Sector 10 Dwarka, South West Delhi New Delhi, India - 110075";
         RequestPickupLatLong = "28.587139642806772,77.06051312312718";
         VehicleColor = red;
         aps =     {
             alert = "new2 has confirmed your booling.";
         };
         bookingDate = "2023-11-30T00:00:00+0530";
         bookingId = 114;
         bookingTime = "18:54";
         device = Android;
         deviceToken = "";
         driverContact = 5623528523;
         driverId = 92;
         driverLatitude = "28.6634817";
         driverName = new2;
         driverlongitude = "77.3239864";
         estimatedPrice = "22.2";
         "gcm.message_id" = 1700141078871064;
         "google.c.a.e" = 1;
         "google.c.fid" = "cERsVVQO20uFlSaTcL-Hja";
         "google.c.sender.id" = 750959835757;
         message = "new2 has confirmed your booling.";
         rating = 5;
         totalTime = "1 hour 4 mins";
         type = confirm;
         vehicleNumber = yuw62782;
         */
        print("===================================")
        print("===================================")
        
         self.lbl_price.text = "\(str_bangladesh_currency_symbol) \(self.dict_get_booking_details["estimatedPrice"]!)"
         self.lbl_distance.text = "\(self.dict_get_booking_details["totalDistance"]!)"
        
        // self.btn_back.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.btn_chat.addTarget(self, action: #selector(chat_click_method), for: .touchUpInside)
        
    }
    
    @objc func chat_click_method() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BooCheckChatId") as? BooCheckChat
       
        push!.get_all_data = self.dict_get_booking_details
        push!.str_booking_id = "\(self.dict_get_booking_details["bookingId"]!)"
        
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func home_click_methodd() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as? dashboard
        self.navigationController?.pushViewController(push!, animated: true)
        
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
                            
                            // self.find_driver_WB(str_show_loader: "no")
                            
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
    

    // MARK:- GET TOTAL DISTANCE FARE -
    @objc func get_fare_WB() {
        
       /*if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
            
            let headers: HTTPHeaders = [
                "token":String(token_id_is),
            ]
           
           let fullNameArr = fullName.componentsSeparatedByString(" ")
           
           var parameters:Dictionary<AnyHashable, Any>!
           parameters = [
                "action"        : "getprice",
                "pickuplatLong" : String(pickUp),
                "droplatLong"   : String(drop),
                "categoryId"    : String(self.str_get_category_id2),
           ]
         
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
                        
                        var message : String!
                        message = (JSON["msg"] as? String)
                        
                        if strSuccess.lowercased() == "success" {
                             
                            var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            
                            self.hide_loading_UI()
                            self.tbleView.separatorColor = .clear
                            // self.iAmHereForLocationPermission()
                            
                            self.str_total_distance = (dict["distance"] as! String)
                            self.str_total_rupees = "\(dict["total"]!)"
                            self.str_total_duration = (dict["duration"] as! String)
                            
                        }  else if message == String(not_authorize_api) {
                            self.login_refresh_token_wb()
                            
                        } else {
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
        }*/
    }
}

extension schedule_ride_details: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:schedule_ride_details_table_cell = tableView.dequeueReusableCell(withIdentifier: "schedule_ride_details_table_cell") as! schedule_ride_details_table_cell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.lbl_from.text = (self.dict_get_booking_details["RequestPickupAddress"] as! String)
        cell.lbl_to.text = (self.dict_get_booking_details["RequestDropAddress"] as! String)
        
        cell.lbl_price_one.text = "\(str_bangladesh_currency_symbol) \(self.dict_get_booking_details["estimatedPrice"]!)"
        cell.lbl_price_two.text = "\(str_bangladesh_currency_symbol) \(self.dict_get_booking_details["estimatedPrice"]!)"
        
        // @IBOutlet weak var lbl_total_fare_head:UILabel!
        // @IBOutlet weak var lbl_distance_head:UILabel!
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                cell.lbl_total_fare.text = "Total fare : "
                cell.lbl_total.text = "Total : "
                cell.btn_call.setTitle("Call", for: .normal)
                cell.btn_cancel.setTitle("Cancel", for: .normal)
                self.lbl_total_fare_head.text = "TOTAL FARE"
                self.lbl_distance_head.text = "DISTANCE"
            } else {
                cell.lbl_total_fare.text = "মোট ভাড়া : "
                cell.lbl_total.text = "মোট : "
                cell.btn_call.setTitle("ড্রাইভারকে", for: .normal)
                cell.btn_cancel.setTitle("বাতিল", for: .normal)
                self.lbl_total_fare_head.text = "মোট ভাড়া"
                self.lbl_distance_head.text = "দূরত্ব"
            }
            
             
        } else {
            print("=============================")
            print("LOGIN : Select language error")
            print("=============================")
            UserDefaults.standard.set("en", forKey: str_language_convert)
        }
        
        // bookingDate = "2024-01-30T00:00:00+0530";
        
        if (self.str_from_history == "yes") {
            let str = (self.dict_get_booking_details["bookingDate"] as! String)
            let resultString = String(str.prefix(10))
            
            /*let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            let showDate = inputFormatter.date(from: String(result))
            inputFormatter.dateFormat = "MM-dd-yyyy"
            let resultString = inputFormatter.string(from: showDate!)
            print(resultString)*/
            //
            if (self.dict_get_booking_details["bookingTime"] as! String) == "" {
                
                
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        cell.lbl_time.text = "Booking Date and Time : "+String(resultString)+" | "+(self.dict_get_booking_details["bookingTime"] as! String)
                    } else {
                        cell.lbl_time.text = "বুকিংয়ের তারিখ তারিখ এবং : "+String(resultString)+" | "+(self.dict_get_booking_details["bookingTime"] as! String)
                    }
                    
                     
                } else {
                    print("=============================")
                    print("LOGIN : Select language error")
                    print("=============================")
                    UserDefaults.standard.set("en", forKey: str_language_convert)
                }
                
                
            } else {
                let fullName    = (self.dict_get_booking_details["bookingTime"] as! String)
                let fullNameArr = fullName.components(separatedBy: ":")

                let hour    = fullNameArr[0]
                let minute = fullNameArr[1]
                
                var str_am:String! = "am"
                var str_pm:String! = "pm"
                
                var booking_date_and_time_text = ""
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        booking_date_and_time_text = "Booking Date and Time"
                    } else {
                        booking_date_and_time_text = "বুকিংয়ের তারিখ তারিখ এবং"
                    }
                    
                     
                } else {
                    print("=============================")
                    print("LOGIN : Select language error")
                    print("=============================")
                    UserDefaults.standard.set("en", forKey: str_language_convert)
                }
                
                if (hour == "13") {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | 1:"+minute+str_pm
                } else if (hour == "14") {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | 2:"+minute+str_pm
                } else if (hour == "15") {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | 3:"+minute+str_pm
                } else if (hour == "16") {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | 4:"+minute+str_pm
                } else if (hour == "17") {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | 5:"+minute+str_pm
                } else if (hour == "18") {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | 6:"+minute+str_pm
                } else if (hour == "19") {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | 7:"+minute+str_pm
                } else if (hour == "20") {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | 8:"+minute+str_pm
                } else if (hour == "21") {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | 9:"+minute+str_pm
                } else if (hour == "22") {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | 10:"+minute+str_pm
                } else if (hour == "23") {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | 11:"+minute+str_pm
                } else if (hour == "24") {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | 12:"+minute+str_pm
                } else {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | "+(self.dict_get_booking_details["bookingTime"] as! String)+str_am
                }
            }
        } else {
            let str = (self.dict_get_booking_details["bookingDate"] as! String)
            let result = String(str.prefix(10))
            
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            let showDate = inputFormatter.date(from: String(result))
            inputFormatter.dateFormat = "MM-dd-yyyy"
            let resultString = inputFormatter.string(from: showDate!)
            print(resultString)
            
            if (self.dict_get_booking_details["bookingTime"] as! String) == "" {
                // cell.lbl_time.text = "Booking Date and Time : "+String(resultString)+" | "+(self.dict_get_booking_details["bookingTime"] as! String)
                
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        cell.lbl_time.text = "Booking Date and Time : "+String(resultString)+" | "+(self.dict_get_booking_details["bookingTime"] as! String)
                    } else {
                        cell.lbl_time.text = "বুকিংয়ের তারিখ তারিখ এবং : "+String(resultString)+" | "+(self.dict_get_booking_details["bookingTime"] as! String)
                    }
                    
                     
                } else {
                    print("=============================")
                    print("LOGIN : Select language error")
                    print("=============================")
                    UserDefaults.standard.set("en", forKey: str_language_convert)
                }
                
                
                
            } else {
                let fullName    = (self.dict_get_booking_details["bookingTime"] as! String)
                let fullNameArr = fullName.components(separatedBy: ":")

                let hour    = fullNameArr[0]
                let minute = fullNameArr[1]
                
                let str_am:String! = "am"
                let str_pm:String! = "pm"
                
                var booking_date_and_time_text = ""
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        booking_date_and_time_text = "Booking Date and Time"
                    } else {
                        booking_date_and_time_text = "বুকিংয়ের তারিখ তারিখ এবং"
                    }
                    
                     
                } else {
                    print("=============================")
                    print("LOGIN : Select language error")
                    print("=============================")
                    UserDefaults.standard.set("en", forKey: str_language_convert)
                }
                
                if (hour == "13") {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | 1:"+minute+str_pm
                } else if (hour == "14") {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | 2:"+minute+str_pm
                } else if (hour == "15") {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | 3:"+minute+str_pm
                } else if (hour == "16") {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | 4:"+minute+str_pm
                } else if (hour == "17") {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | 5:"+minute+str_pm
                } else if (hour == "18") {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | 6:"+minute+str_pm
                } else if (hour == "19") {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | 7:"+minute+str_pm
                } else if (hour == "20") {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | 8:"+minute+str_pm
                } else if (hour == "21") {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | 9:"+minute+str_pm
                } else if (hour == "22") {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | 10:"+minute+str_pm
                } else if (hour == "23") {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | 11:"+minute+str_pm
                } else if (hour == "24") {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | 12:"+minute+str_pm
                } else {
                    cell.lbl_time.text = "\(booking_date_and_time_text) : "+String(resultString)+" | "+(self.dict_get_booking_details["bookingTime"] as! String)+str_am
                }
            }
        }
        
        
        
         
        
        if (self.str_from_history == "yes") {
            cell.lbl_driver_name.text = (self.dict_get_booking_details["fullName"] as! String)
        } else {
            cell.lbl_driver_name.text = (self.dict_get_booking_details["driverName"] as! String)
        }
        
        if (self.str_from_history == "yes") {
            
            // star manage
            if "\(self.dict_get_booking_details["AVGRating"]!)" == "0" {
                
                cell.img_star_one.image = UIImage(systemName: "star")
                cell.img_star_two.image = UIImage(systemName: "star")
                cell.img_star_three.image = UIImage(systemName: "star")
                cell.img_star_four.image = UIImage(systemName: "star")
                cell.img_star_five.image = UIImage(systemName: "star")
                
            } else if "\(self.dict_get_booking_details["AVGRating"]!)" > "1" &&
                        "\(self.dict_get_booking_details["AVGRating"]!)" < "2" {
                
                cell.img_star_one.image = UIImage(systemName: "star.fill")
                cell.img_star_two.image = UIImage(systemName: "star.leadinghalf.filled")
                cell.img_star_three.image = UIImage(systemName: "star")
                cell.img_star_four.image = UIImage(systemName: "star")
                cell.img_star_five.image = UIImage(systemName: "star")
                
            } else if "\(self.dict_get_booking_details["AVGRating"]!)" == "2" {
                
                cell.img_star_one.image = UIImage(systemName: "star.fill")
                cell.img_star_two.image = UIImage(systemName: "star.fill")
                cell.img_star_three.image = UIImage(systemName: "star")
                cell.img_star_four.image = UIImage(systemName: "star")
                cell.img_star_five.image = UIImage(systemName: "star")
                
                
            } else if "\(self.dict_get_booking_details["AVGRating"]!)" > "2" &&
                        "\(self.dict_get_booking_details["AVGRating"]!)" < "3" {
                
                cell.img_star_one.image = UIImage(systemName: "star.fill")
                cell.img_star_two.image = UIImage(systemName: "star.fill")
                cell.img_star_three.image = UIImage(systemName: "star.leadinghalf.filled")
                cell.img_star_four.image = UIImage(systemName: "star")
                cell.img_star_five.image = UIImage(systemName: "star")
                
            } else if "\(self.dict_get_booking_details["AVGRating"]!)" == "3" {
                
                cell.img_star_one.image = UIImage(systemName: "star.fill")
                cell.img_star_two.image = UIImage(systemName: "star.fill")
                cell.img_star_three.image = UIImage(systemName: "star.fill")
                cell.img_star_four.image = UIImage(systemName: "star")
                cell.img_star_five.image = UIImage(systemName: "star")
                
            } else if "\(self.dict_get_booking_details["AVGRating"]!)" > "3" &&
                        "\(self.dict_get_booking_details["AVGRating"]!)" < "4" {
                
                cell.img_star_one.image = UIImage(systemName: "star.fill")
                cell.img_star_two.image = UIImage(systemName: "star.fill")
                cell.img_star_three.image = UIImage(systemName: "star.fill")
                cell.img_star_four.image = UIImage(systemName: "star.leadinghalf.filled")
                cell.img_star_five.image = UIImage(systemName: "star")
                
            } else if "\(self.dict_get_booking_details["AVGRating"]!)" == "4" {
                
                cell.img_star_one.image = UIImage(systemName: "star.fill")
                cell.img_star_two.image = UIImage(systemName: "star.fill")
                cell.img_star_three.image = UIImage(systemName: "star.fill")
                cell.img_star_four.image = UIImage(systemName: "star.fill")
                cell.img_star_five.image = UIImage(systemName: "star")
                
            } else if "\(self.dict_get_booking_details["AVGRating"]!)" > "4" &&
                        "\(self.dict_get_booking_details["AVGRating"]!)" < "5" {
                
                cell.img_star_one.image = UIImage(systemName: "star.fill")
                cell.img_star_two.image = UIImage(systemName: "star.fill")
                cell.img_star_three.image = UIImage(systemName: "star.fill")
                cell.img_star_four.image = UIImage(systemName: "star.fill")
                cell.img_star_five.image = UIImage(systemName: "star.leadinghalf.filled")
                
            } else if "\(self.dict_get_booking_details["AVGRating"]!)" == "5" {
                
                cell.img_star_one.image = UIImage(systemName: "star.fill")
                cell.img_star_two.image = UIImage(systemName: "star.fill")
                cell.img_star_three.image = UIImage(systemName: "star.fill")
                cell.img_star_four.image = UIImage(systemName: "star.fill")
                cell.img_star_five.image = UIImage(systemName: "star.fill")
                
            }
            
        } else {
            // star manage
            if "\(self.dict_get_booking_details["rating"]!)" == "0" {
                
                cell.img_star_one.image = UIImage(systemName: "star")
                cell.img_star_two.image = UIImage(systemName: "star")
                cell.img_star_three.image = UIImage(systemName: "star")
                cell.img_star_four.image = UIImage(systemName: "star")
                cell.img_star_five.image = UIImage(systemName: "star")
                
            } else if "\(self.dict_get_booking_details["rating"]!)" > "1" &&
                        "\(self.dict_get_booking_details["rating"]!)" < "2" {
                
                cell.img_star_one.image = UIImage(systemName: "star.fill")
                cell.img_star_two.image = UIImage(systemName: "star.leadinghalf.filled")
                cell.img_star_three.image = UIImage(systemName: "star")
                cell.img_star_four.image = UIImage(systemName: "star")
                cell.img_star_five.image = UIImage(systemName: "star")
                
            } else if "\(self.dict_get_booking_details["rating"]!)" == "2" {
                
                cell.img_star_one.image = UIImage(systemName: "star.fill")
                cell.img_star_two.image = UIImage(systemName: "star.fill")
                cell.img_star_three.image = UIImage(systemName: "star")
                cell.img_star_four.image = UIImage(systemName: "star")
                cell.img_star_five.image = UIImage(systemName: "star")
                
                
            } else if "\(self.dict_get_booking_details["rating"]!)" > "2" &&
                        "\(self.dict_get_booking_details["rating"]!)" < "3" {
                
                cell.img_star_one.image = UIImage(systemName: "star.fill")
                cell.img_star_two.image = UIImage(systemName: "star.fill")
                cell.img_star_three.image = UIImage(systemName: "star.leadinghalf.filled")
                cell.img_star_four.image = UIImage(systemName: "star")
                cell.img_star_five.image = UIImage(systemName: "star")
                
            } else if "\(self.dict_get_booking_details["rating"]!)" == "3" {
                
                cell.img_star_one.image = UIImage(systemName: "star.fill")
                cell.img_star_two.image = UIImage(systemName: "star.fill")
                cell.img_star_three.image = UIImage(systemName: "star.fill")
                cell.img_star_four.image = UIImage(systemName: "star")
                cell.img_star_five.image = UIImage(systemName: "star")
                
            } else if "\(self.dict_get_booking_details["rating"]!)" > "3" &&
                        "\(self.dict_get_booking_details["rating"]!)" < "4" {
                
                cell.img_star_one.image = UIImage(systemName: "star.fill")
                cell.img_star_two.image = UIImage(systemName: "star.fill")
                cell.img_star_three.image = UIImage(systemName: "star.fill")
                cell.img_star_four.image = UIImage(systemName: "star.leadinghalf.filled")
                cell.img_star_five.image = UIImage(systemName: "star")
                
            } else if "\(self.dict_get_booking_details["rating"]!)" == "4" {
                
                cell.img_star_one.image = UIImage(systemName: "star.fill")
                cell.img_star_two.image = UIImage(systemName: "star.fill")
                cell.img_star_three.image = UIImage(systemName: "star.fill")
                cell.img_star_four.image = UIImage(systemName: "star.fill")
                cell.img_star_five.image = UIImage(systemName: "star")
                
            } else if "\(self.dict_get_booking_details["rating"]!)" > "4" &&
                        "\(self.dict_get_booking_details["rating"]!)" < "5" {
                
                cell.img_star_one.image = UIImage(systemName: "star.fill")
                cell.img_star_two.image = UIImage(systemName: "star.fill")
                cell.img_star_three.image = UIImage(systemName: "star.fill")
                cell.img_star_four.image = UIImage(systemName: "star.fill")
                cell.img_star_five.image = UIImage(systemName: "star.leadinghalf.filled")
                
            } else if "\(self.dict_get_booking_details["rating"]!)" == "5" {
                
                cell.img_star_one.image = UIImage(systemName: "star.fill")
                cell.img_star_two.image = UIImage(systemName: "star.fill")
                cell.img_star_three.image = UIImage(systemName: "star.fill")
                cell.img_star_four.image = UIImage(systemName: "star.fill")
                cell.img_star_five.image = UIImage(systemName: "star.fill")
                
            }
        }
        
        
        /*cell.lbl_car_driver_name.text = (self.dict_get_booking_details["fullName"] as! String)
        
        cell.lbl_from.text = (self.dict_get_booking_details["RequestPickupAddress"] as! String)
        cell.lbl_to.text = (self.dict_get_booking_details["RequestDropAddress"] as! String)
        
        cell.lbl_fare.text = "\(self.dict_get_booking_details["FinalFare"]!)"
        cell.lbl_tip.text = "\(self.dict_get_booking_details["TIP"]!)"
        cell.lbl_promotion.text = "\(self.dict_get_booking_details["discountAmount"]!)"
        
        // tip
        let i_am_tip:String!
        if "\(self.dict_get_booking_details["TIP"]!)" == "" {
            i_am_tip = "0.0"
        } else {
            i_am_tip = "\(self.dict_get_booking_details["TIP"]!)"
        }
        
        // promotion
        let i_am_promotion:String!
        if "\(self.dict_get_booking_details["discountAmount"]!)" == "" {
            i_am_promotion = "0.0"
        } else {
            i_am_promotion = "\(self.dict_get_booking_details["discountAmount"]!)"
        }
        
        let double_fare = Double("\(self.dict_get_booking_details["FinalFare"]!)")
        let double_tip = Double(i_am_tip)
        let double_promotion = Double(i_am_promotion)
        
        let add_all = double_fare!+double_tip!+double_promotion!
        cell.lbl_total_amount.text = "\(add_all)"
        
        cell.lbl_car_number.text = "\(self.dict_get_booking_details["CarName"]!)"+" "+"\(self.dict_get_booking_details["vehicleNumber"]!)"
        cell.lbl_car_color.text = "\(self.dict_get_booking_details["VehicleColor"]!)"
        
        cell.img_car_image.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.img_car_image.sd_setImage(with: URL(string: (self.dict_get_booking_details["carImage"] as! String)), placeholderImage: UIImage(named: "logo33"))
        
        cell.img_driver_profile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.img_driver_profile.sd_setImage(with: URL(string: (self.dict_get_booking_details["image"] as! String)), placeholderImage: UIImage(named: "logo33"))
        
        cell.lbl_rating.text = "\(self.dict_get_booking_details["AVGRating"]!)"
        
        if "\(self.dict_get_booking_details["rideStatus"]!)" == "5" {
            
            if "\(self.dict_get_booking_details["paymentStatus"]!)" != "" {
                cell.img_gif.isHidden = false
                cell.img_gif.image = UIImage.gif(name: "double-check")
            } else {
                cell.img_gif.isHidden = true
            }
            
        } else {
            cell.img_gif.isHidden = true
        }*/
        cell.btn_cancel.addTarget(self, action: #selector(cancel_ride_click_method2), for: .touchUpInside)
        cell.backgroundColor = .clear
        
        return cell
        
    }
     
        @objc func cancel_ride_click_method2() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myAlert = storyboard.instantiateViewController(withIdentifier: "decline_request_id") as? decline_request
            myAlert!.dict_booking_details = self.dict_get_booking_details
            myAlert!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            myAlert!.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            present(myAlert!, animated: true, completion: nil)
        }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           
        return 486
    }
    
}

class schedule_ride_details_table_cell: UITableViewCell {
    
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
    
    @IBOutlet weak var btn_chat:UIButton!
    
    @IBOutlet weak var lbl_fare:UILabel!
    @IBOutlet weak var lbl_tip:UILabel!
    @IBOutlet weak var lbl_promotion:UILabel!
    @IBOutlet weak var lbl_total_amount:UILabel!
    
    @IBOutlet weak var view_star:UIView! {
        didSet {
            view_star.backgroundColor = .white
            
            // shadow
            view_star.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_star.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_star.layer.shadowOpacity = 1.0
            view_star.layer.shadowRadius = 10.0
            view_star.layer.masksToBounds = false
            view_star.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var view_driver_info:UIView! {
        didSet {
            view_driver_info.backgroundColor = .white
            
            // shadow
            view_driver_info.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_driver_info.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_driver_info.layer.shadowOpacity = 1.0
            view_driver_info.layer.shadowRadius = 10.0
            view_driver_info.layer.masksToBounds = false
            view_driver_info.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var lbl_car_driver_name:UILabel!
    @IBOutlet weak var lbl_car_number:UILabel!
    @IBOutlet weak var lbl_car_color:UILabel!
    
    @IBOutlet weak var lbl_time:UILabel!
    
    @IBOutlet weak var lbl_driver_name:UILabel!
    
    @IBOutlet weak var lbl_total_fare:UILabel!
    @IBOutlet weak var lbl_total:UILabel!
    
    @IBOutlet weak var btn_call:UIButton! {
        didSet {
            btn_call.layer.cornerRadius = 12
            btn_call.clipsToBounds = true
            btn_call.setTitleColor(.black, for: .normal)
            btn_call.backgroundColor = .white
            btn_call.tintColor = .systemGreen
        }
    }
    @IBOutlet weak var btn_cancel:UIButton! {
        didSet {
            btn_cancel.layer.cornerRadius = 12
            btn_cancel.clipsToBounds = true
            btn_cancel.setTitleColor(.black, for: .normal)
            btn_cancel.backgroundColor = .white
            btn_cancel.tintColor = .systemRed
        }
    }
    
    @IBOutlet weak var lbl_text:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_text.text = "Driver will wait only 10 minutes after the schedule ride time. **Cancellation fee will be apply if you cancel the schedule ride."
                } else {
                    lbl_text.text = "ড্রাইভার সিডিউল রাইড সময়ের পর ১০ মিনিট পর্যন্ত অপেক্ষা করবেন। আপনি রাইড বাতিল করলে ফি যুক্ত হবে।"
                }
                
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    
    @IBOutlet weak var lbl_price_one:UILabel!
    @IBOutlet weak var lbl_price_two:UILabel! {
        didSet {
            lbl_price_two.textColor = .systemOrange
        }
    }
    
    @IBOutlet weak var img_car_image:UIImageView! {
        didSet {
            img_car_image.layer.cornerRadius = 20
            img_car_image.clipsToBounds = true
        }
    }
    
    /*@IBOutlet weak var img_driver_profile:UIImageView! {
        didSet {
            img_car_image.layer.cornerRadius = 25
            img_car_image.clipsToBounds = true
        }
    }*/
 
    @IBOutlet weak var img_gif:UIImageView!
    
    @IBOutlet weak var lbl_rating:UILabel!

    @IBOutlet weak var img_star_one:UIImageView!
    @IBOutlet weak var img_star_two:UIImageView!
    @IBOutlet weak var img_star_three:UIImageView!
    @IBOutlet weak var img_star_four:UIImageView!
    @IBOutlet weak var img_star_five:UIImageView!
}
