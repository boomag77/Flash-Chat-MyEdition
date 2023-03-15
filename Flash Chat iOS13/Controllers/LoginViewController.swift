
import UIKit

class LoginViewController: UIViewController, AuthRequester {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction private func loginPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            var manager = AuthManager()
            manager.delegate = self
            manager.logIn(withEmail: email, withPassword: password)
        }
        
    }

    func successfulAuth() {
        self.performSegue(withIdentifier: K.loginSegue, sender: self)
    }

}
