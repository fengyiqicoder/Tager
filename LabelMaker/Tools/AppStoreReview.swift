//
//  AppStoreReview.swift
//  Tager
//
//  Created by Edmund Feng on 2021/7/30.
//

import AppKit
import StoreKit

class ReviewController {
    static var shared = ReviewController()
    
    private var usedTime: Int {
        get {
            (UserDefaults.standard.object(forKey: "usedTime") as? Int) ?? 0
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "usedTime")
        }
    }
    
    func checkForReviewRequest() {
        usedTime += 1
        if usedTime == 30 {
            SKStoreReviewController.requestReview()
        }
    }
}

