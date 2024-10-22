//
//  ride_status.swift
//  PathMark
//
//  Created by Dishant Rajput on 29/08/23.
//

import UIKit
import MapKit
import Alamofire
import SDWebImage

// MARK:- LOCATION -
import CoreLocation

import GoogleMaps


class ride_status: UIViewController , CLLocationManagerDelegate , MKMapViewDelegate, UITextFieldDelegate {
    
    var str_from_history:String!
    
    var str_vehicle_type:String!
    
    var dict_get_all_data_from_notification:NSDictionary!
    
    let locationManager = CLLocationManager()
    
    // MARK:- SAVE LOCATION STRING -
    var strSaveLatitude:String! = ""
    var strSaveLongitude:String! = ""
    var strSaveCountryName:String!
    var strSaveLocalAddress:String!
    var strSaveLocality:String!
    var strSaveLocalAddressMini:String!
    var strSaveStateName:String!
    var strSaveZipcodeName:String!
    
    
    var counter = 2
    var timer:Timer!
    
    var myDeviceTokenIs:String!
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    let annotation = MKPointAnnotation()
    let annotation2 = MKPointAnnotation()
    
    var str_from_location:String!
    var str_to_location:String!
    
    // MARK:- MY LOCATION -
    var my_location_lat:String!
    var my_location_long:String!
    
    // MARK:- PLACE LOCATION -
    var searched_place_location_lat:String!
    var searched_place_location_long:String!
    
    var str_get_category_id:String!
    
    var str_fetch_payment_method:String!
    var str_fetch_duration:String!
    var str_fetch_distance:String!
    var str_fetch_fare_estimated:String!
    
    var str_total_distance:String! = ""
    var str_total_duration:String! = ""
    var str_total_rupees:String! = ""
    
    var str_user_save_phone_number:String! = ""
    
    var str_booking_id:String!
    
    var isRideCodeHidden:Bool! = false
    
    // ***************************************************************** // nav
    
    // google maps
    // NEW
    var getLoginUserLatitudeTo:String!
    var getLoginUserLongitudeTo:String!
    var getLoginUserAddressTo:String!
    var getLoginUserLatitudeFrom:String!
    var getLoginUserLongitudeFrom:String!
    var getLoginUserAddressFrom:String!
    var mapView: GMSMapView!
    
    var doublePlaceStartLat:Double!
    var doublePlaceStartLong:Double!
    
    var doublePlaceFinalLat:Double!
    var doublePlaceFinalLong:Double!
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            btnBack.tintColor = NAVIGATION_BACK_COLOR
            btnBack.isHidden = true
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Fare distance"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
        }
    }
    
    let cellReuseIdentifier = "dFareDistanceTableViewCell"
    
    @IBOutlet weak var tbleView:UITableView!
    
    @IBOutlet weak var btn_share:UIButton!
    
    @IBOutlet weak var btnConfirmBooking:UIButton! {
        didSet {
            btnConfirmBooking.isHidden = true
            btnConfirmBooking.backgroundColor = .systemGreen
            btnConfirmBooking.setTitle("Confirm booking", for: .normal)
        }
    }
    
    //    @IBOutlet weak var mapView:MKMapView!
    
    @IBOutlet weak var view_bg:UIView! {
        didSet {
            view_bg.layer.masksToBounds = false
            view_bg.layer.shadowColor = UIColor.black.cgColor
            view_bg.layer.shadowOffset =  CGSize.zero
            view_bg.layer.shadowOpacity = 0.5
            view_bg.layer.shadowRadius = 2
            view_bg.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var lbl_car_details:UILabel!
    @IBOutlet weak var lbl_driver_name:UILabel!
    @IBOutlet weak var lbl_driver_rating:UILabel!
    
    @IBOutlet weak var txt_write_message:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_write_message,
                              tfName: txt_write_message.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "write a message")
            
            txt_write_message.layer.masksToBounds = false
            txt_write_message.layer.shadowColor = UIColor.black.cgColor
            txt_write_message.layer.shadowOffset =  CGSize.zero
            txt_write_message.layer.shadowOpacity = 0.5
            txt_write_message.layer.shadowRadius = 2
            txt_write_message.isSecureTextEntry = false
        }
    }
    
    @IBOutlet weak var lbl_OTP:UILabel! {
        didSet {
            self.lbl_OTP.isHidden = true
        }
    }
    
    @IBOutlet weak var btnConfirmRide:UIButton! {
        didSet {
            btnConfirmRide.isHidden = true
            btnConfirmRide.backgroundColor = .systemGreen
            btnConfirmRide.setTitle("Confirm booking", for: .normal)
        }
    }
    
    @IBOutlet weak var btn_send:UIButton! {
        didSet {
            btn_send.setTitleColor(.systemOrange, for: .normal)
        }
    }
    
    @IBOutlet weak var btn_chat:UIButton! {
        didSet {
            btn_chat.backgroundColor = .red
        }
    }
    
    @IBOutlet weak var btn_call_driver:UIButton! {
        didSet {
            btn_call_driver.backgroundColor = .clear
            btn_call_driver.setTitleColor(.black, for: .normal)
        }
    }
    
    @IBOutlet weak var btn_cancel_ride:UIButton! {
        didSet {
            btn_cancel_ride.backgroundColor = .clear
            btn_cancel_ride.setTitleColor(.black, for: .normal)
        }
    }
    
    @IBOutlet weak var img_profile:UIImageView! {
        didSet {
            img_profile.image = UIImage(named: "1024")
        }
    }
    
    @IBOutlet weak var img_star_one:UIImageView!
    @IBOutlet weak var img_star_two:UIImageView!
    @IBOutlet weak var img_star_three:UIImageView!
    @IBOutlet weak var img_star_four:UIImageView!
    @IBOutlet weak var img_star_five:UIImageView!
    
    @IBOutlet weak var btn_booking_confirmed:UIButton!
    
    @IBOutlet weak var btn_home:UIButton!
    
    @IBOutlet weak var lbl_message:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if (self.dict_get_all_data_from_notification["type"] != nil) {
            
            if (self.dict_get_all_data_from_notification["type"] as! String == "Chat") {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BooCheckChatId") as? BooCheckChat
                
                push!.str_back_home = "home"
                push!.get_all_data = self.dict_get_all_data_from_notification
                push!.str_booking_id = "\(self.dict_get_all_data_from_notification["bookingId"]!)"
                
                self.navigationController?.pushViewController(push!, animated: true)
                
                return
            }
            
        }
        
        // keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        self.btn_share.addTarget(self, action: #selector(share_click_method), for: .touchUpInside)
        
        self.btn_chat.backgroundColor = .clear
        self.btn_chat.addTarget(self, action: #selector(chat_click_method), for: .touchUpInside)
        
        self.btn_home.addTarget(self, action: #selector(home_click_method), for: .touchUpInside)
        
        // self.btnConfirmBooking.addTarget(self, action: #selector(validation_before_confirm_booking), for: .touchUpInside)
        
        // self.show_loading_UI()
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        self.tbleView.delegate = self
        self.tbleView.dataSource = self
        
        self.tbleView.reloadData()
        
        self.btn_cancel_ride.addTarget(self, action: #selector(cancancel_ride_click_method), for: .touchUpInside)
        
        /*
         DriverImage = "";
         RequestDropAddress = "Modinagar Modinagar";
         RequestDropLatLong = "28.835619,77.569403";
         RequestPickupAddress = "Sector 10 Dwarka South West Delhi New Delhi,New Delhi,India";
         RequestPickupLatLong = "28.587152917200502,77.06061415697155";
         VehicleColor = red;
         aps =     {
         alert = "iDriver5 has confirmed your booling.";
         };
         bookingId = 87;
         driverContact = 8287632345;
         driverId = 13;
         driverLatitude = "28.587238814653944";
         driverName = iDriver5;
         driverlongitude = "77.06062328401764";
         "gcm.message_id" = 1693292390930120;
         "google.c.a.e" = 1;
         "google.c.fid" = cwFMTZl0K0fpkfcPMinYSO;
         "google.c.sender.id" = 750959835757;
         message = "iDriver5 has confirmed your booling.";
         rating = 0;
         type = confirm;
         vehicleNumber = dl007;
         // str_from_history
         */
        
        print("=============================================")
        print("=============================================")
        print(self.dict_get_all_data_from_notification as Any)
        print("=============================================")
        print("=============================================")
        
        // whatIsYourRideCodeStatus
        
        if self.dict_get_all_data_from_notification["RideCode"] != nil {
            let myString = "\(self.dict_get_all_data_from_notification["RideCode"]!)"
            if (myString.count < 4) {
                debugPrint("Yes, Ride code is less then 4")
                isRideCodeHidden = true
            } else {
                debugPrint("Ride code is valid")
                isRideCodeHidden = false
            }
        }
        
        
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                self.btn_call_driver.setTitle(" Call driver", for: .normal)
                self.btn_cancel_ride.setTitle(" cancel ride", for: .normal)
            } else {
                self.btn_call_driver.setTitle(" ড্রাইভারকে কল করুন", for: .normal)
                self.btn_cancel_ride.setTitle(" যাত্রা বাতিল করুন", for: .normal)
            }
            
        } else {
            print("=============================")
            print("LOGIN : Select language error")
            print("=============================")
            UserDefaults.standard.set("en", forKey: str_language_convert)
        }
        
        if (self.str_from_history == "yes") {
            print("\(self.dict_get_all_data_from_notification["rideStatus"]!)")
            
            if ("\(self.dict_get_all_data_from_notification["rideStatus"]!)" == "3") {
                self.btnConfirmBooking.isHidden = true
                self.navigationBar.backgroundColor = navigation_color
                
                self.btn_booking_confirmed.isHidden = true
                // self.lbl_OTP.isHidden = true
                
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        self.lblNavigationTitle.text = "Enjoy your ride"
                        self.lbl_message.text = "Enjoy your ride"
                        
                    } else {
                        self.lblNavigationTitle.text = "আপনার রাইড উপভোগ করুন"
                        self.lbl_message.text = "আপনার রাইড উপভোগ করুন"
                    }
                    
                } else {
                    print("=============================")
                    print("LOGIN : Select language error")
                    print("=============================")
                    UserDefaults.standard.set("en", forKey: str_language_convert)
                }
                
            } else if ("\(self.dict_get_all_data_from_notification["rideStatus"]!)" == "2") {
                
                self.navigationBar.backgroundColor = navigation_color
                
                self.btn_booking_confirmed.isHidden = true
                
                // self.lbl_OTP.isHidden = true
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        self.lblNavigationTitle.text = "Driver has Arrived"
                        self.lbl_message.text = "Confirm booking"
                        
                    } else {
                        self.lblNavigationTitle.text = "ড্রাইভার এসেছিল"
                        self.lbl_message.text = "ড্রাইভার এসেছিল"
                    }
                    
                } else {
                    print("=============================")
                    print("LOGIN : Select language error")
                    print("=============================")
                    UserDefaults.standard.set("en", forKey: str_language_convert)
                }
                self.hide_loading_UI()
                
                if (isRideCodeHidden == true) {
                    self.btnConfirmBooking.isHidden = false
                    self.btnConfirmBooking.setTitle("Driver arrived", for: .normal)
                    self.btnConfirmBooking.tag = 100
                    
                } else {
                    self.btnConfirmBooking.isHidden = false
                    self.btnConfirmBooking.addTarget(self, action: #selector(confirmBookingSetOTP), for: .touchUpInside)
                    
                }
                
            }  else if ("\(self.dict_get_all_data_from_notification["rideStatus"]!)" == "1") {
                // self.lblNavigationTitle.text = "Booking Confirmed"
                self.navigationBar.backgroundColor = navigation_color
                
                self.btnConfirmBooking.isHidden = true
                
                self.btn_booking_confirmed.isHidden = false
                self.lbl_message.text = "سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ . وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ"
                
                
                // self.lbl_OTP.text = "OTP : \(self.dict_get_all_data_from_notification["RideCode"]!)"
                
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        self.lblNavigationTitle.text = "Booking Confirmed"
                        
                        
                    } else {
                        self.lblNavigationTitle.text = "বুকিং নিশ্চিত করা হয়েছে"
                    }
                    
                } else {
                    print("=============================")
                    print("LOGIN : Select language error")
                    print("=============================")
                    UserDefaults.standard.set("en", forKey: str_language_convert)
                }
                
            }
            
            
            
            self.lbl_car_details.text = (self.dict_get_all_data_from_notification["vehicleNumber"] as! String)+" ("+(self.dict_get_all_data_from_notification["VehicleColor"] as! String)+" )"
            
            print(self.self.dict_get_all_data_from_notification as Any)
            
            self.lbl_driver_name.text = (self.dict_get_all_data_from_notification["fullName"] as! String)
            self.lbl_driver_rating.text = "\(self.dict_get_all_data_from_notification["AVGRating"]!)"
            
            self.img_profile.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
            self.img_profile.sd_setImage(with: URL(string: (self.dict_get_all_data_from_notification["image"] as! String)), placeholderImage: UIImage(named: "logo"))
            
            //
            // star manage
            if "\(self.dict_get_all_data_from_notification["AVGRating"]!)" == "0" {
                
                self.img_star_one.image = UIImage(systemName: "star")
                self.img_star_two.image = UIImage(systemName: "star")
                self.img_star_three.image = UIImage(systemName: "star")
                self.img_star_four.image = UIImage(systemName: "star")
                self.img_star_five.image = UIImage(systemName: "star")
                
            } else if "\(self.dict_get_all_data_from_notification["AVGRating"]!)" > "1" &&
                        "\(self.dict_get_all_data_from_notification["AVGRating"]!)" < "2" {
                
                self.img_star_one.image = UIImage(systemName: "star.fill")
                self.img_star_two.image = UIImage(systemName: "star.leadinghalf.filled")
                self.img_star_three.image = UIImage(systemName: "star")
                self.img_star_four.image = UIImage(systemName: "star")
                self.img_star_five.image = UIImage(systemName: "star")
                
            } else if "\(self.dict_get_all_data_from_notification["AVGRating"]!)" == "2" {
                
                self.img_star_one.image = UIImage(systemName: "star.fill")
                self.img_star_two.image = UIImage(systemName: "star.fill")
                self.img_star_three.image = UIImage(systemName: "star")
                self.img_star_four.image = UIImage(systemName: "star")
                self.img_star_five.image = UIImage(systemName: "star")
                
                
            } else if "\(self.dict_get_all_data_from_notification["AVGRating"]!)" > "2" &&
                        "\(self.dict_get_all_data_from_notification["AVGRating"]!)" < "3" {
                
                self.img_star_one.image = UIImage(systemName: "star.fill")
                self.img_star_two.image = UIImage(systemName: "star.fill")
                self.img_star_three.image = UIImage(systemName: "star.leadinghalf.filled")
                self.img_star_four.image = UIImage(systemName: "star")
                self.img_star_five.image = UIImage(systemName: "star")
                
            } else if "\(self.dict_get_all_data_from_notification["AVGRating"]!)" == "3" {
                
                self.img_star_one.image = UIImage(systemName: "star.fill")
                self.img_star_two.image = UIImage(systemName: "star.fill")
                self.img_star_three.image = UIImage(systemName: "star.fill")
                self.img_star_four.image = UIImage(systemName: "star")
                self.img_star_five.image = UIImage(systemName: "star")
                
            } else if "\(self.dict_get_all_data_from_notification["AVGRating"]!)" > "3" &&
                        "\(self.dict_get_all_data_from_notification["AVGRating"]!)" < "4" {
                
                self.img_star_one.image = UIImage(systemName: "star.fill")
                self.img_star_two.image = UIImage(systemName: "star.fill")
                self.img_star_three.image = UIImage(systemName: "star.fill")
                self.img_star_four.image = UIImage(systemName: "star.leadinghalf.filled")
                self.img_star_five.image = UIImage(systemName: "star")
                
            } else if "\(self.dict_get_all_data_from_notification["AVGRating"]!)" == "5" {
                
                self.img_star_one.image = UIImage(systemName: "star.fill")
                self.img_star_two.image = UIImage(systemName: "star.fill")
                self.img_star_three.image = UIImage(systemName: "star.fill")
                self.img_star_four.image = UIImage(systemName: "star.fill")
                self.img_star_five.image = UIImage(systemName: "star.fill")
                
            }
            
        } else {
            // print("\(self.dict_get_all_data_from_notification["rideStatus"]!)")
            if (self.dict_get_all_data_from_notification == nil) {
                
            } else {
                
                if (self.dict_get_all_data_from_notification["type"] as! String) == "confirm" {
                    
                    self.navigationBar.backgroundColor = navigation_color
                    // UIColor.init(red: 104.0/255.0, green: 218.0/255.0, blue: 134.0/255.0, alpha: 1)
                    
                    self.btn_booking_confirmed.isHidden = false
                    self.lbl_message.isHidden = false
                    
                    // self.lbl_OTP.isHidden = true
                    // self.lbl_OTP.text = "OTP : \(self.dict_get_all_data_from_notification["RideCode"]!)"
                    
                    if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                        print(language as Any)
                        
                        if (language == "en") {
                            self.btn_booking_confirmed.setTitle("Booking Confirmed", for: .normal)
                            self.lblNavigationTitle.text = "Booking Confirmed."
                            
                        } else {
                            self.btn_booking_confirmed.setTitle("বুকিং নিশ্চিত করা হয়েছে", for: .normal)
                            self.lblNavigationTitle.text = "বুকিং নিশ্চিত করা হয়েছে."
                        }
                        
                    } else {
                        print("=============================")
                        print("LOGIN : Select language error")
                        print("=============================")
                        UserDefaults.standard.set("en", forKey: str_language_convert)
                    }
                    
                } else if (self.dict_get_all_data_from_notification["type"] as! String) == "arrived" {
                    
                    // self.lbl_OTP.isHidden = false
                    // self.lbl_OTP.text = "OTP : \(self.dict_get_all_data_from_notification["RideCode"]!)"
                    
                    
                    self.navigationBar.backgroundColor = navigation_color
                    
                    self.btn_booking_confirmed.isHidden = true
                    if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                        print(language as Any)
                        
                        if (language == "en") {
                            self.lblNavigationTitle.text = "Driver has Arrived"
                            self.lbl_message.text = "Confirm booking"
                            
                        } else {
                            self.lblNavigationTitle.text = "ড্রাইভার এসেছিল"
                            self.lbl_message.text = "ড্রাইভার এসেছিল"
                        }
                        
                    } else {
                        print("=============================")
                        print("LOGIN : Select language error")
                        print("=============================")
                        UserDefaults.standard.set("en", forKey: str_language_convert)
                    }
                    
                    if (isRideCodeHidden == true) {
                        self.btnConfirmBooking.isHidden = false
                        
                    } else {
                        self.btnConfirmBooking.isHidden = false
                        self.btnConfirmBooking.addTarget(self, action: #selector(confirmBookingSetOTP), for: .touchUpInside)
                        
                    }
                    
                }  else if (self.dict_get_all_data_from_notification["type"] as! String) == "ridestart" {
                    // self.lbl_OTP.isHidden = true
                    
                    
                    self.navigationBar.backgroundColor = navigation_color
                    self.btn_cancel_ride.isHidden = true
                    
                    self.btn_booking_confirmed.isHidden = true
                    
                    
                    if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                        print(language as Any)
                        
                        if (language == "en") {
                            self.lblNavigationTitle.text = "Enjoy your ride"
                            self.lbl_message.text = "Enjoy your ride"
                            
                        } else {
                            self.lblNavigationTitle.text = "আপনার রাইড উপভোগ করুন"
                            self.lbl_message.text = "আপনার রাইড উপভোগ করুন  "
                        }
                        
                    } else {
                        print("=============================")
                        print("LOGIN : Select language error")
                        print("=============================")
                        UserDefaults.standard.set("en", forKey: str_language_convert)
                    }
                    
                    self.btnConfirmBooking.isHidden = true
                    
                }  else if (self.dict_get_all_data_from_notification["type"] as! String) == "rideend1" {
                    // self.lbl_OTP.isHidden = true
                    
                    self.lblNavigationTitle.text = "Ride Complete - Please pay"
                    self.navigationBar.backgroundColor = navigation_color
                    self.btn_cancel_ride.isHidden = true
                    
                    self.btn_booking_confirmed.isHidden = true
                    self.lbl_message.text = "Ride Complete - Please pay"
                    
                    // NEW
                    if self.dict_get_all_data_from_notification["Last_cancel_amount"] == nil {
                        
                        if self.dict_get_all_data_from_notification["last_cancel_amount"] == nil {
                            
                            // BOTH LAST CANCEL AMOUNT IS NIL
                            print(self.dict_get_all_data_from_notification as Any)
                            
                            /*let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Ride done"), style: .alert)
                             let pay = NewYorkButton(title: "Pay : \(self.dict_get_all_data_from_notification["FinalFare"]!)", style: .default) {
                             _ in
                             let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "before_payment_id") as? before_payment
                             
                             push!.str_booking_id2 = "\(self.dict_get_all_data_from_notification!["bookingId"]!)"
                             push!.str_get_total_price2 = "\(self.dict_get_all_data_from_notification!["FinalFare"]!)"
                             push!.get_full_data_for_payment2 = self.dict_get_all_data_from_notification
                             
                             self.navigationController?.pushViewController(push!, animated: true)
                             }
                             let cancel = NewYorkButton(title: "Home", style: .default) {
                             _ in
                             let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as? dashboard
                             self.navigationController?.pushViewController(push!, animated: true)
                             }
                             alert.addButtons([pay,cancel])
                             self.present(alert, animated: true)*/
                            
                            
                            let alert = UIAlertController(title: "Alert", message: String("Ride done"), preferredStyle: .alert)
                            
                            // Add actions
                            let okAction = UIAlertAction(title: "Pay : \(self.dict_get_all_data_from_notification["FinalFare"]!)", style: .default) { _ in
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "before_payment_id") as? before_payment
                                
                                push!.str_booking_id2 = "\(self.dict_get_all_data_from_notification!["bookingId"]!)"
                                push!.str_get_total_price2 = "\(self.dict_get_all_data_from_notification!["FinalFare"]!)"
                                push!.get_full_data_for_payment2 = self.dict_get_all_data_from_notification
                                
                                self.navigationController?.pushViewController(push!, animated: true)
                            }
                            let cancelAction = UIAlertAction(title: "Home", style: .cancel) { _ in
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as? dashboard
                                self.navigationController?.pushViewController(push!, animated: true)
                            }
                            
                            alert.addAction(okAction)
                            alert.addAction(cancelAction)
                            
                            // Present the alert
                            self.present(alert, animated: true, completion: nil)
                            
                        } else {
                            let a = Double("\(self.dict_get_all_data_from_notification["last_cancel_amount"]!)")
                            let b = Double("\(self.dict_get_all_data_from_notification["FinalFare"]!)")
                            var sum = a! + b!
                            print(sum as Any)
                            
                            
                            
                            print(self.dict_get_all_data_from_notification as Any)
                            
                            
                            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                                print(language as Any)
                                
                                if (language == "en") {
                                    /*let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Ride done")+"\n\nLast cancel ride amount: "+"\(str_bangladesh_currency_symbol) \(self.dict_get_all_data_from_notification["last_cancel_amount"]!)", style: .alert)
                                     let pay = NewYorkButton(title: "Pay : \(self.dict_get_all_data_from_notification["FinalFare"]!)", style: .default) {
                                     _ in
                                     let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "before_payment_id") as? before_payment
                                     
                                     push!.str_booking_id2 = "\(self.dict_get_all_data_from_notification!["bookingId"]!)"
                                     push!.str_get_total_price2 = "\(self.dict_get_all_data_from_notification!["FinalFare"]!)"
                                     push!.get_full_data_for_payment2 = self.dict_get_all_data_from_notification
                                     
                                     self.navigationController?.pushViewController(push!, animated: true)
                                     }
                                     
                                     let cancel = NewYorkButton(title: "Home", style: .default) {
                                     _ in
                                     let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as? dashboard
                                     self.navigationController?.pushViewController(push!, animated: true)
                                     }
                                     alert.addButtons([pay,cancel])
                                     self.present(alert, animated: true)*/
                                    
                                    let alert = UIAlertController(title: "Alert", message: String("Ride done")+"\n\nLast cancel ride amount: "+"\(str_bangladesh_currency_symbol) \(self.dict_get_all_data_from_notification["last_cancel_amount"]!)", preferredStyle: .alert)
                                    
                                    // Add actions
                                    let okAction = UIAlertAction(title: "Pay : \(self.dict_get_all_data_from_notification["FinalFare"]!)", style: .default) { _ in
                                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "before_payment_id") as? before_payment
                                        
                                        push!.str_booking_id2 = "\(self.dict_get_all_data_from_notification!["bookingId"]!)"
                                        push!.str_get_total_price2 = "\(self.dict_get_all_data_from_notification!["FinalFare"]!)"
                                        push!.get_full_data_for_payment2 = self.dict_get_all_data_from_notification
                                        
                                        self.navigationController?.pushViewController(push!, animated: true)
                                    }
                                    let cancelAction = UIAlertAction(title: "Home", style: .cancel) { _ in
                                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as? dashboard
                                        self.navigationController?.pushViewController(push!, animated: true)
                                    }
                                    
                                    alert.addAction(okAction)
                                    alert.addAction(cancelAction)
                                    
                                    // Present the alert
                                    self.present(alert, animated: true, completion: nil)
                                    
                                    
                                } else {
                                    /*let alert = NewYorkAlertController(title: nil, message: "\n\nশেষ বাতিল রাইড পরিমাণ: "+"\(str_bangladesh_currency_symbol) \(self.dict_get_all_data_from_notification["last_cancel_amount"]!)", style: .alert)
                                     let pay = NewYorkButton(title: "বেতন : \(self.dict_get_all_data_from_notification["FinalFare"]!)", style: .default) {
                                     _ in
                                     let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "before_payment_id") as? before_payment
                                     
                                     push!.str_booking_id2 = "\(self.dict_get_all_data_from_notification!["bookingId"]!)"
                                     push!.str_get_total_price2 = "\(self.dict_get_all_data_from_notification!["FinalFare"]!)"
                                     push!.get_full_data_for_payment2 = self.dict_get_all_data_from_notification
                                     
                                     self.navigationController?.pushViewController(push!, animated: true)
                                     }
                                     
                                     let cancel = NewYorkButton(title: "হোম", style: .default) {
                                     _ in
                                     let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as? dashboard
                                     self.navigationController?.pushViewController(push!, animated: true)
                                     }
                                     alert.addButtons([pay,cancel])
                                     self.present(alert, animated: true)
                                     */
                                    let alert = UIAlertController(title: "Alert", message: "\n\nশেষ বাতিল রাইড পরিমাণ: "+"\(str_bangladesh_currency_symbol) \(self.dict_get_all_data_from_notification["last_cancel_amount"]!)", preferredStyle: .alert)
                                    
                                    // Add actions
                                    let okAction = UIAlertAction(title: "বেতন : \(self.dict_get_all_data_from_notification["FinalFare"]!)", style: .default) { _ in
                                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "before_payment_id") as? before_payment
                                        
                                        push!.str_booking_id2 = "\(self.dict_get_all_data_from_notification!["bookingId"]!)"
                                        push!.str_get_total_price2 = "\(self.dict_get_all_data_from_notification!["FinalFare"]!)"
                                        push!.get_full_data_for_payment2 = self.dict_get_all_data_from_notification
                                        
                                        self.navigationController?.pushViewController(push!, animated: true)
                                    }
                                    let cancelAction = UIAlertAction(title: "হোম", style: .cancel) { _ in
                                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as? dashboard
                                        self.navigationController?.pushViewController(push!, animated: true)
                                    }
                                    
                                    alert.addAction(okAction)
                                    alert.addAction(cancelAction)
                                    
                                    // Present the alert
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }
                                
                            }
                            
                            /*self.lbl_total.text = "\(str_bangladesh_currency_symbol) \(sum)"
                             self.lbl_price.text = "\(str_bangladesh_currency_symbol) \(sum)"*/
                        }
                        
                    } else {
                        print(self.dict_get_all_data_from_notification as Any)
                        let a = Double("\(self.dict_get_all_data_from_notification["Last_cancel_amount"]!)")
                        let b = Double("\(self.dict_get_all_data_from_notification["FinalFare"]!)")
                        var sum = a! + b!
                        print(sum as Any)
                        
                        
                        
                        /*var total_Amount_is:String!
                         
                         let cancellationFees:Double!
                         
                         if let amount = self.convertToDouble("\(self.dict_get_all_data_from_notification["FinalFare"]!)"),
                         let bookingFees = self.convertToDouble("\(self.dict_get_all_data_from_notification["bookingFee"]!)") {
                         
                         if "\(self.dict_get_all_data_from_notification["Last_cancel_amount"]!)" == "" {
                         cancellationFees = convertToDouble("0.0")
                         } else if "\(self.dict_get_all_data_from_notification["Last_cancel_amount"]!)" == "" {
                         cancellationFees = convertToDouble("0.0")
                         } else {
                         cancellationFees = convertToDouble("\(self.dict_get_all_data_from_notification["Last_cancel_amount"]!)")
                         }
                         
                         let totalAmount = amount + bookingFees + cancellationFees!
                         
                         if "\(self.dict_get_all_data_from_notification["Promotional_total"]!)" != "" {
                         let pro_dis = convertToDouble("\(self.dict_get_all_data_from_notification["Promotional_total"]!)")
                         print(pro_dis as Any)
                         let complete_cal = totalAmount - pro_dis!
                         print("Complete cal: \(complete_cal)")
                         
                         // self.lbl_total.text = "\(str_bangladesh_currency_symbol) \(complete_cal)"
                         // // self.lbl_price.text = "\(str_bangladesh_currency_symbol) \(complete_cal)"
                         
                         // also manage trip fare
                         // self.lbl_trip_fare.text = "\(str_bangladesh_currency_symbol) \(self.dict_get_all_data_from_notification["FinalFare"]!)"
                         
                         let final_fare = convertToDouble("\(self.dict_get_all_data_from_notification["FinalFare"]!)")
                         print("Final fare: \(final_fare!)")
                         
                         let f_f_total = final_fare! - pro_dis!
                         // self.lbl_trip_fare.text = "\(str_bangladesh_currency_symbol) \(f_f_total)"
                         total_Amount_is = "\(f_f_total)"
                         } else {
                         total_Amount_is = "\(totalAmount)"
                         // self.lbl_total.text = "\(str_bangladesh_currency_symbol) \(totalAmount)"
                         // self.lbl_price.text = "\(str_bangladesh_currency_symbol) \(totalAmount)"
                         }
                         
                         } else {
                         print("Invalid number format in one of the strings.")
                         }*/
                        
                        self.str_booking_id = "\(self.dict_get_all_data_from_notification["bookingId"]!)"
                        
                        let delayInSeconds = Double(500) / 1000.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
                            // Call the hitWebservice function after the delay
                            self.booking_history_details_WB(str_show_loader: "yes")
                        }
                        
                        /*self.lbl_total.text = "\(str_bangladesh_currency_symbol) \(sum)"
                         self.lbl_price.text = "\(str_bangladesh_currency_symbol) \(sum)"*/
                    }
                    self.btnConfirmBooking.isHidden = true
                } else if (self.dict_get_all_data_from_notification["type"] as! String) == "Chat" {
                    
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BooCheckChatId") as? BooCheckChat
                    
                    push!.str_back_home = "home"
                    push!.get_all_data = self.dict_get_all_data_from_notification
                    push!.str_booking_id = "\(self.dict_get_all_data_from_notification["bookingId"]!)"
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                    return
                }
                
                
                self.lbl_car_details.text = (self.dict_get_all_data_from_notification["vehicleNumber"] as! String)
                // +" ("+(self.dict_get_all_data_from_notification["VehicleColor"] as! String)+" )"
                
                // print(self.self.dict_get_all_data_from_notification as Any)
                
                self.lbl_driver_name.text = (self.dict_get_all_data_from_notification["driverName"] as! String)
                self.lbl_driver_rating.text = "\(self.dict_get_all_data_from_notification["rating"]!)"
                
                self.img_profile.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
                self.img_profile.sd_setImage(with: URL(string: (self.dict_get_all_data_from_notification["DriverImage"] as! String)), placeholderImage: UIImage(named: "logo"))
                
                
                
                
                
                
                // star manage
                if "\(self.dict_get_all_data_from_notification["rating"]!)" == "0" {
                    
                    self.img_star_one.image = UIImage(systemName: "star")
                    self.img_star_two.image = UIImage(systemName: "star")
                    self.img_star_three.image = UIImage(systemName: "star")
                    self.img_star_four.image = UIImage(systemName: "star")
                    self.img_star_five.image = UIImage(systemName: "star")
                    
                } else if "\(self.dict_get_all_data_from_notification["rating"]!)" > "1" &&
                            "\(self.dict_get_all_data_from_notification["rating"]!)" < "2" {
                    
                    self.img_star_one.image = UIImage(systemName: "star.fill")
                    self.img_star_two.image = UIImage(systemName: "star.leadinghalf.filled")
                    self.img_star_three.image = UIImage(systemName: "star")
                    self.img_star_four.image = UIImage(systemName: "star")
                    self.img_star_five.image = UIImage(systemName: "star")
                    
                } else if "\(self.dict_get_all_data_from_notification["rating"]!)" == "2" {
                    
                    self.img_star_one.image = UIImage(systemName: "star.fill")
                    self.img_star_two.image = UIImage(systemName: "star.fill")
                    self.img_star_three.image = UIImage(systemName: "star")
                    self.img_star_four.image = UIImage(systemName: "star")
                    self.img_star_five.image = UIImage(systemName: "star")
                    
                    
                } else if "\(self.dict_get_all_data_from_notification["rating"]!)" > "2" &&
                            "\(self.dict_get_all_data_from_notification["rating"]!)" < "3" {
                    
                    self.img_star_one.image = UIImage(systemName: "star.fill")
                    self.img_star_two.image = UIImage(systemName: "star.fill")
                    self.img_star_three.image = UIImage(systemName: "star.leadinghalf.filled")
                    self.img_star_four.image = UIImage(systemName: "star")
                    self.img_star_five.image = UIImage(systemName: "star")
                    
                } else if "\(self.dict_get_all_data_from_notification["rating"]!)" == "3" {
                    
                    self.img_star_one.image = UIImage(systemName: "star.fill")
                    self.img_star_two.image = UIImage(systemName: "star.fill")
                    self.img_star_three.image = UIImage(systemName: "star.fill")
                    self.img_star_four.image = UIImage(systemName: "star")
                    self.img_star_five.image = UIImage(systemName: "star")
                    
                } else if "\(self.dict_get_all_data_from_notification["rating"]!)" > "3" &&
                            "\(self.dict_get_all_data_from_notification["rating"]!)" < "4" {
                    
                    self.img_star_one.image = UIImage(systemName: "star.fill")
                    self.img_star_two.image = UIImage(systemName: "star.fill")
                    self.img_star_three.image = UIImage(systemName: "star.fill")
                    self.img_star_four.image = UIImage(systemName: "star.leadinghalf.filled")
                    self.img_star_five.image = UIImage(systemName: "star")
                    
                } else if "\(self.dict_get_all_data_from_notification["rating"]!)" == "5" {
                    
                    self.img_star_one.image = UIImage(systemName: "star.fill")
                    self.img_star_two.image = UIImage(systemName: "star.fill")
                    self.img_star_three.image = UIImage(systemName: "star.fill")
                    self.img_star_four.image = UIImage(systemName: "star.fill")
                    self.img_star_five.image = UIImage(systemName: "star.fill")
                    
                }
            }
        }
        
        
        //
        print(self.dict_get_all_data_from_notification as Any)
        
        if (self.dict_get_all_data_from_notification["type"] != nil) {
            if(self.dict_get_all_data_from_notification["type"] as! String == "rideend") {
                debugPrint("COMPLETED: RIDE END % Show popup now")
                
                
                /*let delayInSeconds = Double(500) / 1000.0
                 DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
                 // Call the hitWebservice function after the delay
                 debugPrint("Show popup now")
                 // self.booking_history_details_WB(str_show_loader: "yes")
                 }*/
                
                self.handleEveythingFromGoogleMapInit()
                
            } else {
                debugPrint("DATA IS NOT NIL")
                
                self.handleEveythingFromGoogleMapInit()
            }
        } else {
            self.handleEveythingFromGoogleMapInit()
        }
        
        
    }
    
    
    @objc func parseData() {
        
    }
    
    
    
    @objc func booking_history_details_WB(str_show_loader:String) {
        
        if(self.dict_get_all_data_from_notification["type"] as! String != "rideend") {
            if (str_show_loader == "yes") {
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                    } else {
                        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "অপেক্ষা করুন")
                    }
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
                
                var lan:String!
                
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        lan = "en"
                    } else {
                        lan = "bn"
                    }
                    
                    
                }
                
                if(self.dict_get_all_data_from_notification["type"] as! String != "rideend") {
                    parameters = [
                        "action"        : "bookingdetail",
                        "bookingId"     : String(self.str_booking_id),
                        "userId"        : String(myString),
                        "language"      : String(lan),
                    ]
                } else {
                    parameters = [
                        "action"        : "bookingdetail",
                        "bookingId"     : "\(self.dict_get_all_data_from_notification["bookingId"]!)",
                        "userId"        : String(myString),
                        "language"      : String(lan),
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
                            
                            let str_token = (JSON["AuthToken"] as! String)
                            UserDefaults.standard.set("", forKey: str_save_last_api_token)
                            UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                            
                            ERProgressHud.sharedInstance.hide()
                            
                            var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            print(dict as Any)
                            
                            let cancellationFees:Double!
                            
                            if let amount = self.convertToDouble("\(dict["FinalFare"]!)"),
                               let bookingFees = self.convertToDouble("\(dict["bookingFee"]!)") {
                                
                                if "\(dict["last_cancel_amount"]!)" == "" {
                                    cancellationFees = self.convertToDouble("0.0")
                                } else if "\(dict["last_cancel_amount"]!)" == "0" {
                                    cancellationFees = self.convertToDouble("0.0")
                                } else {
                                    cancellationFees = self.convertToDouble("\(dict["last_cancel_amount"]!)")
                                }
                                
                                let totalAmount = amount + bookingFees + cancellationFees!
                                print(totalAmount as Any)
                                
                                if "\(dict["promotional_discount"]!)" != "" {
                                    let pro_dis = self.convertToDouble("\(dict["promotional_discount"]!)")
                                    print(pro_dis as Any)
                                    let complete_cal = totalAmount - pro_dis!
                                    print("Complete cal: \(complete_cal)")
                                    
                                    if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                                        print(language as Any)
                                        
                                        if (language == "en") {
                                            
                                            /*let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Ride done")+"\n\nLast cancel ride amount: "+"\(str_bangladesh_currency_symbol) \(self.dict_get_all_data_from_notification["Last_cancel_amount"]!)", style: .alert)
                                             let pay = NewYorkButton(title: "Pay : \(complete_cal)", style: .default) {
                                             _ in
                                             let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "before_payment_id") as? before_payment
                                             
                                             push!.str_booking_id2 = "\(self.dict_get_all_data_from_notification!["bookingId"]!)"
                                             push!.str_get_total_price2 = "\(complete_cal)"
                                             push!.get_full_data_for_payment2 = self.dict_get_all_data_from_notification
                                             
                                             self.navigationController?.pushViewController(push!, animated: true)
                                             }
                                             let cancel = NewYorkButton(title: "Home", style: .default) {
                                             _ in
                                             let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as? dashboard
                                             self.navigationController?.pushViewController(push!, animated: true)
                                             }
                                             alert.addButtons([pay,cancel])
                                             self.present(alert, animated: true)*/
                                            
                                            let alert = UIAlertController(title: "Alert", message: String("Ride done")+"\n\nLast cancel ride amount: "+"\(str_bangladesh_currency_symbol) \(self.dict_get_all_data_from_notification["Last_cancel_amount"]!)", preferredStyle: .alert)
                                            
                                            // Add actions
                                            let okAction = UIAlertAction(title: "Pay : \(complete_cal)", style: .default) { _ in
                                                
                                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "before_payment_id") as? before_payment
                                                push!.str_booking_id2 = "\(self.dict_get_all_data_from_notification!["bookingId"]!)"
                                                push!.str_get_total_price2 = "\(complete_cal)"
                                                push!.get_full_data_for_payment2 = self.dict_get_all_data_from_notification
                                                self.navigationController?.pushViewController(push!, animated: true)
                                                
                                            }
                                            let cancelAction = UIAlertAction(title: "Home", style: .cancel) { _ in
                                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as? dashboard
                                                self.navigationController?.pushViewController(push!, animated: true)
                                            }
                                            
                                            alert.addAction(okAction)
                                            alert.addAction(cancelAction)
                                            
                                            // Present the alert
                                            self.present(alert, animated: true, completion: nil)
                                            
                                        } else {
                                            
                                            /*let alert = NewYorkAlertController(title: nil, message: "\n\nশেষ বাতিল রাইড পরিমাণ: "+"\(str_bangladesh_currency_symbol) \(self.dict_get_all_data_from_notification["Last_cancel_amount"]!)", style: .alert)
                                             let pay = NewYorkButton(title: "বেতন : \(complete_cal)", style: .default) {
                                             _ in
                                             let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "before_payment_id") as? before_payment
                                             
                                             push!.str_booking_id2 = "\(self.dict_get_all_data_from_notification!["bookingId"]!)"
                                             push!.str_get_total_price2 = "\(complete_cal)"
                                             push!.get_full_data_for_payment2 = self.dict_get_all_data_from_notification
                                             
                                             self.navigationController?.pushViewController(push!, animated: true)
                                             }
                                             let cancel = NewYorkButton(title: "হোম", style: .default) {
                                             _ in
                                             let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as? dashboard
                                             self.navigationController?.pushViewController(push!, animated: true)
                                             }
                                             alert.addButtons([pay,cancel])
                                             self.present(alert, animated: true)*/
                                            
                                            let alert = UIAlertController(title: nil, message: "\n\nশেষ বাতিল রাইড পরিমাণ: "+"\(str_bangladesh_currency_symbol) \(self.dict_get_all_data_from_notification["Last_cancel_amount"]!)", preferredStyle: .alert)
                                            
                                            // Add actions
                                            let okAction = UIAlertAction(title: "বেতন : \(complete_cal)", style: .default) { _ in
                                                
                                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "before_payment_id") as? before_payment
                                                push!.str_booking_id2 = "\(self.dict_get_all_data_from_notification!["bookingId"]!)"
                                                push!.str_get_total_price2 = "\(complete_cal)"
                                                push!.get_full_data_for_payment2 = self.dict_get_all_data_from_notification
                                                self.navigationController?.pushViewController(push!, animated: true)
                                                
                                            }
                                            let cancelAction = UIAlertAction(title: "হোম", style: .cancel) { _ in
                                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as? dashboard
                                                self.navigationController?.pushViewController(push!, animated: true)
                                            }
                                            
                                            alert.addAction(okAction)
                                            alert.addAction(cancelAction)
                                            
                                            // Present the alert
                                            self.present(alert, animated: true, completion: nil)
                                            
                                        }
                                        
                                    }
                                    
                                    
                                } else {
                                    if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                                        print(language as Any)
                                        
                                        if (language == "en") {
                                            
                                            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Ride done")+"\n\nLast cancel ride amount: "+"\(str_bangladesh_currency_symbol) \(self.dict_get_all_data_from_notification["Last_cancel_amount"]!)", style: .alert)
                                            let pay = NewYorkButton(title: "Pay : \(totalAmount)", style: .default) {
                                                _ in
                                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "before_payment_id") as? before_payment
                                                
                                                push!.str_booking_id2 = "\(self.dict_get_all_data_from_notification!["bookingId"]!)"
                                                push!.str_get_total_price2 = "\(totalAmount)"
                                                push!.get_full_data_for_payment2 = self.dict_get_all_data_from_notification
                                                
                                                self.navigationController?.pushViewController(push!, animated: true)
                                            }
                                            let cancel = NewYorkButton(title: "Home", style: .default) {
                                                _ in
                                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as? dashboard
                                                self.navigationController?.pushViewController(push!, animated: true)
                                            }
                                            alert.addButtons([pay,cancel])
                                            self.present(alert, animated: true)
                                            
                                        } else {
                                            
                                            let alert = NewYorkAlertController(title: nil, message: "\n\nশেষ বাতিল রাইড পরিমাণ: "+"\(str_bangladesh_currency_symbol) \(self.dict_get_all_data_from_notification["Last_cancel_amount"]!)", style: .alert)
                                            let pay = NewYorkButton(title: "বেতন : \(totalAmount)", style: .default) {
                                                _ in
                                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "before_payment_id") as? before_payment
                                                
                                                push!.str_booking_id2 = "\(self.dict_get_all_data_from_notification!["bookingId"]!)"
                                                push!.str_get_total_price2 = "\(totalAmount)"
                                                push!.get_full_data_for_payment2 = self.dict_get_all_data_from_notification
                                                
                                                self.navigationController?.pushViewController(push!, animated: true)
                                            }
                                            let cancel = NewYorkButton(title: "হোম", style: .default) {
                                                _ in
                                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as? dashboard
                                                self.navigationController?.pushViewController(push!, animated: true)
                                            }
                                            alert.addButtons([pay,cancel])
                                            self.present(alert, animated: true)
                                            
                                        }
                                        
                                    }
                                }
                                
                            } else {
                                print("Invalid number format in one of the strings.")
                            }
                            
                            
                            
                            /*// self.dict_get_booking_details = JSON
                             self.str_starrating = "\(dict["bookingrating"]!)"
                             self.tbleView.delegate = self
                             self.tbleView.dataSource = self
                             self.tbleView.reloadData()*/
                            
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
    /*
     
     */
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
                    "role"      : (person["role"] as! String)
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
                            
                            let delayInSeconds = Double(500) / 1000.0
                            DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
                                // Call the hitWebservice function after the delay
                                self.booking_history_details_WB(str_show_loader: "no")
                            }
                            
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
    
    
    
    
    @objc func home_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id")
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    @objc func chat_click_method() {
        
        print(self.dict_get_all_data_from_notification as Any)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BooCheckChatId") as? BooCheckChat
        // push!.str_get_user_id = "\(self.dict_get_all_data_from_notification["userId"]!)"
        
        // push!.str_driver_id = "\(self.dict_get_all_data_from_notification["userId"]!)"
        push!.get_all_data = self.dict_get_all_data_from_notification
        push!.str_booking_id = "\(self.dict_get_all_data_from_notification["bookingId"]!)"
        
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func cancancel_ride_click_method() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "decline_request_id") as? decline_request
        myAlert!.dict_booking_details   = self.dict_get_all_data_from_notification
        myAlert!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert!.modalTransitionStyle   = UIModalTransitionStyle.crossDissolve
        present(myAlert!, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func updateCounter() {
        
        if (counter == 2) {
            counter -= 1
        } else if (counter == 1) {
            counter -= 1
            self.hide_loading_UI()
        } else if (counter == 0) {
            timer.invalidate()
        }
        
    }
    
    
    /*@objc func iAmHereForLocationPermission() {
     // Ask for Authorisation from the User.
     self.locManager.requestAlwaysAuthorization()
     
     // For use in foreground
     self.locManager.requestWhenInUseAuthorization()
     
     if CLLocationManager.locationServicesEnabled() {
     switch CLLocationManager.authorizationStatus() {
     case .notDetermined, .restricted, .denied:
     print("No access")
     // self.strSaveLatitude = "0"
     // self.strSaveLongitude = "0"
     
     case .authorizedAlways, .authorizedWhenInUse:
     print("Access")
     
     locManager.delegate = self
     locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
     locManager.startUpdatingLocation()
     
     @unknown default:
     break
     }
     }
     }*/
    
    
    
    /*func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
     print("locations = \(locValue.latitude) \(locValue.longitude)")
     
     let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
     print(location)
     
     self.strSaveLatitude = "\(locValue.latitude)"
     self.strSaveLongitude = "\(locValue.longitude)"
     
     self.tbleView.delegate = self
     self.tbleView.dataSource = self
     self.tbleView.reloadData()
     
     let indexPath = IndexPath.init(row: 0, section: 0)
     let cell = self.tbleView.cellForRow(at: indexPath) as! ride_status_table_cell
     
     // cell.lblStartingLocation.text = String(self.str_from_location)
     // cell.lblEndLocation.text = String(self.str_to_location)
     cell.viewCellbg.isHidden = false
     
     // print(self.str_from_location as Any)
     // print(self.str_to_location as Any)
     
     // cell.lbl_from.text = String(self.str_from_location)
     // cell.lbl_to.text = String(self.str_to_location)
     
     print("**********************")
     
     let pickUp_lat_long = (self.dict_get_all_data_from_notification["RequestPickupLatLong"] as! String)
     let drop_lat_long = (self.dict_get_all_data_from_notification["RequestDropLatLong"] as! String)
     
     let pickUp = pickUp_lat_long.components(separatedBy: ",")
     let drop = drop_lat_long.components(separatedBy: ",")
     
     print(pickUp)
     print(drop)
     
     let restaurantLatitudeDouble    = Double(pickUp[0])
     let restaurantLongitudeDouble   = Double(pickUp[1])
     let driverLatitudeDouble        = Double(drop[0])
     let driverLongitudeDouble       = Double(drop[1])
     
     let coordinate₀ = CLLocation(latitude: restaurantLatitudeDouble!, longitude: restaurantLongitudeDouble!)
     let coordinate₁ = CLLocation(latitude: driverLatitudeDouble!, longitude: driverLongitudeDouble!)
     
     /************************************** RESTAURANT LATITUTDE AND LINGITUDE  ********************************/
     // first location
     let sourceLocation = CLLocationCoordinate2D(latitude: restaurantLatitudeDouble!, longitude: restaurantLongitudeDouble!)
     /********************************************************************************************************************/
     
     
     /************************************* DRIVER LATITUTDE AND LINGITUDE ******************************************/
     // second location
     let destinationLocation = CLLocationCoordinate2D(latitude: driverLatitudeDouble!, longitude: driverLongitudeDouble!)
     /********************************************************************************************************************/
     
     //print(sourceLocation)
     //print(destinationLocation)
     
     let sourcePin = customPin(pinTitle: "Drop Location", pinSubTitle: "", location: sourceLocation,image:UIImage(systemName: "car")!)
     
     let destinationPin = customPin(pinTitle: "Pick Location", pinSubTitle: "", location: destinationLocation,image:UIImage(systemName: "car")!)
     
     /***************** REMOVE PREVIUOS ANNOTATION TO GENERATE NEW ANNOTATION *******************************************/
     cell.mapView.removeAnnotations(cell.mapView.annotations)
     /********************************************************************************************************************/
     
     cell.mapView.addAnnotation(sourcePin)
     cell.mapView.addAnnotation(destinationPin)
     
     let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation)
     let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)
     
     let directionRequest = MKDirections.Request()
     directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
     directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
     directionRequest.transportType = .automobile
     
     let directions = MKDirections(request: directionRequest)
     directions.calculate { (response, error) in
     guard let directionResonse = response else {
     if let error = error {
     print("we have error getting directions==\(error.localizedDescription)")
     }
     return
     }
     
     /***************** REMOVE PREVIUOS POLYLINE TO GENERATE NEW POLYLINE *******************************/
     let overlays = cell.mapView.overlays
     cell.mapView.removeOverlays(overlays)
     /************************************************************************************/
     
     
     /***************** GET DISTANCE BETWEEN TWO CORDINATES *******************************/
     
     let distanceInMeters = coordinate₀.distance(from: coordinate₁)
     // print(distanceInMeters as Any)
     
     // remove decimal
     let distanceFloat: Double = (distanceInMeters as Any as! Double)
     
     //            cell.lbl_distance.text = (String(format: "%.0f Miles away", distanceFloat/1609.344))
     // cell.lbl_distance.text = (String(format: "%.0f", distanceFloat/1000))
     
     print(String(format: "Distance : %.0f KM away", distanceFloat/1000))
     print(String(format: "Distance : %.0f Miles away", distanceFloat/1609.344))
     
     /************************************************************************/
     
     /***************** GENERATE NEW POLYLINE *******************************/
     
     let route = directionResonse.routes[0]
     cell.mapView.addOverlay(route.polyline, level: .aboveRoads)
     let rect = route.polyline.boundingMapRect
     cell.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
     
     /***********************************************************************/
     
     }
     
     cell.mapView.delegate = self
     
     // self.locManager.stopUpdatingLocation()
     
     // self.locManager.startUpdatingLocation()
     
     self.locManager.stopUpdatingLocation()
     
     print("=================================")
     print("LOCATION UPDATE")
     print("=================================")
     
     self.tbleView.reloadData()
     
     // speed = distance / time
     }*/
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            
            if(annotation.title == "Drop Location") {
                annotationView.image = UIImage(systemName: "car")
            } else {
                annotationView.image = UIImage(systemName: "person")
            }
            annotationView.tintColor = .systemBlue
            
            
        }
        
        return annotationView
    }
    
    @objc func validation_before_confirm_booking() {
        
        /*let alert = NewYorkAlertController(title: String("Alert"), message: String("Are you sure you want to confirm this booking?"), style: .alert)
         
         let yes_confirm = NewYorkButton(title: "yes, confirm", style: .default) {
         _ in
         
         self.confirm_booking_WB()
         }
         
         let cancel = NewYorkButton(title: "dismiss", style: .destructive) {
         _ in
         }
         
         alert.addButtons([yes_confirm,cancel])
         self.present(alert, animated: true)*/
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                let alert = NewYorkAlertController(title: String("Alert"), message: String("Are you sure you want to confirm this booking?"), style: .alert)
                
                let yes_confirm = NewYorkButton(title: "yes, confirm", style: .default) {
                    _ in
                    
                    self.confirm_booking_WB()
                }
                
                let cancel = NewYorkButton(title: "dismiss", style: .destructive) {
                    _ in
                }
                
                alert.addButtons([yes_confirm,cancel])
                self.present(alert, animated: true)
                
            } else {
                let alert = NewYorkAlertController(title: String("সতর্ক"), message: String("আপনি কি নিশ্চিত আপনি এই বুকিং নিশ্চিত করতে চান?"), style: .alert)
                
                let yes_confirm = NewYorkButton(title: "হ্যাঁ, নিশ্চিত করুন", style: .default) {
                    _ in
                    
                    self.confirm_booking_WB()
                }
                
                let cancel = NewYorkButton(title: "বরখাস্ত করা", style: .destructive) {
                    _ in
                }
                
                alert.addButtons([yes_confirm,cancel])
                self.present(alert, animated: true)
            }
            
        } else {
            print("=============================")
            print("LOGIN : Select language error")
            print("=============================")
            UserDefaults.standard.set("en", forKey: str_language_convert)
        }
        
    }
    
    // MARK:- GET TOTAL DISTANCE FARE -
    @objc func confirm_booking_WB() {
        
        self.view.endEditing(true)
        
    }
    
    @objc func share_click_method() {
        let alertController = UIAlertController(title: "Share your ride", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "enter phone number"
            textField.keyboardType = .numberPad
        }
        let saveAction = UIAlertAction(title: "Send", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            
            self.str_user_save_phone_number = String(firstTextField.text!)
            self.share_to_my_friend_WB(str_show_loader: "yes")
        })
        
        alertController.addAction(saveAction)
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func share_to_my_friend_WB(str_show_loader:String) {
        
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
                    "action"        : "shareride",
                    "shreFrom"        : String(myString),
                    "mobilenumber"   : String(self.str_user_save_phone_number),
                    "bookingId"      : "\(self.dict_get_all_data_from_notification["bookingId"]!)",
                    
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
                            
                        } else if message == String(not_authorize_api) {
                            self.login_refresh_token_wb2()
                            
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
    
    @objc func login_refresh_token_wb2() {
        
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
                            
                            self.share_to_my_friend_WB(str_show_loader: "no")
                            
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
    
    
    
    @objc func confirmBookingSetOTP() {
        
        if (self.btnConfirmBooking.tag == 100) {
            return
        }
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            } else {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "অপেক্ষা করুন")
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
                    "action"        : "customerverify",
                    "bookingId"     : "\(self.dict_get_all_data_from_notification["bookingId"]!)",
                    "userId"        : String(myString),
                    "RideCode"      : "\(self.dict_get_all_data_from_notification["RideCode"]!)",
                    "language"      : String(lan),
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
                            
                            self.isRideCodeHidden = false
                            self.btnConfirmBooking.isHidden = false
                            self.btnConfirmBooking.tag = 100
                            self.btnConfirmBooking.setTitle("Driver arrived", for: .normal)
                            
                        } else if message == String(not_authorize_api) {
                            self.login_refresh_token_wb7()
                            
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
    
    /*
     
     */
    @objc func login_refresh_token_wb7() {
        
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
                    "role"      : (person["role"] as! String)
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
                            
                            self.confirmBookingSetOTP()
                            
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
    
    
    
    
    
    @objc func handleEveythingFromGoogleMapInit() {
        
        
        /*print(self.getLoginUserLatitudeTo as Any)
         print(self.getLoginUserLongitudeTo as Any)
         print(self.getLoginUserAddressTo as Any)
         
         print(self.getLoginUserLatitudeFrom as Any)
         print(self.getLoginUserLongitudeFrom as Any)
         print(self.getLoginUserAddressFrom as Any)
         
         UserDefaults.standard.set("", forKey: "key_map_view_lat_long")
         UserDefaults.standard.set(nil, forKey: "key_map_view_lat_long")
         
         UserDefaults.standard.set("", forKey: "key_map_view_address")
         UserDefaults.standard.set(nil, forKey: "key_map_view_address")
         
         UserDefaults.standard.set("", forKey: "keyUserSelectWhichProfile")
         UserDefaults.standard.set(nil, forKey: "keyUserSelectWhichProfile")
         */
        self.initializeMap()
    }
    
    func initializeMap() {
        
        print(dict_get_all_data_from_notification as Any)
        
        let separateDropLocation    = (self.dict_get_all_data_from_notification["RequestDropLatLong"] as! String)
        let separateRequestLocation    = (self.dict_get_all_data_from_notification["RequestPickupLatLong"] as! String)
        
        let separateDropLocationArr = separateDropLocation.components(separatedBy: ",")
        let separateRequestLocationArr = separateRequestLocation.components(separatedBy: ",")
        
        let dropLatitude    = separateDropLocationArr[0]
        let dropLongitude   = separateDropLocationArr[1]
        
        let requestLatitude    = separateRequestLocationArr[0]
        let requestLongitude   = separateRequestLocationArr[1]
        
        self.doublePlaceStartLat = Double(requestLatitude)
        self.doublePlaceStartLong = Double(requestLongitude)
        
        self.doublePlaceFinalLat = Double(dropLatitude)
        self.doublePlaceFinalLong = Double(dropLongitude)
        
        debugPrint(doublePlaceStartLat as Any)
        debugPrint(doublePlaceStartLong as Any)
        debugPrint(doublePlaceFinalLat as Any)
        debugPrint(doublePlaceFinalLong as Any)
        
        let camera = GMSCameraPosition.camera(withLatitude: doublePlaceStartLat!, longitude: doublePlaceStartLong!, zoom: 10.0)
        mapView = GMSMapView(frame: .zero)
        mapView.camera = camera
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        // Set up constraints for mapView
        NSLayoutConstraint.activate([
            // Set mapView's leading and trailing constraints to the view's leading and trailing edges
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Set mapView's top constraint to 220 points from the top of the view
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 220),
            
            // Set mapView's bottom constraint to be equal to the view's bottom anchor to make it extend to the bottom
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Ensure overlayView is added after mapView so it's on top
        view.bringSubviewToFront(navigationBar)
        view.bringSubviewToFront(view_bg)
        
        let placeACoordinate = CLLocationCoordinate2D(latitude: doublePlaceStartLat!, longitude: doublePlaceStartLong!)
        let placeBCoordinate = CLLocationCoordinate2D(latitude: doublePlaceFinalLat!, longitude: doublePlaceFinalLong!)
        
        addMarker(at: placeACoordinate, title: "Origin", snippet: (self.dict_get_all_data_from_notification["RequestPickupAddress"] as! String), color: .green)
        addMarker(at: placeBCoordinate, title: "Destination", snippet: (self.dict_get_all_data_from_notification["RequestDropAddress"] as! String), color: .yellow)
        
        fetchRoute(from: placeACoordinate, to: placeBCoordinate)
    }
    
    @objc func buttonUpClickMethod() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "search_location_id") as? search_location
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    func addMarker(at position: CLLocationCoordinate2D, title: String, snippet: String,color: UIColor) {
        let marker = GMSMarker()
        marker.position = position
        marker.title = title
        marker.snippet = snippet
        
        // Set marker icon color
        marker.icon = GMSMarker.markerImage(with: color)
        
        marker.map = mapView
    }
    
    func fetchRoute(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) {
        let origin = "\(self.doublePlaceStartLat!),\(self.doublePlaceStartLong!)"
        let destination = "\(self.doublePlaceFinalLat!),\(self.doublePlaceFinalLong!)"
        let apiKey = GOOGLE_MAP_API
        
        debugPrint(origin)
        debugPrint(destination)
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Network error")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let routes = json["routes"] as? [[String: Any]],
                   let route = routes.first,
                   let overviewPolyline = route["overview_polyline"] as? [String: Any],
                   let points = overviewPolyline["points"] as? String {
                    
                    DispatchQueue.main.async {
                        self.drawPath(fromEncodedPath: points)
                    }
                }
            } catch {
                print("JSON parsing error")
            }
        }
        
        task.resume()
    }
    
    func drawPath(fromEncodedPath encodedPath: String) {
        guard let path = GMSPath(fromEncodedPath: encodedPath) else {
            print("Failed to decode path")
            return
        }
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .blue
        polyline.strokeWidth = 5.0
        polyline.map = mapView
        
        // Call zoom function
        zoomToFitRoute(withPath: path)
    }
    
    func zoomToFitRoute(withPath path: GMSPath) {
        let bounds = GMSCoordinateBounds(path: path)
        let update = GMSCameraUpdate.fit(bounds, withPadding: 100.0)
        mapView.animate(with: update)
        
        if (self.dict_get_all_data_from_notification["type"] != nil) {
            if(self.dict_get_all_data_from_notification["type"] as! String == "rideend") {
                print(self.dict_get_all_data_from_notification as Any)
                
                let delayInSeconds = Double(600) / 1000.0
                DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
                    // Call the hitWebservice function after the delay
                    debugPrint("Show popup now")
                    ERProgressHud.sharedInstance.hide()
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "pay_after_ride_cancel_id") as? pay_after_ride_cancel
                    push!.dictGetAllData = self.dict_get_all_data_from_notification
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                    // self.booking_history_details_WB(str_show_loader: "yes")
                }
                
            } else {
                ERProgressHud.sharedInstance.hide()
            }
        } else {
            ERProgressHud.sharedInstance.hide()
        }
        
    }
}


//MARK:- TABLE VIEW -
extension ride_status: UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ride_status_table_cell = tableView.dequeueReusableCell(withIdentifier: "ride_status_table_cell") as! ride_status_table_cell
        
        cell.backgroundColor = .white
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        /*
         DriverImage = "";
         RequestDropAddress = "Modinagar Modinagar";
         RequestDropLatLong = "28.835619,77.569403";
         RequestPickupAddress = "Sector 10 Dwarka South West Delhi New Delhi,New Delhi,India";
         RequestPickupLatLong = "28.587152917200502,77.06061415697155";
         VehicleColor = red;
         aps =     {
             alert = "iDriver5 has confirmed your booling.";
         };
         bookingId = 87;
         driverContact = 8287632345;
         driverId = 13;
         driverLatitude = "28.587238814653944";
         driverName = iDriver5;
         driverlongitude = "77.06062328401764";
         "gcm.message_id" = 1693292390930120;
         "google.c.a.e" = 1;
         "google.c.fid" = cwFMTZl0K0fpkfcPMinYSO;
         "google.c.sender.id" = 750959835757;
         message = "iDriver5 has confirmed your booling.";
         rating = 0;
         type = confirm;
         vehicleNumber = dl007;
         */
        
        
        if (self.dict_get_all_data_from_notification != nil) {
            
            cell.lbl_from.text = (self.dict_get_all_data_from_notification["RequestPickupAddress"] as! String)
            cell.lbl_to.text = (self.dict_get_all_data_from_notification["RequestDropAddress"] as! String)
            
            /*cell.lbl_car_details.text = (self.dict_get_all_data_from_notification["vehicleNumber"] as! String)+" ("+(self.dict_get_all_data_from_notification["VehicleColor"] as! String)+" )"
            
            cell.lbl_driver_name.text = (self.dict_get_all_data_from_notification["driverName"] as! String)
            cell.lbl_driver_name.text = "\(self.dict_get_all_data_from_notification["rating"]!)"*/

            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }
    
}
 
class ride_status_table_cell: UITableViewCell {
    
    
    // @IBOutlet weak var  mapView:MKMapView!
    
    
    @IBOutlet weak var lbl_from:UILabel!
    @IBOutlet weak var lbl_to:UILabel!
    
    @IBOutlet weak var viewCellbg:UIView! {
        didSet {
            viewCellbg.layer.cornerRadius = 8
            viewCellbg.clipsToBounds = true
            viewCellbg.backgroundColor = UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1)
            
            viewCellbg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viewCellbg.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viewCellbg.layer.shadowOpacity = 1.0
            viewCellbg.layer.shadowRadius = 15.0
            viewCellbg.layer.masksToBounds = false
            viewCellbg.backgroundColor = .white
            
    
        }
    }
    
    
}
