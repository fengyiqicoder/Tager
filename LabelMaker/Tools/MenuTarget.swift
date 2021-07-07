//
//  MenuTarget.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/7/7.
//

import AppKit

private class Target<Sender> {
    private let closure: (Sender) -> Void
    
    init(closure: @escaping (Sender) -> Void) {
        self.closure = closure
    }
    
    @objc func action(sender: Any) {
        closure(sender as! Sender)
    }
}


extension NSButton {
    func addTarget(closure: @escaping (Self) -> Void) {
        let target = Target<Self>(closure: closure)
        action = #selector(Target<Self>.action(sender:))
        self.target = target
        objc_setAssociatedObject(self, unsafeBitCast(target, to: UnsafeRawPointer.self), target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func addTarget(closure: @escaping () -> Void) {
        addTarget { _ in closure() }
    }
}

