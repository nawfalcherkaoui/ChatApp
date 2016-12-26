//
//  InputAccessoryView.swift
//  ChatApp
//
//  Created by nawfal cherkaoui on 11/13/16.
//  Copyright © 2016 nawfal cherkaoui. All rights reserved.
//

import UIKit
import Firebase

class InputAccessoryView: UIView, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user: User?
    
    lazy var inputTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFontOfSize(16)
        textView.layer.borderWidth = 1.5
        textView.layer.borderColor = UIColor(r: 199, g: 199, b: 204).CGColor
        textView.layer.cornerRadius = 4
        textView.layer.masksToBounds = true
        textView.scrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var imagePickerIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.userInteractionEnabled = true
        imageView.layer.cornerRadius = 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFit
        imageView.image = UIImage(named: "Camera")
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickImageFromLibrary)))
        return imageView
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .System)
        button.setTitle("Send", forState: .Normal)
        button.tintColor = UIColor.init(red: 25/255, green: 165/255, blue: 153/255, alpha: 1)
        button.enabled = false // we're disabling the button here but once the user start typing we're enabling it, to prevent sending empty strings.
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSend), forControlEvents: .TouchUpInside)
        return button
    }()
    
    // this is how it will go, we will play with this. So if a user pick a picture then we'll add this View on top of the textView with a picture in it. and if he hit sends, we will send them seperataly to firebase. 
    let imagePickedToSend: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        imageView.image = UIImage(named: "defaultPicture")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .whiteColor()
        
        inputTextView.delegate = self 
        // This is required to make the view grow vertically
        self.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        
        // Setup textView as needed
        addSubview(sendButton)
        addSubview(inputTextView)
        addSubview(imagePickerIcon)
        addSubview(separatorLineView)
        
        //x,y,w,h
        sendButton.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        //sendButton.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true   -> this will make it be in the center as the container grows but you want it to stick at the bottom
        sendButton.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 0).active = true
        sendButton.widthAnchor.constraintEqualToConstant(60).active = true
        sendButton.heightAnchor.constraintEqualToConstant(50).active = true
        
        //x,y,w,h
        imagePickerIcon.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 8).active = true
        imagePickerIcon.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -5).active = true
        imagePickerIcon.widthAnchor.constraintEqualToConstant(30).active = true
        
        //x,y,w,h  by having the constraint for the textView (tops, bottom, left right) and setting the height for the input container to be flexible >=50 then if the text grow both of them will grow as well.
        inputTextView.leadingAnchor.constraintEqualToAnchor(imagePickerIcon.trailingAnchor, constant: 8).active = true
        inputTextView.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 5).active = true
        inputTextView.trailingAnchor.constraintEqualToAnchor(sendButton.leadingAnchor).active = true
        inputTextView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -5).active = true
        
        //x,y,w,h
        separatorLineView.leftAnchor.constraintEqualToAnchor(self.leftAnchor).active = true
        separatorLineView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        separatorLineView.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        separatorLineView.heightAnchor.constraintEqualToConstant(1).active = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func intrinsicContentSize() -> CGSize {
        // Calculate intrinsicContentSize that will fit all the text
        let textSize = self.inputTextView.sizeThatFits(CGSize(width: self.inputTextView.bounds.width, height: CGFloat.max))
        
        // we need to calculate the height of the screen and minus the navigation bar to make the textView extend all the way to the top and have the user scroll.
        let screenHeight = UIScreen.mainScreen().bounds.height
        let navigationBarHeight = UIApplication.sharedApplication().statusBarFrame.height + 44 // statusBar (carrier, time, battery) + the navigation bar
        let limitToShowText = screenHeight / 2 - navigationBarHeight
        if textSize.height > limitToShowText {
            inputTextView.scrollEnabled = true
            return CGSize(width: self.bounds.width, height: limitToShowText)
        } else {
            inputTextView.scrollEnabled = false
            return CGSize(width: self.bounds.width, height: textSize.height)
        }
    }
    
    // MARK: UITextViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        // Re-calculate intrinsicContentSize when text changes
        inputTextView.becomeFirstResponder()
        self.invalidateIntrinsicContentSize()
    }
    
    // this required in order of the text view to take effect and interact with the user otherwise no text will show on the screen. -> this will get called when the user start playing textView
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        // setting the textView inputAccessoryView to self, this also required
        inputTextView.inputAccessoryView = self
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        inputTextView.resignFirstResponder()
        return true
    }
    
//    func textViewDidEndEditing(textView: UITextView) {
//        inputTextView.text = "gqwg erw w g"
//    }
//
//    func textViewShouldEndEditing(textView: UITextView) -> Bool {
//        inputTextView.text = "gqwg erw w g"
//        return true
//    }
    
    // this function get's called anytime the user type in the inputTextView or changes anything.
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        // Find out what the text field will be after adding the current edit
        let textString = (textView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)

        if !textString.isEmpty{//Checking if the inputTextView is not empty
            sendButton.enabled = true //Enabling the button
        } else {
            sendButton.enabled = false //Disabling the button
        }
        return true
    }
    
    func handleSend() {
        
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let toId = user!.id!
        let timestamp: NSNumber = Int(NSDate().timeIntervalSince1970)
        let values: [String: AnyObject] = ["text": inputTextView.text!, "fromId": fromId, "toId": toId, "timestamp": timestamp]
        childRef.updateChildValues(values) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            // the values were succesfully updated
            
            // getting the reference of the users who is sending this message and the one recieving this message.
            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromId).child(toId) // setting a child in user-messages with the id of who's sending this msg to storing the msg there.
            let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-messages").child(toId).child(fromId) // doing the same except that the msg will be stored in the child with the reciever's id
            
            let userLastMessage = FIRDatabase.database().reference().child("last-messages").child(fromId).child(toId)
            let recipientLastMessage = FIRDatabase.database().reference().child("last-messages").child(toId).child(fromId)
            
            // getting the auto id of the message so we can store it instead of the message itself and later reference it when we need it.
            let messageId = childRef.key
            
            // storing the messageId in both users data the sender and the reciever. So each user will have all the message they send and recieved in one block.
            userMessagesRef.updateChildValues([messageId:1])
            recipientUserMessagesRef.updateChildValues([messageId: 1])
            
            userLastMessage.setValue([messageId:1])
            recipientLastMessage.setValue([messageId:1])
            
            // should this go before updating it in the user-messages to or after it got updated in all places
            self.inputTextView.text = ""
            // making the textView and inputAccesoryView go back to it's size
            self.invalidateIntrinsicContentSize()
        }
    }
    // everytime the user presses the imageIcon it will post this notification that the chatLogController listens to, and it wil present the UIImagePickerController
    func pickImageFromLibrary() {
        NSNotificationCenter.defaultCenter().postNotificationName("ImagePickerControllerNotification", object: nil)
    }
    
    // instead of doing this, make a pop up from the chatLogController that has the image and have the background color be blurry a little bit
    // and have 2 buttons one says send and the other send cancel.
    func showImagePicked() {
//        addSubview(imagePickedToSend)
//        imagePickedToSend.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
//        //sendButton.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true   -> this will make it be in the center as the container grows but you want it to stick at the bottom
//        imagePickedToSend.bottomAnchor.constraintEqualToAnchor(separatorLineView.topAnchor, constant: 0).active = true
//        //imagePickedToSend.topAnchor.constraintEqualToAnchor(separatorLineView.bottomAnchor).active = true
//        imagePickedToSend.widthAnchor.constraintEqualToConstant(60).active = true
//        imagePickedToSend.heightAnchor.constraintEqualToConstant(60).active = true
        
        if let sendingImage = imagePickedToSend.image {
           uploadToFirebaseStorageUsingImage(sendingImage) 
        }
        
    }
    
    
    private func uploadToFirebaseStorageUsingImage(image: UIImage) {
        let imageName = NSUUID().UUIDString
        let ref = FIRStorage.storage().reference().child("message_images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print("Failed to upload image:", error)
                    return
                }
                
                // the image is succefully stored in firbase storage
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    self.sendMessageWithImageUrl(imageUrl, image: image)
                }
                
            })
        }
    }
    
    private func sendMessageWithImageUrl(imageUrl: String, image: UIImage) {
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let timestamp: NSNumber = Int(NSDate().timeIntervalSince1970)
        
        let values = ["imageUrl": imageUrl, "imageWidth": image.size.width, "imageHeight": image.size.height, "toId": toId, "fromId": fromId, "timestamp": timestamp]
        
        childRef.updateChildValues(values) { (error, ref) in
            
            if error != nil {
                print(error)
                return
            }
            
            self.inputTextView.text = nil
            
            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromId).child(toId)
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-messages").child(toId).child(fromId)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
            
            let userLastMessage = FIRDatabase.database().reference().child("last-messages").child(fromId).child(toId)
            userLastMessage.setValue([messageId:1])
            
            let recipientLastMessage = FIRDatabase.database().reference().child("last-messages").child(toId).child(fromId)
            recipientLastMessage.setValue([messageId:1])
            
        }
    }
    
}
