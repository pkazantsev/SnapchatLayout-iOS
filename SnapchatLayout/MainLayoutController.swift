//
//  MainLayoutController.swift
//  SnapchatLayout
//
//  Created by Pavel Kazantsev on 3/2/17.
//  Copyright © 2017 PaKaz.net. All rights reserved.
//

import UIKit

class MainLayoutController: NSObject {

    weak var horizontalScrollView: UIScrollView! {
        didSet {
            horizontalScrollView.delegate = self
        }
    }
    weak var verticalScrollView: UIScrollView! {
        didSet {
            verticalScrollView.delegate = self
        }
    }

    fileprivate var screenWidth: CGFloat {
        return verticalScrollView.frame.width
    }
    fileprivate var screenHeight: CGFloat {
        return horizontalScrollView.frame.height
    }

    var horizontalScrollChanged: [(_ progress: CGFloat) -> Void] = []
    var verticalScrollChanged: [(_ progress: CGFloat) -> Void] = []

    var vPage: Int {
        get { return Int(verticalScrollView.contentOffset.y / screenHeight) }
        set {
            guard newValue >= 0 && newValue <= 2 else { return }
            verticalScrollView.contentOffset.y = screenHeight * CGFloat(newValue)
        }
    }
    var hPage: Int {
        get { return Int(horizontalScrollView.contentOffset.x / screenWidth) }
        set {
            guard newValue >= 0 && newValue <= 2 else { return }
            horizontalScrollView.contentOffset.x = screenWidth * CGFloat(newValue)
        }
    }

    fileprivate func vPageOffset() -> CGFloat {
        return verticalScrollView.contentOffset.y.truncatingRemainder(dividingBy: screenHeight)
    }

    fileprivate func hPageOffset() -> CGFloat {
        return horizontalScrollView.contentOffset.x.truncatingRemainder(dividingBy: screenWidth)
    }

}

extension MainLayoutController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == verticalScrollView {
            guard vPageOffset() > 0 else { return }

            let scrollProgress = vPageOffset() / screenHeight
            print("Vertical scroll progress: \(scrollProgress)")

            for listener in verticalScrollChanged {
                listener(scrollProgress)
            }
        }
        else if scrollView == horizontalScrollView {
            guard hPageOffset() > 0 else { return }

            let scrollProgress = hPageOffset() / screenWidth
            print("Horizontal scroll progress: \(scrollProgress)")

            for listener in horizontalScrollChanged {
                listener(scrollProgress)
            }
        }

    }
    
}
