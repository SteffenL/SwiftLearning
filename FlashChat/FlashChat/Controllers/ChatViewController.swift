//
//  ChatViewController.swift
//  FlashChat
//
//  Created by Steffen André Langnes on 17/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, KeyboardHelperDelegate {
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!

    private var messages = [Message]()
    private var keyboardHelper: KeyboardHelper?

    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.delegate = self
        messageTableView.dataSource = self
        keyboardHelper = KeyboardHelper(view: view, constraint: bottomLayoutConstraint)
        keyboardHelper!.delegate = self
        retrieveMessages()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageTableViewCell", for: indexPath) as! MessageTableViewCell
        let message = messages[indexPath.row]
        cell.senderLabel.text = message.sender
        cell.messageLabel.text = message.body
        return cell
    }

    func kbhTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.returnKeyType {
        case .send:
            sendMessage()
        default:
            return true
        }

        return false
    }

    @IBAction func logOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let error {
            print(error)
        }
    }

    private func retrieveMessages() {
        let db = Database.database().reference().child("Messages")
        db.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let sender = snapshotValue["Sender"]
            let messageBody = snapshotValue["MessageBody"]
            let message = Message(sender: sender!, body: messageBody!)
            self.messages.append(message)
            self.messageTableView.reloadData()
        }
    }

    private func sendMessage() {
        messageTextField.isEnabled = false
        let db = Database.database().reference().child("Messages")
        let email = Auth.auth().currentUser?.email!
        let messageBody = messageTextField.text!
        let messageDictionary = ["Sender": email, "MessageBody": messageBody]
        db.childByAutoId().setValue(messageDictionary) { (error, dbRef ) in
            if let err = error {
                print(err)
            } else {
                print("ok")
                self.messageTextField.text = ""
            }

            self.messageTextField.isEnabled = true
        }
    }
}

