import UIKit
import SceneKit
import ARKit

class ProteinViewController: UIViewController, ARSCNViewDelegate {
    var atomList: [Atom] = []
    
    @IBOutlet var scnView: ARSCNView!
    
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var symbolLabel: UILabel!
    
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    
    @IBOutlet weak var switchControl: UISwitch!
    static var switchIsOn:Bool = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        scnView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scnView.session.pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        informationView.layer.cornerRadius = 5
        switchControl.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
        hide(on: true)
        
        scnView.delegate = self
        scnView.showsStatistics = true

        self.scnView.scene = ProteinScene(atomList: atomList)
        self.scnView.autoenablesDefaultLighting = true
        self.scnView.allowsCameraControl = true
        DispatchQueue.main.async {
            self.scnView.addGestureRecognizer(tap)
        }
    }
    
    @objc func stateChanged(switchState: UISwitch) {
        if switchState.isOn {
            ProteinViewController.switchIsOn = true
        } else {
            ProteinViewController.switchIsOn = false
        }
        self.scnView.scene = ProteinScene(atomList: atomList)
    }
    
    @IBAction func sharePressed(_ sender: Any) {
        let snapshot = self.scnView.snapshot()
        
        let activityVC = UIActivityViewController(activityItems: [snapshot], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    
    func hide(on: Bool) {
        infoView.isHidden = on
        symbolLabel.isHidden = on
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
                    symbolLabel.text = "Atom: \(atom.symb)"
                    xLabel.text = "X position: " + String(atom.x)
                    yLabel.text = "Y position: " + String(atom.y)
                    zLabel.text = "Z position: " + String(atom.z)
                }
            } else {
                hide(on: true)
            }
        }
    }
}
