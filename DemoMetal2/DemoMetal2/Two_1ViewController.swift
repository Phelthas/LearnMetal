//
//  Two_1ViewController.swift
//  DemoMetal2
//
//  Created by billthaslu on 2024/1/22.
//

import UIKit
import MetalKit

class Two_1ViewController: UIViewController {

    
}

extension Two_1ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let metalView = MTKView(frame: CGRect(x: 50, y: 100, width: self.view.frame.size.width - 100, height: self.view.frame.size.height - 200))
        metalView.device = MTLCreateSystemDefaultDevice()
        metalView.clearColor = MTLClearColor(red: 1, green: 0.5, blue: 0, alpha: 1)
        self.view.addSubview(metalView)

        let metalRender = DemoMetalRender(view: metalView)
        
        metalRender.draw(in: metalView)
    }
}
