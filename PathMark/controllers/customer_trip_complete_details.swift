//
//  customer_trip_complete_details.swift
//  PathMark
//
//  Created by Dishant Rajput on 07/01/26.
//

import UIKit
import SDWebImage
import Alamofire

class customer_trip_complete_details: UIViewController {
    
    var dict_get_booking_details:NSDictionary!
    //    var get_booking_details:NSDictionary!
    
    var str_home:String!
    var str_stars:String!
    var str_message:String!
    
    var str_user_id:String!
    var str_driver_id:String!
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            DispatchQueue.main.async {
                GradientViewHelper.apply(
                    to: self.navigationBar,
                    colors: [
                        UIColor(red: 255/255, green: 94/255, blue: 58/255, alpha: 1),
                        UIColor(red: 255/255, green: 185/255, blue: 0/255, alpha: 1)
                    ]
                )
            }
        }
    }
    
    @IBOutlet weak var view_header_first:UIView! {
        didSet {
            view_header_first.layer.cornerRadius = 6
            view_header_first.clipsToBounds = true
            view_header_first.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var view_location:UIView! {
        didSet {
            view_location.layer.cornerRadius = 6
            view_location.clipsToBounds = true
            view_location.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var view_trip_fare:UIView! {
        didSet {
            view_trip_fare.layer.cornerRadius = 6
            view_trip_fare.clipsToBounds = true
            view_trip_fare.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var view_driver_info:UIView! {
        didSet {
            view_driver_info.layer.cornerRadius = 6
            view_driver_info.clipsToBounds = true
            view_driver_info.backgroundColor = .white
        }
    }
    
    // MARK: REVIEW
    @IBOutlet weak var view_review:UIView! {
        didSet {
            view_review.layer.cornerRadius = 6
            view_review.clipsToBounds = true
            view_review.backgroundColor = .white
            view_review.isHidden = true
        }
    }
    @IBOutlet weak var btn_review:UIButton! {
        didSet {
            btn_review.layer.cornerRadius = 6
            btn_review.clipsToBounds = true
        }
    }
    @IBOutlet weak var lbl_total_review:UILabel! {
        didSet {
            lbl_total_review.textColor = .black
        }
    }
    
    @IBOutlet weak var img_driver:UIImageView! {
        didSet {
            img_driver.layer.cornerRadius = 20
            img_driver.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lbl_driver_name:UILabel! {
        didSet {
            lbl_driver_name.textColor = .black
        }
    }
    @IBOutlet weak var lbl_driver_number:UILabel! {
        didSet {
            lbl_driver_number.textColor = .black
        }
    }
    @IBOutlet weak var lbl_driver_car:UILabel! {
        didSet {
            lbl_driver_car.textColor = .black
        }
    }
    
    // MARK: DESTINATION
    @IBOutlet weak var lbl_destination_from:UILabel! {
        didSet {
            lbl_destination_from.textColor = .black
        }
    }
    @IBOutlet weak var lbl_destination_to:UILabel! {
        didSet {
            lbl_destination_to.textColor = .black
        }
    }
    
    // MARK: TRIP
    @IBOutlet weak var lbl_trip_fare:UILabel! {
        didSet {
            lbl_trip_fare.textColor = .black
        }
    }
    @IBOutlet weak var lbl_trip_amount:UILabel! {
        didSet {
            lbl_trip_amount.textColor = .black
        }
    }
    
    // MARK: HEADER
    @IBOutlet weak var lbl_header_fare:UILabel! {
        didSet {
            lbl_header_fare.textColor = .black
        }
    }
    @IBOutlet weak var lbl_header_distance:UILabel! {
        didSet {
            lbl_header_distance.textColor = .black
        }
    }
    
    // MARK: STARS
    @IBOutlet weak var btn_star_one:UIButton!
    @IBOutlet weak var btn_star_two:UIButton!
    @IBOutlet weak var btn_star_three:UIButton!
    @IBOutlet weak var btn_star_four:UIButton!
    @IBOutlet weak var btn_star_five:UIButton!
    
    @IBOutlet weak var btn_back:UIButton!
    @IBOutlet weak var btn_home:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.str_home == "yes") {
            self.btn_back.isUserInteractionEnabled = true
            self.btn_back.isEnabled = true
            self.btn_back.setImage(UIImage(systemName: "house"), for: .normal)
            self.btn_back.addTarget(self, action: #selector(home_click_method), for: .touchUpInside)
            self.btn_back.isHidden = true
            self.btn_home.addTarget(self, action: #selector(home_click_method), for: .touchUpInside)
        } else {
            self.btn_home.isHidden = true
            self.btn_back.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        }
        
        self.view.backgroundColor = .black
        
        self.booking_history_details_WB(str_show_loader: "yes" )
    }
    
    @objc func home_click_method() {
        var window: UIWindow?
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationController = storyboard.instantiateViewController(withIdentifier:"dashboard_id") as? dashboard
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
    
    @objc func booking_history_details_WB(str_show_loader:String) {
        
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
                    "action"        : "bookingdetail",
                    "bookingId"     : "\(self.self.dict_get_booking_details["bookingId"]!)",
                    "userId"        : String(myString),
                    "language"      : String(lan),
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
                            
                            var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            print(dict as Any)
                            
                            self.str_user_id = "\(dict["userId"]!)"
                            self.str_driver_id = "\(dict["driverId"]!)"
                            
                            self.lbl_trip_fare.text = "$\(dict["estimatedPrice"]!)"
                            self.lbl_trip_amount.text = "$\(dict["estimatedPrice"]!)"
                            
                            self.lbl_destination_to.text = "\(dict["RequestPickupAddress"]!)"
                            self.lbl_destination_from.text = "\(dict["Actual_Drop_Address"]!)"
                            
                            // DRIVER NAME
                            self.lbl_driver_name.text = "\(dict["driverName"]!)"
                            self.lbl_driver_number.text = "\(dict["driverPhone"]!)"
                            self.lbl_driver_car.text = "\(dict["CarName"]!) (\(dict["VehicleColor"]!))"
                            
                            // rating
                            self.updateStars(rating: "\(dict["driverRating"]!)")
                            
                            self.img_driver.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
                            self.img_driver.sd_setImage(with: URL(string: "\(dict["driverRating"]!)"), placeholderImage: UIImage(named: "logo"))
                            
                            // header
                            self.lbl_header_fare.text = "$\(dict["estimatedPrice"]!)"
                            self.lbl_header_distance.text = "\(dict["totalDistance"]!) KM"
                            
                            // review
                            if ("\(dict["bookingrating"]!)" == "0") {
                                self.view_review.isHidden = false
                                self.btn_review.addTarget(self, action: #selector(open_review_popup), for: .touchUpInside)
                            } else {
                                self.view_review.isHidden = true
                            }
                            
                            self.lbl_total_review.text = "(\(dict["driverRating"]!) / 5)"
                            
                            
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
                            
                            self.booking_history_details_WB(str_show_loader: "no")
                            
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
    
    @objc func open_review_popup() {
        let popup = ReviewPopupViewController()
        popup.modalPresentationStyle = .overFullScreen
        
        popup.onSubmit = { [weak self] rating, review in
            guard let self = self else { return }
            
            self.str_stars = "\(rating)"
            self.str_message = review
            self.submit_review_WB()
        }
        
        present(popup, animated: true)
    }
    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    @objc func submit_review_WB() {
        
        
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
                    "action"        : "submitreview",
                    "bookingId"     : "\(self.dict_get_booking_details["bookingId"]!)",
                    "reviewFrom"    : String(self.str_user_id),
                    "reviewTo"      : String(self.str_driver_id),
                    "star"          : String(self.str_stars),
                    "message"       : String(self.str_message),
                    "language"      : String(lan),
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
                            
                            self.booking_history_details_WB(str_show_loader: "no")
                            
                        } else if message == String(not_authorize_api) {
                            self.login_refresh_token_wb3()
                            
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
    
    
    
    @objc func login_refresh_token_wb3() {
        
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
                            
                            self.submit_review_WB()
                            
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
    func updateStars(rating: Any) {
        
        var ratingValue: Double = 0
        
        if let intValue = rating as? Int {
            ratingValue = Double(intValue)
        } else if let doubleValue = rating as? Double {
            ratingValue = doubleValue
        } else if let stringValue = rating as? String {
            ratingValue = Double(stringValue) ?? 0
        }
        
        let stars = [
            btn_star_one,
            btn_star_two,
            btn_star_three,
            btn_star_four,
            btn_star_five
        ]
        
        for (index, button) in stars.enumerated() {
            let starIndex = Double(index + 1)
            
            if ratingValue >= starIndex {
                // ⭐ Full star
                button?.setImage(UIImage(systemName: "star.fill"), for: .normal)
                button?.tintColor = .systemOrange
                
            } else if ratingValue >= starIndex - 0.5 {
                // ⭐ Half star (optional)
                button?.setImage(UIImage(systemName: "star.leadinghalf.filled"), for: .normal)
                button?.tintColor = .systemOrange
                
            } else {
                // ⭐ Empty star
                button?.setImage(UIImage(systemName: "star"), for: .normal)
                button?.tintColor = .systemGray3
            }
        }
    }
    
    
}


// MARK: REVIEW POPUP
import UIKit

final class StarRatingView: UIView {

    private var buttons: [UIButton] = []
    var rating: Double = 0 {
        didSet { updateUI() }
    }

    var onRatingChanged: ((Double) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        for i in 1...5 {
            let btn = UIButton(type: .system)
            btn.tag = i
            btn.setImage(UIImage(systemName: "star"), for: .normal)
            btn.tintColor = .systemYellow
            btn.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
            buttons.append(btn)
            stack.addArrangedSubview(btn)
        }
    }

    @objc private func starTapped(_ sender: UIButton) {
        rating = Double(sender.tag)
        onRatingChanged?(rating)
    }

    private func updateUI() {
        for btn in buttons {
            btn.setImage(
                UIImage(systemName: btn.tag <= Int(rating) ? "star.fill" : "star"),
                for: .normal
            )
        }
    }
}

final class ReviewPopupViewController: UIViewController {

    // MARK: - UI
    private let container = UIView()
    private let starView = StarRatingView()
    private let textView = UITextView()
    private let submitBtn = UIButton(type: .system)
    private let cancelBtn = UIButton(type: .system)

    // MARK: - Data
    private(set) var rating: Double = 1
    private(set) var reviewText: String = ""

    var onSubmit: ((Double, String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }

    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        container.backgroundColor = .systemBackground
        container.layer.cornerRadius = 16

        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.widthAnchor.constraint(equalToConstant: 300)
        ])

        // Star View
        starView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(starView)

        // Text View
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.cornerRadius = 8
        textView.font = .systemFont(ofSize: 14)
        container.addSubview(textView)

        // Buttons
        submitBtn.setTitle("Submit Review", for: .normal)
        cancelBtn.setTitle("Dismiss", for: .normal)

        let btnStack = UIStackView(arrangedSubviews: [cancelBtn, submitBtn])
        btnStack.axis = .horizontal
        btnStack.distribution = .fillEqually
        btnStack.spacing = 12
        container.addSubview(btnStack)

        // Layout
        starView.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
        starView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        starView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        starView.widthAnchor.constraint(equalToConstant: 200).isActive = true

        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: starView.bottomAnchor, constant: 12),
            textView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            textView.heightAnchor.constraint(equalToConstant: 100)
        ])

        btnStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btnStack.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            btnStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            btnStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            btnStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
        ])
    }

    private func setupActions() {
        starView.onRatingChanged = { [weak self] value in
            self?.rating = value
        }

        cancelBtn.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
        submitBtn.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    }

    @objc private func dismissPopup() {
        dismiss(animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func submitTapped() {

        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)

        // ⭐ Validation INSIDE POPUP
        /*if rating < 5 && text.isEmpty {
            self.showAlert(
                title: "Write a Review",
                message: "Please write a review if rating is less than 5 stars."
            )
            return
        }*/

        reviewText = text
        onSubmit?(rating, reviewText)
        dismiss(animated: true)
    }


}

