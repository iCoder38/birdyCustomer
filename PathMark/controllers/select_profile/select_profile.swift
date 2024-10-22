//
//  select_profile.swift
//  PathMark
//
//  Created by Dishant Rajput on 22/05/24.
//



// class select_profile: UIViewController {
    // import UIKit
import UIKit

class select_profile: UIViewController {
    
    @IBOutlet weak var btn_language:UIButton!
    
    @IBOutlet weak var btn_create_ac_account:UIButton! {
        didSet {
            btn_create_ac_account.layer.cornerRadius = 12
            btn_create_ac_account.clipsToBounds = true
            btn_create_ac_account.backgroundColor = .systemOrange
        }
    }
    @IBOutlet weak var btn_login:UIButton!  {
        didSet {
            btn_login.layer.cornerRadius = 12
            btn_login.clipsToBounds = true
            btn_login.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var lbl_title:UILabel!
    @IBOutlet weak var lbl_sub_title:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = viewBackgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                btn_create_ac_account.setTitle("Create an account", for: .normal)
                btn_login.setTitle("Login", for: .normal)
                lbl_title.text = "Hello, welcome to zarib app"
                lbl_sub_title.text = "Get started now"
            } else {
                btn_create_ac_account.setTitle("অ্যাকাউন্ট তৈরি করুন", for: .normal)
                btn_login.setTitle("লগ-ইন", for: .normal)
                lbl_title.text = "হ্যালো, যারিব অ্যাপে আপনাকে স্বাগতম !"
                lbl_sub_title.text = "এখনই শুরু করুন"
            }
            
        }
        
        self.btn_language.addTarget(self, action: #selector(language), for: .touchUpInside)
        self.btn_login.addTarget(self, action: #selector(login_click_method), for: .touchUpInside)
        self.btn_create_ac_account.addTarget(self, action: #selector(register_click_method), for: .touchUpInside)
    }
    
    @objc func login_click_method() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "login_id") as? login
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func register_click_method() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "sign_up_id") as? sign_up
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func language() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "change_language_id") as? change_language
        push!.str_start_screens = "yes"
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func loginButtonTapped() {
        // Handle login button tap action
        print("Login button tapped!")
    }
    
    @objc func createAccountButtonTapped() {
        // Handle create account button tap action
        print("Create an account button tapped!")
    }
}
