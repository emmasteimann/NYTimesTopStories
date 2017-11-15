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
@testable import NYTimesTopStories

class StorySpec: QuickSpec {
  override func spec() {
    describe("A NYC Story") {
      var myStory:Story!
      beforeEach {
        myStory = Story()
        print(myStory.cat)
      }
      context("if a story exists it is testable") {
        it("has testMe as green") {
          let testableValue = myStory.testMe()
          print("Heeeeeellllllo")
          print("🐙🐙🐙🐙🐙🐙🐙")
          print(myStory)
          expect(testableValue).to(equal("red"))
        }
      }
    }
  }
}
