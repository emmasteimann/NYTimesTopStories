//
//  ImageDownloader.swift
//  NYTimesTopStories
//
//  Created by Emma Steimann on 11/14/17.
//  Copyright © 2017 Emma Steimann. All rights reserved.
//

import UIKit

class ImageDownloader {
  class func loadImageFromURLString(url:String, callback:@escaping (_ image:UIImage, _ imageURL:String) -> Void) {

    if ImageCache.sharedInstance.doesImageForURLExist(imageURL: url) {
      let image = ImageCache.sharedInstance.getImageForURL(imageURL: url)!
      callback(image, url)
      return
    }

    DispatchQueue.global(qos: .userInitiated).async {
      let request:NSURLRequest = NSURLRequest(url:NSURL(string:url)! as URL)
      let config = URLSessionConfiguration.default
      let session = URLSession(configuration: config)

      session.dataTask(with: request as URLRequest as URLRequest, completionHandler: { (data, response, error) in

        if let error = error {

          print(error.localizedDescription)

        } else if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {

          if let data = data {
            let image:UIImage = UIImage(data: data)!
            DispatchQueue.main.async {
              callback(image, url)
            }
          }

        }

      }).resume()
    }
  }
}
