//
//  imageCellProfile.swift
//  ChatApp
//
//  Created by nawfal cherkaoui on 11/4/16.
//  Copyright © 2016 nawfal cherkaoui. All rights reserved.
//

import UIKit

class imageCellProfile: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellComponents()
        backgroundColor = .whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var userImagesView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
        //imageView.image = UIImage(named: "SkyImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func setupCellComponents() {
        // setting up the layout of a cell here
        self.addSubview(userImagesView)
        
        //x,y,w,h
        userImagesView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor).active = true
        userImagesView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor).active = true
        userImagesView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        userImagesView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        
    }
    

}
