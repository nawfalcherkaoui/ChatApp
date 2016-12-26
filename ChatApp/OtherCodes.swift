//
//  OtherCodes.swift
//  ChatApp
//
//  Created by nawfal cherkaoui on 10/29/16.
//  Copyright © 2016 nawfal cherkaoui. All rights reserved.
//

import Foundation



/* old code for chatLogController Constraint */

//        view.addSubview(containerView)
//        containerView.addSubview(sendButton)
//        containerView.addSubview(inputTextView)
//        containerView.addSubview(separatorLineView)

//        //x,y,w,h
//        containerView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
//        bottomContainerViewConstraint = containerView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
//        bottomContainerViewConstraint!.active = true
//        containerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
//        containerView.heightAnchor.constraintGreaterThanOrEqualToConstant(50).active = true // the height is flexible, it's either 50 or greather, meaning as the text grow, the height grow as well
//        //containerView.heightAnchor.constraintLessThanOrEqualToConstant(426).active = true
//        containerView.topAnchor.constraintEqualToAnchor(collectionView.bottomAnchor).active = true
//
//        //x,y,w,h
//        sendButton.rightAnchor.constraintEqualToAnchor(containerView.rightAnchor).active = true
//        //sendButton.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true   -> this will make it be in the center as the container grows but you want it to stick at the bottom
//        sendButton.bottomAnchor.constraintEqualToAnchor(containerView.bottomAnchor, constant: 0).active = true
//        sendButton.widthAnchor.constraintEqualToConstant(60).active = true
//        sendButton.heightAnchor.constraintEqualToConstant(50).active = true
//
//        //x,y,w,h  by having the constraint for the textView (tops, bottom, left right) and setting the height for the input container to be flexible >=50 then if the text grow both of them will grow as well.
//        inputTextView.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor, constant: 8).active = true
//        inputTextView.topAnchor.constraintEqualToAnchor(containerView.topAnchor, constant: 5).active = true
//        inputTextView.rightAnchor.constraintEqualToAnchor(sendButton.leftAnchor).active = true
//        inputTextView.bottomAnchor.constraintEqualToAnchor(containerView.bottomAnchor, constant: -5).active = true
//
//        /*
//            this is optional if you want the textView and The inputContainer to stop growing at a certain height
//            also the containerView will only grow if the text is growing by making the constraint less than or equal to a certain height we will stop growing at that height and make the text view scrollable
//            inputTextView.heightAnchor.constraintLessThanOrEqualToConstant((UIScreen.mainScreen().bounds.height/2)).active = true
//         */
//
//        //x,y,w,h
//        separatorLineView.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor).active = true
//        separatorLineView.topAnchor.constraintEqualToAnchor(containerView.topAnchor).active = true
//        separatorLineView.widthAnchor.constraintEqualToAnchor(containerView.widthAnchor).active = true
//        separatorLineView.heightAnchor.constraintEqualToConstant(1).active = true


/******************************************************************************************************************************************************/



// -> this is for anytime the user edit, or change anything in the text view it will get fired.

//var heightText: CGFloat = 0
//this is not required but if he presses to jump line it will hide the keyboard
//    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        // this will dissmiss the keyboard whenever the user presses Return (jumpline)
////        if text == "\n"
////        {
////            textView.resignFirstResponder()
////            return false
////        }
//
////        if text.characters.count == 0 {
////            // Back pressed
////            print("back pressed")
////            return false
////        }
//        // keeping track of the height of the text
////        let size = CGSize(width: view.bounds.width, height: 1000)
////        let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
////        let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(14)]
////
////        let rect = NSString(string: text).boundingRectWithSize(size, options: options, attributes: attributes, context: nil)
////        heightText += rect.height
////        print("text Height is = \(heightText)")
//
//        let screenHeight = UIScreen.mainScreen().bounds.height
//        let total = screenHeight - ((navigationController?.navigationBar.frame.size.height)! + keyboardHeight! + 31)
//        print("tottal is \(total)" )
//        print(textView.frame.height)
//        print(range.length)
//
//        if textView.frame.height > total - 100 && text.characters.count != 0 { // the height is bigger than the sapce given make it scrollable
//            inputTextView.scrollEnabled = true
//        }else if text.characters.count == 0 { // otherwise we're going to shrink it
//
//            print("delete button pressed")
//
//            if textView.frame.height == 283.5  {
//                print("I am here")
//                inputTextView.scrollEnabled = false
//            }
//
//        }
//        return true
//    }












//view.addSubview(userInfoContainer)
//
//userInfoContainer.addSubview(profileImage)
//userInfoContainer.addSubview(userName)
//userInfoContainer.addSubview(descreptiveText)
//userInfoContainer.addSubview(button)
//userInfoContainer.addSubview(separatorLineView)
//userInfoContainer.addSubview(posts)
//userInfoContainer.addSubview(followers)
//userInfoContainer.addSubview(following)
//
//view.addSubview(collectionView)
//
//// x,y,h,w
//userInfoContainer.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.bottomAnchor).active = true
//userInfoContainer.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
//userInfoContainer.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
//userInfoContainer.heightAnchor.constraintEqualToConstant(160).active = true
//
//// x,y,h,w
//profileImage.topAnchor.constraintEqualToAnchor(userInfoContainer.topAnchor, constant: 8).active = true
//profileImage.leadingAnchor.constraintEqualToAnchor(userInfoContainer.leadingAnchor, constant: 8).active = true
//profileImage.heightAnchor.constraintEqualToConstant(70).active = true
//profileImage.widthAnchor.constraintEqualToConstant(70).active = true
//
//
//// x,y,h,w
//userName.topAnchor.constraintEqualToAnchor(profileImage.bottomAnchor, constant: 8).active = true
//userName.leadingAnchor.constraintEqualToAnchor(profileImage.leadingAnchor).active = true
////userName.bottomAnchor.constraintEqualToAnchor(descreptiveText.topAnchor).active = true
//
//// x,y,h,w
//descreptiveText.topAnchor.constraintEqualToAnchor(userName.bottomAnchor, constant: -2).active = true
//descreptiveText.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 3).active = true
//descreptiveText.trailingAnchor.constraintEqualToAnchor(userInfoContainer.trailingAnchor, constant: -25).active = true
//descreptiveText.bottomAnchor.constraintEqualToAnchor(userInfoContainer.bottomAnchor).active = true
//
//// x,y,h,w
//separatorLineView.bottomAnchor.constraintEqualToAnchor(userInfoContainer.bottomAnchor).active = true
//separatorLineView.leadingAnchor.constraintEqualToAnchor(userInfoContainer.leadingAnchor).active = true
//separatorLineView.trailingAnchor.constraintEqualToAnchor(userInfoContainer.trailingAnchor).active = true
//separatorLineView.heightAnchor.constraintEqualToConstant(1).active = true
//
//// x,y,h,w
//posts.topAnchor.constraintEqualToAnchor(userInfoContainer.topAnchor, constant: 8).active = true
//posts.bottomAnchor.constraintEqualToAnchor(button.topAnchor, constant: -2).active = true
//posts.leadingAnchor.constraintEqualToAnchor(button.leadingAnchor).active = true
//posts.trailingAnchor.constraintEqualToAnchor(following.leadingAnchor).active = true
//
//// x,y,h,w
//following.topAnchor.constraintEqualToAnchor(userInfoContainer.topAnchor, constant: 8).active = true
//following.bottomAnchor.constraintEqualToAnchor(button.topAnchor, constant: -2).active = true
//following.leadingAnchor.constraintEqualToAnchor(posts.trailingAnchor).active = true
//following.trailingAnchor.constraintEqualToAnchor(followers.leadingAnchor).active = true
//following.widthAnchor.constraintEqualToAnchor(posts.widthAnchor, multiplier: 1).active = true
//
//// x,y,h,w
//followers.topAnchor.constraintEqualToAnchor(userInfoContainer.topAnchor, constant: 8).active = true
//followers.bottomAnchor.constraintEqualToAnchor(button.topAnchor, constant: -2).active = true
//followers.leadingAnchor.constraintEqualToAnchor(following.trailingAnchor).active = true
//followers.trailingAnchor.constraintEqualToAnchor(button.trailingAnchor).active = true
//// the multiplier means if you want the width to be equal then you put 1, double the width then 2 will do it. 1/2 the width of post ect..
//followers.widthAnchor.constraintEqualToAnchor(posts.widthAnchor, multiplier: 1).active = true
//
//// x,y,h,w
////button.topAnchor.constraintEqualToAnchor(userInfoContainer.topAnchor, constant: 8).active = true
//button.leadingAnchor.constraintEqualToAnchor(profileImage.trailingAnchor, constant: 16).active = true
//button.trailingAnchor.constraintEqualToAnchor(userInfoContainer.trailingAnchor, constant: -8).active = true
////button.bottomAnchor.constraintEqualToAnchor(userName.topAnchor).active = true
//button.bottomAnchor.constraintEqualToAnchor(userName.topAnchor, constant: -8).active = true
//
//// x,y,h,w
//collectionView.topAnchor.constraintEqualToAnchor(userInfoContainer.bottomAnchor).active = true
//collectionView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
//collectionView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
//collectionView.bottomAnchor.constraintEqualToAnchor(self.bottomLayoutGuide.topAnchor).active = true





/*
// this function will get all the messages that were sent or recieved by this user from user-messages ref in firebase, to display them in MessagesController ordered by their recent dates.
func observeEventMessages() {
    // getting the user's id using a simple guard statement
    guard let uid = FIRAuth.auth()?.currentUser?.uid else {
        return
    }
    // going to user-messages/uid and getting every Child in there and this will get fired automaticaly everytime a child gets added
    // so we have all the chatpartnerId's underneath uid and under each partnerId's we have all the messagesKeys that were sent between uid and the chatPartner.
    ref.child("user-messages").child(uid).observeEventType(.ChildAdded, withBlock: { (snapshot) in
        // messageId here is every child under user-messages/uid. just the key
        let chatPartnerId = snapshot.key
        // after getting the chatPartnerId, we need to fire a request on every child gets added
        self.ref.child("user-messages").child(uid).child(chatPartnerId).observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let messageId = snapshot.key
            let messagesReference = FIRDatabase.database().reference().child("messages").child(messageId)
            messagesReference.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject] {
                    let message = Message()
                    message.setValuesForKeysWithDictionary(dict)
                    
                    // reall bad data structure here, it definitely needs improvment, using the data in a dictioanry then putting it in an array and the sorting the array (this keeps repeating everytime we get a message)
                    // we're making a dictionary of keys as "toId" meaning what user is getting this message and the values are the message itself. so next time we get a message and store in the dictionary we will overrite the value
                    // if the key is the same (because the goal here is to only keep track of the last massages the user sends or recieves to show).
                    
                    //                        if let toId = message.toId, let fromId = message.fromId {
                    //                            if toId == uid {
                    //                                self.messagesDictionary[fromId] = message
                    //                            } else {
                    //                                self.messagesDictionary[toId] = message
                    //                            }
                    //                        }
                    self.messagesDictionary[chatPartnerId] = message
                    
                    // this what makes it a bad data structure
                    self.messages = Array(self.messagesDictionary.values)
                    
                    // we're not sorting them for now because this causes problems for now, we just have to find an efficient way.
                    //                    self.messages.sortInPlace({ (message1, message2) -> Bool in
                    //                        return message1.timestamp?.intValue > message2.timestamp?.intValue
                    //                    })
                    
                    
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                }
                
                }, withCancelBlock: nil)
            
            
            }, withCancelBlock: nil)
        
        }, withCancelBlock: nil)
}
 
 */

