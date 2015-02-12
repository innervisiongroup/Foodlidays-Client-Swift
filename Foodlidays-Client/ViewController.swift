//
//  LoginVC.swift
//  SwiftLogin
//
//  Created by Timothy Khoury on 22/01/15.
//  Copyright (c) 2015 Timothy Khoury. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    
    @IBOutlet weak var roomTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var qrCodeButton: UIButton!
    var jsonError: NSError?
    var emailReceipt : String!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    // Added to support different barcodes
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = testStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }
    
    
    func registerEmail()
    {
        
        var inputTextField: UITextField?
        let alertController = UIAlertController(title: "Email", message: "Please enter a valid email", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.emailReceipt = inputTextField?.text
            
            
            if(self.isValidEmail(self.emailReceipt) == true)
            {
                println("Valid email -> \(self.emailReceipt)")
            }
                
            else
            {
                println("No valid email")
                self.showAlert("Please enter a valid email address")
                self.emailReceipt = nil
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
        }
        
        alertController.addAction(ok)
        alertController.addAction(cancel)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            inputTextField = textField
        }
        
        
        presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    
    func showAlert(msg : String)
    {
        let alertController = UIAlertController(title: "\(msg)", message: "  ", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
        })
        alertController.addAction(ok)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func signInTapped(sender: AnyObject) {
        if roomTextField.text.isEmpty == false
        {
            
            
            let request = NSMutableURLRequest(URL: NSURL(string: "http://192.168.1.53:8000/api/v1/login")!)
            request.HTTPMethod = "POST"
            
            let postString = "room_number=\(roomTextField.text)"
            
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
                
                if error != nil {
                    println("error=\(error)")
                    return
                }
                
                if let responseArray:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &self.jsonError) as? NSDictionary
                    
                {
                    
                    
                    let room: (AnyObject!) = responseArray.objectForKey("room")
                    
                    let note:(AnyObject!) = room.objectForKey("note")
                    println("Note :  \(note)")
                    
                    let adresse:(AnyObject!) = room.objectForKey("street_address")
                    println("Adresse : \(adresse)")
                    
                    println("test commit")
                    
                    if(self.emailReceipt == nil)
                        
                    {
                        dispatch_async(dispatch_get_main_queue())
                            {
                                self.registerEmail()
                        }
                    }
                        
                    else
                    {
                        dispatch_async(dispatch_get_main_queue())
                            {
                                self.showAlert("Your email is registered as \(self.emailReceipt)")
                        }
                    }
                    
                }
                    
                    
                else
                {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.showAlert("That room number doesn't exist")
                        println("erreur de chambre")
                    }
                }
                
            }
            task.resume()
            
        }
            
        else
        {
            showAlert("Please enter a valid room number")
        }
    }
    
    @IBAction func qrCodeTapped(sender: AnyObject) {
        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error:NSError?
        let input: AnyObject! = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: &error)
        
        if (error != nil) {
            println("\(error?.localizedDescription)")
            return
        }
        
        captureSession = AVCaptureSession()
        captureSession?.addInput(input as AVCaptureInput)
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer)
        
        captureSession?.startRunning()
        
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
        
        registerEmail()
        
        println("email -> \(emailReceipt)")
        
    }
    
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            return
        }
        
        let metadataObj = metadataObjects[0] as AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
        }
        
        let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as AVMetadataMachineReadableCodeObject
        
        qrCodeFrameView?.frame = barCodeObject.bounds
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bgFoodlidays")!)
        roomTextField.attributedPlaceholder = NSAttributedString(string:"Room number",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
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
