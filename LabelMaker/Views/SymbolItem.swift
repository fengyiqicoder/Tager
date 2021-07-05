//
//  SymbolItem.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/7/5.
//

import AppKit

class SymbolItem: NSCollectionViewItem {

    @IBOutlet weak var symbolView: NSView!
    @IBOutlet weak var symbolImageView: NSImageView!
    @IBOutlet weak var symbolNameLabel: NSTextField!
    
    weak var delegate: SymbolItemDelegate!
    var symbol: String {
        set {
            let symbolSize: CGFloat = 32
            symbolNameLabel.stringValue = newValue
            symbolImageView.image = NSImage(systemSymbolName: newValue, accessibilityDescription: nil)?.withSymbolConfiguration(NSImage.SymbolConfiguration(pointSize: symbolSize, weight: .regular))
            
        }
        get {
            symbolNameLabel.stringValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.masksToBounds = false
        
        symbolView.layer?.cornerRadius = 12
        symbolView.layer?.borderWidth = 1
        symbolView.layer?.borderColor = NSColor.systemGray.cgColor
        symbolView.layer?.cornerCurve = .continuous
        
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                delegate.didSelect(item: self)
            }
        }
    }
}

protocol SymbolItemDelegate: AnyObject {
    func didSelect(item: SymbolItem)
}
