//
//  MessageTableViewCell.swift
//  mailbox demo
//
//  Created by Hsin Yi Huang on 5/21/15.
//  Copyright (c) 2015 Hsin Yi Huang. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {


    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var archiveIcon: UIImageView!
    @IBOutlet weak var laterIcon: UIImageView!
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var listIcon: UIImageView!
    var initialLocation = CGPoint()
    let blueColor = UIColor(red: 68/255, green:170/255, blue: 210/255, alpha: 1)
    let yellowColor = UIColor(red: 254/255, green:202/255, blue: 22/255, alpha: 1)
    let brownColor = UIColor(red: 206/255, green:150/255, blue: 98/255, alpha: 1)
    let redColor = UIColor(red: 231/255, green:61/255, blue: 14/255, alpha: 1)
    let greenColor = UIColor(red: 85/255, green:213/255, blue: 80/255, alpha: 1)
    let grayColor = UIColor(red: 230/255, green:230/255, blue: 230/255, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        var recognizer = UIPanGestureRecognizer(target: self, action: "onMessagePan:")
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
        archiveIcon.alpha = 0
        laterIcon.alpha = 0
        deleteIcon.alpha = 0
        listIcon.alpha = 0

        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func onMessagePan(sender: UIPanGestureRecognizer) {
        var location = sender.locationInView(bgView)
        var translation = sender.translationInView(bgView)
        var velocity = sender.velocityInView(bgView)
        
        if sender.state == UIGestureRecognizerState.Began{
            println("begin panning")
            initialLocation = messageImageView.center
        }
        else if sender.state == UIGestureRecognizerState.Changed{
            messageImageView.center = CGPoint(x: initialLocation.x + translation.x, y: initialLocation.y)
            println(messageImageView.center.x)
            
            //changing position of the icons
            if messageImageView.frame.origin.x >= 45{
                println(messageImageView.frame.origin.x)
                archiveIcon.frame.origin.x = messageImageView.frame.origin.x - 35
                deleteIcon.frame.origin.x = messageImageView.frame.origin.x - 35
            }
            else if messageImageView.frame.origin.x <= -45{
                laterIcon.frame.origin.x = messageImageView.frame.origin.x + messageImageView.frame.size.width + 10
                listIcon.frame.origin.x = messageImageView.frame.origin.x + messageImageView.frame.size.width + 10
            }
            
            if messageImageView.center.x < -100{
                self.bgView.backgroundColor = brownColor
                laterIcon.alpha = 0
                listIcon.alpha = 1
            }
                
            else if messageImageView.center.x >= -100 && messageImageView.center.x < 100{
                self.bgView.backgroundColor = yellowColor
                laterIcon.alpha = 1
                listIcon.alpha = 0
                
            }
                
            else if messageImageView.center.x >= 100 && messageImageView.center.x < 160 {
                self.bgView.backgroundColor = grayColor
                //changing alpha value
                if messageImageView.center.x <= 140{
                    laterIcon.alpha = progressValue(messageImageView.center.x, refValueMin: 140, refValueMax: 100, convertValueMin: 0, convertValueMax: 1)
                }
            }
                
            else if messageImageView.center.x <= 220 && messageImageView.center.x >= 160 {
                self.bgView.backgroundColor = grayColor
                //changing the alpha value of archive icon
                if messageImageView.center.x >= 180{
                    archiveIcon.alpha = progressValue(messageImageView.center.x, refValueMin: 180, refValueMax: 220, convertValueMin: 0, convertValueMax: 1)
                    // println(currentValue)
                }
                
            }
            if messageImageView.center.x > 220 && messageImageView.center.x < 400{
                self.bgView.backgroundColor = greenColor
                archiveIcon.alpha = 1
                deleteIcon.alpha = 0
                
            }
            else if messageImageView.center.x >= 420{
                self.bgView.backgroundColor = redColor
                archiveIcon.alpha = 0
                deleteIcon.alpha = 1
            }
            
        }
            
        else if sender.state == UIGestureRecognizerState.Ended{
            
            //snapping back if area is gray
            if (messageImageView.center.x <= 220 && messageImageView.center.x >= 160) || (messageImageView.center.x >= 100 && messageImageView.center.x < 160) {
                UIView.animateWithDuration(0.5, animations: {
                    self.messageImageView.center.x = 160
                })
                
            }
            
        }
        
    }
    
    

    func progressValue(value: CGFloat, refValueMin: CGFloat, refValueMax: CGFloat, convertValueMin: CGFloat, convertValueMax: CGFloat) -> CGFloat {
        
        var ratio = (value - refValueMin)/(refValueMax - refValueMin)
        var currentValue = (convertValueMax - convertValueMin)*ratio + convertValueMin
        return currentValue
    }


}
