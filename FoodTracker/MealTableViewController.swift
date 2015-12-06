//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Alper on 27/10/15.
//  Copyright © 2015 Apple Inc. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {
    
    //MARK:Properties
    
    var deleteRequest:AWSS3DeleteObjectRequest?
    var meals = [Meal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false


         //the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem()
    
        //Load the sample data
        //loadSampleMeals()
    }
    
    func loadSampleMeals(){
        
        let photo1 = UIImage(named: "meal1")!
        let meal1 = Meal(name: "Hamburger", photo: photo1, rating: 5)!
        
        
        meals += [ meal1 ]
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meals.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        return cell    }
    

  
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            
            //Delete image from S3
            deleteFromS3Bucket(indexPath)
          
            // Delete the row from the data source
            meals.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowDetail"{
                let mealDetailViewController = segue.destinationViewController as! MealViewController
                //This code tries to downcast the destination view controller of the segue to a MealViewController using the forced type cast operator (as!).  If the cast is successful, the local constant mealDetailViewController gets assigned the value of segue.destinationViewController cast as type MealViewController. If the cast is unsuccessful, the app should crash at runtime.
                
                
                
                //Get the cell that generated this segue.
                
                if let selectedMealCell = sender as? MealTableViewCell{
                    // If the cast is successful, the local constant selectedMealCell gets assigned the value of sender cast as type MealTableViewCell, and the if statement proceeds to execute. If the cast is unsuccessful, the expression evaluates to nil and the if statement isn’t executed.
                    
                    let indexPath = tableView.indexPathForCell(selectedMealCell)!
                    let selectedMeal = meals[indexPath.row]
                    
                    mealDetailViewController.meal = selectedMeal
                    
                }
        }
        
            else if segue.identifier == "AddItem"{
            print("Adding new meal.")
                
            
//                let controller = segue.destinationViewController as! MealViewController
//                
//                print(meals.count)
//                controller.count = meals.count
            
            
        }
    }
    
    
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        
        
        if let sourceViewController = sender.sourceViewController as? MealViewController, meal = sourceViewController.meal {

        //This code uses the optional type cast operator (as?) to try to downcast the source view controller of the segue to type MealViewController. You need to downcast because sender.sourceViewController is of type UIViewController, but you need to work with MealViewController.
            
            
        // This code checks whether a row in the table view is selected. If it is, that means a user tapped one of the table views cells to edit a meal. In other words, this if statement gets executed if an existing meal is being edited.
           
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
               
                //Update an existing meal
                
                meals[selectedIndexPath.row] = meal
               
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            
            }//end if
            
            else{
                
                //Add a new meal
                let newIndexPath = NSIndexPath(forRow: meals.count, inSection: 0)
        
                meals.append(meal)
                
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            } //end else
        
        }//end if
    
    }//end func
    
    
    //MARK: S3 delete stuff
    func deleteFromS3Bucket(indexPath: NSIndexPath){
        
        let S3 = AWSS3.defaultS3()
        deleteRequest = AWSS3DeleteObjectRequest()
        
        deleteRequest?.bucket = "my-s3-baubox-storage"
        
        let meal = meals[indexPath.row]
        
        let deleteImage = "\(meal.name).jpg"
        deleteRequest?.key = deleteImage
        
        
        let task = S3.deleteObject(deleteRequest)
        task.continueWithBlock { (task) -> AnyObject! in
            if task.error != nil {
                print("Error: \(task.error)")
            } else {
                print("Delete successful")
            }
            return nil
        }
        
    
    }

}//end class
