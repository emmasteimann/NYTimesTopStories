//
//  ImageCache.swift
//  NYTimesTopStories
//
//  Created by Emma Steimann on 11/14/17.
//  Copyright © 2017 Emma Steimann. All rights reserved.
//

import UIKit
class ImageCache {
  let imgCache = NSCache<AnyObject, AnyObject>()

  static let sharedInstance = ImageCache()

  func addImageURL(imageURL:String, withImage image: UIImage) {
    self.imgCache.setObject(image, forKey: imageURL as AnyObject)
  }

  func getImageForURL(imageURL: String) -> UIImage? {
    return self.imgCache.object(forKey: imageURL as AnyObject) as? UIImage
  }

  func doesImageForURLExist(imageURL: String) -> Bool {
    if self.imgCache.object(forKey: imageURL as AnyObject as AnyObject) == nil {
      return false
    }
    return true
  }
}
