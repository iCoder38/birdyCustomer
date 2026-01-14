import UIKit

class SetNewPasswordVC: UIViewController {

    // MARK: - UI Elements

    let headerView = UIView()
    let titleLabel = UILabel()
    let backButton = UIButton()

    let iconImageView = UIImageView()
    let mainLabel = UILabel()
    let descLabel = UILabel()

    let otpTextField = UITextField()
    let passwordTextField = UITextField()
    let confirmPasswordTextField = UITextField()

    let changePasswordButton = UIButton()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        changePasswordButton.addTarget(self,
                                       action: #selector(changePasswordTapped),
                                       for: .touchUpInside)
    }

    // MARK: - UI Setup

    func setupUI() {
        view.backgroundColor = .black
        setupHeader()
        setupContent()
    }

    // MARK: - Header

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
            UIColor.systemOrange.cgColor,
            UIColor.systemYellow.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.frame = CGRect(x: 0, y: 0,
                                width: UIScreen.main.bounds.width,
                                height: 110)
        headerView.layer.insertSublayer(gradient, at: 0)

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white
        backButton.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = "SET NEW PASSWORD"
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

    // MARK: - Content

    func setupContent() {

        iconImageView.image = UIImage(systemName: "lock.circle.fill")
        iconImageView.tintColor = .systemRed
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        mainLabel.text = "Enter your password"
        mainLabel.textColor = .white
        mainLabel.font = .boldSystemFont(ofSize: 20)
        mainLabel.textAlignment = .center
        mainLabel.translatesAutoresizingMaskIntoConstraints = false

        descLabel.text = "Please enter the OTP you have received in your registered phone number and email ID to reset new password."
        descLabel.textColor = .lightGray
        descLabel.font = .systemFont(ofSize: 14)
        descLabel.numberOfLines = 0
        descLabel.textAlignment = .center
        descLabel.translatesAutoresizingMaskIntoConstraints = false

        setupTextField(otpTextField, placeholder: "Enter OTP", secure: false)
        setupTextField(passwordTextField, placeholder: "Password", secure: true)
        setupTextField(confirmPasswordTextField, placeholder: "Confirm password", secure: true)

        changePasswordButton.setTitle("CHANGE PASSWORD", for: .normal)
        changePasswordButton.backgroundColor = .systemRed
        changePasswordButton.setTitleColor(.white, for: .normal)
        changePasswordButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        changePasswordButton.layer.cornerRadius = 10
        changePasswordButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(iconImageView)
        view.addSubview(mainLabel)
        view.addSubview(descLabel)
        view.addSubview(otpTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(changePasswordButton)

        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 30),
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 80),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),

            mainLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 16),
            mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            descLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 10),
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            otpTextField.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 20),
            otpTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            otpTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            otpTextField.heightAnchor.constraint(equalToConstant: 48),

            passwordTextField.topAnchor.constraint(equalTo: otpTextField.bottomAnchor, constant: 12),
            passwordTextField.leadingAnchor.constraint(equalTo: otpTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: otpTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),

            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 12),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: otpTextField.leadingAnchor),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: otpTextField.trailingAnchor),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 48),

            changePasswordButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 20),
            changePasswordButton.leadingAnchor.constraint(equalTo: otpTextField.leadingAnchor),
            changePasswordButton.trailingAnchor.constraint(equalTo: otpTextField.trailingAnchor),
            changePasswordButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Helpers

    func setupTextField(_ tf: UITextField, placeholder: String, secure: Bool) {
        tf.placeholder = placeholder
        tf.isSecureTextEntry = secure
        tf.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        tf.layer.cornerRadius = 8
        tf.setLeftPadding(12)
        tf.translatesAutoresizingMaskIntoConstraints = false

        let lock = UIImageView(image: UIImage(systemName: "lock"))
        lock.tintColor = .gray
        tf.rightView = lock
        tf.rightViewMode = .always
    }

    // MARK: - Actions

    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc func changePasswordTapped() {
        print("CHANGE PASSWORD API HIT HERE")
        // 👉 yahin API lagani hai
    }
}
