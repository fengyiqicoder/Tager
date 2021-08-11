//
//  TypeItem.swift
//  Tager
//
//  Created by Edmund Feng on 2021/8/10.
//

import AppKit

class TypeItem: NSCollectionViewItem {
    
    @IBOutlet weak var itemImage: NSImageView!
    @IBOutlet weak var borderView: NSBox!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                borderView.wantsLayer = true
                borderView.layer?.borderWidth = 1
                borderView.layer?.borderColor = #colorLiteral(red: 0.4434176981, green: 0.8099910617, blue: 0.9819725156, alpha: 1).cgColor
                borderView.layer?.cornerCurve = .continuous
                borderView.layer?.cornerRadius = 4
            } else {
                borderView.layer?.borderWidth = 0
            }
        }
    }
    
    override func prepareForReuse() {
        itemImage.image = nil
        borderView.layer?.borderWidth = 0
    }
}

protocol TypeItemDelegate {
    
}
