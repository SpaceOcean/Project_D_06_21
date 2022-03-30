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
    
    override func viewWillAppear(_ animated: Bool) {
        
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

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
        if let message = self.allIngridients[normalIndex].name {
            self.showToast(message: message + " добавлен", font: .systemFont(ofSize: 12.0))
        }
        do {
            try context.save()
        } catch let error as NSError {
            print("no save: \(error)")
        }
        // myIngridTable.reloadData()
    }

}

extension AddIngridViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: 20, y: self.view.frame.size.height-270, width: self.view.frame.size.width - 40, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 6.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }

 
