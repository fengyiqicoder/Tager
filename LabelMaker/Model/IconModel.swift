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
        self.imageData = image.tiffRepresentation!
        self.colorData = color.data
    }
    var uuid: String
    var name: String
    var markerStr: String
    
    //NSImage -> Data
    var image: NSImage {
        get {
             NSImage(data: imageData)!
        }
        set {
            imageData = newValue.tiffRepresentation!
        }
    }
    private var imageData: Data
    
    //NSColor -> ColorData
    var color: NSColor {
        get {
            colorData.color
        }
        set {
            colorData = newValue.data
        }
    }
    private var colorData: ColorData
    
    static var defualt:IconModel {
        IconModel(uuid: UUID().uuidString,
                  name: "",
                  markerStr: "",
                  image: NSImage(named: "folderIcon")!,
                  color: NSColor.white)
        
    }
}

fileprivate
extension NSColor {
    var data: ColorData {
        let color = self.usingColorSpace(NSColorSpace.deviceRGB)!
        return ColorData(red: color.redComponent,
                         green: color.greenComponent,
                         blue: color.blueComponent,
                         alpaht: color.alphaComponent)
    }
}

fileprivate
struct ColorData: Codable {
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    var alpaht: CGFloat
    
    var color: NSColor {
        NSColor(calibratedRed: red, green: green, blue: blue, alpha: alpaht)
    }
}
