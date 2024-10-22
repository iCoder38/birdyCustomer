//
//  UPDOHome.swift
//  GoFourService
//
//  Created by Dishant Rajput on
//

import UIKit
import CoreLocation
import MapKit
import Alamofire
import SDWebImage

// MARK:- LOCATION -
import CoreLocation
import CryptoKit
// import JWTDecode

import GoogleMaps

struct Location {

    let title: String
    let latitude: Double
    let longitude: Double
}

class map_view: UIViewController , UITextFieldDelegate, CLLocationManagerDelegate , MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    var str_which_textfield = "0"
    var db:DBHelper = DBHelper()
    var persons:[Person] = []
    
    var str_get_user_current_full_address:String!
    var str_get_login_user_lat:String!
    var str_get_login_user_long:String!
    
    var str_user_select_vehicle:String!
    var str_user_option:String!
    
    var arr_mut_list_of_category:NSMutableArray! = []
    
    let locationManager = CLLocationManager()
    
    // MARK:- SAVE LOCATION STRING -
    var strSaveLatitude:String! = "0.0"
    var strSaveLongitude:String! = "0.0"
    var strSaveCountryName:String!
    var strSaveLocalAddress:String!
    var strSaveLocality:String!
    var strSaveLocalAddressMini:String!
    var strSaveStateName:String!
    var strSaveZipcodeName:String!
    
    // apple maps
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var countryName:String!
    var stateAndCountry:String!
    var fullAddress:String!
    
    var searchLat:String!
    var searchLong:String!
    
    var str_category_id:String! = "0"
    
    var ar : NSArray!
    var arr_list_of_all_Drivers : NSArray!
    
    var arr_all_locations_pin:NSMutableArray! = []
    
    // click on map
    let newPin = MKPointAnnotation()
    var str_count:String! = "1"
    var set_new_lat:Double!
    var set_new_long:Double!
    
    var str_selected_language_is:String!
    
    var drop_lat:String!
    var drop_long:String!
    
    var pick_lat:String!
    var pick_long:String!
    
    var str_bike_cat_id:String!
    
    // NEW
    var getLoginUserLatitudeTo:String!
    var getLoginUserLongitudeTo:String!
    var getLoginUserAddressTo:String!
    var getLoginUserLatitudeFrom:String!
    var getLoginUserLongitudeFrom:String!
    var getLoginUserAddressFrom:String!
    
    
    @IBOutlet weak var btn_push_to_map:UIButton!
    @IBOutlet weak var btn_push_to_map_down:UIButton!
    
    @IBOutlet weak var txtFieldUp:UITextField!
    @IBOutlet weak var txtFieldDown:UITextField!
    
    // google maps
    var mapView: GMSMapView!
    
    var doublePlaceStartLat:Double!
    var doublePlaceStartLong:Double!
    
    var doublePlaceFinalLat:Double!
    var doublePlaceFinalLong:Double!
    
    
    @IBOutlet weak var btnLocationPointOne:UIButton!
    @IBOutlet weak var btnLocationPointTwo:UIButton!
    
    
    @IBOutlet weak var view_set_name:UIView! {
        didSet {
            view_set_name.backgroundColor = .white
            view_set_name.layer.masksToBounds = false
            view_set_name.layer.shadowColor = UIColor.black.cgColor
            view_set_name.layer.shadowOffset =  CGSize.zero
            view_set_name.layer.shadowOpacity = 0.5
            view_set_name.layer.shadowRadius = 2
            view_set_name.layer.cornerRadius = 2
        }
    }
    
    @IBOutlet weak var search_text_field:UISearchTextField! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    search_text_field.placeholder = "Select drop address"
                } else {
                    search_text_field.placeholder = "গন্তব্য নির্বাচন করুন"
                }
                
            }
            
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
                    view_navigation_title.text = "Select vehicle"
                } else {
                    view_navigation_title.text = "অনুসন্ধান করুন"
                }
                
            }
            
            view_navigation_title.textColor = .white
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var search_place_pickup:UISearchBar! {
        didSet {
            search_place_pickup.tag = 0
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    search_place_pickup.placeholder = "Select pickup address"
                } else {
                    search_place_pickup.placeholder = "পিক-আপ স্থান নির্বাচন করুন"
                }
                
            }
            
        }
    }
    
    @IBOutlet weak var search_place_drop:UISearchBar!  {
        didSet {
            search_place_drop.tag = 1
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    search_place_drop.placeholder = "Select drop address"
                } else {
                    search_place_drop.placeholder = "গন্তব্য নির্বাচন করুন"
                }
                
            }
        }
    }
    
    @IBOutlet weak var searchResultsTableView: UITableView! {
        didSet {
            searchResultsTableView.delegate = self
            searchResultsTableView.dataSource = self
        }
    }
    
    // @IBOutlet weak var mapView:MKMapView!
    
    // ***************************************************************** // nav
    
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
            lblNavigationTitle.text = ORDER_FOOD_PAGE_NAVIGATION_TITLE
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var collectionView:UICollectionView! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var map:MKMapView!
    
    @IBOutlet weak var lbl_location_from:UILabel! {
        didSet {
            //            txt_location_from.delegate = self
            /*txt_location_from.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
             txt_location_from.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
             txt_location_from.layer.shadowOpacity = 1.0
             txt_location_from.layer.shadowRadius = 15.0
             txt_location_from.layer.masksToBounds = false
             txt_location_from.layer.cornerRadius = 15
             txt_location_from.backgroundColor = .white*/
        }
    }
    
    @IBOutlet weak var btn_search:UIButton! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var txt_location_to:UITextField! {
        didSet {
            txt_location_to.delegate = self
            /*txt_location_to.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
             txt_location_to.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
             txt_location_to.layer.shadowOpacity = 1.0
             txt_location_to.layer.shadowRadius = 15.0
             txt_location_to.layer.masksToBounds = false
             txt_location_to.layer.cornerRadius = 15
             txt_location_to.backgroundColor = .white*/
        }
    }
    
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
    
    @IBOutlet weak var btnStarting:UIButton!{
        didSet{
            btnStarting.setTitle("", for: .normal)
        }
    }
    @IBOutlet weak var btnEnding:UIButton!{
        didSet{
            btnEnding.setTitle("", for: .normal)
        }
    }
    
    @IBOutlet weak var btnRideNow:UIButton!{
        didSet{
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btnRideNow.setTitle("Continue to Book", for: .normal)
                } else {
                    btnRideNow.setTitle("বুকিং চালিয়ে যান", for: .normal)
                }
                
            }
            
            
            btnRideNow.backgroundColor = .systemGreen
        }
    }
    
    @IBOutlet weak var btn_get_current_location:UIButton! {
        didSet {
            
        }
    }
    
    var counter = 2
    var timer:Timer!
    
    var  set_lat:String!
    var  set_long:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let kUserDefault = UserDefaults.standard
        kUserDefault.set(["1","2"], forKey: "nameArray")
        kUserDefault.synchronize()
        
        
        self.collectionView.isHidden = true
        // self.mapView.isHidden = true
        self.btnRideNow.isHidden = true
        
        // print(persons[0].name)
        // print(persons[1].name)
        
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        if (self.str_user_option == "schedule") {
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    self.btnRideNow.setTitle("Continue to Book", for: .normal)
                    self.btn_search.setTitle("recent", for: .normal)
                    self.str_selected_language_is = "en"
                } else {
                    self.btnRideNow.setTitle("বুকিং চালিয়ে যান", for: .normal)
                    self.btn_search.setTitle("বর্তমান", for: .normal)
                    self.str_selected_language_is = "bn"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                self.str_selected_language_is = "en"
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        } else {
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    self.btnRideNow.setTitle("Ride now", for: .normal)
                    // self.btn_search.setTitle("recent", for: .normal)
                    self.str_selected_language_is = "en"
                } else {
                    self.btnRideNow.setTitle("এখনই রাইড নিন", for: .normal)
                    // self.btn_search.setTitle("বর্তমান", for: .normal)
                    self.str_selected_language_is = "bn"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                self.str_selected_language_is = "en"
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
        }
        
        self.btnRideNow.addTarget(self, action: #selector(ride_now_click_method), for: .touchUpInside)
        // self.btn_search.addTarget(self, action: #selector(search_click_method), for: .touchUpInside)
        
        self.btnLocationPointOne.addTarget(self, action: #selector(locationOneClickMethod), for: .touchUpInside)
        self.btnLocationPointTwo.addTarget(self, action: #selector(locationTwoClickMethod), for: .touchUpInside)
        
        self.btn_push_to_map.addTarget(self, action: #selector(please_select_atleast_one_vehicle), for: .touchUpInside)
        self.btn_push_to_map_down.addTarget(self, action: #selector(please_select_atleast_one_vehicle2), for: .touchUpInside)
        
        self.handleEveythingFromGoogleMapInit()
        
        
        
        
        
        // self.strSaveLatitude = String(str_get_login_user_lat)
        // self.strSaveLongitude = String(str_get_login_user_long)
        
        
        
        // apple maps
        // self.mapView.delegate = self
        // self.searchCompleter.delegate = self
        // self.searchResultsTableView.isHidden = true
        
        // self.annotationsOnMap()
        
        // self.stateAndCountry = "0"
        // self.fullAddress = "0"
        
        // self.searchLat = "0"
        // self.searchLong = "0"
        
        // self.lbl_location_from.text = String(self.str_get_user_current_full_address)
        // self.search_place_pickup.text = String(self.str_get_user_current_full_address)
        
        /*
         push!.str_get_login_user_lat = String(self.strSaveLatitude)
         push!.str_get_login_user_long = String(self.strSaveLongitude)
         
         var drop_lat:String!
         var drop_long:String!
         
         var pick_lat:String!
         var pick_long:String!
         */
        
        /*print(self.str_get_login_user_lat as Any)
         print(self.str_get_login_user_long as Any)
         print(self.str_user_select_vehicle as Any)
         */
        
        // self.current_location_click_method()
        
        // self.show_loading_UI()
        // self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        /*let lpgr = UITapGestureRecognizer(target: self, action: #selector(handleLongPress(gestureReconizer:)))
         // lpgr.minimumPressDuration = 0.5
         lpgr.delaysTouchesBegan = true
         lpgr.delegate = self
         self.mapView.addGestureRecognizer(lpgr)*/
        
        if (self.str_user_select_vehicle == "BIKE") {
            list_of_all_category_WB()
        }
        
        self.txtFieldUp.text = String(getLoginUserAddressTo)
        self.txtFieldDown.text = String(getLoginUserAddressFrom)
    }
    
    @objc func locationOneClickMethod() {
        UserDefaults.standard.set("userLocationTo", forKey: "keyUserSelectWhichProfile")
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "select_location_via_name_id") as? select_location_via_name
        push!.userSelectOriginOrDestination = "origin"
        push!.selectedVehicleType = String(self.str_user_select_vehicle)
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func locationTwoClickMethod() {
        UserDefaults.standard.set("userLocationFrom", forKey: "keyUserSelectWhichProfile")
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "select_location_via_name_id") as? select_location_via_name
        push!.userSelectOriginOrDestination = "destination"
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
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
                    
                    self.txtFieldUp.text = String(address)
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
                    
                    self.txtFieldDown.text = String(address)
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
        
        self.initializeMap()
    }
    
    func initializeMap() {
        
        self.doublePlaceStartLat = Double(self.getLoginUserLatitudeTo)
        self.doublePlaceStartLong = Double(self.getLoginUserLongitudeTo)
        
        self.doublePlaceFinalLat = Double(self.getLoginUserLatitudeFrom)
        self.doublePlaceFinalLong = Double(self.getLoginUserLongitudeFrom)
        
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
        view.bringSubviewToFront(view_navigation_bar)
        view.bringSubviewToFront(view_set_name)
        
        let placeACoordinate = CLLocationCoordinate2D(latitude: doublePlaceStartLat!, longitude: doublePlaceStartLong!)
        let placeBCoordinate = CLLocationCoordinate2D(latitude: doublePlaceFinalLat!, longitude: doublePlaceFinalLong!)
        
        
        
        addMarker(at: placeACoordinate, title: "Origin", snippet: String(self.getLoginUserAddressTo), color: .green)
        addMarker(at: placeBCoordinate, title: "Destination", snippet: String(self.getLoginUserAddressFrom), color: .yellow)
        
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
        let update = GMSCameraUpdate.fit(bounds, withPadding: 100.0) // Adjust padding as needed
        mapView.animate(with: update)
        
        
        self.list_by_car_WB(str_show_loader: "yes")
        
    }
    
    
    
    
    
    
    
    
    @objc func please_select_atleast_one_vehicle2() {
        
        UserDefaults.standard.set("userLocationFrom", forKey: "keyUserSelectWhichProfile")
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "search_location_id") as? search_location
        push!.userSelectedIs = "2"
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func please_select_atleast_one_vehicle() {
        
        UserDefaults.standard.set("userLocationTo", forKey: "keyUserSelectWhichProfile")
        
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "search_location_id") as? search_location
        push!.userSelectedIs = "1"
         
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    
    
    
    @objc func search_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "search_location_id") as? search_location
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    /* @objc func updateCounter() {
     
     if (counter == 2) {
     counter -= 1
     } else if (counter == 1) {
     counter -= 1
     self.list_of_all_category_WB()
     } else if (counter == 0) {
     timer.invalidate()
     }
     
     }*/
    
    /* @objc func handleLongPress(gestureReconizer: UITapGestureRecognizer) {
     if gestureReconizer.state != UIGestureRecognizer.State.ended {
     let touchLocation = gestureReconizer.location(in: self.mapView)
     let locationCoordinate = self.mapView.convert(touchLocation,toCoordinateFrom: self.mapView)
     print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
     return
     }
     if gestureReconizer.state != UIGestureRecognizer.State.began {
     print("begin")
     let touchLocation = gestureReconizer.location(in: self.mapView)
     let locationCoordinate = self.mapView.convert(touchLocation,toCoordinateFrom: self.mapView)
     print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
     //
     self.str_count = "2"
     self.set_new_lat = locationCoordinate.latitude
     self.set_new_long = locationCoordinate.longitude
     
     
     // push!.my_location_lat = String(self.strSaveLatitude)
     // push!.my_location_long = String(self.strSaveLongitude)
     
     UserDefaults.standard.set(String(self.set_new_lat), forKey: "key_save_lat_for_address")
     UserDefaults.standard.set(String(self.set_new_long), forKey: "key_save_long_for_address")
     
     
     // convertLatLongToAddress(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
     return
     }
     }*/
    
    /*override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(true)
     
     /*UserDefaults.standard.set("", forKey: "key_map_view_lat_long")
      UserDefaults.standard.set(nil, forKey: "key_map_view_lat_long")
      
      UserDefaults.standard.set("", forKey: "key_map_view_address")
      UserDefaults.standard.set(nil, forKey: "key_map_view_address")*/
     
     if let load_latitude = UserDefaults.standard.string(forKey: "key_map_view_lat_long") {
     print(load_latitude)
     
     // self.str_save_lat = load_latitude
     let fullName    = load_latitude
     let fullNameArr = fullName.components(separatedBy: ",")
     
     let name    = fullNameArr[0]
     let surname = fullNameArr[1]
     
     set_lat = String(name)
     set_long = String(surname)
     
     self.pick_lat = set_lat
     self.pick_long = set_long
     }
     
     // longitude
     if let address = UserDefaults.standard.string(forKey: "key_map_view_address") {
     print(address)
     self.search_text_field.text = String(address)
     //
     UserDefaults.standard.set("", forKey: "key_map_view_lat_long")
     UserDefaults.standard.set(nil, forKey: "key_map_view_lat_long")
     
     UserDefaults.standard.set("", forKey: "key_map_view_address")
     UserDefaults.standard.set(nil, forKey: "key_map_view_address")
     //
     convertLatLongToAddress(latitude: Double(set_lat!)!, longitude: Double(set_long!)! )
     }
     
     
     }*/
    
    
    
    /*func convertLatLongToAddress(latitude:Double,longitude:Double){
     self.mapView.removeAnnotations(self.mapView.annotations)
     
     let geoCoder = CLGeocoder()
     let location = CLLocation(latitude: latitude, longitude: longitude)
     print(location)
     
     self.searchLat = "\(latitude)"
     self.searchLong = "\(longitude)"
     
     geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
     
     // Place details
     var placeMark: CLPlacemark!
     placeMark = placemarks?[0]
     
     // Location name
     if let locationName = placeMark.location {
     print(locationName)
     }
     // Street address
     if let street = placeMark.thoroughfare {
     print(street)
     }
     // City
     if let city = placeMark.locality {
     print(city)
     }
     // State
     if let state = placeMark.administrativeArea {
     print(state)
     }
     
     var save_sub_locality:String!
     var save_name:String!
     var save_subAdministrativeArea:String!
     var save_zipCode:String!
     
     // Zip code
     if let zipCode = placeMark.postalCode {
     print(zipCode)
     save_zipCode = zipCode
     }
     // Country
     if let country = placeMark.country {
     print(country)
     }
     
     
     // Country
     if let subLocality = placeMark.subLocality {
     print(subLocality)
     save_sub_locality = subLocality
     }
     
     // Country
     if let name = placeMark.name {
     print(name)
     save_name = name
     }
     // Country
     if let subAdministrativeArea = placeMark.subAdministrativeArea {
     print(subAdministrativeArea)
     save_subAdministrativeArea = subAdministrativeArea
     }
     self.lbl_location_from.numberOfLines = 0
     
     if (save_name == nil) {
     save_name = "0"
     } else if (save_sub_locality == nil) {
     save_sub_locality = "0"
     }
     let one = save_name+","+save_sub_locality
     let two = save_subAdministrativeArea+","+save_zipCode
     
     self.stateAndCountry = one
     self.fullAddress = two
     
     self.search_text_field.text = one+","+two
     
     
     self.collectionView.isHidden = true
     self.mapView.isHidden = true
     self.btnRideNow.isHidden = true
     
     if (self.str_user_select_vehicle == "BIKE"){
     print("bike")
     
     print(self.str_get_login_user_lat as Any)
     print(self.str_get_login_user_long as Any)
     print(self.pick_lat as Any)
     print(self.pick_long as Any)
     
     let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "total_fare_distance_mpa_route_id") as? total_fare_distance_mpa_route
     
     push!.str_vehicle_type = String(self.str_user_select_vehicle)
     
     push!.str_get_category_id = String(self.str_bike_cat_id)
     // push!.str_from_location = String(self.lbl_location_from.text!)
     // push!.str_to_location = String(self.stateAndCountry)+" "+String(self.stateAndCountry)
     
     push!.str_from_location = String(self.search_place_pickup.text!)
     push!.str_to_location = String(self.search_place_drop.text!)//+" "+String(self.stateAndCountry)
     
     push!.my_location_lat = String(self.str_get_login_user_lat)
     push!.my_location_long = String(self.str_get_login_user_long)
     
     push!.searched_place_location_lat = String(self.searchLat)
     push!.searched_place_location_long = String(self.searchLong)
     
     self.navigationController?.pushViewController(push!, animated: true)
     } else {
     self.list_by_car_WB(str_show_loader: "yes")
     }
     
     // UserDefaults.standard.set(self.lbl_location_from.text, forKey: "key_save_full_address_for_map_search")
     
     //
     // self.find_driver_WB()
     })
     
     }*/
    
    /*func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     
     mapView.removeAnnotation(newPin)
     
     let location = locations.last! as CLLocation
     
     if (self.str_count == "1") {
     let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
     let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
     mapView.setRegion(region, animated: true)
     newPin.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
     mapView.addAnnotation(newPin)
     } else {
     let center = CLLocationCoordinate2D(latitude: set_new_lat, longitude: set_new_long)
     let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
     mapView.setRegion(region, animated: true)
     newPin.coordinate = CLLocationCoordinate2D(latitude: set_new_lat, longitude: set_new_long)
     mapView.addAnnotation(newPin)
     }
     
     }*/
    
    @objc func current_location_click_method() {
        
        self.iAmHereForLocationPermission()
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
                
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                
            @unknown default:
                break
            }
        }
    }
    
    /// **************************************************************
    /// ************* FIND DRIVERS NEAR MY LOCATION ******************
    /// **************************************************************
    @objc func find_driver_WB() {
        
        self.show_loading_UI()
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                
                let headers: HTTPHeaders = [
                    "token":String(token_id_is),
                ]
                
                var parameters:Dictionary<AnyHashable, Any>!
                
                parameters = [
                    
                    "action"    : "finddriver",
                    "userId"    : String(myString),
                    "latitude"  : String(self.strSaveLatitude),
                    "longitude" : String(self.strSaveLongitude),
                    "language"  : String(self.str_selected_language_is)
                    
                ]
                
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
                                
                                
                                
                                let str_token = (JSON["AuthToken"] as! String)
                                UserDefaults.standard.set("", forKey: str_save_last_api_token)
                                UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                                
                                self.arr_list_of_all_Drivers = (JSON["data"] as! Array<Any>) as NSArray
                                
                                for indexx in 0..<self.arr_list_of_all_Drivers.count {
                                    
                                    let item = self.arr_list_of_all_Drivers[indexx] as? [String:Any]
                                    
                                    let my_current_location = ["title":(item!["fullName"] as! String),
                                                               "id":"\(item!["id"]!)",
                                                               "distance":"\(item!["distance"]!)",
                                                               "fullName":(item!["fullName"] as! String),
                                                               // "latitude":(item!["latitude"] as! String),
                                                               // "longitude":(item!["longitude"] as! String)
                                                               "latitude":"28.4595",
                                                               "longitude":"77.0266"
                                                               
                                    ]
                                    
                                    self.arr_all_locations_pin.add(my_current_location)
                                    
                                }
                                
                                print(self.arr_all_locations_pin as Any)
                                print(self.arr_all_locations_pin.count as Any)
                                
                                // self.annotationsOnMap()
                                
                            }
                            else {
                                self.hide_loading_UI()
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
    
    /// **************************************************************
    /// ************* ALL ANNOTATIONS ON MAP *********************************
    /// **************************************************************
    /*func annotationsOnMap() {
     
     for location in 0..<arr_all_locations_pin.count {
     let item = self.arr_all_locations_pin[location] as? [String:Any]
     
     let annotation = MKPointAnnotation()
     annotation.title = (item!["fullName"] as! String)
     annotation.coordinate = CLLocationCoordinate2D(latitude: Double(item!["latitude"] as! String)! ,
     longitude: Double(item!["longitude"] as! String)!)
     
     self.mapView.addAnnotation(annotation)
     }
     
     
     let my_lat = String(self.strSaveLatitude)
     let my_long = String(self.strSaveLongitude)
     
     let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(my_lat)! ,
     longitude: Double(my_long)!)
     , span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
     self.mapView.setRegion(region, animated: true)
     
     
     self.hide_loading_UI()
     
     }*/
    
    
    func geocodeAddress(_ address: String) {
        let apiKey = GOOGLE_MAP_API
        let geocodeURL = "https://maps.googleapis.com/maps/api/geocode/json?address=\(address)&key=\(apiKey)"
        
        guard let url = URL(string: geocodeURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            print("Invalid URL.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error occurred: \(String(describing: error))")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let addressComponents = results.first?["address_components"] as? [[String: Any]] {
                    
                    print(results as Any)
                    print(addressComponents as Any)
                    
                    var city = ""
                    var country = ""
                    
                    for component in addressComponents {
                        if let types = component["types"] as? [String], types.contains("locality") {
                            city = component["long_name"] as? String ?? ""
                        }
                        if let types = component["types"] as? [String], types.contains("country") {
                            country = component["long_name"] as? String ?? ""
                        }
                    }
                    
                    if city == "Dhaka" && country == "Bangladesh" {
                        print("The place is in Dhaka, Bangladesh.")
                        if (self.str_user_select_vehicle != "INTERCITY") {
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "total_fare_distance_mpa_route_id") as? total_fare_distance_mpa_route
                            
                            debugPrint(self.str_user_select_vehicle as Any)
                            
                            push!.str_vehicle_type = String(self.str_user_select_vehicle)
                            
                            push!.str_get_category_id = String(self.str_category_id)
                            // push!.str_from_location = String(self.lbl_location_from.text!)
                            // push!.str_to_location = String(self.stateAndCountry)+" "+String(self.stateAndCountry)
                            
                            push!.str_from_location = String(self.getLoginUserAddressTo)
                            push!.str_to_location = String(self.getLoginUserAddressFrom)
                            
                            push!.my_location_lat = String(self.getLoginUserLatitudeTo)
                            push!.my_location_long = String(self.getLoginUserLongitudeTo)
                            
                            push!.searched_place_location_lat = String(self.getLoginUserLatitudeFrom)
                            push!.searched_place_location_long = String(self.getLoginUserLongitudeFrom)
                            DispatchQueue.main.async {
                                ERProgressHud.sharedInstance.hide()
                                self.navigationController?.pushViewController(push!, animated: true)
                            }
                        } else {
                            DispatchQueue.main.async {
                                ERProgressHud.sharedInstance.hide()
                                let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Your selected location is out of our \(self.str_user_select_vehicle!) service."), style: .alert)
                                let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                                alert.addButtons([cancel])
                                self.present(alert, animated: true)
                            }
                            
                        }
                    } else {
                        print("The place is not in Dhaka, Bangladesh.")
                        print(self.str_user_select_vehicle as Any)
                        
                        if (self.str_user_select_vehicle == "INTERCITY") {
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "total_fare_distance_mpa_route_id") as? total_fare_distance_mpa_route
                            
                            debugPrint(self.str_user_select_vehicle as Any)
                            
                            push!.str_vehicle_type = String(self.str_user_select_vehicle)
                            
                            push!.str_get_category_id = String(self.str_category_id)
                            // push!.str_from_location = String(self.lbl_location_from.text!)
                            // push!.str_to_location = String(self.stateAndCountry)+" "+String(self.stateAndCountry)
                            
                            push!.str_from_location = String(self.getLoginUserAddressTo)
                            push!.str_to_location = String(self.getLoginUserAddressFrom)
                            
                            push!.my_location_lat = String(self.getLoginUserLatitudeTo)
                            push!.my_location_long = String(self.getLoginUserLongitudeTo)
                            
                            push!.searched_place_location_lat = String(self.getLoginUserLatitudeFrom)
                            push!.searched_place_location_long = String(self.getLoginUserLongitudeFrom)
                            DispatchQueue.main.async {
                                ERProgressHud.sharedInstance.hide()
                                self.navigationController?.pushViewController(push!, animated: true)
                            }
                        } else {
                            DispatchQueue.main.async {
                                ERProgressHud.sharedInstance.hide()
                                let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Your selected location is out of our \(self.str_user_select_vehicle!) service."), style: .alert)
                                let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                                alert.addButtons([cancel])
                                self.present(alert, animated: true)
                            }
                            
                        }
                        
                        
                        
                    }
                }
            } catch let parseError {
                print("Error parsing response: \(parseError)")
            }
        }
        task.resume()
    }

    
    /// **************************************************************
    /// ************* RIDE NOW CLICK *********************************
    /// **************************************************************
    @objc func ride_now_click_method() {
        
        if self.str_category_id == "0" {
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    let alert = NewYorkAlertController(title: String("Alert"), message: String("Please select atleast one vehicle"), style: .alert)
                    let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                    alert.addButtons([cancel])
                    present(alert, animated: true)
                } else {
                    let alert = NewYorkAlertController(title: String("সতর্কতা"), message: String("অনুগ্রহ করে অন্তত একটি গাড়ি নির্বাচন করুন"), style: .alert)
                    let cancel = NewYorkButton(title: "বরখাস্ত করা", style: .cancel)
                    alert.addButtons([cancel])
                    present(alert, animated: true)
                }
                
            }
            
        } else {
            
            if (self.str_user_option == "schedule") {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "schedule_a_ride_id") as? schedule_a_ride
                
                push!.str_get_category_id = String(self.str_category_id)
                push!.str_from_location = String(self.lbl_location_from.text!)
                push!.str_to_location = String(self.stateAndCountry)+" "+String(self.stateAndCountry)
                
                push!.my_location_lat = String(self.strSaveLatitude)
                push!.my_location_long = String(self.strSaveLongitude)
                
                push!.searched_place_location_lat = String(self.searchLat)
                push!.searched_place_location_long = String(self.searchLong)
                
                self.navigationController?.pushViewController(push!, animated: true)
                
            } else {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
                geocodeAddress(String(self.getLoginUserAddressFrom))
            }
            
        }
    }
    
    
    /// **************************************************************
    /// ************* API - LIST OF ALL CAR CATEGORY *****************
    /// **************************************************************
    
    @objc func list_of_all_category_WB() {
        
        self.view.endEditing(true)
        
        let params = payload_vehicle_list(action: "category",
                                          TYPE: String(self.str_user_select_vehicle),
                                          language:String(self.str_selected_language_is))
        
        print(params as Any)
        
        AF.request(application_base_url,
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder.default
                   /*headers: headers*/).responseJSON {  response in
            
            debugPrint(params)
            
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    
                    let JSON = data as! NSDictionary
                    print(JSON)
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"] as? String
                    
                    if strSuccess.lowercased() == "success" {
                        
                        self.ar = (JSON["data"] as! Array<Any>) as NSArray
                        
                        let item = self.ar[0] as? [String:Any]
                        self.str_bike_cat_id = "\(item!["id"]!)"
                        /*for indexx in 0..<self.ar.count {
                         
                         let item = self.ar[indexx] as? [String:Any]
                         
                         
                         let custom_dict = ["ID":"\(item!["ID"]!)",
                         "name":(item!["name"] as! String),
                         "image":(item!["image"] as! String),
                         "status":"no",
                         "perMile":"\(item!["perMile"]!)",
                         "total":"\(item!["total"]!)",
                         "TYPE":(item!["TYPE"] as! String)]
                         
                         self.arr_mut_list_of_category.add(custom_dict)
                         
                         }
                         
                         // self.arr_mut_list_of_category.addObjects(from: ar as! [Any])
                         
                         self.collectionView.dataSource = self
                         self.collectionView.delegate = self
                         self.collectionView.reloadData()*/
                        
                        self.hide_loading_UI()
                        
                    }
                    else {
                        self.hide_loading_UI()
                    }
                    
                }
                
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
                self.hide_loading_UI()
                self.please_check_your_internet_connection()
                
                break
            }
            
        }
        //        } else {
        //            print("TOKEN NOT SAVED.")
        //        }
    }
    
    func postAction() {
        let Url = String(format: application_base_url)
        guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary = ["username" : "Test", "password" : "123456"]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func decode(jwtToken jwt: String) -> [String: Any] {
        let segments = jwt.components(separatedBy: ".")
        return decodeJWTPart(segments[1]) ?? [:]
    }
    
    func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 = base64 + padding
        }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
    
    func decodeJWTPart(_ value: String) -> [String: Any]? {
        guard let bodyData = base64UrlDecode(value),
              let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
            return nil
        }
        
        return payload
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // apple maps
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
     
     // print("local address ==> "+localAddress as Any) // south west delhi
     // print("local address mini ==> "+localAddressMini as Any) // new delhi
     // print("locality ==> "+locality as Any) // sector 10 dwarka
     
     // print(self.strSaveCountryName as Any) // india
     // print(self.strSaveStateName as Any) // new delhi
     // print(self.strSaveZipcodeName as Any) // 110075
     
     var str_locality = String(self.strSaveLocality)
     var str_local_address = String(self.strSaveLocalAddress)
     var str_local_state = String(self.strSaveStateName)
     var str_local_country = String(self.strSaveCountryName)
     let str_local_zipcode = String(self.strSaveZipcodeName)
     
     self.lbl_location_from.text = String(self.strSaveLocality)+", "+String(self.strSaveLocalAddress)+" "+String(self.strSaveStateName)+", "+String(self.strSaveCountryName)+" - "+String(self.strSaveZipcodeName)
     
     //            self.lbl_location_from.text = String(self.strSaveLocality)+", "+String(self.strSaveLocalAddress)+" "+String(self.strSaveStateName)+", "+String(self.strSaveCountryName)
     
     //            self.lbl_location_from.text = String(self.strSaveLocality)+" "+String(self.strSaveLocalAddress)+" "+String(self.strSaveLocalAddressMini)+","+String(self.strSaveStateName)+","+String(self.strSaveCountryName)
     
     
     /*print(manager.location?.coordinate.latitude as Any)
      print(manager.location?.coordinate.longitude as Any)
      
      let sourceLocation = CLLocationCoordinate2D(latitude: Double((manager.location?.coordinate.latitude)!), longitude: Double((manager.location?.coordinate.longitude)!))*/
     
     /*
      AVGRating = 0;
      address = "";
      contactNumber = 8287632345;
      distance = 0;
      fullName = iDriver5;
      id = 13;
      latitude = "28.587238814653944";
      longitude = "77.06062328401764";
      "profile_picture" = "";
      */
     
     let my_current_location = ["title":"You are here",
     "id":"",
     "distance":"",
     "fullName":"",
     "latitude":String(self.strSaveLatitude),
     "longitude":String(self.strSaveLongitude)]
     
     self.arr_all_locations_pin.add(my_current_location)
     // print(self.arr_all_locations_pin)
     
     
     /*let sourcePin = customPin(pinTitle: "You", pinSubTitle: "", location: sourceLocation)
      
      self.mapView.removeAnnotations(self.mapView.annotations)
      
      self.mapView.addAnnotation(sourcePin)*/
     
     //MARK:- STOP LOCATION -
     self.locationManager.stopUpdatingLocation()
     
     self.find_driver_WB()
     
     }
     
     }*/
    
    /* @nonobjc func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
     guard annotation is MKPointAnnotation else { return nil }
     
     let identifier = "Annotation"
     var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
     
     if annotationView == nil {
     annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
     annotationView!.canShowCallout = true
     // annotationView?.removeFromSuperview()
     } else {
     annotationView!.annotation = annotation
     }
     
     return annotationView
     }*/
    
    /*@nonobjc func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
     let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
     self.mapView.setRegion(region, animated: true)
     }*/
    
    
    
    @objc func list_by_car_WB(str_show_loader:String) {
        
        // self.show_loading_UI()
        
        if (str_show_loader == "yes") {
            // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
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
                
                /*
                 var getLoginUserLatitudeTo:String!
                 var getLoginUserLongitudeTo:String!
                 var getLoginUserAddressTo:String!
                 var getLoginUserLatitudeFrom:String!
                 var getLoginUserLongitudeFrom:String!
                 var getLoginUserAddressFrom:String!
                 */
                
                
                
                if (self.str_user_select_vehicle == "INTERCITY") {
                    parameters = [
                        "action"            : "listbyprice",
                        "TYPE"              : String("CAR"),
                        "userId"            : String(myString),
                        "pickuplatLong"     : String(self.getLoginUserLatitudeTo)+","+String(self.getLoginUserLongitudeTo),
                        "droplatLong"       : String(self.getLoginUserLatitudeFrom)+","+String(self.getLoginUserLongitudeFrom),
                        "language"          : String(lan)
                    ]
                } else {
                    parameters = [
                        "action"            : "listbyprice",
                        "TYPE"              : String(self.str_user_select_vehicle),
                        "userId"            : String(myString),
                        "pickuplatLong"     : String(self.getLoginUserLatitudeTo)+","+String(self.getLoginUserLongitudeTo),
                        "droplatLong"       : String(self.getLoginUserLatitudeFrom)+","+String(self.getLoginUserLongitudeFrom),
                        "language"          : String(lan)
                    ]
                }
                
                
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
                                
                                self.arr_mut_list_of_category.removeAllObjects()
                                
                                /*if (JSON["AuthToken"] == nil) {
                                 let str_token = (JSON["AuthToken"] as! String)
                                 UserDefaults.standard.set("", forKey: str_save_last_api_token)
                                 UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                                 
                                 ERProgressHud.sharedInstance.hide()
                                 self.back_click_method()
                                 } else {
                                 let str_token = (JSON["AuthToken"] as! String)
                                 UserDefaults.standard.set("", forKey: str_save_last_api_token)
                                 UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                                 
                                 ERProgressHud.sharedInstance.hide()
                                 self.back_click_method()
                                 }*/
                                
                                self.ar = (JSON["data"] as! Array<Any>) as NSArray
                                
                                for indexx in 0..<self.ar.count {
                                    
                                    let item = self.ar[indexx] as? [String:Any]
                                    
                                    let custom_dict = ["ID":"\(item!["ID"]!)",
                                                       "name":(item!["name"] as! String),
                                                       "image":(item!["image"] as! String),
                                                       "status":"no",
                                                       "perMile":"\(item!["perMile"]!)",
                                                       "Promotional_total":"\(item!["Promotional_total"]!)",
                                                       "total":"\(item!["total"]!)",
                                                       "TYPE":(item!["TYPE"] as! String)]
                                    
                                    self.arr_mut_list_of_category.add(custom_dict)
                                    
                                }
                                
                                // self.arr_mut_list_of_category.addObjects(from: ar as! [Any])
                                ERProgressHud.sharedInstance.hide()
                                
                                self.collectionView.isHidden = false
                                self.mapView.isHidden = false
                                self.btnRideNow.isHidden = false
                                
                                self.collectionView.dataSource = self
                                self.collectionView.delegate = self
                                
                                self.view.bringSubviewToFront(self.collectionView)
                                self.collectionView.backgroundColor = .clear
                                
                                self.collectionView.reloadData()
                                
                                self.hide_loading_UI()
                                
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
                            
                            if (self.str_user_select_vehicle == "BIKE"){
                                print("bike")
                                
                                print(self.str_get_login_user_lat as Any)
                                print(self.str_get_login_user_long as Any)
                                print(self.pick_lat as Any)
                                print(self.pick_long as Any)
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "total_fare_distance_mpa_route_id") as? total_fare_distance_mpa_route
                                
                                push!.str_vehicle_type = String(self.str_user_select_vehicle)
                                
                                push!.str_get_category_id = String(self.str_bike_cat_id)
                                push!.str_from_location = String(self.lbl_location_from.text!)
                                push!.str_to_location = String(self.stateAndCountry)+" "+String(self.stateAndCountry)
                                
                                push!.my_location_lat = String(self.str_get_login_user_lat)
                                push!.my_location_long = String(self.str_get_login_user_long)
                                
                                push!.searched_place_location_lat = String(self.searchLat)
                                push!.searched_place_location_long = String(self.searchLong)
                                
                                self.navigationController?.pushViewController(push!, animated: true)
                            } else {
                                self.list_by_car_WB(str_show_loader: "no")
                            }
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

//MARK:- COLLECTION VIEW -
extension map_view: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arr_mut_list_of_category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "map_view_collection_view_cell", for: indexPath as IndexPath) as! map_view_collection_view_cell
        
        let item = self.arr_mut_list_of_category[indexPath.row] as? [String:Any]
        print(item as Any)
        
        // cell.imgCarType.image = UIImage(named: "foodPlaceholder")
        cell.lblCarType.text = (item!["name"] as! String)
        // cell.lblExtimatedTime.text = (item!["name"] as! String)
        // cell.lblExtimatedTime.isHidden = true
        
        cell.layer.cornerRadius = 22
        cell.clipsToBounds = true
        
        cell.imgCarType.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.imgCarType.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "logo33"))
        
        if (item!["status"] as! String) == "no" {
            
            cell.img_purple.isHidden = true
            cell.imgCarType.layer.cornerRadius = 0
            cell.imgCarType.clipsToBounds = true
            cell.imgCarType.layer.borderWidth = 0
            cell.layer.borderWidth = 5
            cell.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
            
        } else {
            
            cell.img_purple.isHidden = false
            cell.imgCarType.layer.cornerRadius = 0
            cell.imgCarType.clipsToBounds = true
            cell.imgCarType.layer.borderWidth = 0
            cell.layer.borderWidth = 5
            cell.layer.borderColor = UIColor.orange.cgColor
        }
        
        if (self.str_user_select_vehicle == "BIKE") {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
            if (language == "en") {
                cell.lbl_total_seats.text = "1 person per ride"
            } else {
                cell.lbl_total_seats.text = "রাইড প্রতি 1 জন ব্যক্তি"
            }
        }
        } else {
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    cell.lbl_total_seats.text = "4 person per ride"
                } else {
                    cell.lbl_total_seats.text = "রাইড প্রতি 4 জন ব্যক্তি"
                }
                
            }
        }
        
        cell.lbl_price.text = "\(str_bangladesh_currency_symbol) \(item!["total"]!)"
        cell.backgroundColor  = .clear
        
         print("\(item!["Promotional_total"]!)")
        if let firstValue = Double("\(item!["Promotional_total"]!)"), let secondValue = Double("\(item!["total"]!)") {
            // Subtract the second value from the first value
            let result = secondValue - firstValue
            
            // Print the result
            print("The result of subtraction is \(result)")
            
            let formattedStringFF = roundToTwoDecimalPlaces(result)
            
            cell.lbl_discount_price.text = "\(str_bangladesh_currency_symbol) \(formattedStringFF)"
            
        } else {
            print("One or both of the string values could not be converted to Double.")
        }
        
        
        // var calculate = doublePriceTotal - doublePricePT
        
        // cell.lbl_discount_price.text = "\(calculate)"
        
        return cell
        
    }
    
    func centerItemsInCollectionView(cellWidth: Double, numberOfItems: Double, spaceBetweenCell: Double, collectionView: UICollectionView) -> UIEdgeInsets {
        let totalWidth = cellWidth * numberOfItems
        let totalSpacingWidth = spaceBetweenCell * (numberOfItems - 1)
        let leftInset = (collectionView.frame.width - CGFloat(totalWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
    /*func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
     
     let totalCellWidth = 400 * 3
     let totalSpacingWidth = 12 * (3 - 1)
     
     let leftInset = (600 - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
     let rightInset = leftInset
     
     return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
     }*/
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.arr_mut_list_of_category.removeAllObjects()
        
        for indexx in 0..<self.ar.count {
            
            let item = self.ar[indexx] as? [String:Any]
            
            let custom_dict = ["ID":"\(item!["ID"]!)",
                               "name":(item!["name"] as! String),
                               "image":(item!["image"] as! String),
                               "status":"no",
                               "perMile":"\(item!["perMile"]!)",
                               "Promotional_total":"\(item!["Promotional_total"]!)",
                               "total":"\(item!["total"]!)",
                               "TYPE":(item!["TYPE"] as! String)]
            
            self.arr_mut_list_of_category.add(custom_dict)
            
        }
        
        
        let item = self.arr_mut_list_of_category[indexPath.row] as? [String:Any]
        self.str_category_id = (item!["ID"] as! String)
        
        self.arr_mut_list_of_category.removeObject(at: indexPath.row)
        
        let custom_dict = ["ID":(item!["ID"] as! String),
                           "name":(item!["name"] as! String),
                           "image":(item!["image"] as! String),
                           "status":"yes",
                           "perMile":"\(item!["perMile"]!)",
                           "Promotional_total":"\(item!["Promotional_total"]!)",
                           "total":"\(item!["total"]!)",
                           "TYPE":(item!["TYPE"] as! String)]
        
        self.arr_mut_list_of_category.insert(custom_dict, at: indexPath.row)
        
        print(self.str_category_id as Any)
        
        self.view.bringSubviewToFront(self.btnRideNow)
        
        // self.str_category_id = "\(item!["id"]!)"
        
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var sizes: CGSize
        let result = UIScreen.main.bounds.size
        NSLog("%f",result.height)
        sizes = CGSize(width: 120, height: 192)
        
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
        
        let cellWidth : CGFloat = collectionView.frame.size.width
        
        let numberOfCells = floor(collectionView.frame.size.width / cellWidth)
        let edgeInsets = (collectionView.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
        
        if (self.str_user_select_vehicle == "BIKE") {
            return UIEdgeInsets(top: 10, left: 140, bottom: 10, right: edgeInsets)
        } else {
            return UIEdgeInsets(top: 10, left: edgeInsets, bottom: 10, right: edgeInsets)
        }
        
        // return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}

extension map_view: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print(searchBar.tag as Any)
        
        print(searchText as Any)
        
        if (searchBar.tag == 0) {
            self.str_which_textfield = "0"
        } else {
            self.str_which_textfield = "1"
        }
        
        searchCompleter.queryFragment = searchText
        
        self.searchResultsTableView.isHidden = false
    }
}

extension map_view: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

extension map_view: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.view.endEditing(true)
        
        if (self.str_user_select_vehicle == "BIKE") {
            print("bike")
            
            print(self.str_get_login_user_lat as Any)
            print(self.str_get_login_user_long as Any)
            print(self.pick_lat as Any)
            print(self.pick_long as Any)
             print(self.str_user_select_vehicle)
             print(self.str_user_option)
             
            if (self.str_user_option == "schedule") {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "schedule_a_ride_id") as? schedule_a_ride
                
                push!.str_get_category_id = "10"//String(self.str_category_id)
                push!.str_from_location = String(self.lbl_location_from.text!)
                push!.str_to_location = String(self.stateAndCountry)+" "+String(self.stateAndCountry)
                
                push!.my_location_lat = String(self.strSaveLatitude)
                push!.my_location_long = String(self.strSaveLongitude)
                
                push!.searched_place_location_lat = String(self.searchLat)
                push!.searched_place_location_long = String(self.searchLong)
                
                self.navigationController?.pushViewController(push!, animated: true)
            } else {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "total_fare_distance_mpa_route_id") as? total_fare_distance_mpa_route
                
                push!.str_vehicle_type = String(self.str_user_select_vehicle)
                
                push!.str_get_category_id = String(self.str_bike_cat_id)
                // push!.str_from_location = String(self.lbl_location_from.text!)
                // push!.str_to_location = String(self.stateAndCountry)+" "+String(self.stateAndCountry)
                
                push!.str_from_location = String(self.search_place_pickup.text!)
                push!.str_to_location = String(self.search_place_drop.text!)
                
                push!.my_location_lat = String(self.getLoginUserLatitudeTo)
                push!.my_location_long = String(self.getLoginUserLongitudeTo)
                
                push!.searched_place_location_lat = String(self.getLoginUserLatitudeFrom)
                push!.searched_place_location_long = String(self.getLoginUserLongitudeFrom)
                
                self.navigationController?.pushViewController(push!, animated: true)
            }
        } else {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "total_fare_distance_mpa_route_id") as? total_fare_distance_mpa_route
            
            push!.str_vehicle_type = String(self.str_user_select_vehicle)
            
            push!.str_get_category_id = String(self.str_bike_cat_id)
//                                push!.str_from_location = String(self.lbl_location_from.text!)
//                                push!.str_to_location = String(self.stateAndCountry)+" "+String(self.stateAndCountry)
            
            push!.str_from_location = String(self.search_place_pickup.text!)
            push!.str_to_location = String(self.search_place_drop.text!)//+" "+String(self.stateAndCountry)
            
            push!.my_location_lat = String(self.str_get_login_user_lat)
            push!.my_location_long = String(self.str_get_login_user_long)
            
            push!.searched_place_location_lat = String(self.searchLat)
            push!.searched_place_location_long = String(self.searchLong)
            
            self.navigationController?.pushViewController(push!, animated: true)
        }
        
        /*print(self.search_place_drop.text as Any)
        print(self.search_place_pickup.text as Any)
        
        self.searchResultsTableView.isHidden = true
        
        // here all prevoius annotations removed before insert new
        // self.mapView.removeAnnotations(self.mapView.annotations)
        
        
        
        let completion = searchResults[indexPath.row]
        
        print(completion.title as Any)
        print(completion.subtitle as Any)
        
        /*if self.mapView.annotations.isEmpty != true {
            self.mapView.removeAnnotation(self.mapView.annotations.last!)
        }*/
        
        if (self.str_which_textfield == "0") {
            
            self.search_place_pickup.text = ""
            self.search_place_pickup.text = completion.title+" "+completion.subtitle
            
            print(self.search_place_drop.text as Any)
            print(self.search_place_pickup.text as Any)
            
            UserDefaults.standard.synchronize()
            
            let searchRequest = MKLocalSearch.Request(completion: completion)
            let search = MKLocalSearch(request: searchRequest)
            
            search.start { [self] (response, error) in
                let coordinate = response?.mapItems[0].placemark.coordinate
                // print(String(describing: coordinate?.latitude))
                // print(String(describing: coordinate?.longitude))
                
                print(Double(coordinate!.latitude))
                print(Double(coordinate!.longitude))
                
                // let fullAddress = completion.title+" "+completion.subtitle
                
                self.stateAndCountry = String(completion.title)
                self.fullAddress = String(completion.subtitle)
                
                self.searchLat = String(coordinate!.latitude)
                self.searchLong = String(coordinate!.longitude)
                
                self.drop_lat = String(coordinate!.latitude)
                self.drop_long = String(coordinate!.longitude)
                
                self.str_get_login_user_lat = String(coordinate!.latitude)
                self.str_get_login_user_long = String(coordinate!.longitude)
                
                print(self.str_get_login_user_lat as Any)
                print(self.str_get_login_user_long as Any)
                
                let randomCGFloat = Int.random(in: 1...1000)
                print(randomCGFloat as Any)
                
                // db.insert(id: randomCGFloat, name: "\(completion.title), \(completion.subtitle)", lat_long: "\(self.searchLat!),\(self.searchLong!)", age: 2)
                
                let london = MKPointAnnotation()
                london.title = completion.title
                london.subtitle = completion.subtitle
                // mapView.delegate = self
                london.coordinate = CLLocationCoordinate2D(latitude: coordinate!.latitude, longitude: coordinate!.longitude)
                // mapView.removeAnnotation(london)
                // mapView.addAnnotation(london)
                
                
                /*var zoomRect: MKMapRect = MKMapRect.null
                for annotation in mapView.annotations {
                    let annotationPoint = MKMapPoint(annotation.coordinate)
                    let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1)
                    zoomRect = zoomRect.union(pointRect)
                }*/
                
                // mapView.setVisibleMapRect(zoomRect, animated: true)
                
                // self.mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
                
                self.locManager.stopUpdatingLocation()
                
                print(self.pick_lat as Any)
                
                if (self.pick_lat != "") {
                    if (self.pick_lat == nil) {
                        
                    } else {
                        if (self.str_user_select_vehicle == "BIKE"){
                            print("bike")
                            
                            print(self.str_get_login_user_lat as Any)
                            print(self.str_get_login_user_long as Any)
                            print(self.pick_lat as Any)
                            print(self.pick_long as Any)
                            // print(self.str_user_select_vehicle)
                            // print(self.str_user_option)
                             
                            if (self.str_user_option == "schedule") {
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "schedule_a_ride_id") as? schedule_a_ride
                                
                                push!.str_get_category_id = "10"//String(self.str_category_id)
                                push!.str_from_location = String(self.lbl_location_from.text!)
                                push!.str_to_location = String(self.stateAndCountry)+" "+String(self.stateAndCountry)
                                
                                push!.my_location_lat = String(self.strSaveLatitude)
                                push!.my_location_long = String(self.strSaveLongitude)
                                
                                push!.searched_place_location_lat = String(self.searchLat)
                                push!.searched_place_location_long = String(self.searchLong)
                                
                                self.navigationController?.pushViewController(push!, animated: true)
                            } else {
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "total_fare_distance_mpa_route_id") as? total_fare_distance_mpa_route
                                
                                push!.str_vehicle_type = String(self.str_user_select_vehicle)
                                
                                push!.str_get_category_id = String(self.str_bike_cat_id)
                                // push!.str_from_location = String(self.lbl_location_from.text!)
                                // push!.str_to_location = String(self.stateAndCountry)+" "+String(self.stateAndCountry)
                                
                                push!.str_from_location = String(self.search_place_pickup.text!)
                                push!.str_to_location = String(self.search_place_drop.text!)//+" "+String(self.stateAndCountry)
                                
                                push!.my_location_lat = String(self.str_get_login_user_lat)
                                push!.my_location_long = String(self.str_get_login_user_long)
                                
                                push!.searched_place_location_lat = String(self.searchLat)
                                push!.searched_place_location_long = String(self.searchLong)
                                
                                self.navigationController?.pushViewController(push!, animated: true)
                            }
                        } else {
                            self.list_by_car_WB(str_show_loader: "yes")
                        }
                    }
                    
                }
                
            }
            
        } else {
            
            self.search_place_drop.text = ""
            self.search_place_drop.text = completion.title+" "+completion.subtitle
            
            print(self.search_place_drop.text as Any)
            print(self.search_place_pickup.text as Any)
            
            UserDefaults.standard.synchronize()
            
            let searchRequest = MKLocalSearch.Request(completion: completion)
            let search = MKLocalSearch(request: searchRequest)
            
            search.start { [self] (response, error) in
                let coordinate = response?.mapItems[0].placemark.coordinate
                // print(String(describing: coordinate?.latitude))
                // print(String(describing: coordinate?.longitude))
                
                print(Double(coordinate!.latitude))
                print(Double(coordinate!.longitude))
                
                // let fullAddress = completion.title+" "+completion.subtitle
                
                self.stateAndCountry = String(completion.title)
                self.fullAddress = String(completion.subtitle)
                
                self.searchLat = String(coordinate!.latitude)
                self.searchLong = String(coordinate!.longitude)
                
                
                self.pick_lat = String(coordinate!.latitude)
                self.pick_long = String(coordinate!.longitude)
                
                let randomCGFloat = Int.random(in: 1...1000)
                print(randomCGFloat as Any)
                
                db.insert(id: randomCGFloat, name: "\(completion.title), \(completion.subtitle)", lat_long: "\(self.searchLat!),\(self.searchLong!)", age: 2)
                
                /*let london = MKPointAnnotation()
                london.title = completion.title
                london.subtitle = completion.subtitle
                mapView.delegate = self
                london.coordinate = CLLocationCoordinate2D(latitude: coordinate!.latitude, longitude: coordinate!.longitude)
                mapView.removeAnnotation(london)
                mapView.addAnnotation(london)*/
                
                
                /*var zoomRect: MKMapRect = MKMapRect.null
                for annotation in mapView.annotations {
                    let annotationPoint = MKMapPoint(annotation.coordinate)
                    let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1)
                    zoomRect = zoomRect.union(pointRect)
                }
                // mapView.setVisibleMapRect(zoomRect, animated: true)
                
                self.mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
                
                
                self.locManager.stopUpdatingLocation()
                 */
                
                if (self.str_get_login_user_lat != "") {
                    if (self.str_get_login_user_lat == nil) {
                        
                    } else {
                        if (self.str_user_select_vehicle == "BIKE") {
                            print("bike")
                            
                            print(self.str_get_login_user_lat as Any)
                            print(self.str_get_login_user_long as Any)
                            print(self.pick_lat as Any)
                            print(self.pick_long as Any)
                            print(self.str_user_select_vehicle)
                            print(self.str_user_option)
                            
                            if (self.str_user_option == "schedule") {
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "schedule_a_ride_id") as? schedule_a_ride
                                
                                push!.str_get_category_id = "10"// String(self.str_category_id)
                                push!.str_from_location = String(self.lbl_location_from.text!)
                                push!.str_to_location = String(self.stateAndCountry)+" "+String(self.stateAndCountry)
                                
                                push!.my_location_lat = String(self.strSaveLatitude)
                                push!.my_location_long = String(self.strSaveLongitude)
                                
                                push!.searched_place_location_lat = String(self.searchLat)
                                push!.searched_place_location_long = String(self.searchLong)
                                
                                self.navigationController?.pushViewController(push!, animated: true)
                            } else {
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "total_fare_distance_mpa_route_id") as? total_fare_distance_mpa_route
                                
                                push!.str_vehicle_type = String(self.str_user_select_vehicle)
                                
                                push!.str_get_category_id = String(self.str_bike_cat_id)
//                                push!.str_from_location = String(self.lbl_location_from.text!)
//                                push!.str_to_location = String(self.stateAndCountry)+" "+String(self.stateAndCountry)
                                
                                push!.str_from_location = String(self.search_place_pickup.text!)
                                push!.str_to_location = String(self.search_place_drop.text!)//+" "+String(self.stateAndCountry)
                                
                                push!.my_location_lat = String(self.str_get_login_user_lat)
                                push!.my_location_long = String(self.str_get_login_user_long)
                                
                                push!.searched_place_location_lat = String(self.searchLat)
                                push!.searched_place_location_long = String(self.searchLong)
                                
                                self.navigationController?.pushViewController(push!, animated: true)
                            }
                            
                        } else {
                            self.list_by_car_WB(str_show_loader: "yes")
                        }
                    }
                    
                }
                
                
            }
            
        }*/
    }
    
}

class map_view_collection_view_cell: UICollectionViewCell , UITextFieldDelegate {
    
    @IBOutlet weak var imgCarType:UIImageView! {
        didSet {
            imgCarType.layer.cornerRadius = 25
            imgCarType.clipsToBounds = true
            imgCarType.layer.borderWidth = 5
            imgCarType.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
        }
    }
    @IBOutlet weak var img_purple:UIImageView!
    
    @IBOutlet weak var lblCarType:UILabel!
    @IBOutlet weak var lblExtimatedTime:UILabel!
    
    @IBOutlet weak var lbl_total_seats:UILabel! {
        didSet {
            
        }
    }
    @IBOutlet weak var lbl_price:UILabel!
    
    @IBOutlet weak var lbl_discount_price:UILabel!
}

class Person
{
    
    var name: String = ""
    var lat_long: String = ""
    var age: Int = 0
    var id: Int = 0
    
    init(id:Int, name:String, lat_long:String, age:Int)
    {
        self.id = id
        self.name = name
        self.lat_long = lat_long
        self.age = age
    }
    
}

import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "myDb4.sqlite"
    
   
    
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        var db_name:String!
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            db_name = String(myString)+".sqlite"
        }
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent(db_name)
            var db: OpaquePointer? = nil
            if sqlite3_open(fileURL.path, &db) != SQLITE_OK
            {
                print("error opening database")
                return nil
            }
            else
            {
                print("Successfully opened connection to database at \(db_name!)")
                return db
            }
       
        
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS person(Id INTEGER PRIMARY KEY,name TEXT,lat_long TEXT,age INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("person table created.")
            } else {
                print("person table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(id:Int, name:String, lat_long:String, age:Int)
    {
        let persons = read()
        for p in persons
        {
            if p.id == id
            {
                return
            }
        }
        
        let insertStatementString = "INSERT INTO person (Id, name, lat_long, age) VALUES (?, ?, ?, ?);"
        
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (lat_long as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 4, Int32(age))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [Person] {
        let queryStatementString = "SELECT * FROM person;"
        var queryStatement: OpaquePointer? = nil
        var psns : [Person] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let lat_long = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let year = sqlite3_column_int(queryStatement, 3)
                // psns.append(Person(id: Int(id), name: name, age: Int(year)))
                // psns.append(Person(id: Int(id), name: name, lat_long: lat_long, age: Int(year)))
                psns.append(Person(id: 1, name:name, lat_long: lat_long, age: 1))
                print("Query Result:")
                 
                print("\(id) | \(name) | \(lat_long) | \(year)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM person WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
}
