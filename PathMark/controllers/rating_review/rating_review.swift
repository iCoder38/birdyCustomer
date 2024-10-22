//
//  rating_review.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 07/09/23.
//

import UIKit
import Alamofire
import SDWebImage

class rating_review: UIViewController {
    
    var str_user_select:String! = "TODAY"
    
    var arr_earnings:NSMutableArray! = []
    
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
                   view_navigation_title.text = "Review & Rating"
               } else {
                   view_navigation_title.text = "রিভিউ ও রেটিং"
               }
               
            
           }
            
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var btn_today:UIButton! {
        didSet {
            btn_today.setTitleColor(.black, for: .normal)
            btn_today.tag = 0
            btn_today.backgroundColor = UIColor.init(red: 250.0/255.0, green: 218.0/255.0, blue: 78.0/255.0, alpha: 1)
            btn_today.setTitle("Today", for: .normal)
        }
    }
    @IBOutlet weak var btn_week:UIButton! {
        didSet {
            btn_week.setTitleColor(.black, for: .normal)
            btn_week.tag = 0
            btn_week.backgroundColor = UIColor.init(red: 250.0/255.0, green: 218.0/255.0, blue: 78.0/255.0, alpha: 1)
            btn_week.setTitle("Weekly", for: .normal)
        }
    }
    
    @IBOutlet weak var lbl_today_line:UILabel! {
        didSet {
            lbl_today_line.backgroundColor = .black
        }
    }
    @IBOutlet weak var lbl_week_line:UILabel! {
        didSet {
            lbl_week_line.backgroundColor = .black
        }
    }
    
    @IBOutlet weak var lbl_my_earnings:UILabel!
    @IBOutlet weak var lbl_spend_time:UILabel!
    @IBOutlet weak var lbl_completed_trips:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.sideBarMenu()
        
        self.rating_review_history(str_show_loader: "yes")
    }
    
    @objc func sideBarMenu() {
        
        if revealViewController() != nil {
            
            btn_back.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    @objc func rating_review_history(str_show_loader:String) {
        
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
            
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                print(token_id_is as Any)
                
                let headers: HTTPHeaders = [
                    "token":String(token_id_is),
                ]
                
                parameters = [
                    "action"    : "reviewlist",
                    "userId"    : String(myString)
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
                           
                            var ar : NSArray!
                            ar = (JSON["data"] as! Array<Any>) as NSArray
                            self.arr_earnings.addObjects(from: ar as! [Any])
                            
                            // print(self.arr_earnings.count as Any)
                            
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
                            
                            self.rating_review_history(str_show_loader: "no")
                            
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


extension rating_review: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arr_earnings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:rating_review_table_cell = tableView.dequeueReusableCell(withIdentifier: "rating_review_table_cell") as! rating_review_table_cell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView

        cell.backgroundColor = .clear
        
        let item = self.arr_earnings[indexPath.row] as? [String:Any]
        cell.lbl_user_name.text = "\(item!["userName"]!)"
        // cell.lbl_distance.text = "\(item!["totalDistance"]!)"
        cell.lbl_time.text = (item!["message"] as! String)
        cell.lbl_time.textColor = .black
        cell.lbl_time.isHidden = false
        cell.lbl_time.backgroundColor = .clear
        
        cell.img_profile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.img_profile.sd_setImage(with: URL(string: (item!["profile_picture"] as! String)), placeholderImage: UIImage(named: "logo33"))
        
        // star manage
        if "\(item!["star"]!)" == "0" {
            
            cell.img_star_one.image = UIImage(systemName: "star")
            cell.img_star_two.image = UIImage(systemName: "star")
            cell.img_star_three.image = UIImage(systemName: "star")
            cell.img_star_four.image = UIImage(systemName: "star")
            cell.img_star_five.image = UIImage(systemName: "star")
            
        } else if "\(item!["star"]!)" > "1" &&
                    "\(item!["star"]!)" < "2" {
            
            cell.img_star_one.image = UIImage(systemName: "star.fill")
            cell.img_star_two.image = UIImage(systemName: "star.leadinghalf.filled")
            cell.img_star_three.image = UIImage(systemName: "star")
            cell.img_star_four.image = UIImage(systemName: "star")
            cell.img_star_five.image = UIImage(systemName: "star")
            
        } else if "\(item!["star"]!)" == "2" {
            
            cell.img_star_one.image = UIImage(systemName: "star.fill")
            cell.img_star_two.image = UIImage(systemName: "star.fill")
            cell.img_star_three.image = UIImage(systemName: "star")
            cell.img_star_four.image = UIImage(systemName: "star")
            cell.img_star_five.image = UIImage(systemName: "star")
            
        } else if "\(item!["star"]!)" > "2" &&
                    "\(item!["star"]!)" < "3" {
            
            cell.img_star_one.image = UIImage(systemName: "star.fill")
            cell.img_star_two.image = UIImage(systemName: "star.fill")
            cell.img_star_three.image = UIImage(systemName: "star.leadinghalf.filled")
            cell.img_star_four.image = UIImage(systemName: "star")
            cell.img_star_five.image = UIImage(systemName: "star")
            
        } else if "\(item!["star"]!)" == "3" {
            
            cell.img_star_one.image = UIImage(systemName: "star.fill")
            cell.img_star_two.image = UIImage(systemName: "star.fill")
            cell.img_star_three.image = UIImage(systemName: "star.fill")
            cell.img_star_four.image = UIImage(systemName: "star")
            cell.img_star_five.image = UIImage(systemName: "star")
            
        } else if "\(item!["star"]!)" > "3" &&
                    "\(item!["star"]!)" < "4" {
            
            cell.img_star_one.image = UIImage(systemName: "star.fill")
            cell.img_star_two.image = UIImage(systemName: "star.fill")
            cell.img_star_three.image = UIImage(systemName: "star.fill")
            cell.img_star_four.image = UIImage(systemName: "star.leadinghalf.filled")
            cell.img_star_five.image = UIImage(systemName: "star")
            
        } else if "\(item!["star"]!)" == "4" {
            
            cell.img_star_one.image = UIImage(systemName: "star.fill")
            cell.img_star_two.image = UIImage(systemName: "star.fill")
            cell.img_star_three.image = UIImage(systemName: "star.fill")
            cell.img_star_four.image = UIImage(systemName: "star.fill")
            cell.img_star_five.image = UIImage(systemName: "star")
            
        } else if "\(item!["star"]!)" == "5" {
            
            cell.img_star_one.image = UIImage(systemName: "star.fill")
            cell.img_star_two.image = UIImage(systemName: "star.fill")
            cell.img_star_three.image = UIImage(systemName: "star.fill")
            cell.img_star_four.image = UIImage(systemName: "star.fill")
            cell.img_star_five.image = UIImage(systemName: "star.fill")
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        let item = self.arr_earnings[indexPath.row] as? [String:Any]
        
        
             if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    let alert = NewYorkAlertController(title: String("Message").uppercased(), message: "\(item!["message"]!)", style: .alert)
                    let cancel = NewYorkButton(title: "OK", style: .cancel)
                    alert.addButtons([cancel])
                    self.present(alert, animated: true)
                } else {
                    let alert = NewYorkAlertController(title: String("বার্তা").uppercased(), message: "\(item!["message"]!)", style: .alert)
                    let cancel = NewYorkButton(title: "OK", style: .cancel)
                    alert.addButtons([cancel])
                    self.present(alert, animated: true)
                }
                
             
            }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           
        return 100 // UITableView.automaticDimension
    }
    
}

class rating_review_table_cell: UITableViewCell {
    
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
    
    @IBOutlet weak var img_profile:UIImageView! {
        didSet {
            img_profile.layer.cornerRadius = 30
            img_profile.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lbl_user_name:UILabel!
    @IBOutlet weak var lbl_distance:UILabel!
    @IBOutlet weak var lbl_distance_text:UILabel!
    @IBOutlet weak var lbl_time:UILabel!
    
    @IBOutlet weak var img_star_one:UIImageView! {
        didSet {
            img_star_one.tintColor = .systemYellow
        }
    }
    
    @IBOutlet weak var img_star_two:UIImageView! {
        didSet {
            img_star_two.tintColor = .systemYellow
        }
    }
    
    @IBOutlet weak var img_star_three:UIImageView! {
        didSet {
            img_star_three.tintColor = .systemYellow
        }
    }
    
    @IBOutlet weak var img_star_four:UIImageView! {
        didSet {
            img_star_four.tintColor = .systemYellow
        }
    }
    
    @IBOutlet weak var img_star_five:UIImageView! {
        didSet {
            img_star_five.tintColor = .systemYellow
        }
    }
    
}
