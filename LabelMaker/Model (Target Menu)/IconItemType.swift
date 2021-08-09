//
//  IconItemTyep.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/8/9.
//

import AppKit

extension IconModel {
    
    struct ItemTypeWithColor {
        
        static let defaultName: String = "folderIcon"
        
        init(type: ItemType, color: ItemType.Color) {
            imageAssetName = type.rawValue + color.rawValue
        }
        
        init(name: String) {
            self.imageAssetName = name
        }
        
        private(set) var imageAssetName: String
        private var colorStr: String? {
            let names = imageAssetName.split(separator: "-")
            return names.count == 2 ? String(names[1]) : nil
        }
        private var typeStr: String {
            String(imageAssetName.split(separator: "-").first!)
        }
        
        
        var image: NSImage? {
            NSImage(named: imageAssetName)
        }
        
        var itemType: ItemType {
            set {
                imageAssetName = newValue.rawValue
            }
            get {
                ItemType(rawValue: typeStr)!
            }
        }
        
        var itemColor: ItemType.Color {
            set {
                if newValue == .defualt {
                    imageAssetName = typeStr
                } else {
                    imageAssetName = typeStr + "-" + newValue.rawValue
                }
            }
            get {
                if let colorStr = colorStr {
                    return ItemType.Color(rawValue: colorStr)!
                } else {
                    return .defualt
                }
            }
        }
        
    }
    
    enum ItemType: String {
        //folder
        case folderIcon, fileIcon, pdfIcon //有颜色的
        case fullTrashIcon, projectIcon, trashIcon, zipFileIcon
        
        static let defualt = ItemType.folderIcon
        
        
        enum Color: String {
            case defualt
            case pink, oringe, mint, red, purple, blue, green
        }
    }
}
