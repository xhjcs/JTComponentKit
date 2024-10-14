//
//  Component.swift
//  JTComponentKit
//
//  Created by xinghanjie on 2024/10/14.
//

import Foundation

@objc
public class Component: NSObject {
    
    @objc public func registerViews() {
        
    }
    
    @objc public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
