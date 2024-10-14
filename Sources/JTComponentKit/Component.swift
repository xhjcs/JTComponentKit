//
//  Component.swift
//  JTComponentKit
//
//  Created by xinghanjie on 2024/10/14.
//

import Foundation

@objc
public class Component: NSObject {
    var collectionView: UICollectionView?

    var section: Int?

    @objc public func registerHeader() -> UIView.Type {
        return UIView.self
    }
    
    @objc public func registerItemViews() -> [UIView.Type] {
        return [UIView.Type]()
    }
    
    @objc public func registerFooter() -> UIView.Type {
        return UIView.self
    }

    @objc public func reload() {
        if let section = section {
            collectionView?.reloadSections(IndexSet(integer: section))
        }
    }

    // MARK: - section
    @objc public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    @objc public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    @objc public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let renderView = kind == UICollectionView.elementKindSectionHeader ?
            self.collectionView(collectionView, headerForSectionAt: indexPath.section)
            : self.collectionView(collectionView, footerForSectionAt: indexPath.section)
        if let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(renderView.self)", for: indexPath) as? ComponentReusableView {
            if supplementaryView.renderView == nil {
                supplementaryView.renderView = renderView
            }
        }
        return UICollectionReusableView()
    }

    // MARK: - Header

    @objc public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }

    @objc public func collectionView(_ collectionView: UICollectionView, headerForSectionAt section: Int) -> UIView {
        return UIView()
    }

    // MARK: - Cell

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .zero
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let renderView = self.collectionView(collectionView, itemViewForItemAt: indexPath)
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(renderView.self)", for: indexPath) as? ComponentCell {
            if cell.renderView == nil {
                cell.renderView = renderView
            }
            return cell
        }
        return UICollectionViewCell()
    }

    @objc public func collectionView(_ collectionView: UICollectionView, itemViewForItemAt indexPath: IndexPath) -> UIView {
        return UIView()
    }

    // MARK: - Footer

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }

    @objc public func collectionView(_ collectionView: UICollectionView, footerForSectionAt section: Int) -> UIView {
        return UIView()
    }
}
