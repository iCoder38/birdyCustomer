//
//  add_address.swift
//  PathMark
//
//  Created by Dishant Rajput on 16/08/23.
//

import UIKit

// MARK:- LOCATION -
import CoreLocation
import Alamofire

class add_address: UIViewController , CLLocationManagerDelegate {

    var dict_address:NSDictionary!
    var str_address_id:String!
    var str_Address_text:String!
    
    let locationManager = CLLocationManager()
    
    // MARK:- SAVE LOCATION STRING -
    var strSaveLatitude:String!
    var strSaveLongitude:String!
    var strSaveCountryName:String!
    var strSaveLocalAddress:String!
    var strSaveLocality:String!
    var strSaveLocalAddressMini:String!
    var strSaveStateName:String!
    var strSaveZipcodeName:String!
    
    // new
    var getLoginUserLatitudeTo:String!
    var getLoginUserLongitudeTo:String!
    var getLoginUserAddressTo:String!
    var getLoginUserLatitudeFrom:String!
    var getLoginUserLongitudeFrom:String!
    var getLoginUserAddressFrom:String!
    
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
                    view_navigation_title.text = "Add address"
                } else {
                    view_navigation_title.text = "নতুন ঠিকানা যোগ করুন"
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
    
    @IBOutlet weak var lbl_complete_address:UILabel!
    @IBOutlet weak var lbl_save_as:UILabel!
    @IBOutlet weak var lbl_additional_info:UILabel!
    
    @IBOutlet weak var lbl_current_address:UILabel!
    
    @IBOutlet weak var txt_house_number:UITextField! {
        didSet {
            // shadow
            txt_house_number.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_house_number.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_house_number.layer.shadowOpacity = 1.0
            txt_house_number.layer.shadowRadius = 10.0
            txt_house_number.layer.masksToBounds = false
            txt_house_number.layer.cornerRadius = 12
            txt_house_number.backgroundColor = .white
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_house_number.frame.height))
            txt_house_number.leftView = paddingView
            txt_house_number.leftViewMode = UITextField.ViewMode.always
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    
                    txt_house_number.placeholder = "House No. / Flat No. Building"
                     
                } else {
                    txt_house_number.placeholder = "বাড়ি নং / ফ্ল্যাট নং বিল্ডিং"
                     
                }
                
                
            }
            
        }
    }
    
    @IBOutlet weak var txt_save_as:UITextField! {
        didSet {
            // shadow
            txt_save_as.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_save_as.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_save_as.layer.shadowOpacity = 1.0
            txt_save_as.layer.shadowRadius = 10.0
            txt_save_as.layer.masksToBounds = false
            txt_save_as.layer.cornerRadius = 12
            txt_save_as.backgroundColor = .white
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_save_as.frame.height))
            txt_save_as.leftView = paddingView
            txt_save_as.leftViewMode = UITextField.ViewMode.always
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    
                     
                    txt_save_as.placeholder = "Home / Work / Other"
                } else {
                     
                    txt_save_as.placeholder = "বাড়ি / কাজ / অন্যান্য"
                }
                
                
            }
            
        }
    }
    
    @IBOutlet weak var lbl_name:UILabel! {
        didSet {
            lbl_name.isHidden = true
        }
    }
    @IBOutlet weak var txt_enter_name:UITextField! {
        didSet {
            // shadow
            txt_enter_name.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_enter_name.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_enter_name.layer.shadowOpacity = 1.0
            txt_enter_name.layer.shadowRadius = 10.0
            txt_enter_name.layer.masksToBounds = false
            txt_enter_name.layer.cornerRadius = 12
            txt_enter_name.backgroundColor = .white
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_enter_name.frame.height))
            txt_enter_name.leftView = paddingView
            txt_enter_name.leftViewMode = UITextField.ViewMode.always
            
            txt_enter_name.isHidden = true
        }
    }
    
    @IBOutlet weak var txt_additional_info:UITextField! {
        didSet {
            // shadow
            txt_additional_info.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_additional_info.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_additional_info.layer.shadowOpacity = 1.0
            txt_additional_info.layer.shadowRadius = 10.0
            txt_additional_info.layer.masksToBounds = false
            txt_additional_info.layer.cornerRadius = 12
            txt_additional_info.backgroundColor = .white
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_additional_info.frame.height))
            txt_additional_info.leftView = paddingView
            txt_additional_info.leftViewMode = UITextField.ViewMode.always
            
            txt_additional_info.isHidden = false
        }
    }
    
    
    @IBOutlet weak var btnCompleteAddress:UIButton!
    
    @IBOutlet weak var btn_save:UIButton!
    
    var str_save_lat:String!
    var str_save_long:String!
    var str_save_address:String!
    
    @IBOutlet weak var btn_submit:UIButton! {
        didSet {
            btn_submit.setTitle("SAVE ADDRESS", for: .normal)
            btn_submit.setTitleColor(.white, for: .normal)
            btn_submit.layer.cornerRadius = 6
            btn_submit.clipsToBounds = true
            btn_submit.backgroundColor = UIColor.init(red: 104.0/255.0, green: 218.0/255.0, blue: 134.0/255.0, alpha: 1)
            
            // shadow
            btn_submit.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_submit.layer.shadowOffset = CGSize(width: 0, height: 3)
            btn_submit.layer.shadowOpacity = 1.0
            btn_submit.layer.shadowRadius = 10.0
            btn_submit.layer.masksToBounds = false
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.btn_save.addTarget(self, action: #selector(save_as_click_method), for: .touchUpInside)
        self.iAmHereForLocationPermission()
        
        self.btn_back.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        self.btn_submit.addTarget(self, action: #selector(validate_before_submit), for: .touchUpInside)
        self.btnCompleteAddress.addTarget(self, action: #selector(map_view_click_method), for: .touchUpInside)
        
        // @IBOutlet weak var lbl_complete_address:UILabel!
        // @IBOutlet weak var lbl_save_as:UILabel!
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                
                self.lbl_complete_address.text = "Enter location"
                self.lbl_save_as.text = "Save as"
                self.lbl_additional_info.text = "Additional info"
                
            } else {
                
                self.lbl_complete_address.text = "অবস্থান লিখুন"
                self.lbl_save_as.text = "সংরক্ষণ করুন"
                self.lbl_additional_info.text = "অতিরিক্ত তথ্য"
                
            }
            
            
        } else {
            print("=============================")
            print("LOGIN : Select language error")
            print("=============================")
            UserDefaults.standard.set("en", forKey: str_language_convert)
        }
        
        if (self.dict_address == nil) {
            print("add contact")
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    self.view_navigation_title.text = "NEW ADDRESS"
                    self.btn_submit.setTitle("SAVE ADDRESS", for: .normal)
                } else {
                    self.view_navigation_title.text = "নতুন ঠিকানা যোগ করুন"
                    self.btn_submit.setTitle("ঠিকানা সংরক্ষণ করুন", for: .normal)
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
        } else {
            print("edit contact")
            
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    self.view_navigation_title.text = "EDIT ADDRESS"
                    self.btn_submit.setTitle("SAVE ADDRESS", for: .normal)
                } else {
                    self.view_navigation_title.text = "ঠিকানা সম্পাদনা করুন"
                    self.btn_submit.setTitle("ঠিকানা সংরক্ষণ করুন", for: .normal)
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
            
            print(self.dict_address as Any)
            
            self.txt_house_number.text = (self.dict_address["address"] as! String)
            self.txt_additional_info.text = (self.dict_address["address_Info"] as! String)
            self.txt_enter_name.text = (self.dict_address["address_name"] as! String)
            
            if "\(self.dict_address["addressType"]!)" == "2" {
                self.txt_enter_name.isHidden = false
            }
            // self.txt_save_as.text = (self.dict_address["addressType"] as! String)
            
             
            let fullNameArr = "\(self.dict_address["coordinate"]!)".components(separatedBy: ",")

            let name    = fullNameArr[0]
            let surname = fullNameArr[1]
            self.str_save_lat = "\(name)"
            self.str_save_lat = "\(surname)"
            
            
            if ("\(self.dict_address["addressType"]!)" == "0") {
                
                
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        self.txt_save_as.text = "Home"
                        self.str_Address_text = "0"
                    } else {
                        self.txt_save_as.text = "বাড়ি"
                        self.str_Address_text = "0"
                    }
                    
                } else {
                    print("=============================")
                    print("LOGIN : Select language error")
                    print("=============================")
                    UserDefaults.standard.set("en", forKey: str_language_convert)
                }
                
                
            } else if ("\(self.dict_address["addressType"]!)" == "1") {
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        self.txt_save_as.text = "Work"
                        self.str_Address_text = "1"
                    } else {
                        self.txt_save_as.text = "কাজ"
                        self.str_Address_text = "1"
                    }
                    
                } else {
                    print("=============================")
                    print("LOGIN : Select language error")
                    print("=============================")
                    UserDefaults.standard.set("en", forKey: str_language_convert)
                }
            } else {
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        self.txt_save_as.text = "Other"
                        self.str_Address_text = "2"
                    } else {
                        self.txt_save_as.text = "অন্যান্য"
                        self.str_Address_text = "2"
                    }
                    
                } else {
                    print("=============================")
                    print("LOGIN : Select language error")
                    print("=============================")
                    UserDefaults.standard.set("en", forKey: str_language_convert)
                }
            }
            
            self.str_address_id = "\(self.dict_address["addressId"]!)"
        }
    }
  
    @objc func map_view_click_method() {
        UserDefaults.standard.set("userLocationTo", forKey: "keyUserSelectWhichProfile")
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "select_location_via_name_id") as? select_location_via_name
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        /*
         UserDefaults.standard.set(String(self.searchLat), forKey: "key_save_lat_for_address")
         UserDefaults.standard.set(String(self.searchLong), forKey: "key_save_long_for_address")
         UserDefaults.standard.set(completion.title+","+completion.subtitle, forKey: "key_save_full_address_for_address")
         */
        // latitude
        /*if let load_latitude = UserDefaults.standard.string(forKey: "key_save_lat_for_address") {
            print(load_latitude)
            
            self.str_save_lat = load_latitude
           
        }
        
        // longitude
        if let load_longitude = UserDefaults.standard.string(forKey: "key_save_long_for_address") {
            print(load_longitude)
            
            self.str_save_long = load_longitude
           
        }
        
        // address
        if let load_address = UserDefaults.standard.string(forKey: "key_save_full_address_for_address") {
            print(load_address)
            
            self.str_save_address = load_address
            self.txt_house_number.text = String(self.str_save_address)
            
        }
        UserDefaults.standard.set("", forKey: "key_save_lat_for_address")
        UserDefaults.standard.set(nil, forKey: "key_save_lat_for_address")
        UserDefaults.standard.set("", forKey: "key_save_long_for_address")
        UserDefaults.standard.set("", forKey: "key_save_full_address_for_address")
        UserDefaults.standard.set(nil, forKey: "key_save_full_address_for_address")*/
        
        if let profileUpOrBottom = UserDefaults.standard.string(forKey: "keyUserSelectWhichProfile") {
            debugPrint(profileUpOrBottom)
            
            if (profileUpOrBottom == "userLocationTo") {
                
                debugPrint("SET VALUE FOR TO")
                
                if let load_latitude = UserDefaults.standard.string(forKey: "key_map_view_lat_long") {
                    print(load_latitude)
                    
                    // self.str_save_lat = load_latitude
                    let fullName    = load_latitude
                    let fullNameArr = fullName.components(separatedBy: ",")
                    
                    let name    = fullNameArr[0]
                    let surname = fullNameArr[1]
                    
                    self.getLoginUserLatitudeTo = String(name)
                    self.getLoginUserLongitudeTo = String(surname)
                    
                }
                
                // address
                if let address = UserDefaults.standard.string(forKey: "key_map_view_address") {
                    print(address)
                    
                    self.txt_house_number.text = String(address)
                    self.getLoginUserAddressTo = String(address)
                }
                
            } else {
                
                debugPrint("set value for from")
                if let load_latitude = UserDefaults.standard.string(forKey: "key_map_view_lat_long") {
                    print(load_latitude)
                    
                    // self.str_save_lat = load_latitude
                    let fullName    = load_latitude
                    let fullNameArr = fullName.components(separatedBy: ",")
                    
                    let name    = fullNameArr[0]
                    let surname = fullNameArr[1]
                    
                    self.getLoginUserLatitudeFrom = String(name)
                    self.getLoginUserLongitudeFrom = String(surname)
                    
                }
                
                // address
                if let address = UserDefaults.standard.string(forKey: "key_map_view_address") {
                    print(address)
                    
                     self.txt_house_number.text = String(address)
                    self.getLoginUserAddressFrom = String(address)
                }
            }
        }
        
        self.handleEveythingFromGoogleMapInit()
    }
    
    
    @objc func handleEveythingFromGoogleMapInit() {
        print(self.getLoginUserLatitudeTo as Any)
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
        
        // self.initializeMap()
    }

    
    @objc func save_as_click_method() {
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                
                let alertController = UIAlertController(title: "Save as", message: "", preferredStyle: .actionSheet)
                
                let home = UIAlertAction(title: "Home", style: .default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    self.txt_save_as.text = "Home"
                    self.str_Address_text = "0"
                    
                    self.lbl_name.isHidden = true
                    self.txt_enter_name.isHidden = true
                    
                    self.txt_enter_name.text = ""
                }
                
                let work = UIAlertAction(title: "Work", style: .default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    self.txt_save_as.text = "Work"
                    self.str_Address_text = "1"
                    
                    self.lbl_name.isHidden = true
                    self.txt_enter_name.isHidden = true
                    
                    self.txt_enter_name.text = ""
                }
                
                let other = UIAlertAction(title: "Other", style: .default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    self.txt_save_as.text = "Other"
                    self.str_Address_text = "2"
                    
                    self.lbl_name.isHidden = false
                    self.txt_enter_name.isHidden = false
                    
                }
                
                let dismiss = UIAlertAction(title: "Dismiss", style: .cancel) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }
                
                alertController.addAction(home)
                alertController.addAction(work)
                alertController.addAction(other)
                alertController.addAction(dismiss)
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "সংরক্ষণ করুন", message: "", preferredStyle: .actionSheet)
                
                let home = UIAlertAction(title: "বাড়ি", style: .default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    self.txt_save_as.text = "বাড়ি"
                    self.str_Address_text = "0"
                    
                    self.lbl_name.isHidden = true
                    self.txt_enter_name.isHidden = true
                    
                    self.txt_enter_name.text = ""
                }
                
                let work = UIAlertAction(title: "কাজ", style: .default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    self.txt_save_as.text = "কাজ"
                    self.str_Address_text = "1"
                    
                    self.lbl_name.isHidden = true
                    self.txt_enter_name.isHidden = true
                    
                    self.txt_enter_name.text = ""
                }
                
                let other = UIAlertAction(title: "অন্যান্য", style: .default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    self.txt_save_as.text = "অন্যান্য"
                    self.str_Address_text = "2"
                    
                    self.lbl_name.isHidden = true
                    self.txt_enter_name.isHidden = true
                    
                    self.txt_enter_name.text = ""
                }
                
                let dismiss = UIAlertAction(title: "খারিজ", style: .cancel) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }
                
                alertController.addAction(home)
                alertController.addAction(work)
                alertController.addAction(other)
                alertController.addAction(dismiss)
                
                self.present(alertController, animated: true, completion: nil)
            }
            
            
        }
        
        
        
    }
    
    @objc func iAmHereForLocationPermission() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                
                self.strSaveLatitude = "0"
                self.strSaveLongitude = "0"
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                
                DispatchQueue.global().async {
                    if CLLocationManager.locationServicesEnabled() {
                        // your code here
                        self.locationManager.delegate = self
                        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                        self.locationManager.startUpdatingLocation()
                    }
                }
                
            @unknown default:
                break
            }
        }
    }
     
    // MARK:- GET CUSTOMER LOCATION -
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tbleView.cellForRow(at: indexPath) as! PDBagPurchaseTableCell
        
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
        location.fetchCityAndCountry { city, country, zipcode,localAddress,localAddressMini,locality, error in
            guard let city = city, let country = country,let zipcode = zipcode,let localAddress = localAddress,let localAddressMini = localAddressMini,let locality = locality, error == nil else { return }
            
            self.strSaveCountryName     = country
            self.strSaveStateName       = city
            self.strSaveZipcodeName     = zipcode
            
            self.strSaveLocalAddress     = localAddress
            self.strSaveLocality         = locality
            self.strSaveLocalAddressMini = localAddressMini
            
            let doubleLat = locValue.latitude
            let doubleStringLat = String(doubleLat)
            
            let doubleLong = locValue.longitude
            let doubleStringLong = String(doubleLong)
            
            self.strSaveLatitude = String(doubleStringLat)
            self.strSaveLongitude = String(doubleStringLong)
            
            // print("local address ==> "+localAddress as Any) // south west delhi
            // print("local address mini ==> "+localAddressMini as Any) // new delhi
            // print("locality ==> "+locality as Any) // sector 10 dwarka
            
            // print(self.strSaveCountryName as Any) // india
            // print(self.strSaveStateName as Any) // new delhi
            // print(self.strSaveZipcodeName as Any) // 110075
            
            //MARK:- STOP LOCATION -
            self.locationManager.stopUpdatingLocation()
            
            // self.lbl_current_address.text = String(self.strSaveLocality)+" "+String(self.strSaveLocalAddress)+" "+String(self.strSaveLocalAddressMini)+","+String(self.strSaveStateName)+","+String(self.strSaveCountryName)
            
            if (self.dict_address == nil) {
                
                print("add contact")
                // self.txt_house_number.text = String(self.strSaveLocality)+" "+String(self.strSaveLocalAddress)+" "+String(self.strSaveLocalAddressMini)+","+String(self.strSaveStateName)+","+String(self.strSaveCountryName)
                
            }
            
            // print(self.strSaveLatitude as Any)
            // print(self.strSaveLongitude as Any)

        }
    }
    
    @objc func  validate_before_submit() {
        
        if (self.dict_address == nil) {
            print("add contact")
            self.add_address_WB(str_show_loader: "yes")
            
        } else {
            print("edit contact")
            self.view_navigation_title.text = "EDIT ADDRESS"
            
            self.edit_address_WB(str_show_loader: "yes")
        }
    }
    
    @objc func edit_address_WB(str_show_loader:String) {
        
        if (str_show_loader == "yes") {
            
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "editing...")
                } else {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "সম্পাদনা...")
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
            
        }
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            
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
                    "action"        : "addressadd",
                    "userId"        : String(myString),
                    "addressId"     : String(self.str_address_id),
                    "address"       : String(self.txt_house_number.text!),
                    "addressType"   : String(self.str_Address_text),
                    "coordinate"    : String(self.self.getLoginUserLatitudeTo)+","+String(self.self.getLoginUserLongitudeTo),
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
                            // self.hide_loading_UI()
                            
                            if strSuccess.lowercased() == "success" {
                                
                                let str_token = (JSON["AuthToken"] as! String)
                                UserDefaults.standard.set("", forKey: str_save_last_api_token)
                                UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                                
                                ERProgressHud.sharedInstance.hide()
                                self.back_click_method()
                                
                            } else {
                                self.login_refresh_token_wb()
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
    }
    
    @objc func login_refresh_edit_token_wb() {
        
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
                               
                            self.edit_address_WB(str_show_loader: "no")
                           
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
    
    
    
    @objc func add_address_WB(str_show_loader:String) {
        
        // self.show_loading_UI()
        
        if (str_show_loader == "yes") {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "adding...")
        }
        
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            
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
                    "action"        : "addressadd",
                    "userId"        : String(myString),
                    "address"       : String(self.txt_house_number.text!),
                    "addressType"   : String(self.str_Address_text),
                    "coordinate"    : String(self.getLoginUserLatitudeTo)+","+String(self.getLoginUserLongitudeTo),
                    "language"      : String(lan),
                    "address_Info"  : String(self.txt_additional_info.text!),
                    "address_name"  : String(self.txt_enter_name.text!)
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
                            // self.hide_loading_UI()
                            
                            if strSuccess.lowercased() == "success" {
                                
                                let str_token = (JSON["AuthToken"] as! String)
                                UserDefaults.standard.set("", forKey: str_save_last_api_token)
                                UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                                
                                ERProgressHud.sharedInstance.hide()
                                self.back_click_method()
                                
                            } else {
                                ERProgressHud.sharedInstance.hide()
                                self.login_refresh_token_wb()
                            }
                            
                            
                        }
                        
                    case .failure(_):
                        print("Error message:\(String(describing: response.error))")
                        self.hide_loading_UI()
                        self.please_check_your_internet_connection()
                        ERProgressHud.sharedInstance.hide()
                        
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
                               
                            self.add_address_WB(str_show_loader: "no")
                           
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
