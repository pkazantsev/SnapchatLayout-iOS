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

    var overlay: UIView?

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
            self.animateOverlay(progress, direction: .vertical)
        })
        layoutController.horizontalScrollChanged.append({ [unowned self] progress in
            self.moveLabelsHorizontally(progress)
            self.animateOverlay(progress, direction: .horizontal)
        })
    }

    private func moveLabelsVertically(_ scrollProgress: CGFloat) {
        if layoutController.vPage == 0 {
            let progress = scrollProgress / 2
            scrollUpLabelCenterY.constant = view.frame.height * progress / 2.0
            scrollUpLabel.alpha = 0.3 + progress
        } else {
            let progress = scrollProgress / 2
            scrollDownLabelCenterY.constant = -view.frame.height * progress / 2.0
            scrollDownLabel.alpha = 0.3 + progress
        }
    }

    private func moveLabelsHorizontally(_ scrollProgress: CGFloat) {
        if layoutController.hPage == 0 {
            let progress = scrollProgress / 2
            scrollLeftLabelCenterX.constant = view.frame.width * progress / 2.0
            scrollLeftLabel.alpha = 0.3 + progress
        } else {
            let progress = scrollProgress / 2
            scrollRightLabelCenterX.constant = -view.frame.width * progress / 2.0
            scrollRightLabel.alpha = 0.3 + progress
        }
    }

    private func animateOverlay(_ scrollProgress: CGFloat, direction: ScrollingDirection) {
        addOverlayIfNeeded()
        guard let overlay = self.overlay else { return }

        if overlay.backgroundColor == nil {
            overlay.backgroundColor = layoutController.colorForNextSpace(direction: direction)
        }

        overlay.alpha = scrollProgress

        if scrollProgress < 0.01 {
            overlay.backgroundColor = nil
        }
    }

    private func addOverlayIfNeeded() {
        guard self.overlay == nil else { return }

        let overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(overlay, at: 1)

        overlay.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        overlay.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        overlay.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        self.overlay = overlay
    }
}

