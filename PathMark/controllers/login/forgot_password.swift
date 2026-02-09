import UIKit
import Alamofire

class ForgotPasswordVC: UIViewController {
    
    // MARK: - UI Elements -
    
    let headerView = UIView()
    let titleLabel = UILabel()
    let backButton = UIButton()
    
    let iconImageView = UIImageView()
    let resetLabel = UILabel()
    let descLabel = UILabel()
    
    let emailTextField = UITextField()
    let submitButton = UIButton()
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    }
    
    @objc func backTapped() {
        if let nav = navigationController {
            nav.popViewController(animated: true)
        }
        else {
            dismiss(animated: true)
        }
    }
    
    
    // MARK: - UI Setup -
    
    func setupUI() {
        view.backgroundColor = UIColor.black
        
        setupHeader()
        setupContent()
    }
    
    // MARK: - Header -
    
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
        gradient.colors = [
            lightGreenColor,
            darkGreenColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 110)
        headerView.layer.insertSublayer(gradient, at: 0)
        
        // Back Button
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white
        backButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(backButton)
        
        // Title
        titleLabel.text = "FORGOT PASSWORD"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            backButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -16),
            
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor)
        ])
    }
    
    // MARK: - Content -
    
    func setupContent() {
        
        iconImageView.image = UIImage(systemName: "lock.circle.fill")
        iconImageView.tintColor = UIColor.systemRed
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        resetLabel.text = "Reset Password"
        resetLabel.textColor = .white
        resetLabel.font = UIFont.boldSystemFont(ofSize: 20)
        resetLabel.textAlignment = .center
        resetLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descLabel.text = "Enter your email address and you will receive an OTP on your registered email ID to reset password."
        descLabel.textColor = .lightGray
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.numberOfLines = 0
        descLabel.textAlignment = .center
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailTextField.placeholder = "E-mail address"
        emailTextField.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        emailTextField.layer.cornerRadius = 8
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.setLeftPadding(12)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.backgroundColor = APP_BUTTON_COLOR
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 10
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(iconImageView)
        view.addSubview(resetLabel)
        view.addSubview(descLabel)
        view.addSubview(emailTextField)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40),
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 80),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            
            resetLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 16),
            resetLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            resetLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            descLabel.topAnchor.constraint(equalTo: resetLabel.bottomAnchor, constant: 12),
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            emailTextField.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 24),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            submitButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    @objc func submitTapped() {
        
        guard let email = emailTextField.text,
              !email.isEmpty else {
            showAlert("Please enter email address")
            return
        }
        
        if !isValidEmail(email) {
            showAlert("Please enter valid email")
            return
        }
        
        forgotPasswordAPI(email: email)
    }
    
    func forgotPasswordAPI(email: String) {
        
        self.show_loading_UI()
        
        var parameters:Dictionary<AnyHashable, Any>!

            parameters = [
                "action"        :   "forgotpassword",
                "email"         :   String(email),
            ]
        
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
                        self.hide_loading_UI()
                        let vc = SetNewPasswordVC()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else {
                        
                        self.hide_loading_UI()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"] as? String
                        
                        let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String(strSuccess2), style: .alert)
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                        
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
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
}

// MARK: - Padding Extension -

extension UITextField {
    func setLeftPadding(_ value: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: value, height: 0))
        leftView = paddingView
        leftViewMode = .always
    }
}
