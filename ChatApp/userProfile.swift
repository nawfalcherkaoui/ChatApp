//
//  userProfile.swift
//  ChatApp
//
//  Created by nawfal cherkaoui on 11/29/16.
//  Copyright © 2016 nawfal cherkaoui. All rights reserved.
//

import UIKit
import Firebase

class userProfile: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user: User? {
        didSet {
            
            if let name = user?.name, email = user?.email {
               userName = setUserInfo(name, email: email)
            }
            
            if let profileImageURL = user?.profileImage {
                profileImageView.loadImageUsingCacheWithUrlString(profileImageURL)
            }
            
            if let uid = user?.id {
                observeUserImage(uid)
            }
        }
    }
    
    var userImagesURL = [String]()

    
    lazy var collectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.registerClass(imageCellProfile.self, forCellWithReuseIdentifier: "cellId") // regestering the cell for collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.alwaysBounceVertical = true
        //collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -8, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false // We do this to not give it any permissions to mess with the constraints and follow our constraints.
        self.automaticallyAdjustsScrollViewInsets = false // this will prevent the spacing that automatically comes on top of the first cell when you set collectionView programatically.
        
        return collectionView
    }()
    
    // layout of the collectionViewCell, setting up how the cell will layout in temrs of width, height, and spaces between them.
    let trippleFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        // setting the laout of the cell here
        let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width // getting the width of the screen
        /* we put minus 3 here because we have 1 space from the left and 1 from the right of the collectionView and 0.5 spacing between cells.
         we know we want 3 cells in a row so we'll have 1-image-0.5-image-0.5-image-1, so (screen width - all the spaces 3) / 3 will give us the
         width of each cell  */
        flowLayout.itemSize = CGSize(width: (screenWidth-3)/3.0, height: (screenWidth-3)/3.0) // giving the cell and a size
        // these 2 control the spacing between the cells.
        flowLayout.minimumInteritemSpacing = 0.5 // setting the space between the cells horizantally (x-axis)
        flowLayout.minimumLineSpacing = 0.5 // setting the space between the cells veritcally (y-axis)
        return flowLayout
    }()
    
    // layout of the collectionViewCell, setting up how the cell will layout in temrs of width, height, and spaces between them.
    let singleFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        // setting the laout of the cell here
        let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width // getting the width of the screen
        /* we put minus 3 here because we have 1 space from the left and 1 from the right of the collectionView and 0.5 spacing between cells.
         we know we want 3 cells in a row so we'll have 1-image-0.5-image-0.5-image-1, so (screen width - all the spaces 3) / 3 will give us the
         width of each cell  */
        flowLayout.itemSize = CGSize(width: screenWidth, height: (screenWidth)/1.7) // giving the cell and a size
        // these 2 control the spacing between the cells.
        flowLayout.minimumInteritemSpacing = 0.5 // setting the space between the cells horizantally (x-axis)
        flowLayout.minimumLineSpacing = 0.5 // setting the space between the cells veritcally (y-axis)
        return flowLayout
    }()
    
    
    let profileImageBackgroundView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Img3")) // img3 && BackgroundImage
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 100/2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var userName: UILabel = self.setUserInfo("UserName", email: "UserEmail@yahoo.com")
    
    func setUserInfo(name: String, email: String) -> UILabel {
        let label = UILabel()
        
        label.numberOfLines = 2
        let attributedText = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18),  NSForegroundColorAttributeName: UIColor.whiteColor()])
        attributedText.appendAttributedString(NSAttributedString(string: "\n\(email)" ,
            attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14),
                NSForegroundColorAttributeName: UIColor.whiteColor()
            ]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.characters.count))
        label.attributedText = attributedText
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    let posts: UIButton = {
        let button = UIButton()
        button.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping // allow the text to have multiple lines if you want
        button.titleLabel?.textAlignment = NSTextAlignment.Center // make the text center.
        let attributedText = NSMutableAttributedString(string: "0", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(13), NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        
        attributedText.appendAttributedString(NSAttributedString(string: "\nposts",
            attributes: [NSFontAttributeName: UIFont.systemFontOfSize(11),
                NSForegroundColorAttributeName: UIColor.whiteColor()
            ]))
        
        button.setAttributedTitle(attributedText, forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let followers: UIButton = {
        let button = UIButton()
        button.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping // allow the text to have multiple lines if you want
        button.titleLabel?.textAlignment = NSTextAlignment.Center // make the text center.
        let attributedText = NSMutableAttributedString(string: "0", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(13), NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        
        attributedText.appendAttributedString(NSAttributedString(string: "\nfollowers",
            attributes: [NSFontAttributeName: UIFont.systemFontOfSize(11),
                NSForegroundColorAttributeName: UIColor.whiteColor()
            ]))
        
        button.setAttributedTitle(attributedText, forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let following: UIButton = {
        let button = UIButton()
        button.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping // allow the text to have multiple lines if you want
        button.titleLabel?.textAlignment = NSTextAlignment.Center // make the text center.
        let attributedText = NSMutableAttributedString(string: "0", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(13), NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        
        attributedText.appendAttributedString(NSAttributedString(string: "\nfollowing",
            attributes: [NSFontAttributeName: UIFont.systemFontOfSize(11),
                NSForegroundColorAttributeName: UIColor.whiteColor()
            ]))
        
        button.setAttributedTitle(attributedText, forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteColor() //UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let separatorLineView2: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteColor() //UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", forState: .Normal)
        button.setTitleColor(.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(15)
        button.backgroundColor = UIColor.init(red: 255/255, green: 114/255, blue: 120/255, alpha: 1) //UIColor.init(r: 255, g: 144, b: 118) //UIColor.init(red: 118/255, green: 199/255, blue: 183/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.setImage(UIImage(named: "cross-icon"), forState: .Normal)
        button.tintColor = UIColor.init(red: 118/255, green: 199/255, blue: 183/255, alpha: 1)
        button.addTarget(self, action: #selector(dismissUserProfile), forControlEvents: .TouchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var addPictureButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.setImage(UIImage(named: "add-icon"), forState: .Normal)
        button.tintColor = UIColor.init(red: 118/255, green: 199/255, blue: 183/255, alpha: 1)
        button.addTarget(self, action: #selector(addPicture), forControlEvents: .TouchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.hidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.hidden = true
        setupUIComponents()
        collectionView.collectionViewLayout = trippleFlowLayout
        
        
        let showSingleCellImage = UISwipeGestureRecognizer(target: self, action: #selector(changeCollectionViewLayout))
        showSingleCellImage.direction = .Left
        collectionView.addGestureRecognizer(showSingleCellImage)
        
        let showTripleCellImage = UISwipeGestureRecognizer(target: self, action: #selector(changeCollectionViewLayout))
        showTripleCellImage.direction = .Right
        collectionView.addGestureRecognizer(showTripleCellImage)
    }
    
    override func viewWillAppear(animated: Bool) {
        /* if the user isn't been initilaized yet, meaning it's nil then we should show the userLoggedIn profile.
         otherwise, if the user isn't nill, then we know it's been called through the method showUserProfileVC that take a user as an arguments and initiliaze it here to show
         another follower, or following profile. */
        if user == nil {
            dismissButton.hidden = true
            addPictureButton.hidden = false
            
            if let name = CURRENT_USER.currentUser?.name, email = CURRENT_USER.currentUser?.email {
                let attributedText = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18),  NSForegroundColorAttributeName: UIColor.whiteColor()])
                attributedText.appendAttributedString(NSAttributedString(string: "\n\(email)" ,
                    attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14),
                        NSForegroundColorAttributeName: UIColor.whiteColor()
                    ]))
                userName.attributedText = attributedText
            }
            
            if let profileImageURL = CURRENT_USER.currentUser?.profileImage {
                profileImageView.loadImageUsingCacheWithUrlString(profileImageURL)
            }
            // getting the uid for the current loggedin User.
            if let uid = FIRAuth.auth()?.currentUser?.uid {
                print("this user is", uid)
                if userImagesURL.count == 0 {
                    print("I am here", userImagesURL.count)
                    observeUserImage(uid) // this is not getting called when the user loggs back again
                }
            }
        }
    }
    
    
    func userIsLogingOut() {
        userImagesURL.removeAll()
        collectionView.reloadData()
        //user = nil
        //FIRDatabase.database().reference().removeAllObservers()
        print("am i getting called", userImagesURL.count)
    }
    
    func dismissUserProfile() {
        userImagesURL.removeAll()
        print("The view is being dismissed")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupUIComponents() {
        let bV = UIView(frame: view.bounds)
        bV.backgroundColor = .blackColor() // or .lightGrayColor()
        bV.alpha = 0.4
        
        view.addSubview(collectionView)
        collectionView.addSubview(profileImageBackgroundView)
        profileImageBackgroundView.addSubview(bV)
        collectionView.addSubview(dismissButton)
        collectionView.addSubview(addPictureButton)
        profileImageBackgroundView.addSubview(userName)
        profileImageBackgroundView.addSubview(profileImageView)
        profileImageBackgroundView.addSubview(posts)
        profileImageBackgroundView.addSubview(separatorLineView)
        profileImageBackgroundView.addSubview(followers)
        profileImageBackgroundView.addSubview(separatorLineView2)
        profileImageBackgroundView.addSubview(following)
        collectionView.addSubview(button)
        
        // x,y,h,w
        collectionView.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.bottomAnchor).active = true
        collectionView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        collectionView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        collectionView.bottomAnchor.constraintEqualToAnchor(self.bottomLayoutGuide.topAnchor).active = true
        
        
        // x,y,h,w
        profileImageBackgroundView.topAnchor.constraintEqualToAnchor(collectionView.topAnchor).active = true
        profileImageBackgroundView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        profileImageBackgroundView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        //profileImageView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        //        let height = (UIScreen.mainScreen().bounds.height/2)
        profileImageBackgroundView.heightAnchor.constraintEqualToConstant(300).active = true
        
        // x,y,h,w
        dismissButton.topAnchor.constraintEqualToAnchor(profileImageBackgroundView.topAnchor, constant: 12).active = true
        dismissButton.trailingAnchor.constraintEqualToAnchor(profileImageBackgroundView.trailingAnchor, constant: -12).active = true
        dismissButton.heightAnchor.constraintEqualToConstant(19).active = true
        dismissButton.widthAnchor.constraintEqualToConstant(19).active = true
        
        // x,y,h,w
        addPictureButton.topAnchor.constraintEqualToAnchor(profileImageBackgroundView.topAnchor, constant: 12).active = true
        addPictureButton.trailingAnchor.constraintEqualToAnchor(profileImageBackgroundView.trailingAnchor, constant: -12).active = true
        addPictureButton.heightAnchor.constraintEqualToConstant(19).active = true
        addPictureButton.widthAnchor.constraintEqualToConstant(19).active = true
        
        userName.centerYAnchor.constraintEqualToAnchor(profileImageBackgroundView.centerYAnchor).active = true
        userName.centerXAnchor.constraintEqualToAnchor(profileImageBackgroundView.centerXAnchor).active = true
        
        // x,y,h,w
        profileImageView.bottomAnchor.constraintEqualToAnchor(userName.topAnchor, constant: -8).active = true
        profileImageView.centerXAnchor.constraintEqualToAnchor(profileImageBackgroundView.centerXAnchor).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(100).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(100).active = true
        
        // x,y,h,w
        //posts.topAnchor.constraintEqualToAnchor(userName.bottomAnchor, constant: 8).active = true
        posts.bottomAnchor.constraintEqualToAnchor(button.topAnchor, constant: -8).active = true
        posts.leadingAnchor.constraintEqualToAnchor(button.leadingAnchor).active = true
        posts.trailingAnchor.constraintEqualToAnchor(following.leadingAnchor).active = true
        
        // x,y,h,w
        separatorLineView.bottomAnchor.constraintEqualToAnchor(posts.bottomAnchor).active = true
        separatorLineView.leadingAnchor.constraintEqualToAnchor(posts.trailingAnchor).active = true
        separatorLineView.heightAnchor.constraintEqualToAnchor(posts.heightAnchor).active = true
        separatorLineView.widthAnchor.constraintEqualToConstant(1).active = true
        
        // x,y,h,w
        //following.topAnchor.constraintEqualToAnchor(userName.topAnchor, constant: 8).active = true
        following.bottomAnchor.constraintEqualToAnchor(button.topAnchor, constant: -8).active = true
        following.leadingAnchor.constraintEqualToAnchor(posts.trailingAnchor).active = true
        following.trailingAnchor.constraintEqualToAnchor(followers.leadingAnchor).active = true
        following.widthAnchor.constraintEqualToAnchor(posts.widthAnchor, multiplier: 1).active = true
        
        // x,y,h,w
        separatorLineView2.bottomAnchor.constraintEqualToAnchor(posts.bottomAnchor).active = true
        separatorLineView2.leadingAnchor.constraintEqualToAnchor(following.trailingAnchor).active = true
        separatorLineView2.heightAnchor.constraintEqualToAnchor(posts.heightAnchor).active = true
        separatorLineView2.widthAnchor.constraintEqualToConstant(1).active = true
        
        // x,y,h,w
        //followers.topAnchor.constraintEqualToAnchor(userName.topAnchor, constant: 8).active = true
        followers.bottomAnchor.constraintEqualToAnchor(button.topAnchor, constant: -8).active = true
        followers.leadingAnchor.constraintEqualToAnchor(following.trailingAnchor).active = true
        followers.trailingAnchor.constraintEqualToAnchor(button.trailingAnchor).active = true
        // the multiplier means if you want the width to be equal then you put 1, double the width then 2 will do it. 1/2 the width of post ect..
        followers.widthAnchor.constraintEqualToAnchor(posts.widthAnchor, multiplier: 1).active = true
        
        // x,y,h,w
        //button.topAnchor.constraintEqualToAnchor(userInfoContainer.topAnchor, constant: 8).active = true
        button.leadingAnchor.constraintEqualToAnchor(profileImageBackgroundView.leadingAnchor).active = true
        button.trailingAnchor.constraintEqualToAnchor(profileImageBackgroundView.trailingAnchor).active = true
        //button.bottomAnchor.constraintEqualToAnchor(userName.topAnchor).active = true
        button.bottomAnchor.constraintEqualToAnchor(profileImageBackgroundView.bottomAnchor, constant: 0).active = true
        button.heightAnchor.constraintEqualToConstant(50).active = true
        
    }
    
    func changeCollectionViewLayout(recognizer: UISwipeGestureRecognizer) {
        
        if recognizer.direction == UISwipeGestureRecognizerDirection.Left {
            UIView.animateWithDuration(0.6) { () -> Void in
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.setCollectionViewLayout(self.singleFlowLayout, animated: true)
            }
        } else {
            UIView.animateWithDuration(0.2) { () -> Void in
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.setCollectionViewLayout(self.trippleFlowLayout, animated: true)
            }
        }
    }
    
    
    // the user is adding a picture to the collectionViewCells
    func addPicture() {
        let picker = UIImagePickerController()
            
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let editingImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            //profileImageView.image = editingImage
            uploadImageToFirebaseStorage(editingImage)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            //profileImageView.image = originalImage
            uploadImageToFirebaseStorage(originalImage)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    var timer = NSTimer()
    
    func observeUserImage(userId: String) {
        let ref = FIRDatabase.database().reference()
        
        ref.child("post-images").child(userId).observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            if let dict = snapshot.value, imageUrl = dict["imageUrl"] as? String {
                self.userImagesURL.insert(imageUrl, atIndex: 0)
                print("1")
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                print("timer timer")
                self.timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(self.reloadCollectionView), userInfo: nil, repeats: false)
                //self.collectionView.reloadData()
            })
            
        }, withCancelBlock: nil)
    }
    
    func reloadCollectionView() {
        self.collectionView.reloadData()
    }

    private func uploadImageToFirebaseStorage(image: UIImage) {
        let imageName = NSUUID().UUIDString
        let ref = FIRStorage.storage().reference().child("post_images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print("Failed to upload image:", error)
                    return
                }
                
                // the image is succefully stored in firbase storage
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    self.sendPostWithImageUrl(imageUrl)
                }
                
            })
        }
    }
    
    private func sendPostWithImageUrl(imageUrl: String) {
        // getting the uid for the current loggedin User.
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }

        let ref = FIRDatabase.database().reference().child("post-images").child(uid)
        let childRef = ref.childByAutoId()
        
        childRef.updateChildValues(["imageUrl": imageUrl])
    }
}

extension userProfile: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userImagesURL.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellId", forIndexPath: indexPath) as? imageCellProfile {
            cell.userImagesView.loadImageUsingCacheWithUrlString(userImagesURL[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    
    // this will give spaces arround the collectionViewCells, like 1 space from the left, 1 space from the left, and bottom. and giving it the height of the userInfoContainer from the top to make sit right underneath it.
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: profileImageBackgroundView.frame.height, left: 1, bottom: 1, right: 1)
    }
    
    // we don't want the collectionView to move at all when we change the layout of it. For that reason we need to set the contentOffset of it to (0,0) so when we change the layout it will show the collectionView from the point(0,0) of the collectionView
    // for example if we set the CGPoint equal to (0,100), it will show the collectionView from the position 0 but 100 points spaces down, meaning the collectionView will be hidden 100 sapces from the top.
    func collectionView(collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return CGPoint(x: 0, y: 0)
    }
}
