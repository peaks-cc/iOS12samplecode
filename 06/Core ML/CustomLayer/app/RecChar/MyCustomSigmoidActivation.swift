//
//  MyCustomSigmoidActivation.swift
//  RecChar
//
//  Created by sonson on 2018/07/27.
//  Copyright © 2018 sonson. All rights reserved.
//

import Foundation
import CoreML
import Accelerate

@objc(MyCustomSigmoidActivation) public class MyCustomSigmoidActivation: NSObject, MLCustomLayer {
    public required init(parameters: [String : Any]) throws {
        print(parameters)
    }
    
    public func setWeightData(_ weights: [Data]) throws {
        // do nothing
        let data = weights[0]
        let value = data.withUnsafeBytes { (ptr: UnsafePointer<Float>) -> Float in
            return ptr.pointee
        }
        print(value)
    }
    
    public func outputShapes(forInputShapes inputShapes: [[NSNumber]]) throws -> [[NSNumber]] {
        /// Sigmoid function, the output shape is as same as the input shape.
        return inputShapes
    }
    
    public func evaluate(inputs: [MLMultiArray], outputs: [MLMultiArray]) throws {
        assert(inputs.count == outputs.count)
        
        let input = inputs[0]
        let output = outputs[0]
        
        var count = Int32(input.count)
        let iptr = UnsafeMutablePointer<Float>(OpaquePointer(input.dataPointer))
        let optr = UnsafeMutablePointer<Float>(OpaquePointer(output.dataPointer))
        
        vvfabsf(optr, iptr, &count)
        
        let buffer = UnsafeMutablePointer<Float>.allocate(capacity: input.count)
        defer { buffer.deallocate() }
        
        vDSP_vadd(iptr, 1, optr, 1, buffer, 1, UInt(input.count))
        
        var scale = Float(0.5)
        
        vDSP_vmul(buffer, 1, &scale, 0, optr, 1, UInt(input.count))
        
    }
}
