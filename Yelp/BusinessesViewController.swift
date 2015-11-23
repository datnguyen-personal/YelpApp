//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit


class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FilterViewControllerDelegate {

    @IBOutlet weak var restaurantTableView: UITableView!
    
    var businesses: [Business]!
    
    var restaurantSearchBar: UISearchBar!
    
    var filterButton: UIButton!
    
    var isSearching: Bool = false
    
    var searchResults: [Business]!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantTableView.dataSource = self
        restaurantTableView.delegate = self
        
        restaurantTableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        restaurantTableView.estimatedRowHeight = 100
        restaurantTableView.rowHeight = UITableViewAutomaticDimension
        
        
        setupView()

//        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
//            self.businesses = businesses
//            
//            for business in businesses {
//                println(business.name!)
//                println(business.address!)
//            }
//        })
        
        Business.searchWithTerm("Thai") { (businesses:[Business]!, error:NSError!) -> Void in
            self.businesses = businesses
            //print(businesses.count)
            self.restaurantTableView.reloadData()
        }
        
        
//        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
//            self.businesses = businesses
//            
//            self.restaurantTableView.reloadData()
//        }
        
        
    }
    
    func setupView(){
        //setup Navigation Bar
        navigationController?.navigationBar.barTintColor = UIColor(red: 196/255, green: 18/255, blue: 0/255, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
        navigationController?.navigationBar.tintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        //filter Button
//        filterButton = UIButton(frame: CGRectMake(0, 0, 60, 30))
//        filterButton.layer.cornerRadius = 8
//        filterButton.layer.borderWidth = 1
//        filterButton.layer.borderColor = UIColor(red: 185/255, green: 137/255, blue: 132/255, alpha: 1.0).CGColor
//        filterButton.setTitle("Filter", forState: UIControlState.Normal)
//        filterButton.titleLabel!.font = UIFont(name: "System", size: 12)
//        filterButton.tintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
//        let filterItem = UIBarButtonItem(customView: filterButton)
//        navigationItem.leftBarButtonItem = filterItem
        
        //setup Search bar
        restaurantSearchBar = UISearchBar()
        restaurantSearchBar.sizeToFit()
        restaurantSearchBar.placeholder = "Restaurant, Mexican, Thai, cusine..."
        restaurantSearchBar.delegate = self
        
        navigationItem.titleView = restaurantSearchBar
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        //restaurantTableView.reloadData()
        if searchBar.text == "" {
            Business.searchWithTerm("") { (businesses:[Business]!, error:NSError!) -> Void in
                self.businesses = businesses
                //print(businesses.count)
                self.restaurantTableView.reloadData()
                searchBar.endEditing(true)
                searchBar.text = ""
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        Business.searchWithTerm(searchBar.text!) { (businesses:[Business]!, error:NSError!) -> Void in
            self.businesses = businesses
            //print(businesses.count)
            self.restaurantTableView.reloadData()
            //searchBar.endEditing(true)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let navigationController = segue.destinationViewController as! UINavigationController
        
        let filterViewController = navigationController.topViewController as! FilterViewController
        
        filterViewController.delegate = self
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = restaurantTableView.dequeueReusableCellWithIdentifier("restaurantCell") as! RestaurantCell
        cell.business = businesses[indexPath.row]
        
        //cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil && businesses.count > 0 {
            return businesses.count
        } else {
            return 0
        }
    }
    
    func filterViewController(filtersViewController: FilterViewController, didUpdateFilters filters: [Filter]) {
        
        doSearch(filters)
    }

    func doSearch(filters: [Filter]){
        Business.searchWithTerm(restaurantSearchBar.text!, sort: filters[2].filterValues[filters[2].currentIndex].value, categories: [filters[3].filterValues[filters[3].currentIndex].value], deals: filters[0].filterValues[filters[0].currentIndex].value) { (businesses:[Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.restaurantTableView.reloadData()
        }
    }
}
