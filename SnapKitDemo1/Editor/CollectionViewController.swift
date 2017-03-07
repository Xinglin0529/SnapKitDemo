//
//  CollectionViewController.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/13.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    fileprivate var collectionView: UICollectionView = {
        let flow = EditorFlowLayout()
        flow.minimumLineSpacing = 10
        flow.minimumInteritemSpacing = 10
        flow.itemSize = CGSize(width: 100, height: 100)
        let collection = UICollectionView.init(frame: .zero, collectionViewLayout: flow)
        collection.backgroundColor = .white
        return collection
    }()
    
    fileprivate var dataList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        for i in 0...20 {
            dataList.append("Item\(i)")
        }

        self.view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EditorCollectionViewCell.self, forCellWithReuseIdentifier: "EditorCollectionViewCell")
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        addLongGestureRecognize()
    }
}


// MARK: - UILongGestureRecognize
extension CollectionViewController {
    fileprivate func addLongGestureRecognize() {
        let longGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(CollectionViewController.longGestureAction(sender:)))
        collectionView.addGestureRecognizer(longGesture)
    }
    
    @objc private func longGestureAction(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let indexPath = collectionView.indexPathForItem(at: sender.location(in: collectionView))
            if indexPath == nil {
                return
            }
            collectionView.beginInteractiveMovementForItem(at: indexPath!)
        } else if sender.state == .changed {
            collectionView.updateInteractiveMovementTargetPosition(sender.location(in: collectionView))
        } else if sender.state == .cancelled {
            collectionView.cancelInteractiveMovement()
        } else if sender.state == .ended {
            collectionView.endInteractiveMovement()
        }
    }
    
}


// MARK: - UICollectionViewDelegate
extension CollectionViewController: UICollectionViewDelegate {
    
}


// MARK: - UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditorCollectionViewCell", for: indexPath) as! EditorCollectionViewCell
        cell.text = dataList[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = dataList[sourceIndexPath.item]
        dataList.remove(at: sourceIndexPath.item)
        dataList.insert(item, at: destinationIndexPath.item)
    }
}

