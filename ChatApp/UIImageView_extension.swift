//
//  UIImageView_extension.swift
//  ChatApp
//
//  Created by nawfal cherkaoui on 9/17/16.
//  Copyright © 2016 nawfal cherkaoui. All rights reserved.
//

import UIKit

let imageCache = NSCache()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.objectForKey(urlString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        if let url = NSURL(string: urlString) {
            NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
                
                //download hit an error so lets return out
                if error != nil {
                    print(error)
                    return
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if let downloadedImage = UIImage(data: data!) {
                        imageCache.setObject(downloadedImage, forKey: urlString)
                        
                        self.image = downloadedImage
                    }
                }
                
            }.resume()

        }
    }
    
    
}
