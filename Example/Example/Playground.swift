//
//  Playground.swift
//  Example
//
//  Created by xinghanjie on 2024/10/14.
//

import Foundation
import UIKit
import JTComponentKit
import SnapKit

class AComponent: JTComponent {
    override func inset() -> UIEdgeInsets {
        return .init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    override func numberOfItems() -> Int {
        return 10
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return .init(width: 60, height: 60)
    }
    
    override func itemView(for index: Int) -> UIView {
        let item = dequeueReusableItemView(of: UIView.self, for: index)
        item.backgroundColor = .yellow
        return item
    }
}

@objcMembers class ExampleComponent1: JTComponent {
    override func componentDidMount() {
        super.componentDidMount()
        on(JTCComponent.switchComponentEventName()) { [weak self] args in
            guard let self = self, let idx = args.arg0 as? Int, idx == 0 else {
                return
            }
            self.scroll(toSelf: true)
        }
    }
    
    override func pinningBehaviorForHeader() -> JTComponentHeaderPinningBehavior {
        return .none
    }
    
    override func inset() -> UIEdgeInsets {
        return .init(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    override func headerSize() -> CGSize {
        return .init(width: 30, height: 30)
    }
    
    override func headerView() -> UIView {
        let header = dequeueReusableHeaderView(of: UIView.self)
        header.backgroundColor = .green
        return header
    }
    
    override func footerSize() -> CGSize {
        return .init(width: 30, height: 30)
    }
    
    override func footerView() -> UIView {
        let footer = dequeueReusableFooterView(of: UIView.self)
        footer.backgroundColor = .blue
        return footer
    }
    
    override func numberOfItems() -> Int {
        return 10
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return .init(width: 60, height: 60)
    }
    
    override func itemView(for index: Int) -> UIView {
        let item = dequeueReusableItemView(of: UIView.self, for: index)
        item.backgroundColor = .black
        return item
    }
}

class ExampleComponent2: JTComponent {
    override func componentDidMount() {
        super.componentDidMount()
        on(JTCComponent.switchComponentEventName()) { [weak self] args in
            guard let self = self, let idx = args.arg0 as? Int, idx == 1 else {
                return
            }
            self.scroll(toSelf: true)
        }
    }
    
    override func pinningBehaviorForHeader() -> JTComponentHeaderPinningBehavior {
        return .alwaysPin
    }
    
    override func inset() -> UIEdgeInsets {
        return .init(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    override func headerSize() -> CGSize {
        return .init(width: 30, height: 30)
    }
    
    override func headerView() -> UIView {
        let header = dequeueReusableHeaderView(of: UIView.self)
        header.backgroundColor = .blue
        return header
    }
    
    override func footerSize() -> CGSize {
        return .init(width: 30, height: 30)
    }
    
    override func footerView() -> UIView {
        let footer = dequeueReusableFooterView(of: UIView.self)
        footer.backgroundColor = .red
        return footer
    }
    
    override func numberOfItems() -> Int {
        return 20
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return .init(width: size.width - inset().left - inset().right, height: 60)
    }
    
    override func itemView(for index: Int) -> UIView {
        let item = dequeueReusableItemView(of: UIView.self, for: index)
        item.backgroundColor = .green
        return item
    }
    
    override func insetForBackgroundView() -> UIEdgeInsets {
        return .init(top: 36, left: 10, bottom: 36, right: 10)
    }
    
    override func backgroundView() -> UIView {
        let backgroundView = dequeueReusableBackgroundView(of: UIView.self)
        backgroundView.backgroundColor = .lightGray
        backgroundView.layer.cornerRadius = 8
        return backgroundView
    }
}

class ExampleComponent3: JTComponent {
    override func componentDidMount() {
        super.componentDidMount()
        on(JTCComponent.switchComponentEventName()) { [weak self] args in
            guard let self = self, let idx = args.arg0 as? Int, idx == 2 else {
                return
            }
            self.scroll(toSelf: false)
        }
    }
    
    override func inset() -> UIEdgeInsets {
        return .init(top: 25, left: 25, bottom: 25, right: 25)
    }
    
    override func pinningBehaviorForHeader() -> JTComponentHeaderPinningBehavior {
        return .pin
    }
    
    override func headerSize() -> CGSize {
        return .init(width: 30, height: 30)
    }
    
    override func headerView() -> UIView {
        let header = dequeueReusableHeaderView(of: UIView.self)
        header.backgroundColor = .red
        return header
    }
    
    override func footerSize() -> CGSize {
        return .init(width: 30, height: 30)
    }
    
    override func footerView() -> UIView {
        let footer = dequeueReusableFooterView(of: UIView.self)
        footer.backgroundColor = .green
        return footer
    }
    
    override func numberOfItems() -> Int {
        return 10
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return .init(width: (size.width - inset().left - inset().right) / 2 - 10, height: 60)
    }
    
    override func itemView(for index: Int) -> UIView {
        let item = dequeueReusableItemView(of: UIView.self, for: index)
        item.backgroundColor = .blue
        return item
    }
}

@objc class JTViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Swift Example"
        let componentsAssemblyView = JTComponentsAssemblyView()
        view.addSubview(componentsAssemblyView)
        componentsAssemblyView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }
        componentsAssemblyView.assembleComponents([JTSpacingComponent(spacing: 100), AComponent(), JTCComponent(), ExampleComponent1(), JTSpacingComponent(spacing: 25), ExampleComponent2(), JTSpacingComponent(spacing: 50), ExampleComponent3(), JTBComponent()])
//        componentsAssemblyView.scrollDirection = .horizontal
    }
}
