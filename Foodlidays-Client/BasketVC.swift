//
//  BasketVC.swift
//  Foodlidays-Client
//
//  Created by Timothy Khoury on 19/05/15.
//  Copyright (c) 2015 Timothy Khoury. All rights reserved.
//

import UIKit

class BasketVC: UIViewController {
    
    var roomNumber:AnyObject!
    var emailClient:AnyObject!
    var basket = Array<(id: Int,name: String, price: String, note: String, quantite: Int)>()
    
    @IBOutlet weak var productList: UILabel!
    @IBOutlet weak var total: UILabel!
    
    
    var finalPrice: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        println(roomNumber)
        println(emailClient)
        
        for product in basket
        {
            var prix = product.price as NSString
            prix = String(stringInterpolationSegment: prix.doubleValue * Double(product.quantite))
            
            productList.text = productList.text?.stringByAppendingString("\(product.quantite)x : \(product.name) \t \(prix)€ \n")
            productList.numberOfLines++
            
            self.finalPrice += prix.doubleValue
            
        }
        
        total.text = ("Total :  \(self.finalPrice)€")
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    


}
