//
//  GameViewController.swift
//  DriftCar
//
//  Created by Krystian Śliwa on 27/02/2018.
//  Copyright © 2018 Krystian Śliwa. All rights reserved.
//

import SceneKit
import QuartzCore

class GameViewController: NSViewController {
    
    var scene: Scene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = Scene()
        scene.setupNodes()
        self.scene = scene
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        scnView.scene = scene
        
        scnView.allowsCameraControl = true
        scnView.showsStatistics = true
        scnView.backgroundColor = NSColor.black
    }
    
    override func keyDown(with event: NSEvent) {
        scene.keyDown(with: event)
    }
    
    override func keyUp(with event: NSEvent) {
        scene.keyUp(with: event)
    }
    
}
