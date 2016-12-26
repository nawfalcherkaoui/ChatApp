//
//  ChatMessageCellCollectionViewCell.swift
//  ChatApp
//
//  Created by nawfal cherkaoui on 10/25/16.
//  Copyright © 2016 nawfal cherkaoui. All rights reserved.
//

import UIKit


class ChatMessageCell: UICollectionViewCell {
    
    var message: Message? {
        didSet {
//            if let text = message?.text {
//                textMessage.text = text
//            }
            
        }
    }
    
    var bubbleWidthConstraint: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    
    static let greenBubbleColor: UIColor = UIColor.init(red: 25/255, green: 165/255, blue: 153/255, alpha: 1) //UIColor(r: 0, g: 137, b: 249)
    
    let textMessage: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFontOfSize(16)
        tv.textColor = .whiteColor()
        tv.backgroundColor = .clearColor()
        tv.userInteractionEnabled = false
        /* to think about
        tv.backgroundColor = UIColor.init(r: 0, g: 137, b: 249)
        tv.layer.cornerRadius = 10
        tv.layer.masksToBounds = true
        ***************************   */
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()
    
    let bubbleChat: UIView = {
        let view = UIView()
        view.backgroundColor = greenBubbleColor
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIForCell()
        backgroundColor = .whiteColor()
    }
    
    func setupUIForCell() {
        addSubview(bubbleChat)
        addSubview(textMessage)
        addSubview(messageImageView)
        
        // setting x,y,w,h constraints for bubbleChat
        /*
         the leading, trailing & the width will be dynamically changed depending on the size of the text, & who's sending (the sender or reciever).
         we're giving them a default values here such as the width is 200 and the all the bubbles are in blue but we will be changing them
         from the chatLogController at cellForItemAtIndexPath when we get each message and figure out who's the reciever and sender as well the
         estimation width of the text.
         */
        bubbleChat.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 1).active = true
        bubbleChat.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -1).active = true
        bubbleLeftAnchor = bubbleChat.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 8)
        bubbleLeftAnchor?.active = false
        bubbleRightAnchor = bubbleChat.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: -8)
        bubbleRightAnchor?.active = true
        bubbleWidthConstraint = bubbleChat.widthAnchor.constraintEqualToConstant(200)
        bubbleWidthConstraint?.active = true
        
        
        // setting x,y,w,h contraints for the textMessage
        textMessage.topAnchor.constraintEqualToAnchor(bubbleChat.topAnchor).active = true
        textMessage.leadingAnchor.constraintEqualToAnchor(bubbleChat.leadingAnchor, constant: 8).active = true
        textMessage.trailingAnchor.constraintEqualToAnchor(bubbleChat.trailingAnchor).active = true
        textMessage.bottomAnchor.constraintEqualToAnchor(bubbleChat.bottomAnchor).active = true
        
        // setting x,y,w,h contraints for the messageImageView
        messageImageView.topAnchor.constraintEqualToAnchor(bubbleChat.topAnchor).active = true
        messageImageView.leadingAnchor.constraintEqualToAnchor(bubbleChat.leadingAnchor).active = true
        messageImageView.trailingAnchor.constraintEqualToAnchor(bubbleChat.trailingAnchor).active = true
        messageImageView.bottomAnchor.constraintEqualToAnchor(bubbleChat.bottomAnchor).active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
