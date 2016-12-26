//
//  LoginHandlers.swift
//  ChatApp
//
//  Created by nawfal cherkaoui on 9/13/16.
//  Copyright © 2016 nawfal cherkaoui. All rights reserved.
//

import UIKit
import Firebase

extension LoginVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func handleLoginRegisterButton() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLoginButton()
        } else {
            handleRegisterButton()
        }
    }
    
    
    func handleRegisterButton() {
        guard let name = nameTextField.text where name.characters.count >= 1, let email = emailTextField.text, password = passwordTextField.text where password.characters.count > 5 else {
            print("Form is not valid")
            return
        }
        // creat a new user and SignIn
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                // try localizedSuggestions
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            // else the user was succesfully created
            // give the picture a unique id
            let imageId = NSUUID().UUIDString
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageId).png") // set up a path for it in storage under profile_images folder and a child with that its unique id
            
            //let imageCompressed = self.compressImage(self.profileImageView.image!)
            
            if let uploadData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.2) { // convert the image to binary (NSData)
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in  // putting the data in storage that returns a metadata which contains its URL
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                        let values = ["name": name, "email": email, "profileImage": profileImageURL]
                        self.registerUserIntoDatabaseWithUID(uid, values: values)
                    }
                    
                })
            }
        })
    }
    
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let usersReference = self.ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
            
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            self.messagesController.navigationItem.title = values["name"] as? String
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    
    func handleLoginButton() {
        guard let email = emailTextField.text, password = passwordTextField.text where password.characters.count > 5 else {
            print("Form is not valid")
            return
        }
        // sign in an existing user
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            
            if let error = error {
                print(error.code)
                if let errCode = FIRAuthErrorCode(rawValue: error.code) {
                    switch errCode {
                    case .ErrorCodeInvalidEmail:
                        print("\nthis email doesn't exist please register with (name of the app)\n")
                    case .ErrorCodeWrongPassword:
                        print("\nYou inserted the wrong password\n")
                    case .ErrorCodeUserDisabled:
                        print("\nYour account is disabled, would you want to activate it again?\n")
                    default:
                        print("Create User Error: \(error)")
                    }
                }
                print(error.localizedDescription)
                return
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let editingImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            profileImageView.image = editingImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            profileImageView.image = originalImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
//    enum FIRAuthErrorCode: String {
//        case FIRAuthErrorCodeNetworkError = "FIRAuthErrorCodeNetworkError"
//        case FIRAuthErrorCodeUserNotFound = "FIRAuthErrorCodeUserNotFound"
//        case FIRAuthErrorCodeUserTokenExpired = "FIRAuthErrorCodeUserTokenExpired"
//        case FIRAuthErrorCodeTooManyRequests = "FIRAuthErrorCodeTooManyRequests"
//        case FIRAuthErrorCodeInvalidEmail = "FIRAuthErrorCodeInvalidEmail"
//        case FIRAuthErrorCodeWrongPassword = "FIRAuthErrorCodeWrongPassword"
//    }
    
    
    
    
    
    
    //compression of pictures
    
//    func compressImage(image: UIImage) -> UIImage? {
//        
//        var actualHeight: CGFloat = image.size.height;
//        var actualWidth: CGFloat = image.size.width;
//        let maxHeight: CGFloat = 600.0;
//        let maxWidth: CGFloat = 800.0;
//        var imgRatio: CGFloat = actualWidth/actualHeight;
//        let maxRatio: CGFloat = maxWidth/maxHeight;
//        let compressionQuality: CGFloat = 0.5;//50 percent compression
//        if (actualHeight > maxHeight || actualWidth > maxWidth){
//            if(imgRatio < maxRatio){
//                //adjust width according to maxHeight
//                imgRatio = maxHeight / actualHeight;
//                actualWidth = imgRatio * actualWidth;
//                actualHeight = maxHeight;
//            } else if(imgRatio > maxRatio) {
//                //adjust height according to maxWidth
//                imgRatio = maxWidth / actualWidth;
//                actualHeight = imgRatio * actualHeight;
//                actualWidth = maxWidth;
//            } else {
//                actualHeight = maxHeight;
//                actualWidth = maxWidth;
//            }
//        }
//        let rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
//        UIGraphicsBeginImageContext(rect.size);
//        image.drawInRect(rect)
//        let img = UIGraphicsGetImageFromCurrentImageContext();
//        let imageData = UIImageJPEGRepresentation(img, compressionQuality);
//        UIGraphicsEndImageContext();
//        return UIImage(data: imageData!)!
//    }
    
    
    
}
