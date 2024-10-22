//
//  address_list.swift
//  PathMark
//
//  Created by Dishant Rajput on 17/08/23.
//

import UIKit
import Alamofire

class address_list: UIViewController {

    var arr_address_list:NSMutableArray! = []
    
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
                    
                    view_navigation_title.text = "ADDRESSES LIST"
                    
                } else {
                    view_navigation_title.text = "ঠিকানার তালিকা"
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
    
    
    @IBOutlet weak var tbleView:UITableView!
    @IBOutlet weak var btn_add:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbleView.separatorColor = .clear
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                
                btn_add.setTitle("+ add", for: .normal)
            } else {
                btn_add.setTitle("+ যোগ করুন", for: .normal)
            }
            
            
        }
        
        self.sideBarMenuClick()

        self.btn_add.addTarget(self, action: #selector(add_contacts_click_method), for: .touchUpInside)        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.arr_address_list.removeAllObjects()
        self.address_list_wb(str_show_loader: "yes")
    }
    
    @objc func sideBarMenuClick() {
        
        self.view.endEditing(true)
        if revealViewController() != nil {
            btn_back.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @objc func add_contacts_click_method() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "add_address_id")
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    //
    @objc func address_list_wb(str_show_loader:String) {

        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            
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
                    "action"    : "addresslist",
                    "userId"     : String(myString),
                    "language"      : String(lan)
                ]
                
                print(headers)
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
                            
                            if strSuccess.lowercased() == "success" {
                                ERProgressHud.sharedInstance.hide()
                                
                                var ar : NSArray!
                                ar = (JSON["data"] as! Array<Any>) as NSArray
                                self.arr_address_list.addObjects(from: ar as! [Any])

                                let str_token = (JSON["AuthToken"] as! String)
                                UserDefaults.standard.set("", forKey: str_save_last_api_token)
                                UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                                
                                self.tbleView.delegate = self
                                self.tbleView.dataSource = self
                                self.tbleView.reloadData()
                            }
                            else {
                                self.login_refresh_token_wb()
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
                                                        
                            self.address_list_wb(str_show_loader: "no")
 
                        }
                        else {
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
    
    
    // delete contact
    @objc func delete_address(address_id:String) {

        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            self.arr_address_list.removeAllObjects()
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "deleting...")
                } else {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "মুছে ফেলা...")
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                print(token_id_is as Any)
                
                let headers: HTTPHeaders = [
                     "token":String(token_id_is),
                ]
                
                parameters = [
                    "action"        : "addressdelete",
                    "userId"        : String(myString),
                    "addressId"   : String(address_id),
                ]
                
                print(headers)
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
                            ERProgressHud.sharedInstance.hide()
                            
                            if strSuccess.lowercased() == "success" {
                                
                                 let str_token = (JSON["AuthToken"] as! String)
                                UserDefaults.standard.set("", forKey: str_save_last_api_token)
                                UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                                
                                self.address_list_wb(str_show_loader: "no")
                            }
                            else {
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
}


//MARK:- TABLE VIEW -
extension address_list: UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_address_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:address_list_table_cell = tableView.dequeueReusableCell(withIdentifier: "address_list_table_cell") as! address_list_table_cell
        
        cell.backgroundColor = .white
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        let item = self.arr_address_list[indexPath.row] as? [String:Any]
        print(item as Any)
        
        if ("\(item!["addressType"]!)" == "0") {
            cell.lbl_title.text = "Home"
        } else if ("\(item!["addressType"]!)" == "1") {
            cell.lbl_title.text = "Work"
        } else {
            cell.lbl_title.text = "other"
        }
        
        cell.lbl_sub_title.text = (item!["address"] as! String)
        
        cell.btn_setting.tag = indexPath.row
        cell.btn_setting.addTarget(self, action: #selector(setting_click_method), for: .touchUpInside)
        
        return cell
    }
    
    @objc func setting_click_method(_ sender:UIButton) {

        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                
                let item = self.arr_address_list[sender.tag] as? [String:Any]
                
                let alertController = UIAlertController(title: "Settings", message: "", preferredStyle: .actionSheet)
                
                let delete_contact = UIAlertAction(title: "Delete address", style: .destructive) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    
                    
                     self.delete_address(address_id: "\(item!["addressId"]!)" )
                }
                
                let Edit_contact = UIAlertAction(title: "Edit address", style: .default) {
                    UIAlertAction in
                    NSLog("OK Pressed")

                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "add_address_id") as? add_address
                    
                    push!.dict_address = (item! as NSDictionary)
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                }
                 
                
                let dismiss = UIAlertAction(title: "Dismiss", style: .cancel) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }

                 
                alertController.addAction(Edit_contact)
                alertController.addAction(delete_contact)
                alertController.addAction(dismiss)
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                let item = self.arr_address_list[sender.tag] as? [String:Any]
                
                let alertController = UIAlertController(title: "সেটিংস", message: "", preferredStyle: .actionSheet)
                
                let delete_contact = UIAlertAction(title: "ঠিকানা মুছুন", style: .destructive) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    
                    
                     self.delete_address(address_id: "\(item!["addressId"]!)" )
                }
                
                let Edit_contact = UIAlertAction(title: "ঠিকানা সম্পাদনা করুন", style: .default) {
                    UIAlertAction in
                    NSLog("OK Pressed")

                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "add_address_id") as? add_address
                    
                    push!.dict_address = (item! as NSDictionary)
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                }
                 
                
                let dismiss = UIAlertAction(title: "খারিজ", style: .cancel) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }

                 
                alertController.addAction(Edit_contact)
                alertController.addAction(delete_contact)
                alertController.addAction(dismiss)
                
                self.present(alertController, animated: true, completion: nil)
            }
            
            
        }
        
        
        

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

class address_list_table_cell: UITableViewCell {
    
    @IBOutlet weak var view_bg:UIView! {
        didSet {
            // shadow
            view_bg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_bg.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_bg.layer.shadowOpacity = 1.0
            view_bg.layer.shadowRadius = 10.0
            view_bg.layer.masksToBounds = false
            view_bg.layer.cornerRadius = 12
            view_bg.backgroundColor = .white
            
        }
    }
    
    @IBOutlet weak var lbl_title:UILabel!
    @IBOutlet weak var lbl_sub_title:UILabel!
    
    @IBOutlet weak var btn_setting:UIButton!
}
