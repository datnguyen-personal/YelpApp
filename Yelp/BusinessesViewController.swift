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
    
    var filters: [Filter] = [
        Filter(title: "Deal",
            type: "1",
            filterValues: [
                FilterValue(name: "Offering a Deal", value: "false", on: true)
            ],
            code: "deals_filter",
            value: "true",
            activate: false,
            currentIndex: 0),
        
        Filter(title: "Distance",
            type: "2",
            filterValues: [
                FilterValue(name: "Auto", value: "", on: true),
                FilterValue(name: "0.3 miles", value: "480", on: false),
                FilterValue(name: "1 mile", value: "1605", on: false),
                FilterValue(name: "5 miles", value: "8050", on: false)
            ],
            code: "radius_filter",
            value: "",
            activate: false,
            currentIndex: 0),
        
        Filter(title: "Sort By",
            type: "2",
            filterValues: [
                FilterValue(name: "Best Match", value: "0", on: true),
                FilterValue(name: "Distance", value: "1", on: false),
                FilterValue(name: "Highest Rated", value: "2", on: false)
            ],
            code: "sort",
            value: "0",
            activate: false,
            currentIndex: 0),
        
        Filter(title: "Category",
            type: "3",
            filterValues: [
                FilterValue(name : "Afghan", value: "afghani", on: false),
                FilterValue(name : "African", value: "african", on: false),
                FilterValue(name : "American, New", value: "newamerican", on: false),
                FilterValue(name : "American, Traditional", value: "tradamerican", on: false),
                FilterValue(name : "Arabian", value: "arabian", on: false),
                FilterValue(name : "Argentine", value: "argentine", on: false),
                FilterValue(name : "Armenian", value: "armenian", on: false),
                FilterValue(name : "Asian Fusion", value: "asianfusion", on: false),
                FilterValue(name : "Asturian", value: "asturian", on: false),
                FilterValue(name : "Australian", value: "australian", on: false),
                FilterValue(name : "Austrian", value: "austrian", on: false),
                FilterValue(name : "Baguettes", value: "baguettes", on: false),
                FilterValue(name : "Bangladeshi", value: "bangladeshi", on: false),
                FilterValue(name : "Barbeque", value: "bbq", on: false),
                FilterValue(name : "Basque", value: "basque", on: false),
                FilterValue(name : "Bavarian", value: "bavarian", on: false),
                FilterValue(name : "Beer Garden", value: "beergarden", on: false),
                
            ],
            code: "categories_filter",
            value: "",
            activate: false,
            currentIndex: 0)
    ]
    
    var categories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantTableView.dataSource = self
        restaurantTableView.delegate = self
        
        restaurantTableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        restaurantTableView.estimatedRowHeight = 100
        restaurantTableView.rowHeight = UITableViewAutomaticDimension
        
        setupView()
        
        doSearch(filters)
        
        
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
            doSearch(filters)
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        doSearch(filters)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let navigationController = segue.destinationViewController as! UINavigationController
        
        let filterViewController = navigationController.topViewController as! FilterViewController
        
        filterViewController.delegate = self
        
        filterViewController.filters = filters
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
        self.filters = filters
        categories.removeAll()
        for category: FilterValue in filters[3].filterValues {
            if category.on {
                categories.append(category.value)
            }
        }
        
        print(categories)
        doSearch(filters)
    }

    func doSearch(filters: [Filter]){
        
        Business.searchWithTerm(restaurantSearchBar.text!, sort: filters[2].filterValues[filters[2].currentIndex].value, categories: categories, deals: filters[0].filterValues[filters[0].currentIndex].value, distance: filters[1].filterValues[filters[1].currentIndex].value) { (businesses:[Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.restaurantTableView.reloadData()
            self.restaurantSearchBar.endEditing(true)
        }
    }
}
