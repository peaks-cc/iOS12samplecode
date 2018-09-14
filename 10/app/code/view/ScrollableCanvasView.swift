//
//  ScrollableCanvasView.swift
//
//  Created by ToKoRo on 2018-09-14.
//

import UIKit

class ScrollableCanvasView: CanvasView, UIFocusItemScrollableContainer {
    override func createRects() -> [Rect] {
        return (0..<30)
            .map { index in
                let color = UIColor(
                    red: 1 - CGFloat(index + 1) / 30,
                    green: 0.5,
                    blue: CGFloat(index + 1) / 30,
                    alpha: 1
                )
                return MoveRect(
                    x: 100 + 200 * CGFloat(index),
                    y: 100,
                    color: color.cgColor,
                    parent: self
                )
            }
    }

    override func draw(_ rect: CGRect) {
        if contentOffset != .zero, let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: -contentOffset.x, y: -contentOffset.y)
        }
        super.draw(rect)
    }

    var visibleSize: CGSize {
        return bounds.size
    }

    var contentSize: CGSize {
        let width = (rects.last?.frame.maxX ?? 0) + 100
        return CGSize(width: width, height: visibleSize.height)
    }

    var contentOffset: CGPoint = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
}
