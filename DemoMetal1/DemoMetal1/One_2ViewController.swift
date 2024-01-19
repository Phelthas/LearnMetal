//
//  One_2ViewController.swift
//  DemoMetal1
//
//  Created by billthaslu on 2024/1/16.
//

import UIKit
import MetalKit

class One_2ViewController: UIViewController {

    lazy var metalView: MTKView = {
        let metalView = MTKView(frame: self.view.bounds)
        metalView.enableSetNeedsDisplay = true;
        metalView.device = MTLCreateSystemDefaultDevice()
        metalView.clearColor = MTLClearColor(red: 1, green: 0, blue: 0.5, alpha: 1)
        metalView.delegate = self
        return metalView
    }()
    
    var device: MTLDevice?
    var commandQueue: MTLCommandQueue?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.metalView)
        self.device = self.metalView.device;
        self.commandQueue = self.device?.makeCommandQueue()
        
    }
    
}

extension One_2ViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        guard let renderPassDescriptor = self.metalView.currentRenderPassDescriptor,
              let commandBuffer = self.commandQueue?.makeCommandBuffer(),
              let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        commandEncoder.endEncoding()
        guard let drawable = self.metalView.currentDrawable else {
            return
        }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
}
