//
//  CollectionViewCell.swift
//  NYTimesTopStories
//
//  Created by Emma Steimann on 11/15/17.
//  Copyright © 2017 Emma Steimann. All rights reserved.
//

import UIKit
import SnapKit
import MarqueeLabel

class CollectionViewCell: UICollectionViewCell {
  var story:Story?
  var imageView:UIImageView?
  var marquee:MarqueeLabel?
  
  var initialLoad = true
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if self.story != nil {
    
      if initialLoad {
        imageView = UIImageView()
        marquee = MarqueeLabel(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: 50))
        marquee?.textColor = UIColor.white
        marquee?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        marquee?.font = UIFont.boldSystemFont(ofSize: 40)
        self.contentView.addSubview(imageView!)
        self.contentView.addSubview(marquee!)
        initialLoad = false
      }
      
      imageView?.snp.makeConstraints {(make) -> Void in
        make.width.height.equalTo(self.contentView)
      }
      

      
      self.contentView.backgroundColor = generateRandomColor()
    }
  }
  
  func setStory(_ story:Story) {
      self.story = story
      self.layoutSubviews()
      buildView()
  }
  
  func buildView() {
    if let cellStory = story {
      marquee?.text = cellStory.title! + " "
      self.imageView?.image = nil
      let normal = cellStory.storyMultimedia.filter { $0.format == "superJumbo" }.first
      if normal != nil {
        let normalUrlString = normal!.url.absoluteString
        ImageDownloader.loadImageFromURLString(url: normalUrlString, callback: { (image, url) in
            ImageCache.sharedInstance.addImageURL(imageURL: url, withImage: image)
            self.imageView?.image = image
            self.marquee?.frame = CGRect(x: 0, y: self.contentView.frame.height - 50, width: self.contentView.frame.width, height: 50)
        })
      } else {
        marquee?.center = self.contentView.center
      }
    }
  }
  
  
  override func prepareForReuse() {
    if marquee != nil {
      marquee?.text = ""
    }
    imageView?.image = nil
  }
  
  func generateRandomColor() -> UIColor {
    let hue : CGFloat = CGFloat(arc4random() % 256) / 256
    let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5
    let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5
    return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
  }
}
