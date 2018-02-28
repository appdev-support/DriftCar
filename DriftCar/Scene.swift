//
//  Scene.swift
//  DriftCar
//
//  Created by Krystian Śliwa on 27/02/2018.
//  Copyright © 2018 Krystian Śliwa. All rights reserved.
//

import SceneKit

class Scene: SCNScene {
    
    var vehicle: SCNPhysicsVehicle!
    var reactor: SCNParticleSystem!
    var camera: SCNNode!

    public func setupNodes() {
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.zFar = 300
        rootNode.addChildNode(cameraNode)
        self.camera = cameraNode
        
        cameraNode.position = SCNVector3(x: 0, y: 15, z: 100)
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 0)
        rootNode.addChildNode(lightNode)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = NSColor.darkGray
        rootNode.addChildNode(ambientLightNode)
        
        let floor = Floor()
        rootNode.addChildNode(floor)
        
        let track = Track()
        rootNode.addChildNode(track)
        
        addSkybox()
        addCar()
    }
    
    func addCar() {
        let carScene = SCNScene(named: "art.scnassets/Car.dae")!
        let chassisNode = carScene.rootNode .childNode(withName: "rccarBody", recursively: false)!
        chassisNode.position = SCNVector3Make(0, 0, 0)
        chassisNode.rotation = SCNVector4Make(0, 1, 0, .pi)
        self.rootNode.addChildNode(chassisNode)
        
        let body = SCNPhysicsBody(type: .dynamic, shape: nil)
        body.allowsResting = false
        body.mass = 100
        body.restitution = 0.1
        body.friction = 0.5
        body.rollingFriction = 0
        
        chassisNode.physicsBody = body
        
        let pipeNode = chassisNode.childNode(withName: "pipe", recursively: true)!
        let reactor = SCNParticleSystem(named: "reactor", inDirectory: "art.scnassets")!
        reactor.birthRate = 100
        pipeNode.addParticleSystem(reactor)
        self.reactor = reactor
        
        let wheel0Node = chassisNode.childNode(withName: "wheelLocator_FL", recursively: true)!
        let wheel1Node = chassisNode.childNode(withName: "wheelLocator_FR", recursively: true)!
        let wheel2Node = chassisNode.childNode(withName: "wheelLocator_RL", recursively: true)!
        let wheel3Node = chassisNode.childNode(withName: "wheelLocator_RR", recursively: true)!
        
        let wheel0 = SCNPhysicsVehicleWheel(node: wheel0Node)
        let wheel1 = SCNPhysicsVehicleWheel(node: wheel1Node)
        let wheel2 = SCNPhysicsVehicleWheel(node: wheel2Node)
        let wheel3 = SCNPhysicsVehicleWheel(node: wheel3Node)
        
        let (min, max) = wheel0Node.boundingBox
        let halfWidth = 0.5 * (max.x - min.x)
        
        wheel0.connectionPosition = wheel0Node.convertPosition(SCNVector3Zero, to: chassisNode) + SCNVector3Make(halfWidth, 0, 0)
        wheel1.connectionPosition = wheel1Node.convertPosition(SCNVector3Zero, to: chassisNode) - SCNVector3Make(halfWidth, 0, 0)
        wheel2.connectionPosition = wheel2Node.convertPosition(SCNVector3Zero, to: chassisNode) + SCNVector3Make(halfWidth, 0, 0)
        wheel3.connectionPosition = wheel3Node.convertPosition(SCNVector3Zero, to: chassisNode) - SCNVector3Make(halfWidth, 0, 0)
        
        let vehicle = SCNPhysicsVehicle(chassisBody: body, wheels: [wheel0, wheel1, wheel2, wheel3])
        self.physicsWorld.addBehavior(vehicle)
        self.vehicle = vehicle
        
        
        let constraint = SCNLookAtConstraint(target: chassisNode)
        constraint.isGimbalLockEnabled = true
        camera.constraints = [constraint]
    }
    
    func addSkybox() {
        let files = ["Left", "Right", "Top", "Bottom", "Back", "Front"].map({ "skybox.scnassets/skybox\($0).png"})
        self.background.contents = files
    }
    
    public func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 49: //space
            breakCar()
        case 123: //left
            left()
        case 124: //right
            right()
        case 125: //backward
            backward()
        case 126: //forward
            forward()
        default:
            break
        }
    }
    
    public func keyUp(with event: NSEvent) {
        switch event.keyCode {
        case 49:
            vehicle.applyBrakingForce(0, forWheelAt: 2)
            vehicle.applyBrakingForce(0, forWheelAt: 3)
        case 123, 124:
            vehicle.setSteeringAngle(0.0, forWheelAt: 0)
            vehicle.setSteeringAngle(0.0, forWheelAt: 1)
        case 125, 126: //forward, backward
            reactor.birthRate = 0
            vehicle.applyEngineForce(0, forWheelAt: 2)
            vehicle.applyEngineForce(0, forWheelAt: 3)
        default:
            break;
        }
    }
    
    func breakCar() {
        vehicle.applyBrakingForce(1000, forWheelAt: 2)
        vehicle.applyBrakingForce(1000, forWheelAt: 3)
    }
    
    func forward() {
        reactor.birthRate = 1000
        
        vehicle.applyEngineForce(1500, forWheelAt: 0)
        vehicle.applyEngineForce(1500, forWheelAt: 1)
    }
    
    func backward() {
        reactor.birthRate = 1000
        vehicle.applyEngineForce(-500, forWheelAt: 0)
        vehicle.applyEngineForce(-500, forWheelAt: 1)
    }
    
    func left() {
        vehicle.setSteeringAngle(0.4, forWheelAt: 0)
        vehicle.setSteeringAngle(0.4, forWheelAt: 1)
    }
    
    func right() {
        vehicle.setSteeringAngle(-0.4, forWheelAt: 0)
        vehicle.setSteeringAngle(-0.4, forWheelAt: 1)
    }
    
}
