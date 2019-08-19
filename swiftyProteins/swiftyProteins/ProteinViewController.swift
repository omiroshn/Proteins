import UIKit
import SceneKit

class ProteinViewController: UIViewController {
    var ligand = String()
    var ligandData: [String] = []
    
    @IBOutlet weak var proteinName: UILabel!
    
    static var atomList: [Atom] = []
    var proteinsNames: [String] = []
    var colors = [String: UIColor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        proteinName.text = ligand
        
        view.backgroundColor = .black
        
        proteinDataRequest() {
            data in
            ProteinViewController.atomList = []
            if let ligandData = data as Data? {
                if let ligandStringData = String(data: ligandData, encoding: .utf8) {
                    for line in ligandStringData.split(separator: "\n") {
                        self.ligandData.append(String(line))
                    }
                    self.parseLigandsData()
                }
            }
            let scnView = self.view as! SCNView
            scnView.scene = ProteinScene()
            scnView.backgroundColor = UIColor.black
            scnView.autoenablesDefaultLighting = true
            scnView.allowsCameraControl = true
        }
    }
    
    func addColor(atomName: String) -> UIColor {
        if !proteinsNames.contains(atomName) {
            colors[atomName] = UIColor.random
            proteinsNames.append(atomName)
        }
        return colors[atomName] ?? UIColor.white
    }

    func parseLigandsData() {
        for line in ligandData {
            let atomData = line.split(separator: " ")
            
            if atomData[0] == "ATOM" {
                ProteinViewController.atomList.append(
                    Atom(id: Int(atomData[1])!,
                         symb: String(atomData[11]),
                         color: addColor(atomName: String(atomData[11])),
                         x: Float(atomData[6])!,
                         y: Float(atomData[7])!,
                         z: Float(atomData[8])!
                    )
                )
            }
            else if atomData[0] == "CONECT" {
                var connections: [Int] = []
                
                for index in 1...atomData.count - 1 {
                    connections.append(Int(atomData[index])!)
                }
                ProteinViewController.atomList[Int(atomData[1])! - 1].setConnections(connections: connections)
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

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
