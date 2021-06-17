//
//  RecipeDetailViewController.swift
//  Project_D_06_21
//
//  Created by Влад Комсомоленко on 15.06.2021.
//


import UIKit

class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var recipeImgView: UIImageView!
    @IBOutlet weak var recipeNameView: UILabel!
    
    
    
    var recipeName: String = ""
    var recipeImg: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeNameView.text = recipeName
        recipeImgView.image = UIImage(named: recipeImg)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
