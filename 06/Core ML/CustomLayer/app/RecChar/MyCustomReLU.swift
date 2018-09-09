//
//  MyCustomReLU.swift
//  RecChar
//
//  Created by sonson on 2018/09/09.
//  Copyright © 2018 sonson. All rights reserved.
//

import Foundation
import CoreML
import Accelerate
import Metal

enum MyCustomReLUError: Error {
    case initializeError
}

@objc(MyCustomReLU) public class MyCustomReLU: NSObject, MLCustomLayer {
    #if USE_GPU
    var device: MTLDevice?
    var library: MTLLibrary?
    var commandQueue: MTLCommandQueue?
    var pipelineState: MTLComputePipelineState?
    
    private func encode(commandBuffer: MTLCommandBuffer, inputs: [MTLTexture], outputs: [MTLTexture]) throws {
        guard let pipelineState = pipelineState else {
            throw MyCustomReLUError.initializeError
        }
        if let encoder = commandBuffer.makeComputeCommandEncoder() {
            for i in 0..<inputs.count {
                encoder.setTexture(inputs[i], index: 0)
                encoder.setTexture(outputs[i], index: 1)
                
                let w = pipelineState.threadExecutionWidth
                let h = pipelineState.maxTotalThreadsPerThreadgroup / w
                let threadGroupSize = MTLSizeMake(w, h, 1)
                
                let threadGroups = MTLSizeMake(
                    (inputs[i].width       + threadGroupSize.width  - 1) / threadGroupSize.width,
                    (inputs[i].height      + threadGroupSize.height - 1) / threadGroupSize.height,
                    (inputs[i].arrayLength + threadGroupSize.depth  - 1) / threadGroupSize.depth
                )
                
                encoder.setComputePipelineState(pipelineState)
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
                throw MyCustomReLUError.initializeError
            }
            guard let library = device.makeDefaultLibrary() else {
                throw MyCustomReLUError.initializeError
            }
            guard let sigmoidFunction = library.makeFunction(name: "relu") else {
                throw MyCustomReLUError.initializeError
            }
            self.pipelineState = try device.makeComputePipelineState(function: sigmoidFunction)
        } catch {
            print(error)
        }
        #endif
        super.init()
    }
    
    public func setWeightData(_ weights: [Data]) throws {
        // do nothing
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
        vDSP_vabs(iptr, 1, optr, 1, vDSP_Length(count))
        vDSP_vadd(iptr, 1, optr, 1, iptr, 1, vDSP_Length(count))
        var mult: Float = 0.5
        vDSP_vsmul(iptr, 1, &mult, optr, 1, vDSP_Length(count))
        #else
        for i in 0..<count {
            optr[Int(i)] = (iptr[Int(i)] > 0) ? iptr[Int(i)] : 0
        }
        #endif
    }
}
