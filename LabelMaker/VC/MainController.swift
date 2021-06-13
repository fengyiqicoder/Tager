//
//  ViewController.swift
//  LabelMaker
//
//  Created by Edmund Feng on 2021/6/13.
//

import Cocoa

class MainController: NSViewController {
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let flowLayout = NSCollectionViewGridLayout()
        flowLayout.minimumItemSize = NSSize(width: 160.0, height: 140.0)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.dataSource = self
    }
    
}

extension MainController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IconItem"), for: indexPath) as! IconItem
        item.label.stringValue = "testing"
        return item
    }
}

