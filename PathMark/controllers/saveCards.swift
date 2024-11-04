import UIKit
import Alamofire

// Protocol to notify the main view controller about the selected card
protocol FullScreenPopupDelegate: AnyObject {
    func didSelectCard(_ card: [String: Any])
}

// Full-Screen Popup ViewController
class FullScreenPopupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arrCardList: NSMutableArray! = []
    private let tableView = UITableView()
    private var selectedCardIndex: Int? // Track only one selected card index
    
    // Delegate property to notify the previous screen
    weak var delegate: FullScreenPopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        fetchCardList() // Call API or load data
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.title = "Select a Card"
        
        // Add a close button in the top-right corner to dismiss the view
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissPopup))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func dismissPopup() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CardTableViewCell.self, forCellReuseIdentifier: "CardCell") // Register custom cell
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchCardList() {
        cardListWB(str_show_loader: "yes")
    }
    
    @objc func cardListWB(str_show_loader: String) {
        if str_show_loader == "yes" {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        }
        
        self.view.endEditing(true)
        
        var parameters: Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String: Any] {
            let userId = person["userId"] as! Int
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                let headers: HTTPHeaders = ["token": String(token_id_is)]
                
                parameters = [
                    "action": "cardlist",
                    "userId": String(userId)
                ]
                
                AF.request(application_base_url, method: .post, parameters: parameters as? Parameters, headers: headers).responseJSON { [self] response in
                    switch response.result {
                    case .success(let value):
                        let JSON = value as! NSDictionary
                        let status = (JSON["status"] as? String)?.lowercased()
                        
                        if status == "success" {
                            let authToken = JSON["AuthToken"] as! String
                            UserDefaults.standard.set(authToken, forKey: str_save_last_api_token)
                            
                            if let data = JSON["data"] as? [[String: Any]] {
                                arrCardList.addObjects(from: data)
                                self.tableView.reloadData()
                            }
                            ERProgressHud.sharedInstance.hide()
                        } else {
                            let message = JSON["msg"] as? String ?? "Unknown error"
                            self.showAlert(title: "Alert", message: message)
                            ERProgressHud.sharedInstance.hide()
                        }
                    case .failure(_):
                        self.please_check_your_internet_connection()
                        ERProgressHud.sharedInstance.hide()
                    }
                }
            }
        }
    }
    
    // MARK: - TableView DataSource -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardTableViewCell
        let item = arrCardList[indexPath.row] as! [String: Any]
        
        cell.configure(with: item, isSelected: selectedCardIndex == indexPath.row)
        return cell
    }
    
    // MARK: - TableView Delegate -
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Update selected card index and reload
        if selectedCardIndex != indexPath.row {
            selectedCardIndex = indexPath.row
            tableView.reloadData()
        }
        
        // Pass the selected card to the delegate and dismiss the view
        if let selectedCard = arrCardList[indexPath.row] as? [String: Any] {
            delegate?.didSelectCard(selectedCard)
            // dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // Helper function to show alert
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
//    private func please_check_your_internet_connection() {
//        showAlert(title: "Error", message: "Please check your internet connection.")
//    }
}

// Custom TableViewCell with Checkbox
class CardTableViewCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let checkboxImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        titleLabel.numberOfLines = 0
        checkboxImageView.contentMode = .scaleAspectFit
        checkboxImageView.image = UIImage(systemName: "square") // Default unselected
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, checkboxImageView])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            checkboxImageView.widthAnchor.constraint(equalToConstant: 24),
            checkboxImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(with data: [String: Any], isSelected: Bool) {
        titleLabel.text = "- \(data["c_no"]!) \n- \(data["exp_m"]!)/\(data["exp_y"]!)"
        checkboxImageView.image = UIImage(systemName: isSelected ? "checkmark.square" : "square")
    }
}

