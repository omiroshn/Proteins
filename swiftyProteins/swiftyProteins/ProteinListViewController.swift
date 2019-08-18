import UIKit

class ProteinCell: UITableViewCell {
    @IBOutlet weak var ligand: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            contentView.backgroundColor = UIColor(red: 0.3216, green: 0.7686, blue: 0.6784, alpha: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.contentView.backgroundColor = .white
            }
        }
    }
}


class ProteinListViewController: UIViewController {
    @IBOutlet weak var proteinTableView: UITableView!
    @IBOutlet weak var proteinSearchBar: UISearchBar!
    
    var ligandsList = [String]()
    var searchLigands = [String]()
    var isSearching = false
    var ligandForSeque = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        proteinSearchBar.backgroundColor = UIColor(red: 0.3216, green: 0.7686, blue: 0.6784, alpha: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVc = segue.destination as? ProteinViewController {
            nextVc.ligand = ligandForSeque
        }
    }
}

extension ProteinListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchLigands.count
        } else {
            return ligandsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProteinCell") as! ProteinCell
        
        if isSearching {
            cell.ligand.text = searchLigands[indexPath.row]
        } else {
            cell.ligand.text = ligandsList[indexPath.row]
        }
        cell.layer.borderWidth = 0.1
        cell.layer.cornerRadius = 3
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            ligandForSeque = self.searchLigands[indexPath.row]
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "Ligand", sender: self)
            }
        }
        else {
            ligandForSeque = self.ligandsList[indexPath.row]
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "Ligand", sender: self)
            }
        }
    }
}

extension ProteinListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchLigands = ligandsList.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        isSearching = true
        proteinTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        proteinSearchBar.text = ""
        proteinTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
