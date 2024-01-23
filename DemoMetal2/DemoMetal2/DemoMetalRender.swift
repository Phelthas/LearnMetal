//
//  DemoMetalRender.swift
//  DemoMetal2
//
//  Created by billthaslu on 2024/1/23.
//

import UIKit
import MetalKit
import simd

class DemoMetalRender: NSObject {
    var commandQueue: MTLCommandQueue?
    var piplineState: MTLRenderPipelineState?
    
    var texture: MTLTexture?
    
//    let rectangleVertices: [DemoShaderVertex] = {
//        let vertex0 = DemoShaderVertex(position: vector_float2(-1, -1), textureCoordinate: vector_float2(0, 0))
//        let vertex1 = DemoShaderVertex(position: vector_float2(-1, 1), textureCoordinate: vector_float2(0, 1))
//        let vertex2 = DemoShaderVertex(position: vector_float2(1, -1), textureCoordinate: vector_float2(1, 0))
//        let vertex3 = DemoShaderVertex(position: vector_float2(1, 1), textureCoordinate: vector_float2(1, 1))
//        return [vertex0, vertex1, vertex2, vertex3]
//    }()
    
    // 加载出来的图片默认是倒着的，因为坐标系不一致，可以用修改纹理坐标的位置把它正过来
    let rectangleVertices: [DemoShaderVertex] = {
        let vertex0 = DemoShaderVertex(position: vector_float2(-1, -1), textureCoordinate: vector_float2(0, 1))
        let vertex1 = DemoShaderVertex(position: vector_float2(-1, 1), textureCoordinate: vector_float2(0, 0))
        let vertex2 = DemoShaderVertex(position: vector_float2(1, -1), textureCoordinate: vector_float2(1, 1))
        let vertex3 = DemoShaderVertex(position: vector_float2(1, 1), textureCoordinate: vector_float2(1, 0))
        return [vertex0, vertex1, vertex2, vertex3]
    }()
    
    init(view: MTKView) {
        guard let device = view.device,
              let defaultLibrary = device.makeDefaultLibrary(),
              let vertexShader = defaultLibrary.makeFunction(name: "vertexShader"),
              let fragmentShader = defaultLibrary.makeFunction(name: "fragmentShader")
        else {
            return
        }
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.label = "asd"
        pipelineStateDescriptor.vertexFunction = vertexShader
        pipelineStateDescriptor.fragmentFunction = fragmentShader
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat
        
        piplineState = try? device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
        commandQueue = device.makeCommandQueue()
        
        let textureLoader = MTKTextureLoader(device: device)
        if let image = UIImage(named: "xianhua.png"),
           let cgImage = image.cgImage {
            texture = try? textureLoader.newTexture(cgImage: cgImage)
        }
        
    }
    
}

extension DemoMetalRender: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        guard let piplineState = piplineState,
        let commandBuffer = commandQueue?.makeCommandBuffer() else {
            return
        }
        commandBuffer.label = "aaa"
        
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder?.label = "bbb"
        renderEncoder?.setViewport(MTLViewport(originX: 0, originY: 0, width: Double(view.drawableSize.width), height: Double(view.drawableSize.height), znear: -1, zfar: 1))
        renderEncoder?.setRenderPipelineState(piplineState)
        renderEncoder?.setVertexBytes(rectangleVertices, length: rectangleVertices.count * MemoryLayout<DemoShaderVertex>.size, index: Int(DemoShaderVertexInputIndexVertices.rawValue))
        renderEncoder?.setFragmentTexture(texture, index: Int(DemoShaderTextureIndexBaseColor.rawValue))
        renderEncoder?.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
        renderEncoder?.endEncoding()
        if let drawable = view.currentDrawable {
            commandBuffer.present(drawable)
        }
        
        commandBuffer.commit()
    }
    
    
}
