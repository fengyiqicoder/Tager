//
//  IconModel.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/6/13.
//

import AppKit

struct IconModel: Codable {
    init(uuid: String, name: String, markerStr: String? = nil, symbolStr: String? = nil, image: NSImage, color: NSColor) {
        self.uuid = uuid
        self.name = name
        self.markerStr = markerStr
        self.symbolStr = symbolStr
        self.iconImage = IconImage(nsimage: image)
        self.colorData = color.data
    }
    var uuid: String
    var name: String
    
    //TYPE
    //nil is old version data do not have this
    private var typeName: String? = ItemTypeWithColor.defaultName
    var type: ItemTypeWithColor? {
        get {
            typeName == nil ? nil : ItemTypeWithColor(name: typeName!)
        }
        set {
            typeName = newValue?.imageAssetName
        }
    }
    
    
    //LABEL
    private(set) var markerStr: String? = nil
    private(set) var symbolStr: String? = nil
    
    //nil 是自动大小
    var assignLabelSize: CGFloat? = nil

    mutating func set(symbolStr: String) {
        markerStr = nil
        self.symbolStr = symbolStr
    }
    
    mutating func set(markerStr: String) {
        symbolStr = nil
        self.markerStr = markerStr
    }
    
    var markerIsSymbol: Bool { self.symbolStr != nil }
    //NSImage -> IconImage
    var image: NSImage {
        get {
            iconImage.nsimage
        }
        set {
            iconImage.nsimage = newValue
        }
    }
    private var iconImage: IconImage
    
    //NSColor -> ColorData
    var color: NSColor {
        get {
            try! NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: colorData)!
        }
        set {
            colorData = newValue.data
        }
    }
    private var colorData: Data
    
    static var defualt:IconModel {
        IconModel(uuid: UUID().uuidString,
                  name: "Default".localize,
                  markerStr: "",
                  image: NSImage(named: "folderIcon")!,
                  color: NSColor.white)
        
    }
    
    static var standardInitModels: [IconModel] {
        return [
            IconModel(uuid: UUID().uuidString, name: "Blue".localize, markerStr: "", image: NSImage(named: "folderIcon-blue")!, color: .white),
            IconModel(uuid: UUID().uuidString, name: "Red".localize, markerStr: "", image: NSImage(named: "folderIcon-red")!, color: .white),
            IconModel(uuid: UUID().uuidString, name: "Green".localize, markerStr: "", image: NSImage(named: "folderIcon-green")!, color: .white),
            IconModel(uuid: UUID().uuidString, name: "Mint".localize, markerStr: "", image: NSImage(named: "folderIcon-mint")!, color: .white),
            IconModel(uuid: UUID().uuidString, name: "Orange".localize, markerStr: "", image: NSImage(named: "folderIcon-orange")!, color: .white),
            IconModel(uuid: UUID().uuidString, name: "Pink".localize, markerStr: "", image: NSImage(named: "folderIcon-pink")!, color: .white),
            IconModel(uuid: UUID().uuidString, name: "Purple".localize, markerStr: "", image: NSImage(named: "folderIcon-purple")!, color: .white),
        ]
    }
}

private
extension NSColor {
    var deviceRGBColor: NSColor {
        usingColorSpace(NSColorSpace.deviceRGB)!
    }
}


private
extension NSColor {
    
    var data: Data {
        try! NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false) as Data
    }
    
}

