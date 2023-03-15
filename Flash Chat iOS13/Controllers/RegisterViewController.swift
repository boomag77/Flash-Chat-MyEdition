
import UIKit

class RegisterViewController: UIViewController, AuthRequester {
    

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction private func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            var manager = AuthManager()
            manager.delegate = self
            manager.registerUser(withEmail: email, withPassword: password)
        }
        
    }
    
    func successfulAuth() {
        self.performSegue(withIdentifier: K.registerSegue, sender: self)
    }
    
}
