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
    var normalIngridients: [Ingridient] = []
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
    
    
    private func getNormalIngridientsList() {
        
        let fetchRequest: NSFetchRequest<Ingridient> = Ingridient.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            normalIngridients = fetchedResultsController.fetchedObjects!
            normalIngridients = try context.fetch(fetchRequest)

        } catch {
            print(error.localizedDescription)
        }
    }
    
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
        let sortRecipeFetchRequest: NSFetchRequest<Recipe>  = Recipe.fetchRequest()

        let sortRecipeDescriptor = NSSortDescriptor(key: "ingridMatch", ascending: false)
        sortRecipeFetchRequest.sortDescriptors = [sortRecipeDescriptor]
        do {
            recipes = uploadRecipesList(recipes: try context.fetch(sortRecipeFetchRequest))
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
            curIngridientsIndex.append(Int(ingrid.curIndex))
        }
        
        for recipe in recipes {
            var buf: Double = 0.0
            
            let ingridIntersection = Array(Set(curIngridientsIndex).intersection(Set(recipe.ingridNormalIndex ?? [])))
            
            recipe.ingridMatchCount = Int16(ingridIntersection.count)
            
            for ingrid in ingridIntersection {
                buf += normalIngridients[ingrid].weight
            }
            recipe.ingridMatch = buf / Double(recipe.ingridCount)
        }
        do {
            try context.save()
        } catch let error as NSError {
            print("no save: \(error)")
        }
        
        recipesTable.reloadData()
    }
    
    func getFilterArrays() {
        let sortRecipeFetchRequest: NSFetchRequest<Recipe>  = Recipe.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "ingridMatch", ascending: false)
        sortRecipeFetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            recipes = try context.fetch(sortRecipeFetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        self.filter.allGroups = recipes.map{ return $0.group ?? "" }.unique{ $0 }
        self.filter.allDifficultys = recipes.map{ return $0.difficulty ?? "" }.unique{ $0 }
        recipesTable.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        getNormalIngridientsList()
        getFilterArrays()
        uploadIngridMatch()
        
        recipesTable.reloadData()
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.setValue("Закрыть", forKey: "cancelButtonText")
        navigationItem.searchController = searchController
        definesPresentationContext = true
        recipesTable.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFilterArrays()

        uploadIngridMatch()
        
        recipesTable.reloadData()
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
            
            let image = UIImage(data: recipe.img!) ?? UIImage(named: "noPhoto.jpg")!
            cell.recipeImg.image = image
            cell.recipeName.text = recipe.name
            cell.ingridMatchLabel.text = "\(recipe.ingridMatchCount)/\(recipe.ingridCount)"
            if recipe.ingridCount == recipe.ingridMatchCount {
                cell.ingridMatchView.backgroundColor = UIColor.green.withAlphaComponent(0.85)
            } else if recipe.ingridMatchCount == 0 {
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
            
            let newRecipe = NewRecipe()
            dvc.newRecipe = newRecipe
            dvc.delegate = self
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

extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>()
        var arrayOrdered = [Element]()
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }

        return arrayOrdered
    }
}
