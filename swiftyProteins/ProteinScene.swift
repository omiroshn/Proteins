import UIKit
import SceneKit

class ProteinScene: SCNScene {
    var atomList: [Atom] = []
    
    init(atomList: [Atom] = []) {
        super.init()
        
        self.atomList = atomList
        if ProteinViewController.switchIsOn == true {
            drawAtomsWithSpheres()
        } else {
            drawAtomsWithCubes()
        }
        drawPillars()
    }
    
    
    func drawAtomsWithSpheres() {
        for atom in atomList {
            let sphereGeom = SCNSphere(radius: 0.5)
            sphereGeom.firstMaterial?.diffuse.contents = atom.color
            let sphereNode = SCNNode(geometry: sphereGeom)
            sphereNode.position = SCNVector3(x: atom.x, y: atom.y, z: atom.z - 20)
            sphereNode.name = String(atom.id)
            self.rootNode.addChildNode(sphereNode)
        }
    }
    
    func drawAtomsWithCubes() {
        for atom in atomList {
            let boxGeom = SCNBox(width: 0.8, height: 0.8, length: 0.8, chamferRadius: 0)
            boxGeom.firstMaterial?.diffuse.contents = atom.color
            let boxNode = SCNNode(geometry: boxGeom)
            boxNode.position = SCNVector3(x: atom.x, y: atom.y, z: atom.z - 20)
            boxNode.name = String(atom.id)
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
        
        let pos = (to + from) / 2
        node.position = SCNVector3(x: pos.x, y: pos.y, z: pos.z - 20)
        node.eulerAngles = SCNVector3Make(Float(Double.pi/2), acos((to.z-from.z)/length), atan2((to.y-from.y), (to.x-from.x) ))
        
        return node
    }
    
    func drawPillars() {
        for atom in atomList {
            let first = atom.connections.first!
            let firstProtein = atomList[first-1]
            let firstVec = SCNVector3(x: firstProtein.x, y: firstProtein.y, z: firstProtein.z)
            
            for atomID in atom.connections {
                if (atomID == atom.connections.first!) {continue}

                let secondProtein = atomList[atomID-1]
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
