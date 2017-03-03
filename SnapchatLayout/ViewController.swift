//
//  ViewController.swift
//  SnapchatLayout
//
//  Created by Pavel Kazantsev on 3/2/17.
//  Copyright © 2017 PaKaz.net. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var verticalScrollView: UIScrollView! {
        didSet {
            layoutController.verticalScrollView = verticalScrollView
        }
    }
    @IBOutlet weak var scrollUpLabel: UILabel!
    @IBOutlet weak var scrollUpLabelCenterY: NSLayoutConstraint!
    @IBOutlet weak var scrollDownLabel: UILabel!
    @IBOutlet weak var scrollDownLabelCenterY: NSLayoutConstraint!

    @IBOutlet weak var scrollLeftLabel: UILabel!
    @IBOutlet weak var scrollLeftLabelCenterX: NSLayoutConstraint!
    @IBOutlet weak var scrollRightLabel: UILabel!
    @IBOutlet weak var scrollRightLabelCenterX: NSLayoutConstraint!

    let layoutController = MainLayoutController()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedHorizontalScrollView" {
            let vc = segue.destination as! MiddleViewController
            vc.layoutController = layoutController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Scroll to middle view
        layoutController.vPage = 1
        layoutController.verticalScrollChanged.append({ [unowned self] progress in
            self.moveLabelsVertically(progress)
        })
        layoutController.horizontalScrollChanged.append({ [unowned self] progress in
            self.moveLabelsHorizontally(progress)
        })
    }

    private func moveLabelsVertically(_ scrollProgress: CGFloat) {
        if layoutController.vPage == 0 {
            let progress = 1 - scrollProgress
            scrollUpLabelCenterY.constant = view.frame.height / 2.0 * (progress / 2)
            scrollUpLabel.alpha = 0.3 + progress
            print("Scroll up progress: \(progress)")
        } else {
            let progress = scrollProgress / 2
            scrollDownLabelCenterY.constant = -view.frame.height / 2.0 * (progress / 2)
            scrollDownLabel.alpha = 0.3 + progress
            print("Scroll down progress: \(progress)")
        }
    }

    private func moveLabelsHorizontally(_ scrollProgress: CGFloat) {
        if layoutController.hPage == 0 {
            let progress = 1 - scrollProgress
            scrollLeftLabelCenterX.constant = view.frame.width / 2.0 * (progress / 2)
            scrollLeftLabel.alpha = 0.3 + progress
            print("Scroll left progress: \(progress)")
        } else {
            let progress = scrollProgress / 2
            scrollRightLabelCenterX.constant = -view.frame.width / 2.0 * (progress / 2)
            scrollRightLabel.alpha = 0.3 + progress
            print("Scroll right progress: \(progress)")
        }
    }
}

