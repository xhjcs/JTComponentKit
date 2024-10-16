//
//  Component.swift
//  JTComponentKit
//
//  Created by xinghanjie on 2024/10/14.
//

import Foundation

@objc
open class Component: NSObject {
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

    private func dequeueReusableView(ofKind elementKind: String, withViewType viewType: UIView.Type, for indexPath: IndexPath) -> UIView {
        let reusableView = collectionView?.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: "\(viewType)", for: indexPath)
        guard let reusableView = reusableView as? ComponentReusableView else {
            return UIView()
        }
        if let renderView = reusableView.renderView {
            return renderView
        }
        let renderView = viewType.init(frame: .zero)
        reusableView.renderView = renderView
        return renderView
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

    // MARK: - Header

    @objc public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }

    @objc public func dequeueReusableHeader(withHeaderType headerType: UIView.Type, for indexPath: IndexPath) -> UIView {
        return dequeueReusableView(ofKind: UICollectionView.elementKindSectionHeader, withViewType: headerType, for: indexPath)
    }

    @objc public func collectionView(_ collectionView: UICollectionView, headerForSectionAt indexPath: IndexPath) -> UIView {
        return UIView()
    }

    // MARK: - Cell

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .zero
    }

    @objc public func dequeueReusableView(withItemViewType viewType: UIView.Type, for indexPath: IndexPath) -> UIView {
        let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: "\(viewType)", for: indexPath)
        guard let cell = cell as? ComponentCell else {
            return UIView()
        }
        if let renderView = cell.renderView {
            return renderView
        }
        let renderView = viewType.init(frame: .zero)
        cell.renderView = renderView
        return renderView
    }

    @objc public func collectionView(_ collectionView: UICollectionView, itemViewForItemAt indexPath: IndexPath) -> UIView {
        return UIView()
    }

    // MARK: - Footer

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }

    @objc public func dequeueReusableFooter(withFooterType footerType: UIView.Type, for indexPath: IndexPath) -> UIView {
        return dequeueReusableView(ofKind: UICollectionView.elementKindSectionFooter, withViewType: footerType, for: indexPath)
    }

    @objc public func collectionView(_ collectionView: UICollectionView, footerForSectionAt indexPath: IndexPath) -> UIView {
        return UIView()
    }
}
