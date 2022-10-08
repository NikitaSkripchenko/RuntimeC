//
//  ViewController+helpers.swift
//  RuntimeC
//
//  Created by Nikita Skrypchenko on 02.10.2022.
//

import Foundation
import SceneKit

extension ViewController {
    
    struct Constants {
        static let pixelToAngleConstant: Float = .pi / 180
    }
    
    public func imageFromUrl(url: URL?, closure: @escaping(UIImage)->()) {
        if let url = url {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("error")
                    return
                }
                
                DispatchQueue.main.async {
                    closure(UIImage(data: data)!)
                }
            }
            
            task.resume()
        }
    }
    
    
    func handlePan(_ newPoint: CGPoint) {
        if let previousPoint = previousPanPoint {
            let dx = Float(newPoint.x - previousPoint.x)
            let dy = Float(newPoint.y - previousPoint.y)

            rotateUp(by: dy * Constants.pixelToAngleConstant)
            rotateRight(by: dx * Constants.pixelToAngleConstant)
        }

        previousPanPoint = newPoint
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            previousPanPoint = gestureRecognizer.location(in: view)
        case .changed:
            handlePan(gestureRecognizer.location(in: view))
        default:
            previousPanPoint = nil
        }
    }
    
    func makeSphere(with image: UIImage) {
        let scene = SCNScene()
        sceneView.scene = scene
        
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 1.0, y: 1.0, z: 3.0)
        
        let light = SCNLight()
        light.type = SCNLight.LightType.omni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 1.5, y: 1.5, z: 1.5)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        sceneView.addGestureRecognizer(panGesture)
        let planeMaterial = SCNMaterial()
        planeMaterial.emission.contents = image
        planeMaterial.isDoubleSided = true
        let sphereGeometry = SCNSphere(radius: 0.8)
        sphereGeometry.materials = [planeMaterial]
        self.sphereNode = SCNNode(geometry: sphereGeometry)
        
        let constraint = SCNLookAtConstraint(target: self.sphereNode)
        constraint.isGimbalLockEnabled = true
        cameraNode.constraints = [constraint]
        
        let imageRatio:CGFloat = 1
        let desiredPlaneWidth: CGFloat = 1
        let planeGeometry = SCNPlane(width: desiredPlaneWidth, height: desiredPlaneWidth * imageRatio)
        planeMaterial.diffuse.contents = image
        scene.rootNode.addChildNode(lightNode)
        scene.rootNode.addChildNode(cameraNode)
        scene.rootNode.addChildNode(self.sphereNode)
    }
    
    func rotateUp(by angle: Float) {
        let axis = SCNVector3(1, 0, 0) // x-axis
        rotate(by: angle, around: axis)
    }

    func rotateRight(by angle: Float) {
        let axis = SCNVector3(0, 1, 0) // y-axis
        rotate(by: angle, around: axis)
    }
    
    func rotate(by angle: Float, around axis: SCNVector3) {
        let transform = SCNMatrix4MakeRotation(angle, axis.x, axis.y, axis.z)
        sphereNode.transform = SCNMatrix4Mult(sphereNode.transform, transform)
    }
}
