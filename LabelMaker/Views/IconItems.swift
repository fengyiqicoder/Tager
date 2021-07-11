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
    weak var delegate: IconItemDelegate!
    var text: String = ""
    
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

    override func rightMouseDown(with event: NSEvent) {
        let menu = NSMenu()
         
        menu.addItem(withTitle: "Delete".localize, action: #selector(deleteItem), keyEquivalent: "")
        menu.addItem(withTitle: "Top".localize, action: #selector(topItem), keyEquivalent: "")

        NSMenu.popUpContextMenu(menu, with: event, for: self.view)
    }
    
    @objc
    func deleteItem(sender: NSMenu) {
        delegate.didDelete(item: self)
    }
    
    @objc
    func topItem(sender: NSMenu) {
        delegate.didTop(item: self)
    }
    
    func setState(isSeleted: Bool) {
        if isSelected {
            backgroundBox.borderWidth = 3
            backgroundBox.borderColor = NSColor.darkGray
        } else {
            backgroundBox.borderWidth = 0
        }
    }
}

protocol IconItemDelegate: AnyObject {
    func didDelete(item: IconItem)
    func didTop(item: IconItem)
}
