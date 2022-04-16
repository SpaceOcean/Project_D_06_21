//
//  RecipesViewController.swift
//  Project_D_06_21
//
//  Created by Влад Комсомоленко on 15.06.2021.
//

import UIKit
import CoreData

class RecipesViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var recipesTable: UITableView!
    
    
    let myFilters = Filters()
    
    var fetchedResultsController: NSFetchedResultsController<Ingridient>!
    var recipeFetchedResultsController: NSFetchedResultsController<Ingridient>!
    var curIngridientsIndex: [Int] = []
    var curIngridients: [Ingridient] = []
    var recipes: [Recipe] = []
    var allIngrids: [MainIngridient] = []
    
    private var filteredRecipes: [Recipe] = []
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    private func uploadRecipesList(recipes: [Recipe]) -> [Recipe] {
        var filteredRecipesList = recipes
        if myFilters.onlyMy {
            filteredRecipesList = filteredRecipesList.filter { (recipe) in recipe.isMine == true }
        }
        if myFilters.fullMatch {
            filteredRecipesList = filteredRecipesList.filter { (recipe) in recipe.ingridMatch == 1.0 }
        }
        if myFilters.onlyFavorities {
            filteredRecipesList = filteredRecipesList.filter { (recipe) in recipe.isFavourite == true  }
        }
        if myFilters.isCurrentDifficultySelected {
            filteredRecipesList = filteredRecipesList.filter { (recipe) in recipe.difficulty == myFilters.allDifficultys[myFilters.currentDifficultyID]  }
        }
        if myFilters.isCurrentGroupSelected {
            filteredRecipesList = filteredRecipesList.filter { (recipe) in recipe.group == myFilters.allGroups[myFilters.currentGroupID]   }
        }
        
        return filteredRecipesList
    }
    
    private func uploadIngridMatch() {
        let recipeFetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        do {
            recipes = uploadRecipesList(recipes: try context.fetch(recipeFetchRequest))
        } catch {
            print(error.localizedDescription)
        }
        let fetchRequest: NSFetchRequest<Ingridient> = Ingridient.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "added = true")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            curIngridients = fetchedResultsController.fetchedObjects!
            curIngridients = try context.fetch(fetchRequest)

        } catch {
            print(error.localizedDescription)
        }
        
        curIngridientsIndex = []
        for ingrid in curIngridients {
            curIngridientsIndex.append(contentsOf: ingrid.index!.components(separatedBy: ";").map{ Int($0) ?? Int(-1)})
        }
        print(curIngridientsIndex)
        
        for recipe in recipes {
            let indexOfRecipe = Set(recipe.ingridIndex as! [Int])
            let buf = Array(indexOfRecipe.intersection(Set(curIngridientsIndex)))
            recipe.ingridMatch = Double(buf.count)/Double(recipe.ingridCount)
            // print(recipe.ingridMatch)
        }
        do {
            try context.save()
        } catch let error as NSError {
            print("no save: \(error)")
        }
        recipesTable.reloadData()
        
    }
    
    func getFilterArrays() {
        let recipeFetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        do {
            recipes = try context.fetch(recipeFetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        self.filter.allGroups = Array(Set(recipes.map{ return $0.group ?? "" }))
        self.filter.allDifficultys = Array(Set(recipes.map{ return $0.difficulty ?? "" }))
        recipesTable.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getFilterArrays()
        
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.setValue("Закрыть", forKey: "cancelButtonText")
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        uploadIngridMatch()
        
        let sortRecipeFetchRequest: NSFetchRequest<Recipe>  = Recipe.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "ingridMatch", ascending: false)
        sortRecipeFetchRequest.sortDescriptors = [sortDescriptor]

        do {
            recipes = uploadRecipesList(recipes: try context.fetch(sortRecipeFetchRequest))
        } catch {
            print(error.localizedDescription)
        }
        
        getFilterArrays()
    }
    
    // MARK: - TABLE VIEW CELL
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredRecipes.count
        }
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RecipesTableViewCell") as? RecipesTableViewCell {
            var recipe: Recipe
            
            if isFiltering {
                recipe = filteredRecipes[indexPath.row]
            } else {
                recipe = recipes[indexPath.row]
            }
            
            let image = UIImage(named: recipe.img ?? "noPhoto.jpg") ?? UIImage(named: "noPhoto.jpg")!
            cell.recipeImg.image = image
            cell.recipeName.text = recipe.name
            let matchedIngrids = Int(recipe.ingridMatch * Double(recipe.ingridCount))
            cell.ingridMatchLabel.text = "\(matchedIngrids)/\(recipe.ingridCount)"
            if recipe.ingridCount == matchedIngrids {
                cell.ingridMatchView.backgroundColor = UIColor.green.withAlphaComponent(0.85)
            } else if matchedIngrids == 0 {
                cell.ingridMatchView.backgroundColor = UIColor(red: 248, green: 0, blue: 0, alpha: 0.75)
            } else {
                cell.ingridMatchView.backgroundColor = UIColor.yellow.withAlphaComponent(0.85)
            }
            
            return cell
        }
        return UITableViewCell()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                var recipe: Recipe
                
                if isFiltering {
                    recipe = filteredRecipes[indexPath.row]
                } else {
                    recipe = recipes[indexPath.row]
                }
                
                let dvc = segue.destination as! RecipeDetailViewController
                dvc.recipeItem = recipe
                dvc.arrayOfUserIngridients = curIngridientsIndex
            }
        }
        
        if segue.identifier == "filterRecipes" {
            let dvc = segue.destination as! FilterRecipeViewController
            dvc.delegate = self
        }
        
        if segue.identifier == "addRecipe" {
            let dvc = segue.destination as! AddNewRecipeTableViewController
            dvc.newRecipe = Recipe()

        }
    }


}

extension RecipesViewController: FilterRecipeDelegate {
    
    func uploadRecipeTable() {
        uploadIngridMatch()
    }
    
    var filter: Filters {
        get {
            return myFilters
        }
    }
}

extension RecipesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredRecipes = recipes.filter({ (recipe: Recipe) -> Bool in
            return recipe.name?.lowercased().contains(searchText.lowercased()) ?? false
        })
        recipesTable.reloadData()
    }
}
