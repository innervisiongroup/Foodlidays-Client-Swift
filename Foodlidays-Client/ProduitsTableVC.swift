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



class ProduitsTableVC: UITableViewController, UITableViewDataSource, UITableViewDelegate{


    
    var zipCodeClient: AnyObject!
    var jsonError: NSError?
    
    var products: Product!
    var jsonDictionary: NSArray!
    
    @IBAction func action(sender: AnyObject) {
        println(self.jsonDictionary)
    }
    
    func retrieveProducts(){
        
        Alamofire.request(.GET, "http:foodlidays.dev.innervisiongroup.com/api/v1/food/cat/all/1435"
         ).responseJSON{ (_,_,JSON,error) in
        
            self.jsonDictionary = JSON as NSArray

            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveProducts()
        tableView.registerNib(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCellOne")
    }
    
    override func tableView(
        tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
           return 1
    }

    override func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        

        
        
            var cell = tableView.dequeueReusableCellWithIdentifier("cell") as ProductCell
            println(self.jsonDictionary)
        
            return cell
        
    }

}
