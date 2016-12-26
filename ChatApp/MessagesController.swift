//
//  ViewController.swift
//  ChatApp
//
//  Created by nawfal cherkaoui on 9/9/16.
//  Copyright © 2016 nawfal cherkaoui. All rights reserved.
//

import UIKit
import Firebase


class MessagesController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    let ref = FIRDatabase.database().reference()
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    var friends = [User]()
    
    var userNeverFiredMessagesObserver: Bool = true
    
//    var sideMenu: SideMenu?
//    let menuItemTitles = ["Profile", "Photos Shared", "CONTACT US", "Logout"]
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        // regestering the cell for collection view
        tableView.registerClass(UserCell.self, forCellReuseIdentifier: "CellId")
        tableView.backgroundColor = UIColor.whiteColor()
        //tableView.separatorStyle = .None
        tableView.alwaysBounceVertical = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 0, right: 0) // 80 spaces from the top to show the scrollView
        tableView.translatesAutoresizingMaskIntoConstraints = false // We do this to not give it any permissions to mess with the constraints and follow our constraints.
        self.automaticallyAdjustsScrollViewInsets = false
        return tableView
    }()
    
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.backgroundColor = .whiteColor()
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false
        scrollView.indicatorStyle = .White
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var searchBarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30) // the x and y will adjust according to the leftbarItemButton
        //view.backgroundColor = .redColor()
       
        let image = UIImageView(image: UIImage(named: "Search Icon"))
        image.frame = CGRect(x: 10, y: 5, width: 20, height: 20)
        image.tintColor = UIColor.init(red: 25/255, green: 165/255, blue: 153/255, alpha: 1)
        imageView.addSubview(image)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleNewMessage))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(recognizer)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UserCell.self, forCellReuseIdentifier: "CellId")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBarImage)
        navigationController?.navigationBar.tintColor = UIColor.init(red: 25/255, green: 165/255, blue: 153/255, alpha: 1)
        
        setViewContorllerUIComponents()
        
//        // initiliazing the sideMenu with the titles and the width
//        sideMenu = SideMenu(menuWidth: 165, menuItemTitles: menuItemTitles, parentViewController: self)
//        // setting  the delegate to self so we can be notified when the user presses a certain cell by calling the method didSelectMenuItem.
//        if let sideMenu = sideMenu {
//            sideMenu.menuDelegate = self
//        }

        //setContentSizeForScrollView()
        
        // little nice trick if we're using a tableViewController, we could actually modify the constraint, in this making it above the tabBarController
        //tableView.bottomAnchor.constraintEqualToAnchor(self.bottomLayoutGuide.topAnchor).active = true
        }

    //    override func viewWillAppear(animated: Bool) {
//        if messages.count == 0 {
//            observeLastMessagesConversation()
//            observeChangedLastMessagesConversation()
//        }
//    }
    
    override func viewWillAppear(animated: Bool) {
        //since we setting up user's name here from the nameTextfield when they first register so we won't make any other network request we're checking if the title is already been set up or not. also everytime we switch to another view we wanna maintain the same name and not make another network request to get a name everytime.
        if navigationItem.title == "" || navigationItem.title == nil {
            checkIfUserLoggedIn()
        }
        // if there is no messages displaying go ahead and get them from firebase in case someone logged out and logged in with a different email
        if messages.count == 0 && userNeverFiredMessagesObserver == true {
            observeLastMessagesConversation()
            observeChangedLastMessagesConversation()
            userNeverFiredMessagesObserver = false
        }
        
        if friends.count == 0 {
            fetchUserFriends()
        }
    }
    
    func setViewContorllerUIComponents() {
        view.addSubview(tableView)
        tableView.addSubview(scrollView)
        tableView.addSubview(separatorLineView)
        
        // x,y,h,w
        tableView.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.bottomAnchor).active = true
        tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        tableView.bottomAnchor.constraintEqualToAnchor(self.bottomLayoutGuide.topAnchor).active = true
        
        //searchController.
        
        // x,y,h,w
        // tableView is different than CollectionView, UIEdgeInsent didn't work as we expected here. It gave it 80 spaces from the top but it doesn't count that space as part of the tableView in constraint even though it's part of and it slides with it.
        scrollView.bottomAnchor.constraintEqualToAnchor(tableView.topAnchor).active = true
        scrollView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true // i've tried to set it equal to collectionView.leadingAnchor and it didn't but view.leadingAnchor seemed to work perfectly!
        scrollView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true // -> same thing here.
        //scrollView.bottomAnchor.constraintEqualToAnchor(tableView.topAnchor).active = true
        scrollView.heightAnchor.constraintEqualToConstant(80).active = true
        
        // x,y,h,w separatorLineView constraints
        separatorLineView.heightAnchor.constraintEqualToConstant(1).active = true
        separatorLineView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        separatorLineView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        separatorLineView.topAnchor.constraintEqualToAnchor(tableView.topAnchor).active = true

    }
    // 62
    var totalContentSize: CGFloat = 0.0
    var currentIndex: Int = 0
    func setContentSizeForScrollView() {
        
        while(currentIndex < friends.count) {
            let pageView = FriendsCellScrollView.loadFromNib()
            pageView.setUserInfo(friends[currentIndex])
            // setting up the frame of the page view right next to each other by increasing totalContentSize.
            pageView.frame = CGRect(origin: CGPoint(x: totalContentSize + 3, y: 0), size: CGSize(width: 55, height: 80))
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped(_:)))
            pageView.friendImageView.addGestureRecognizer(recognizer)
            // pageView.addGestureRecognizer(recognizer)
            scrollView.addSubview(pageView)
            // increasing totalContentSize by the pageView width
            totalContentSize += pageView.bounds.width
            currentIndex += 1
        }

        // finally we have all the pages and ready to set the scrollView contentSize to the totalContentSize of all the pagesView
        scrollView.contentSize = CGSize(width: totalContentSize, height: 65)
    }
    
    func scrollViewTapped(recognizer: UITapGestureRecognizer) {
        // pageWidth is now the width value of each cell that is placed in the scrollView. we're taking the whole width of the scrollView and deviding it by the total number of the array friends(representung the cell) to know how much width each cell in the scrollView occupies.
        if friends.count != 0 {
            let pageWidth = Int(scrollView.contentSize.width) / friends.count
            let index = Int(recognizer.locationInView(self.scrollView).x) / pageWidth
            let user = friends[index]
            showChatControllerForUser(user)
        }
    }
    
    func checkIfUserLoggedIn() {
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in.
                let uid = user.uid // getting the user's id
                
                // from he/she uid we could look he/she up in the dataBase and get her/his email and name. since we have a child users that has bunch of childs of uids that have their names and emails.
                self.ref.child("users").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in // observeSignleEvent will only get you certspecificain data but not all
                    
                    if let dict = snapshot.value as? [String: AnyObject] {
                        // you'll see that 1 is printing twice that's because .Value means as long as there is another value in this child (/users/uid) keep calling this function to retrieve all the data sitting underneath it till there is nothing but remember a specific child but not all childs. and all of the data we get back get stored in snapshot
                        //print(1)
                        
                        self.navigationItem.title = dict["name"] as? String
                        //self.titleView.text = dict["name"] as? String
                        
                        let user = User()
                        user.id = snapshot.key
                        user.setValuesForKeysWithDictionary(dict)
                        
                        // initiliazing the singleton to the userLoggedin.
                        CURRENT_USER.currentUser = user
                        
                    }
                    
                    }, withCancelBlock: nil)
            } else {
                // No user is signed in.
                self.handleLogout()
            }
        }
    }
    
    // fetching the dataBase for all your friends, storing them in an array (friedns) and displaying them in scrollView.
    func fetchUserFriends() {
        
        ref.child("users").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.id = snapshot.key
                user.setValuesForKeysWithDictionary(dictionary)
                self.friends.append(user)
                self.setContentSizeForScrollView()
                dispatch_async(dispatch_get_main_queue(), {
                    self.scrollView.reloadInputViews()
                })
            }
            }, withCancelBlock: nil)
        
    }
    
    // important ***************
    // this function should get us always the last message sent in each conversation between 2 people and display the in the Messages, userCell
    // so it makes sence to have a child in firebase that keeps track of the last message between 2 users and fire that here, instead of getting all the messages which might be 10000 messages and put some operation on like dictionary and array to get the last message sent, like this function is doing. which will take a long time.
    
    // .Value will only be called once and not when the value is changed but rather only when things gets added in that path where you're calling .Value at.
    func observeLastMessagesConversation() {
        // getting the user's id using a simple guard statement
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        ref.child("last-messages").child(uid).observeEventType(.ChildAdded, withBlock: { (snapshot) in
            // messageId here is every child under user-messages/uid. just the key
            let chatPartnerId = snapshot.key
            //print(chatPartnerId)
            // after getting the chatPartnerId, we need to fire a request on every child gets added
            self.ref.child("last-messages").child(uid).child(chatPartnerId).observeSingleEventOfType(.ChildAdded, withBlock: { (snapshot) in
                let messageId = snapshot.key
                //print(messageId)
                let messagesReference = FIRDatabase.database().reference().child("messages").child(messageId)
                messagesReference.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                   
                    if let dict = snapshot.value as? [String: AnyObject] {
                        let message = Message()
                        message.setValuesForKeysWithDictionary(dict)
                    
                        //self.messages.append(message)
                        self.messages.insert(message, atIndex: 0)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tableView.reloadData()
                        })
                    }
                    
                    }, withCancelBlock: nil)
                
                
                }, withCancelBlock: nil)
            
            }, withCancelBlock: nil)
    }
    
    // this observer will only observe if any changes happen to the path we give it and it'll give us back the data that was changed. like in this example, we go to last-messages/uid and this will get called if any of the existing data changed underneath it whether it's a child or node, and it will give us back the data that's been modified.
    // Notice this will not get called if a child gets added under uid, for example Last-messages/userId/now we have all the childs with id's of people that have last messages shared with them. this only gets called if the dataChanged and not Added.
    func observeChangedLastMessagesConversation() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        // observe anything that changes under this path. Not when childs gets added but only existing data are chnaged
        ref.child("last-messages").child(uid).observeEventType(.ChildChanged, withBlock: { (snapshot) in
            // messageId here is every child under user-messages/uid. just the key
            let chatPartnerId = snapshot.key
            print(chatPartnerId)
            // after getting the chatPartnerId, we need to fire a request on every child gets added
            self.ref.child("last-messages").child(uid).child(chatPartnerId).observeSingleEventOfType(.ChildAdded, withBlock: { (snapshot) in
                let messageId = snapshot.key
                print(messageId)
                let messagesReference = FIRDatabase.database().reference().child("messages").child(messageId)
                messagesReference.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    
                    if let dict = snapshot.value as? [String: AnyObject] {
                        let message = Message()
                        message.setValuesForKeysWithDictionary(dict)
                        
                        // bad data structure, definetly needs to be changed
                        for i in 0 ..< self.messages.count {
                            if (message.chatPartnerId() == self.messages[i].chatPartnerId()) {
                                self.messages.removeAtIndex(i)
                                self.messages.insert(message, atIndex: 0)
                            }
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tableView.reloadData()
                        })
                    }
                    
                    }, withCancelBlock: nil)
                
                
                }, withCancelBlock: nil)
            
            }, withCancelBlock: nil)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("CellId", forIndexPath: indexPath) as? UserCell {
            let message = messages[indexPath.row]
            cell.message = message
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.setSelected(false, animated: true)
        if let chatPartnerId = messages[indexPath.row].chatPartnerId() {
            ref.child("users").child(chatPartnerId).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                guard let dict = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let user = User()
                user.id = chatPartnerId
                user.setValuesForKeysWithDictionary(dict)
                self.showChatControllerForUser(user)
                    
            }, withCancelBlock: nil)
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
    }
    
    let userProfileVC = userProfile()
    
    // this is function must be implemented to confirm to SideMenuDelegate protocol
//    func didSelectMenuItem(withTitle title: String, index: Int) {
//        print("user pressed ", title, index)
//        
//        if title == "Profile" && index == 0 {
//            userProfileVC.user = CURRENT_USER.currentUser?.self
//            userProfileVC.button.setTitle("Following", forState: .Normal)
//            userProfileVC.button.setTitleColor(.whiteColor(), forState: .Normal)
//            userProfileVC.button.backgroundColor = UIColor.init(red: 118/255, green: 199/255, blue: 183/255, alpha: 1) //UIColor.init(red: 252/255, green: 92/255, blue: 99/255, alpha: 1) //UIColor.init(r: 234, g: 132, b: 108)
//            navigationController?.presentViewController(userProfileVC, animated: true, completion: nil)
//        }
//    }
    

    func handleLogout() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        self.navigationItem.title = nil
        let loginVC = LoginVC()
        // intializing the reference messagesController in LoginVC to this view so we can add stuff to it later on
        loginVC.messagesController = self
        resetWhenUserLogout()
        presentViewController(loginVC, animated: true, completion: nil)
    }
    
    func resetWhenUserLogout() {
        userProfileVC.userIsLogingOut()
        userNeverFiredMessagesObserver = true
        messages.removeAll()
        messagesDictionary.removeAll()
        friends.removeAll()
        currentIndex = 0
        totalContentSize = 0
        setContentSizeForScrollView()
        tableView.reloadData()
    }
    
    func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        // we're putting the view controller here in the navigation controller just so we can have the navigation bar on top everytime the page pops up
        presentViewController(UINavigationController(rootViewController: newMessageController), animated: true, completion: nil)
    }    
    
    func showChatControllerForUser(user: User) {
        let chatLogController = ChatLogController()
        chatLogController.user = user
        // this will hide the tabBarController on the bottom when chatLogController is being pushed. and that's how we want the chatLogController to look
        chatLogController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatLogController, animated: true)
    }

}

