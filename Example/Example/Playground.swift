//
//  Playground.swift
//  Example
//
//  Created by xinghanjie on 2024/10/14.
//

import Foundation
import UIKit
import JTComponentKit

class AComponent: JTComponent {
    override func inset() -> UIEdgeInsets {
        return .init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    override func numberOfItems() -> Int {
        return 100
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

@objc class JTViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.title = "Swift Example"
        let componentsAssemblyView = JTComponentsAssemblyView(frame: self.view.bounds)
        view.addSubview(componentsAssemblyView)
        componentsAssemblyView.assembleComponents([AComponent(), AComponent()])
    }
}
