//
//  ProduitsTableVC.swift
//  Foodlidays-Client
//
//  Created by Timothy Khoury on 24/02/15.
//  Copyright (c) 2015 Timothy Khoury. All rights reserved.
//


import UIKit
import SwiftyJSON
import Alamofire

class ProfileVC: UIViewController {
    
    var emailClient : String!
    var roomNumber: String!
    
    @IBOutlet weak var labelEmail: UILabel!
    
    @IBOutlet weak var labelNum: UILabel!
    @IBOutlet weak var labelZip: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadElements()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        loadElements()
    }
    
    func loadElements() {
        labelNum.text = roomNumber
        labelEmail.text = emailClient

        
        let parameters = [
            "email": ["\(emailClient)"],
            "room_number": ["\(roomNumber)"]
        ]
        
        Alamofire.request(.POST, "http:foodlidays.dev.innervisiongroup.com/api/v1/login", parameters: parameters, encoding: .JSON)
            .responseJSON {
                (data) -> Void in
                
                println(data)
        }
    }

}
