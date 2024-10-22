//
//  ride_history_details.swift
//  PathMark
//
//  Created by Dishant Rajput on 30/08/23.
//

import UIKit
import SDWebImage

class ride_history_details: UIViewController {

    var dict_get_booking_details:NSDictionary!
    
    @IBOutlet weak var view_driver_info:UIView! {
        didSet {
            view_driver_info.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var lbl_total_fare_text:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_total_fare_text.text = "TOTAL FARE"
                } else {
                    lbl_total_fare_text.text = "মোট ভাড়া"
                }
                
            }
        }
    }
    @IBOutlet weak var lbl_total_distance_text:UILabel!  {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_total_distance_text.text = "DISTANCE"
                } else {
                    lbl_total_distance_text.text = "মোট দুরত্ব"
                }
                
            }
        }
    }
    
    @IBOutlet weak var lbl_price:UILabel! {
        didSet {
            lbl_price.textColor = .white
        }
    }
    @IBOutlet weak var lbl_distance:UILabel! {
        didSet {
            lbl_distance.textColor = .white
        }
    }
    
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
            view_navigation_title.text = "Details"
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbleView.separatorColor = .clear
        
        print("===================================")
        print("===================================")
        print(self.dict_get_booking_details as Any)
        print("===================================")
        print("===================================")
        
        self.lbl_price.text = "\(str_bangladesh_currency_symbol)\(self.dict_get_booking_details["totalAmount"]!)"
        
        self.lbl_distance.text = "\(self.dict_get_booking_details["totalDistance"]!)"
        
        self.btn_back.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

}

extension ride_history_details: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ride_history_details_table_cell = tableView.dequeueReusableCell(withIdentifier: "ride_history_details_table_cell") as! ride_history_details_table_cell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.lbl_car_driver_name.text = (self.dict_get_booking_details["fullName"] as! String)
        
        cell.lbl_from.text = (self.dict_get_booking_details["RequestPickupAddress"] as! String)
        cell.lbl_to.text = (self.dict_get_booking_details["RequestDropAddress"] as! String)
        
        cell.lbl_fare.text = "\(self.dict_get_booking_details["FinalFare"]!)"
        // cell.lbl_tip.text = "\(self.dict_get_booking_details["TIP"]!)"
        cell.lbl_promotion.text = "\(self.dict_get_booking_details["discountAmount"]!)"
        cell.lbl_cancellation_fee.text = "\(str_bangladesh_currency_symbol) \(self.dict_get_booking_details["last_cancel_amount"]!)"
        
        
         
        // tip
        /*let i_am_tip:String!
        if "\(self.dict_get_booking_details["TIP"]!)" == "" {
            i_am_tip = "0.0"
        } else {
            i_am_tip = "\(self.dict_get_booking_details["TIP"]!)"
        }*/
        
        // promotion
        let i_am_promotion:String!
        if "\(self.dict_get_booking_details["discountAmount"]!)" == "" {
            i_am_promotion = "0.0"
        } else {
            i_am_promotion = "\(self.dict_get_booking_details["discountAmount"]!)"
        }
        
        //
        /*let double_fare:Double!
        if "\(self.dict_get_booking_details["FinalFare"]!)" == "" {
            double_fare = Double(0.0)
        } else {
             double_fare = Double("\(self.dict_get_booking_details["FinalFare"]!)")
        }*/
        
        // let double_tip = Double(i_am_tip)
        let double_promotion = Double(i_am_promotion)
        
        // let add_all = double_tip!+double_promotion!
        let add_all = double_promotion!
        // cell.lbl_total_amount.text = "\(add_all)"
        
        var added_all_value = "\(add_all)"
        if self.dict_get_booking_details["Last_cancel_amount"] == nil {
            
            if self.dict_get_booking_details["last_cancel_amount"] == nil {
                
                if "\(self.dict_get_booking_details["last_cancel_amount"]!)" == "" {
                    cell.lbl_cancellation_fee.isHidden = true
                    cell.lbl_cancellation_fee_text.isHidden = true
                } else if "\(self.dict_get_booking_details["last_cancel_amount"]!)" == "0" {
                    cell.lbl_cancellation_fee.isHidden = true
                    cell.lbl_cancellation_fee_text.isHidden = true
                } else {
                    cell.lbl_cancellation_fee.isHidden = false
                    cell.lbl_cancellation_fee_text.isHidden = false
                    cell.lbl_cancellation_fee.text = "\(str_bangladesh_currency_symbol) \(self.dict_get_booking_details["last_cancel_amount"]!)"
                }
                
                
            } else {
                let a = Double("\(self.dict_get_booking_details["last_cancel_amount"]!)")
                let b = Double("\(self.dict_get_booking_details["FinalFare"]!)")
                 
                
                let sum = a! + b! + add_all
                print(sum as Any)
                if "\(self.dict_get_booking_details["last_cancel_amount"]!)" == "" {
                    cell.lbl_cancellation_fee.isHidden = true
                    cell.lbl_cancellation_fee_text.isHidden = true
                } else if "\(self.dict_get_booking_details["last_cancel_amount"]!)" == "0" {
                    cell.lbl_cancellation_fee.isHidden = true
                    cell.lbl_cancellation_fee_text.isHidden = true
                    cell.lbl_total_amount.text = "\(str_bangladesh_currency_symbol) \(sum)"
                } else {
                    cell.lbl_cancellation_fee.isHidden = false
                    cell.lbl_cancellation_fee_text.isHidden = false
                    cell.lbl_total_amount.text = "\(str_bangladesh_currency_symbol) \(sum)"
                }
                
            }
            
        } else {
            let a = Double("\(self.dict_get_booking_details["Last_cancel_amount"]!)")
            let b = Double("\(self.dict_get_booking_details["FinalFare"]!)")
            let sum = a! + b! + add_all
            print(sum as Any)
            
            if "\(self.dict_get_booking_details["last_cancel_amount"]!)" == "" {
                cell.lbl_cancellation_fee.isHidden = true
                cell.lbl_cancellation_fee_text.isHidden = true
            } else if "\(self.dict_get_booking_details["last_cancel_amount"]!)" == "0" {
                cell.lbl_cancellation_fee.isHidden = true
                cell.lbl_cancellation_fee_text.isHidden = true
                
                let formattedStringFF = roundToTwoDecimalPlaces(sum)
                cell.lbl_total_amount.text = "\(str_bangladesh_currency_symbol) \(formattedStringFF)"
            } else {
                cell.lbl_cancellation_fee_text.isHidden = false
                cell.lbl_cancellation_fee.isHidden = false
                
                let formattedStringFF = roundToTwoDecimalPlaces(sum)
                cell.lbl_total_amount.text = "\(str_bangladesh_currency_symbol) \(formattedStringFF)"
            }
            
        }
        
        
        
        cell.lbl_car_number.text = "\(self.dict_get_booking_details["CarName"]!)"+" "+"\(self.dict_get_booking_details["vehicleNumber"]!)"
        cell.lbl_car_color.text = "\(self.dict_get_booking_details["VehicleColor"]!)"
        
        cell.img_car_image.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.img_car_image.sd_setImage(with: URL(string: (self.dict_get_booking_details["carImage"] as! String)), placeholderImage: UIImage(named: "logo33"))
        
        cell.img_driver_profile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.img_driver_profile.sd_setImage(with: URL(string: (self.dict_get_booking_details["image"] as! String)), placeholderImage: UIImage(named: "logo33"))
        
        cell.lbl_rating.text = "\(self.dict_get_booking_details["AVGRating"]!)"
        
        if "\(self.dict_get_booking_details["rideStatus"]!)" == "5" {
            
            if "\(self.dict_get_booking_details["paymentStatus"]!)" != "" {
                cell.img_gif.isHidden = false
                cell.img_gif.image = UIImage.gif(name: "double-check")
            } else {
                cell.img_gif.isHidden = true
            }
            
        } else {
            cell.img_gif.isHidden = true
        }
        
        
        // star manage
        if "\(self.dict_get_booking_details["AVGRating"]!)" == "0" {
            
            cell.img_star_one.image = UIImage(systemName: "star")
            cell.img_star_two.image = UIImage(systemName: "star")
            cell.img_star_three.image = UIImage(systemName: "star")
            cell.img_star_four.image = UIImage(systemName: "star")
            cell.img_star_five.image = UIImage(systemName: "star")
            
        } else if "\(self.dict_get_booking_details["AVGRating"]!)" > "1" &&
                    "\(self.dict_get_booking_details["AVGRating"]!)" < "2" {
            
            cell.img_star_one.image = UIImage(systemName: "star.fill")
            cell.img_star_two.image = UIImage(systemName: "star.leadinghalf.filled")
            cell.img_star_three.image = UIImage(systemName: "star")
            cell.img_star_four.image = UIImage(systemName: "star")
            cell.img_star_five.image = UIImage(systemName: "star")
            
        } else if "\(self.dict_get_booking_details["AVGRating"]!)" == "2" {
            
            cell.img_star_one.image = UIImage(systemName: "star.fill")
            cell.img_star_two.image = UIImage(systemName: "star.fill")
            cell.img_star_three.image = UIImage(systemName: "star")
            cell.img_star_four.image = UIImage(systemName: "star")
            cell.img_star_five.image = UIImage(systemName: "star")
            
        } else if "\(self.dict_get_booking_details["AVGRating"]!)" > "2" &&
                    "\(self.dict_get_booking_details["AVGRating"]!)" < "3" {
            
            cell.img_star_one.image = UIImage(systemName: "star.fill")
            cell.img_star_two.image = UIImage(systemName: "star.fill")
            cell.img_star_three.image = UIImage(systemName: "star.leadinghalf.filled")
            cell.img_star_four.image = UIImage(systemName: "star")
            cell.img_star_five.image = UIImage(systemName: "star")
            
        } else if "\(self.dict_get_booking_details["AVGRating"]!)" == "3" {
            
            cell.img_star_one.image = UIImage(systemName: "star.fill")
            cell.img_star_two.image = UIImage(systemName: "star.fill")
            cell.img_star_three.image = UIImage(systemName: "star.fill")
            cell.img_star_four.image = UIImage(systemName: "star")
            cell.img_star_five.image = UIImage(systemName: "star")
            
        } else if "\(self.dict_get_booking_details["AVGRating"]!)" > "3" &&
                    "\(self.dict_get_booking_details["AVGRating"]!)" < "4" {
            
            cell.img_star_one.image = UIImage(systemName: "star.fill")
            cell.img_star_two.image = UIImage(systemName: "star.fill")
            cell.img_star_three.image = UIImage(systemName: "star.fill")
            cell.img_star_four.image = UIImage(systemName: "star.leadinghalf.filled")
            cell.img_star_five.image = UIImage(systemName: "star")
            
        } else if "\(self.dict_get_booking_details["AVGRating"]!)" == "5" {
            
            cell.img_star_one.image = UIImage(systemName: "star.fill")
            cell.img_star_two.image = UIImage(systemName: "star.fill")
            cell.img_star_three.image = UIImage(systemName: "star.fill")
            cell.img_star_four.image = UIImage(systemName: "star.fill")
            cell.img_star_five.image = UIImage(systemName: "star.fill")
            
        }
        
        cell.backgroundColor = .clear
        
        
        cell.lbl_booking_fee.text = "\(str_bangladesh_currency_symbol) \(self.dict_get_booking_details["bookingFee"]!)"
        cell.lbl_cancellation_fee.text = "\(str_bangladesh_currency_symbol) \(self.dict_get_booking_details["last_cancel_amount"]!)"
        
        let cancellationFees:Double!
        let discountAmount:Double!
        let complete_cal:Double!
        
        if let amount = convertToDouble("\(self.dict_get_booking_details["FinalFare"]!)"),
           let bookingFees = convertToDouble("\(self.dict_get_booking_details["bookingFee"]!)") {
            
            if "\(self.dict_get_booking_details["last_cancel_amount"]!)" == "" {
                 cancellationFees = convertToDouble("0.0")
            } else if "\(self.dict_get_booking_details["last_cancel_amount"]!)" == "0" {
                cancellationFees = convertToDouble("0.0")
           } else {
               cancellationFees = convertToDouble("\(self.dict_get_booking_details["last_cancel_amount"]!)")
            }
            
            if "\(self.dict_get_booking_details["discountAmount"]!)" == "" {
                discountAmount = convertToDouble("0.0")
            } else if "\(self.dict_get_booking_details["discountAmount"]!)" == "0" {
                discountAmount = convertToDouble("0.0")
            } else {
                discountAmount = convertToDouble("\(self.dict_get_booking_details["discountAmount"]!)")
            }
             
            let totalAmount =  amount + bookingFees + cancellationFees! - discountAmount!
            
            if "\(self.dict_get_booking_details["promotional_discount"]!)" != "" {
                let pro_dis = convertToDouble("\(self.dict_get_booking_details["promotional_discount"]!)")
                print(pro_dis as Any)
                complete_cal = totalAmount - pro_dis!
                print("Complete cal: \(complete_cal!)")
                
                let final_fare = convertToDouble("\(self.dict_get_booking_details["FinalFare"]!)")
                print("Final fare: \(final_fare!)")
                
                let f_f_total = final_fare! - pro_dis!
                print("total: \(f_f_total)")
                // self.lbl_trip_fare.text = "\(str_bangladesh_currency_symbol) \(f_f_total)"
                
                
                cell.lbl_fare.text = "\(str_bangladesh_currency_symbol) \(f_f_total)"
                
                
                let doubleStr = String(format: "%.2f", complete_cal)
                self.lbl_price.text = "\(str_bangladesh_currency_symbol) \(doubleStr)"
                cell.lbl_total_amount.text = "\(str_bangladesh_currency_symbol) \(doubleStr)"
                
                if "\(self.dict_get_booking_details["discountAmount"]!)" == "" {
                    cell.lbl_promotion.text = "\(str_bangladesh_currency_symbol) 0"
                } else if "\(self.dict_get_booking_details["discountAmount"]!)" == "0" {
                    cell.lbl_promotion.text = "\(str_bangladesh_currency_symbol) 0"
                } else {
                    cell.lbl_promotion.text = "\(str_bangladesh_currency_symbol) \(self.dict_get_booking_details["discountAmount"]!)"
                }
                
            } else {
                print("NO promotional_discount")
                
                self.lbl_price.text = "\(str_bangladesh_currency_symbol) \(totalAmount)"
                cell.lbl_fare.text = "\(str_bangladesh_currency_symbol) \(totalAmount)"
                cell.lbl_total_amount.text = "\(str_bangladesh_currency_symbol) \(totalAmount)"
                
                let doubleStr = String(format: "%.2f", totalAmount)
                self.lbl_price.text = "\(str_bangladesh_currency_symbol) \(doubleStr)"
                cell.lbl_fare.text = "\(str_bangladesh_currency_symbol) \(doubleStr)"
                cell.lbl_total_amount.text = "\(str_bangladesh_currency_symbol) \(doubleStr)"
                
                if "\(self.dict_get_booking_details["discountAmount"]!)" == "" {
                    cell.lbl_promotion.text = "\(str_bangladesh_currency_symbol) 0"
                } else if "\(self.dict_get_booking_details["discountAmount"]!)" == "0" {
                    cell.lbl_promotion.text = "\(str_bangladesh_currency_symbol) 0"
                } else {
                    cell.lbl_promotion.text = "\(str_bangladesh_currency_symbol) \(self.dict_get_booking_details["discountAmount"]!)"
                }
                
                
            }
            
        } else {
            print("Invalid number format in one of the strings.")
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           
        return 460
    }
    
}

class ride_history_details_table_cell: UITableViewCell {
    
    @IBOutlet weak var view_from_to:UIView! {
        didSet {
            view_from_to.backgroundColor = .white
            
            // shadow
            view_from_to.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_from_to.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_from_to.layer.shadowOpacity = 1.0
            view_from_to.layer.shadowRadius = 10.0
            view_from_to.layer.masksToBounds = false
            view_from_to.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var lbl_fare_text:UILabel!  {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_fare_text.text = "Total fare"
                } else {
                    lbl_fare_text.text = "ট্রিপ ভাড়া"
                }
                
            }
        }
    }
    @IBOutlet weak var lbl_discoun_text:UILabel!  {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_discoun_text.text = "Discount"
                } else {
                    lbl_discoun_text.text = "ছাড়"
                }
                
            }
        }
    }
    
    @IBOutlet weak var lbl_total_amount_text:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_total_amount_text.text = "Total amount"
                } else {
                    lbl_total_amount_text.text = "সর্বমোট"
                }
                
            }
        }
    }
    
    @IBOutlet weak var lbl_car_number_text:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_car_number_text.text = "Car number"
                } else {
                    lbl_car_number_text.text = "গাড়ির নম্বর"
                }
                
            }
        }
    }
    
    @IBOutlet weak var lbl_car_color_text:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_car_color_text.text = "Car color"
                } else {
                    lbl_car_color_text.text = "গাড়ির রঙ"
                }
                
            }
        }
    }
    
    @IBOutlet weak var lbl_cancellation_fee_text:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_cancellation_fee_text.text = "Previous Cancellation fee"
                } else {
                    lbl_cancellation_fee_text.text = "পূর্ববর্তী বাতিলকরণ ফি"
                }
                
            }
        }
    }
    
    @IBOutlet weak var lbl_cancellation_fee:UILabel!
    
    @IBOutlet weak var lbl_from:UILabel!
    @IBOutlet weak var lbl_to:UILabel!
    
    @IBOutlet weak var view_fare:UIView! {
        didSet {
            view_fare.backgroundColor = .white
            
            // shadow
            view_fare.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_fare.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_fare.layer.shadowOpacity = 1.0
            view_fare.layer.shadowRadius = 10.0
            view_fare.layer.masksToBounds = false
            view_fare.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var lbl_fare:UILabel!
    @IBOutlet weak var lbl_tip:UILabel!
    @IBOutlet weak var lbl_promotion:UILabel!
    @IBOutlet weak var lbl_total_amount:UILabel!
    
    @IBOutlet weak var view_star:UIView! {
        didSet {
            view_star.backgroundColor = .white
            
            // shadow
            view_star.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_star.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_star.layer.shadowOpacity = 1.0
            view_star.layer.shadowRadius = 10.0
            view_star.layer.masksToBounds = false
            view_star.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var view_driver_info:UIView! {
        didSet {
            view_driver_info.backgroundColor = .white
            
            // shadow
            view_driver_info.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_driver_info.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_driver_info.layer.shadowOpacity = 1.0
            view_driver_info.layer.shadowRadius = 10.0
            view_driver_info.layer.masksToBounds = false
            view_driver_info.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var lbl_car_driver_name:UILabel!
    @IBOutlet weak var lbl_car_number:UILabel!
    @IBOutlet weak var lbl_car_color:UILabel!
    
    @IBOutlet weak var img_car_image:UIImageView! {
        didSet {
            img_car_image.layer.cornerRadius = 20
            img_car_image.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var img_driver_profile:UIImageView! {
        didSet {
            img_car_image.layer.cornerRadius = 25
            img_car_image.clipsToBounds = true
        }
    }
 
    @IBOutlet weak var img_gif:UIImageView!
    
    @IBOutlet weak var lbl_rating:UILabel!

    @IBOutlet weak var img_star_one:UIImageView!
    @IBOutlet weak var img_star_two:UIImageView!
    @IBOutlet weak var img_star_three:UIImageView!
    @IBOutlet weak var img_star_four:UIImageView!
    @IBOutlet weak var img_star_five:UIImageView!
    
    @IBOutlet weak var lbl_booking_fee:UILabel! {
        didSet {
            lbl_booking_fee.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_booking_fee_text:UILabel! {
        didSet {
            lbl_booking_fee_text.textColor = .black
        }
    }
}
