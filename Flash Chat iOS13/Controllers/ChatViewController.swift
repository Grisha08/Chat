
import UIKit
import Firebase
class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var senderButton: UIButton!
    @IBOutlet weak var messageTextfield: UITextField!
    var messages :[Message] = []
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true//back disappear
        title = "⚡️FlashChat"
        
       messageTextfield.delegate = self
        senderButton.isHidden = true
        
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessage()
    }
    func loadMessage (){
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)// make seder
            .addSnapshotListener { guerySnapshot, error  in//get data when sender clicked 
            self.messages = []
                if error != nil{
                print("bla bla 2")
            }else{
                if let snapshotDocuments =  guerySnapshot?.documents{
                    for doc in snapshotDocuments{
                        
                     let data = doc.data()
                      if  let sender = data[K.FStore.senderField] as? String,
                          let body = data[K.FStore.bodyField] as? String{
                          let newMesagge = Message(sender: sender, body: body)
                          self.messages.append(newMesagge)
                          
                          DispatchQueue.main.async{
                              self.tableView.reloadData()//make data source metod work again
                              //scroll to the bottom
                              let IndexPath = IndexPath(row: self.messages.count - 1, section: 0)
                              self.tableView.scrollToRow(at: IndexPath, at: .top, animated: true)
                          }
                       }
                    }
                }
            }
        }
    }
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if  let messageBody = messageTextfield.text ,
            let messageSender = Auth.auth().currentUser?.email{
            
            db.collection(K.FStore.collectionName).addDocument(data: 
            [K.FStore.bodyField: messageBody,
             K.FStore.senderField: messageSender,
             K.FStore.dateField : Date().timeIntervalSince1970]) { error in
                
                if error != nil {
                    print("bla bla")
                }else {
                    print("good")
                    DispatchQueue.main.async{
                        self.messageTextfield.text = ""
                    }
                  
                }
            }
        }
    }
    @IBAction func LogOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
}
extension ChatViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        as! MessageCell2
        cell.label2.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView2.isHidden = true
            cell.rightImageView2.isHidden = false
            cell.messageBubble2.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
        cell.label2.textColor = UIColor(named: K.BrandColors.purple)
        }else{
            cell.leftImageView2.isHidden = false
            cell.rightImageView2.isHidden = true
            cell.messageBubble2.backgroundColor = UIColor(named: K.BrandColors.purple)
          cell.label2.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        return cell
    }
}

extension ChatViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
           senderButton.isHidden = false
        } else {
            senderButton.isHidden = true
        }
    }
}
