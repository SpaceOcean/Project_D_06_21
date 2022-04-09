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
        let recipeFetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
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
        print(curIngridientsIndex)
        
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
        recipesTable.reloadData()
    }
    
    // MARK: - TABLE VIEW CELL
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RecipesTableViewCell") as? RecipesTableViewCell {
            
            let image = UIImage(named: recipes[indexPath.row].img ?? "noPhoto.jpg") ?? UIImage(named: "noPhoto.jpg")!
            cell.recipeImg.image = image
            cell.recipeName.text = recipes[indexPath.row].name
            let matchedIngrids = Int(recipes[indexPath.row].ingridMatch * Double(recipes[indexPath.row].ingridCount))
            cell.ingridMatchLabel.text = "\(matchedIngrids)/\(recipes[indexPath.row].ingridCount)"
            if recipes[indexPath.row].ingridCount == matchedIngrids {
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
                let dvc = segue.destination as! RecipeDetailViewController
                dvc.recipeItem = self.recipes[indexPath.row]
                dvc.arrayOfUserIngridients = curIngridientsIndex
                
            }
        }
    }


}

