//
//  schedule_confirm_booking.swift
//  PathMark
//
//  Created by Dishant Rajput on 16/11/23.
//

import UIKit
import MapKit
import Alamofire

// MARK:- LOCATION -
import CoreLocation

class schedule_confirm_booking: UIViewController , CLLocationManagerDelegate , MKMapViewDelegate, UITextFieldDelegate {
    
    var str_date:String!
    var str_date2:String!
    var str_time:String!
    var str_time2:String!
    
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
       
    var str_fetch_payment_method:String!
    var str_fetch_duration:String!
    var str_fetch_distance:String!
    var str_fetch_fare_estimated:String!
    
    var str_total_distance:String! = ""
    var str_total_duration:String! = ""
    var str_total_rupees:String! = ""
    
    var str_get_category_id2:String!
    var str_from_location2:String!
    var str_to_location2:String!
    
    var searched_place_location_lat2:String!
    var searched_place_location_long2:String!
    
    var my_location_lat2:String!
    var my_location_long2:String!
    
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            btnBack.tintColor = NAVIGATION_BACK_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
             
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lblNavigationTitle.text = "Fare distance"
                } else {
                    lblNavigationTitle.text = "ভাড়া দূরত্ব"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
        }
    }
    
   
    let cellReuseIdentifier = "dFareDistanceTableViewCell"
    
    @IBOutlet weak var tbleView:UITableView! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var btnConfirmBooking:UIButton! {
        didSet {
            btnConfirmBooking.backgroundColor = .systemGreen
            
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btnConfirmBooking.setTitle("Confirm booking", for: .normal)
                } else {
                    btnConfirmBooking.setTitle("বুকিং নিশ্চিত করুন", for: .normal)
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
        }
    }
    
//    @IBOutlet weak var mapView:MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        self.btnConfirmBooking.addTarget(self, action: #selector(validation_before_confirm_booking), for: .touchUpInside)
        
        self.show_loading_UI()
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)

        // self.iAmHereForLocationPermission()
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
             self.get_fare_WB()
        } else if (counter == 0) {
            timer.invalidate()
        }

    }
    
    
    @objc func iAmHereForLocationPermission() {
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
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
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
        let cell = self.tbleView.cellForRow(at: indexPath) as! schedule_confirm_booking_table_cell
        
        cell.lblStartingLocation.text = String(self.str_from_location2)
        cell.lblEndLocation.text = String(self.str_to_location2)
        // cell.viewCellbg.isHidden = true
        
        // print(self.str_from_location as Any)
        // print(self.str_to_location as Any)
        
        cell.lbl_from.text = String(self.str_from_location2)
        cell.lbl_to.text = String(self.str_to_location2)
        
        print("**********************")
        
        let restaurantLatitudeDouble    = Double(self.searched_place_location_lat2)
        let restaurantLongitudeDouble   = Double(self.searched_place_location_long2)
        let driverLatitudeDouble        = Double(self.my_location_lat2)
        let driverLongitudeDouble       = Double(self.my_location_long2)
        
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
            
            // cell.lbl_distance.text = (String(format: "%.0f Miles away", distanceFloat/1609.344))
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
    }
    
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
    
    @objc func payment_method_click_method() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! schedule_confirm_booking_table_cell
        
        let dummyList = ["Please select payment method", "Cash", "Card"]
        
        RPicker.selectOption(title: "Select", cancelText: "Cancel", dataArray: dummyList, selectedIndex: 0) { (selctedText, atIndex) in
            // TODO: Your implementation for selection
            // cell.btnSelectPaymentMethod.setTitleColor(.black, for: .normal)
            // cell.btnSelectPaymentMethod.setTitle(" Payment method : "+String(selctedText), for: .normal)
            
            // cell.lbl_payment_type.textColor = .black
            // cell.lbl_payment_type.text = String(selctedText)
            
        }
        
    }
    
    @objc func validation_before_confirm_booking() {
        
        /*let alert = NewYorkAlertController(title: String("Alert"), message: String("Are you sure you want to confirm this booking?"), style: .alert)
        
        let yes_confirm = NewYorkButton(title: "yes, confirm", style: .default) {
            _ in

            
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

        self.find_driver_WB(str_show_loader: "yes")
    }
    
    
    @objc func find_driver_WB(str_show_loader:String) {

        if (str_show_loader == "yes") {
            self.show_loading_UI()
        }
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                
                let headers: HTTPHeaders = [
                    "token":String(token_id_is),
                ]
                
                var parameters:Dictionary<AnyHashable, Any>!
                
                
                let request_lat = String(self.strSaveLatitude)
                let request_long = String(self.strSaveLongitude)
                
                let drop_lat = String(self.searched_place_location_lat2)
                let drop_long = String(self.searched_place_location_long2)

                var lan:String!
                
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        lan = "en"
                    } else {
                        lan = "bn"
                    }
                    
                } else {
                    print("=============================")
                    print("LOGIN : Select language error")
                    print("=============================")
                    UserDefaults.standard.set("en", forKey: str_language_convert)
                }
                
                parameters = [
                    
                    "action"            : "addbooking",
                    "userId"            : String(myString),
                    "categoryId"        : String(self.str_get_category_id2),
                    "RequestPickupAddress" : String(self.str_from_location2),
                    "RequestPickupLatLong" : String(request_lat)+","+String(request_long),
                    "RequestDropAddress" : String(self.str_to_location2),
                    "RequestDropLatLong" : String(drop_lat)+","+String(drop_long),
                    
                    "duration" : String(self.str_total_duration),
                    // "totalTime" : String(self.str_total_duration),
                    
                    "distance" : String(self.str_total_distance),
                    // "totalTime" : String(self.str_total_distance),
                    
                    "estimateAmount": String(self.str_total_rupees),
                    // "estimatedPrice": String(self.str_total_rupees),
                    
                    "bookingDate":String(self.str_date),
                    "bookingTime":String(self.str_time),
                    "language" : String(lan)
                    
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
                            
                            var message : String!
                            message = (JSON["msg"] as? String)
                            
                            if strSuccess.lowercased() == "success" {
                                
                                self.hide_loading_UI()
                                
                                let str_token = (JSON["AuthToken"] as! String)
                                UserDefaults.standard.set("", forKey: str_save_last_api_token)
                                UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                                
                                /*var dict: Dictionary<AnyHashable, Any>
                                dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                
                                self.hide_loading_UI()
                                self.tbleView.separatorColor = .clear
                                self.iAmHereForLocationPermission()
                                
                                self.str_total_distance = (dict["distance"] as! String)
                                self.str_total_rupees = "\(dict["total"]!)"
                                self.str_total_duration = (dict["duration"] as! String)*/
                                
                            } else if message == String(not_authorize_api) {
                                self.login_refresh_token_wb()
                                
                            }
                            else {
                                self.hide_loading_UI()
                                
                                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                                    print(language as Any)
                                    
                                    if (language == "en") {
                                        let alert = NewYorkAlertController(title: String("Alert"), message: String(message), style: .alert)
                                        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                                        alert.addButtons([cancel])
                                        self.present(alert, animated: true)
                                    } else {
                                        let alert = NewYorkAlertController(title: String("সতর্কতা"), message: String(message), style: .alert)
                                        let cancel = NewYorkButton(title: "বরখাস্ত করা", style: .cancel)
                                        alert.addButtons([cancel])
                                        self.present(alert, animated: true)
                                    }
                                    
                                } else {
                                    print("=============================")
                                    print("LOGIN : Select language error")
                                    print("=============================")
                                    UserDefaults.standard.set("en", forKey: str_language_convert)
                                }
                                
                                
                                
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
                            
                            self.find_driver_WB(str_show_loader: "no")
                            
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
    

    // MARK:- GET TOTAL DISTANCE FARE -
    @objc func get_fare_WB() {
        
       if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
            
            let headers: HTTPHeaders = [
                "token":String(token_id_is),
            ]
           
           let pickUp = String(self.my_location_lat2)+","+String(self.my_location_long2)
           let drop = String(self.searched_place_location_lat2)+","+String(self.searched_place_location_long2)
           
           var parameters:Dictionary<AnyHashable, Any>!
           
           var lan:String!
           
           if let language = UserDefaults.standard.string(forKey: str_language_convert) {
               print(language as Any)
               
               if (language == "en") {
                    
                   lan = "en"
               } else {
                   lan = "bn"
               }
               
           } else {
               print("=============================")
               print("LOGIN : Select language error")
               print("=============================")
                
               UserDefaults.standard.set("en", forKey: str_language_convert)
           }
           
           
           if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
               
               let x : Int = person["userId"] as! Int
               let myString = String(x)
               
               
               parameters = [
                "action"        : "getprice",
                "userId"        : String(myString),
                "pickuplatLong" : String(pickUp),
                "droplatLong"   : String(drop),
                "categoryId"    : String(self.str_get_category_id2),
                "language"      : String(lan)
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
                               
                               var dict: Dictionary<AnyHashable, Any>
                               dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                               
                               self.hide_loading_UI()
                               self.tbleView.separatorColor = .clear
                               self.iAmHereForLocationPermission()
                               
                               self.str_total_distance = (dict["distance"] as! String)
                               self.str_total_rupees = "\(dict["total"]!)"
                               self.str_total_duration = (dict["duration"] as! String)
                               
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
}



//MARK:- TABLE VIEW -
extension schedule_confirm_booking: UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:schedule_confirm_booking_table_cell = tableView.dequeueReusableCell(withIdentifier: "schedule_confirm_booking_table_cell") as! schedule_confirm_booking_table_cell
        
        cell.backgroundColor = .white
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        // cell.lblTotalPayableAmount.text = String(self.str_total_rupees)
        // cell.lbl_duration.text = "Duration : "+String(self.str_total_duration)
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                cell.lbl_amount.text = str_bangladesh_currency_symbol+" "+String(self.str_total_rupees)+"\nAmount"
            } else {
                cell.lbl_amount.text = str_bangladesh_currency_symbol+" "+String(self.str_total_rupees)+"\nপরিমাণ"
            }
            
        } else {
            print("=============================")
            print("LOGIN : Select language error")
            print("=============================")
            UserDefaults.standard.set("en", forKey: str_language_convert)
        }
        
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                cell.lbl_arrived.text = String(self.str_total_duration)+"\nArrived"
                cell.lbl_distance.text = String(self.str_total_distance)+"\nDistance"
            } else {
                cell.lbl_arrived.text = String(self.str_total_duration)+"\nপৌঁছেছে"
                cell.lbl_distance.text = String(self.str_total_distance)+"\nদূরত্ব"
            }
            
        } else {
            print("=============================")
            print("LOGIN : Select language error")
            print("=============================")
            UserDefaults.standard.set("en", forKey: str_language_convert)
        }
        
         
         
        
        cell.lbl_date.text = String(str_date2)
        cell.lbl_time.text = String(str_time2)
        
        cell.txt_field.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }
    
}


class schedule_confirm_booking_table_cell: UITableViewCell {
    
    @IBOutlet weak var txt_field:UITextField! {
        didSet {
            txt_field.backgroundColor = UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1)
            
            txt_field.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_field.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            txt_field.layer.shadowOpacity = 1.0
            txt_field.layer.shadowRadius = 15.0
            txt_field.layer.masksToBounds = false
            txt_field.backgroundColor = .white
            txt_field.layer.cornerRadius = 8
            txt_field.placeholder = "Promo Code"
            txt_field.setLeftPaddingPoints(60)
            // txt_field.clipsToBounds = true
    
        }
    }
    
    @IBOutlet weak var mapView:MKMapView!
    
    // new
    @IBOutlet weak var view_cell_big:UIView! {
        didSet {
            view_cell_big.layer.cornerRadius = 8
            view_cell_big.clipsToBounds = true
            // view_cell_big.backgroundColor = UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1)
            
            view_cell_big.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_cell_big.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_cell_big.layer.shadowOpacity = 1.0
            view_cell_big.layer.shadowRadius = 15.0
            view_cell_big.layer.masksToBounds = false
            // view_cell_big.backgroundColor = .white
            
    
        }
    }
    
    @IBOutlet weak var view_cell_amount:UIView! {
        didSet {
            view_cell_amount.layer.cornerRadius = 8
            view_cell_amount.clipsToBounds = true
            // view_cell_amount.backgroundColor = UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1)
            
            view_cell_amount.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_cell_amount.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_cell_amount.layer.shadowOpacity = 1.0
            view_cell_amount.layer.shadowRadius = 15.0
            view_cell_amount.layer.masksToBounds = false
            // view_cell_amount.backgroundColor = .white
            
    
        }
    }
    
    @IBOutlet weak var view_cell_arrived:UIView! {
        didSet {
            view_cell_arrived.layer.cornerRadius = 8
            view_cell_arrived.clipsToBounds = true
            // view_cell_arrived.backgroundColor = UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1)
            
            view_cell_arrived.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_cell_arrived.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_cell_arrived.layer.shadowOpacity = 1.0
            view_cell_arrived.layer.shadowRadius = 15.0
            view_cell_arrived.layer.masksToBounds = false
            // view_cell_arrived.backgroundColor = .white
            
    
        }
    }
    
    @IBOutlet weak var view_cell_distance:UIView! {
        didSet {
            view_cell_distance.layer.cornerRadius = 8
            view_cell_distance.clipsToBounds = true
            // view_cell_distance.backgroundColor = UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1)
            
            view_cell_distance.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_cell_distance.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_cell_distance.layer.shadowOpacity = 1.0
            view_cell_distance.layer.shadowRadius = 15.0
            view_cell_distance.layer.masksToBounds = false
            // view_cell_distance.backgroundColor = .white
            
    
        }
    }
    
    @IBOutlet weak var view_cell_date:UIView! {
        didSet {
            view_cell_date.layer.cornerRadius = 8
            view_cell_date.clipsToBounds = true
            // view_cell_distance.backgroundColor = UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1)
            
            view_cell_date.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_cell_date.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_cell_date.layer.shadowOpacity = 1.0
            view_cell_date.layer.shadowRadius = 15.0
            view_cell_date.layer.masksToBounds = false
            // view_cell_distance.backgroundColor = .white
            
    
        }
    }
    
    @IBOutlet weak var view_cell_time:UIView! {
        didSet {
            view_cell_time.layer.cornerRadius = 8
            view_cell_time.clipsToBounds = true
            // view_cell_distance.backgroundColor = UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1)
            
            view_cell_time.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_cell_time.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_cell_time.layer.shadowOpacity = 1.0
            view_cell_time.layer.shadowRadius = 15.0
            view_cell_time.layer.masksToBounds = false
            // view_cell_distance.backgroundColor = .white
            
    
        }
    }
    
    
    @IBOutlet weak var lbl_amount:UILabel!
    @IBOutlet weak var lbl_arrived:UILabel!
    @IBOutlet weak var lbl_distance:UILabel!
    
    @IBOutlet weak var lbl_from:UILabel!
    @IBOutlet weak var lbl_to:UILabel!
    
    @IBOutlet weak var lbl_date:UILabel!
    @IBOutlet weak var lbl_time:UILabel!

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
    
    @IBOutlet weak var lblStartingLocation:UILabel!
    @IBOutlet weak var lblEndLocation:UILabel!
    
    @IBOutlet weak var lbl_estimate:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_estimate.text = "This is an estimate only, time, price & km may vary"
                } else {
                    lbl_estimate.text = "এটি শুধুমাত্র একটি অনুমান, সময়, মূল্য এবং কিমি পরিবর্তিত হতে পারে"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
