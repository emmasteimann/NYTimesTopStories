//
//  ViewController.swift
//  NYTimesTopStories
//
//  Created by Emma Steimann on 11/14/17.
//  Copyright © 2017 Emma Steimann. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UICollectionViewController, TopStoriesDataSourceDelegate, UICollectionViewDelegateFlowLayout, SFSafariViewControllerDelegate {
  let tSds = TopStoriesDataSource.sharedInstance
  
  func allStoriesLoaded() {
    self.collectionView?.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView?.backgroundColor = UIColor.black
    self.collectionView!.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
    
    tSds.delegate = self
    tSds.loadTopStories()
  }
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    if tSds.stories.count > 0 {
      return 1
    }
    return 0
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if tSds.stories.count > 0 {
      return TopStoriesDataSource.sharedInstance.stories.count
    }
    return 0
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
    if let item = TopStoriesDataSource.sharedInstance.itemAtIndexPath(indexPath as NSIndexPath) {
      cell.setStory(item)
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      if let item = TopStoriesDataSource.sharedInstance.itemAtIndexPath(indexPath as NSIndexPath) {
        let normal = item.storyMultimedia.filter { $0.format == "superJumbo" }.first
        if (normal != nil) {
          let ratio:CGFloat = CGFloat(normal!.height) / CGFloat(normal!.width)
          let newHeight = (self.collectionView?.frame.size.width)! * ratio
          return CGSize(width: (self.collectionView?.frame.size.width)!, height: newHeight)
        }
        return CGSize(width: (self.collectionView?.frame.size.width)!, height: 100)
      }
      return CGSize(width: 0, height: 0)
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let item = TopStoriesDataSource.sharedInstance.itemAtIndexPath(indexPath as NSIndexPath) {
      let safariVC = SFSafariViewController(url: item.url!)
      self.present(safariVC, animated: true, completion: nil)
      safariVC.delegate = self
    }
  }
  
  func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    controller.dismiss(animated: true, completion: nil)
  }

}

