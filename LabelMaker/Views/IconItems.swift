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
    @IBOutlet weak var iconBackgroundView: NSVisualEffectView!
    @IBOutlet weak var image: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.stringValue = text
        iconBackgroundView.wantsLayer = true
        iconBackgroundView.layer?.cornerRadius = 12
        iconBackgroundView.layer?.cornerCurve = .continuous
    }
    
    func setState(isSeleted: Bool) {
        if isSelected {
            iconBackgroundView.layer?.borderWidth = 3
            iconBackgroundView.layer?.borderColor = NSColor.blue.cgColor
        } else {
            iconBackgroundView.layer?.borderWidth = 0
        }
    }
}
