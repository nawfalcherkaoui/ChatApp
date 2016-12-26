//
//  UserProfileVC.swift
//  ChatApp
//
//  Created by nawfal cherkaoui on 11/2/16.
//  Copyright © 2016 nawfal cherkaoui. All rights reserved.
//

import UIKit

class UserProfileVC: UIViewController {
    
    var user: User? {
        didSet {
            userName.text = user?.name
            if let profileImageURL = user?.profileImage {
                profileImageView.loadImageUsingCacheWithUrlString(profileImageURL)
            }
            descreptiveText.text = "I am coming from showProfileVC. I am coming from showProfileVC. I am coming from showProfileVC. I am coming from showProfileVC."
        }
    }
    
    var descreptiveTextHeightConstraint: NSLayoutConstraint?
    
    let userInfoContainer: UIView = {
       let view = UIView()
        view.backgroundColor = .whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "zuckdog"))
        imageView.layer.cornerRadius = 70/2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let userName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descreptiveText: UITextView = {
        let description = UITextView()
        description.font = UIFont.systemFontOfSize(13)
        //description.text = "This where a decriptive text goes! This where a decriptive text goes! This where a decriptive text goes! This where a decriptive text goes! This where a decriptive text goes!"
        description.textColor = .blackColor()
        description.userInteractionEnabled = false
        //description.backgroundColor = .grayColor()
        /* to think about
         tv.backgroundColor = UIColor.init(r: 0, g: 137, b: 249)
         tv.layer.cornerRadius = 10
         tv.layer.masksToBounds = true
         ***************************   */
        description.translatesAutoresizingMaskIntoConstraints = false
        return description
    }()
    
    /* maybe we can make a function and call it on all of these buttons since they're all the same but the text   */
    
    let posts: UIButton = {
        let button = UIButton()
        button.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping // allow the text to have multiple lines if you want
        button.titleLabel?.textAlignment = NSTextAlignment.Center // make the text center.
        let attributedText = NSMutableAttributedString(string: "0", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(13), NSForegroundColorAttributeName: UIColor.blackColor()])
        
        attributedText.appendAttributedString(NSAttributedString(string: "\nposts",
            attributes: [NSFontAttributeName: UIFont.systemFontOfSize(11),
                NSForegroundColorAttributeName: UIColor.darkGrayColor()
            ]))
        
        button.setAttributedTitle(attributedText, forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let followers: UIButton = {
        let button = UIButton()
        button.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping // allow the text to have multiple lines if you want
        button.titleLabel?.textAlignment = NSTextAlignment.Center // make the text center.
        let attributedText = NSMutableAttributedString(string: "0", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(13), NSForegroundColorAttributeName: UIColor.blackColor()])
        
        attributedText.appendAttributedString(NSAttributedString(string: "\nfollowers",
            attributes: [NSFontAttributeName: UIFont.systemFontOfSize(11),
                NSForegroundColorAttributeName: UIColor.darkGrayColor()
            ]))
        
        button.setAttributedTitle(attributedText, forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let following: UIButton = {
        let button = UIButton()
        button.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping // allow the text to have multiple lines if you want
        button.titleLabel?.textAlignment = NSTextAlignment.Center // make the text center.
        let attributedText = NSMutableAttributedString(string: "0", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(13), NSForegroundColorAttributeName: UIColor.blackColor()])
        
        attributedText.appendAttributedString(NSAttributedString(string: "\nfollowing",
            attributes: [NSFontAttributeName: UIFont.systemFontOfSize(11),
                NSForegroundColorAttributeName: UIColor.darkGrayColor()
            ]))
        
        button.setAttributedTitle(attributedText, forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    /*    */
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(15)
        button.setTitleColor(.whiteColor(), forState: .Normal)
        button.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let separatorTopLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        
        var flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.registerClass(imageCellProfile.self, forCellWithReuseIdentifier: "cellId") // regestering the cell for collection view
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.alwaysBounceVertical = true
        //collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -8, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false // We do this to not give it any permissions to mess with the constraints and follow our constraints.
        self.automaticallyAdjustsScrollViewInsets = false // this will prevent the spacing that automatically comes on top of the first cell when you set collectionView programatically.
        
        // setting the laout of the cell here
        let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width // getting the width of the screen
        // this is not needed because we already have the flowLayout initiliazed
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        /* we put minus 3 here because we have 1 space from the left and 1 from the right of the collectionView and 0.5 spacing between cells.
        we know we want 3 cells in a row so we'll have 1-image-0.5-image-0.5-image-1, so (screen width - all the spaces 3) / 3 will give us the
        width of each cell  */
        layout.itemSize = CGSize(width: (screenWidth-3)/3.0, height: (screenWidth-3)/3.0) // giving the cell and a size
        // these 2 control the spacing between the cells.
        layout.minimumInteritemSpacing = 0.5 // setting the space between the cells horizantally (x-axis)
        layout.minimumLineSpacing = 0.5 // setting the space between the cells veritcally (y-axis)
        collectionView.collectionViewLayout = layout
        
        return collectionView
    }()
    
    /* if this viewController gets called through the customTabBar, it will only be called once in the lifeTime of the app. untill the user gets exited
        so the bug is, when the user loggOut and try to log back in with a different account this will never get called and the profile it'll have the previous user info we we need to put in viewWill appear. */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "MyApp"
        collectionView.delegate = self
        collectionView.dataSource = self
        setupUIComponents()
        
    }
    /*
     this is where we're handling our logic of if we should show the userLoggedIn's profile or his friends profile
     calling this Controller from the customTabBar is totally different than calling it from showProfileVC
     calling from customTabBar, user variable will always be nil, but  from showProfileVC every time we call it we pass in a user.
     */
    override func viewWillAppear(animated: Bool) {
        /* if the user isn't been initilaized yet, meaning it's nil then we should show the userLoggedIn profile.
         otherwise, if the user isn't nill, then we know it's been called through the method showUserProfileVC that take a user as an arguments and initiliaze it here to show
          another follower, or following profile. */
        if user == nil {
            if let name = CURRENT_USER.currentUser?.name {
                userName.text = name
            }
            
            if let profileImageURL = CURRENT_USER.currentUser?.profileImage {
                profileImageView.loadImageUsingCacheWithUrlString(profileImageURL)
            }
            
            descreptiveText.text = "I am coming from The TabBarController. this is a long test to see if it's gonna fit, I am coming from The TabBarController. this is a long test to see if it's gonna fit, I am coming from The TabBarController. this is a long test to see if it's gonna fit, I am coming from The TabBarController. this is a long test to see if it's gonna fit"
        }
        
        setUserInfoContainerHeight()
        
    }
    
    func setUserInfoContainerHeight() {
        /* the height of the text is whatever we're getting back from the function estimateFrameForText(descreptiveText.text), but we need to add all the spaces and the heights for the profileImage and the userName text. because remember we're setting the height of the userInfoContainerConstraint that holds the image, name, text, button ... and not the descriptiveText constraint. V:8-70-8-8-then lay the text blow */
        let textHeight = estimateFrameForText(descreptiveText.text).height
        descreptiveTextHeightConstraint?.constant = textHeight + 20
    }
    
    
    private func estimateFrameForText(text: String) -> CGRect {
        let screenWidth = UIScreen.mainScreen().bounds.width
        // when we want the estimate height and width of a text String, we want the CGRect estimation on a form that if we had to display on view that has a certain width and certain height. we have to specify the view's width and height that we're planing to put the text in. for example the width of the descriptive textView is only from some spaces from the begining to -25 from the end of the screen. we need to provide that below to indicate that our text can only be in that form of width. Meaning it can only start from that point and ends -25 from the end. And same thing for the height, Since users can write as much as they can in their bio, we give a large number to indicate that te text can be 10000 of a height. But most importantly is the width here to get the right estimations. 
        // that's the view we're planing to put our text in -> the text can only be this (screenWidth - 33) width (meaning jump the line after you reach that limit of width) and for the height 10000.
        let size = CGSize(width: screenWidth - 33, height: 10000)
        let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
        return NSString(string: text).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(13)], context: nil)
    }
    
    
    func setupUIComponents() {
        
        //view.addSubview(userInfoContainer)
        view.addSubview(collectionView)
        collectionView.addSubview(userInfoContainer)
        
        userInfoContainer.addSubview(separatorTopLineView)
        userInfoContainer.addSubview(profileImageView)
        userInfoContainer.addSubview(userName)
        userInfoContainer.addSubview(descreptiveText)
        userInfoContainer.addSubview(button)
        userInfoContainer.addSubview(separatorLineView)
        userInfoContainer.addSubview(posts)
        userInfoContainer.addSubview(followers)
        userInfoContainer.addSubview(following)
        
        // x,y,h,w
        collectionView.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.bottomAnchor).active = true
        collectionView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        collectionView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        collectionView.bottomAnchor.constraintEqualToAnchor(self.bottomLayoutGuide.topAnchor).active = true
        
        // x,y,h,w
        userInfoContainer.topAnchor.constraintEqualToAnchor(collectionView.topAnchor).active = true
        userInfoContainer.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true // i've tried to set it equal to collectionView.leadingAnchor and it didn't but view.leadingAnchor seemed to work perfectly!
        userInfoContainer.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true // -> same thing here.
        userInfoContainer.bottomAnchor.constraintEqualToAnchor(descreptiveText.bottomAnchor).active = true
        
        // x,y,h,w
        separatorTopLineView.topAnchor.constraintEqualToAnchor(userInfoContainer.topAnchor).active = true
        separatorTopLineView.leadingAnchor.constraintEqualToAnchor(userInfoContainer.leadingAnchor).active = true
        separatorTopLineView.trailingAnchor.constraintEqualToAnchor(userInfoContainer.trailingAnchor).active = true
        separatorTopLineView.heightAnchor.constraintEqualToConstant(1).active = true

        // x,y,h,w
        profileImageView.topAnchor.constraintEqualToAnchor(userInfoContainer.topAnchor, constant: 8).active = true
        profileImageView.leadingAnchor.constraintEqualToAnchor(userInfoContainer.leadingAnchor, constant: 8).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(70).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(70).active = true
        
        
        // x,y,h,w
        userName.topAnchor.constraintEqualToAnchor(profileImageView.bottomAnchor, constant: 8).active = true
        userName.leadingAnchor.constraintEqualToAnchor(profileImageView.leadingAnchor).active = true
        //userName.bottomAnchor.constraintEqualToAnchor(descreptiveText.topAnchor).active = true
        
        // x,y,h,w
        descreptiveText.topAnchor.constraintEqualToAnchor(userName.bottomAnchor, constant: -2).active = true
        descreptiveText.leadingAnchor.constraintEqualToAnchor(collectionView.leadingAnchor, constant: 3).active = true
        descreptiveText.trailingAnchor.constraintEqualToAnchor(userInfoContainer.trailingAnchor, constant: -25).active = true
        //descreptiveText.bottomAnchor.constraintEqualToAnchor(userInfoContainer.bottomAnchor).active = true
        descreptiveTextHeightConstraint = descreptiveText.heightAnchor.constraintEqualToConstant(80)
        descreptiveTextHeightConstraint?.active = true
        
        // x,y,h,w
        separatorLineView.bottomAnchor.constraintEqualToAnchor(userInfoContainer.bottomAnchor).active = true
        separatorLineView.leadingAnchor.constraintEqualToAnchor(userInfoContainer.leadingAnchor).active = true
        separatorLineView.trailingAnchor.constraintEqualToAnchor(userInfoContainer.trailingAnchor).active = true
        separatorLineView.heightAnchor.constraintEqualToConstant(1).active = true
        
        // x,y,h,w
        posts.topAnchor.constraintEqualToAnchor(userInfoContainer.topAnchor, constant: 8).active = true
        posts.bottomAnchor.constraintEqualToAnchor(button.topAnchor, constant: -2).active = true
        posts.leadingAnchor.constraintEqualToAnchor(button.leadingAnchor).active = true
        posts.trailingAnchor.constraintEqualToAnchor(following.leadingAnchor).active = true
        
        // x,y,h,w
        following.topAnchor.constraintEqualToAnchor(userInfoContainer.topAnchor, constant: 8).active = true
        following.bottomAnchor.constraintEqualToAnchor(button.topAnchor, constant: -2).active = true
        following.leadingAnchor.constraintEqualToAnchor(posts.trailingAnchor).active = true
        following.trailingAnchor.constraintEqualToAnchor(followers.leadingAnchor).active = true
        following.widthAnchor.constraintEqualToAnchor(posts.widthAnchor, multiplier: 1).active = true
        
        // x,y,h,w
        followers.topAnchor.constraintEqualToAnchor(userInfoContainer.topAnchor, constant: 8).active = true
        followers.bottomAnchor.constraintEqualToAnchor(button.topAnchor, constant: -2).active = true
        followers.leadingAnchor.constraintEqualToAnchor(following.trailingAnchor).active = true
        followers.trailingAnchor.constraintEqualToAnchor(button.trailingAnchor).active = true
        // the multiplier means if you want the width to be equal then you put 1, double the width then 2 will do it. 1/2 the width of post ect..
        followers.widthAnchor.constraintEqualToAnchor(posts.widthAnchor, multiplier: 1).active = true
        
        // x,y,h,w
        //button.topAnchor.constraintEqualToAnchor(userInfoContainer.topAnchor, constant: 8).active = true
        button.leadingAnchor.constraintEqualToAnchor(profileImageView.trailingAnchor, constant: 16).active = true
        button.trailingAnchor.constraintEqualToAnchor(userInfoContainer.trailingAnchor, constant: -8).active = true
        //button.bottomAnchor.constraintEqualToAnchor(userName.topAnchor).active = true
        button.bottomAnchor.constraintEqualToAnchor(userName.topAnchor, constant: -8).active = true
        
//        // x,y,h,w
//        collectionView.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.bottomAnchor).active = true
//        collectionView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
//        collectionView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
//        collectionView.bottomAnchor.constraintEqualToAnchor(self.bottomLayoutGuide.topAnchor).active = true
        
        //collectionView.addSubview(userInfoContainer)

    }
}
