//
//  change_language.swift
//  PathMark
//
//  Created by Dishant Rajput on 23/01/24.
//

import UIKit

class change_language: UIViewController {

    var str_start_screens:String!
    
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
            lblNavigationTitle.text = "Change language"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var btn_english:UIButton!
    @IBOutlet weak var btn_bangla:UIButton!
    
    var str_select_language:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btn_english.addTarget(self, action: #selector(english_click_method), for: .touchUpInside)
        self.btn_bangla.addTarget(self, action: #selector(bangla_click_method), for: .touchUpInside)
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                self.str_select_language = "en"
                self.btn_english.setImage(UIImage(named: "check"), for: .normal)
            } else {
                self.str_select_language = "bn"
                self.btn_bangla.setImage(UIImage(named: "check"), for: .normal)
            }
            
        } else {
            print("=============================")
            print("LOGIN : Select language error")
            print("=============================")
            UserDefaults.standard.set("en", forKey: str_language_convert)
        }
        
        if (self.str_start_screens != nil) {
            self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        } else {
            self.sideBarMenuClick()
        }
        
        
    }
    
    @objc func sideBarMenuClick() {
        
        if revealViewController() != nil {
            
            self.btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    @objc func english_click_method() {
        self.btn_english.setImage(UIImage(named: "check"), for: .normal)
        self.btn_bangla.setImage(UIImage(named: "un_check"), for: .normal)
        UserDefaults.standard.set("en", forKey: str_language_convert)
    }
    
    @objc func bangla_click_method() {
        self.btn_english.setImage(UIImage(named: "un_check"), for: .normal)
        self.btn_bangla.setImage(UIImage(named: "check"), for: .normal)
        UserDefaults.standard.set("bn", forKey: str_language_convert)
    }
    
}
