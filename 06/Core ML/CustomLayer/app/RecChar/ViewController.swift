//
//  ViewController.swift
//  hogee
//
//  Created by sonson on 2017/07/26.
//  Copyright © 2017年 sonson. All rights reserved.
//

import UIKit
import CoreML

var time1: timeval = timeval(tv_sec: 0, tv_usec: 0)

func tic() {
    gettimeofday(&time1, nil)
}

func toc(_ message: String? = nil) {
    var time2: timeval = timeval(tv_sec: 0, tv_usec: 0)
    gettimeofday(&time2, nil)
    let diff = (Double(time2.tv_sec) * Double(1000) + Double(time2.tv_usec) / Double(1000)) - (Double(time1.tv_sec) * Double(1000) + Double(time1.tv_usec) / Double(1000))
    
    if let message = message {
        print("\(message) \(diff)[msec]")
    } else {
        print("\(diff)[msec]")
    }
}

extension MLMultiArray {
    var maxIndex: Int {
        var max: Double = 0
        var index = -1
        for j in 0..<self.count {
            let x = self[[NSNumber(value: j)]]
            if max < x.doubleValue {
                max = x.doubleValue
                index = j
            }
        }
        return index
    }
    
    func imageAsString(width: Int, height: Int) -> String {
        var buffer = ""
        for x in 0..<width {
            for y in 0..<height {
                let xx = NSNumber(value: x)
                let yy = NSNumber(value: y)
                buffer = buffer.appendingFormat("%02x", Int(self[[0, xx, yy]].doubleValue*255))
            }
            buffer = buffer.appendingFormat("\n")
        }
        return buffer
    }
}

class ViewController: UIViewController {
    let model = KerasMNIST_customlayer()
    
    static let width: Int = 28
    static let height: Int = 28
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textLabel: UILabel!
    
    var pixelBuffer32bit: [CUnsignedChar] = [CUnsignedChar](repeating: 0, count: ViewController.width * ViewController.height * 4)
    
    private func creatCGImage(pointer: UnsafeMutableRawPointer?, width: Int, height: Int, bytesPerRow: Int) -> CGImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
            .union(CGBitmapInfo.byteOrder32Little)
        guard let context = CGContext(data: pointer, width: (width), height: (height), bitsPerComponent: 8, bytesPerRow: (bytesPerRow), space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else { return nil }
        return context.makeImage()
    }
    
    func updateImage() {
        guard let cgImage = creatCGImage(pointer: &pixelBuffer32bit, width: ViewController.width, height: ViewController.height, bytesPerRow: 4 * ViewController.width) else { return }
        imageView.image = UIImage(cgImage: cgImage)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for x in 0..<ViewController.width {
            for y in 0..<ViewController.height {
                pixelBuffer32bit[4 * y + 4 * x * ViewController.width + 0] = 255
                pixelBuffer32bit[4 * y + 4 * x * ViewController.width + 1] = 0
                pixelBuffer32bit[4 * y + 4 * x * ViewController.width + 2] = 0
                pixelBuffer32bit[4 * y + 4 * x * ViewController.width + 3] = 0
            }
        }
        updateImage()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self.view)
        if imageView.frame.contains(location) {
            let locationInImageView = imageView.convert(location, from: self.view)
            
            let x = locationInImageView.x / imageView.frame.size.width
            let y = locationInImageView.y / imageView.frame.size.height
            
            let ix = Int(x * CGFloat(ViewController.width))
            let iy = Int(y * CGFloat(ViewController.height))
            
            let w = 1
            let l = ix - 0 > 0 ? ix - w : 0
            let r = ix + 0 < ViewController.width ? ix + 1 : ViewController.width - 1
            let t = iy - 0 > 0 ? iy - w : 0
            let b = iy + 0 < ViewController.height ? iy + 1 : ViewController.height - 1
            
            for xx in l..<r {
                for yy in t..<b {
                    pixelBuffer32bit[4 * xx + 4 * yy * ViewController.width + 0] = 255
                    pixelBuffer32bit[4 * xx + 4 * yy * ViewController.width + 1] = 255
                    pixelBuffer32bit[4 * xx + 4 * yy * ViewController.width + 2] = 255
                    pixelBuffer32bit[4 * xx + 4 * yy * ViewController.width + 3] = 255
                }
            }
            updateImage()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        do {
            let input = try MLMultiArray(shape: [1, NSNumber(value: ViewController.width), NSNumber(value: ViewController.height)], dataType: .double)
            for x in 0..<ViewController.width {
                for y in 0..<ViewController.height {
                    let xx = NSNumber(value: x)
                    let yy = NSNumber(value: y)
                    input[[0, xx, yy]] = NSNumber(value: Double(pixelBuffer32bit[4 * y + 4 * x * ViewController.width + 1]) / 255 )
                }
            }
            print(input.imageAsString(width: ViewController.width, height: ViewController.height))
            let result = try model.prediction(image: input)
            let index = result.digit.maxIndex
            textLabel.text = "\(index)"
        } catch {
            print(error)
        }
    }
    func testMNIST() {
        do {
            let count = 1000
            var trueCount = 0
            tic()
            for i in 0..<count {
                let label = try loadLabel(index: i)
                let image = try loadImage(index: i)
                let result = try model.prediction(image: image)
                if label == result.digit.maxIndex {
                    trueCount += 1
                }
            }
            toc()
            print("\(Double(trueCount) / Double(count) * 100)")
        } catch {
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testMNIST()
        
        for x in 0..<ViewController.width {
            for y in 0..<ViewController.height {
                pixelBuffer32bit[4 * y + 4 * x * ViewController.width + 0] = 255
                pixelBuffer32bit[4 * y + 4 * x * ViewController.width + 1] = 0
                pixelBuffer32bit[4 * y + 4 * x * ViewController.width + 2] = 0
                pixelBuffer32bit[4 * y + 4 * x * ViewController.width + 3] = 0
            }
        }
        updateImage()
    }
}

