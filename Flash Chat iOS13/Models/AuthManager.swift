
import Foundation
import FirebaseAuth

protocol AuthRequester: UIViewController {
    func successfulAuth()
}

class AuthManager {
    
    weak var delegate: AuthRequester?
    
    func registerUser(withEmail email: String, withPassword password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            self.checkAuth(error)
        }
    }
    
    func logIn(withEmail email: String, withPassword password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            self.checkAuth(error)
        }
    }
    
    func getCurrentUser() -> String? {
        
        let currentUser = Auth.auth().currentUser?.email
        return currentUser
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            checkAuth(nil)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
      
    }
    
    private func checkAuth(_ error: Error?) {
        if let e = error {
            print(e.localizedDescription)
            return
        }
        self.delegate?.successfulAuth()
    }
    
}
