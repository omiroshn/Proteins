import UIKit
import SceneKit

class ProteinViewController: UIViewController {
    var atomList: [Atom] = []
    var scnView = SCNView()
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    
    @IBOutlet weak var switchControl: UISwitch!
    static var switchIsOn:Bool = true
    
    @objc func stateChanged(switchState: UISwitch) {
        if switchState.isOn {
            ProteinViewController.switchIsOn = true
        } else {
            ProteinViewController.switchIsOn = false
        }
        self.scnView.scene = ProteinScene(atomList: atomList)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        switchControl.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        
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
    
    @IBAction func sharePressed(_ sender: Any) {
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        // Creates UIImage of same size as view
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        
        let activityVC = UIActivityViewController(activityItems: [screenshot!], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
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
