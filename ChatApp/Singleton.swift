//
//  Singleton.swift
//  ChatApp
//
//  Created by nawfal cherkaoui on 11/6/16.
//  Copyright © 2016 nawfal cherkaoui. All rights reserved.
//

import UIKit

let CURRENT_USER = Singleton.sharedInstance

class Singleton {
    
    static let sharedInstance = Singleton()
    var currentUser: User?
    
    private init() {}
}
