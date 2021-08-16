//
//  IconItemTyep.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/8/9.
//

import AppKit

extension IconModel {
    
    static let ItemTypes: [ItemTypeWithColor] = [
        ItemTypeWithColor(type: .folderIcon, color: .defualt),
        ItemTypeWithColor(type: .fileIcon, color: .defualt),
        ItemTypeWithColor(type: .pdfIcon, color: .defualt),
        ItemTypeWithColor(type: .trashIcon, color: .defualt),
        ItemTypeWithColor(type: .fullTrashIcon, color: .defualt),
//        ItemTypeWithColor(type: .zipFileIcon, color: .defualt),
        ItemTypeWithColor(type: .projectIcon, color: .defualt),
    ]
    static let ItemsColorDict: [ItemType: [ItemType.Color]] = [
        .folderIcon: [.defualt, .blue, .green, .mint, .orange, .pink, .purple],
        .fileIcon: [.defualt, .blue, .green, .mint, .orange, .pink, .purple],
        .pdfIcon: [.defualt, .blue, .green, .mint, .orange, .pink, .purple],
        .fullTrashIcon: [.defualt],
        .projectIcon: [.defualt],
        .trashIcon: [.defualt],
        .zipFileIcon: [.defualt],
    ]
    
    static let ItemsPostionConfigDict: [ItemType: ItemPosition] = [
        .folderIcon: ItemPosition(markerWidth: 180, markerCenterOffset: 0, symbolsCenterOffset: 40),
        .fileIcon: ItemPosition(markerWidth: 150, markerCenterOffset: -6, symbolsCenterOffset: 30),
        .pdfIcon: ItemPosition(markerWidth: 150, markerCenterOffset: -6, symbolsCenterOffset: 20),
        .fullTrashIcon: ItemPosition(markerWidth: 120, markerCenterOffset: 0, symbolsCenterOffset: 40),
        .projectIcon: ItemPosition(markerWidth: 150, markerCenterOffset: 35, symbolsCenterOffset: 20),
        .trashIcon: ItemPosition(markerWidth: 120, markerCenterOffset: 0, symbolsCenterOffset: 40),
        .zipFileIcon: ItemPosition(markerWidth: 180, markerCenterOffset: 0, symbolsCenterOffset: 40),
    ]
    
    struct ItemPosition {
        var markerWidth: CGFloat
        var markerCenterOffset: CGFloat
        var symbolsCenterOffset: CGFloat
    }
    
    struct ItemTypeWithColor: Hashable {
        
        static let defaultName: String = "folderIcon"
        static let defualt: ItemTypeWithColor = ItemTypeWithColor(name: defaultName)
        
        init(type: ItemType, color: ItemType.Color) {
            if color == .defualt {
                imageAssetName = type.rawValue
            } else {
                imageAssetName = type.rawValue + "-" + color.rawValue
            }
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
            case pink, orange, mint, red, purple, blue, green
        }
        
        var defualtColor: ItemTypeWithColor {
            ItemTypeWithColor(type: self, color: .defualt)
        }
        
        func with(color: ItemType.Color) -> ItemTypeWithColor {
            return ItemTypeWithColor(type: self, color: color)
        }
    }
}
