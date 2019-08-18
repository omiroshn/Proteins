import UIKit

class Ligands: NSObject {
    var ligandsList: [String] = []
    
    func ligandsRequest(completeonClosure: @escaping (Data?) -> ()) {
        let url = URL(string:"https://projects.intra.42.fr/uploads/document/document/312/ligands.txt")!
        let task = URLSession.shared.dataTask(with:url) { (data, response, error) in
            if let err = error{
                print(err)
            }
            else {
                completeonClosure(data as Data?)
            }
        }
        task.resume()
    }
}
