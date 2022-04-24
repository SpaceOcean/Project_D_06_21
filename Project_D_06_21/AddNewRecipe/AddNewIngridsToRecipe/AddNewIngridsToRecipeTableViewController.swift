//
//  AddNewIngridsToRecipeTableViewController.swift
//  Project_D_06_21
//
//  Created by Владислав Комсомоленко on 16.04.2022.
//

import UIKit
import CoreData

class AddNewIngridsToRecipeTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var newRecipe: NewRecipe = NewRecipe()
    
    @IBOutlet var table: UITableView!
    
    var fetchedResultsControllerAllMainIngrids: NSFetchedResultsController<MainIngridient>!
    var fetchedResultsController: NSFetchedResultsController<Ingridient>!
    var ingridients: [Ingridient] = []
    var allIngridients: [Ingridient] = []
    var allMainIngrids: [MainIngridient] = []
    private var filteredCurIngridients: [Ingridient] = []
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    
    var infoIngridItem: Ingridient = Ingridient()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewWillAppear(_ animated: Bool) {
        let fetchRequestAllMainIngrids: NSFetchRequest<MainIngridient> = MainIngridient.fetchRequest()
        let sortDescriptorAllMainIngrids = NSSortDescriptor(key: "name", ascending: true)
        fetchRequestAllMainIngrids.sortDescriptors = [sortDescriptorAllMainIngrids]
        fetchedResultsControllerAllMainIngrids = NSFetchedResultsController(fetchRequest: fetchRequestAllMainIngrids, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsControllerAllMainIngrids.delegate = self
        do {
            try fetchedResultsControllerAllMainIngrids.performFetch()
            allMainIngrids = fetchedResultsControllerAllMainIngrids.fetchedObjects!
            allMainIngrids = try context.fetch(fetchRequestAllMainIngrids)

        } catch {
            print(error.localizedDescription)
        }
        
        
        let fetchRequest: NSFetchRequest<Ingridient>  = Ingridient.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            allIngridients = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        do {
            ingridients = try context.fetch(fetchRequest)

        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.setValue("Закрыть", forKey: "cancelButtonText")
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCurIngridients.count
        }
        return ingridients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var ingrid: Ingridient
        if isFiltering {
            ingrid = filteredCurIngridients[indexPath.row]
        } else {
            ingrid = ingridients[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "addNewIngridsToRecipe") as! AddNewIngridsToRecipeTableViewCell
        cell.addIngrigNameLabel.text = ingrid.name
        cell.addIngridButton.tag = indexPath.row
        cell.addIngridButton.addTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)
        
        let largeConfig = UIImage.SymbolConfiguration(scale: .large)
        
        if let _ = (newRecipe.ingridNormalIndex)?.firstIndex(of: Int(ingrid.curIndex))  {
            cell.addIngridButton.setImage(UIImage(systemName: "checkmark.square", withConfiguration: largeConfig), for: .normal)
        } else {
            cell.addIngridButton.setImage(UIImage(systemName: "square", withConfiguration: largeConfig), for: .normal)
        }
        
        return cell
    }


    @objc func addButtonTapped(sender: UIButton) {
        let rowIndex:Int = sender.tag
        let normalIndex: Int
        
        if isFiltering {
            normalIndex = allIngridients.firstIndex{$0 === filteredCurIngridients[rowIndex]}!
        } else {
            normalIndex = allIngridients.firstIndex{$0 === ingridients[rowIndex]}!
        }
        
        
        if let index = newRecipe.ingridNormalIndex?.firstIndex(of: normalIndex)  {
            (newRecipe.ingridNormalIndex)?.remove(at: index)
        } else {
            (newRecipe.ingridNormalIndex)?.append(normalIndex)
        }
        
        if let bufIngridNormalIndex = newRecipe.ingridNormalIndex {
            var bufIngredients = ""
            var bufIngridIndex: [Int] = []
            for normalIngridIndex in bufIngridNormalIndex {
                let normalIngrid = ingridients[normalIngridIndex]
                let ingridIndex = Int(normalIngrid.index?.components(separatedBy: ";")[0] ?? "-1")
                if let ingridIndex = ingridIndex {
                    bufIngridIndex.append(ingridIndex)
                    if let bufMainIngrid = allMainIngrids[ingridIndex+1].name {
                        bufIngredients = bufIngredients + String(bufMainIngrid) + ";"
                    }
                }
            }
            
            if bufIngredients.count != 0 {
                bufIngredients = String(bufIngredients.dropLast())
                newRecipe.ingredients = bufIngredients
                newRecipe.ingridIndex = bufIngridIndex
            }
            
        } else {
            
        }
        table.reloadData()
    }

    
}
 
extension AddNewIngridsToRecipeTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredCurIngridients = ingridients.filter({ (ingrid: Ingridient) -> Bool in
            return ingrid.name?.lowercased().contains(searchText.lowercased()) ?? false
        })
        table.reloadData()
    }
}
