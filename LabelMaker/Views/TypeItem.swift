//
//  TypeItem.swift
//  Tager
//
//  Created by Edmund Feng on 2021/8/10.
//

import AppKit

class TypeItem: NSCollectionViewItem {
    
    @IBOutlet weak var itemImage: NSImageView!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
//                print("is select")
                itemImage.wantsLayer = true
                itemImage.layer?.borderWidth = 2
                itemImage.layer?.cornerCurve = .continuous
                itemImage.layer?.cornerRadius = 4
            } else {
//                print("unselect")
                itemImage.layer?.borderWidth = 0
            }
        }
    }
}

protocol TypeItemDelegate {
    
}
