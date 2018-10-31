//
//  Label.swift
//  DemoUI
//
//  Created by Yosuke Ishikawa on 2018/08/24.
//

@IBDesignable
final class Label: UILabel {
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        if let text = text {
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key(kCTLanguageAttributeName as String): "ja",
            ]
            
            attributedText = NSAttributedString(string: text, attributes: attributes)
        }
    }
}
