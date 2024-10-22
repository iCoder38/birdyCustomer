//
//  emergency_contacts.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 11/08/23.
//

import UIKit
import Alamofire
import Toast_Swift

class emergency_contacts: UIViewController {

    var arr_emergency_number:NSMutableArray! = []
    
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
                    view_navigation_title.text = "Emergency Contact"
                } else {
                    view_navigation_title.text = "জরুরী যোগাযোগ"
                }
                
                view_navigation_title.textColor = .white
            }
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            
            // tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var btn_add:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        self.tbleView.separatorColor = .lightGray
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
        
        // login_refresh_token_wb()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.arr_emergency_number.removeAllObjects()
        self.emergency_wb(str_show_loader: "yes")
    }
    
    @objc func sideBarMenuClick() {
        
        self.view.endEditing(true)
        if revealViewController() != nil {
            btn_back.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @objc func add_contacts_click_method() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "add_contacts_id")
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    //
    @objc func emergency_wb(str_show_loader:String) {

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
                
                parameters = [
                    "action"    : "emergencylist",
                    "userId"     : String(myString),
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
                                self.arr_emergency_number.addObjects(from: ar as! [Any])

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
            //        }
            
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
                            
                            
                            self.emergency_wb(str_show_loader: "no")
                            
                            
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
    @objc func delete_contact(emergency_id:String) {

        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            self.arr_emergency_number.removeAllObjects()
            
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "deleting...")
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                print(token_id_is as Any)
                
                let headers: HTTPHeaders = [
                     "token":String(token_id_is),
                ]
                
                parameters = [
                    "action"        : "emergencydelete",
                    "userId"        : String(myString),
                    "emergencyId"   : String(emergency_id),
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
                                
                                var strSuccess2 : String!
                                strSuccess2 = JSON["msg"]as Any as? String
                                
                                // basic usage
                                self.view.makeToast(strSuccess2)
                                    self.emergency_wb(str_show_loader: "no")
                                 
                                
                                
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

extension emergency_contacts: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.arr_emergency_number.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:emergency_contacts_table_cell = tableView.dequeueReusableCell(withIdentifier: "emergency_contacts_table_cell") as! emergency_contacts_table_cell
            
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.backgroundColor = .clear
         
        let item = self.arr_emergency_number[indexPath.row] as? [String:Any]
        // print(item as Any)
        
         
        cell.lbl_name.text = (item!["Name"] as! String)
        cell.lbl_phone.text = (item!["phone"] as! String)
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                
                if ("\(item!["relation"]!)" == "0") {
                    cell.lbl_relation.text = "Relation : Friends"
                } else if ("\(item!["relation"]!)" == "1") {
                    cell.lbl_relation.text = "Relation : Family"
                } else {
                    cell.lbl_relation.text = "Relation : Other"
                }
   
            } else {
                
                if ("\(item!["relation"]!)" == "0") {
                    cell.lbl_relation.text = "সম্পর্ক : Friends"
                } else if ("\(item!["relation"]!)" == "1") {
                    cell.lbl_relation.text = "সম্পর্ক : Family"
                } else {
                    cell.lbl_relation.text = "সম্পর্ক : Other"
                }
            }
            
             
        }
        
        
        
        
        cell.btn_setting.tag = indexPath.row
        cell.btn_setting.addTarget(self, action: #selector(setting_click_method), for: .touchUpInside)
        
        return cell
    }
    
    @objc func setting_click_method(_ sender:UIButton) {

        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                
                let item = self.arr_emergency_number[sender.tag] as? [String:Any]
                
                let alertController = UIAlertController(title: "Settings", message: "", preferredStyle: .actionSheet)
                
                let delete_contact = UIAlertAction(title: "Delete contact", style: .destructive) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    
                    
                    self.delete_contact(emergency_id: "\(item!["emergencyId"]!)" )
                }
                
                let Edit_contact = UIAlertAction(title: "Edit contact", style: .default) {
                    UIAlertAction in
                    NSLog("OK Pressed")

                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "add_contacts_id") as? add_contacts
                    
                    push!.dict_emergency = (item! as NSDictionary)
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                }
                
                let call_contact = UIAlertAction(title: "Call", style: .default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    
                    if let url = URL(string: "tel://\(item!["phone"]!)"), UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(url)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                    
                }
                
                let dismiss = UIAlertAction(title: "Dismiss", style: .cancel) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }

                alertController.addAction(call_contact)
                alertController.addAction(Edit_contact)
                alertController.addAction(delete_contact)
                alertController.addAction(dismiss)
                
                self.present(alertController, animated: true, completion: nil)

   
            } else {
                
                let item = self.arr_emergency_number[sender.tag] as? [String:Any]
                
                let alertController = UIAlertController(title: "সেটিংস", message: "", preferredStyle: .actionSheet)
                
                let delete_contact = UIAlertAction(title: "পরিচিতি মুছুন", style: .destructive) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    
                    
                    self.delete_contact(emergency_id: "\(item!["emergencyId"]!)" )
                }
                
                let Edit_contact = UIAlertAction(title: "সম্পাদনা করুন", style: .default) {
                    UIAlertAction in
                    NSLog("OK Pressed")

                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "add_contacts_id") as? add_contacts
                    
                    push!.dict_emergency = (item! as NSDictionary)
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                }
                
                let call_contact = UIAlertAction(title: "কল", style: .default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    
                    if let url = URL(string: "tel://\(item!["phone"]!)"), UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(url)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                    
                }
                
                let dismiss = UIAlertAction(title: "খারিজ", style: .cancel) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }

                alertController.addAction(call_contact)
                alertController.addAction(Edit_contact)
                alertController.addAction(delete_contact)
                alertController.addAction(dismiss)
                
                self.present(alertController, animated: true, completion: nil)

            }
            
             
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
}

class emergency_contacts_table_cell: UITableViewCell {
    
    @IBOutlet weak var img_profile:UIImageView! {
        didSet {
            img_profile.backgroundColor = .gray
            img_profile.layer.cornerRadius = 30
            img_profile.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lbl_name:UILabel!
    @IBOutlet weak var lbl_phone:UILabel!
    @IBOutlet weak var lbl_relation:UILabel!
    
    @IBOutlet weak var btn_setting:UIButton!
    
}

