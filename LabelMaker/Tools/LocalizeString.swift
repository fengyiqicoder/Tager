//
//  LocalizeString.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/7/11.
//

import Foundation

extension String {
    var localize: String {
        NSLocalizedString(self, comment: "")
    }
}
