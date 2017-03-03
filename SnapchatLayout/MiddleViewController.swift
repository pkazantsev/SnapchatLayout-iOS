//
//  MiddleViewController.swift
//  SnapchatLayout
//
//  Created by Pavel Kazantsev on 3/2/17.
//  Copyright © 2017 PaKaz.net. All rights reserved.
//

import UIKit

class MiddleViewController: UIViewController {

    @IBOutlet weak var horizontalScrollView: UIScrollView! {
        didSet {
            if layoutController != nil {
                layoutController?.horizontalScrollView = horizontalScrollView
            }
        }
    }

    weak var layoutController: MainLayoutController! {
        didSet {
            if horizontalScrollView != nil {
                layoutController?.horizontalScrollView = horizontalScrollView
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Scroll to center view
        layoutController.hPage = 1
    }

}
