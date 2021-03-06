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
    @IBOutlet weak var loadingIndicator:UIView!
    @IBOutlet weak var searchBar:UISearchBar!
    var networkSession:NetworkSession?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        titleLabel.text = category?.title
        searchBar.setup()
        requestBooksForCategory(searchString: nil)
        
    }

   
    func requestBooksForCategory(searchString:String?)
    {
        
        if let categoryTitle = category?.title
        {
            networkSession?.cancel()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.loadingIndicator.isHidden = false

             networkSession = NetworkSession(completionBlock: {(data) in
                
                do
                {
                    let bookResponse = try JSONDecoder().decode(BookResponse.self, from: data)
                    
                    if  let bookList = bookResponse.bookList
                    {
                        DispatchQueue.main.async {
                            if let bookCollection = self.children.first as? BooksCollectionViewController
                            {
                                bookCollection.bookList = bookList
                                self.loadingIndicator.isHidden = true
                                UIApplication.shared.isNetworkActivityIndicatorVisible = false

                            }
                        }
                    }
                    
                }
                catch {
                    print(error)
                }
                
            }, errorBlock: {(error) in
                DispatchQueue.main.async {
                    self.loadingIndicator.isHidden = true
                  //  UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
            }, cancelBlock: {
                DispatchQueue.main.async {
                     self.loadingIndicator.isHidden = true
                   // UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            })
            
            var components = URLComponents()
            components.scheme = "https"
            components.host = "gutendex.com"
            components.path = URLConstant.books
            var queryItems = [URLQueryItem(name: URLConstant.queryTopic, value: categoryTitle.lowercased()),
                              URLQueryItem(name: URLConstant.mimeType, value: BookItemConstant.bookItemImage)]
            if let searchText = searchString
            {
                queryItems.append(URLQueryItem(name: URLConstant.search, value: searchText))
            }
            components.queryItems = queryItems
            networkSession?.setupGetRequest(url: components.url!)
            
            
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
extension BooksViewController:UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.requestBooksForCategory(searchString: searchText)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.borderColor = ColorConstant.blue
        searchBar.borderWidth = 1
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.requestBooksForCategory(searchString: searchBar.text)
        searchBar.borderWidth = 0

    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.requestBooksForCategory(searchString: searchBar.text)

    }
}
