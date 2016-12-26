//
//  ChatLogController.swift
//  ChatApp
//
//  Created by nawfal cherkaoui on 9/18/16.
//  Copyright © 2016 nawfal cherkaoui. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    /* Variables: - */
    var user: User? {
        didSet {
            //titleView.text = user?.name
            //navigationItem.title = user?.name
            observeMessages()
        }
    }
    
    var messages = [Message]()
    var bottomCollectionViewConstraint: NSLayoutConstraint?
    var lastContentOffset: CGFloat = 0
    var timer = NSTimer()
    
    // one thing that we know here is that user will be initialized before this viewController get loaded because we're passing the user data
    // from MessagesController when he presses at a cell. And this titleView will get called and get its text label from the user.
    lazy var titleView: UILabel = {
        let titleView = UILabel()
        titleView.text = self.user?.name
        let width = titleView.sizeThatFits(CGSizeMake(CGFloat.max, CGFloat.max)).width
        if let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height {
            titleView.frame = CGRect(origin:CGPointZero, size:CGSizeMake(width, navigationBarHeight))
        }
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(showProfileVC))
        titleView.userInteractionEnabled = true
        titleView.addGestureRecognizer(recognizer)
        
        return titleView
    }()
    
    lazy var collectionView: UICollectionView = {
        var flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        // regestering the cell for collection view
        collectionView.registerClass(ChatMessageCell.self, forCellWithReuseIdentifier: "CellId")
        // this will only dissmiss the keyBoard if you drag it down and won't do anything if you drag the scrollView down
        collectionView.keyboardDismissMode = .Interactive
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.alwaysBounceVertical = true
        //collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -8, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false // We do this to not give it any permissions to mess with the constraints and follow our constraints.
        self.automaticallyAdjustsScrollViewInsets = false // this will prevent the spacing that automatically comes on top of the first cell when you set collectionView programatically.
        return collectionView
    }()
    
    //InputAccessoryView is a class View that I made that contains the textView, send button and all of the other component.
    lazy var accessoryView: InputAccessoryView = {
        let inputAccessoryView = InputAccessoryView()
        inputAccessoryView.user = self.user
        return inputAccessoryView
    }()
    
    // inputAccessoryView sits just right on top of the keyboard and when the keyboard moves the view follows it as well.
    override var inputAccessoryView: UIView? {
        get {
            return accessoryView
        }
    }
    
    // we need to set this to true in order for inputAccessoryView to work
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .whiteColor()
        
        // confirming to the delgates of collections view
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // setting the titleView of the VC  to the titleView property we declared above
        self.navigationItem.titleView = titleView
        
        setupInputComponents()
        //inputTextView.keyboardType = .Twitter
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatLogController.keyBoardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatLogController.keyBoardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
        /*
     setting up this Observer Notification in viewDidLoad will only observe the notification once when the View Controller is first created but we wanted to be observed anytime the user clicks on the imageIcon to present the ImagePickerController. So putting it in viewWillAppear, we're saying anytime the the view appears be ready to listen for that ImagePickerControllerNotification. when the user clicks at the imageIcon, we present the UIImagePickerController and when it gets dismissed, viewWillAppear will get called again and listen for that notification which makes it just like a button with a targetAction. 
     */
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(presentImagePickerController), name:"ImagePickerControllerNotification", object: nil)
    }
    // make sure those observers are removed when the view is disappeared.
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func setupInputComponents() {
        
        view.addSubview(collectionView)
        
        //ios9 constraint anchors x,y,w,h
        collectionView.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.bottomAnchor).active = true
        collectionView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        collectionView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        bottomCollectionViewConstraint = collectionView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -(accessoryView.frame.height))
        bottomCollectionViewConstraint?.active = true
    }
    
    // getting all the messages for the conversation and storing them in an array
    func observeMessages() {
        // getting the uid for the current loggedin User and the user sending message to.
        guard let uid = FIRAuth.auth()?.currentUser?.uid, toId = user?.id else {
            return
        }
        
        let ref = FIRDatabase.database().reference()
        
        ref.child("user-messages").child(uid).child(toId).observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            let messageId = snapshot.key
            ref.child("messages").child(messageId).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let message = Message()
                message.setValuesForKeysWithDictionary(dictionary)
                
                self.messages.append(message)
                    
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionView.reloadData()
                    // everytime the user hits the send button or a message gets added we want to appear the last indexpath of the scrollView
        
                    self.scrollCollectionViewToBottom()
                })
                
            }, withCancelBlock: nil)
            
        }, withCancelBlock: nil)
    }
    
    func scrollCollectionViewToBottom() {
        if (self.messages.count) > 0 {
            let indexPath = NSIndexPath(forItem: self.messages.count-1, inSection: 0)
            self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
        }
    }
    
    func keyBoardWillShow(notification: NSNotification) {
        /*  this is if you want to get the height and width of the keyboard but since we're using inputAccessoryView we don't need it in this case because it does all the work for us. */
        
         if let userInfoDict = notification.userInfo, keyboardFrameValue = userInfoDict[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardFrameValue.CGRectValue()
            let keyboardHeight = keyboardFrame.size.height

            
            UIView.animateWithDuration(0.2) {
                // here we could've use contentInset too instead of upgrading the bottom constraint
                //self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -(keyboardFrame.size.height + self.inputContainerView.frame.height), right: 0)
                self.bottomCollectionViewConstraint?.constant = -(keyboardHeight)
                self.view.layoutIfNeeded()
            }
        }
        
        // getting the last indexPath from the last message in the array messages and scrolling down to it when the keyboard shows. we want the last message to always show.
        scrollCollectionViewToBottom()
        
    }
    
    func keyBoardWillHide(notification: NSNotification) {
        
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        bottomCollectionViewConstraint?.constant = -(accessoryView.frame.height)
        UIView.animateWithDuration(keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    func presentImagePickerController(){
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        imagePickerViewController.allowsEditing = true
        self.presentViewController(imagePickerViewController, animated: true, completion: nil)
    }
    
    // so now we have the picture that the user picked in editingImage or originalImage variables
    // the next step should be to make a small pop up that has the image and have the background color be blurry a little bit
    // and have 2 buttons one says send and the other send cancel.
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let editingImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            accessoryView.imagePickedToSend.image = editingImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            accessoryView.imagePickedToSend.image = originalImage
        }
        accessoryView.showImagePicked()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // when we do this we push a brand new controller that is different than the one appearing from tabBar, and any changes we make here will not show in the one in the taBar
    func showProfileVC() {
        
        let userProfileVC = userProfile()
        userProfileVC.user = user
        userProfileVC.button.setTitle("Following", forState: .Normal)
        userProfileVC.button.setTitleColor(.whiteColor(), forState: .Normal)
        userProfileVC.button.backgroundColor = UIColor.init(red: 118/255, green: 199/255, blue: 183/255, alpha: 1) //UIColor.init(red: 252/255, green: 92/255, blue: 99/255, alpha: 1) //UIColor.init(r: 234, g: 132, b: 108)
        navigationController?.presentViewController(userProfileVC, animated: true, completion: nil)
        //navigationController?.pushViewController(userProfileVC, animated: true)

    }
    
}



