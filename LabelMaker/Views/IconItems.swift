//
//  IconItems.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/6/13.
//

import AppKit

class IconItem: NSCollectionViewItem {
    
    override var isSelected: Bool {
        didSet {
            setState(isSeleted: isSelected)
        }
    }
    var text: String = "defualt"
    
    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var image: NSImageView!
    @IBOutlet weak var backgroundBox: NSBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.stringValue = text
        
        backgroundBox.fillColor = NSColor.textBackgroundColor.withAlphaComponent(1.0)
        backgroundBox.borderWidth = 0
        backgroundBox.cornerRadius = 14
        backgroundBox.layer?.cornerCurve = .continuous
    }
    
    func setState(isSeleted: Bool) {
        if isSelected {
            backgroundBox.borderWidth = 3
            backgroundBox.borderColor = NSColor.blue
        } else {
            backgroundBox.borderWidth = 0
        }
    }
}
