//
//  One_1ViewController.swift
//  DemoMetal1
//
//  Created by billthaslu on 2024/1/16.
//

import UIKit
import Metal

let arrayLength: Int = 1 << 4
let bufferSize: Int = arrayLength * MemoryLayout<Float>.size

class One_1ViewController: UIViewController {

    var bufferA: MTLBuffer?
    var bufferB: MTLBuffer?
    var bufferResult: MTLBuffer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        test1()
    }


}

extension One_1ViewController {
    
    
    
    func test1() {
        guard let device: MTLDevice = MTLCreateSystemDefaultDevice() else {
            return
        }
        
        guard let defaultLibrary: MTLLibrary = device.makeDefaultLibrary() else {
            return
        }
        
        guard let addFunction: MTLFunction = defaultLibrary.makeFunction(name: "add_arrays") else {
            return
        }
        
        guard let addFuntionPSO: MTLComputePipelineState = try? device.makeComputePipelineState(function: addFunction) else {
            return
        }
        
        guard let commandQueue:MTLCommandQueue = device.makeCommandQueue() else {
            return
        }
        
        bufferA = device.makeBuffer(length: bufferSize, options: MTLResourceOptions.storageModeShared)
        bufferB = device.makeBuffer(length: bufferSize, options: MTLResourceOptions.storageModeShared)
        bufferResult = device.makeBuffer(length: bufferSize, options: MTLResourceOptions.storageModeShared)
        
        if let tempBuffer = bufferA {
            self.generateRandomFloatData(buffer: tempBuffer)
        }
        if let tempBuffer = bufferB {
            self.generateRandomFloatData(buffer: tempBuffer)
        }
        
        
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            return
        }
        guard let computeEncoder = commandBuffer.makeComputeCommandEncoder() else {
            return
        }
        computeEncoder.setComputePipelineState(addFuntionPSO)
        computeEncoder.setBuffer(bufferA, offset: 0, index: 0)
        computeEncoder.setBuffer(bufferB, offset: 0, index: 1)
        computeEncoder.setBuffer(bufferResult, offset: 0, index: 2)
        let gridSize = MTLSize(width: arrayLength, height: 1, depth: 1)
        var threadGroupSize = addFuntionPSO.maxTotalThreadsPerThreadgroup
        if threadGroupSize > arrayLength {
            threadGroupSize = arrayLength
        }
        let groupSize = MTLSize(width: threadGroupSize, height: 1, depth: 1)
        computeEncoder.dispatchThreads(gridSize, threadsPerThreadgroup: groupSize)
        
        computeEncoder.endEncoding()
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        self.verifyResults()
        
    }
    
    func generateRandomFloatData(buffer: MTLBuffer) {
        let dataPtr = buffer.contents().bindMemory(to: Float.self, capacity: buffer.length)
        
        for index in 0..<arrayLength {
            dataPtr[index] = Float.random(in: 0..<1)
        }
    }
    
    func verifyResults() {
        guard let a = bufferA?.contents().bindMemory(to: Float.self, capacity: arrayLength),
              let b = bufferB?.contents().bindMemory(to: Float.self, capacity: arrayLength),
              let c = bufferResult?.contents().bindMemory(to: Float.self, capacity: arrayLength) else {
            return
        }
        
        for index in 0 ..< arrayLength {
            print("Compute: index=\(index) result=\(c[index]) vs \(a[index])+\(b[index])")
            if c[index] != (a[index] + b[index]) {
                assert(c[index] == (a[index] + b[index]))
            }
        }
        
    }
    
}
