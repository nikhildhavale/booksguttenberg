//
//  CategoryCollectionViewCell.swift
//  Books
//
//  Created by Nikhil Dhavale on 23/02/20.
//  Copyright © 2020 Nikhil Dhavale. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryIconView: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    func updateCell(category:Category)
    {
        categoryTitle.text = category.title
        if let iconName = category.icon
        {
            categoryIconView.image = UIImage(named: iconName)
        }
    }
}
