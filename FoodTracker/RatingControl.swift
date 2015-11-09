//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Alper on 24/10/15.
//  Copyright © 2015 Apple Inc. All rights reserved.
//

import UIKit

class RatingControl: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: Properties
    
    //??
    var rating = 0{
        didSet {
            setNeedsLayout()
        }
    }
    
    var ratingButtons = [UIButton]()
    var spacing = 5
    var stars = 5
    
    
    //MARK: Initilization
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        let emptyStarImage = UIImage(named: "emptyStar")
        let filledStarImage = UIImage(named: "filledStar")
        
        for _ in 0..<stars{
            
            let button = UIButton()
            
            button.setImage(emptyStarImage, forState: .Normal)
            button.setImage(filledStarImage, forState: .Selected)
            button.setImage(filledStarImage, forState: [.Highlighted,.Selected])
            
            //??
            //button.adjustsImageWhenHighlighted = false
            
            button.addTarget(self, action: "ratingButtonTapped:", forControlEvents:.TouchDown )

            ratingButtons += [button]
            addSubview(button)
        
        }// end for in
        
    }// end init
    
    override func intrinsicContentSize() -> CGSize {
        
        let buttonSize = Int(frame.size.height)
        
        let width = (buttonSize + spacing) * stars
        
        return CGSize(width: width, height: buttonSize)
    }
    
    override func layoutSubviews() {
        
        let buttonSize = Int(frame.size.height)
        
        var buttonFrame =  CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        
        for (index,button) in ratingButtons.enumerate(){
            buttonFrame.origin.x = CGFloat(index *
                (buttonSize + spacing))
            
            button.frame = buttonFrame
        }
        
        updateButtonSelectionStates()
    }
    
    func ratingButtonTapped(button: UIButton){
        rating = ratingButtons.indexOf(button)! + 1
    
        updateButtonSelectionStates()
    }
    
    func updateButtonSelectionStates(){
        
        for (index,button) in ratingButtons.enumerate(){
            
            button.selected = index < rating
        
        }
    }
    
    
    
    
}
