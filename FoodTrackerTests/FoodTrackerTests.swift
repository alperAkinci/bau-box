//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Jane Appleseed on 5/23/15.
//  Copyright © 2015 Apple Inc. All rights reserved.
//

import XCTest

class FoodTrackerTests: XCTestCase {
    
   //MARK : FoodTracker Tests
    
    
    // Tests to confirm that the Meal initializer returns when no name or a negative rating is provided.
    func testMealInitialization(){
    
        //Success Case 
        let potentialItem = Meal(name: "Newest meal ", photo: nil , rating: 5)
        XCTAssertNotNil(potentialItem)
        
        //Failure Case
        let noName = Meal(name: "", photo: nil , rating:3 )
        XCTAssertNil(noName,"Empty name is invalid ")
        
        let badRating = Meal (name : "Hamburger" , photo : nil , rating: -4)
        XCTAssertNil(badRating,"Negative ratings are invalid , be positive")
    
    }
    
    
}
