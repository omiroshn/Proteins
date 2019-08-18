import UIKit

class Atom: NSObject {
    var id = Int()
    var symb = String()
    var color = UIColor()
    var x = Double()
    var y = Double()
    var z = Double()
    var connections = [Int()]
    
    init(id: Int, symb: String, color: UIColor, x: Double, y: Double, z: Double) {
        self.id = id
        self.symb = symb
        self.color = color
        self.x = x
        self.y = y
        self.z = z
    }
    
    func setConnections(connections: [Int]) {
        self.connections = connections
    }
}
