//
//  GutenbergCategoryCollectionViewController.swift
//  Books
//
//  Created by Nikhil Dhavale on 23/02/20.
//  Copyright © 2020 Nikhil Dhavale. All rights reserved.
//

import UIKit
struct CategoryConstant {
    static let categoryCell = "categoryCell"
    static let marginConstant = UIDevice.current.userInterfaceIdiom == .phone ? CGFloat(30): CGFloat(40)
    static let itemHeight = CGFloat(50)
    static let showBooks = "showBooks"
}

class GutenbergCategoryCollectionViewController: UICollectionViewController {
    var categoryList = [Category]()
    {
        didSet
        {
            collectionView?.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategoryList()
        if let layout = collectionViewLayout as?
            UICollectionViewFlowLayout{
            if UIDevice.current.userInterfaceIdiom == .pad
            {
                setItemSizeForiPad()
            }
            else
            {
                
                let itemWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)  - CategoryConstant.marginConstant

                layout.itemSize = CGSize(width:itemWidth , height: CategoryConstant.itemHeight)
            }

        }
    }
    func setItemSizeForiPad()
    {
        let width = UIScreen.main.bounds.width   - CategoryConstant.marginConstant
        var itemWidth = width
        if self.view.bounds.width > self.view.bounds.height
        {
           itemWidth =  width/3
        }
        else
        {
            itemWidth = width/2
        }
        if let layout = collectionViewLayout as?
                   UICollectionViewFlowLayout{
            layout.itemSize = CGSize(width:itemWidth , height: CategoryConstant.itemHeight)
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: {(context) in
            if self.traitCollection.userInterfaceIdiom == .pad
            {
                self.setItemSizeForiPad()
                self.collectionViewLayout.invalidateLayout()
                self.collectionView.reloadData()
            }
        })


    }
    func getCategoryList()
    {
        if let jsonString = Bundle.main.path(forResource: "category", ofType: "json")
        {
            let url = URL(fileURLWithPath: jsonString)
            if let data = try? Data(contentsOf: url)
            {
                if let category = try? JSONDecoder().decode(CategoryJSON.self, from: data)
                {
                    if let categoryArray = category.categoryList{
                        categoryList = categoryArray
                    }
                }
                
            }
            
        }
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
        return categoryList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryConstant.categoryCell, for: indexPath) as! CategoryCollectionViewCell
        let category = categoryList[indexPath.row]
        cell.updateCell(category:category )
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categoryList[indexPath.row]

        self.parent?.performSegue(withIdentifier: CategoryConstant.showBooks, sender: category)
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
