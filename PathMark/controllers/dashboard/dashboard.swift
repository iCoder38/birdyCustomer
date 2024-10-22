//
//  dashboard.swift
//  PathMark
//
//  Created by Dishant Rajput on 10/07/23.
//

import UIKit
import MapKit
import SDWebImage

// MARK:- LOCATION -
import CoreLocation
import ZKCarousel

import Alamofire

class dashboard: UIViewController , CLLocationManagerDelegate {
    
    // MARK:- SAVE LOCATION STRING -
    var strSaveLatitude:String!
    var strSaveLongitude:String!
    var strSaveCountryName:String!
    var strSaveLocalAddress:String!
    var strSaveLocality:String!
    var strSaveLocalAddressMini:String!
    var strSaveStateName:String!
    var strSaveZipcodeName:String!
    
    var str_selected_language_is:String!
    
    var loginUserLatitudeTo:String!
    var loginUserLongitudeTo:String!
    var loginUserAddressTo:String!
    var loginUserLatitudeFrom:String!
    var loginUserLongitudeFrom:String!
    var loginUserAddressFrom:String!
    
    @IBOutlet weak var view_navigation_bar:UIView! {
        didSet {
            view_navigation_bar.applyGradient()
        }
    }
    
    @IBOutlet weak var btn_back:UIButton!
    
    @IBOutlet weak var view_navigation_title:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    view_navigation_title.text = "Dashboard"
                } else {
                    view_navigation_title.text = "ড্যাশবোর্ড"
                }
                
            }
            
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var tbleView:UITableView! {
        didSet {
            tbleView.isHidden = true
            tbleView.backgroundColor = .white
            tbleView.separatorColor = .clear
        }
    }
    
    @IBOutlet var carousel: ZKCarousel? = ZKCarousel()
    
    // var arr_banner = ["car_image_name","car_image_name"]
    
    var arr_banner:NSMutableArray! = []
    var arrCarCategories:NSMutableArray! = []
    
    var str_token_id:String!
    
    var str_vehicle_type:String! = "0"
    var str_select_option:String! = "0"
    
    // new
    var userLatitude: Double?
    var userLongitude: Double?
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    var userAddress: String?
    
    var strUserSelectCarCategory:String!
    
    @IBOutlet weak var btn_car:UIButton! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_car.setImage(UIImage(named: "ns_car"), for: .normal)
                } else {
                    btn_car.setImage(UIImage(named: "car_bangla_unselected"), for: .normal)
                }
                
            }
            
            btn_car.titleLabel!.font = UIFont(name: "Poppins-Regular", size: 14.0)!
            btn_car.backgroundColor = .systemPurple
            btn_car.layer.cornerRadius = 14
            btn_car.clipsToBounds = true
            
            btn_car.layer.masksToBounds = false
            btn_car.layer.shadowColor = UIColor.black.cgColor
            btn_car.layer.shadowOffset =  CGSize.zero
            btn_car.layer.shadowOpacity = 0.5
            btn_car.layer.shadowRadius = 2
            btn_car.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var btn_car_checkmark:UIButton! {
        didSet {
            btn_car_checkmark.setImage(UIImage(named: "un_check"), for: .normal)
        }
    }
    @IBOutlet weak var btn_bike_checkmark:UIButton! {
        didSet {
            btn_bike_checkmark.setImage(UIImage(named: "un_check"), for: .normal)
        }
    }
    @IBOutlet weak var btn_intercity_checkmark:UIButton! {
        didSet {
            btn_intercity_checkmark.setImage(UIImage(named: "un_check"), for: .normal)
        }
    }
    
    @IBOutlet weak var btn_bike:UIButton! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_bike.setImage(UIImage(named: "ns_bike"), for: .normal)
                } else {
                    btn_bike.setImage(UIImage(named: "bike_bangla_unselected"), for: .normal)
                }
                
            }
            btn_bike.titleLabel!.font = UIFont(name: "Poppins-Regular", size: 14.0)!
            btn_bike.backgroundColor = .systemPurple
            btn_bike.layer.cornerRadius = 14
            btn_bike.clipsToBounds = true
            
            btn_bike.layer.masksToBounds = false
            btn_bike.layer.shadowColor = UIColor.black.cgColor
            btn_bike.layer.shadowOffset =  CGSize.zero
            btn_bike.layer.shadowOpacity = 0.5
            btn_bike.layer.shadowRadius = 2
            btn_bike.layer.cornerRadius = 12
        }
    }
    @IBOutlet weak var btn_intercity:UIButton! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_intercity.setImage(UIImage(named: "ns_intercity"), for: .normal)
                } else {
                    btn_intercity.setImage(UIImage(named: "intercity_bangla_unselected"), for: .normal)
                }
                
            }
            btn_intercity.titleLabel!.font = UIFont(name: "Poppins-Regular", size: 14.0)!
            btn_intercity.backgroundColor = .systemPurple
            btn_intercity.layer.cornerRadius = 14
            btn_intercity.clipsToBounds = true
            
            btn_intercity.layer.masksToBounds = false
            btn_intercity.layer.shadowColor = UIColor.black.cgColor
            btn_intercity.layer.shadowOffset =  CGSize.zero
            btn_intercity.layer.shadowOpacity = 0.5
            btn_intercity.layer.shadowRadius = 2
            btn_intercity.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var btn_next:UIButton! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_next.setTitle("Next", for: .normal)
                } else {
                    btn_next.setTitle("পরবর্তী", for: .normal)
                }
                
            }
        }
    }
    
    @IBOutlet weak var btn_previous:UIButton! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_previous.setTitle("Previous", for: .normal)
                } else {
                    btn_previous.setTitle("পূর্ববর্তী", for: .normal)
                }
                
            }
        }
    }
    
    @IBOutlet weak var page_control:UIPageControl! {
        didSet {
            page_control.currentPage = 0
            page_control.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var collectionView:UICollectionView! {
        didSet {
            collectionView.isPagingEnabled = true
            collectionView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var btn_push_to_map:UIButton!
    @IBOutlet weak var btn_push_to_map_down:UIButton!
    
    @IBOutlet weak var viewPlace:UIView! {
        didSet {
            viewPlace.backgroundColor = .white
            viewPlace.layer.masksToBounds = false
            viewPlace.layer.shadowColor = UIColor.black.cgColor
            viewPlace.layer.shadowOffset =  CGSize.zero
            viewPlace.layer.shadowOpacity = 0.5
            viewPlace.layer.shadowRadius = 2
            viewPlace.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var lbl_my_full_address:UILabel! {
        didSet {
            lbl_my_full_address.text = ""
        }
    }
    
    @IBOutlet weak var view_select_vehicle:UIView! {
        didSet {
            view_select_vehicle.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var btn_book_a_ride_now:UIButton! {
        didSet {
            Utils.buttonStyle(button: btn_book_a_ride_now,
                              bCornerRadius: 0,
                              bBackgroundColor: navigation_color,
                              bTitle: "BOOK A RIDE NOW",
                              bTitleColor: .white)
            
            btn_book_a_ride_now.layer.masksToBounds = false
            btn_book_a_ride_now.layer.shadowColor = UIColor.black.cgColor
            btn_book_a_ride_now.layer.shadowOffset =  CGSize.zero
            btn_book_a_ride_now.layer.shadowOpacity = 0.5
            btn_book_a_ride_now.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var btn_schedule_a_ride_now:UIButton! {
        didSet {
            Utils.buttonStyle(button: btn_schedule_a_ride_now,
                              bCornerRadius: 0,
                              bBackgroundColor: UIColor(red: 246.0/255.0, green: 200.0/255.0, blue: 68.0/255.0, alpha: 1),
                              bTitle: "SCHEDULE A RIDE",
                              bTitleColor: .white)
            
            btn_schedule_a_ride_now.layer.masksToBounds = false
            btn_schedule_a_ride_now.layer.shadowColor = UIColor.black.cgColor
            btn_schedule_a_ride_now.layer.shadowOffset =  CGSize.zero
            btn_schedule_a_ride_now.layer.shadowOpacity = 0.5
            btn_schedule_a_ride_now.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var lbl_select_destination:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_select_destination.text = "Select destination"
                } else {
                    lbl_select_destination.text = "গন্তব্য নির্বাচন করুন"
                }
                
            }
        }
    }
    
    @IBOutlet weak var lbl_set_ride_location:UILabel!
    @IBOutlet weak var lbl_select_vehicle:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.sideBarMenu(button: self.btn_back)
        
        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "bKash_payment_gateway_id") as? bKash_payment_gateway
         self.navigationController?.pushViewController(push!, animated: true)*/
        
        self.tbleView.delegate = self
        self.tbleView.dataSource = self
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                self.str_selected_language_is = "en"
            } else {
                self.str_selected_language_is = "bn"
            }
            
        } else {
            print("=============================")
            print("LOGIN : Select language error")
            print("=============================")
            self.str_selected_language_is = "en"
            UserDefaults.standard.set("en", forKey: str_language_convert)
        }
        
        // location
        // self.iAmHereForLocationPermission()
        
        
        
        if let device_token = UserDefaults.standard.string(forKey: "key_my_device_token") {
            
            self.str_token_id = String(device_token)
        }
        
        self.btn_push_to_map.addTarget(self, action: #selector(please_select_atleast_one_vehicle), for: .touchUpInside)
        self.btn_push_to_map_down.addTarget(self, action: #selector(please_select_atleast_one_vehicle2), for: .touchUpInside)
       
        // book a ride now
        self.btn_book_a_ride_now.addTarget(self, action: #selector(bookARideNowClickMethod), for: .touchUpInside)
        
        
        self.getUsersCurrentLatLong()
        
    }
    
    @objc func bookARideNowClickMethod() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "total_fare_distance_mpa_route_id") as? total_fare_distance_mpa_route
       
        // login user location
        push!.my_location_lat = String(self.loginUserLatitudeTo)
        push!.my_location_long = String(self.loginUserLongitudeTo)
        
        // destination lat long
        push!.searched_place_location_lat = String(self.loginUserLatitudeFrom)
        push!.searched_place_location_long = String(self.loginUserLongitudeFrom)
        
        // id
        push!.str_get_category_id = String(self.strUserSelectCarCategory)
        
        // address
        push!.str_to_location =  String(self.loginUserAddressTo)
        push!.str_from_location =  String(self.loginUserAddressFrom)
        
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //        UserDefaults.standard.set("", forKey: "key_map_view_lat_long")
        //        UserDefaults.standard.set(nil, forKey: "key_map_view_lat_long")
        //
        //        UserDefaults.standard.set("", forKey: "key_map_view_address")
        //        UserDefaults.standard.set(nil, forKey: "key_map_view_address")
        //
        //        UserDefaults.standard.set("", forKey: "keyUserSelectWhichProfile")
        //        UserDefaults.standard.set(nil, forKey: "keyUserSelectWhichProfile")
        
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
                    
                    self.loginUserLatitudeTo = String(name)
                    self.loginUserLongitudeTo = String(surname)
                    
                }
                
                // address
                if let address = UserDefaults.standard.string(forKey: "key_map_view_address") {
                    print(address)
                    
                    //                    let indexPath = IndexPath.init(row: 0, section: 0)
                    //                    let cell = self.tbleView.cellForRow(at: indexPath) as! dashboard_table_cell
                    
                    self.lbl_my_full_address.text = String(address)
                    self.loginUserAddressTo = String(address)
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
                    
                    self.loginUserLatitudeFrom = String(name)
                    self.loginUserLongitudeFrom = String(surname)
                    
                }
                
                // address
                if let address = UserDefaults.standard.string(forKey: "key_map_view_address") {
                    print(address)
                    
                    //                    let indexPath = IndexPath.init(row: 0, section: 0)
                    //                    let cell = self.tbleView.cellForRow(at: indexPath) as! dashboard_table_cell
                    
                    self.lbl_select_destination.text = String(address)
                    self.loginUserAddressFrom = String(address)
                }
            }
        }
        
        UserDefaults.standard.set("", forKey: "key_map_view_lat_long")
        UserDefaults.standard.set(nil, forKey: "key_map_view_lat_long")
        
        UserDefaults.standard.set("", forKey: "key_map_view_address")
        UserDefaults.standard.set(nil, forKey: "key_map_view_address")
        
        UserDefaults.standard.set("", forKey: "keyUserSelectWhichProfile")
        UserDefaults.standard.set(nil, forKey: "keyUserSelectWhichProfile")
        
        
        if (self.loginUserLatitudeTo != nil && self.loginUserLatitudeFrom != nil) {
            self.checkCarCategoriesWB(str_show_loader: "yes")
        }
        
    }
    
    @objc func checkCarCategoriesWB(str_show_loader:String) {
        
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
                
                // loginUserLatitudeTo = "\(userLatitude!)"
                // loginUserLongitudeTo = "\(userLongitude!)"
                
                var parameters:Dictionary<AnyHashable, Any>!
                parameters = [
                    "action"        : "category",
                    "TYPE"        : String("CAR"),
                    
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
                            
                            self.arrCarCategories.removeAllObjects()
                            var ar : NSArray!
                            ar = (JSON["data"] as! Array<Any>) as NSArray
                            self.arrCarCategories.addObjects(from: ar as! [Any])
                            
                            ERProgressHud.sharedInstance.hide()
                            
                            self.tbleView.isHidden = false
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
            } else {
                print("no token found")
                self.login_refresh_token_wb()
            }
        } else {
            print("something went very wrong")
            ERProgressHud.sharedInstance.hide()
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "get_started_id")
            self.navigationController?.pushViewController(push, animated: true)
        }
    }
    
    @objc func findDriversWB(str_show_loader:String) {
        
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
                
                // loginUserLatitudeTo = "\(userLatitude!)"
                // loginUserLongitudeTo = "\(userLongitude!)"
                
                var parameters:Dictionary<AnyHashable, Any>!
                parameters = [
                    "action"        : "finddriver",
                    "userId"        : String(myString),
                    "latitude"      : "\(self.userLatitude!)",
                    "longitude"     : "\(self.userLongitude!)",
                    "language"      : String("en"),
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
                            self.arrCarCategories.addObjects(from: ar as! [Any])
                            
                            ERProgressHud.sharedInstance.hide()
                            
                            /*self.tbleView.isHidden = false
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
            } else {
                print("no token found")
                self.login_refresh_token_wb()
            }
        } else {
            print("something went very wrong")
            ERProgressHud.sharedInstance.hide()
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "get_started_id")
            self.navigationController?.pushViewController(push, animated: true)
        }
    }
    
    
    
    @objc func getUsersCurrentLatLong() {
        //        // Request location authorization
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // Check if location services are enabled
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
            // Handle the case where location services are not enabled
            print("Location services are not enabled")
        }
        // locationManager.delegate = self
        
        // Request location authorization
        // locationManager.requestWhenInUseAuthorization()
        // locationManager.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            
            userLatitude = location.coordinate.latitude
            userLongitude = location.coordinate.longitude
            
            loginUserLatitudeTo = "\(userLatitude!)"
            loginUserLongitudeTo = "\(userLongitude!)"
            
            // get user's latitude and longitude
            print("Latitude: \(userLatitude ?? 0.0), Longitude: \(userLongitude ?? 0.0)")
            
            // get user's full address
            getAddressFromLocation(location)
            
            // Stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            findDriversWB(str_show_loader: "yes")
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            // Handle the case where user denied or restricted location access
            print("Location access denied or restricted")
        default:
            break
        }
    }
    
    // Handle location errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
    
    // Reverse geocoding to get address from coordinates
    private func getAddressFromLocation(_ location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Failed to reverse geocode location: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                var addressString = ""
                
                if let name = placemark.name {
                    addressString += name + ", "
                }
                if let locality = placemark.locality {
                    addressString += locality + ", "
                }
                if let administrativeArea = placemark.administrativeArea {
                    addressString += administrativeArea + ", "
                }
                if let country = placemark.country {
                    addressString += country
                }
                
                self.userAddress = addressString
                print("User's Address: \(addressString)")
                
                self.call(addressString: "\(addressString)")
            }
        }
    }
    
    @objc func call(addressString:String){
        //        let indexPath = IndexPath.init(row: 0, section: 0)
        //        let cell = self.tbleView.cellForRow(at: indexPath) as! dashboard_table_cell
        //
        self.lbl_my_full_address.text = "\(addressString)"
        self.loginUserAddressTo = "\(addressString)"
        
        self.update_token_WB(str_show_loader: "yes")
    }
    
    var _lastContentOffset: CGPoint!
    var panGesture : UIPanGestureRecognizer!
    var strIndex:Int! = 0
    
    @objc func please_select_atleast_one_vehicle2() {
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tbleView.cellForRow(at: indexPath) as! dashboard_table_cell
        
        UserDefaults.standard.set("userLocationFrom", forKey: "keyUserSelectWhichProfile")
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "search_location_id") as? search_location
        push!.userSelectedIs = "2"
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func please_select_atleast_one_vehicle() {
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tbleView.cellForRow(at: indexPath) as! dashboard_table_cell
        
        UserDefaults.standard.set("userLocationTo", forKey: "keyUserSelectWhichProfile")
        
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "search_location_id") as? search_location
        push!.userSelectedIs = "1"
        self.navigationController?.pushViewController(push!, animated: true)
        
        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "select_vehicle_id") as? select_vehicle
         push!.userCurrentLocationIs = cell.lbl_my_full_address.text
         self.navigationController?.pushViewController(push!, animated: true)*/
        
        //        if (self.str_vehicle_type == "0") {
        //
        //            debugPrint("PLEASE SELECT VEHICLE TYPE")
        //
        //        } else if (self.str_select_option == "0") {
        //
        //            debugPrint("PLEASE SELECT OPTIONS")
        //
        //        } else {
        //
        //        }
        
        
        /*if (self.str_vehicle_type == "0") {
         /*let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please select one vehicle type."), style: .alert)
          let cancel = NewYorkButton(title: "dismiss", style: .cancel)
          alert.addButtons([cancel])
          self.present(alert, animated: true)*/
         if let language = UserDefaults.standard.string(forKey: str_language_convert) {
         print(language as Any)
         
         if (language == "en") {
         let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please select one vehicle type."), style: .alert)
         let cancel = NewYorkButton(title: "dismiss", style: .cancel)
         alert.addButtons([cancel])
         self.present(alert, animated: true)
         } else {
         let alert = NewYorkAlertController(title: String("সতর্কতা").uppercased(), message: String("একটি গাড়ির ধরন নির্বাচন করুন."), style: .alert)
         let cancel = NewYorkButton(title: "dismiss", style: .cancel)
         alert.addButtons([cancel])
         self.present(alert, animated: true)
         
         
         }
         
         }
         } else {
         if (self.str_select_option == "0") {
         
         if let language = UserDefaults.standard.string(forKey: str_language_convert) {
         print(language as Any)
         
         if (language == "en") {
         let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please select an option ( Book a ride now or Schedulae a ride )."), style: .alert)
         let cancel = NewYorkButton(title: "dismiss", style: .cancel)
         alert.addButtons([cancel])
         self.present(alert, animated: true)
         } else {
         let alert = NewYorkAlertController(title: String("সতর্কতা").uppercased(), message: String("অনুগ্রহ করে একটি বিকল্প নির্বাচন করুন (এখন একটি রাইড বুক করুন বা একটি যাত্রার সময়সূচী করুন)।"), style: .alert)
         let cancel = NewYorkButton(title: "বরখাস্ত করা", style: .cancel)
         alert.addButtons([cancel])
         self.present(alert, animated: true)
         
         
         }
         
         }
         
         } else {
         // push to next screen
         
         if (self.str_vehicle_type == "CAR") {
         let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "map_view_id") as? map_view
         push!.str_user_select_vehicle = "CAR"
         push!.str_user_option = self.str_select_option
         
         push!.str_get_user_current_full_address = cell.lbl_my_full_address.text
         
         push!.str_get_login_user_lat = String(self.strSaveLatitude)
         push!.str_get_login_user_long = String(self.strSaveLongitude)
         
         self.navigationController?.pushViewController(push!, animated: true)
         } else if (self.str_vehicle_type == "INTERCITY") {
         let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "map_view_id") as? map_view
         push!.str_user_select_vehicle = "CAR"
         push!.str_user_option = self.str_select_option
         
         push!.str_get_user_current_full_address = cell.lbl_my_full_address.text
         
         push!.str_get_login_user_lat = String(self.strSaveLatitude)
         push!.str_get_login_user_long = String(self.strSaveLongitude)
         
         self.navigationController?.pushViewController(push!, animated: true)
         } else {
         let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "map_view_id") as? map_view
         push!.str_user_select_vehicle = self.str_vehicle_type
         push!.str_user_option = self.str_select_option
         
         push!.str_get_user_current_full_address = cell.lbl_my_full_address.text
         
         push!.str_get_login_user_lat = String(self.strSaveLatitude)
         push!.str_get_login_user_long = String(self.strSaveLongitude)
         
         self.navigationController?.pushViewController(push!, animated: true)
         }
         
         
         }
         }*/
        
        /*let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please select one vehicle type."), style: .alert)
         let cancel = NewYorkButton(title: "dismiss", style: .cancel)
         alert.addButtons([cancel])
         self.present(alert, animated: true)*/
        
    }
    @objc func push_to_car_map_click_method() {
        
        self.str_vehicle_type = "CAR"
        self.tbleView.reloadData()
        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "map_view_id") as? map_view
         push!.str_user_select_vehicle = "CAR"
         self.navigationController?.pushViewController(push!, animated: true)*/
        
    }
    
    @objc func push_to_bike_map_click_method() {
        
        self.str_vehicle_type = "BIKE"
        self.tbleView.reloadData()
        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "map_view_id") as? map_view
         push!.str_user_select_vehicle = "BIKE"
         self.navigationController?.pushViewController(push!, animated: true)*/
        
    }
    
    @objc func push_to_intercity_map_click_method() {
        
        
        
        self.str_vehicle_type = "INTERCITY"
        self.tbleView.reloadData()
        
        
        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "map_view_id") as? map_view
         push!.str_user_select_vehicle = "INTERCITY"
         self.navigationController?.pushViewController(push!, animated: true)*/
        
    }
    
    @objc func schedule_a_ride_click_method() {
        if (self.str_vehicle_type == "0") {
            debugPrint("Please select car type")
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please select car type"), style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            
        } else {
            self.str_select_option = "schedule"
            // self.tbleView.reloadData()
            
            debugPrint(self.str_vehicle_type as Any)
            debugPrint(self.str_select_option as Any)
            debugPrint(self.loginUserLatitudeFrom as Any)
            
            
            
        }
        
        
        // let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "schedule_a_ride_id") as? schedule_a_ride
        // self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func book_a_ride_click_method() {
        
        if (self.loginUserLatitudeFrom == "" || self.loginUserLatitudeFrom == nil) {
            
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please select destination"), style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            
        } else if (self.str_vehicle_type == "0") {
            
            debugPrint("Please select car type")
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please select car type"), style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            
        } else {
            self.str_select_option = "book"
            // self.tbleView.reloadData()
            
            debugPrint(self.str_vehicle_type as Any)
            debugPrint(self.str_select_option as Any)
            debugPrint(self.loginUserLatitudeFrom as Any)
            
            self.pushAfterEverything(vehicleType: String(self.str_vehicle_type),
                                     vehicleOption: String(self.str_select_option))
            
        }
        
    }
    
    @objc func pushAfterEverything(vehicleType:String,
                                   vehicleOption:String) {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "map_view_id") as? map_view
        
        debugPrint(vehicleType as Any)
        
        push!.str_user_select_vehicle = String(vehicleType)
        //"CAR"
        
        push!.str_user_option = String(vehicleOption)
        // self.str_select_option
        // debugPrint(vehicleOption as Any)
        push!.str_get_user_current_full_address = String(self.loginUserAddressTo)
        // cell.lbl_my_full_address.text
        
        push!.str_get_login_user_lat = String(loginUserLatitudeTo)
        push!.str_get_login_user_long = String(loginUserLongitudeTo)
        
        //
        push!.getLoginUserAddressTo = String(loginUserAddressTo)
        push!.getLoginUserLatitudeTo = String(loginUserLatitudeTo)
        push!.getLoginUserLongitudeTo = String(loginUserLongitudeTo)
        
        push!.getLoginUserAddressFrom = String(loginUserAddressFrom)
        push!.getLoginUserLatitudeFrom = self.loginUserLatitudeFrom
        push!.getLoginUserLongitudeFrom = self.loginUserLongitudeFrom
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(push!, animated: true)
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
    /*func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
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
     
     
     
     
     
     
     
     print("local address ==> "+localAddress as Any) // south west delhi
     print("local address mini ==> "+localAddressMini as Any) // new delhi
     print("locality ==> "+locality as Any) // sector 10 dwarka
     
     print(self.strSaveCountryName as Any) // india
     print(self.strSaveStateName as Any) // new delhi
     print(self.strSaveZipcodeName as Any) // 110075
     
     //MARK:- STOP LOCATION -
     self.locationManager.stopUpdatingLocation()
     
     let indexPath = IndexPath.init(row: 0, section: 0)
     let cell = self.tbleView.cellForRow(at: indexPath) as! dashboard_table_cell
     
     let str_locality = String(self.strSaveLocality)
     let str_local_address = String(self.strSaveLocalAddress)
     let str_local_state = String(self.strSaveStateName)
     let str_local_country = String(self.strSaveCountryName)
     let str_local_zipcode = String(self.strSaveZipcodeName)
     
     cell.lbl_my_full_address.text = String(self.strSaveLocality)+", "+String(self.strSaveLocalAddress)+" "+String(self.strSaveStateName)+", "+String(self.strSaveCountryName)+" - "+String(self.strSaveZipcodeName)
     
     self.loginUserLatitudeTo = String(doubleStringLat)
     self.loginUserLongitudeTo = String(doubleStringLong)
     self.loginUserAddressTo = String(self.strSaveLocality)+", "+String(self.strSaveLocalAddress)+" "+String(self.strSaveStateName)+", "+String(self.strSaveCountryName)+" - "+String(self.strSaveZipcodeName)
     
     
     
     
     
     
     
     UserDefaults.standard.set(self.strSaveLatitude, forKey: "key_current_latitude")
     UserDefaults.standard.set(self.strSaveLongitude, forKey: "key_current_latitude")
     UserDefaults.standard.set(locality+","+localAddress+","+localAddressMini, forKey: "key_current_address")
     
     /*print(self.strSaveLocality as Any)
      print(self.strSaveLocalAddress as Any)
      print(self.strSaveLocalAddressMini as Any)
      print(self.strSaveStateName as Any)
      print(self.strSaveCountryName as Any)*/
     
     self.update_token_WB(str_show_loader: "yes")
     
     }
     }*/
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        _lastContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // var str_count = "0"
        
        if _lastContentOffset.y < scrollView.contentOffset.y {
            NSLog("Scrolled Down")
            // str_count = "1"
        }
        
        else if _lastContentOffset.y > scrollView.contentOffset.y {
            NSLog("Scrolled Up")
            
            // str_count = "1"
        } else {
            
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            print(pageNumber)
            
            self.strIndex = Int(pageNumber)
            self.tbleView.reloadData()
        }
        
    }
    
    @objc func update_token_WB(str_show_loader:String) {
        
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
                
                // loginUserLatitudeTo = "\(userLatitude!)"
                // loginUserLongitudeTo = "\(userLongitude!)"
                
                var parameters:Dictionary<AnyHashable, Any>!
                parameters = [
                    "action"        : "editprofile",
                    "userId"        : String(myString),
                    "deviceToken"   : String(self.str_token_id),
                    // "latitude"      : "28.663360225298394", // String(self.strSaveLatitude),
                    // "longitude"     : "77.32386478305855", // String(self.strSaveLongitude),
                    "latitude"      : String(self.loginUserLatitudeTo),
                    "longitude"     : String(self.loginUserLongitudeTo),
                    "device"        : String("iOS")
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
                            
                            let defaults = UserDefaults.standard
                            defaults.setValue(JSON["data"], forKey: str_save_login_user_data)
                            
                            let str_token = (JSON["AuthToken"] as! String)
                            UserDefaults.standard.set("", forKey: str_save_last_api_token)
                            UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                            
                            self.show_banner_WB()
                            
                            /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ride_status_id") as? ride_status
                             self.navigationController?.pushViewController(push!, animated: true)*/
                            
                            
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
            } else {
                print("no token found")
                self.login_refresh_token_wb()
            }
        } else {
            print("something went very wrong")
            ERProgressHud.sharedInstance.hide()
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "get_started_id")
            self.navigationController?.pushViewController(push, animated: true)
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
                            
                            self.update_token_WB(str_show_loader: "no")
                            
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
    
    @objc func show_banner_WB() {
        
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
                    "action"    : "couponlist",
                    "language"  :String(self.str_selected_language_is)
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
                            
                            var ar : NSArray!
                            ar = (JSON["data"] as! Array<Any>) as NSArray
                            self.arr_banner.addObjects(from: ar as! [Any])
                            
                            self.tbleView.reloadData()
                            
                            ERProgressHud.sharedInstance.hide()
                            self.dismiss(animated: true)
                            
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
    
    
    
    var token:String = "cIu4OcOD8E3Fhk-Z4Aj8XH:APA91bHI5xX0Vzzdvu-TN2vZjrUCgTLMSy-L4l-SR7WUHZrV0CRYCCMYMBfi_2hm1j73Pp_jZeYD0hligeVI8SksVOOj-fc5ZlhvDYqIdP0l9-CyNiCgqEdpHk4r0KTACFaiMtJt--X-"
    var serverKey:String = "AAAArtixum0:APA91bHUusFW81-wCd6C7YUgzTHY9zi-XpqHw_YVyRukf5yNTNpdMe8NXuAk5TnStvbz6_Z-VpOdPs4-nCvxYZ2ejPf6yoLq1Dvk0ZwlBM2HSGD1xY3xdm_MIZrYd6wQbsueAqWlnAiV"
    
    @objc func dummy_notification() {
        print("CUSTOM NOTIFICATION TOKEN")
        let token = token
        print(token as Any)
        
        let serverKey = serverKey
        
        let partnerToken = token
        
        let url = NSURL(string: "https://fcm.googleapis.com/fcm/send")
        
        let postParams = [
            "to": partnerToken,
            "content-available" : 1,
            "notification": [
                "body": "New request from XYZ",
                "title": "Zarib Driver",
                "sound" : "default"
                
                // "custom_notification.mp3",
                
            ],
            /*"data":[
             "message"               : "Incoming Audio Call",
             "type"                  : "audiocall",
             ]*/
            
        ] as [String : Any]
        
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postParams, options: JSONSerialization.WritingOptions())
            print("My paramaters: \(postParams)")
            
            
        } catch {
            print("Caught an error: \(error)")
        }
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if let realResponse = response as? HTTPURLResponse {
                if realResponse.statusCode != 200 {
                    print("Not a 200 response")
                }
            }
            
            if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String? {
                print("POST: \(postString)")
                DispatchQueue.main.async {
                    
                    
                }
            }
        }
        
        task.resume()
    }
    
    func getDistanceInMiles(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let location1 = CLLocation(latitude: lat1, longitude: lon1)
        let location2 = CLLocation(latitude: lat2, longitude: lon2)
        
        // Distance in meters
        let distanceInMeters = location1.distance(from: location2)
        
        // Convert meters to miles (1 mile = 1609.34 meters)
        let distanceInMiles = distanceInMeters / 1609.34
        
        return distanceInMiles
    }
    
}


extension dashboard: UITableViewDataSource  , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCarCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:dashboard_table_cell = tableView.dequeueReusableCell(withIdentifier: "dashboard_table_cell") as! dashboard_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        let item = self.arrCarCategories[indexPath.row] as? [String:Any]
        cell.lblName.text = (item!["name"] as! String)
        cell.lblName.textColor = .black
        
        
        let lat1 = Double(self.loginUserLatitudeTo!)
        let lon1 = Double(self.loginUserLongitudeTo!)

        let lat2 = Double(self.loginUserLatitudeFrom!)
        let lon2 = Double(self.loginUserLongitudeFrom!)

        let distance = getDistanceInMiles(lat1: lat1!, lon1: lon1!, lat2: lat2!, lon2: lon2!)
       
        let multiplePriceWithDistance = Double(distance) * Double("\(item!["perMile"]!)")!
        let myString = String(format: "%.2f", multiplePriceWithDistance)
        cell.lblPrice.text = "$\(myString)"
        cell.lblPrice.textColor = .black
        
        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        cell.imgProfile.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "logo"))
         
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.arrCarCategories[indexPath.row] as? [String:Any]
        self.strUserSelectCarCategory = "\(item!["id"]!)"
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}


//MARK:- COLLECTION VIEW -
/*extension dashboard: UICollectionViewDelegate ,
                     UICollectionViewDataSource ,
                     UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arr_banner.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dashboard_collection_view_cell", for: indexPath as IndexPath) as! dashboard_collection_view_cell

        cell.backgroundColor  = .clear
        
        let item = self.arr_banner[indexPath.row] as? [String:Any]
        
        cell.backgroundColor = .clear
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = true
        
        cell.lbl_type.text = (item!["couponCode"] as! String)
        cell.lbl_off.text = "\(item!["discount"]!)% off"
        cell.lbl_off.textAlignment = .center
        cell.lbl_off.backgroundColor = .systemGreen
        cell.lbl_off.layer.cornerRadius = 6
        cell.lbl_off.clipsToBounds = true
        
        cell.lbl_off_right_text.text = (item!["couponCode"] as! String)
        cell.lbl_description.text = (item!["description"] as! String)
        cell.lbl_expired.text = "Expire : "+(item!["endDate"] as! String)
        
        cell.lbl_type.textColor = .white
        cell.lbl_off.textColor = .white
        cell.lbl_off_right_text.textColor = .white
        cell.lbl_description.textColor = .blue
        cell.lbl_expired.textColor = .white
        
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var sizes: CGSize
        let result = UIScreen.main.bounds.size
        NSLog("%f",result.height)
        sizes = CGSize(width: collectionView.frame.size.width-20, height: 136)
        
        return sizes
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}*/

/*class dashboard_collection_view_cell: UICollectionViewCell , UITextFieldDelegate {
    
    @IBOutlet weak var view_bg:UIView! {
        didSet {
            view_bg.layer.cornerRadius = 12
            view_bg.clipsToBounds = true
            // view_bg.backgroundColor = UIColor.init(red: 86.0/255.0, green: 86.0/255.0, blue: 86.0/255.0, alpha: 1)
            
            /*view_bg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
             view_bg.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
             view_bg.layer.shadowOpacity = 1.0
             view_bg.layer.shadowRadius = 15.0
             view_bg.layer.masksToBounds = false*/
        }
    }
    
    @IBOutlet weak var img_view:UIImageView! {
        didSet {
            img_view.layer.cornerRadius = 12
            img_view.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lbl_type:UILabel!
    @IBOutlet weak var lbl_off:UILabel!
    @IBOutlet weak var lbl_off_right_text:UILabel!
    @IBOutlet weak var lbl_description:UILabel!
    @IBOutlet weak var lbl_expired:UILabel!
    
}*/

class dashboard_table_cell: UITableViewCell {
    
    @IBOutlet weak var viewBG:UIView! {
        didSet {
            viewBG.backgroundColor = .white
            viewBG.layer.cornerRadius = 12
            viewBG.clipsToBounds = true
            
            viewBG.layer.shadowColor = UIColor.black.cgColor
            viewBG.layer.shadowOpacity = 0.5
            viewBG.layer.shadowOffset = CGSize(width: 2, height: 2)
            viewBG.layer.shadowRadius = 4
            viewBG.layer.masksToBounds = false

        }
    }
    @IBOutlet weak var imgProfile:UIImageView!
    
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
