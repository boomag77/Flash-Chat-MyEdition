
import Foundation
import FirebaseFirestore

protocol DataRequester: UIViewController {
    
    func updateMessages()
}

class StoreManager {
    
    init () {
        DispatchQueue.main.async {
            self.fetchMessages()
        }
    }
    
    weak var delegate: DataRequester?
    
    let db = Firestore.firestore()
    var listener: ListenerRegistration?
    
    var messages: [Message] = []
    
    func saveData(messageSender: String, messageBody: String) {
      
        DispatchQueue.main.async {
            self.db.collection(K.FStore.collectionName).addDocument(
                data: [K.FStore.senderField: messageSender,
                       K.FStore.bodyField: messageBody,
                       K.FStore.dateField: Date().timeIntervalSince1970]) { (error) in
                if let e = error {
                    print("Issue saving data to firestore,\(e)")
                } else {
                    //print("Succesfuly saved data")
                }
            }
        }
        
    }
    
    private func extractMessage(data: [String:Any]) -> Message? {
        if let messageSeneder = data[K.FStore.senderField] as? String,
           let messageBody = data[K.FStore.bodyField] as? String {
            return Message(sender: messageSeneder, body: messageBody)
        }
        return nil
    }
    
    private func fetchMessages() {
        
        listener = db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                
                snapshot.documentChanges.forEach { [weak self] diff in
                    
                    switch diff.type {
                    case .added:
                        let data = diff.document.data()
                        if let newMessage = self?.extractMessage(data: data) {
                            self?.messages.append(newMessage)
                    }
                    case .modified:
                        print("Modified city: \(diff.document.data())")
                    default:
                        print("Removed city: \(diff.document.data())")
                    }
                }
                self.delegate?.updateMessages()
            }
        
    }
    
    func stopFetching() {
        listener?.remove()
    }
}


