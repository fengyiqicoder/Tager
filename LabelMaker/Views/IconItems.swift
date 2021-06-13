//
//  IconItems.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/6/13.
//

import AppKit

class IconItem: NSCollectionViewItem {
    
    var text: String = "defualt"
    
    @IBOutlet weak var label: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.stringValue = text
    }
    
}
