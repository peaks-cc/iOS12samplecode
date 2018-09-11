//
//  ViewController.swift
//
//  Created by ToKoRo on 2018-08-29.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var idTextField: UITextField?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        idTextField?.becomeFirstResponder()
    }
}
