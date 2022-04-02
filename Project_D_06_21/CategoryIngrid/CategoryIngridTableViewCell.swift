//
//  CategoryIngridTableViewCell.swift
//  Project_D_06_21
//
//  Created by Владислав Комсомоленко on 01.04.2022.
//

import UIKit

class CategoryIngridTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryImg: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        
        contentView.layer.cornerRadius = 30
        contentView.layer.borderWidth = 2.0
        contentView.layer.borderColor = UIColor.black.cgColor
    }

}
