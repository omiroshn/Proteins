import UIKit
import SceneKit

class ProteinViewController: UIViewController {
    var ligand = String()
    var ligandData: [String] = []
    
    static var atomList: [Atom] = []
    var proteinsNames: [String] = []
    var colors = [String: UIColor]()
    var scnView = SCNView()
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        hide(on: true)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
        
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
            self.scnView = self.view as! SCNView
            self.scnView.scene = ProteinScene()
            self.scnView.backgroundColor = UIColor.black
            self.scnView.autoenablesDefaultLighting = true
            self.scnView.allowsCameraControl = true
            DispatchQueue.main.async {
                self.scnView.addGestureRecognizer(tap)
            }
        }
    }
    
    func hide(on: Bool) {
        infoView.isHidden = on
        symbolLabel.isHidden = on
        idLabel.isHidden = on
        xLabel.isHidden = on
        yLabel.isHidden = on
        zLabel.isHidden = on
    }
    
    @objc func handleTap(rec: UITapGestureRecognizer) {
        
        if rec.state == .ended {
            let location: CGPoint = rec.location(in: scnView)
            let hits = self.scnView.hitTest(location, options: nil)
            if !hits.isEmpty{
                hide(on: false)
                let tappedNode = hits.first?.node
                if let id = tappedNode?.name {
                    let atom = ProteinViewController.atomList[Int(id)! - 1]
                    symbolLabel.text = atom.symb
                    idLabel.text = "ID " + String(atom.id)
                    xLabel.text = "X " + String(atom.x)
                    yLabel.text = "Y " + String(atom.y)
                    zLabel.text = "Z " + String(atom.z)
                }
            } else {
                hide(on: true)
            }
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
