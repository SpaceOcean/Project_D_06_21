//
//  FilterDetailRecipesViewController.swift
//  Project_D_06_21
//
//  Created by Владислав Комсомоленко on 10.04.2022.
//

import UIKit

class FilterDetailRecipesViewController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBAction func checkboxTapped(_ sender: Any) {
        if filterName == "Подборка" {
            if delegate?.filter.currentGroupID == (sender as! UIButton).tag {
                delegate?.filter.isCurrentGroupSelected = false
                delegate?.filter.currentGroupID = -1
            } else {
                delegate?.filter.isCurrentGroupSelected = true
                delegate?.filter.currentGroupID = (sender as! UIButton).tag
            }
            
        } else if filterName == "Сложность" {
            if delegate?.filter.currentDifficultyID == (sender as! UIButton).tag {
                delegate?.filter.isCurrentDifficultySelected = false
                delegate?.filter.currentDifficultyID = -1
            } else {
                delegate?.filter.isCurrentDifficultySelected = true
                delegate?.filter.currentDifficultyID = (sender as! UIButton).tag
            }
        }
        delegate?.uploadRecipeTable()
        table.reloadData()
    }
    
    let largeConfig = UIImage.SymbolConfiguration(scale: .large)
    var delegate: FilterRecipeDelegate?
    var filterName: String = "    Фильтр"
    var isGroupScreen = false
    var elements: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainLabel.frame = self.mainLabel.frame.inset(by: UIEdgeInsets(top: 80, left: 0, bottom: 40, right: 0))
        self.mainLabel.text = "    " + filterName
        
        if filterName == "Подборка" {
            isGroupScreen = true
            elements = delegate?.filter.allGroups ?? []
        } else if filterName == "Сложность" {
            isGroupScreen = false
            elements = delegate?.filter.allDifficultys ?? []
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "FilterRecipeCurrentDetail") as? FilterRecipeCurrentDetailTableViewCell {
            cell.filterName.text = elements[indexPath.row]
            cell.filterCheckbox.setImage(UIImage(systemName: "square", withConfiguration: largeConfig), for: .normal)
            cell.filterCheckbox.tag = indexPath.row
            if filterName == "Подборка" {
                if ((delegate?.filter.isCurrentGroupSelected) ?? false),
                   delegate?.filter.currentGroupID == indexPath.row {
                    cell.filterCheckbox.setImage(UIImage(systemName: "circle.inset.filled", withConfiguration: largeConfig), for: .normal)
                } else {
                    cell.filterCheckbox.setImage(UIImage(systemName: "circle", withConfiguration: largeConfig), for: .normal)
                }
            } else if filterName == "Сложность" {
                if ((delegate?.filter.isCurrentDifficultySelected) ?? false),
                   delegate?.filter.currentDifficultyID == indexPath.row {
                    cell.filterCheckbox.setImage(UIImage(systemName: "circle.inset.filled", withConfiguration: largeConfig), for: .normal)
                } else {
                    cell.filterCheckbox.setImage(UIImage(systemName: "circle", withConfiguration: largeConfig), for: .normal)
                }
            }
            return cell
        }
        
        return UITableViewCell()
        
    }

}
