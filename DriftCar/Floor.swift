//
//  Floor.swift
//  DriftCar
//
//  Created by Krystian Śliwa on 27/02/2018.
//  Copyright © 2018 Krystian Śliwa. All rights reserved.
//

import SceneKit

class Floor: SCNNode {

    override init() {
        super.init()
        
        self.geometry = SCNFloor()
        self.geometry?.firstMaterial = SCNMaterial()
        self.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/grass.jpg"
        self.geometry?.firstMaterial?.diffuse.wrapS = .repeat
        self.geometry?.firstMaterial?.diffuse.wrapT = .repeat
        self.geometry?.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(3, 3, 1);
        self.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
