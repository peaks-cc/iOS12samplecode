//
//  Button.swift
//  DemoUI
//
//  Created by Yosuke Ishikawa on 2018/08/24.
//

@IBDesignable
final class Button: UIButton {
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        if let title = title(for: state) {
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key(kCTLanguageAttributeName as String): "ja",
            ]
            
            let attributedTitle = NSAttributedString(string: title, attributes: attributes)
            setAttributedTitle(attributedTitle, for: state)
        }
    }
}
