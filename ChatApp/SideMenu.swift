//
//  SideMenu.swift
//  ChatApp
//
//  Created by nawfal cherkaoui on 12/1/16.
//  Copyright © 2016 nawfal cherkaoui. All rights reserved.
//

import UIKit
import Firebase

protocol SideMenuDelegate {
    func didSelectMenuItem (withTitle title:String, index:Int)
}

class SideMenu: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let user = User()
    
    lazy var menuTable:UITableView = {
        let tableView = UITableView(frame: self.bounds, style: .Plain)
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        tableView.scrollEnabled = false
        //tableView.alpha = 1
        
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    // using this parentViewController var to add this MenuSlide to it from here, and also add the gestureSwipeRecognizer
    var parentViewController = UIViewController()
    
    // this is a plain backround view that we'll be inserted underneath the sideMenu with the screen bounds. it's alpha is 0 so the gray color won't take effect untill the user slide to the right to open menuSlide. To give it the shade color.
    lazy var backgroundView: UIView = {
        let view = UIView(frame:  UIScreen.mainScreen().bounds)
        view.backgroundColor = .lightGrayColor()
        view.alpha = 0
        return view
    }()
    
    var animator:UIDynamicAnimator!
    
    var menuWidth:CGFloat = 0
    
    var menuItemTitles = [String]()
    
    // whatever viewController that's implementing this UIView, must confirm to the protocol SideMenuDelegate to set this menuDelegate variable. Once this gets set, it will give us the ability to notify them which title the user presses, from didSelectRowAtIndexPath whenever the user presses on a cell, by calling the function that they confirmed to from the protocol which is didSelectMenuItem (withTitle title:String, index:Int).
    var menuDelegate:SideMenuDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    init(menuWidth:CGFloat, menuItemTitles:[String], parentViewController: UIViewController) {
        // setting up the frame of the view. x is negative value because we want to start from the close state.
        super.init(frame: CGRect(x: -menuWidth, y: 0, width: menuWidth, height: parentViewController.view.frame.height))
        
        self.menuWidth = menuWidth
        self.menuItemTitles = menuItemTitles
        self.parentViewController = parentViewController
        
        // setting it's background color to darkGray
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7) // try 0.8 instead of 0.7 if you want it a little bit darker. the desicion to be made later ...
        // adding this view to the parentViewController.
        parentViewController.view.addSubview(self)
        
        // adding the tableView to this View, and a view(backgroundView) to the parentView.
        setupMenuView()
        
        animator = UIDynamicAnimator(referenceView: parentViewController.view)
        
        let showMenuRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleGestures))
        
        showMenuRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        parentViewController.view.addGestureRecognizer(showMenuRecognizer)
        
        let hideMenuRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleGestures))
        
        hideMenuRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        parentViewController.view.addGestureRecognizer(hideMenuRecognizer)
        
    }
    
    func setupMenuView() {
        // adding the tableView to this view
        self.addSubview(menuTable)
        parentViewController.view.insertSubview(backgroundView, belowSubview: self)
    }
    
    func handleGestures(recognizer:UISwipeGestureRecognizer) {
        if recognizer.direction == UISwipeGestureRecognizerDirection.Right {
            toggleMenu(true) // open
        }else{
            toggleMenu(false) // close
        }
    }
    
    // this will get called anytime the user try to open or close the sideMenu
    func toggleMenu (open: Bool) {
        animator.removeAllBehaviors()
        
        // positive value will make the gravity of the object go to the right, negative value will make it move to the left
        let gravityX:CGFloat = open ? 2 : -1
        let pushMagnitude:CGFloat = open ? 2 : -20
        let boundaryX:CGFloat = open ? menuWidth : -menuWidth - 5 // boundary is either 150 or -155
        
        let gravity = UIGravityBehavior(items: [self])
        gravity.gravityDirection = CGVector(dx: gravityX, dy: 0)
        animator.addBehavior(gravity)
        
        let collision = UICollisionBehavior(items: [self])
        collision.addBoundaryWithIdentifier(1 as NSCopying, fromPoint:  CGPoint(x: boundaryX, y:20), toPoint: CGPoint(x: boundaryX, y: parentViewController.view.bounds.height))
        animator.addBehavior(collision)
        
        let push = UIPushBehavior(items: [self], mode: .Instantaneous)
        push.magnitude = pushMagnitude
        animator.addBehavior(push)
        
        
        let menuBehaviour = UIDynamicItemBehavior(items: [self])
        menuBehaviour.elasticity = 0.4
        animator.addBehavior(menuBehaviour)
        
        // when you open the sideMenu, the backround view will be lightGray with an alpha of 0.5. When you close it, it's alpha will be 0 (plain white color)
        UIView.animateWithDuration(0.3) {
            self.backgroundView.alpha = open ? 0.5 : 0
            
            // show or hide the statusBar according to the state of the MenuSide. (true -> show, false -> hide)
            //isStatusBarHidden = open ? true : false
            self.parentViewController.setNeedsStatusBarAppearanceUpdate() // after setting the var isStatusBarHidden, we need the statusBar to take effect so we must call this
        }
        
        // if the user open the sideMenu, give the navigationBar zPosition of value -1 to make appear underneath the sideMenu, otherwise give normal value 1
        self.parentViewController.navigationController?.navigationBar.layer.zPosition = -1 //open ? -1 : 1
        
    }
    
    
    
    // this the components of the tableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItemTitles.count
    }
    
    // this header is giving us that white space from the top.
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 25/255, green: 165/255, blue: 153/255, alpha: 1)
        
        let appTitle = UILabel()
        appTitle.translatesAutoresizingMaskIntoConstraints = false
        appTitle.text = "N"
        appTitle.font = UIFont.boldSystemFontOfSize(100)
        appTitle.textColor = .whiteColor()
        
        view.addSubview(appTitle)
        
        appTitle.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        appTitle.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        
        // when we return the view, the view automatically adjust to the frame of the header, so we don't need to set the frame of it
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = menuItemTitles[indexPath.row]
        cell.textLabel?.textColor = UIColor.whiteColor()
        //cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        cell.textLabel?.font = UIFont.boldSystemFontOfSize(14)
        cell.textLabel?.textAlignment = .Center
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // this will make the cell fade out when we press on it.
        tableView.cellForRowAtIndexPath(indexPath)?.setSelected(false, animated: true)
        // this will make the textLabel of the cell fade out the the color give in.
        tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.highlightedTextColor = UIColor.lightGrayColor()
        // this will make that fade out in the specified color we set it into.
        tableView.cellForRowAtIndexPath(indexPath)?.contentView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        
        //tableView.cellForRowAtIndexPath(indexPath)?.selectionStyle = UITableViewCellSelectionStyle.None
        
        
        // Everytime the user presses a cell we want to let parentViewcontroller know so we can change the viewController's content according to what the user presses. And also dismiss the SideMenu.
        if let delegate = menuDelegate {
            delegate.didSelectMenuItem(withTitle: menuItemTitles[indexPath.row], index: indexPath.row)
            toggleMenu(false)
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
//    func getCurrentUserInfo() {
//        let ref = FIRDatabase.database().reference()
//        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
//            if let user = user {
//                // User is signed in.
//                let uid = user.uid // getting the user's id
//                
//                // from he/she uid we could look he/she up in the dataBase and get her/his email and name. since we have a child users that has bunch of childs of uids that have their names and emails.
//                ref.child("users").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in // observeSignleEvent will only get you certspecificain data but not all
//                    
//                    if let dict = snapshot.value as? [String: AnyObject] {
//                        self.user.id = snapshot.key
//                        self.user.setValuesForKeysWithDictionary(dict)
//                    }
//                    
//                    }, withCancelBlock: nil)
//            }
//            
//        }
//    }
}

