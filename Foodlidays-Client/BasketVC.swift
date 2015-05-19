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
    var basket = Array<(name: String, price: String, note: String, quantite: String)>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        println(roomNumber)
        println(emailClient)
        println(basket)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
