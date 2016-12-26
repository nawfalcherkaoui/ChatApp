//
//  AddingFriendsVC.swift
//  ChatApp
//
//  Created by nawfal cherkaoui on 10/5/16.
//  Copyright © 2016 nawfal cherkaoui. All rights reserved.
//

import UIKit

class AddingFriendsVC: UIViewController {
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "zuckdog")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let followers: UILabel = {
        let label = UILabel()
        label.text = "Followers"
        return label
    }()
    
    let following: UILabel = {
        let label = UILabel()
        label.text = "Following"
        return label
    }()
    
    let followButton: UIButton = {
        let button = UIButton(type: .System)
        button.setTitle("Follow", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
