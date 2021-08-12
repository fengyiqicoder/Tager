//
//  IconEditor+Labels.swift
//  Tager
//
//  Created by Edmund Feng on 2021/8/12.
//

import AppKit

enum EditingSchema {
    case label
    case color
    case type
    case custom
}

extension IconEditorViewController: TextFieldDelegate {
    func textFieldDidChange(textField: NSTextField) {
        //Meaning textField is marker
        if textField.tag == 1 {
            setMarker(string: model.markerStr ?? "nil")
        }
        save()
    }
    
    func save() {
        IconModelController.shared.save(model: model)
        view.window?.title = model.name
        MainController.shared.reload()
    }
}

extension IconEditorViewController: SymbolItemDelegate {
    func didSelect(item: SymbolItem) {
        setSymbol(name: item.symbol)
        popoverVC?.dismissPopover()
        save()
    }
}
