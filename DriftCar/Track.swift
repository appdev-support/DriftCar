//
//  Track.swift
//  DriftCar
//
//  Created by Krystian Śliwa on 27/02/2018.
//  Copyright © 2018 Krystian Śliwa. All rights reserved.
//

import SceneKit

class Track: SCNNode {
    
    override init() {
        super.init()
        
        self.position = SCNVector3Make(0, 0.01, 0)
        self.rotation = SCNVector4Make(1, 0, 0, CGFloat.pi/2.0)
        let rect = NSRect(x: -60, y: -20, width: 120, height: 40)
        let trackPath = NSBezierPath(roundedRect: rect, xRadius: 20, yRadius: 20)
        
        let smallerRect = rect.insetBy(dx: 10, dy: 10)
        let smallerPath = NSBezierPath(roundedRect: smallerRect, xRadius: 10, yRadius: 10)
        smallerPath.windingRule = .evenOddWindingRule
        
        trackPath.append(smallerPath)
        trackPath.flatness = 0.1
        
        let geometry = SCNShape(path: trackPath, extrusionDepth: 1)
        
        let material = SCNMaterial()
        material.diffuse.contents = "art.scnassets/asphalt.jpg"
        material.diffuse.wrapS = .repeat
        material.diffuse.wrapT = .repeat
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(5, 5, 1);
        geometry.firstMaterial = material
        
        self.geometry = geometry
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
