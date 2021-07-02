//
//  ViewSnaper.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/7/2.
//

import AppKit

extension NSView {
    
    func image() -> NSImage {
        let imageRepresentation = bitmapImageRepForCachingDisplay(in: bounds)!
        cacheDisplay(in: bounds, to: imageRepresentation)
        return NSImage(cgImage: imageRepresentation.cgImage!, size: bounds.size)
    }

}


