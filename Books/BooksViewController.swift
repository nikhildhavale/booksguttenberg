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
                if let bookResponse = try? JSONDecoder().decode(BookResponse.self, from: data)
                {
                    if let bookCollection = self.children.first as? BooksCollectionViewController , let bookList = bookResponse.bookList{
                        bookCollection.bookList = bookList
                    }
                }
            }, errorBlock: {(error) in
                
            }, cancelBlock: {
                
            })
            let urlString =  URLConstant.baseurl + URLConstant.topic + categoryTitle.lowercased()
            
            networkSession.setupGetRequest(urlString: urlString)
            
            
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
