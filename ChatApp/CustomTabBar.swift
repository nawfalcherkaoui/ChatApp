//
//  CustomTabBar.swift
//  ChatApp
//
//  Created by nawfal cherkaoui on 11/4/16.
//  Copyright © 2016 nawfal cherkaoui. All rights reserved.
//

import UIKit

class customTabBarController: UITabBarController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .whiteColor()
        
        let messagesController = MessagesController()
        let navigationController = UINavigationController(rootViewController: messagesController)
        navigationController.tabBarItem.title = "Messages"
        navigationController.tabBarItem.image = UIImage(named: "messenger_icon")
        
        let userProfileVC = userProfile()
        let secondNavigationController = UINavigationController(rootViewController: userProfileVC)
        secondNavigationController.tabBarItem.title = "Profile"
        secondNavigationController.tabBarItem.image = UIImage(named: "news_feed_icon")
        
        viewControllers = [navigationController, secondNavigationController]
    }
}