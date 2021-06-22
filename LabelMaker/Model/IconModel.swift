//
//  IconModel.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/6/13.
//

import AppKit

struct IconModel: Codable {
    init(uuid: String, name: String, markerStr: String, image: NSImage) {
        self.uuid = uuid
        self.name = name
        self.markerStr = markerStr
        self.imageData = image.tiffRepresentation!
    }
    var uuid: String
    var name: String
    var markerStr: String
    
    var image: NSImage {
        get {
             NSImage(data: imageData)!
        }
        set {
            imageData = newValue.tiffRepresentation!
        }
    }
    private var imageData: Data
}
