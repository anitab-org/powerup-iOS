//
//  AppStoreReviewManager.swift..swift
//  Powerup
//
//  Created by Anubhav Singh on 06/02/20.
//  Copyright © 2020 Systers. All rights reserved.
//

import Foundation

import StoreKit

enum AppStoreReviewManager {
  static func requestReviewIfAppropriate() {
    
    SKStoreReviewController.requestReview()
    
  }
}
