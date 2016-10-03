//
//  ViewController.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 5/23/15.
//  Copyright © 2015 Apple Inc. All rights reserved.
//  See LICENSE.txt for this sample’s licensing information.
//

import UIKit

class MealViewController: UIViewController , UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    
    //@IBOutlet weak var mealNameLabel: UILabel!//Deleted Label from storyboard
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    //The weak keyword means that it’s possible for that property to have no value (be nil) at some point in its life.
   
    //MARK:AWS S3 properties
    //@IBOutlet var selectedImage:UIImageView?
    var imagePickerController:UIImagePickerController?
    var loadingBg:UIView?
    var progressView:UIView?
    var progressLabel:UILabel?
    
    var uploadRequest:AWSS3TransferManagerUploadRequest?
    //    var filesize:Int64 = 0
    //    var amountUploaded:Int64 = 0
    
    //MARK:Properties
    
    var meal: Meal?
    
    //image count number
    //var count : Int?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        //ViewController is now a delegate for nameTextField

        
        
        if let meal = meal{
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        checkValidMealName()

    }
    
    
    //MARK:UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //Hide keyboard
        textField.resignFirstResponder()// textfield first responder olma görevini başkasına bırakıyor.
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //Makes label(meal name) the text that entered to textfield!
        //mealNameLabel.text = nameTextField.text
    
        
        //The first line calls checkValidMealName() to check if the text field has text in it, which enables the Save button if it does. The second line sets the title of the scene to that text.
        checkValidMealName()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //Disable the Save Button while editing
        saveButton.enabled = false
        
    }
    
    func checkValidMealName(){
        //Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty    }
    
    //MARK:UIImagePickerController
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        // Dismiss the picker if the user canceled.
        // ? ?
        dismissViewControllerAnimated(true, completion: nil)
    }
    
        //imagePickerController(_:didFinishPickingMediaWithInfo:), gets called when a user selects a photo. This method gives you a chance to do something with the image or images that a user selected from the picker. In your case, you’ll take the selected image and display it in your UI.
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Navigation
    
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            //This code will dismiss the meal scene without storing any information. When the meal scene gets dismissed, the meal list is shown.
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController!.popViewControllerAnimated(true)
        }
        
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        //   The code below code uses the identity operator (===) to check that the object referenced by the saveButton outlet is the same object instance as sender. If it is, the if statement is executed.
        
                if (saveButton === sender){
                    
                    
                    self.uploadToS3()
                    
                    let name = nameTextField.text ?? ""
                    let photo = photoImageView.image
                    let rating = ratingControl.rating
                    
                    // Set the meal to be passed to MealTableViewController after the unwind segue.
                    meal = Meal(name: name , photo: photo, rating: rating)
                    
                    
                    //This code configures the meal property with the appropriate values before segue executes.
                    
            }
        
    
    }
    
    
    //MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        
        //Hide the keyboard
        nameTextField.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        // ? ?
        presentViewController(imagePickerController, animated: true, completion: nil)
        
        //After an image picker controller is presented, its behavior is handed off to its delegate(which is ViewController).
        
    }
    
//    @IBAction func setDefaultLabelText(sender: UIButton) {
//            mealNameLabel.text = "Default Text"
//    }
    
    
    
    
    //MARK: S3 upload stuff
    
    // WARNING!
    // Please create in your AWS S3 bucket named "my-s3-baubox-storage" before
    // using this func otherwise it doesnt work
    
    // This func uploads your selected photo to "my-s3-baubox-storage" bucket
    // in your AWS S3 storage
    func uploadToS3(){
        
        //
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        // get the image
        let img:UIImage = photoImageView!.image!
        
        
        // create a local image that we can use to upload to s3
        
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documentsURL.URLByAppendingPathComponent("\(nameTextField.text!).jpg")
        
        let path = fileURL.path!
        let imageData = UIImageJPEGRepresentation(img, 0.5)!
        imageData.writeToURL(fileURL, atomically: true)
        
        // once the image is saved we can use the path to create a local fileurl
        let url:NSURL = NSURL(fileURLWithPath: path as String)
        print(url)
        
        // next we set up the S3 upload request manager
        uploadRequest = AWSS3TransferManagerUploadRequest()
        // set the bucket
        uploadRequest?.bucket = "my-s3-baubox-storage"
        // I want this image to be public to anyone to view it so I'm setting it to Public Read
        uploadRequest?.ACL = AWSS3ObjectCannedACL.PublicRead
        // set the image's name that will be used on the s3 server. I am also creating a folder to place the image in
        uploadRequest?.key = "\(nameTextField.text!).jpg"
        // set the content type
        //uploadRequest?.contentType = "\(nameTextField.text!)/jpg"
        // and finally set the body to the local file path
        uploadRequest?.body = url
 
       
     
        let task = transferManager.upload(uploadRequest)
        task.continueWithBlock { (task) -> AnyObject! in
            if task.error != nil {
                print("Error: \(task.error)")
            } else {
                print("Upload successful")
                
                
            }
            return nil

        }
        
       
        
    }// end of UploadToS3

    
    //MARK: Loading Views
    
    
    func displayUploadingAlert(){
    
        let title = "Uploading"
        let message = "Successful!"
        let okText = "OK"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(okayButton)
        
        self.presentViewController(alert, animated: true, completion : nil)
    }

}



