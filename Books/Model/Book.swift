//
//  Book.swift
//  Books
//
//  Created by Nikhil Dhavale on 23/02/20.
//  Copyright © 2020 Nikhil Dhavale. All rights reserved.
//

import Foundation
class BookResponse:Codable
{
    var bookList:[Book]?
    enum CodingKeys: String, CodingKey {
        case bookList = "results"
    }
}
class Book: Codable {
    var id:String?
    var title:String?
    var authors:[Author]?
    var subjects:[String]?
    var formats:[String:String]?
    var authorNames:String{
        var names = ""
        if let authorArray = authors{
            for author in authorArray{
                if names.count == 0
                {
                    names += author.name ?? ""
                }
                else if let name = author.name
                {
                    if name.count > 0
                    {
                        names += ", " + name
                    }
                }
            }
        }

        return names
    }
}
class Author:Codable {
    var name:String?
    var birth_year:Int?
    var death_year:Int?
}
