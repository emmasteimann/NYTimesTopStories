//
//  TopStoriesOperation.swift
//  NYTimesTopStories
//
//  Created by Emma Steimann on 11/15/17.
//  Copyright © 2017 Emma Steimann. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class TopStoriesOperation: ConcurrentOperation {
  override func main() {
    let apiKey = Bundle.main.object(forInfoDictionaryKey: "apiKey") as! String
    let apiUrl = Bundle.main.object(forInfoDictionaryKey: "apiUrl") as! String
    
    let parameters:Parameters = ["api-key": apiKey]
    
    Alamofire.request(apiUrl, parameters: parameters).validate().responseJSON { response in
      switch response.result {
      case .success:
        if let value = response.result.value {
          let json = JSON(value)
          self.result = json as AnyObject
          self.success = true
          self.completeOperation()
          return
        }
      case .failure(let error):
        print(error)
        self.success = false
        self.completeOperation()
        return
      }
      self.success = false
      self.completeOperation()
      return
    }
  }
  
  deinit {
    print("Removing: TopStories Operation")
  }
}
