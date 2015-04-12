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


class ProduitsTableVC: UITableViewController, UITableViewDataSource, UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
    
    var zipCodeClient: AnyObject!
    var jsonError: NSError?
    
    var products: Product!
    var jsonDictionary:JSON!
    
    var category: Int! = 2 // Par défaut
    
    var cpt: Int! = 0
    
    @IBOutlet weak var categoryPicker: UIPickerView!
     let pickerData = ["Beverages","Burgers & Sandwiches","Deserts","Sushis"," Salads","Pizza", "Vegetarian","Pasta","Asian","Breakfast","Libanais", "Apetizer"]
    
    @IBAction func action(sender: AnyObject) {
        println(self.jsonDictionary)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView .reloadData()
    }
    
    func countCat(category : Int!) -> Int {
        for (index: String, subJson: JSON) in self.jsonDictionary {
            if(subJson["category_id"].intValue == self.category){
                self.cpt = self.cpt + 1
            }
        }
        return self.cpt
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countCat(self.category)
        tableView.registerNib(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCellOne")
        println(self.jsonDictionary)
        var nav = self.navigationController?.navigationBar
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "profile")
        imageView.image = image
        navigationItem.titleView = imageView
        categoryPicker.dataSource = self
        categoryPicker.delegate = self

    }
    
    override func tableView(
        tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int
    {
        println("---\(cpt)")
        return cpt
    }

    override func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
         var cell = tableView.dequeueReusableCellWithIdentifier("cell") as ProductCell

        if(self.jsonDictionary[indexPath.row]["category_id"].intValue == self.category)
        {
            cell.label.text   = self.jsonDictionary[indexPath.row]["name"].string
            cell.note.text   = self.jsonDictionary[indexPath.row]["note"].string
            cell.price.text = self.jsonDictionary[indexPath.row]["price"].stringValue
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
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.category = find(pickerData,pickerData[row])! + 2
        println(self.category)
        self.cpt = 0
        countCat(self.category)
        refreshTable()
    }

}
