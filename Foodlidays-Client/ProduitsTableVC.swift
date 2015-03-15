//
//  ProduitsTableVC.swift
//  Foodlidays-Client
//
//  Created by Timothy Khoury on 24/02/15.
//  Copyright (c) 2015 Timothy Khoury. All rights reserved.
//

import UIKit
import Alamofire

class ProductCell : UITableViewCell{
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var price: UILabel!
    
}

struct Product {
    var label: String
    var price: String
}


class ProduitsTableVC: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var zipCodeClient: AnyObject!
    var jsonError: NSError?
    
    var responseArray:NSDictionary!
    var products: Product!
    
    lazy var data = NSMutableData()
    
    func retrieveProducts(){
        
        Alamofire.request(.GET, "http:foodlidays.dev.innervisiongroup.com/api/v1/food/cat/all/1435"
        ).responseJSON() {
            data in
            println(data)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCellOne")
    

    }
    
    override func tableView(
        tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            
            return 1
    }

    override func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
            
            var cell = tableView.dequeueReusableCellWithIdentifier("cell") as ProductCell
                retrieveProducts()
        
            println(responseArray)
            
            return cell
    }

}
