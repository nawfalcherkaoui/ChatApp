//
//  FriendsCellScrollView.swift
//  ChatApp
//
//  Created by nawfal cherkaoui on 11/27/16.
//  Copyright © 2016 nawfal cherkaoui. All rights reserved.
//

import UIKit

class FriendsCellScrollView: UIView {
    
    lazy var friendImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGrayColor()
        imageView.layer.cornerRadius = 22.2
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.userInteractionEnabled = true
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(9)
        label.textColor = .blackColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // this is like viewDidload it gets called whenever the pageview is getting created
    override func awakeFromNib() {
        self.addSubview(friendImageView)
        self.addSubview(nameLabel)
        setConstraintForImageView()
        setConstraintForTextLabel()
        //self.backgroundColor = .grayColor()
    }
    
    // we call this class method from other view coontrollers to creat this view
    class func loadFromNib() -> FriendsCellScrollView {
        let bundle = NSBundle(forClass: self)
        let nib = UINib(nibName: "FriendsCellScrollView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! FriendsCellScrollView
        return view
    }
    
    func setConstraintForImageView() {
    
        NSLayoutConstraint.activateConstraints([
            friendImageView.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 8),
            friendImageView.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor),
            //friendImageView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor),
            //friendImageView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor),
            friendImageView.heightAnchor.constraintEqualToConstant(45),
            friendImageView.widthAnchor.constraintEqualToConstant(45)
            ])
    }
    
    func setConstraintForTextLabel() {

//        let topAnchorConstraint = textLabel.topAnchor.constraintGreaterThanOrEqualToAnchor(self.layoutMarginsGuide.topAnchor, constant: 60)
//        let bottomAnchorConstraint = textLabel.bottomAnchor.constraintLessThanOrEqualToAnchor(imageView.topAnchor, constant: -20)
//        topAnchorConstraint.priority = 1000
//        bottomAnchorConstraint.priority = 500
//        NSLayoutConstraint.activateConstraints([
//            topAnchorConstraint,
//            bottomAnchorConstraint,
//            textLabel.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor)
//            ])
        
        nameLabel.topAnchor.constraintEqualToAnchor(friendImageView.bottomAnchor, constant: 0).active = true
        nameLabel.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -5).active = true
        nameLabel.centerXAnchor.constraintEqualToAnchor(friendImageView.centerXAnchor).active = true
    }
    
    
    // we passing info from the view controller to set the image and text label
    func setUserInfo(data: User) {
        if let imageURl = data.profileImage {
            friendImageView.loadImageUsingCacheWithUrlString(imageURl)
        }
        if let userName = data.name {
            nameLabel.text = userName
        }
        
        
    }
    
}
