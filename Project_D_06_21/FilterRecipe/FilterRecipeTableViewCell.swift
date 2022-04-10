//
//  FilterRecipeTableViewCell.swift
//  Project_D_06_21
//
//  Created by Владислав Комсомоленко on 10.04.2022.
//

import UIKit

class FilterRecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var filterNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
