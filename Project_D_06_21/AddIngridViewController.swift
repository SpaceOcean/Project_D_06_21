//
//  AddIngridViewController.swift
//  Project_D_06_21
//
//  Created by Влад Комсомоленко on 21.06.2021.
//

import UIKit
import CoreData



class AddIngridViewController: UITableViewController{
 
    @IBOutlet var table: UITableView!
    var ingridients: [Ingridient] = []
    var allIngridients: [Ingridient] = []
    var category: Int = 0
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(ingridients.count)
        let fetchRequest: NSFetchRequest<Ingridient>  = Ingridient.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            allIngridients = try context.fetch(fetchRequest)

        } catch {
            print(error.localizedDescription)
        }
        
        if (category != 0) {
            let format = "category == " + String(category - 1)
            fetchRequest.predicate = NSPredicate(format: format)
        }
        do {
            ingridients = try context.fetch(fetchRequest)
            // ingridients.sort(by: { $0.name! < $1.name! })

        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingridients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngridientCell") as! AddIngridTableViewCell
        print("IngridientCell")
        print(ingridients.count)
        cell.textLabel?.text = ingridients[indexPath.row].name
        cell.addIngridButton.tag = indexPath.row
        cell.addIngridButton.addTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)
        return cell
    }

    @objc
     
    func addButtonTapped(sender:UIButton){
        let rowIndex:Int = sender.tag
        let normalIndex = allIngridients.firstIndex{$0 === ingridients[rowIndex]}!
        print(normalIndex)
        print(allIngridients[normalIndex].added)
        self.allIngridients[normalIndex].added = true
        print(allIngridients[normalIndex].added)
        // let ingrid = Ingridient(context: context)
        // ingrid.added = true
        
        do {
            try context.save()
        } catch let error as NSError {
            print("no save: \(error)")
        }
        // myIngridTable.reloadData()
    }
}
 
