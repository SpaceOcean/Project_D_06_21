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
    
    var fetchedResultsController: NSFetchedResultsController<Ingridient>!
    var ingridients: [Ingridient] = []
    var allIngridients: [Ingridient] = []
    var curIngridients: [Ingridient] = []
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
            // ingridients.sort(by: { $0.name! < $1.name! })

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
        print("IngridientCell")
//        print(ingridients.count)
        cell.addIngrigNameLabel.text = ingrid.name
        cell.addIngridButton.tag = indexPath.row
        cell.addIngridButton.addTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)
        
        let largeConfig = UIImage.SymbolConfiguration(scale: .large)
        
        if let _ = (newRecipe.ingridNormalIndex)?.firstIndex(of: indexPath.row)  {
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
        
        print("newRecipe.ingridNormalIndex")
//        print(newRecipe.ingridNormalIndex)
        
        
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
