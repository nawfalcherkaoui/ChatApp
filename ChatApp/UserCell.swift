//
//  UserCell.swift
//  ChatApp
//
//  Created by nawfal cherkaoui on 9/16/16.
//  Copyright © 2016 nawfal cherkaoui. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    var message: Message? {
        didSet {
           setupNameAndProfileImageForCell()
        }
    }
    
    func setupNameAndProfileImageForCell() {
        
        // getting chatPartner name and ProfileImageURL
        if let id = message?.chatPartnerId() {
            let ref = FIRDatabase.database().reference().child("users").child(id)
            ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if let userInfoDict = snapshot.value as? [String: AnyObject] {
                    self.textLabel?.text = userInfoDict["name"] as? String
                    // if a text exist, show it otherwise it was a picture sent and label it.
                    if let messageText = self.message?.text {
                        self.detailTextLabel?.text = messageText
                    } else if self.message?.imageUrl != nil {
                        self.detailTextLabel?.text = "Attachment: 1 Image"
                    }
                    
                    if let profileImageURL = userInfoDict["profileImage"] as? String {
                        self.profileImageView.loadImageUsingCacheWithUrlString(profileImageURL)
                        
                    }
                    
                    if let seconds = self.message?.timestamp?.doubleValue {
                        let time = NSDate(timeIntervalSince1970: seconds)
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.locale = NSLocale.currentLocale()
                        dateFormatter.dateFormat = "dd/MM/yy HH:mm a" //"HH:MM a"
                        self.timeLabel.text = dateFormatter.stringFromDate(time)
                    }
                }
            }, withCancelBlock: nil)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRectMake(64, textLabel!.frame.origin.y - 2, textLabel!.frame.width, textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRectMake(64, detailTextLabel!.frame.origin.y + 2, detailTextLabel!.frame.width, detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
        //imageView.image = UIImage(named: "zuckdog")
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "HH:MM:SS A"
        label.font = UIFont.systemFontOfSize(10)
        label.textColor = UIColor.darkGrayColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors for ProfilePicture
        profileImageView.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 8).active = true
        profileImageView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(50).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(50).active = true
        
        //need x,y,width,height anchors for TimeLable
        timeLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor).active = true
        timeLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 15).active = true
        timeLabel.widthAnchor.constraintEqualToConstant(100).active = true
        timeLabel.heightAnchor.constraintEqualToAnchor(textLabel?.heightAnchor).active = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
