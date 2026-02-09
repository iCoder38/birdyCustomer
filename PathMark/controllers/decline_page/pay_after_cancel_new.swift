import UIKit
import Alamofire

class PayAfterCancelNewVC: UIViewController, UITextFieldDelegate {

    var get_dict_booking_details:NSDictionary!
    var get_str_reason_select:String!
    var get_txt_view:String!
     
    // MARK: - UI

    let headerView = UIView()
    let titleLabel = UILabel()
    let backButton = UIButton()

    let cardNumberTF = UITextField()
    let expiryMonthTF = UITextField()
    let expiryYearTF = UITextField()
    let cvvTF = UITextField()

    let payButton = UIButton()

    // MARK: - State

    var isAmexCard = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        payButton.addTarget(self, action: #selector(payTapped), for: .touchUpInside)

        cardNumberTF.delegate = self
        cvvTF.delegate = self
    }

    // MARK: - UI Setup -

    func setupUI() {
        view.backgroundColor = .black
        setupHeader()
        setupForm()
    }

    func setupHeader() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 110)
        ])

        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemOrange.cgColor, UIColor.systemYellow.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 110)
        headerView.layer.insertSublayer(gradient, at: 0)

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white
        backButton.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = "Payment $5"
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(backButton)
        headerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            backButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -16),

            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor)
        ])
    }

    func setupForm() {

        setupTextField(cardNumberTF, placeholder: "Card Number", keyboard: .numberPad)
        setupTextField(expiryMonthTF, placeholder: "MM", keyboard: .numberPad)
        setupTextField(expiryYearTF, placeholder: "YY", keyboard: .numberPad)
        setupTextField(cvvTF, placeholder: "CVV", keyboard: .numberPad, secure: true)

        let expiryStack = UIStackView(arrangedSubviews: [expiryMonthTF, expiryYearTF])
        expiryStack.axis = .horizontal
        expiryStack.spacing = 12
        expiryStack.distribution = .fillEqually
        expiryStack.translatesAutoresizingMaskIntoConstraints = false

        payButton.setTitle("PAY NOW", for: .normal)
        payButton.backgroundColor = .systemRed
        payButton.setTitleColor(.white, for: .normal)
        payButton.layer.cornerRadius = 10
        payButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        payButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(cardNumberTF)
        view.addSubview(expiryStack)
        view.addSubview(cvvTF)
        view.addSubview(payButton)

        NSLayoutConstraint.activate([
            cardNumberTF.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40),
            cardNumberTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            cardNumberTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            cardNumberTF.heightAnchor.constraint(equalToConstant: 50),

            expiryStack.topAnchor.constraint(equalTo: cardNumberTF.bottomAnchor, constant: 16),
            expiryStack.leadingAnchor.constraint(equalTo: cardNumberTF.leadingAnchor),
            expiryStack.trailingAnchor.constraint(equalTo: cardNumberTF.trailingAnchor),
            expiryStack.heightAnchor.constraint(equalToConstant: 50),

            cvvTF.topAnchor.constraint(equalTo: expiryStack.bottomAnchor, constant: 16),
            cvvTF.leadingAnchor.constraint(equalTo: cardNumberTF.leadingAnchor),
            cvvTF.trailingAnchor.constraint(equalTo: cardNumberTF.trailingAnchor),
            cvvTF.heightAnchor.constraint(equalToConstant: 50),

            payButton.topAnchor.constraint(equalTo: cvvTF.bottomAnchor, constant: 24),
            payButton.leadingAnchor.constraint(equalTo: cardNumberTF.leadingAnchor),
            payButton.trailingAnchor.constraint(equalTo: cardNumberTF.trailingAnchor),
            payButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func setupTextField(_ tf: UITextField,
                        placeholder: String,
                        keyboard: UIKeyboardType,
                        secure: Bool = false) {
        tf.placeholder = placeholder
        tf.keyboardType = keyboard
        tf.isSecureTextEntry = secure
        tf.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        tf.layer.cornerRadius = 8
        tf.setLeftPadding(12)
        tf.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Validation Logic

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        guard let text = textField.text else { return true }
        let newText = (text as NSString).replacingCharacters(in: range, with: string)

        if textField == cardNumberTF {
            isAmexCard = newText.hasPrefix("34") || newText.hasPrefix("37")
            let maxLength = isAmexCard ? 15 : 16
            return newText.count <= maxLength
        }

        if textField == cvvTF {
            let maxCVV = isAmexCard ? 4 : 3
            return newText.count <= maxCVV
        }

        return true
    }

    // MARK: - Actions

    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc func payTapped() {

        guard let card = cardNumberTF.text, !card.isEmpty,
              let cvv = cvvTF.text, !cvv.isEmpty else {
            showAlert("Please fill all details")
            return
        }

        if isAmexCard {
            if card.count != 15 || cvv.count != 4 {
                showAlert("Invalid AMEX card details")
                return
            }
        } else {
            if card.count != 16 || cvv.count != 3 {
                showAlert("Invalid card details")
                return
            }
        }

        // showAlert("Payment validated successfully")
        
        self.decline_ride_WB(str_show_loader: "yes")
    }

    @objc func decline_ride_WB(str_show_loader:String) {
         
        
         if let language = UserDefaults.standard.string(forKey: str_language_convert) {
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
                    "action"        : "ridecancel",
                    "userId"        : String(myString),
                    "bookingId"     : "\(self.get_dict_booking_details["bookingId"]!)",
                    "userType"      : String("Member"),
                    "cancelReason"  : String(self.get_str_reason_select),
                    "cancelComment" : String(self.get_txt_view),
                    "totalAmount"   : "5",
                    "transactionId" : "tok_dummy",
                    "language"      : "en",
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
                            
                            let alert = UIAlertController(
                                    title: "Alert",
                                    message: "Ride cancelled successfully.",
                                    preferredStyle: .alert
                                )

                                 
                                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                                    print("OK button clicked")
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

                                alert.addAction(okAction)

                                self.present(alert, animated: true)
                            
                            
                            
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
                            
                            self.decline_ride_WB(str_show_loader: "no")
                            
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
    func showAlert(_ msg: String) {
        let alert = UIAlertController(title: "Alert",
                                      message: msg,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
