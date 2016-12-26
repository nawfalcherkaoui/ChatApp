//
//  LoginVC.swift
//  ChatApp
//
//  Created by nawfal cherkaoui on 9/9/16.
//  Copyright © 2016 nawfal cherkaoui. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    let ref = FIRDatabase.database().reference()
    
    var messagesController = MessagesController()
    
    // i couldn't figure out how to change constraint with visual formats when a button is pressed but we can change it if we keep a reference to it and change the constant with anchors
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BackgroundImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.zPosition = -1
        return imageView
    }()
    
    let greetingUserLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        let attributedText = NSMutableAttributedString(string: "WELCOME BACK!", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(27),  NSForegroundColorAttributeName: UIColor.whiteColor()])
        attributedText.appendAttributedString(NSAttributedString(string: "\nStay Connected with your friends\n and beloved ones.",
            attributes: [NSFontAttributeName: UIFont.systemFontOfSize(15),
                NSForegroundColorAttributeName: UIColor.init(red: 118/255, green: 199/255, blue: 183/255, alpha: 1)
            ]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.characters.count))
        label.attributedText = attributedText
        label.textAlignment = .Center
        //label.textColor = UIColor.whiteColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var inputsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.10)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        //tf.placeholder = "Name"
        tf.attributedPlaceholder = NSAttributedString(string:"Name", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string:"Email", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        //tf.tintColor = .redColor()
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.secureTextEntry = true
        return tf
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "userMale")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.cornerRadius = 75
        imageView.layer.masksToBounds = true
        
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        return imageView
    }()
    
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
       let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = .whiteColor()
        sc.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.init(red: 118/255, green: 199/255, blue: 183/255, alpha: 1), NSFontAttributeName: UIFont.systemFontOfSize(15)], forState: .Selected) // setting the color for the text (Loging & Register)
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleloginRegisterSegmentedChange), forControlEvents: .ValueChanged)
        return sc
    }()
    
    func handleloginRegisterSegmentedChange() {
        let title = loginRegisterSegmentedControl.titleForSegmentAtIndex(loginRegisterSegmentedControl.selectedSegmentIndex)
        LoginRegisterButton.setTitle(title, forState: .Normal)
        
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            inputsContainerViewHeightAnchor?.constant = 100 // decrease height for inputContainer
            
            nameTextFieldHeightAnchor?.active = false // deactivate the constraint so we can make a new height constraint for height of 0 for nameTextField
            nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraintEqualToConstant(0)
            nameTextFieldHeightAnchor?.active = true
            
            nameSeparatorView.hidden = true
            
            emailTextFieldHeightAnchor?.active = false
            emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraintEqualToAnchor(inputsContainer.heightAnchor, multiplier: 1/2)
            emailTextFieldHeightAnchor?.active = true
            
            passwordTextFieldHeightAnchor?.active = false
            passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraintEqualToAnchor(emailTextField.heightAnchor)
            passwordTextFieldHeightAnchor?.active = true
            
            profileImageView.hidden = true
            greetingUserLabel.hidden = false
            
        } else {
            inputsContainerViewHeightAnchor?.constant = 150
            
            nameSeparatorView.hidden = false
            
            nameTextFieldHeightAnchor?.active = false
            nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraintEqualToAnchor(inputsContainer.heightAnchor, multiplier: 1/3) // 1/3 here means its height is -> its superview which is inputContainer devided by 3. the result of that is the height of nameTextField
            nameTextFieldHeightAnchor?.active = true
            
            emailTextFieldHeightAnchor?.active = false
            emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraintEqualToAnchor(nameTextField.heightAnchor)
            emailTextFieldHeightAnchor?.active = true
            
            passwordTextFieldHeightAnchor?.active = false
            passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraintEqualToAnchor(nameTextField.heightAnchor)
            passwordTextFieldHeightAnchor?.active = true
            
            profileImageView.hidden = false
            greetingUserLabel.hidden = true
        }
        
        //inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
    }
    
    
    lazy var LoginRegisterButton: UIButton = {
        let button = UIButton(type: .System)
        button.setTitle("REGISTER", forState: .Normal)
        button.setTitleColor(.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        button.backgroundColor = UIColor.init(red: 118/255, green: 199/255, blue: 183/255, alpha: 1) //UIColor.init(red: 252/255, green: 92/255, blue: 99/255, alpha: 1) //UIColor(r: 80, g: 101, b: 161)
        //button.layer.borderColor = UIColor.whiteColor().CGColor
        //button.layer.borderWidth = 1
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLoginRegisterButton), forControlEvents: .TouchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        view.backgroundColor = .grayColor()
        setupViews()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(inputsContainer)
        inputsContainer.addSubview(nameTextField)
        inputsContainer.addSubview(emailTextField)
        inputsContainer.addSubview(passwordTextField)
        inputsContainer.addSubview(nameSeparatorView)
        inputsContainer.addSubview(emailSeparatorView)
        view.addSubview(profileImageView)
        view.addSubview(LoginRegisterButton)
        view.addSubview(loginRegisterSegmentedControl)
        
        // add a greeting label when the user comes Log Back again
        view.addSubview(greetingUserLabel)
        
        //x,y,w,h
        backgroundImageView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        backgroundImageView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        backgroundImageView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
        backgroundImageView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        
        
        view.addConstraintsWithFormat("V:[v0(150)]-10-[v1(36)]-10-[v2]-10-[v3(50)]", views: profileImageView, loginRegisterSegmentedControl, inputsContainer, LoginRegisterButton)
        inputsContainer.addConstraintsWithFormat("V:|[v0][v1(1)][v2][v3(1)][v4]|", views: nameTextField, nameSeparatorView, emailTextField, emailSeparatorView, passwordTextField)
        
        inputsContainer.addConstraintsWithFormat("H:|-8-[v0]|", views: nameTextField)// 8 space leading an space at the end (trailling)
        inputsContainer.addConstraintsWithFormat("H:|-8-[v0]|", views: emailTextField)
        inputsContainer.addConstraintsWithFormat("H:|-8-[v0]|", views: passwordTextField)
        
        view.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: loginRegisterSegmentedControl)
        view.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: inputsContainer)
        inputsContainer.addConstraintsWithFormat("H:|[v0]|", views: nameSeparatorView)
        inputsContainer.addConstraintsWithFormat("H:|[v0]|", views: emailSeparatorView)
        view.addConstraintsWithFormat("H:|-20-[v0]-20-|", views: LoginRegisterButton)
    
        profileImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        inputsContainer.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        
        profileImageView.widthAnchor.constraintEqualToConstant(150).active = true
        inputsContainerViewHeightAnchor = inputsContainer.heightAnchor.constraintEqualToConstant(150)
        inputsContainerViewHeightAnchor?.active = true
        
        // constraints for greetingUserLabel
        greetingUserLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        greetingUserLabel.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 95).active = true
        //greetingUserLabel.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        greetingUserLabel.hidden = true
        
        // setting up the textFields Heights to be the exact(equal) same height for all three of them
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraintEqualToAnchor(inputsContainer.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraintEqualToAnchor(nameTextField.heightAnchor)
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraintEqualToAnchor(nameTextField.heightAnchor)
        nameTextFieldHeightAnchor?.active = true
        emailTextFieldHeightAnchor?.active = true
        passwordTextFieldHeightAnchor?.active = true
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let _ = touches.first {
            emailTextField.resignFirstResponder()
            nameTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
        }
    }
    
}



extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
}