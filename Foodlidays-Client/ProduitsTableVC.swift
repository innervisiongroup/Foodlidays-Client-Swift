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
    @IBOutlet weak var quantite: UILabel!
    
    @IBAction func Stepper(sender: UIStepper) {
        quantite.text = "\(Int(sender.value))"
    }
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
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        nav?.tintColor = UIColor.yellowColor()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "profile")
        imageView.image = image
        navigationItem.titleView = imageView

    }
    
    override func tableView(
        tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
           return self.jsonDictionary.count
    }

    override func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
         var cell = tableView.dequeueReusableCellWithIdentifier("cell") as ProductCell

            cell.label.text   = self.jsonDictionary[indexPath.row]["name"].string
            cell.note.text   = self.jsonDictionary[indexPath.row]["note"].string
            cell.price.text = self.jsonDictionary[indexPath.row]["price"].stringValue
            if (cell.img.image == nil)
            {
                var img  = self.jsonDictionary[indexPath.row]["image"].stringValue
                var imgUrl = "http://foodlidays.dev.innervisiongroup.com/uploads/\(img)"
                
                ImageLoader.sharedLoader.imageForUrl(imgUrl,
                    completionHandler:{(image: UIImage?, url: String) in
                    cell.img.image = image
              })
            }
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
