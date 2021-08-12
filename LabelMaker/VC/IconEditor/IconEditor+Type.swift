//
//  IconEditor+Type.swift
//  Tager
//
//  Created by Edmund Feng on 2021/8/12.
//

import AppKit

extension IconEditorViewController {
    
    func initSelectedType(item: ColorfulType) {
        let type = item.itemType.defualtColor
        typeItems.enumerated().forEach { (order, object) in
            if object.imageAssetName == type.imageAssetName {
                DispatchQueue.main.async {
                    self.typeCollectionView.select(order: order)
                }
            }
        }
    }
    
    func initSelcetTypeWithColor(item: ColorfulType) {
        typeItemsWithColor.enumerated().forEach { (order, object) in
            if object.imageAssetName == item.imageAssetName {
                DispatchQueue.main.async {
                    self.typeWithColorCollectionView.select(order: order)
                }
            }
        }
    }
    
    
    func configPostionIfNoAutosize(type: IconModel.ItemType) {
        guard assignLabelSize == nil else {
            guard let postionConfig = IconModel.ItemsPostionConfigDict[type] else { return }
            markerLabelCenterYConstraint.constant = postionConfig.markerCenterOffset
            symbolLabelTopConstraint.constant = postionConfig.symbolsCenterOffset
            view.layoutSubtreeIfNeeded()
            markerLabel.resizeText()
            return
        }
        configPostionWith(type: type)
    }
    
    func configPostionWith(type: IconModel.ItemType) {
        guard let postionConfig = IconModel.ItemsPostionConfigDict[type] else { return }
        markerLabelWidthConstraint.constant = postionConfig.markerWidth
        markerLabelCenterYConstraint.constant = postionConfig.markerCenterOffset
        symbolLabelTopConstraint.constant = postionConfig.symbolsCenterOffset
        view.layoutSubtreeIfNeeded()
        markerLabel.resizeText()
    }
    
    var typeItems: [ColorfulType] {
        IconModel.ItemTypes
    }
    var typeItemsWithColor: [ColorfulType] {
        guard let item = selectedTypeItem else { return [] }
        let colorTypes = IconModel.ItemsColorDict[item.itemType]!
        let currentTypeColorItem = colorTypes.map{
            ColorfulType(type: item.itemType, color: $0)
        }
        return currentTypeColorItem
    }
    
    func configTypeSelection() {
        typeCollectionView.isTypeItem = true
        typeWithColorCollectionView.isTypeItem = false
        
        typeCollectionView.config()
        typeCollectionView.delegate = self
        typeCollectionView.dataSource = self

        typeWithColorCollectionView.config()
        typeWithColorCollectionView.delegate = self
        typeWithColorCollectionView.dataSource = self
        
    }
    
}
