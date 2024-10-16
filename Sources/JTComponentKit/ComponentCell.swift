//
//  ComponentCell.swift
//  JTComponentKit
//
//  Created by xinghanjie on 2024/10/14.
//

import Foundation

class ComponentCell: UICollectionViewCell {
    var renderView: UIView? {
        didSet {
            if let renderView = renderView {
                contentView.addSubview(renderView)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        renderView?.frame = contentView.bounds
    }
}
