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
            label.stringValue = isSelected ? "Select" : "NoSelect"
        }
    }
    var text: String = "defualt"
    
    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var iconBackgroundView: NSVisualEffectView!
    @IBOutlet weak var image: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.stringValue = text
        iconBackgroundView.wantsLayer = true
        iconBackgroundView.layer?.cornerRadius = 12
    }
    
}
