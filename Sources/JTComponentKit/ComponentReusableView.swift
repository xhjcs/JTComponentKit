//
//  ComponentReuseView.swift
//  JTComponentKit
//
//  Created by xinghanjie on 2024/10/14.
//

import Foundation

class ComponentReusableView: UICollectionReusableView {
    var renderView: UIView? {
        didSet {
            if let renderView = renderView {
                addSubview(renderView)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        renderView?.frame = bounds
    }
}
