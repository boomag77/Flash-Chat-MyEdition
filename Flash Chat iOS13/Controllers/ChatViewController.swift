
import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let authManager = AuthManager()
    let storeManager = StoreManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = K.appName
        navigationItem.hidesBackButton = true
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        storeManager.delegate = self
        
    }
    
    //MARK: -- buttons beheiviers (IBActions)
    
    @IBAction private func sendPressed(_ sender: UIButton) {
        guard messageTextfield.text! != "" else { return }
        if let messageBody = messageTextfield.text,
           let messageSender = authManager.getCurrentUser() {
            
            storeManager.saveData(
                messageSender: messageSender,
                messageBody: messageBody
            )
            
        }
        messageTextfield.text = nil
    }
    
    @IBAction private func logOutPressed(_ sender: UIBarButtonItem) {
        storeManager.stopFetching()
        authManager.delegate = self
        authManager.logOut()
    }
}

//MARK: -- Extensions

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return storeManager.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = storeManager.messages[indexPath.row]
        let currentUser = authManager.getCurrentUser()!
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: K.cellIdentifier,
            for: indexPath)
            as! MessageCell
        
        cell.label.text = message.body
        
        if message.sender == currentUser {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.MessageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.MessageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        
        return cell
    }
}

extension ChatViewController: DataRequester {
    
    func updateMessages() {
        DispatchQueue.main.async {
            
            //guard !self.storeManager.messages.isEmpty else { return }
            self.tableView.reloadData()
            let lastRow = self.tableView.numberOfRows(inSection: 0)
            guard lastRow > 1 else {return}
            let indexPath = IndexPath(row: lastRow - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            //self.tableView.scrollToBottom()
        }
    }
}

extension ChatViewController: AuthRequester {
    func successfulAuth() {
        navigationController?.popToRootViewController(animated: true)
    }
}

//extension UITableView {
//
//    func scrollToBottom(isAnimated:Bool = true){
//
//        DispatchQueue.main.async {
//            let indexPath = IndexPath(
//                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
//                section: self.numberOfSections - 1)
//            if self.hasRowAtIndexPath(indexPath: indexPath) {
//                self.scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
//            }
//        }
//    }
//
//    func scrollToTop(isAnimated:Bool = true) {
//
//        DispatchQueue.main.async {
//            let indexPath = IndexPath(row: 0, section: 0)
//            if self.hasRowAtIndexPath(indexPath: indexPath) {
//                self.scrollToRow(at: indexPath, at: .top, animated: isAnimated)
//           }
//        }
//    }
//
//    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
//        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
//    }
//}

//extension ChatViewController: UITextFieldDelegate {
//
//    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        <#code#>
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        textField.text = nil
//        print("Did end editing")
//    }
//}
