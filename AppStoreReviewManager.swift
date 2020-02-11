//
//  AppStoreReviewManager.swift
//  Powerup

import Foundation

import StoreKit

enum AppStoreReviewManager {
    
    static func requestReviewIfAppropriate() {
        
        // funcion for Requesting App Ratings
        SKStoreReviewController.requestReview()
        
    }
}
