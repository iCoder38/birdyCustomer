//
//  parameter.swift
//  PathMark
//
//  Created by Dishant Rajput on 12/07/23.
//

import UIKit

struct Header:Encodable {
    let alg = "HS512"
    let typ = "JWT"
}
struct main_token: Encodable {
    let body :String
}

struct payload_login: Encodable {
    let action :String
      let email :String
      let password :String
}

struct payload_registration: Encodable {
    let action :String
    let fullName:String
    let email:String
    let countryCode:String
    let contactNumber:String
    let password:String
    let role: String  //Member    Driver
    let INDNo:String
    let device:String
    let deviceToken:String
}

struct payload_country_list: Encodable {
    let action :String
}

struct payload_verify_OTP: Encodable {
    let action :String
    let userId :String
    let OTP :String
}

struct payload_vehicle_list: Encodable {
    let action :String
    let TYPE :String
    let language :String
}

class parameter: UIViewController {

//action:login
//mailto:email:raushan@mailinator.com
//password:123456
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
