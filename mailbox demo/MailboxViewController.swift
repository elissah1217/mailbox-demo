//
//  MailboxViewController.swift
//  mailbox demo
//
//  Created by Hsin Yi Huang on 5/19/15.
//  Copyright (c) 2015 Hsin Yi Huang. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var composeView: UIView!
    @IBOutlet weak var composeViewPopup: UIView!
    @IBOutlet weak var composeField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    //variable for undo
    var lastStep: String!
    var lastMessageIndex: Int!
    @IBOutlet weak var viewSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var messageScrollView: UIScrollView!
    @IBOutlet weak var archiveScrollView: UIScrollView!
    @IBOutlet weak var laterScrollView: UIScrollView!
    
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var laterImageView: UIImageView!
    
    
    
    var messageList: Array<UIImageView> = []
    var laterList: Array<UIImageView> = []
    var archiveList: Array<UIImageView> = []
    
    var menuRevealPointX = CGFloat(150)
    
    //message outlet
    @IBOutlet weak var messageView: UIView!
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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageScrollView.contentSize = CGSize(width: 320, height: 516)
        
        archiveScrollView.hidden = true
        laterScrollView.hidden = true
        
        resetCompose()
        resetIcon()
        lastStep = "none"
        lastMessageIndex = nil
        
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        messageView.addGestureRecognizer(edgeGesture)

        
        var firstMessageY = 0
        //create list of images
        for var index = 0; index < 12; ++index {
            var image = UIImage(named: "message")
            var imageView = UIImageView(frame: CGRectMake(0, CGFloat(firstMessageY + index * 86), view.frame.size.width, 86))
            imageView.image = image
             var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onMessagePan:")
            imageView.addGestureRecognizer(panGestureRecognizer)
            imageView.userInteractionEnabled = true
            messageScrollView.addSubview(imageView);
            messageList.append(imageView)
            //println(messageList[index].frame.origin.y)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    ///////////shaking//////////
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if(event.subtype == UIEventSubtype.MotionShake) {
            undo();
           /* var alert = UIAlertController(title: "Shaken",
                message: "index: \(lastMessageIndex)",
                preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)*/
        }
    }
    
    ///////////////////////////
    
    
    
    func onEdgePan(sender:UIPanGestureRecognizer){
        
        var translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began{
        }
        else if sender.state == UIGestureRecognizerState.Changed{
             messageView.frame.origin = CGPoint(x: translation.x, y: 0)
        }
        else if sender.state == UIGestureRecognizerState.Ended{
            if messageView.frame.origin.x > menuRevealPointX{
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.frame.origin.x = 320
                })
            }
            else{
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.frame.origin.x = 0
                })
                
            }
        }
    }
    
    
    
    func resetCompose(){
        composeView.hidden = true
        composeView.alpha = 0
        composeViewPopup.frame.origin.y = 100
        sendButton.enabled = false
    }
    
    func resetIcon(){
        //Message
        archiveIcon.alpha = 0
        laterIcon.alpha = 0
        deleteIcon.alpha = 0
        listIcon.alpha = 0
        
        listImageView.hidden = true
        listImageView.alpha = 0
        laterImageView.hidden = true
        laterImageView.alpha = 0
    }
    
    @IBAction func onMessagePan(sender: UIPanGestureRecognizer) {
        var location = sender.locationInView(view)
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        
        messageImageView =  sender.view as UIImageView
        
        if sender.state == UIGestureRecognizerState.Began{
            //println("begin panning")
            initialLocation = messageImageView.center
        }
            
        else if sender.state == UIGestureRecognizerState.Changed{
            messageImageView.center = CGPoint(x: initialLocation.x + translation.x, y: initialLocation.y)
           // println(messageImageView.center.x)
            
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
            
            //change background color
            if messageImageView.center.x < -100{
                messageScrollView.backgroundColor = brownColor
                laterIcon.alpha = 0
                listIcon.alpha = 1
            }
                
            else if messageImageView.center.x >= -100 && messageImageView.center.x < 100{
                messageScrollView.backgroundColor = yellowColor
                laterIcon.alpha = 1
                listIcon.alpha = 0
                
            }
                
            else if messageImageView.center.x >= 100 && messageImageView.center.x < 160 {
                messageScrollView.backgroundColor = grayColor
                //changing alpha value
                if messageImageView.center.x <= 140{
                    laterIcon.alpha = progressValue(messageImageView.center.x, refValueMin: 140, refValueMax: 100, convertValueMin: 0, convertValueMax: 1)
                }
            }
                
            else if messageImageView.center.x <= 220 && messageImageView.center.x >= 160 {
                messageScrollView.backgroundColor = grayColor
                //changing the alpha value of archive icon
                if messageImageView.center.x >= 180{
                    archiveIcon.alpha = progressValue(messageImageView.center.x, refValueMin: 180, refValueMax: 220, convertValueMin: 0, convertValueMax: 1)
                    // println(currentValue)
                }
                
            }
            if messageImageView.center.x > 220 && messageImageView.center.x < 400{
                messageScrollView.backgroundColor = greenColor
                archiveIcon.alpha = 1
                deleteIcon.alpha = 0
                
            }
            else if messageImageView.center.x >= 420{
                messageScrollView.backgroundColor = redColor
                archiveIcon.alpha = 0
                deleteIcon.alpha = 1
            }
            
        }
            
        else if sender.state == UIGestureRecognizerState.Ended{
            var image = UIImage(named: "message")
            var imageView = UIImageView(frame: CGRectMake(0, 0, laterScrollView.frame.size.width, 86))
            imageView.image = image
            
            
            //snapping back if area is gray
            if (messageImageView.center.x <= 220 && messageImageView.center.x >= 160) || (messageImageView.center.x >= 100 && messageImageView.center.x < 160) {
                UIView.animateWithDuration(0.3, animations: {
                    self.messageImageView.center.x = 160
                })
            }//if
            else if messageScrollView.backgroundColor == brownColor {
                animateMessageLeft()
                lastStep = "list"
            }
            else if messageScrollView.backgroundColor == yellowColor{
                animateMessageLeft()
                imageView.frame.origin.y = CGFloat(laterList.count * 86)
                laterScrollView.addSubview(imageView);
                laterList.append(imageView)
                lastStep = "later"
                
            }//else if
            else if messageScrollView.backgroundColor == redColor{
                aniamteMessageRight()
                lastStep = "delete"
            }
            else if messageScrollView.backgroundColor == greenColor{
                aniamteMessageRight()
                imageView.frame.origin.y = CGFloat(archiveList.count * 86)
                archiveScrollView.addSubview(imageView);
                archiveList.append(imageView)
                lastStep = "archieve"
            }
            
        }
        
    }
    
    
    //animate the rest of messages up
    func removeMessage(){
        resetIcon()
        for var index = 0; index < messageList.count; ++index {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.messageList[index].frame.origin.y -= 86
                if self.messageList[index].frame.origin.x != 0{
                    self.lastMessageIndex = index
                }
            })
        }
        
    }
    
    func aniamteMessageRight(){
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.messageImageView.frame.origin.x = 320
            self.archiveIcon.frame.origin.x = self.messageImageView.frame.origin.x - 35
            self.deleteIcon.frame.origin.x = self.messageImageView.frame.origin.x - 35
            
        })
        removeMessage()
    }
    
    
    
    func undo(){
        if messageList[0].frame.origin.x != 0 && lastMessageIndex != -1 { //if there's already an out of view message
            for var index = 0; index < messageList.count; ++index {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageList[index].frame.origin.y += 86
                })
            }
            messageList[lastMessageIndex].frame.origin.x = 0
           if lastStep == "archieve"{
                archiveList[archiveList.count-1].removeFromSuperview()
                archiveList.removeAtIndex(archiveList.count-1)
            }
            else if lastStep == "later"{
                laterList[laterList.count-1].removeFromSuperview()
                laterList.removeAtIndex(laterList.count-1)
            }
            
            lastMessageIndex = -1
        }
    }
    
    func animateMessageLeft(){
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.messageImageView.frame.origin.x = -320
            self.laterIcon.frame.origin.x = self.messageImageView.frame.origin.x + self.messageImageView.frame.size.width + 10
            self.listIcon.frame.origin.x = self.messageImageView.frame.origin.x + self.messageImageView.frame.size.width + 10
        }) { (Bool) -> Void in
            if self.messageScrollView.backgroundColor == self.brownColor{
                self.listImageView.hidden = false
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.listImageView.alpha = 1
                })
            }//if
            else if self.messageScrollView.backgroundColor == self.yellowColor{
                println("yellow ")
                println(self.laterImageView.frame.origin.x)
                self.laterImageView.hidden = false
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.laterImageView.alpha = 1
                })
            }
        }
    }
    
    
    
    @IBAction func dismissPopup(sender: UITapGestureRecognizer) {
        let imageView =  sender.view as UIImageView
        imageView.hidden = true
        removeMessage()
    }
    
    
    @IBAction func mailBoxButtonPressed(sender: AnyObject) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.messageView.frame.origin.x = 0
        })
    }
    
    
    @IBAction func switchView(sender: AnyObject) {
        laterScrollView.hidden = false
        messageScrollView.hidden = false
        archiveScrollView.hidden = false
        if viewSegmentControl.selectedSegmentIndex == 0{
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.laterScrollView.frame.origin.x = 0
                self.messageScrollView.frame.origin.x = 320
                self.archiveScrollView.frame.origin.x = 640
                })
        }
        else if viewSegmentControl.selectedSegmentIndex == 1{
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.laterScrollView.frame.origin.x = -320
                self.messageScrollView.frame.origin.x = 0
                self.archiveScrollView.frame.origin.x = 320
            }, completion: { (Bool) -> Void in
                self.laterScrollView.hidden = true
            })
        }
        else if viewSegmentControl.selectedSegmentIndex == 2{
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.laterScrollView.frame.origin.x = -640
                self.messageScrollView.frame.origin.x = -320
                self.archiveScrollView.frame.origin.x = 0
                })
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.laterScrollView.frame.origin.x = -640
                self.messageScrollView.frame.origin.x = -320
                self.archiveScrollView.frame.origin.x = 0
            }, completion: { (Bool) -> Void in
                self.laterScrollView.hidden = true
                self.messageScrollView.hidden = true
            })
            
        }
    }
    
    
    @IBAction func composeButtonPressed(sender: AnyObject) {
        composeView.hidden = false
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.composeView.alpha = 1
            self.composeViewPopup.frame.origin.y = 22
        })
        composeField.becomeFirstResponder()
        
    }
    
    @IBAction func cancelComposeButtonPressed(sender: AnyObject) {
        view.endEditing(true)
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.composeView.alpha = 0
        }) { (Bool) -> Void in
            self.resetCompose()
        }
        
    }
    
    

    
    func progressValue(value: CGFloat, refValueMin: CGFloat, refValueMax: CGFloat, convertValueMin: CGFloat, convertValueMax: CGFloat) -> CGFloat {
        
        var ratio = (value - refValueMin)/(refValueMax - refValueMin)
        var currentValue = (convertValueMax - convertValueMin)*ratio + convertValueMin
        return currentValue
    }


    

}
