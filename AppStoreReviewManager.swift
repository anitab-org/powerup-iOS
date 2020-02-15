//
//  AppStoreReviewManager.swift
//  Powerup
import Foundation

import StoreKit

enum AppStoreReviewManager {
  
  static let minimumReviewWorthyActionCount = 4

  static func requestReviewIfAppropriate() {
    let defaults = UserDefaults.standard
    let bundle = Bundle.main

    // Read the current number of actions that the user has performed since the last requested review from the User Defaults.
    
    var actionCount = defaults.integer(forKey: .reviewWorthyActionCount)
    
  /*  Note: This sample project uses an extension on UserDefaults to eliminate the need for using “stringly” typed keys when accessing values. This is a good practice to follow in order to avoid accidentally mistyping a key as it can cause hard-to-find bugs in your app. You can find this extension in UserDefaults+Key.swift.
 */
    
    actionCount += 1

    defaults.set(actionCount, forKey: .reviewWorthyActionCount)

    guard actionCount >= minimumReviewWorthyActionCount else {
      return
    }
    
    let bundleVersionKey = kCFBundleVersionKey as String
    let currentVersion = bundle.object(forInfoDictionaryKey: bundleVersionKey) as? String
    let lastVersion = defaults.string(forKey: .lastReviewRequestAppVersion)

    // Check if this is the first request for this version of the app before continuing.
    guard lastVersion == nil || lastVersion != currentVersion else {
      return
    }

    SKStoreReviewController.requestReview()

    // Reset the action count and store the current version in User Defaults so that you don’t request again on this version of the app.
    defaults.set(0, forKey: .reviewWorthyActionCount)
    defaults.set(currentVersion, forKey: .lastReviewRequestAppVersion)
  }
  
  
}


