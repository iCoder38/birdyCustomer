import UIKit
import Alamofire

// MARK: - Delegate -
protocol FullScreenPopupDelegate: AnyObject {
    func didSelectCard(_ card: [String: Any])
}

// MARK: - ViewController -
class FullScreenPopupViewController: UIViewController,
                                     UITableViewDelegate,
                                     UITableViewDataSource {

    var arrCardList: NSMutableArray = []
    private let tableView = UITableView()
    private var selectedCardIndex: Int?

    weak var delegate: FullScreenPopupDelegate?

    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        fetchCardList()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Gradient background (same as Saved Card button)
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            GradientViewHelper.apply(
//                to: self.view,
//                colors: [
//                    UIColor(red: 255/255, green: 94/255, blue: 58/255, alpha: 1),
//                    UIColor(red: 255/255, green: 185/255, blue: 0/255, alpha: 1)
//                ]
//            )
//        }
        self.view.backgroundColor = .black
    }

    // MARK: - UI Setup -
    private func setupView() {
        view.backgroundColor = .clear
        navigationItem.title = "Saved Cards"

        let closeButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(dismissPopup)
        )
        closeButton.tintColor = .white
        navigationItem.rightBarButtonItem = closeButton

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }

    @objc private func dismissPopup() {
        dismiss(animated: true)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CardTableViewCell.self,
                           forCellReuseIdentifier: "CardCell")

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - API -
    private func fetchCardList() {
        cardListWB(str_show_loader: "yes")
    }

    @objc func cardListWB(str_show_loader: String) {

        if str_show_loader == "yes" {
            ERProgressHud.sharedInstance.showDarkBackgroundView(
                withTitle: "Please wait..."
            )
        }

        self.view.endEditing(true)

        if let person = UserDefaults.standard.value(
            forKey: str_save_login_user_data
        ) as? [String: Any],
           let userId = person["userId"] as? Int,
           let token = UserDefaults.standard.string(
            forKey: str_save_last_api_token
           ) {

            let headers: HTTPHeaders = ["token": token]

            let parameters: Parameters = [
                "action": "cardlist",
                "userId": "\(userId)"
            ]

            AF.request(application_base_url,
                       method: .post,
                       parameters: parameters,
                       headers: headers)
            .responseJSON { response in

                ERProgressHud.sharedInstance.hide()

                switch response.result {
                case .success(let value):

                    guard let json = value as? NSDictionary else { return }

                    let status = (json["status"] as? String)?.lowercased()

                    if status == "success" {

                        if let authToken = json["AuthToken"] as? String {
                            UserDefaults.standard.set(
                                authToken,
                                forKey: str_save_last_api_token
                            )
                        }

                        if let data = json["data"] as? [[String: Any]] {
                            self.arrCardList.removeAllObjects()
                            self.arrCardList.addObjects(from: data)
                            self.tableView.reloadData()
                        }

                    } else {
                        let msg = json["msg"] as? String ?? "Something went wrong"
                        self.showAlert(title: "Alert", message: msg)
                    }

                case .failure:
                    self.please_check_your_internet_connection()
                }
            }
        }
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        arrCardList.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CardCell",
            for: indexPath
        ) as! CardTableViewCell

        let item = arrCardList[indexPath.row] as! [String: Any]
        cell.configure(
            with: item,
            isSelected: selectedCardIndex == indexPath.row
        )

        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

        selectedCardIndex = indexPath.row
        tableView.reloadData()

        if let card = arrCardList[indexPath.row] as? [String: Any] {
            delegate?.didSelectCard(card)
        }
    }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    // MARK: - Helpers
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Cell
class CardTableViewCell: UITableViewCell {

    private let titleLabel = UILabel()
    private let checkboxImageView = UIImageView()
    private let containerView = UIView()

    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {

        backgroundColor = .clear
        contentView.backgroundColor = .clear

        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)

        checkboxImageView.contentMode = .scaleAspectFit
        checkboxImageView.tintColor = .systemOrange

        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            checkboxImageView
        ])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(stack)
        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            containerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            containerView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 8
            ),
            containerView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -8
            ),

            stack.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: 16
            ),
            stack.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -16
            ),
            stack.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: 16
            ),
            stack.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor,
                constant: -16
            ),

            checkboxImageView.widthAnchor.constraint(equalToConstant: 24),
            checkboxImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    func configure(with data: [String: Any], isSelected: Bool) {
        let cardNo = data["c_no"] ?? ""
        let expM = data["exp_m"] ?? ""
        let expY = data["exp_y"] ?? ""

        titleLabel.text = "•••• \(cardNo)\nExpiry: \(expM)/\(expY)"
        checkboxImageView.image = UIImage(
            systemName: isSelected
            ? "checkmark.square.fill"
            : "square"
        )
    }
}
