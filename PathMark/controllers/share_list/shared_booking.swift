//
//  shared_booking.swift
//  PathMark
//
//  Created by Dishant Rajput on 23/11/23.
//

import UIKit
import Alamofire
import SDWebImage

class shared_booking: UIViewController {

    var arr_shared_booking:NSMutableArray! = []
    
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
                    
                    view_navigation_title.text = "Shared Booking"
                    
                } else {
                    view_navigation_title.text = "বুকিং শেয়ার করুন"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
            
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var tbleView:UITableView! {
        didSet {
            tbleView.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideBarMenuClick()
        self.share_booking_list_WB(str_show_loader: "yes")
        
    }

    @objc func sideBarMenuClick() {
        
        self.view.endEditing(true)
        if revealViewController() != nil {
            btn_back.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = self.view.frame.size.width
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @objc func share_booking_list_WB(str_show_loader:String) {
        
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
                    "action"        : "sharelist",
                    "userId"        : String(myString),
                    // "userId"        : String("111"),
                    
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
                            
                            var ar : NSArray!
                            ar = (JSON["data"] as! Array<Any>) as NSArray
                            self.arr_shared_booking.addObjects(from: ar as! [Any])
                            
                            print(self.arr_shared_booking.count as Any)
                            ERProgressHud.sharedInstance.hide()
                            
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
                            
                            self.share_booking_list_WB(str_show_loader: "no")
                            
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



//MARK:- TABLE VIEW -
extension shared_booking: UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_shared_booking.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:shared_booking_table_cell = tableView.dequeueReusableCell(withIdentifier: "shared_booking_table_cell") as! shared_booking_table_cell
        
        cell.backgroundColor = .white
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        //
        //
        let item = self.arr_shared_booking[indexPath.row] as? [String:Any]
        print(item as Any)
        
        if "\(item!["rideStatus"]!)" == "1" { 
            cell.lbl_address_name.text = (item!["fullName"] as! String)+" ( Driver accepted )"
        } else if "\(item!["rideStatus"]!)" == "2" {
            cell.lbl_address_name.text = (item!["fullName"] as! String)+" ( Picked you up )"
        } else if "\(item!["rideStatus"]!)" == "3" {
            cell.lbl_address_name.text = (item!["fullName"] as! String)+" ( On the way )"
        } else {
            cell.lbl_address_name.text = (item!["fullName"] as! String)+" ( Driver accepted )"
        }
        //
        //
        cell.lbl_from.text = (item!["RequestPickupAddress"] as! String)
        cell.lbl_to.text = (item!["RequestDropAddress"] as! String)
        
        cell.lbl_vehicle_type.text = (item!["car_name"] as! String)
        cell.lbl_vehicle_number.text = (item!["vehicleNumber"] as! String)+"("+(item!["VehicleColor"] as! String)+")"
        
        cell.lbl_type.text = "Driver's name : \(item!["driver_fullName"] as! String) - \(item!["driver_AVGRating"]!)"
        
        cell.img_profile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.img_profile.sd_setImage(with: URL(string: (item!["car_image"] as! String)), placeholderImage: UIImage(named: "1024"))
        
        cell.img_car_profile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.img_car_profile.sd_setImage(with: URL(string: (item!["driver_image"] as! String)), placeholderImage: UIImage(named: "1024"))
        
        cell.btn_call.tag = indexPath.row
        cell.btn_call.addTarget(self, action: #selector(call), for: .touchUpInside)
        
        return cell
    }
    
    @objc func call(sender:UIButton) {
        print(sender as Any)
        
        let item = self.arr_shared_booking[sender.tag] as? [String:Any]
        
        if let url = URL(string: "tel://\(item!["contactNumber"] as! String)") {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
         }
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.arr_shared_booking[indexPath.row] as? [String:Any]
        
        if "\(item!["rideStatus"]!)" == "4" {
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Ride ended"), style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
        } else if "\(item!["rideStatus"]!)" == "5" {
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Ride ended"), style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
        } else {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "share_track_id") as? share_track
            push!.dict_get_all_shared_booking_details = (item! as NSDictionary)
            self.navigationController?.pushViewController(push!, animated: true)
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 290
    }
    
}


class shared_booking_table_cell: UITableViewCell {
    
    @IBOutlet weak var btn_call:UIButton!
    @IBOutlet weak var btn_chat:UIButton!
    
    @IBOutlet weak var lbl_address_name:UILabel!
    
    @IBOutlet weak var lbl_to:UILabel! {
        didSet {
            lbl_to.textColor = .black
        }
    }
    @IBOutlet weak var lbl_from:UILabel! {
        didSet {
            lbl_from.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_vehicle_type:UILabel!
    @IBOutlet weak var lbl_vehicle_number:UILabel!
    
    @IBOutlet weak var lbl_type:UILabel!
    @IBOutlet weak var img_profile:UIImageView! {
        didSet {
            img_profile.layer.cornerRadius = 25
            img_profile.clipsToBounds = true
        }
    }
    @IBOutlet weak var img_car_profile:UIImageView! {
        didSet {
            img_car_profile.layer.cornerRadius = 25
            img_car_profile.clipsToBounds = true
        }
    }
}
