//
//  RecipesTableViewCell.swift
//  Project_D_06_21
//
//  Created by Владислав Комсомоленко on 31.03.2022.
//

import UIKit

class RecipesTableViewCell: UITableViewCell {

    @IBOutlet weak var ingridMatchView: UIView!
    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var ingridMatchLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.ingridMatchView.layer.cornerRadius = 12
        self.ingridMatchView.layer.borderWidth = 1.0
        self.ingridMatchView.layer.borderColor = UIColor.black.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        
        contentView.layer.cornerRadius = 35
        contentView.layer.borderWidth = 2.0
        contentView.layer.borderColor = UIColor.black.cgColor
    }
}
