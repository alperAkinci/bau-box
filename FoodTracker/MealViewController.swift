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

    //MARK:Properties
    
    var meal: Meal?

    
    
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
    
        
    
    
    }



