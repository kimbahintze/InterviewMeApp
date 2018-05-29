//
//  AnswersViewController.swift
//  InterviewMeApp
//
//  Created by Kimba Hintze on 5/24/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit

class AnswersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    static var shared = AnswersViewController()
   
    var usersAnswers: [UserAnswer] = []
    // MARK: - Outlets
    @IBOutlet weak var usersAnswersTableView: UITableView!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        usersAnswersTableView.dataSource = self
        usersAnswersTableView.delegate = self
    }

    // MARK: - Actions
    @IBAction func postButtonTapped(_ sender: Any) {
    }
    
    // MARK: - Tableview datasource and delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return usersAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = usersAnswersTableView.dequeueReusableCell(withIdentifier: "userAnswerCell", for: indexPath)
        
        return cell
    }
    
    
   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
