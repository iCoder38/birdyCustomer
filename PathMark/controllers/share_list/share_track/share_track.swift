//
//  share_track.swift
//  PathMark
//
//  Created by Dishant Rajput on 23/11/23.
//

import UIKit
import Alamofire
import SDWebImage
// MARK:- LOCATION -
import CoreLocation
import MapKit
class share_track: UIViewController, CLLocationManagerDelegate , MKMapViewDelegate {

    var dict_get_all_shared_booking_details:NSDictionary!
    
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
            view_navigation_title.text = "Tracking"
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var btn_call:UIButton!
    @IBOutlet weak var btn_chat:UIButton!
    
    @IBOutlet weak var lbl_address_name:UILabel!
    
    @IBOutlet weak var lbl_to:UILabel! {
        didSet {
            lbl_to.textColor = .black
        }
    }
    @IBOutlet weak var lbl_from:UILabel! {
        didSet {
            lbl_from.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_vehicle_type:UILabel!
    @IBOutlet weak var lbl_vehicle_number:UILabel!
    
    @IBOutlet weak var lbl_type:UILabel!
    @IBOutlet weak var img_profile:UIImageView! {
        didSet {
            img_profile.layer.cornerRadius = 25
            img_profile.clipsToBounds = true
        }
    }
    @IBOutlet weak var img_car_profile:UIImageView! {
        didSet {
            img_car_profile.layer.cornerRadius = 25
            img_car_profile.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var view_bg:UIView! {
        didSet {
            view_bg.backgroundColor = .white
        }
    }
    
    // MARK:- SAVE LOCATION STRING -
    var strSaveLatitude:String! = ""
    var strSaveLongitude:String! = ""
    var strSaveCountryName:String!
    var strSaveLocalAddress:String!
    var strSaveLocality:String!
    var strSaveLocalAddressMini:String!
    var strSaveStateName:String!
    var strSaveZipcodeName:String!
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    @IBOutlet weak var mapView:MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.btn_back.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        self.parse_all_value()
    }
    
    @objc func parse_all_value() {
    
        
        
        print(self.dict_get_all_shared_booking_details as Any)
        
        if "\(self.dict_get_all_shared_booking_details["rideStatus"]!)" == "1" {
            self.lbl_address_name.text = (self.dict_get_all_shared_booking_details["fullName"] as! String)+"( Driver accepted )"
        } else if "\(self.dict_get_all_shared_booking_details["rideStatus"]!)" == "2" {
            self.lbl_address_name.text = (self.dict_get_all_shared_booking_details["fullName"] as! String)+"( Picked you up )"
        } else if "\(self.dict_get_all_shared_booking_details["rideStatus"]!)" == "3" {
            self.lbl_address_name.text = (self.dict_get_all_shared_booking_details["fullName"] as! String)+"( On the way )"
        } else {
            self.lbl_address_name.text = (self.dict_get_all_shared_booking_details["fullName"] as! String)+"( Driver accepted )"
        }
        
        
        
        self.lbl_from.text = (self.dict_get_all_shared_booking_details["RequestPickupAddress"] as! String)
        self.lbl_to.text = (self.dict_get_all_shared_booking_details["RequestDropAddress"] as! String)
        
        self.lbl_vehicle_type.text = (self.dict_get_all_shared_booking_details["car_name"] as! String)
        self.lbl_vehicle_number.text = (self.dict_get_all_shared_booking_details["vehicleNumber"] as! String)+"("+(self.dict_get_all_shared_booking_details["VehicleColor"] as! String)+")"
        
        self.lbl_type.text = "Driver's name : \(self.dict_get_all_shared_booking_details["driver_fullName"] as! String) - \(self.dict_get_all_shared_booking_details["driver_AVGRating"]!)"
        
        self.img_profile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        self.img_profile.sd_setImage(with: URL(string: (self.dict_get_all_shared_booking_details["car_image"] as! String)), placeholderImage: UIImage(named: "1024"))
        
        self.img_car_profile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        self.img_car_profile.sd_setImage(with: URL(string: (self.dict_get_all_shared_booking_details["driver_image"] as! String)), placeholderImage: UIImage(named: "1024"))
        
        self.btn_call.addTarget(self, action: #selector(call), for: .touchUpInside)
        
        
        self.iAmHereForLocationPermission()
    }
    
    @objc func call() {
        
        if let url = URL(string: "tel://\(self.dict_get_all_shared_booking_details["contactNumber"] as! String)") {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
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
        
        /*
         "Drivber_userId" = 107;
         FinalFare = 1;
         RequestDropAddress = "Morena, Madhya Pradesh 476001, India";
         RequestDropLatLong = "26.4947172,77.9940222";
         RequestPickupAddress = "65P6+J6P, Sheel Nagar, Gwalior, Madhya Pradesh 474008, India ";
         RequestPickupLatLong = "26.2363658,78.1608951";
         VehicleColor = red;
         bookingDate = "2023-11-09";
         bookingId = 59;
         bookingTime = "";
         "car_image" = "https://demo4.evirtualservices.net/pathmark/img/uploads/cars/1690351421_bike.png";
         "car_name" = "BIKE RIDE";
         contactNumber = 9999999999;
         device = Android;
         deviceToken = "";
         "driver_AVGRating" = 5;
         "driver_contactNumber" = 9966696666;
         "driver_email" = "driver@gmail.com";
         "driver_fullName" = ffgg;
         "driver_image" = "https://demo4.evirtualservices.net/pathmark/img/uploads/users/1699486400PLUDIN_1699454004466.png";
         "driver_zipCode" = "";
         email = "nik222@mailinator.com";
         estimatedPrice = "";
         fullName = nik;
         image = "https://demo4.evirtualservices.net/pathmark/img/uploads/users/1699486114PLUDIN_1699453804676.png";
         paymentMethod = Cash;
         paymentStatus = 1;
         rideStatus = 5;
         shareTo = 111;
         shreFrom = 106;
         totalAmount = 1;
         totalDistance = 1;
         transactionId = "Cash_1699884464892";
         vehicleNumber = hjjjj;
         vehicleType = 2;
         */
        
        print("**********************")
        
        let pickUp_lat_long = (self.dict_get_all_shared_booking_details["RequestPickupLatLong"] as! String)
        let drop_lat_long = (self.dict_get_all_shared_booking_details["RequestDropLatLong"] as! String)
        
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
            
//            cell.lbl_distance.text = (String(format: "%.0f Miles away", distanceFloat/1609.344))
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
        
        // self.locManager.stopUpdatingLocation()
        
         self.locManager.startUpdatingLocation()
        
        // self.locManager.stopUpdatingLocation()
        
        print("=================================")
        print("LOCATION UPDATE")
        print("=================================")
        
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
    
}
