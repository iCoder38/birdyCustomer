//
//  cancel_your_ride.swift
//  PathMark
//
//  Created by Dishant Rajput on 22/11/23.
//

import UIKit

class cancel_your_ride: UIViewController {
    
    var dict_get_data_from_notification:NSDictionary!
    var window: UIWindow?
    @IBOutlet weak var view_bg:UIView! {
        didSet {
            view_bg.layer.cornerRadius = 12
            view_bg.clipsToBounds = true
            view_bg.backgroundColor = .white
            view_bg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_bg.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_bg.layer.shadowOpacity = 1.0
            view_bg.layer.shadowRadius = 15.0
            view_bg.layer.masksToBounds = false
        }
    }
    
    @IBOutlet weak var lbl_one:UILabel! {
        didSet {
            lbl_one.numberOfLines = 0
            lbl_one.text = "You ride has been cancelled"
             
        }
    }
    
    @IBOutlet weak var btn_dismiss:UIButton! {
        didSet {
            btn_dismiss.layer.cornerRadius = 12
            btn_dismiss.clipsToBounds = true
            btn_dismiss.backgroundColor = .systemRed
            btn_dismiss.setTitle("OK", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if (self.dict_get_data_from_notification["cancelReason"] as! String) == "0" {
            self.lbl_one.text = "\(self.dict_get_data_from_notification["message"] as! String)\n\nReason: Passenger denied to go to destination.\n\n\(self.dict_get_data_from_notification["cancelComment"] as! String)"
        } else if (self.dict_get_data_from_notification["cancelReason"] as! String) == "1" {
            self.lbl_one.text = "\(self.dict_get_data_from_notification["message"] as! String)\n\nReason: Passenger denied to come to pickup.\n\n\(self.dict_get_data_from_notification["cancelComment"] as! String)"
        } else if (self.dict_get_data_from_notification["cancelReason"] as! String) == "2" {
            self.lbl_one.text = "\(self.dict_get_data_from_notification["message"] as! String)\n\nReason: Expected a shorter a wait time.\n\n\(self.dict_get_data_from_notification["cancelComment"] as! String)"
        } else if (self.dict_get_data_from_notification["cancelReason"] as! String) == "3" {
            self.lbl_one.text = "\(self.dict_get_data_from_notification["message"] as! String)\n\nReason: Unable to contact Passenger.\n\n\(self.dict_get_data_from_notification["cancelComment"] as! String)"
        } else {
            self.lbl_one.text = "\(self.dict_get_data_from_notification["message"] as! String)\n\n\(self.dict_get_data_from_notification["cancelComment"] as! String)"
        }
        
//        if (self.dict_get_data_from_notification["cancelComment"] as! String) != "" {
//            self.lbl_one.text = "You ride has been cancelled.\n"+(self.dict_get_data_from_notification["cancelReason"] as! String)+"\n Reason : "+(self.dict_get_data_from_notification["cancelReason"] as! String)
//        } else {
//            self.lbl_one.text = "You ride has been cancelled.\n"+(self.dict_get_data_from_notification["cancelReason"] as! String)+"\n"+(self.dict_get_data_from_notification["cancelComment"] as! String)
//            // self.lbl_one.text = "You ride has been cancelled.
//        }
        
        self.btn_dismiss.addTarget(self, action: #selector(home_page_click), for: .touchUpInside)
    }
    
    @objc func cancelBookingAlert() {
        self.lbl_one.text = "\(self.dict_get_data_from_notification["message"] as! String)\n\nReason: \(self.dict_get_data_from_notification["cancelComment"] as! String)"
    }
    
    @objc func home_page_click() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let destinationController = storyboard.instantiateViewController(withIdentifier:"dashboard_id") as? dashboard
            
        // destinationController?.dict_get_all_data_from_notification = dict as NSDictionary
            
        let frontNavigationController = UINavigationController(rootViewController: destinationController!)

        let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC

        let mainRevealController = SWRevealViewController()

        mainRevealController.rearViewController = rearViewController
        mainRevealController.frontViewController = frontNavigationController
        
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController = mainRevealController
        }
        
        window?.makeKeyAndVisible()
        
    }
}
