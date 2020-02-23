//
//  Category.swift
//  Books
//
//  Created by Nikhil Dhavale on 23/02/20.
//  Copyright © 2020 Nikhil Dhavale. All rights reserved.
//

import Foundation
class CategoryJSON:Codable
{
    var categoryList:[Category]?
}
class Category:Codable
{
    var icon:String?
    var title:String?
}
