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
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var img: UIImageView!
    
}

struct Product {
    var label: String
    var price: String
    var note:  String
    var img:   UIImage
}



class ProduitsTableVC: UITableViewController, UITableViewDataSource, UITableViewDelegate{


    
    var zipCodeClient: AnyObject!
    var jsonError: NSError?
    
    var products: Product!
    var jsonDictionary: NSArray!
    
    @IBAction func action(sender: AnyObject) {
        println(self.jsonDictionary)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView .reloadData()
    }
    
    func retrieveProducts(){
        
        Alamofire.request(.GET, "http:foodlidays.dev.innervisiongroup.com/api/v1/food/cat/all/1435"
         ).responseJSON{ (_,_,JSON,error) in
            self.jsonDictionary = JSON as NSArray
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatch_async(dispatch_get_main_queue()){
        self.retrieveProducts()
        }
        tableView.registerNib(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCellOne")
        refreshTable()

    }
    
    override func tableView(
        tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
           return 5
    }

    override func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
         var cell = tableView.dequeueReusableCellWithIdentifier("cell") as ProductCell
        
            if(self.jsonDictionary != nil)
            {
        
            var rowData: NSDictionary = self.jsonDictionary[indexPath.row] as NSDictionary
            var title=rowData["title"] as String
            var poster=rowData["note"] as String
            var descrip=rowData["price"] as String
        
            cell.label.text = title
            cell.note.text = poster
            cell.price.text = descrip
        
            return cell
        }
        
            else {println("not loaded")}
        
        return cell
        
    }
    
    func refreshTable()
    {
        dispatch_async(dispatch_get_main_queue(),{
            self.tableView.reloadData()
            return
        })
    }

}
