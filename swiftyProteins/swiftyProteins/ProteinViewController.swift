import UIKit

class Atom {
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

class ProteinViewController: UIViewController {
    var ligand = String()
    var ligandData: [String] = []
    @IBOutlet weak var proteinName: UILabel!

    var atomList: [Atom] = []
    var colors = [String: UIColor]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        proteinName.text = ligand
        
        
        
        generateColor()
        proteinDataRequest() {
            data in
            if let ligandData = data as Data? {
                if let ligandStringData = String(data: ligandData, encoding: .utf8) {
                    for line in ligandStringData.split(separator: "\n") {
                        self.ligandData.append(String(line))
                    }
                    self.parseLigandsData()
                }
            }
        }
    }
    
    func generateColor() {
        let proteins = ["H", "C", "N", "O", "F", "Cl", "Br", "I", "He", "Ne", "Ar", "Xe", "Kr", "P", "S", "B", "Li", "Na", "K", "Rb", "Cs", "Fr", "Be", "Mg", "Ca", "Sr", "Ba", "Ra", "Ti", "Fe"]
        
        for protein in proteins {
            colors[protein] = randomColor()
        }
    }
    
    func randomColor() -> UIColor {
        return UIColor(red:   CGFloat(arc4random()) / CGFloat(UInt32.max),
                       green: CGFloat(arc4random()) / CGFloat(UInt32.max),
                       blue:  CGFloat(arc4random()) / CGFloat(UInt32.max),
                       alpha: 1.0)
    }

    func parseLigandsData() {
        for line in ligandData {
            let atomData = line.split(separator: " ")
            
            if atomData[0] == "ATOM" {
                self.atomList.append(Atom(id: Int(atomData[1])!, symb: String(atomData[11]), color: colors[String(atomData[11])]!, x: Double(atomData[6])!, y: Double(atomData[7])!, z: Double(atomData[8])!))
            }
            else if atomData[0] == "CONECT" {
                var connections: [Int] = []
                
                for index in 1...atomData.count - 1 {
                    connections.append(Int(atomData[index])!)
                }
                self.atomList[Int(atomData[1])! - 1].setConnections(connections: connections)
            }
        }
    }
    
    func proteinDataRequest(completeonClosure: @escaping (Data?) -> ()) {
        let url = URL(string: "https://files.rcsb.org/ligands/view/\(self.ligand)_ideal.pdb")
        let request = NSMutableURLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            (data, response, error) in
            if let err = error{
                print(err)
            }
            else if (data != nil){
                completeonClosure(data as Data?)
            }
        }
        task.resume()
    }
}
