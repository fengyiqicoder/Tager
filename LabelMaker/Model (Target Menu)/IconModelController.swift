//
//  IconModelController.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/6/20.
//

import Foundation

class IconModelController {
    static var shared = IconModelController()
    
    var iconModels: [IconModel] {
        set {
            guard let newData = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.appGroup.setValue(newData, forKey: "model")
        }
        get {
            let oldData = UserDefaults.appGroup.object(forKey: "model") as? Data ?? Data()
            guard let oldModels = try? JSONDecoder().decode([IconModel].self, from: oldData) else { return [] }
            return oldModels
        }
    }
    
    func save(model: IconModel) {
        let order = iconModels.firstIndex { $0.uuid == model.uuid }
        guard let order = order, order < iconModels.count else {
            iconModels.append(model)
            return
        }
        iconModels.remove(at: order)
        iconModels.insert(model, at: order)
    }
    
    func delete(model: IconModel) {
        
    }
}
