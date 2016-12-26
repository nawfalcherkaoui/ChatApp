//
//  CollectionViewChatLogController.swift
//  ChatApp
//
//  Created by nawfal cherkaoui on 10/29/16.
//  Copyright © 2016 nawfal cherkaoui. All rights reserved.
//

import UIKit
import Firebase

extension ChatLogController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    /*
     we're getting each message from the messages array
     getting the text and computing the estimated width of the text and adding 30 for padding
     if the message is being send from the current user then the bubble should be blue and placed to the right
     otherWise, the message is from the reciever then we're having placed to the left and gray with white text.
     
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellId", forIndexPath: indexPath) as? ChatMessageCell {
            let message = messages[indexPath.row]
            cell.message = message
            
            if message.fromId == FIRAuth.auth()?.currentUser?.uid {
                cell.bubbleChat.backgroundColor = ChatMessageCell.greenBubbleColor
                cell.textMessage.textColor = .whiteColor()
                
                cell.bubbleRightAnchor?.active = true
                cell.bubbleLeftAnchor?.active = false
            } else {
                cell.bubbleChat.backgroundColor = UIColor(r: 240, g: 240, b: 240)
                cell.textMessage.textColor = .blackColor()
                
                cell.bubbleRightAnchor?.active = false
                cell.bubbleLeftAnchor?.active = true
            }
            
            if let textMessage = message.text {
                cell.textMessage.text = textMessage
                cell.bubbleWidthConstraint?.constant = estimateFrameForText(textMessage).width + 30
                cell.textMessage.hidden = false
                cell.messageImageView.hidden = true
            } else if let imageMessage = message.imageUrl {
                cell.messageImageView.loadImageUsingCacheWithUrlString(imageMessage)
                cell.messageImageView.hidden = false
                cell.textMessage.hidden = true
                cell.bubbleChat.backgroundColor = .clearColor()
                cell.bubbleWidthConstraint?.constant = 200
            }
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    // setting up the height and width for a cell -> we're giving it a default width of the screen but the height changes through the content of the text message using the estimateFrameForText function.
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        var height: CGFloat = 80
        let width = UIScreen.mainScreen().bounds.width
        // estimated height for the text to show in the cell
        let message = messages[indexPath.row]
        if let textMessage = message.text {
            height = estimateFrameForText(textMessage).height + 20
        } else if let imageHeight = message.imageHeight?.floatValue, imageWidth = message.imageWidth?.floatValue {
            height = CGFloat((imageHeight/imageWidth) * 200)
        }
        
        return CGSizeMake(width, height)
    }
    
    
    // it will return an estimation of the height and the width of a text passed in as a CGRect. this is repeated twice, here and profileVC
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 10000)
        let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
        return NSString(string: text).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16)], context: nil)
    }
    
    // this is not needed since we can dissmiss the keyboard by dragging it down
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        inputTextView.endEditing(true)
//    }
    
    // this will allow the layout to redraw itself when we're switching to portrait or landscape mode.
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // this will give spaces arround the CollectionView, like 8 spaces from the top,bottom, and 0 from left, and right.
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // this will only dissmiss the keyBoard if you drag it down and won't do anything if you drag the scrollView down
        // .onDrag will make it follow the keyboard smoothly when it's hidden
        //        scrollView.keyboardDismissMode = .Interactive
        //        scrollView.keyboardDismissMode = .OnDrag
        
        /***************************************
         + scrollView.contentSize.height is the height of the whole scrollView of the collectionView
         + scrollView.frame.height is the height of where the scrollView is appearing and scrolling. in this case from the navigation bar to the containerInputView that's the frame.
         use these for demonstration
         print(scrollView.contentSize.height)
         print(scrollView.frame.height)
         ******************************************/
        // these 2 if statements indicate when the user scrolls up or down
        
        // the conditions after && operators make sure when the user scroll all the way to the top it automaticaly comes up it calls down.
        if (self.lastContentOffset > scrollView.contentOffset.y && self.lastContentOffset < (scrollView.contentSize.height - scrollView.frame.height)) {
            // move up -> this when the user scrolls up
            //let follow = (inputAccessoryView?.frame.height)! + 50
            //bottomCollectionViewConstraint?.constant = follow
            
        } else if (self.lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y > 0) {
            // move down -> when the user scrolls down
            
        }
        
        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
}