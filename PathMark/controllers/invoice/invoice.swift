//
//  invoice.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 31/01/24.
//

import UIKit
import MapKit
import Alamofire

class invoice: UIViewController, CLLocationManagerDelegate , MKMapViewDelegate {
    
    var dict_all_details:NSDictionary!
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView:MKMapView!
    
    // MARK:- SAVE LOCATION STRING -
    var strSaveLatitude:String! = "0.0"
    var strSaveLongitude:String! = "0.0"
    var strSaveCountryName:String!
    var strSaveLocalAddress:String!
    var strSaveLocality:String!
    var strSaveLocalAddressMini:String!
    var strSaveStateName:String!
    var strSaveZipcodeName:String!
    
    var str_store_total_price:String!
    
    @IBOutlet weak var btn_back:UIButton! {
        didSet {
            btn_back.tintColor = .white
            btn_back.isHidden = true
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
                    view_navigation_title.text = "Invoice"
                } else {
                    view_navigation_title.text = "চালান"
                }
                
                view_navigation_title.textColor = .white
            }
        }
    }
    
    
    @IBOutlet weak var lbl_price:UILabel! {
        didSet {
            lbl_price.textColor = .white
        }
    }
    @IBOutlet weak var lbl_price_text:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_price_text.text = "TOTAL AMOUNT"
                } else {
                    lbl_price_text.text = "সর্বমোট পরিমাণ"
                }
                
                
            }
        }
    }
    
    @IBOutlet weak var lbl_distance:UILabel!  {
        didSet {
            lbl_distance.textColor = .white
        }
    }
    @IBOutlet weak var lbl_distance_text:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_distance_text.text = "TOTAL DISTANCE"
                } else {
                    lbl_distance_text.text = "সম্পুর্ণ দুরত্ব"
                }
                
                
            }
        }
    }
    
    @IBOutlet weak var lbl_pick_up:UILabel!
    @IBOutlet weak var lbl_drop:UILabel!
    
    @IBOutlet weak var view_bg:UIView! {
        didSet {
            view_bg.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var lbl_trip_fare:UILabel!
    @IBOutlet weak var lbl_total:UILabel!
    @IBOutlet weak var lbl_previuos_cancel_fee:UILabel!
    
    @IBOutlet weak var lbl_trip_fare_text:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_trip_fare_text.text = "Trip fare : "
                } else {
                    lbl_trip_fare_text.text = "ভ্রমণ ভাড়া:"
                }
                
                
            }
        }
    }
    @IBOutlet weak var lbl_prev_can_fee_text:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_prev_can_fee_text.text = "Previous Cancellation fee"
                } else {
                    lbl_prev_can_fee_text.text = "পূর্ববর্তী বাতিলকরণ ফি"
                }
                
                
            }
        }
    }
    @IBOutlet weak var lbl_total_text:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_total_text.text = "Total"
                } else {
                    lbl_total_text.text = "মোট"
                }
                
                
            }
        }
    }
    
    @IBOutlet weak var btn_cash:UIButton! {
        didSet {
            btn_cash.layer.cornerRadius = 12
            btn_cash.clipsToBounds = true
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_cash.setTitle("Pay now", for: .normal)
                } else {
                    btn_cash.setTitle("এখন পরিশোধ করুন", for: .normal)
                }
                
                
            }
        }
    }
    
    @IBOutlet weak var lbl_booking_fees:UILabel!
    @IBOutlet weak var lbl_booking_fees_text:UILabel!  {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_booking_fees_text.text = "Booking Fee: "
                } else {
                    lbl_booking_fees_text.text = "সংরক্ষণ ফি:"
                }
                
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.dict_all_details as Any)
        self.view.backgroundColor = .black
    
        
        self.lbl_distance.text = "\(self.dict_all_details["totalDistance"]!) km"
        
        self.lbl_pick_up.text = "\(self.dict_all_details["RequestPickupAddress"]!)"
        self.lbl_drop.text = "\(self.dict_all_details["RequestDropAddress"]!)"
        
        self.lbl_trip_fare.text = "\(str_bangladesh_currency_symbol) \(self.dict_all_details["FinalFare"]!)"
        
        if self.dict_all_details["Last_cancel_amount"] == nil {
            
            if self.dict_all_details["last_cancel_amount"] == nil {
                
                let doublePrice1 = Double("\(self.dict_all_details["FinalFare"]!)")
                let formattedNumber1 = String(format: "%.2f", doublePrice1!)
                self.lbl_total.text = "\(str_bangladesh_currency_symbol) \(formattedNumber1)"
                
                let doublePrice11 = Double("\(self.dict_all_details["FinalFare"]!)")
                let formattedNumber11 = String(format: "%.2f", doublePrice11!)
                self.lbl_price.text = "\(str_bangladesh_currency_symbol) \(formattedNumber11)"
                
            } else {
                let a = Double("\(self.dict_all_details["last_cancel_amount"]!)")
                let b = Double("\(self.dict_all_details["FinalFare"]!)")
                let sum = a! + b!
                print(sum as Any)
                
                let doublePrice1 = Double("\(sum)")
                let formattedNumber1 = String(format: "%.2f", doublePrice1!)
                self.lbl_total.text = "\(str_bangladesh_currency_symbol) \(formattedNumber1)"
                
                let doublePrice11 = Double("\(sum)")
                let formattedNumber11 = String(format: "%.2f", doublePrice11!)
                self.lbl_price.text = "\(str_bangladesh_currency_symbol) \(formattedNumber11)"
            }
            
        } else {
            let a = Double("\(self.dict_all_details["Last_cancel_amount"]!)")
            let b = Double("\(self.dict_all_details["FinalFare"]!)")
            let sum = a! + b!
            print(sum as Any)
            
            let doublePrice1 = Double("\(sum)")
            let formattedNumber1 = String(format: "%.2f", doublePrice1!)
            self.lbl_total.text = "\(str_bangladesh_currency_symbol) \(formattedNumber1)"
            // self.lbl_total.text = "\(str_bangladesh_currency_symbol) \(sum)"
            
            
            self.lbl_price.text = "\(str_bangladesh_currency_symbol) \(formattedNumber1)"
        }
        
        
        self.lbl_booking_fees.text = "\(str_bangladesh_currency_symbol) \(self.dict_all_details["bookingFee"]!)"
        
        let cancellationFees:Double!
        
        if let amount = convertToDouble("\(self.dict_all_details["FinalFare"]!)"),
           let bookingFees = convertToDouble("\(self.dict_all_details["bookingFee"]!)") {
            
            if "\(self.dict_all_details["last_cancel_amount"]!)" == "" {
                 cancellationFees = convertToDouble("0.0")
            } else {
                 cancellationFees = convertToDouble("\(self.dict_all_details["last_cancel_amount"]!)")
            }
            
            let totalAmount = amount + bookingFees + cancellationFees!
            
            if "\(self.dict_all_details["promotional_discount"]!)" != "" {
                let pro_dis = convertToDouble("\(self.dict_all_details["promotional_discount"]!)")
                print(pro_dis as Any)
                let complete_cal = totalAmount - pro_dis!
                print("Complete cal: \(complete_cal)")
                
                let doublePrice11 = Double("\(complete_cal)")
                let formattedNumber11 = String(format: "%.2f", doublePrice11!)
                self.lbl_total.text = "\(str_bangladesh_currency_symbol) \(formattedNumber11)"
                
                self.lbl_price.text = "\(str_bangladesh_currency_symbol) \(formattedNumber11)"
                
                // also manage trip fare
                self.lbl_trip_fare.text = "\(str_bangladesh_currency_symbol) \(self.dict_all_details["FinalFare"]!)"
                
                let final_fare = convertToDouble("\(self.dict_all_details["FinalFare"]!)")
                print("Final fare: \(final_fare!)")
                
                let f_f_total = final_fare! - pro_dis!
                
                let doublePrice1 = Double("\(f_f_total)")
                let formattedNumber1 = String(format: "%.2f", doublePrice1!)
                self.lbl_trip_fare.text = "\(str_bangladesh_currency_symbol) \(formattedNumber1)"
                
                self.str_store_total_price = "\(complete_cal)"
                
            } else {
                
                self.str_store_total_price = "\(totalAmount)"
                
                let doublePrice1 = Double("\(totalAmount)")
                let formattedNumber1 = String(format: "%.2f", doublePrice1!)
                self.lbl_total.text = "\(str_bangladesh_currency_symbol) \(formattedNumber1)"
                
                self.lbl_price.text = "\(str_bangladesh_currency_symbol) \(formattedNumber1)"
            }
            
        } else {
            print("Invalid number format in one of the strings.")
        }
        
        
        self.lbl_previuos_cancel_fee.text = "\(str_bangladesh_currency_symbol) \(self.dict_all_details["last_cancel_amount"]!)"
        
        self.btn_cash.addTarget(self, action: #selector(cash_payment_WB), for: .touchUpInside)
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
    
    // MARK:- GET CUSTOMER LOCATION -
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        print(location)
        
        self.strSaveLatitude = "\(locValue.latitude)"
        self.strSaveLongitude = "\(locValue.longitude)"
        
        print("**********************")
        let customer_lat_long = "\(self.dict_all_details["RequestPickupLatLong"]!)".components(separatedBy: ",")
        print(customer_lat_long)
        
        let customer_lat_long2 = "\(self.dict_all_details["RequestDropLatLong"]!)".components(separatedBy: ",")
        print(customer_lat_long2)
        
        
        let restaurantLatitudeDouble    = Double(String(customer_lat_long[0]))
        let restaurantLongitudeDouble   = Double(String(customer_lat_long[1]))
        let driverLatitudeDouble        = Double(String(customer_lat_long2[0]))
        let driverLongitudeDouble       = Double(String(customer_lat_long2[1]))
        
        print(restaurantLatitudeDouble as Any)
        print(restaurantLongitudeDouble as Any)
        print(driverLatitudeDouble as Any)
        print(driverLongitudeDouble as Any)
        
        let coordinate₀ = CLLocation(latitude: restaurantLatitudeDouble!, longitude: restaurantLongitudeDouble!)
        let coordinate₁ = CLLocation(latitude: driverLatitudeDouble!, longitude: driverLongitudeDouble!)
        
        /************************************** CUSTOMER LATITUTDE AND LONGITUDE  ********************************/
        // first location
        let sourceLocation = CLLocationCoordinate2D(latitude: restaurantLatitudeDouble!, longitude: restaurantLongitudeDouble!)
        /********************************************************************************************************************/
        
        
        /************************************* DRIVER LATITUTDE AND LONGITUDE ******************************************/
        // second location
        let destinationLocation = CLLocationCoordinate2D(latitude: driverLatitudeDouble!, longitude: driverLongitudeDouble!)
        /********************************************************************************************************************/
        
        print(sourceLocation)
        print(destinationLocation)
        
        let sourcePin = customPin(pinTitle: "Drop Location", pinSubTitle: "", location: sourceLocation,image:UIImage(systemName: "car")!)
        
        let destinationPin = customPin(pinTitle: "Pick Location", pinSubTitle: "", location: destinationLocation,image:UIImage(systemName: "car")!)
        
        /***************** REMOVE PREVIUOS ANNOTATION TO GENERATE NEW ANNOTATION *******************************************/
        self.mapView.removeAnnotations(self.mapView.annotations)
        /********************************************************************************************************************/
        
        self.mapView.addAnnotation(sourcePin)
        self.mapView.addAnnotation(destinationPin)
        
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
            let overlays = self.mapView.overlays
            self.mapView.removeOverlays(overlays)
            /************************************************************************************/
            
            
            /***************** GET DISTANCE BETWEEN TWO CORDINATES *******************************/
            
            let distanceInMeters = coordinate₀.distance(from: coordinate₁)
            // print(distanceInMeters as Any)
            
            // remove decimal
            let distanceFloat: Double = (distanceInMeters as Any as! Double)
            
            // cell.lbl_distance.text = (String(format: "%.0f Miles away", distanceFloat/1609.344))
            
            print(String(format: "%.0f", distanceFloat/1000))
            // cell.lbl_distance.text = (String(format: "%.0f", distanceFloat/1000))
            
            print(String(format: "Distance : %.0f KM away", distanceFloat/1000))
            print(String(format: "Distance : %.0f Miles away", distanceFloat/1609.344))
            
            /************************************************************************/
            
            /***************** GENERATE NEW POLYLINE *******************************/
            
            let route = directionResonse.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            
            /***********************************************************************/
            
        }
        
        self.mapView.delegate = self
        
        self.locationManager.stopUpdatingLocation()
        
        // self.locationManager.startUpdatingLocation()
        
        // self.locManager.stopUpdatingLocation()
        
        print("=================================")
        print("LOCATION UPDATE")
        print("=================================")
        
        // self.tbleView.reloadData()
        
        // speed = distance / time
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.systemOrange
        renderer.lineWidth = 4.0
        return renderer
    }
    
    
    @objc func cash_payment_WB( ) {
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tbleView.cellForRow(at: indexPath) as! payment_table_cell
        
         
        /*if self.dict_all_details["Last_cancel_amount"] == nil {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "before_payment_id") as? before_payment
            
            push!.str_booking_id2 = "\(self.dict_all_details["bookingId"]!)"
            push!.str_get_total_price2 = "\(self.dict_all_details["FinalFare"]!)"
            push!.get_full_data_for_payment2 = self.dict_all_details
            
            self.navigationController?.pushViewController(push!, animated: true)
        } else {
            let a: Int? = Int("\(self.dict_all_details["Last_cancel_amount"]!)")
            let b: Int? = Int("\(self.dict_all_details["FinalFare"]!)")
            
            let sum:Int!
            
            sum = a! + b!
            
            // print(sum)
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "before_payment_id") as? before_payment
            
            push!.str_booking_id2 = "\(self.dict_all_details["bookingId"]!)"
            push!.str_get_total_price2 = "\(sum!)"
            push!.get_full_data_for_payment2 = self.dict_all_details
            
            self.navigationController?.pushViewController(push!, animated: true)
        }*/
        
        // new
        if self.dict_all_details["Last_cancel_amount"] == nil {
            
            if self.dict_all_details["last_cancel_amount"] == nil {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "before_payment_id") as? before_payment
                
                push!.str_booking_id2 = "\(self.dict_all_details["bookingId"]!)"
                push!.str_get_total_price2 = String(self.str_store_total_price)
                push!.get_full_data_for_payment2 = self.dict_all_details
                
                self.navigationController?.pushViewController(push!, animated: true)
                
            } else {
                let a = Double("\(self.dict_all_details["last_cancel_amount"]!)")
                let b = Double("\(self.dict_all_details["FinalFare"]!)")
                
                let sum:Double!
                
                sum = a! + b!
                
                // print(sum)
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "before_payment_id") as? before_payment
                
                push!.str_booking_id2 = "\(self.dict_all_details["bookingId"]!)"
                push!.str_get_total_price2 = String(self.str_store_total_price)
                push!.get_full_data_for_payment2 = self.dict_all_details
                
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
        } else {
            let a = Double("\(self.dict_all_details["Last_cancel_amount"]!)")
            let b = Double("\(self.dict_all_details["FinalFare"]!)")
            
            let sum:Double!
            
            sum = a! + b!
            
            // print(sum)
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "before_payment_id") as? before_payment
            
            push!.str_booking_id2 = "\(self.dict_all_details["bookingId"]!)"
            push!.str_get_total_price2 = String(self.str_store_total_price)
            push!.get_full_data_for_payment2 = self.dict_all_details
            
            self.navigationController?.pushViewController(push!, animated: true)
        }
        
        
        
        
        
        
            /*if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                } else {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "ড্রাইভার খোঁজা হচ্ছে")
                }
                
                
            }
         
        
        
        self.view.endEditing(true)
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            // var ar : NSArray!
            // ar = (person["carinfromation"] as! Array<Any>) as NSArray
            
            // let arr_mut_order_history:NSMutableArray! = []
            // arr_mut_order_history.addObjects(from: ar as! [Any])
            
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                print(token_id_is as Any)
                
                let headers: HTTPHeaders = [
                    "token":String(token_id_is),
                ]
                
                parameters = [
                    "action"        : "updatepayment",
                    "userId"        : String(myString),
                    "bookingId"     : "\(self.dict_all_details["bookingId"]!)",
                    "transactionId"  : String("cash_dummy_transaction_id"),
                    "totalAmount"   : "\(self.dict_all_details["FinalFare"]!)",
                    "TIP"           : String("0"),
                    "discountAmount"    : String(""),
                    "couponCode"    : String(""),
                    "paymentMethod" : String("Cash"),
                ]
                
                print(parameters as Any)
                
                AF.request(application_base_url, method: .post, parameters: parameters as? Parameters,headers: headers).responseJSON { [self]
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
                            
                            // self.back_click_method()
                            
                            self.navigationController?.popViewController(animated: true)
                            
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
        }*/
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
                    "role"      : "Driver"
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
                            
                            self.cash_payment_WB( )
                            
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
}
