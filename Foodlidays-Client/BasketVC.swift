//
//  BasketVC.swift
//  Foodlidays-Client
//
//  Created by Timothy Khoury on 19/05/15.
//  Copyright (c) 2015 Timothy Khoury. All rights reserved.
//

import UIKit

import SwiftyJSON
import Alamofire

class BasketVC: UIViewController {
    
    var roomNumber:AnyObject!
    var emailClient:AnyObject!
    var basket = Array<(id: Int,name: String, price: String, note: String, quantite: Int)>()
    
    var dataClient : NSDictionary!
    
    
    var productArray = Array<(id: Int,quantity: Int)>()

    
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
        retrieveInfos()
        for product in basket
        {
            self.productArray += [(id: product.id,quantite: product.quantite)]
        }
        
        println(self.productArray)
        
        println(dataClient)
    }
    @IBAction func sendOrder(sender: AnyObject) {
        println(self.dataClient)
        
        
        var prods = [[String:Int]]()
        for product in productArray
        {
            var eachDict = [String:Int]()
            eachDict["id"] =  product.id
            eachDict["quantity"] = product.quantity
            prods.append(eachDict)
        }

        let room: (AnyObject!) = dataClient.objectForKey("room")
        var zip: AnyObject! = room.objectForKey("zip")
        var floor: AnyObject! = room.objectForKey("floor")
        var address: AnyObject! = room.objectForKey("address")
        var id_room: AnyObject! = room.objectForKey("id_room")
        var type_room: AnyObject! = room.objectForKey("type_room")
        var roomNb: AnyObject! = room.objectForKey("room")
        var country: AnyObject! = room.objectForKey("country")
        var city: AnyObject! = room.objectForKey("city")
        var language: AnyObject! = "fr"
        var method_payment: AnyObject! = "cash"
        
        let jsonObject: [String: AnyObject] = [
            "room_number": roomNumber,
            "zip" : zip,
            "email": emailClient,
            "plats": prods,
            "floor" : floor,
            "address": address,
            "type_room" : type_room,
            "id_room" : id_room,
            "country" : country,
            "room" : roomNb,
            "id_user" : 1,
            "city" : city,
            "language" : language,
            "method_payment": method_payment,
        ]
        
        println(jsonObject)


    }
    
    func retrieveInfos()
    {
        let parameters = [
            "email": ["\(emailClient)"],
            "room_number": ["\(roomNumber)"]
        ]
        
        Alamofire.request(.POST, "http:foodlidays.dev.innervisiongroup.com/api/v1/login", parameters: parameters, encoding: .JSON)
            .responseJSON {
                (data) -> Void in
                self.dataClient = data.2 as! NSDictionary
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    


}
