//
//  Symbols.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/7/6.
//

import AppKit

class Symbols {
    static var shared = Symbols()

    private let allSymbolsAppleHave: [String] = []
//    private let allSymbolsGroup: [String: [String]] = [
        
//    ]
    
    lazy var currentAvailables: [String] = {
        return allSymbolsAppleHave.filter{ $0.isAvailable }
    }()
//    lazy var group: [String: [String]] = {
//        
//    }()
    
}

fileprivate
extension String {
    var isAvailable: Bool {
        NSImage(systemSymbolName: self, accessibilityDescription: nil) != nil
    }
}
