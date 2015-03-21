//
//  ProduitsTableVC.swift
//  Foodlidays-Client
//
//  Created by Timothy Khoury on 24/02/15.
//  Copyright (c) 2015 Timothy Khoury. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

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
    var jsonDictionary:JSON!
    
    @IBAction func action(sender: AnyObject) {
        println(self.jsonDictionary)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView .reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCellOne")
        println(self.jsonDictionary)

    }
    
    override func tableView(
        tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
           return self.jsonDictionary.count
    }

    override func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
         var cell = tableView.dequeueReusableCellWithIdentifier("cell") as ProductCell
        
            if(self.jsonDictionary != nil)
            {
        
            var title   = self.jsonDictionary[indexPath.row]["name"].string
            var poster  = self.jsonDictionary[indexPath.row]["note"].string
            var descrip = self.jsonDictionary[indexPath.row]["price"].string
            var img     = self.jsonDictionary[indexPath.row]["image"].string
                
                println(descrip)
                
                
                if let avatarString = NSURL(string: "http://foodlidays.dev.innervisiongroup.com/uploads/\(img)") {
                    dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)){
                        
                        let imageData = NSData(contentsOfURL: avatarString)
                        dispatch_async(dispatch_get_main_queue()) {
                            if imageData != nil {
                                cell.img.image = UIImage(data: imageData!)
                                
                            }
                              else { cell.img.image = UIImage(data: NSData(contentsOfURL: NSURL(string:"http://puu.sh/gJwYV/fa3d1cb517.png")!)!)
                            }
                        }
                    }
                }
        
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
