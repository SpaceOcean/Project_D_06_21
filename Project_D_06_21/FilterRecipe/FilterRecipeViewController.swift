//
//  FilterRecipeViewController.swift
//  Project_D_06_21
//
//  Created by Владислав Комсомоленко on 10.04.2022.
//

import UIKit

class Filters {
    var fullMatch: Bool = false
    var onlyMy: Bool = false
    var onlyFavorities: Bool = false
    var currentGroupID: Int = -1
    var isCurrentGroupSelected: Bool = false
    var currentDifficultyID: Int = -1
    var isCurrentDifficultySelected: Bool = false
    var allGroups: [String] = []
    var allDifficultys: [String] = []
    
    init() {
        self.fullMatch = false
        self.onlyMy = false
        self.onlyFavorities = false
        self.currentGroupID = -1
        self.isCurrentGroupSelected = false
        self.currentDifficultyID = -1
        self.isCurrentDifficultySelected = false
        self.allGroups = []
        self.allDifficultys = []
    }
}

protocol FilterRecipeDelegate: NSObjectProtocol {
    func uploadRecipeTable()
    var filter: Filters { get }
}




class FilterRecipeViewController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet weak var mainLabel: UILabel!
    
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        let rowIndex:Int = (sender as! UIButton).tag
        switch rowIndex {
            case 0:
                delegate?.filter.fullMatch = !(delegate?.filter.fullMatch ?? true)
            
            case 1:
                delegate?.filter.onlyMy = !(delegate?.filter.onlyMy ?? true)
            
            case 2:
                delegate?.filter.onlyFavorities = !(delegate?.filter.onlyFavorities ?? true)
            default:
                print("error")
        }
        table.reloadData()
    }
    
    var delegate: FilterRecipeDelegate?
    
    let largeConfig = UIImage.SymbolConfiguration(scale: .large)
    
    struct filterRecipeItem {
        let name: String
        let neededCheckbox: Bool
        let filterID: Int
        init(name: String, neededCheckbox: Bool, filterID: Int) {
            self.name = name
            self.neededCheckbox = neededCheckbox
            self.filterID = filterID
        }
    }
    
    let arrayOfFilters = [filterRecipeItem(name: "Полное совпадение ингредиентов", neededCheckbox: true, filterID: 0),
                          filterRecipeItem(name: "Только мои рецепты", neededCheckbox: true, filterID: 1),
                          filterRecipeItem(name: "Избранное", neededCheckbox: true, filterID: 2),
                          filterRecipeItem(name: "Подборка", neededCheckbox: false, filterID: 3),
                          filterRecipeItem(name: "Сложность", neededCheckbox: false, filterID: 4)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainLabel.frame = self.mainLabel.frame.inset(by: UIEdgeInsets(top: 80, left: 0, bottom: 40, right: 0))
        
        table.reloadData()
        
        print("hui")
        print(delegate?.filter.fullMatch)
        print(delegate?.filter.onlyMy)
        print(delegate?.filter.onlyFavorities)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayOfFilters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if arrayOfFilters[indexPath.row].neededCheckbox {
           if let cell = tableView.dequeueReusableCell(withIdentifier: "FilterRecipe") as? FilterRecipeTableViewCell {
                cell.filterNameLabel.text = arrayOfFilters[indexPath.row].name
                cell.delegate = delegate
                cell.filterButton.setImage(UIImage(systemName: "square", withConfiguration: largeConfig), for: .normal)
                cell.filterButton.tag = indexPath.row
               
                switch indexPath.row {
                   case 0:
                       if delegate?.filter.fullMatch ?? false {
                           cell.filterButton.setImage(UIImage(systemName: "checkmark.square", withConfiguration: largeConfig), for: .normal)
                       } else if !(delegate?.filter.fullMatch ?? true)  {
                           
                           cell.filterButton.setImage(UIImage(systemName: "square", withConfiguration: largeConfig), for: .normal)
                       }
                   
                   case 1:
                       if delegate?.filter.onlyMy ?? false {
                           cell.filterButton.setImage(UIImage(systemName: "checkmark.square", withConfiguration: largeConfig), for: .normal)
                       } else if !(delegate?.filter.onlyMy ?? true)  {
                           
                           cell.filterButton.setImage(UIImage(systemName: "square", withConfiguration: largeConfig), for: .normal)
                       }
                   
                   case 2:
                       if delegate?.filter.onlyFavorities ?? false {
                           cell.filterButton.setImage(UIImage(systemName: "checkmark.square", withConfiguration: largeConfig), for: .normal)
                       } else if !(delegate?.filter.onlyFavorities ?? true)  {
                           
                           cell.filterButton.setImage(UIImage(systemName: "square", withConfiguration: largeConfig), for: .normal)
                       }
                   default:
                       print("error")
                }
               
               
               
               
               return cell
           }
        
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FilterRecipeDetail") as? FilterRecipeDetailTableViewCell {
                cell.filterDetailName.text = arrayOfFilters[indexPath.row].name
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filterDetailRecipes" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! FilterDetailRecipesViewController
                dvc.delegate = delegate
                dvc.filterName = arrayOfFilters[indexPath.row].name
            }
        }
    }
}
