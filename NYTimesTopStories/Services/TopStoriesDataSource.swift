//
//  TopStoriesDataSource.swift
//  NYTimesTopStories
//
//  Created by Emma Steimann on 11/14/17.
//  Copyright © 2017 Emma Steimann. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol TopStoriesDataSourceDelegate: class {
  func allStoriesLoaded()
}

extension TopStoriesDataSourceDelegate {
  // optional methods here
}


class TopStoriesDataSource {
  // Singleton
  static let sharedInstance:TopStoriesDataSource = TopStoriesDataSource()
  weak var delegate:TopStoriesDataSourceDelegate?
  private let opQ = OperationQueue()
  var stories:[Story] = [Story]()
  var rawJSON:JSON = JSON()
  
  func itemAtIndexPath(_ index:NSIndexPath) -> Story? {
    if stories.count > 0 {
      return stories[index.item]
    }
    return nil
  }
  
  func loadTopStories() {
    let tSop = TopStoriesOperation(completionHandler: { [unowned self] (result:AnyObject?, success:Bool?) in
      if success == true && result != nil {
        self.rawJSON = result as! JSON
        self.processData(result as! JSON)
      }
    })
    opQ.addOperation(tSop)
  }
  
  func processData(_ result:JSON) {
    for story in result["results"].arrayValue {
      var multiStore = [StoryMultimedia]()
      for storyMulti in story["multimedia"].arrayValue {
        let newStoryMultimedia = StoryMultimedia(url: URL(string: storyMulti["url"].stringValue)!, height: storyMulti["height"].intValue, width: storyMulti["width"].intValue, type: storyMulti["type"].stringValue, subType: storyMulti["subtype"].stringValue, format: storyMulti["format"].stringValue)
        multiStore.append(newStoryMultimedia)
      }
      let dateFormatterGet = DateFormatter()
      // 2017-11-14T17:57:25-05:00
      dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
      let date = dateFormatterGet.date(from: story["published_date"].stringValue)
      
      let newStory = Story(title: story["title"].stringValue, publishedDate: date, storyMultimedia: multiStore, url: URL(string: story["url"].stringValue))

      
      self.stories.append(newStory)
      self.delegate?.allStoriesLoaded()
    }
  }
  
}
