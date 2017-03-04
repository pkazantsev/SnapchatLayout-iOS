//
//  MainLayoutController.swift
//  SnapchatLayout
//
//  Created by Pavel Kazantsev on 3/2/17.
//  Copyright © 2017 PaKaz.net. All rights reserved.
//

import UIKit

enum ScrollingDirection {
    case vertical
    case horizontal
}



private let topColor = #colorLiteral(red: 0.63, green: 0.84, blue: 0.35, alpha: 1)
private let bottomColor = #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1)
private let leftColor = #colorLiteral(red: 1, green: 0.7161940546, blue: 0.6508789062, alpha: 1)
private let rightColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)

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

    func colorForNextSpace(direction: ScrollingDirection) -> UIColor {
        if direction == .vertical {
            if 0 == vPage {
                return topColor
            } else {
                return bottomColor
            }
        } else {
            if 0 == hPage {
                return leftColor
            } else {
                return rightColor
            }
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

            for listener in verticalScrollChanged {
                listener(vPage == 0 ? 1 - scrollProgress : scrollProgress)
            }
        }
        else if scrollView == horizontalScrollView {
            guard hPageOffset() > 0 else { return }

            let scrollProgress = hPageOffset() / screenWidth

            for listener in horizontalScrollChanged {
                listener(hPage == 0 ? 1 - scrollProgress : scrollProgress)
            }
        }

    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == horizontalScrollView {
            // Do not allow vertical scroll when it's not middle page in horizontal scroll.
            verticalScrollView.isScrollEnabled = (hPage == 1)
        }
    }
    
}
