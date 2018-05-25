//
//  PostedQuestionsTableViewController.swift
//  InterviewMeApp
//
//  Created by Kimba Hintze on 5/23/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import Firebase

class PostedQuestionsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Actions
    
    @IBAction func addQButtonTapped(_ sender: Any) {
        
        let userID = Auth.auth().currentUser?.uid
        
        let alert = UIAlertController(title: "Got a question?", message: nil, preferredStyle: .alert)
        let add = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let question = alert.textFields?[0].text else { return }
        }
        let questionTF = alert.addTextField { (textfield) in
            textfield.placeholder = "Type your question here..."
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(add)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
