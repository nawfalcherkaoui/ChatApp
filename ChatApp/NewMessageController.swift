//
//  NewMessageController.swift
//  ChatApp
//
//  Created by nawfal cherkaoui on 9/12/16.
//  Copyright © 2016 nawfal cherkaoui. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    let ref = FIRDatabase.database().reference()
    
    var users = [User]()
    
    var messagesController: MessagesController?
    
    let cellId = "CellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(handleCancel))
        navigationItem.title = "Contacts"
        fetchUser()
        tableView.registerClass(UserCell.self, forCellReuseIdentifier: cellId)
        
        tableView.addSubview(searchController.searchBar)
        //let height = searchController.searchBar.frame.height
        //tableView.contentInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        
    }
    
        lazy var searchController: UISearchController = {
            let searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.searchBar.backgroundColor = .redColor()
            searchController.dimsBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Search here..."
            searchController.searchBar.delegate = self
            searchController.searchBar.sizeToFit()
    
            // Place the search bar view to the tableview headerview.
            self.tableView.tableHeaderView = searchController.searchBar
            return searchController
        }()
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
    // getting people's email and name to display in the table view
    func fetchUser() {
        
        ref.child("users").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.id = snapshot.key
                user.setValuesForKeysWithDictionary(dictionary)
                self.users.append(user)
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        }, withCancelBlock: nil)
        
    }
    
    
    func handleCancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as? UserCell {
            let user = users[indexPath.row]
            cell.textLabel?.text = user.name
            cell.detailTextLabel?.text = user.email
            if let profileImageURL = user.profileImage {
                cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageURL)
            }
//            else {
//                cell.profileImageView.backgroundColor = .redColor()
//            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dismissViewControllerAnimated(true) {
            print("Dismiss completed")
            let user = self.users[indexPath.row]
            self.messagesController?.showChatControllerForUser(user)
        }
        
//        let user = self.users[indexPath.row]
//        chatLogControllerForUser(user)

    }
    
    
    
    
//    func chatLogControllerForUser(user: User) {
//        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
//        chatLogController.user = user
//        navigationController?.pushViewController(chatLogController, animated: true)
//    }
    
//    (UIImage *)compressImage:(UIImage *)image{
//    float actualHeight = image.size.height;
//    float actualWidth = image.size.width;
//    float maxHeight = 600.0;
//    float maxWidth = 800.0;
//    float imgRatio = actualWidth/actualHeight;
//    float maxRatio = maxWidth/maxHeight;
//    float compressionQuality = 0.5;//50 percent compression 
//    if (actualHeight > maxHeight || actualWidth > maxWidth){
//        if(imgRatio < maxRatio){
//            //adjust width according to maxHeight
//            imgRatio = maxHeight / actualHeight;
//            actualWidth = imgRatio * actualWidth;
//            actualHeight = maxHeight;
//        } else if(imgRatio > maxRatio) {
//            //adjust height according to maxWidth 
//            imgRatio = maxWidth / actualWidth;
//            actualHeight = imgRatio * actualHeight;
//            actualWidth = maxWidth;
//        } else {
//            actualHeight = maxHeight;
//            actualWidth = maxWidth;
//        }
//    }
//    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
//    UIGraphicsBeginImageContext(rect.size);
//    [image drawInRect:rect];
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
//    UIGraphicsEndImageContext();
//    return [UIImage imageWithData:imageData];
//    }
    
}
