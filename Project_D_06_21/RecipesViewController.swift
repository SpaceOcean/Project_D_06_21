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
    var fetchedResultsController: NSFetchedResultsController<Ingridient>!
    var recipeFetchedResultsController: NSFetchedResultsController<Ingridient>!
    var curIngridientsIndex: [Int] = []
    var curIngridients: [Ingridient] = []
    var recipes: [Recipe] = []
    var allIngrids: [MainIngridient] = []

    private func uploadIngridMatch() {
        let recipeFetchRequest: NSFetchRequest<Recipe>  = Recipe.fetchRequest()
        do {
            recipes = try context.fetch(recipeFetchRequest)

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
        
            // print(recipes)
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        uploadIngridMatch()
        
        let sortRecipeFetchRequest: NSFetchRequest<Recipe>  = Recipe.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "ingridMatch", ascending: false)
        sortRecipeFetchRequest.sortDescriptors = [sortDescriptor]

        do {
            recipes = try context.fetch(sortRecipeFetchRequest)

        } catch {
            print(error.localizedDescription)
        }
        self.recipesTable.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    
    
    // MARK: - TABLE VIEW CELL
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        
        cell.textLabel?.text = recipes[indexPath.row].name
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! RecipeDetailViewController
                dvc.recipeName = "Коэффициент совпадения: \(self.recipes[indexPath.row].ingridMatch)"
                dvc.recipeImg = self.recipes[indexPath.row].img!
            }
        }
    }


}

