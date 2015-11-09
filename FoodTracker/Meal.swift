//
//  Meal.swift
//  FoodTracker
//
//  Created by Alper on 25/10/15.
//  Copyright © 2015 Apple Inc. All rights reserved.
//

import UIKit


class Meal {
    
    //MARK: Properties
    var name : String
    var photo : UIImage?
    var rating : Int
    
    //MARK: Initialization
    init?(name: String , photo: UIImage? , rating : Int){
    
        self.name =  name
        self.photo = photo
        self.rating = rating
        
        // Initialization should fail if there is no name or if the rating is negative.
        if( name.isEmpty || rating < 0 ){
            return nil
        }
    }
    
    
}
