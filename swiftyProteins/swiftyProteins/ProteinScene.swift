//
//  ProteinScene.swift
//  swiftyProteins
//
//  Created by Oleksii MIROSHNYK on 8/19/19.
//  Copyright © 2019 aryabenk. All rights reserved.
//

import UIKit
import SceneKit

class ProteinScene: SCNScene {
    
    override init() {
        super.init()
        
        drawAtomsWithSpheres()
        //drawAtomsWithCubes()
        
        drawPillars()
    }
    
    func drawAtomsWithSpheres() {
        for atom in ProteinViewController.atomList {
            let sphereGeom = SCNSphere(radius: 0.5)
//            sphereGeom.firstMaterial?.diffuse.contents = atom.color
//            sphereGeom.firstMaterial?.diffuse.contents = UIColor.white
            sphereGeom.firstMaterial?.diffuse.contents = UIImage(named: "sphereTextureEarth.png")
            let sphereNode = SCNNode(geometry: sphereGeom)
            sphereNode.position = SCNVector3(x: atom.x, y: atom.y, z: atom.z)
            self.rootNode.addChildNode(sphereNode)
        }
    }
    
    func drawAtomsWithCubes() {
        for atom in ProteinViewController.atomList {
            let boxGeom = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0)
//            sphereGeom.firstMaterial?.diffuse.contents = atom.color
            boxGeom.firstMaterial?.diffuse.contents = UIColor.white
            let boxNode = SCNNode(geometry: boxGeom)
            boxNode.position = SCNVector3(x: atom.x, y: atom.y, z: atom.z)
            self.rootNode.addChildNode(boxNode)
        }
    }
    
    func line(from : SCNVector3, to : SCNVector3, width : Int, color : UIColor) -> SCNNode {
        let vector = to - from,
        length = vector.length()
        
        let cylinder = SCNCylinder(radius: 0.2, height: CGFloat(length))
        cylinder.radialSegmentCount = width
        cylinder.firstMaterial?.diffuse.contents = color
        
        let node = SCNNode(geometry: cylinder)
        
        node.position = (to + from) / 2
        node.eulerAngles = SCNVector3Make(Float(Double.pi/2), acos((to.z-from.z)/length), atan2((to.y-from.y), (to.x-from.x) ))
        
        return node
    }
    
    func drawPillars() {
        for atom in ProteinViewController.atomList {
            let first = atom.connections.first!
            let firstProtein = ProteinViewController.atomList[first-1]
            let firstVec = SCNVector3(x: firstProtein.x, y: firstProtein.y, z: firstProtein.z)
            
            for atomID in atom.connections {
                if (atomID == atom.connections.first!) {continue}

                let secondProtein = ProteinViewController.atomList[atomID-1]
                let secondVec = SCNVector3(x: secondProtein.x, y: secondProtein.y, z: secondProtein.z)
                let lineNode = line(from: firstVec, to: secondVec, width: 10, color: UIColor.white)
                
                self.rootNode.addChildNode(lineNode)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
