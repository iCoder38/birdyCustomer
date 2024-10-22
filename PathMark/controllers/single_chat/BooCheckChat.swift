//
//  BooCheckChat.swift
//  BooCheck
//
//  Created by apple on 01/04/21.
//

import UIKit
import GrowingTextView
import Firebase
import FirebaseStorage
import SDWebImage
import Alamofire

import FirebaseDatabase

// sam //

class BooCheckChat: UIViewController, MessagingDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var str_back_home:String!
    
    var get_all_data:NSDictionary!
    
    var str_sender_id:String!
    var str_get_user_id:String!
    
    // ***************************************************************** // nav
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = navigation_color
        }
    }
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .white
        }
    }
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "CHAT"
            // lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
        }
    }
    // ***************************************************************** // nav
    
    // let dict : [String : Any] = UserDefaults.standard.dictionary(forKey: "kAPI_LOGIN_DATA") ?? [:] //
    
    let cellReuseIdentifier = "cuckooChatCTableCell"
    
    var fromDialog:String!
    var receiverIdFromDialog:String!
    var receiverNameFromDialog:String!
    var receiverImageFromDialog:String!
    
    // MARK:- mutable array set up -
    var chatMessages:NSMutableArray = []
    
    var strLoginUserId:String!
    var strLoginUserName:String!
    var strLoginUserImage:String!
    
    var strReceiptId:String!
    var strReceiptImage:String!
    
    var imageStr1:String!
    var imgData1:Data!
    
    var uploadImageForChatURL:String!
    var chatChannelName:String!
    var receiverData:NSDictionary!
    //    var receiverData : [String :Any] = [:]
    
    
    
    var strSenderDevice:String! = "0"
    var strSenderDeviceToken:String! = "0"
    
    var strReceiverDevice:String! = "0"
    var strReceiverDeviceToken:String! = "0"
    
    
    
    
    var strSaveLastMessage:String!
    
    // for chat
    var str_driver_id:String!
    var str_booking_id:String!
    
    @IBOutlet weak var uploadingImageView:UIView! {
        didSet {
            //  uploadingImageView.backgroundColor = APP_BASIC_COLOR
            uploadingImageView.isHidden = true
        }
    }
    
    @IBOutlet weak var indicators:UIActivityIndicatorView! {
        didSet {
            indicators.color = .white
        }
    }
    
    @IBOutlet weak var lblProcessingImage:UILabel! {
        didSet {
            lblProcessingImage.textColor = .white
            lblProcessingImage.text = "processing..."
        }
    }
    
    @IBOutlet weak var inputToolbar: UIView! {
        didSet {
            inputToolbar.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imgReceiverProfilePicture:UIImageView! {
        didSet {
            imgReceiverProfilePicture.layer.cornerRadius = 20
            imgReceiverProfilePicture.clipsToBounds = true
            imgReceiverProfilePicture.layer.borderWidth = 0.5
            imgReceiverProfilePicture.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    // MARK:- TABLE VIEW -
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            self.tbleView.delegate = self
            self.tbleView.dataSource = self
            self.tbleView.backgroundColor = .clear // UIColor.init(red: 244.0/255.0, green: 246.0/255.0, blue: 248.0/255.0, alpha: 1)
            self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    @IBOutlet weak var btnSendMessage:UIButton! {
        didSet {
            btnSendMessage.tintColor = .white
        }
    }
    
    @IBOutlet weak var btnAttachment:UIButton! {
        didSet {
            btnAttachment.tintColor = .white
        }
    }
    
    
    
    
    @IBOutlet weak var btnPhone:UIButton! {
        didSet {
            btnPhone.isHidden = true
        }
    }
    @IBOutlet weak var btnVideoCall:UIButton! {
        didSet {
            btnVideoCall.isHidden = true
        }
    }
    
    var friendDeviceToken:String!
    
    
    
    
    var receiverNameIs:String!
    
    var room_id:String!
    var reverse_room_id:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print(receiverData as Any)
        
        
        self.imageStr1 = "0"
        self.uploadImageForChatURL = ""
        
        
        
        self.btnSendMessage.addTarget(self, action: #selector(sendMessageWithoutAttachment), for: .touchUpInside)
        self.btnAttachment.addTarget(self, action: #selector(cellTappedMethod1), for: .touchUpInside)
        
        
        
        print(self.get_all_data as Any)
        
        
        if (self.str_back_home == "home") {
            
            
            self.btnBack.addTarget(self, action: #selector(home_click_method), for: .touchUpInside)
        } else {
            self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
        
        
        // *** Customize GrowingTextView ***
        textView.layer.cornerRadius = 4.0
        
        // *** Listen to keyboard show / hide ***
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // *** Hide keyboard when tapping outside ***
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGesture)
        
        /*
         var strSenderDevice:String! = "0"
         var strSenderDeviceToken:String! = "0"
         
         var strReceiverDevice:String! = "0"
         var strReceiverDeviceToken:String! = "0"
         */
        
        // print(self.receiverData as Any)
        
        
        /*if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // let str:String = person["role"] as! String
             print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            self.strLoginUserId = String(myString)
            
            self.strLoginUserName = (person["fullName"] as! String)
            self.strLoginUserImage = (person["image"] as! String)
            
            self.strSenderDevice = (person["device"] as! String)
            self.strSenderDeviceToken = (person["deviceToken"] as! String)
        }
        
        print(self.receiverData as Any)*/
        
        /*if self.fromDialog == "yes" {
            self.yesFromDialog()
        } else {
            self.notFromDialog()
        }*/
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            // let str:String = person["role"] as! String
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            self.str_sender_id = String(myString)
            self.strLoginUserId = String(myString)
            
            self.strLoginUserName = (person["fullName"] as! String)
            
            /*print(self.str_sender_id as Any)
            print(self.str_get_user_id as Any)
            
            print(self.str_driver_id as Any)
            print(self.str_booking_id as Any)*/
            
            // self.room_id = String(self.str_booking_id)+"+"+String(self.str_driver_id)
            self.room_id = String(self.str_booking_id)
            //print(self.room_id as Any)
            
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // print(self.str_sender_id as Any)
        // print(self.str_get_user_id as Any)
        print(self.room_id as Any)
        // print(self.reverse_room_id as Any)
        
        self.get_chat_data_for_room_id()
    }
    
    @objc func home_click_method() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as? dashboard
         
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    // new
    func get_chat_data_for_room_id() {
        
        Firestore.firestore().collection("mode/test/message/India/private_chats")
            .whereField("room_id", isEqualTo: String(self.room_id))
            .order(by: "time_stamp",descending: false)
            .addSnapshotListener() { documentSnapshot, error in
                if error != nil {
                    // print("Error to get user lists")
                    
                    return
                }
                
                if let snapshot = documentSnapshot {
                    self.chatMessages.removeAllObjects()
                    for document in snapshot.documents {
                        
                        
                        let data = document.data()
                        print(data as Any)
                        /*
                         ["sender_name": Seema, "attachment_path": , "message": i at pickup point, "type": Text, "sender_image": https://demo4.evirtualservices.net/pathmark/img/uploads/users/1696546524PLUDIN_1696514177499.png, "room": private, "time_stamp": 1696515426464, "sender_id": 41, "room_id": 331]
                         */
                        self.chatMessages.add(data)
                    }
                    self.tbleView.reloadData()
                    let scrollPoint = CGPoint(x: 0, y: self.tbleView.contentSize.height - self.tbleView.frame.size.height)
                    self.tbleView.setContentOffset(scrollPoint, animated: false)
                } else {
                    print("no, data found")
                }
                
            }
        
    }
    func empty() {
        // print("empty")
    }
    
  
    /*@objc func yesFromDialog() {
        
        self.strReceiptId = String(self.receiverIdFromDialog)
        
        self.receiverNameIs = String(self.receiverNameFromDialog)
        self.lblNavigationTitle.text = String(self.receiverNameFromDialog)
        
        self.strReceiptImage = String(self.receiverImageFromDialog)
        
        self.imgReceiverProfilePicture.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        self.imgReceiverProfilePicture.sd_setImage(with: URL(string: receiverImageFromDialog), placeholderImage: UIImage(named: "logo"))
        
        print(self.strLoginUserId as Any)
        print(self.strLoginUserName as Any)
        
        print(self.strReceiptId as Any)
        print(self.receiverNameFromDialog as Any)
        print(self.receiverNameFromDialog as Any)
        
        print(self.receiverImageFromDialog as Any)
        
        self.observeMessage()
    }*/
    
    /*@objc func notFromDialog() {
    
        print(self.receiverData as Any)
        
        if String(self.strLoginUserId) == "\(self.receiverData["userID"]!)" {
            print("same")
            
            self.strReceiptId = "\(self.receiverData["vendorID"]!)"
            self.strReceiptImage = (receiverData["vendorImage"] as! String)
            
            self.receiverNameIs = (receiverData["vendorName"] as! String)
            
            self.lblNavigationTitle.text = self.receiverNameIs
            self.imgReceiverProfilePicture.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
            self.imgReceiverProfilePicture.sd_setImage(with: URL(string: (receiverData["vendorImage"] as! String)), placeholderImage: UIImage(named: "logo"))
            
            self.strReceiverDevice = (receiverData["vendordevice"] as! String)
            self.strReceiverDeviceToken = (receiverData["vendordeviceToken"] as! String)
            
        } else {
            print("different")
            
            self.strReceiptId = "\(self.receiverData["userID"]!)"
            self.strReceiptImage = (receiverData["userImage"] as! String)
            
            self.receiverNameIs = (receiverData["userName"] as! String)
            
            self.lblNavigationTitle.text = self.receiverNameIs
            self.imgReceiverProfilePicture.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
            self.imgReceiverProfilePicture.sd_setImage(with: URL(string: (receiverData["userImage"] as! String)), placeholderImage: UIImage(named: "logo"))
            
            self.strReceiverDevice = (receiverData["userdevice"] as! String)
            self.strReceiverDeviceToken = (receiverData["userdeviceToken"] as! String)
            
        }

        print(self.strLoginUserId as Any)
        print(self.strReceiptId as Any)
        
        self.observeMessage()
    }*/
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                }
            }
            textViewBottomConstraint.constant = keyboardHeight + 8
            view.layoutIfNeeded()
        }
    }
    
    @objc func tapGestureHandler() {
        view.endEditing(true)
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    /*func observeMessage() {
        // print(self.strReceiptId+"+"+self.strLoginUserId)
        let ref = Database.database().reference()
        ref.child("one_to_one").child(self.strReceiptId+"+"+self.strLoginUserId).observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                print("true rooms exist")
                
                self.chatChannelName = self.strReceiptId+"+"+self.strLoginUserId
                
                self.chatMessages.removeAllObjects()
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let placeDict = snap.value as! [String: Any]
                    // print(placeDict as Any)
                    // self.chatMessages.add(placeDict)
                    DispatchQueue.main.async {
                        /*guard let dict = snapshot.value as? [String: AnyObject] else {
                         return
                         }*/
                        self.chatMessages.add(placeDict)
                        // print(self.chatMessages as Any)
                        self.tbleView.isHidden = false
                        if self.chatMessages.count == 0 {
                            self.tbleView.isHidden = true
                        }
                        if self.chatMessages.count > 2 {
                            self.scrollToBottom()
                        }
                        self.tbleView.delegate = self
                        self.tbleView.dataSource = self
                        self.tbleView.reloadData()
                    }
                }
            } else {
                // print("false rooms exist 1")
                ref.child("one_to_one").child(self.strLoginUserId+"+"+self.strReceiptId).observe(.value, with: { (snapshot) in
                    if snapshot.exists() {
                        print("true rooms exist")
                        self.chatChannelName = self.strLoginUserId+"+"+self.strReceiptId
                        self.chatMessages.removeAllObjects()
                        for child in snapshot.children {
                            let snap = child as! DataSnapshot
                            let placeDict = snap.value as! [String: Any]
                            print(placeDict as Any)
                            DispatchQueue.main.async {
                                /*guard let dict = snapshot.value as? [String: AnyObject] else {
                                 return
                                 }*/
                                
                                self.chatMessages.add(placeDict)
                                // print(self.chatMessages as Any)
                                self.tbleView.isHidden = false
                                if self.chatMessages.count == 0 {
                                    self.tbleView.isHidden = true
                                }
                                if self.chatMessages.count > 2 {
                                    self.scrollToBottom()
                                }
                                self.tbleView.delegate = self
                                self.tbleView.dataSource = self
                                self.tbleView.reloadData()
                            }
                        }
                    } else {
                        print("false rooms exist 2")
                        // here create a new room for chat
                        self.chatChannelName = self.strLoginUserId+"+"+self.strReceiptId
                    }
                })
            }
        })
    }*/
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.chatMessages.count-1, section: 0)
            self.tbleView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    @objc func convertSelectedImageFromGallery(img1 :UIImage) {
    }
    @objc func cellTappedMethod1(){
        // print("you tap image number: \(sender.view.tag)")
        let alert = UIAlertController(title: "Upload Profile Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            self.openCamera1()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            self.openGallery1()
        }))
        alert.addAction(UIAlertAction(title: "In-Appropriate terms", style: .default , handler:{ (UIAlertAction)in
            print("User click Delete button")
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @objc func openCamera1() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func openGallery1() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        self.uploadingImageView.isHidden = false
        self.indicators.startAnimating()
        var strURL = ""
        // Points to the root reference
        let store = Storage.storage()
        let storeRef = store.reference()
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        // default
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let imageData:Data = image_data!.pngData()!
        imageStr1 = imageData.base64EncodedString()
        imgData1 = image_data!.jpegData(compressionQuality: 0.2)!
        // #2
        
        let storeImage = storeRef.child("singleChatImage")
            .child(self.strLoginUserId+".png")
        // if let uploadImageData = UIImagePNGRepresentation((img.image)!){
        storeImage.putData(imgData1, metadata: nil, completion: { (metaData, error) in
            storeImage.downloadURL(completion: { (url, error) in
                if let urlText = url?.absoluteString {
                    strURL = urlText
                    print("///////////tttttttt//////// \(strURL)   ////////")
                    self.uploadImageForChatURL = ("\(strURL)")
                    self.sendMessageWithAttachment()
                } else {
                    print("error upload image")
                    print(error as Any)
                    self.uploadingImageView.isHidden = true
                }
            })
        })
        self.imageStr1 = "1"
    }
    
    
    // MARK:- SEND IMAGE WITH ATTACHMENT -
    @objc func sendMessageWithAttachment() {
        
        
        let timestamp = Date().currentTimeMillis()
        print(timestamp)
        var ref: DocumentReference? = nil
        ref = Firestore.firestore().collection("mode/test/message/India/private_chats").addDocument(data: [
            
            "attachment_path": String(self.uploadImageForChatURL!),
            "message":String(self.textView.text),
            "room":"private",
            "room_id":String(self.room_id),
            "sender_id":String(self.strLoginUserId),
            "sender_image":"",
            "sender_name":String(self.strLoginUserName),
            "time_stamp":timestamp,
            "type": "Image"
            
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                var message = String(self.textView.text)
                self.textView.text = ""
                self.send_notification(message: message)
                // self.get_chat_data_for_room_id()
            }
        }
        
        
    }
    
    /*@objc func dialog_listing() {
        
        let someDate = Date()
        let myTimeStamp = someDate.timeIntervalSince1970
        
        let ref2 = Database.database().reference()
        ref2.child("DialogsListing")
            .child(self.chatChannelName)
            .updateChildValues(
            
                ["SenderId"             : (self.strLoginUserId!),
                 "SenderName"            : (self.strLoginUserName!),
                 "SenderImage"           : (self.strLoginUserImage!),
                 "ReceiverId"            : (self.strReceiptId!),
                 "ReceiverName"          : (self.receiverNameIs!),
                 "ReceiverImage"         : (self.strReceiptImage!),
                 "lastMessage"           : (self.textView.text!),
            
                 "lastMessageType"       : "Image",
            
                 "TimeStamp"             : myTimeStamp,
            
                 "SenderDeviceToken"     : (self.strSenderDeviceToken!),
                 "SenderDevice"          : (self.strSenderDevice!),
            
                 "ReceiverDeviceToken"   : (self.strReceiverDeviceToken!),
                 "ReceiverDevice"        : (self.strReceiverDevice!)
            
            ])
        
        self.textView.text = ""
        
    }*/
    
    // MARK:- SEND IMAGE WITHOUT ATTACHMENT -
    @objc func sendMessageWithoutAttachment() {
         
        /*let date = Date()
         let calender = Calendar.current
         let components = calender.dateComponents([.year,.month,.day,.weekday,.hour,.minute,.second], from: date)
         
         let year = components.year
         let month = components.month
         let day = components.day
         let weekday = components.weekday
         
         let hourr = components.hour
         let minutee = components.minute
         
         let today_string = String(day!) + "/" + String(month!) + "/" + String(year!)
         
         let time_string = String(hourr!)+":"+String(minutee!)
         */
        
        // let newRegistrationUniqueId = String.createChatUniqueId()
        
        if self.textView.text == "" {
            
        } else {
            
            let timestamp = Date().currentTimeMillis()
            print(timestamp)
            var ref: DocumentReference? = nil
            ref = Firestore.firestore().collection("mode/test/message/India/private_chats").addDocument(data: [
                
                "attachment_path": String(""),
                "message":String(self.textView.text),
                "room":"private",
                "room_id":String(self.room_id),
                "sender_id":String(self.strLoginUserId),
                "sender_image":"",
                "sender_name":String(self.strLoginUserName),
                "time_stamp":timestamp,
                "type": "Text"
                
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    
                    var message = String(self.textView.text)
                    self.textView.text = ""
                    self.send_notification(message: message)
                    
                    // self.get_chat_data_for_room_id()
                }
            }
           
        }
        
         
    }
    
    @objc func send_notification(message:String) {
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tbleView.cellForRow(at: indexPath) as! payment_table_cell
        
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            /*if (language == "en") {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            } else {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "ড্রাইভার খোঁজা হচ্ছে")
            }*/
            
            
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
                
                /*
                 @Field("action") action: String?,
                 @Header("token") token: String?,
                 @Field("deviceToken") deviceToken: String?,
                 @Field("device") device: String?,
                 @Field("toDevice") toDevice: String?,
                 @Field("toDeviceToken") toDeviceToken: String?,
                 @Field("message") message: String?,
                 @Field("userId") userId: String?,
                 @Field("bookingId") bookingId: String?,
                 @Field("name") name: String?,
                 @Field("image") image: String?,
                 @Field("type") type: String?,
                 */
                
                print(self.get_all_data as Any)
                
                var token_to_parse:String!
                if (self.str_back_home == "home") {
                    
                    if "\(self.self.get_all_data["deviceToken"]!)" == (person["deviceToken"] as! String) {
                         token_to_parse = "\(self.self.get_all_data["toDeviceToken"]!)"
                    } else {
                        token_to_parse = "\(self.self.get_all_data["deviceToken"]!)"
                    }
                    
                } else {
                    token_to_parse = "\(self.self.get_all_data["deviceToken"]!)"
                }
                
                parameters = [
                    "action"        : "notificationall",
                    "userId"        : String(myString),
                    "deviceToken"   : String(token_to_parse),
                    "device"        : "\(self.self.get_all_data["device"]!)",
                    "toDevice"      : (person["device"] as! String),
                    "toDeviceToken" : (person["deviceToken"] as! String),
                    "message"       : String(message),
                    
                    "bookingId"     : String(self.str_booking_id),
                    "name"          : (person["fullName"] as! String),
                    "image"         : (person["image"] as! String),
                    "type"          : String("Chat"),
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
                            
                            /*let str_token = (JSON["AuthToken"] as! String)
                            UserDefaults.standard.set("", forKey: str_save_last_api_token)
                            UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)*/
                            
                            ERProgressHud.sharedInstance.hide()
                            
                            // self.back_click_method()
                            
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
                            
                            //self.update_payment( )
                            
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
extension BooCheckChat: GrowingTextViewDelegate {
    // *** Call layoutIfNeeded on superview for animation when changing height ***
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension BooCheckChat: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatMessages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.chatMessages[indexPath.row] as? [String:Any]
        if item!["sender_id"] as! String == String(strLoginUserId) {
            
            print(item as Any)
            
            if item!["type"] as! String == "Text" {
                
                // text
                let cell1 = tableView.dequeueReusableCell(withIdentifier: "cellOne") as! BooCheckTableCell
                cell1.senderName.text = (item!["sender_name"] as! String)
                cell1.senderText.text = (item!["message"] as! String)
                cell1.backgroundColor = .clear
                cell1.imgSender.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                // cell1.imgSender.sd_setImage(with: URL(string:strLoginUserImage), placeholderImage: UIImage(named: "logo_300"))
                return cell1
                
            } else  {
                
                // image
                let cell3 = tableView.dequeueReusableCell(withIdentifier: "cellThree") as! BooCheckTableCell
                cell3.imgSenderAttachment.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell3.imgSenderAttachment.sd_setImage(with: URL(string: (item!["attachment_path"] as! String)), placeholderImage: UIImage(named: "logo_300"))
                cell3.backgroundColor = .clear
                cell3.imgSenderAttachment2.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                // cell3.imgSenderAttachment2.sd_setImage(with: URL(string: strLoginUserImage), placeholderImage: UIImage(named: "logo_300"))
                return cell3
                
            }
            
        } else { // receiver txt
            
            if item!["type"] as! String == "Text" {
                
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "cellTwo") as! BooCheckTableCell
                cell2.receiverName.text = (item!["sender_name"] as! String)// (item!["chat_receiver"] as! String)
                cell2.receiverText.text = (item!["message"] as! String)
                cell2.backgroundColor = .clear
                cell2.imgReceiver.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                // cell2.imgReceiver.sd_setImage(with: URL(string: strReceiptImage), placeholderImage: UIImage(named: "logo_300"))
                return cell2
                
            } else { // receiver image
                
                let cell4 = tableView.dequeueReusableCell(withIdentifier: "cellFour") as! BooCheckTableCell
                cell4.imgReceiverAttachment.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell4.imgReceiverAttachment.sd_setImage(with: URL(string: (item!["attachment_path"] as! String)), placeholderImage: UIImage(named: "logo_300"))
                cell4.backgroundColor = .clear
                cell4.imgReceiverAttachment2.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                // cell4.imgReceiverAttachment2.sd_setImage(with: URL(string: strReceiptImage), placeholderImage: UIImage(named: "logo_300"))
                return cell4
                
            }
            
        }
        
        
        
        
    }
    


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.chatMessages[indexPath.row] as? [String:Any]
        if item!["type"] as! String == "Text" {
            return UITableView.automaticDimension
        } else {
            return 240
        }
    }
}

extension BooCheckChat: UITableViewDelegate {
}

struct SendLastMessageToServerWB: Encodable {
    let action: String
    let senderId: String
    let receiverId: String
    let message: String
}

struct ReadUnreadStatus: Encodable {
    let action: String
    let senderId: String
    let receiverId: String
}

