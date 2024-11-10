//
//  JTCComponent.swift
//  Example
//
//  Created by xinghanjie on 2024/11/7.
//

import Foundation
import JTComponentKit
import SnapKit

@objc class JTCComponentHeaderView: UIView {
    @objc var onTapHeader: ((Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        var lastView: UIView?
        for i in 0 ..< 3 {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = .black
            label.text = "\(i)"
            addSubview(label)
            label.snp.makeConstraints { make in
                if lastView == nil {
                    make.left.equalTo(self).offset(10)
                } else {
                    make.left.equalTo(lastView!.snp.right).offset(10)
                    make.width.equalTo(lastView!)
                }
                make.height.equalTo(self)
                make.centerY.equalTo(self)
            }
            lastView = label

            let tap = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
            label.addGestureRecognizer(tap)
            label.tag = i
            label.isUserInteractionEnabled = true
        }
        lastView?.snp.makeConstraints({ make in
            make.right.equalTo(self).offset(-10)
        })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func onTap(sender: UITapGestureRecognizer) {
        guard let view = sender.view else {
            return
        }
        onTapHeader?(view.tag)
    }
}

@objc class JTCComponent: JTComponent {
    
    @objc static func switchComponentEventName() -> String {
        return "kSwitchComponetEvent"
    }
    
    override func pinningBehaviorForHeader() -> JTComponentHeaderPinningBehavior {
        return .alwaysPin
    }

    override func headerSize() -> CGSize {
        return .init(width: 100, height: 44)
    }

    override func headerView() -> UIView {
        let header = dequeueReusableHeaderView(of: JTCComponentHeaderView.self) as! JTCComponentHeaderView
        header.onTapHeader = { [weak self] idx in
            self?.emit(JTCComponent.switchComponentEventName(), arg0: idx)
        }
        return header
    }
}
