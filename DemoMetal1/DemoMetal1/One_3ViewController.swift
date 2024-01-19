//
//  One_3ViewController.swift
//  DemoMetal1
//
//  Created by billthaslu on 2024/1/17.
//

import UIKit
import MetalKit
import simd


class One_3ViewController: UIViewController {

    lazy var metalView: MTKView = {
        let metalView = MTKView(frame: CGRect(x: 20, y: 100, width: 300, height: 300))
        metalView.device = MTLCreateSystemDefaultDevice()
        metalView.clearColor = MTLClearColor(red: 1, green: 0.5, blue: 0, alpha: 1)
        metalView.delegate = self;
        return metalView
    }()
    
    var metalDevice: MTLDevice?
    var commandQueue: MTLCommandQueue?
    var renderPipelineState: MTLRenderPipelineState?
    var viewportSize: vector_uint2 = vector_uint2(0, 0)
}

extension One_3ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.metalView)
        self.metalDevice = self.metalView.device
        self.metalView.delegate?.mtkView(self.metalView, drawableSizeWillChange: self.metalView.drawableSize)

        
        self.test()
    }
}

extension One_3ViewController {
    
    func test() {
        guard let device = self.metalDevice,
        let library = device.makeDefaultLibrary(),
        let vertexFunction = library.makeFunction(name: "vertexShader"),
        let fragmentFunction = library.makeFunction(name: "fragmentShader")
        else {
            return
        }
        self.commandQueue = device.makeCommandQueue()
        
        let piplineDescriptor = MTLRenderPipelineDescriptor()
        piplineDescriptor.label = "simple"
        piplineDescriptor.vertexFunction = vertexFunction
        piplineDescriptor.fragmentFunction = fragmentFunction
        piplineDescriptor.colorAttachments[0].pixelFormat = self.metalView.colorPixelFormat
        
        renderPipelineState = try? device.makeRenderPipelineState(descriptor: piplineDescriptor)
        
    }
}

extension One_3ViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.viewportSize.x = UInt32(size.width)
        self.viewportSize.y = UInt32(size.height)
    }
    
    func draw(in view: MTKView) {
        let vertex1 = Demovertex(position: vector_float2(250, -250), color: vector_float4(1, 0, 0, 1))
        let vertex2 = Demovertex(position: vector_float2(-250, -250), color: vector_float4(0, 1, 0, 1))
        let vertex3 = Demovertex(position: vector_float2(0, 250), color: vector_float4(0, 0, 1, 1))
        let triangleVertices = [vertex1, vertex2, vertex3]
        
        guard let commandBuffer = self.commandQueue?.makeCommandBuffer() else {
            return
        }
        commandBuffer.label = "myCommand"
        
        guard let renderPassDescriptor = view.currentRenderPassDescriptor,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor),
              let renderPipelineState = self.renderPipelineState
                
        else {
            return
        }
        renderEncoder.label = "renderEncoder"
        renderEncoder.setViewport(MTLViewport(originX: 0.0, originY: 0.0, width: Double(self.viewportSize.x), height: Double(self.viewportSize.y), znear: 0.0, zfar: 1.0))
        renderEncoder.setRenderPipelineState(renderPipelineState)
        renderEncoder.setVertexBytes(triangleVertices, length: triangleVertices.count * MemoryLayout<Demovertex>.size, index: Int(DemoVertexInputIndexVertices.rawValue))
        renderEncoder.setVertexBytes(&viewportSize, length: MemoryLayout<vector_uint2>.size, index: Int(DemoVertexInputIndexViewportSize.rawValue))
        renderEncoder.drawPrimitives(type: MTLPrimitiveType.triangle, vertexStart: 0, vertexCount: 3)
        renderEncoder.endEncoding()
        
        if let drawable = view.currentDrawable {
            commandBuffer.present(drawable)
        }
        
        commandBuffer.commit()
    }
    
    
}
