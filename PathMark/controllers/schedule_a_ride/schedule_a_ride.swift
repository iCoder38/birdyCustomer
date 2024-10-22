//
//  schedule_a_ride.swift
//  PathMark
//
//  Created by Dishant Rajput on 16/11/23.
//

import UIKit
import FSCalendar

class schedule_a_ride: UIViewController {

    var str_get_category_id:String!
    var str_from_location:String!
    var str_to_location:String!
    
    var searched_place_location_lat:String!
    var searched_place_location_long:String!
    
    var my_location_lat:String!
    var my_location_long:String!
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = NAVIGATION_BACK_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lblNavigationTitle.text = "Schedule a ride"
                } else {
                    lblNavigationTitle.text = "একটি যাত্রার সময়সূচী"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
            
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var lbl_please_select_date_text:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_please_select_date_text.text = "Please select a date"
                } else {
                    lbl_please_select_date_text.text = "একটি তারিখ নির্বাচন করুন"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    @IBOutlet weak var lbl_please_select_time_text:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_please_select_time_text.text = "Select Time"
                } else {
                    lbl_please_select_time_text.text = "সময় নির্বাচন করুন"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    var str_selected_date:String! = ""
    var str_selected_date2:String! = ""
    
    var str_selected_time:String! = ""
    var str_selected_time2:String! = ""
    
    @IBOutlet weak var lbl_selected_date:UILabel! {
        didSet {
            lbl_selected_date.backgroundColor = UIColor(red: 246.0/255.0, green: 200.0/255.0, blue: 68.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var btn_select_time:UIButton! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_select_time.setTitle("select time", for: .normal)
                } else {
                    btn_select_time.setTitle("সময় নির্বাচন করুন", for: .normal)
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    
    @IBOutlet weak var btn_schedule:UIButton! {
        didSet {
            btn_schedule.backgroundColor = navigation_color
            btn_schedule.layer.cornerRadius = 12
            btn_schedule.clipsToBounds = true
            btn_schedule.setTitleColor(.white, for: .normal)
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_schedule.setTitle("Schedule a ride now", for: .normal)
                } else {
                    btn_schedule.setTitle("এখন একটি রাইড সময়সূচী", for: .normal)
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
            
        }
    }
    
    // calendar
    @IBOutlet weak var calendar: FSCalendar! {
        didSet {
            calendar.appearance.headerTitleFont = UIFont(name: "Poppins-SemiBold", size: 18)
            
            calendar.appearance.weekdayFont = UIFont(name: "Poppins-Regular", size: 14)
            calendar.appearance.weekdayTextColor = UIColor.init(red: 38.0/255.0, green: 34.0/255.0, blue: 108.0/255.0, alpha: 1)
            
            calendar.appearance.todayColor = UIColor.systemOrange// app_red_orange_mix_color
             
            calendar.appearance.eventDefaultColor = UIColor.systemPink
            calendar.scope = .month
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnBack.addTarget(self, action: #selector(back_click_method_2), for: .touchUpInside)
        
        self.btn_select_time.addTarget(self, action: #selector(select_time_click_method), for: .touchUpInside)
        self.btn_schedule.addTarget(self, action: #selector(schedule_a_ride_click_method2), for: .touchUpInside)
        
        // calendar
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.calendar.scope = .month
        
        print(self.str_get_category_id as Any)
        print(self.str_from_location as Any)
        print(self.str_to_location as Any)
        print(self.searched_place_location_lat as Any)
        print(self.searched_place_location_long as Any)
        // print(self.strSaveLongitude as Any)
        print(self.my_location_lat as Any)
        print(self.my_location_long as Any)
    }
    
    @objc func back_click_method_2() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func schedule_a_ride_click_method2() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "schedule_confirm_booking_id") as? schedule_confirm_booking
        
        push!.str_get_category_id2 = String(self.str_get_category_id)
        push!.str_from_location2 = String(self.str_from_location)
        push!.str_to_location2 = String(self.str_to_location)

        push!.my_location_lat2 = String(self.my_location_lat)
        push!.my_location_long2 = String(self.my_location_long)

        push!.searched_place_location_lat2 = String(self.searched_place_location_lat)
        push!.searched_place_location_long2 = String(self.searched_place_location_long)
        
        push!.str_date = String(self.str_selected_date)
        push!.str_date2 = String(self.str_selected_date2)
        push!.str_time = String(self.str_selected_time)
        
        push!.str_time2 = String(self.str_selected_time2)
        
        self.navigationController?.pushViewController(push!, animated: true)
        
        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "schedule_ride_details_id") as? schedule_ride_details
        self.navigationController?.pushViewController(push!, animated: true)*/
      
    }
    
    @objc func select_time_click_method() {
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                RPicker.selectDate(title: "Select Time", cancelText: "Cancel", datePickerMode: .time, didSelectDate: { (selectedDate) in
                    // TODO: Your implementation for date
                    self.btn_select_time.setTitle(selectedDate.dateString("HH:mm"), for: .normal)
                    self.str_selected_time = selectedDate.dateString("HH:mm")
                    
                    print(self.str_selected_time as Any)
                    
                    let fullName    = String(self.str_selected_time)
                    let fullNameArr = fullName.components(separatedBy: ":")

                    let hour    = fullNameArr[0]
                    let minute = fullNameArr[1]
                    
                    var str_am:String! = " am"
                    var str_pm:String! = " pm"
                    
                    
                    
                    if (hour == "00") {
                        
                        self.str_selected_time2 = "12:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("12:\(minute)\(str_am!)", for: .normal)
                        
                    } else if (hour == "01") {
                        
                        self.str_selected_time2 = "1:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("1:\(minute)\(str_am!)", for: .normal)
                        
                    }else if (hour == "02") {
                        
                        self.str_selected_time2 = "2:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("2:\(minute)\(str_am!)", for: .normal)
                        
                    }else if (hour == "03") {
                        
                        self.str_selected_time2 = "3:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("3:\(minute)\(str_am!)", for: .normal)
                        
                    }else if (hour == "04") {
                        
                        self.str_selected_time2 = "4:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("4:\(minute)\(str_am!)", for: .normal)
                        
                    }else if (hour == "05") {
                        
                        self.str_selected_time2 = "5:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("5:\(minute)\(str_am!)", for: .normal)
                        
                    }else if (hour == "06") {
                        
                        self.str_selected_time2 = "6:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("6:\(minute)\(str_am!)", for: .normal)
                        
                    }else if (hour == "07") {
                        
                        self.str_selected_time2 = "7:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("7:\(minute)\(str_am!)", for: .normal)
                        
                    }else if (hour == "08") {
                        
                        self.str_selected_time2 = "8:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("8:\(minute)\(str_am!)", for: .normal)
                        
                    }else if (hour == "09") {
                        
                        self.str_selected_time2 = "9:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("9:\(minute)\(str_am!)", for: .normal)
                        
                    }else if (hour == "10") {
                        
                        self.str_selected_time2 = "10:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("10:\(minute)\(str_am!)", for: .normal)
                        
                    }else if (hour == "11") {
                        
                        self.str_selected_time2 = "11:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("11:\(minute)\(str_am!)", for: .normal)
                        
                    }else if (hour == "12") {
                        
                        self.str_selected_time2 = "12:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("12:\(minute)\(str_am!)", for: .normal)
                        
                    }else if (hour == "13") {
                        
                        self.str_selected_time2 = "1:\(minute)\(str_pm!)"
                        self.btn_select_time.setTitle("1:\(minute)\(str_pm!)", for: .normal)
                        
                    } else if (hour == "14") {
                        
                        self.str_selected_time2 = "2:\(minute)\(str_pm!)"
                        self.btn_select_time.setTitle("2:\(minute)\(str_pm!)", for: .normal)
                        
                    } else if (hour == "15") {
                        
                        self.str_selected_time2 = "3:\(minute)\(str_pm!)"
                        self.btn_select_time.setTitle("3:\(minute)\(str_pm!)", for: .normal)
                        
                    } else if (hour == "16") {
                        
                        self.str_selected_time2 = "4:\(minute)\(str_pm!)"
                        self.btn_select_time.setTitle("4:\(minute)\(str_pm!)", for: .normal)
                        
                    } else if (hour == "17") {
                        
                        self.str_selected_time2 = "5:\(minute)\(str_pm!)"
                        self.btn_select_time.setTitle("5:\(minute)\(str_pm!)", for: .normal)
                        
                    } else if (hour == "18") {
                        
                        self.str_selected_time2 = "6:\(minute)\(str_pm!)"
                        self.btn_select_time.setTitle("6:\(minute)\(str_pm!)", for: .normal)
                        
                    } else if (hour == "19") {
                        
                        self.str_selected_time2 = "7:\(minute)\(str_pm!)"
                        self.btn_select_time.setTitle("7:\(minute)\(str_pm!)", for: .normal)
                        
                    } else if (hour == "20") {
                        
                        self.str_selected_time2 = "8:\(minute)\(str_pm!)"
                        self.btn_select_time.setTitle("8:\(minute)\(str_pm!)", for: .normal)
                        
                    } else if (hour == "21") {
                        
                        self.str_selected_time2 = "9:\(minute)\(str_pm!)"
                        self.btn_select_time.setTitle("9:\(minute)\(str_pm!)", for: .normal)
                        
                    } else if (hour == "22") {
                        
                        self.str_selected_time2 = "10:\(minute)\(str_pm!)"
                        self.btn_select_time.setTitle("10:\(minute)\(str_pm!)", for: .normal)
                        
                    } else if (hour == "23") {
                        
                        self.str_selected_time2 = "11:\(minute)\(str_pm!)"
                        self.btn_select_time.setTitle("11:\(minute)\(str_pm!)", for: .normal)
                        
                    } else if (hour == "24") {
                        
                        self.str_selected_time2 = "12:\(minute)\(str_pm!)"
                        self.btn_select_time.setTitle("12:\(minute)\(str_pm!)", for: .normal)
                        
                    } else {
                        
                        self.btn_select_time.setTitle(selectedDate.dateString("HH:mm")+str_am, for: .normal)
                        self.str_selected_time = selectedDate.dateString("HH:mm")
                        
                    }
                    
                })
            } else {
                RPicker.selectDate(title: "সময় নির্বাচন করুন", cancelText: "বাতিল করুন", datePickerMode: .time, didSelectDate: { (selectedDate) in
                    // TODO: Your implementation for date
                    self.btn_select_time.setTitle(selectedDate.dateString("HH:mm"), for: .normal)
                    self.str_selected_time = selectedDate.dateString("HH:mm")
                    
                    print(self.str_selected_time as Any)
                    
                    let fullName    = String(self.str_selected_time)
                    let fullNameArr = fullName.components(separatedBy: ":")

                    let hour    = fullNameArr[0]
                    let minute = fullNameArr[1]
                    
                    var str_am:String! = " am"
                    var str_pm:String! = " pm"
                    
                    
                    
                    if (hour == "00") {
                        
                        self.str_selected_time2 = "12:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("12:\(minute)\(str_am!)", for: .normal)
                        
                    } else if (hour == "01") {
                        
                        self.str_selected_time2 = "1:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("1:\(minute)\(str_am!)", for: .normal)
                        
                    }else if (hour == "02") {
                        
                        self.str_selected_time2 = "2:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("2:\(minute)\(str_am!)", for: .normal)
                        
                    }else if (hour == "03") {
                        
                        self.str_selected_time2 = "3:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("3:\(minute)\(str_am!)", for: .normal)
                        
                    }else if (hour == "04") {
                        
                        self.str_selected_time2 = "4:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("4:\(minute)\(str_am!)", for: .normal)
                        
                    }else if (hour == "05") {
                        
                        self.str_selected_time2 = "5:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("5:\(minute)\(str_am!)", for: .normal)
                        
                    }else if (hour == "06") {
                        
                        self.str_selected_time2 = "6:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("6:\(minute)\(str_am!)", for: .normal)
                        
                    }else if (hour == "07") {
                        
                        self.str_selected_time2 = "7:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("7:\(minute)\(str_am!)", for: .normal)
                        
                    }else if (hour == "08") {
                        
                        self.str_selected_time2 = "8:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("8:\(minute)\(str_am!)", for: .normal)
                        
                    }else if (hour == "09") {
                        
                        self.str_selected_time2 = "9:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("9:\(minute)\(str_am!)", for: .normal)
                        
                    }else if (hour == "10") {
                        
                        self.str_selected_time2 = "10:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("10:\(minute)\(str_am!)", for: .normal)
                        
                    }else if (hour == "11") {
                        
                        self.str_selected_time2 = "11:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("11:\(minute)\(str_am!)", for: .normal)
                        
                    }else if (hour == "12") {
                        
                        self.str_selected_time2 = "12:\(minute)\(str_am!)"
                        self.btn_select_time.setTitle("12:\(minute)\(str_am!)", for: .normal)
                        
                    }else if (hour == "13") {
                        
                        self.str_selected_time2 = "1:\(minute)\(str_pm!)"
                        self.btn_select_time.setTitle("1:\(minute)\(str_pm!)", for: .normal)
                        
                    } else if (hour == "14") {
                        
                        self.str_selected_time2 = "2:\(minute)\(str_pm!)"
                        self.btn_select_time.setTitle("2:\(minute)\(str_pm!)", for: .normal)
                        
                    } else if (hour == "15") {
                        
                        self.str_selected_time2 = "3:\(minute)\(str_pm!)"
                        self.btn_select_time.setTitle("3:\(minute)\(str_pm!)", for: .normal)
                        
                    } else if (hour == "16") {
                        
                        self.str_selected_time2 = "4:\(minute)\(str_pm!)"
                        self.btn_select_time.setTitle("4:\(minute)\(str_pm!)", for: .normal)
                        
                    } else if (hour == "17") {
                        
                        self.str_selected_time2 = "5:\(minute)\(str_pm!)"
                        self.btn_select_time.setTitle("5:\(minute)\(str_pm!)", for: .normal)
                        
                    } else if (hour == "18") {
                        
                        self.str_selected_time2 = "6:\(minute)\(str_pm!)"
                        self.btn_select_time.setTitle("6:\(minute)\(str_pm!)", for: .normal)
                        
                    } else if (hour == "19") {
                        
                        self.str_selected_time2 = "7:\(minute)\(str_pm!)"
                        self.btn_select_time.setTitle("7:\(minute)\(str_pm!)", for: .normal)
                        
                    } else if (hour == "20") {
                        
                        self.str_selected_time2 = "8:\(minute)\(str_pm!)"
                        self.btn_select_time.setTitle("8:\(minute)\(str_pm!)", for: .normal)
                        
                    } else if (hour == "21") {
                        
                        self.str_selected_time2 = "9:\(minute)\(str_pm!)"
                        self.btn_select_time.setTitle("9:\(minute)\(str_pm!)", for: .normal)
                        
                    } else if (hour == "22") {
                        
                        self.str_selected_time2 = "10:\(minute)\(str_pm!)"
                        self.btn_select_time.setTitle("10:\(minute)\(str_pm!)", for: .normal)
                        
                    } else if (hour == "23") {
                        
                        self.str_selected_time2 = "11:\(minute)\(str_pm!)"
                        self.btn_select_time.setTitle("11:\(minute)\(str_pm!)", for: .normal)
                        
                    } else if (hour == "24") {
                        
                        self.str_selected_time2 = "12:\(minute)\(str_pm!)"
                        self.btn_select_time.setTitle("12:\(minute)\(str_pm!)", for: .normal)
                        
                    } else {
                        
                        self.btn_select_time.setTitle(selectedDate.dateString("HH:mm")+str_am, for: .normal)
                        self.str_selected_time = selectedDate.dateString("HH:mm")
                        
                    }
                    
                })
            }
            
        } else {
            print("=============================")
            print("LOGIN : Select language error")
            print("=============================")
            UserDefaults.standard.set("en", forKey: str_language_convert)
        }
        
        
        
    }
    
    // calendar
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let foramtter = DateFormatter()
        let foramtter2 = DateFormatter()
        // foramtter.dateFormat = "yyyy-MM-dd"
        foramtter.dateFormat = "yyyy-MM-dd"
        foramtter2.dateFormat = "MM-dd-yyy"
        
        let date1 = foramtter.string(from: date)
        let date2 = foramtter2.string(from: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date_set = dateFormatter.date(from: date1)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let resultString = dateFormatter.string(from: date_set!)
        // cell.lblSelectedDate.text = "Selected Date: " + resultString
        
        // # 2
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MM-dd-yyyy"
        let date_set2 = dateFormatter2.date(from: date2)
        dateFormatter2.dateFormat = "MM-dd-yyyy"
        let resultString2 = dateFormatter2.string(from: date_set2!)
        
        
        print("Selected Date: " + resultString)
        
        self.str_selected_date = resultString
        self.str_selected_date2 = resultString2
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                self.lbl_selected_date.text = "Selected Date: " + resultString2
            } else {
                self.lbl_selected_date.text = "নির্বাচিত তারিখ: " + resultString2
            }
            
        } else {
            print("=============================")
            print("LOGIN : Select language error")
            print("=============================")
            UserDefaults.standard.set("en", forKey: str_language_convert)
        }
        
        
        // self.get_calendar_date_WB(str_date: resultString)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter2.string(from: date)
//        if self.datesWithEvent.contains(dateString) {
//            return 1
//        }

        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        let key = self.dateFormatter2.string(from: date)
//        if self.datesWithEvent != nil {
//            return UIColor.black
//        }
        return appearance.selectionColor
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        let key = self.dateFormatter1.string(from: date)
//        if let color = self.borderDefaultColors[key] {
//            return color
//        }
        return appearance.borderDefaultColor
    }
}

extension schedule_a_ride : FSCalendarDelegate,FSCalendarDataSource {
    
}
