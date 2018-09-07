//
//  MyCustomSigmoid.swift
//  RecChar
//
//  Created by sonson on 2018/09/06.
//  Copyright © 2018 sonson. All rights reserved.
//

import Foundation
import CoreML
import Accelerate
import Metal

enum MyCustomSigmoidError: Error {
    case initializeError
}

@objc(MyCustomSigmoid) public class MyCustomSigmoid: NSObject, MLCustomLayer {
#if USE_GPU
    var device: MTLDevice?
    var library: MTLLibrary?
    var commandQueue: MTLCommandQueue?
    var sigmoidPipelineState: MTLComputePipelineState?
    
    private func encode(commandBuffer: MTLCommandBuffer, inputs: [MTLTexture], outputs: [MTLTexture]) throws {
        guard let sigmoidPipelineState = sigmoidPipelineState else {
            throw MyCustomSigmoidError.initializeError
        }
        if let encoder = commandBuffer.makeComputeCommandEncoder() {
            for i in 0..<inputs.count {
                encoder.setTexture(inputs[i], index: 0)
                encoder.setTexture(outputs[i], index: 1)
                
                let w = sigmoidPipelineState.threadExecutionWidth
                let h = sigmoidPipelineState.maxTotalThreadsPerThreadgroup / w
                let threadGroupSize = MTLSizeMake(w, h, 1)
                
                let threadGroups = MTLSizeMake(
                    (inputs[i].width       + threadGroupSize.width  - 1) / threadGroupSize.width,
                    (inputs[i].height      + threadGroupSize.height - 1) / threadGroupSize.height,
                    (inputs[i].arrayLength + threadGroupSize.depth  - 1) / threadGroupSize.depth
                )
                
                encoder.setComputePipelineState(sigmoidPipelineState)
                encoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupSize)
                
                encoder.endEncoding()
            }
        }
    }
#endif
    public required init(parameters: [String : Any]) throws {
#if USE_GPU
        do {
            guard let device = MTLCreateSystemDefaultDevice() else {
                throw MyCustomSigmoidError.initializeError
            }
            guard let library = device.makeDefaultLibrary() else {
                throw MyCustomSigmoidError.initializeError
            }
            guard let sigmoidFunction = library.makeFunction(name: "sigmoid") else {
                throw MyCustomSigmoidError.initializeError
            }
            self.sigmoidPipelineState = try device.makeComputePipelineState(function: sigmoidFunction)
        } catch {
            print(error)
        }
#endif
        super.init()
    }
    
    public func setWeightData(_ weights: [Data]) throws {
        let data = weights[0]
        data.withUnsafeBytes { (ptr: UnsafePointer<Float>) -> Void in
            for i in 0..<10 {
                let p = ptr.advanced(by: i)
                print(p.pointee)
            }
        }
    }
    
    public func outputShapes(forInputShapes inputShapes: [[NSNumber]]) throws -> [[NSNumber]] {
        /// Sigmoid function, the output shape is as same as the input shape.
        return inputShapes
    }
    
    public func evaluate(inputs: [MLMultiArray], outputs: [MLMultiArray]) throws {
        assert(inputs.count == outputs.count)
        
        let input = inputs[0]
        let output = outputs[0]
        
        assert(input.count == output.count)
        
        var count = Int32(input.count)
        let iptr = UnsafeMutablePointer<Float>(OpaquePointer(input.dataPointer))
        let optr = UnsafeMutablePointer<Float>(OpaquePointer(output.dataPointer))
        
#if USE_GPU || USE_SIMD
        vvexpf(iptr, iptr, &count)
        var one: Float = 1
        vDSP_vsadd(iptr, 1, &one, optr, 1, vDSP_Length(count))
        vvdivf(optr, iptr, optr, &count)
#else
        for i in 0..<count {
            optr[Int(i)] = 1 / (1 + exp(-iptr[Int(i)]))
        }
#endif
    }
}
