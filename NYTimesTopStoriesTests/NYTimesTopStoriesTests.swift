//
//  NYTimesTopStoriesTests.swift
//  NYTimesTopStoriesTests
//
//  Created by Emma Steimann on 11/14/17.
//  Copyright © 2017 Emma Steimann. All rights reserved.
//

import Quick
import Nimble
import XCTest
import SwiftyJSON
@testable import NYTimesTopStories

class TopStoriesDataSourceSpec: QuickSpec {
  override func spec() {
    describe("Top Stories Data Source") {
      context("when loading json") {
        var tSds:TopStoriesDataSource!
        var topJSON:JSON!
        beforeEach {
          tSds = TopStoriesDataSource.sharedInstance
          let path = Bundle.main.path(forResource: "NYT", ofType: "json")
          let jsonData = NSData(contentsOfMappedFile: path!)
          topJSON = JSON(jsonData)
        }
        it("it creates an array of stories") {
          expect(tSds.stories).to(beEmpty())
          tSds.processData(topJSON)
          expect(tSds.stories).toEventually(beAnInstanceOf([Story].self))
          expect(tSds.stories.count).toEventually(beGreaterThan(0))
        }
      }
    }
  }
}

class TopStoriesAPI: QuickSpec {
  override func spec() {
    describe("NYT Times API") {
      context("when being called remotely on a concurrent operation queue") {
        var tSds:TopStoriesDataSource!
        beforeEach {
          tSds = TopStoriesDataSource.sharedInstance
        }
        // NOTE: This will fail if it can't reach the API
        it("Returns a valid json object") {
          expect(tSds.rawJSON).to(beEmpty())
          tSds.loadTopStories()
          expect(tSds.rawJSON).toEventually(beAnInstanceOf(JSON.self))
        }
      }
    }
  }
}


