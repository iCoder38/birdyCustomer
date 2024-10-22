//
//  select_vehicle.swift
//  PathMark
//
//  Created by Dishant Rajput on 28/08/24.
//

import UIKit
import GoogleMaps

class select_vehicle: UIViewController {
    
    var userCurrentLocationIs:String!
    
    @IBOutlet weak var overlayView: UIView! {
        didSet {
            overlayView.backgroundColor = .white
            overlayView.layer.masksToBounds = false
            overlayView.layer.shadowColor = UIColor.black.cgColor
            overlayView.layer.shadowOffset =  CGSize.zero
            overlayView.layer.shadowOpacity = 0.5
            overlayView.layer.shadowRadius = 2
            overlayView.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var btn_search_up:UIButton!
    @IBOutlet weak var btn_search_down:UIButton!
    
    @IBOutlet weak var txt_destination_up:UITextField!  {
        didSet {
            txt_destination_up.placeholder = "To"
        }
    }
    @IBOutlet weak var txt_destination_down:UITextField! {
        didSet {
            txt_destination_down.placeholder = "Destination"
        }
    }
    
    @IBOutlet weak var view_navigation_bar:UIView! {
        didSet {
            view_navigation_bar.applyGradient()
        }
    }
    
    @IBOutlet weak var btn_back:UIButton! {
        didSet {
            btn_back.tintColor = .white
            btn_back.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var view_navigation_title:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    view_navigation_title.text = "SELECT VEHICLE"
                } else {
                    view_navigation_title.text = "বাহন নির্বাচন করুন"
                }
                
            }
            
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var tbleView:UITableView! {
        didSet {
            tbleView.backgroundColor = .clear
        }
    }
    
    // google maps
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // automatic dedected location from device
        self.txt_destination_up.text = String(self.userCurrentLocationIs)
        
        self.btn_search_up.addTarget(self, action: #selector(buttonUpClickMethod), for: .touchUpInside)
        initializeMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        debugPrint("called")
    }
    
    func initializeMap() {
        // Create and configure the mapView
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 10.0)
        mapView = GMSMapView(frame: .zero)
        mapView.camera = camera
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        // Set up constraints for mapView
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Ensure overlayView is added after mapView so it's on top
        view.bringSubviewToFront(view_navigation_bar)
        view.bringSubviewToFront(overlayView)
        
        // Configure the overlayView if needed
        // overlayView.backgroundColor = UIColor.white.withAlphaComponent(0.7) // Semi-transparent background
        // setupOverlayView()
        
        let placeACoordinate = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20) // Example coordinates for Place A
        let placeBCoordinate = CLLocationCoordinate2D(latitude: -33.80, longitude: 151.15) // Example coordinates for Place B
        
        addMarker(at: placeACoordinate, title: "Place A", snippet: "This is Place A")
        addMarker(at: placeBCoordinate, title: "Place B", snippet: "This is Place B")
        
        fetchRoute(from: placeACoordinate, to: placeBCoordinate)
    }
    
    @objc func buttonUpClickMethod() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "search_location_id") as? search_location
        self.navigationController?.pushViewController(push!, animated: true)
       
    }
    
    func addMarker(at position: CLLocationCoordinate2D, title: String, snippet: String) {
        let marker = GMSMarker()
        marker.position = position
        marker.title = title
        marker.snippet = snippet
        marker.map = mapView
    }
    
    func fetchRoute(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) {
        let origin = "\(start.latitude),\(start.longitude)"
        let destination = "\(end.latitude),\(end.longitude)"
        let apiKey = GOOGLE_MAP_API
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
        let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0) // Adjust padding as needed
        mapView.animate(with: update)
    }
    
}
