import UIKit

class ProteinViewController: UIViewController {
    var ligand = String()
    
    @IBOutlet weak var proteinName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        proteinName.text = ligand
    }
}
