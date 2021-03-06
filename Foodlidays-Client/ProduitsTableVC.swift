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
    
    var products: JSON!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var img: UIImageView!
    var quantite: Int!
    var idProduit: Int!
    var cellCategory: Int!
    
    var checker:Int = 0
    
    @IBAction func Stepper(sender: UIStepper) {
        
        for(var counter = 0;counter < Basket.product.count; ++counter)
        {
            if(Basket.product[counter].name == label.text!)
            {
                ++checker
                Basket.product[counter].quantite = Int(sender.value)
            }
        }
        
        if(checker == 0) {
            Basket.product += [(id: idProduit!,name: label.text!,price: price.text!,note: note.text!,quantite: 1)]
        }
        
        println(Basket.product)
    }

    
}

struct Product {
    var label: String
    var price: String
    var note:  String
    var img:   UIImage
}

struct Basket {
    static var product = Array<(id: Int,name: String, price: String, note: String, quantite: Int)>()
}

class ProduitsTableVC: UITableViewController, UITableViewDataSource, UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
    
    var zipCodeClient: AnyObject!
    var jsonError: NSError?
    
    var roomNumber: String!
    var emailClient: String!
    
    var products: Product!
    var jsonDictionary:JSON!
    
    var category: Int! = 2 // Par défaut
    
    var cpt: Int! = 0
    
    var chooser: Int! = 0
    
    
    @IBOutlet weak var categoryPicker: UIPickerView!
     let pickerData = ["Beverages","Burgers & Sandwiches","Deserts","Sushis"," Salads","Pizza", "Vegetarian","Pasta","Asian","Breakfast","Libanais", "Apetizer"]
    
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
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bgProducts")!)
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
        return self.cpt
    }

    override func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! ProductCell!
        cell.backgroundColor = UIColor(white: 1, alpha: 0.7)
        
        while(self.jsonDictionary[chooser]["category_id"].intValue != self.category)
        {
            self.chooser = self.chooser + 1
        }
        
                cell.label.text   = self.jsonDictionary[chooser]["name"].string
                cell.note.text   = self.jsonDictionary[chooser]["note"].string
                cell.price.text = self.jsonDictionary[chooser]["price"].stringValue
                cell.cellCategory = self.jsonDictionary[chooser]["category_id"].intValue
                cell.idProduit = self.jsonDictionary[chooser]["id"].intValue
                var img  = self.jsonDictionary[chooser]["image"].stringValue
                var imgUrl = "http://foodlidays.dev.innervisiongroup.com/uploads/\(img)"
            
                
                    ImageLoader.sharedLoader.imageForUrl(imgUrl,
                        completionHandler:{(image: UIImage?, url: String) in
                            cell.img.image = image
                    })
        
        self.chooser = self.chooser + 1;
        
        return cell
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
        self.cpt = 0
        self.chooser = 0
        countCat(self.category)
        println(Basket.product)
        tableView.reloadData()
    }
    
    
    /***    PAGE PROFIL ***/
    
    @IBAction func profile(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("goto_profile", sender: nil)
        }
    }
    
    @IBAction func basket(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("goto_basket", sender: nil)
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "goto_profile"){
            let destinationVC = segue.destinationViewController as?
            ProfileVC
            destinationVC!.roomNumber = roomNumber
            destinationVC!.emailClient = emailClient
        }
        
        else if(segue.identifier == "goto_basket"){
            let destinationVC = segue.destinationViewController as? BasketVC
            destinationVC!.roomNumber = roomNumber
            destinationVC!.emailClient = emailClient
            destinationVC!.basket = Basket.product
        }

        
    }
    
}
