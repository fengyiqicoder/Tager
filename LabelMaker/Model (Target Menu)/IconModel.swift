//
//  IconModel.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/6/13.
//

import AppKit

struct IconModel: Codable {
    init(uuid: String, name: String, markerStr: String, image: NSImage, color: NSColor) {
        self.uuid = uuid
        self.name = name
        self.markerStr = markerStr
        self.iconImage = IconImage(nsimage: image)
        self.colorData = color.data
    }
    var uuid: String
    var name: String
    var markerStr: String
    
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
                  name: "",
                  markerStr: "",
                  image: NSImage(named: "folderIcon")!,
                  color: NSColor.white)
        
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
