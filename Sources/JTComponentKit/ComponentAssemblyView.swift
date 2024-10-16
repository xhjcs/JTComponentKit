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

    override public init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect(origin: CGPoint.zero, size: frame.size), collectionViewLayout: layout)
        super.init(frame: frame)
        register(components: components)
        addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }

    @objc public func register(components: [Component]) {
        self.components = components
        components.forEach { component in
            component.collectionView = self.collectionView
            let header = component.registerHeader()
            self.collectionView.register(header, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(header)")
            component.registerItemViews().forEach { itemType in
                self.collectionView.register(itemType, forCellWithReuseIdentifier: "\(itemType)")
            }
            let footer = component.registerFooter()
            self.collectionView.register(footer, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "\(footer)")
        }
        collectionView.reloadData()
    }

    private func findCell(fromRenderView renderView: UIView) -> ComponentCell {
        var currentView = renderView.superview
        while let view = currentView {
            if let componentCell = view as? ComponentCell {
                return componentCell
            }
            currentView = view.superview
        }
        return ComponentCell()
    }

    // MARK: - section

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return components.count
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let component = components[section]
        return component.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: section)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let component = components[section]
        return component.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let component = components[section]
        return component.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section)
    }

    // MARK: - Header & Footer

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let component = components[section]
        return component.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let component = components[section]
        return component.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForFooterInSection: section)
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let component = components[indexPath.section]
        let renderView = kind == UICollectionView.elementKindSectionHeader ?
            component.collectionView(collectionView, headerForSectionAt: indexPath) :
            component.collectionView(collectionView, footerForSectionAt: indexPath)
        guard let reusableView = renderView.superview as? ComponentReusableView else {
            return UICollectionReusableView()
        }
        return reusableView
    }

    // MARK: - Cell

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let component = components[section]
        component.section = section
        return component.collectionView(collectionView, numberOfItemsInSection: section)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let component = components[indexPath.section]
        return component.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let component = components[indexPath.section]
        let renderView = component.collectionView(collectionView, itemViewForItemAt: indexPath)
        return findCell(fromRenderView: renderView)
    }
}
