//
//  IconImage.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/6/24.
//

import AppKit

class IconImage: Codable {
    init(nsimage: NSImage) {
        uuid = UUID().uuidString
        self.nsimage = nsimage
    }
    
    private let uuid: String
    
    private var imageURL: URL {
//        var url = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        var url = FileManager().containerURL(forSecurityApplicationGroupIdentifier: appGroupSuitName)!
        url.appendPathComponent(self.uuid)
        return url
    }
    
    var nsimage: NSImage {
        set {
            let imageData = newValue.tiffRepresentation ?? Data()
            try? imageData.write(to: imageURL)
        }
        get {
            guard let imageData = try? Data(contentsOf: imageURL) else { return NSImage() }
            return NSImage(data: imageData) ?? NSImage()
        }
    }
}
