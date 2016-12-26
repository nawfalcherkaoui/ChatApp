//
//  userImagesCollection.swift
//  ChatApp
//
//  Created by nawfal cherkaoui on 11/3/16.
//  Copyright © 2016 nawfal cherkaoui. All rights reserved.
//

import UIKit

extension UserProfileVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 0
//    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellId", forIndexPath: indexPath) as? imageCellProfile {
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    
    // this will give spaces arround the collectionViewCells, like 1 space from the left, 1 space from the left, and bottom. and giving it the height of the userInfoContainer from the top to make sit right underneath it.
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: userInfoContainer.frame.height, left: 1, bottom: 1, right: 1)
    }
}
