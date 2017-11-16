//
//  ConcurrentOperation.swift
//  NYTimesTopStories
//
//  Created by Emma Steimann on 11/14/17.
//  Copyright © 2017 Emma Steimann. All rights reserved.
//

import Foundation

class ConcurrentOperation: Operation {
  typealias CompletionHandler = (_ result:AnyObject?, _ success:Bool?)  -> Void
  var completionHandler:CompletionHandler?
  var result:AnyObject?
  var success:Bool?

  public enum State: String {
    case Ready, Executing, Finished

    private var keyPath: String {
      return "is" + rawValue
    }
  }

  var state = State.Ready {
    willSet {
      NSObject.willChangeValue(forKey: newValue.rawValue)
      NSObject.willChangeValue(forKey: state.rawValue)
    }
    didSet {
      NSObject.didChangeValue(forKey: oldValue.rawValue)
      NSObject.didChangeValue(forKey: state.rawValue)
    }
  }

  convenience init(completionHandler:@escaping CompletionHandler) {
    self.init()
    self.completionHandler = completionHandler
  }

  func completeOperation() {
    if let completionHandler = self.completionHandler {
      DispatchQueue.main.async {
        completionHandler(self.result, self.success);
      }
    }
  }
}


extension ConcurrentOperation {
  override public var isReady: Bool {
    return super.isReady && state == .Ready
  }

  override public var isExecuting: Bool {
    return state == .Executing
  }

  override public var isFinished: Bool {
    return state == .Finished
  }

  override public var isAsynchronous: Bool {
    return true
  }

  override public func start() {
    if isCancelled {
      state = .Finished
      return
    }

    main()
    state = .Executing
  }

  override public func cancel() {
    state = .Finished
  }
}
