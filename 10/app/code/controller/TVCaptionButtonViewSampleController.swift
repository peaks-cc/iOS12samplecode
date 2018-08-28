//
//  TVCaptionButtonViewSampleController.swift
//
//  Created by ToKoRo on 2018-08-25.
//

import UIKit
import TVUIKit

class TVCaptionButtonViewSampleController: UIViewController {
    @IBOutlet weak var stackView: UIStackView?
    @IBOutlet weak var optionButton: UIButton?

    private lazy var samples: [ButtonObject] = SampleButtonObjects.shared.samples
    private var captionButtons: [TVCaptionButtonView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupOptionButtonFocusGuide()
        addSamples()
    }

    private func setupOptionButtonFocusGuide() {
        guard let stackView = stackView, let optionButton = optionButton else {
            return
        }

        let guide = UIFocusGuide()
        view.addLayoutGuide(guide)

        guide.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
        guide.topAnchor.constraint(equalTo: optionButton.topAnchor).isActive = true
        guide.heightAnchor.constraint(equalTo: optionButton.heightAnchor).isActive = true
        guide.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        guide.preferredFocusEnvironments = [optionButton]
    }

    private func addSamples() {
        for index in samples.indices {
            let buttonObject = samples[index]
            addCaptionButton(with: buttonObject, at: index)
        }
    }

    private func addCaptionButton(with buttonObject: ButtonObject, at index: Int) {
        let captionButton = TVCaptionButtonView()
        captionButton.tag = index

        switch buttonObject.content {
        case .text(let text):
            captionButton.contentText = text
        case .image(let imageName):
            captionButton.contentImage = UIImage(named: imageName)
        }

        captionButton.title = buttonObject.title
        captionButton.subtitle = buttonObject.subtitle

        captionButton.addTarget(self, action: #selector(self.captionButtonDidTouch(captionButton:)), for: .primaryActionTriggered)

        stackView?.addArrangedSubview(captionButton)

        captionButtons.append(captionButton)
    }

    private func changeMotionDirection(_ motionDirection: TVCaptionButtonViewMotionDirection) {
        for captionButton in captionButtons {
            captionButton.motionDirection = motionDirection
        }
    }

    @IBAction func captionButtonDidTouch(captionButton: TVCaptionButtonView) {
        print("captionButtonDidTouch: \(captionButton.tag)")
    }

    @IBAction func optionMenuAction(sender: AnyObject) {
        let alert = UIAlertController(title: "motionDirection", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "all", style: .default) { [weak self] _ in
            self?.changeMotionDirection(.all)
        })
        alert.addAction(UIAlertAction(title: "horizontal", style: .default) { [weak self] _ in
            self?.changeMotionDirection(.horizontal)
        })
        alert.addAction(UIAlertAction(title: "none", style: .default) { [weak self] _ in
            self?.changeMotionDirection(.none)
        })
        alert.addAction(UIAlertAction(title: "vertical", style: .default) { [weak self] _ in
            self?.changeMotionDirection(.vertical)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}
