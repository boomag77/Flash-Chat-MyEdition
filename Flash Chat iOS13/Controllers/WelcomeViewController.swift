
import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.isToolbarHidden = true
        
        titleLabel.text = ""
        
        DispatchQueue.main.async {
            self.startingAnimation(withInterval: 0.1)
        }
        
        
        
    }
    
    private func startingAnimation(withInterval interval: Double) {
        var charIndex = 0.0
        let titleText = K.appName
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: (interval * charIndex), repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
    }
    
}
