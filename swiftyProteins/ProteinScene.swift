import UIKit
import SceneKit

class ProteinScene: SCNScene {
    var atomList: [Atom] = []
    
    init(atomList: [Atom] = []) {
        super.init()
        
        self.atomList = atomList
        
        background.contents = [
            "right.jpg",
            "left.jpg",
            "top.jpg",
            "bottom.jpg",
            "front.jpg",
            "back.jpg"
        ]
        
        drawAtoms()
        drawPillars()
        rootNode.addChildNode(cameraSettings())
    }
    
    func cameraSettings() -> SCNNode {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 30)
        return cameraNode
    }
    
    func drawAtoms() {
        for atom in atomList {
            var objectGeom = SCNGeometry()
            if ProteinViewController.switchIsOn == true {
                objectGeom = SCNSphere(radius: 0.5)
            } else {
                objectGeom = SCNBox(width: 0.8, height: 0.8, length: 0.8, chamferRadius: 0)
            }
            objectGeom.firstMaterial?.diffuse.contents = atom.color
            let objectNode = SCNNode(geometry: objectGeom)
            objectNode.position = SCNVector3(x: atom.x, y: atom.y, z: atom.z)
            objectNode.name = String(atom.id)
            rootNode.addChildNode(objectNode)
        }
    }
    
    func drawPillars() {
        for atom in atomList {
            if atom.connections.count == 0 {continue}
            
            let first = atom.connections.first!
            let firstProtein = atomList[first - 1]
            let firstVec = SCNVector3(x: firstProtein.x, y: firstProtein.y, z: firstProtein.z)
            
            for atomID in atom.connections {
                if (atomID == first) {continue}

                let secondProtein = atomList[atomID - 1]
                let secondVec = SCNVector3(x: secondProtein.x, y: secondProtein.y, z: secondProtein.z)
                let lineNode = line(from: firstVec, to: secondVec, width: 10, color: UIColor.white)
                
                self.rootNode.addChildNode(lineNode)
            }
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
        node.position = SCNVector3(x: pos.x, y: pos.y, z: pos.z)
        node.eulerAngles = SCNVector3Make(Float(Double.pi/2), acos((to.z-from.z)/length), atan2((to.y-from.y), (to.x-from.x) ))
        
        return node
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
