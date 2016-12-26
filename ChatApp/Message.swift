//
//  message.swift
//  ChatApp
//
//  Created by nawfal cherkaoui on 9/18/16.
//  Copyright © 2016 nawfal cherkaoui. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    
    var fromId: String?
    var text: String?
    var imageUrl: String?
    var timestamp: NSNumber?
    var toId: String?
    
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    
    // we should check for the 2 cases if the current user is the one sending the message or the one recieving the message.
    // case one: if the user is the one sending that message, we want to get the toId of the other user and store in chatPartnerId so we can display his info(name, profileImage)
    // case two: if the user is the one recieving that message, we want to get the fromId of the other user and store in chatPartnerId so we can display his info(name, profileImage)
    // because if I am sending the message, we will get his toId it's fine but if he sending the message we will get my to id and display my info whch is wrong
    func chatPartnerId() -> String? {
        return FIRAuth.auth()?.currentUser?.uid == fromId ? toId : fromId
    }
}
