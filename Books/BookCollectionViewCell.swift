//
//  BookCollectionViewCell.swift
//  Books
//
//  Created by Nikhil Dhavale on 23/02/20.
//  Copyright © 2020 Nikhil Dhavale. All rights reserved.
//

import UIKit
struct BookItemConstant {
    static let bookItemImage = "image/jpeg"
}
class BookCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: SecureImageView!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func updateCell(book:Book)
    {
        if let bookImage = book.formats?[BookItemConstant.bookItemImage]
        {
            imageView.getImageWithImageId(bookImage, shouldSaveToDisk: false)
        }
        bookNameLabel.font = UIFont.BookName
        bookNameLabel.text = book.title?.uppercased()
        bookNameLabel.textColor = ColorConstant.darkergrey
        bookAuthorLabel.font = UIFont.BookAuthor
        bookAuthorLabel.text = book.authorNames
        bookAuthorLabel.textColor = ColorConstant.darkgrey
    }
}
