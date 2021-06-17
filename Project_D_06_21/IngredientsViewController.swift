//
//  IngredientsViewController.swift
//  Project_D_06_21
//
//  Created by Влад Комсомоленко on 15.06.2021.
//

import UIKit

class IngredientsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("test")
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "textLabel"
        return cell
    }

}
