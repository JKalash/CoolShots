//
//  ViewController.swift
//  CoolShots
//
//  Created by Joseph Kalash on 3/18/16.
//  Copyright © 2016 Joseph Kalash. All rights reserved.
//

import UIKit

class SearchResultsController: UICollectionViewController {

    let searchController = UISearchController(searchResultsController: nil)
    
    let manager = SearchResultsManager()
    let historyController = UISearchHistoryController()
    
    let resultsPerRow = 4

    override func viewDidLoad() {
        
        //searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.enablesReturnKeyAutomatically = false
        
        //ensure that the search bar does not remain on the screen if the user navigates to
        //another view controller while the UISearchController is active
        definesPresentationContext = true
        
        //Place the search bar in the titleView to allow enough space for the search results
        self.navigationItem.titleView = searchController.searchBar
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        manager.delegate = self
        
        //Setup out history controller's table
        historyController.tableView.frame = CGRectMake(0, 64, self.view.frame.width, self.view.frame.height-64)
        historyController.tableView.hidden = true
        historyController.delegate = self
        self.view.addSubview(historyController.tableView)
        
        super.viewDidLoad()
    }
    
    //MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.images.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 0.5 * CGFloat(resultsPerRow-1)) / CGFloat(resultsPerRow)
        return CGSizeMake(width, width)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("resultCell", forIndexPath: indexPath) as UICollectionViewCell
        
        let imgView = cell.contentView.viewWithTag(1) as! UIImageView
        if let data = manager.images[indexPath.item].thumb_data {
            imgView.hidden = false
            imgView.image = UIImage(data : data)
        }
        else { imgView.hidden = true }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //If searchbar not dismissed, save in history
        if searchController.searchBar.isFirstResponder() {
            searchController.searchBar.resignFirstResponder()
            historyController.addToHistory(searchController.searchBar.text!)
        }
        
        let imageVC = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("ImageController") as! ImageController
        imageVC.image = manager.images[indexPath.item]
        self.navigationController?.pushViewController(imageVC, animated: true)
    }
    
    //Detect if scrolled to bottom to load more images
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //If scrolling with keyboard set
        //Disable Keyboard & Add to history
        if searchController.searchBar.isFirstResponder() {
            
            if searchController.searchBar.text != nil && searchController.searchBar.text != "" {
                self.historyController.addToHistory(searchController.searchBar.text!)
            }
            
           searchController.searchBar.resignFirstResponder()
        }
        
        if manager.images.count == 0 {return}
        
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        let reload_distance = 10;
        
        if y > h + CGFloat(reload_distance) {
            manager.searchForQuery(searchController.searchBar.text)
        }
    }
    
}

extension SearchResultsController : UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        //Hide History
        if searchText == "" && historyController.history.count > 0 {
            historyController.tableView.hidden = false
        }
        else {
            historyController.tableView.hidden = true
        }
        
        manager.searchForQuery(searchText)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        //Show History 
        if historyController.history.count > 0 {
            historyController.tableView.hidden = false
        }
        
        //Hack the search button to give it a nice tint color
        addColorToUIKeyboardButton()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //Add to history
        if searchBar.text != nil && searchBar.text != "" {
            historyController.addToHistory(searchBar.text!)
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        historyController.tableView.hidden = true
    }
}

//MARK: SearchResultsManagerDelegate
extension SearchResultsController : SearchResultsManagerDelegate {
    
    func resultsManagerDidFetchNewData(manager: SearchResultsManager) {
        if self.manager.images.count == 0 {
            self.collectionView?.hidden = true
        }
        else {
            self.collectionView?.hidden = false
            dispatch_async(dispatch_get_main_queue(), { () -> Void in self.collectionView?.reloadData() })
        }
    }
}

//MARK: UISearchHistoryDelegate
extension SearchResultsController : UISearchHistoryDelegate {
    func didSelectHistory(manager: UISearchHistoryController, selection: String) {
        //Hide table View, Update & Resign SearchBar, and perform the search
        self.historyController.tableView.hidden = true
        self.searchController.searchBar.text = selection
        self.searchController.searchBar.resignFirstResponder()
        self.manager.searchForQuery(selection)
    }
}

//A Hack to add a custom tint color
//To the search buttton
extension SearchResultsController {
    
    func subviewsOfView(view : UIView, withType type:NSString) -> NSArray {
        let prefix = NSString(format: "<%@",type) as String
        let subViewsArray = NSMutableArray()
        for subview in view.subviews {
            let tempArray = subviewsOfView(subview, withType: type)
            for view in tempArray {
                subViewsArray.addObject(view)
            }
        }
        if view.description.hasPrefix(prefix) {
            subViewsArray.addObject(view)
        }
        return NSArray(array: subViewsArray)
    }
    
    func addColorToUIKeyboardButton() {
        for keyboardWindow in UIApplication.sharedApplication().windows {
            for keyboard in keyboardWindow.subviews {
                for view in self.subviewsOfView(keyboard, withType: "UIKBKeyplaneView") {
                    let newView = UIView(frame: (self.subviewsOfView(keyboard, withType: "UIKBKeyView").lastObject as! UIView).frame)
                    newView.frame = CGRectMake(newView.frame.origin.x + 2, newView.frame.origin.y + 1, newView.frame.size.width - 4, newView.frame.size.height - 3)
                    newView.backgroundColor = Helper.appColor()
                    newView.layer.cornerRadius = 4.0
                    view.insertSubview(newView, belowSubview: self.subviewsOfView(keyboard, withType: "UIKBKeyView").lastObject as! UIView)
                }
            }
        }
    }
}

