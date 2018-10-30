//
//  AccessibilitySampleViewController.swift
//
//  Created by ToKoRo on 2018-09-15.
//

import UIKit

class AccessibilitySampleViewController: UIViewController {
    @IBOutlet weak var canvasView: CanvasView?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let rects = canvasView?.rects {
            for index in rects.indices {
                let rect = rects[index]
                rect.accessibilityLabel = "\(index + 1)番目の四角形"
            }
        }
    }
}
