//
//  RecipeDetailViewController.swift
//  Project_D_06_21
//
//  Created by Влад Комсомоленко on 15.06.2021.
//


import UIKit

class PreRecipeDetailViewController: UIViewController {

    @IBOutlet weak var scroller: UIScrollView!
    
    @IBOutlet weak var recipeImgView: UIImageView!
    
    @IBOutlet weak var recipeNameView: UILabel!
    @IBOutlet weak var recipeMatchView: UILabel!
    
    @IBOutlet weak var recipeGroupView: UILabel!
    @IBOutlet weak var recipeDifficultyView: UILabel!
    
    @IBOutlet weak var recipeIngridietsTableView: UITableView!
    @IBOutlet weak var recipeIngridientsTableHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var recipeDetailView: UILabel!
    
    var recipeItem: Recipe = Recipe()
    let defaultImg: String = "noPhoto"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myImage: UIImage = UIImage(named: recipeItem.img ?? defaultImg)!
        recipeNameView.text = recipeItem.name
        let matchCount = Int(Double(recipeItem.ingridCount) * recipeItem.ingridMatch)
        recipeMatchView.text = "Совпало \(matchCount) из \(recipeItem.ingridCount) ингредиентов"
        recipeDetailView.text = recipeItem.steps
        recipeGroupView.text = ["Подборка: ", recipeItem.group].compactMap { $0 }
        .joined(separator: " ")
        recipeDifficultyView.text = ["Сложность: ", recipeItem.difficulty].compactMap { $0 }
        .joined(separator: " ")
        recipeImgView.image = myImage
//        recipeImgView.layer.cornerRadius = 40
        
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scroller.isScrollEnabled = true
        // Do any additional setup after loading the view
//        scroller.contentSize = CGSize(width: 414, height: 2300)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.recipeIngridietsTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.recipeIngridietsTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object is UITableView {
            if let newValue = change?[.newKey] {
                let newSize = newValue as! CGSize
                self.recipeIngridientsTableHeight.constant = newSize.width
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


extension PreRecipeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsDetailCell", for: indexPath) as? IngredientsDetailViewCell {
            cell.ingridName.text = "\(indexPath.row)"
            
            return cell
        }
        
        return UITableViewCell()
    }
}
