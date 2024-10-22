//
//  my_custom_loader.swift
//  PathMark
//
//  Created by Dishant Rajput on 16/08/23.
//

import UIKit
import SwiftGifOrigin

class my_custom_loader: UIViewController {

    @IBOutlet weak var img_loader:UIImageView! {
        didSet {
            img_loader.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.img_loader.image = UIImage.gif(name: "car-toy")
        
    }
}
