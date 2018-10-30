import UIKit
import PlaygroundSupport

let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
view.backgroundColor = UIColor.white
PlaygroundPage.current.liveView = view
let label = UILabel(frame: CGRect(x: 30, y: 30, width: 30, height: 30))
label.text = "Enjoy iOS 12!"
view.addSubview(label)
label.sizeToFit()

