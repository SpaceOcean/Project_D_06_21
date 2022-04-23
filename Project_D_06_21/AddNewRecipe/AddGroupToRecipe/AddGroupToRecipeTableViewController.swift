//
//  AddGroupToRecipeTableViewController.swift
//  Project_D_06_21
//
//  Created by Владислав Комсомоленко on 23.04.2022.
//

import UIKit

class AddGroupToRecipeTableViewController: UITableViewController {
    
    var delegate: FilterRecipeDelegate?
    var newRecipe: NewRecipe = NewRecipe()
    var currentCategory: Int?
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet weak var addNewGroupTF: UITextField!
    @IBOutlet weak var addNewGroupButton: UIButton!
    
    @IBAction func addNewGroupButtonTapped(_ sender: Any) {
        self.addNewGroupTF.resignFirstResponder()
        
        self.newRecipe.group = self.addNewGroupTF.text
        
        currentCategory = -1
        table.reloadData()
        
        showToast(message: "Категория добавлена!", font: .systemFont(ofSize: 12.0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !(newRecipe.group ?? "").isEmpty {
            if let curGroupIndex = self.delegate?.filter.allGroups.firstIndex(where: {$0 == newRecipe.group}) {
                currentCategory = curGroupIndex
            } else {
                addNewGroupTF.text = newRecipe.group
            }
        }

        addNewGroupTF.returnKeyType = .done
        addNewGroupTF.autocapitalizationType = .words
        addNewGroupTF.autocorrectionType = .no
        addNewGroupTF.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.filter.allGroups.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addNewGroupToRecipe", for: indexPath) as! AddGroupToRecipeTableViewCell

        cell.groupLabel.text = delegate?.filter.allGroups[indexPath.row]
        cell.addGroupButton.tag = indexPath.row
        cell.addGroupButton.addTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)

        
        let largeConfig = UIImage.SymbolConfiguration(scale: .large)
        
        if indexPath.row == currentCategory  {
            cell.addGroupButton.setImage(UIImage(systemName: "checkmark.square", withConfiguration: largeConfig), for: .normal)
        } else {
            cell.addGroupButton.setImage(UIImage(systemName: "square", withConfiguration: largeConfig), for: .normal)
        }
        
        return cell
    }
    
    @objc func addButtonTapped(sender: UIButton) {
        let rowIndex:Int = sender.tag
        
        if rowIndex == currentCategory {
            showToast(message: "Категория удалена!", font: .systemFont(ofSize: 12.0))
            currentCategory = -1
            self.newRecipe.group = ""
            
        } else {
            showToast(message: "Категория добавлена!", font: .systemFont(ofSize: 12.0))
            currentCategory = rowIndex
            self.newRecipe.group = self.delegate?.filter.allGroups[rowIndex]
        }
        
        table.reloadData()
    }
}

extension AddGroupToRecipeTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        self.addNewGroupTF.resignFirstResponder()
        
        self.newRecipe.group = self.addNewGroupTF.text

        showToast(message: "Категория добавлена!", font: .systemFont(ofSize: 12.0))
        
        currentCategory = -1
        table.reloadData()
        
        return true
    }
    
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: 20, y: Int(self.view.frame.size.height) - 135, width: Int(self.view.frame.size.width) - 40, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
