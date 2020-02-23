//
//  BooksCollectionViewController.swift
//  Books
//
//  Created by Nikhil Dhavale on 23/02/20.
//  Copyright © 2020 Nikhil Dhavale. All rights reserved.
//

import UIKit
struct BooksConstant {
    static let identifier = "BookCollectionViewCell"
    static let widthMargin = CGFloat(20)
    static let ratio = CGFloat(265.0/200.0)
}

class BooksCollectionViewController: UICollectionViewController {
    var bookList = [Book]()
    {
        didSet{
            DispatchQueue.main.async {
                self.collectionView?.reloadData()

            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "BookCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: BooksConstant.identifier)
        setItemWidth()
        
    }
    func setItemWidth()
    {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout
          {
            let count = CGFloat(3)
            
            var width = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - BooksConstant.widthMargin - count*10
            width = width/count
            let height = CGFloat(265)
            layout.itemSize = CGSize(width: width, height: height)
          }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil, completion: {(context) in
            self.setItemWidth()
            self.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource




    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return bookList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BooksConstant.identifier, for: indexPath) as! BookCollectionViewCell
        let book = bookList[indexPath.row]
        cell.updateCell(book: book)
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
