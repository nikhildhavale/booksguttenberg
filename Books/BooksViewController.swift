//
//  BooksViewController.swift
//  Books
//
//  Created by Nikhil Dhavale on 23/02/20.
//  Copyright © 2020 Nikhil Dhavale. All rights reserved.
//

import UIKit

class BooksViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    var category:Category?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        titleLabel.text = category?.title
        requestBooksForCategory()
        
        
    }
    func requestBooksForCategory()
    {
        
        if let categoryTitle = category?.title
        {
            let networkSession = NetworkSession(completionBlock: {(data) in
                
                do
                {
                    let bookResponse = try JSONDecoder().decode(BookResponse.self, from: data)
                    
                        if  let bookList = bookResponse.bookList
                        {
                            DispatchQueue.main.async {
                               if let bookCollection = self.children.first as? BooksCollectionViewController
                               {
                                bookCollection.bookList = bookList

                                }
                            }
                        }
                    
                }
                catch {
                    print(error)
                }

            }, errorBlock: {(error) in
                
            }, cancelBlock: {
                
            })
            
            var components = URLComponents()
            components.scheme = "https"
            components.host = "gutendex.com"
            components.path = URLConstant.books
            components.queryItems = [URLQueryItem(name: URLConstant.queryTopic, value: categoryTitle.lowercased()),
                                     URLQueryItem(name: "mime_type", value: BookItemConstant.bookItemImage)]
            networkSession.setupGetRequest(url: components.url!)
            
            
        }
    }
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
