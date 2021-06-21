//
//  IconModel.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/6/13.
//

import AppKit

struct IconModel: Codable {
    
    var uuid: String
    var name: String
    var image: IconImage
    var markerStr: String
}


private let docuURL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!

//ImagePool

struct IconImage: Codable {
    private var uuid: String
    
    var image: NSImage {
        get {
            let data = try! Data(contentsOf: docuURL.appendingPathComponent(uuid))
            return NSImage(data: data)!
        }
    }
    
    init(image: NSImage) {
        //FIXME: Change NSImage to data , write data to file
        uuid = UUID().uuidString
        
    }
    
}
