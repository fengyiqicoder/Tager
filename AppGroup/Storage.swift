//
//  AppGroup.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/6/13.
//

import AppKit

let appGroupSuitName = "group.LabelMaker"
//let AppGroupSuitNameWithTeamID = "K2D6DE8NGJ.Tager"

extension UserDefaults {
    
    static var appGroup: UserDefaults {
        return UserDefaults(suiteName: appGroupSuitName)!
    }
}
