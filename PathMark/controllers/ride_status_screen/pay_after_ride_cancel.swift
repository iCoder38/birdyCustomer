//
//  pay_after_ride_cancel.swift
//  PathMark
//
//  Created by Dishant Rajput on 30/08/24.
//

import UIKit

class pay_after_ride_cancel: UIViewController {

    var dictGetAllData:NSDictionary!
    @IBOutlet weak var lblTotalPay:UILabel!
    @IBOutlet weak var lblTotalDistance:UILabel!
    
    @IBOutlet weak var btnPay:UIButton!
    
    var payAfterCalculate:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.dictGetAllData as Any)
        /*
         Optional({
             "Discount_percentage" = 10;
             DriverImage = "https://demo4.evirtualservices.net/pathmark/img/uploads/users/1722856883PLUDIN_1722856930143.png";
             FinalFare = 5;
             "Last_cancel_amount" = 0;
             "Last_cancel_booking_ID" = "";
             "Promotional_total" = "0.5";
             RequestDropAddress = "Vegas Mall Parking, Sector 14 Road, Pocket 1, Sector 14 Dwarka, Dwarka, Delhi, India";
             RequestDropLatLong = "28.6011242,77.0296578";
             RequestPickupAddress = "Sector 10 Dwarka, South West Delhi New Delhi, India - 110075";
             RequestPickupLatLong = "28.587234497070312,77.06063589789477";
             VehicleColor = "<null>";
             bookingFee = 10;
             bookingId = 840;
             driverContact = 99404994964;
             driverId = 301;
             driverLatitude = "28.5873067";
             driverName = vx;
             driverlongitude = "77.0606041";
             message = "You've arrived at your destination. Thank you for riding with us! Your fare is 5.";
             rating = 5;
             totalAmount = "4.5";
             totalDistance = 1;
             totalTime = "1 min";
             type = rideend;
             vehicleNumber = 7171818118;
             vehicleType = 1;
         })
         */
        self.lblTotalDistance.text = "\(self.dictGetAllData["totalDistance"]!) km"
        self.btnPay.addTarget(self, action: #selector(confirmAndPayClickMethod), for: .touchUpInside)
        
        self.manageCalculation()
    }
    
    @objc func manageCalculation() {
        let cancellationFees:Double!
        
        if let amount = self.convertToDouble("\(self.dictGetAllData["FinalFare"]!)"),
           let bookingFees = self.convertToDouble("\(self.dictGetAllData["bookingFee"]!)") {
            
            var lastCancelledAmount:String!
            
            if (self.dictGetAllData["last_cancel_amount"] == nil) {
                lastCancelledAmount = "\(self.dictGetAllData["Last_cancel_amount"]!)"
            } else {
                lastCancelledAmount = "\(self.dictGetAllData["last_cancel_amount"]!)"
            }
            
            if String(lastCancelledAmount) == "" {
                cancellationFees = self.convertToDouble("0.0")
            } else if String(lastCancelledAmount) == "0" {
                cancellationFees = self.convertToDouble("0.0")
            } else {
                cancellationFees = self.convertToDouble(String(lastCancelledAmount))
            }
            
            let totalAmount = amount + bookingFees + cancellationFees!
            print(totalAmount as Any)
            
            if "\(self.dictGetAllData["Promotional_total"]!)" != "" {
                let pro_dis = self.convertToDouble("\(self.dictGetAllData["Promotional_total"]!)")
                print(pro_dis as Any)
                let complete_cal = totalAmount - pro_dis!
                print("Complete cal: \(complete_cal)")
                self.lblTotalPay.text = "\(str_bangladesh_currency_symbol) \(complete_cal)"
                self.btnPay.setTitle("Confirm & Pay: \(str_bangladesh_currency_symbol) \(complete_cal)", for: .normal)
                self.payAfterCalculate = "\(complete_cal)"
            } else {
                self.lblTotalPay.text = "\(str_bangladesh_currency_symbol) \(totalAmount)"
                self.payAfterCalculate = "\(totalAmount)"
                self.btnPay.setTitle("Confirm & Pay: \(str_bangladesh_currency_symbol)\(totalAmount)", for: .normal)
            }
            
        }
    }
    
    @objc func confirmAndPayClickMethod() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "before_payment_id") as? before_payment
        push!.str_booking_id2 = "\(self.dictGetAllData!["bookingId"]!)"
        push!.str_get_total_price2 = "\(self.payAfterCalculate!)"
        push!.get_full_data_for_payment2 = self.dictGetAllData
        self.navigationController?.pushViewController(push!, animated: true)
    }
}
