//
//  ComponentAssemblyView.swift
//  Pods-Example
//
//  Created by xinghanjie on 2024/10/14.
//

import Foundation

@objc
public class ComponentAssemblyView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let collectionView: UICollectionView
    
    var components = [Component]()
    
    public override init(frame: CGRect) {
//        let layout = UICollectionViewFlowLayout()
//        collectionView = UICollectionView(frame: CGRect(origin: CGPoint.zero, size: frame.size), collectionViewLayout: layout)
        collectionView = UICollectionView()
        super.init(frame: frame)
        register(components: components)
        addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    
    @objc public func register(components: [Component]) {
        
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return components.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let component = components[section]
        return component.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let component = components[indexPath.section]
        return component.collectionView(collectionView, cellForItemAt: indexPath)
    }
}
