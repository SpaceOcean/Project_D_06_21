//
//  FilterRecipeViewController.swift
//  Project_D_06_21
//
//  Created by Владислав Комсомоленко on 10.04.2022.
//

import UIKit


class FilterRecipeViewController: UITableViewController {
    
    @IBOutlet weak var mainLabel: UILabel!
    
    struct filterRecipeItem {
        let name: String
        let neededCheckbox: Bool
        init(name: String, neededCheckbox: Bool) {
            self.name = name
            self.neededCheckbox = neededCheckbox
        }
    }
    
    let arrayOfFilters = [filterRecipeItem(name: "Полное совпадение ингредиентов", neededCheckbox: true),
                          filterRecipeItem(name: "Только мои рецепты", neededCheckbox: true),
                          filterRecipeItem(name: "Избранное", neededCheckbox: true),
                          filterRecipeItem(name: "Подборка", neededCheckbox: false),
                          filterRecipeItem(name: "Сложность", neededCheckbox: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainLabel.frame = self.mainLabel.frame.inset(by: UIEdgeInsets(top: 80, left: 0, bottom: 40, right: 0))
        
    }
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayOfFilters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if arrayOfFilters[indexPath.row].neededCheckbox {
           if let cell = tableView.dequeueReusableCell(withIdentifier: "FilterRecipe") as? FilterRecipeTableViewCell {
               cell.filterNameLabel.text = arrayOfFilters[indexPath.row].name
               
               return cell
           }
        
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FilterRecipeDetail") as? FilterRecipeDetailTableViewCell {
                cell.filterDetailName.text = arrayOfFilters[indexPath.row].name

                return cell
            }
//            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrayOfFilters[indexPath.row].neededCheckbox { } else {
            
        }
    }
    
}
