import UIKit

class ParseAtom: NSObject {
    var ligandName = String()
    var atomList: [Atom] = []
    var atomsData: [String] = []
    
    func parseAtomData() {
        for line in atomsData {
            let atomData = line.split(separator: " ")
            
            if atomData[0] == "ATOM" {
                self.atomList.append(
                    Atom(id: Int(atomData[1])!,
                         symb: String(atomData[11]),
                         color: .gray,
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
                self.atomList[Int(atomData[1])! - 1].setConnections(connections: connections)
            }
        }
    }

    func atomSplit(data: Data?) {
        if let ligandData = data as Data? {
            if let stringData = String(data: ligandData, encoding: .utf8) {
                for line in stringData.split(separator: "\n") {
                    self.atomsData.append(String(line))
                }
                self.parseAtomData()
                self.atomsData.removeAll()
            }
        }
    }
}
