//
//  LaunchController.swift
//  Tager
//
//  Created by Edmund Feng on 2021/7/10.
//

import AppKit

class LanuchController {
    static var shared = LanuchController()
    
    func checkFistTimeLaunch() -> Bool {
        if firstTimeLaunch {
            return true
        } else {
            firstTimeLaunch = true
            return false
        }
    }
    
    private var firstTimeLaunch: Bool {
        get {
            UserDefaults.standard.object(forKey: "firstTime") as? Bool ?? false
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "firstTime")
        }
    }
}
