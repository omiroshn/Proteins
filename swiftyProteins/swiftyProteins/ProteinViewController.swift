import UIKit
import SceneKit

class ProteinViewController: UIViewController {
    var atomList: [Atom] = []
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
    
        self.scnView = self.view as! SCNView
        self.scnView.scene = ProteinScene(atomList: atomList)
        self.scnView.backgroundColor = UIColor.black
        self.scnView.autoenablesDefaultLighting = true
        self.scnView.allowsCameraControl = true
        DispatchQueue.main.async {
            self.scnView.addGestureRecognizer(tap)
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
                    let atom = atomList[Int(id)! - 1]
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
}
