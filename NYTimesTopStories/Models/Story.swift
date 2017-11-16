//
//  File.swift
//  NYTimesTopStories
//
//  Created by Emma Steimann on 11/14/17.
//  Copyright © 2017 Emma Steimann. All rights reserved.
//

import Foundation

typealias StoryArray = [Story]

struct Story {
  let title:String?
  let publishedDate:Date?
  let storyMultimedia:[StoryMultimedia]
  let url:URL?
  
  func testMe() -> String {
    return "red"
  }
}

struct StoryMultimedia {
  let url:URL
  let height:Int
  let width:Int
  let type:String
  let subType:String
  let format:String
}
