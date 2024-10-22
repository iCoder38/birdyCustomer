//
//  terms_and_conditions.swift
//  PathMark
//
//  Created by Dishant Rajput on 18/12/23.
//

import UIKit
import WebKit
import Alamofire

class terms_and_conditions: UIViewController {

    @IBOutlet weak var view_navigation_bar:UIView! {
        didSet {
            view_navigation_bar.applyGradient()
        }
    }
    
    @IBOutlet weak var view_navigation_title:UILabel! {
        didSet {
            view_navigation_title.text = "Terms and Condition"
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var btn_accept:UIButton! {
        didSet {
            btn_accept.setTitleColor(.white, for: .normal)
            btn_accept.setTitle("Agree and Continue", for: .normal)
            btn_accept.backgroundColor = .systemYellow
        }
    }
        
    @IBOutlet weak var btn_back:UIButton! {
        didSet {
            btn_back.tintColor = .white
            btn_back.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        }
    }
    
    @IBOutlet weak var view_terms_data:UITextView!
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btn_back.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        self.btn_accept.addTarget(self, action: #selector(accept_click_method), for: .touchUpInside)
        
        // let request = URLRequest(url: URL(string: "https://zaribbd.com/terms-condition/")!)
        // self.webView?.load(request)
        
        self.btn_accept.setImage(UIImage(named: ""), for: .normal)
        
        self.terms_WB()
    }
    
    @objc func accept_click_method() {
        
        let string = "yes_terms"
        UserDefaults.standard.set(string, forKey: "key_accept_term")
        
        
        self.btn_accept.setTitle("Agree and Continue", for: .normal)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func terms_WB() {
         if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                } else {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "ড্রাইভার খোঁজা হচ্ছে")
                }
                
             
            }
        var parameters:Dictionary<AnyHashable, Any>!
        
        parameters = [
            "action" : "termAndConditions_user",
            
        ]
        
        
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
                        
                        var strSuccess : String!
                        strSuccess = JSON["msg"] as? String
                        
                        self.view_terms_data.text = strSuccess.html2String
                        
                        ERProgressHud.sharedInstance.hide()
                    }
                    else {
                        
                        self.hide_loading_UI()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"] as? String
                        
                        let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String(strSuccess2), style: .alert)
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                        
                    }
                    
                }
                
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
                self.hide_loading_UI()
                self.please_check_your_internet_connection()
                
                break
            }
        }
    }
}
