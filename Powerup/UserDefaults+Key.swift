//
//  UserDefaults+Key.swift
//  Powerup
//
//  Created by Anubhav Singh on 06/03/20.
//  Copyright © 2020 Systers. All rights reserved.
//

import Foundation

extension UserDefaults {
  enum Key: String {
    case reviewWorthyActionCount
    case lastReviewRequestAppVersion
  }

  func integer(forKey key: Key) -> Int {
    return integer(forKey: key.rawValue)
  }

  func string(forKey key: Key) -> String? {
    return string(forKey: key.rawValue)
  }

  func set(_ integer: Int, forKey key: Key) {
    set(integer, forKey: key.rawValue)
  }

  func set(_ object: Any?, forKey key: Key) {
    set(object, forKey: key.rawValue)
  }
}
