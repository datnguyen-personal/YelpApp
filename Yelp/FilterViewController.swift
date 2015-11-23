//
//  FilterViewController.swift
//  Yelp
//
//  Created by Dat Nguyen on 22/11/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import KVNProgress
import JTMaterialSwitch
import AIFlatSwitch

@objc protocol FilterViewControllerDelegate {
    func filterViewController(filtersViewController: FilterViewController, didUpdateFilters filters:[Filter])
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var filterTableView: UITableView!
    
    weak var delegate: FilterViewControllerDelegate?
    
    let filters: [Filter] = [
        Filter(title: "Deal",
            type: "1",
            filterValues: [
                FilterValue(name: "Offering a Deal", value: "true", on: true)
            ],
            code: "deals_filter",
            value: "true",
            activate: false,
            currentIndex: 0),
        
        Filter(title: "Distance",
            type: "2",
            filterValues: [
                FilterValue(name: "Auto", value: "", on: true),
                FilterValue(name: "0.3 mile", value: "483", on: false),
                FilterValue(name: "1 mile", value: "1610", on: false),
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
            type: "2",
            filterValues: [
                FilterValue(name : "All", value: "", on: true),
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
            currentIndex: 0),
    ]
    
    var loadedViews: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        filterTableView.dataSource = self
        filterTableView.delegate = self
        filterTableView.separatorColor = UIColor.clearColor()
        filterTableView.reloadData()
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 196/255, green: 18/255, blue: 0/255, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
        navigationController?.navigationBar.tintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = filterTableView.dequeueReusableCellWithIdentifier("filterCell") as! FilterCell
        
        cell.wrapView.layer.borderWidth=1
        cell.wrapView.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0).CGColor
        
        let filter = filters[indexPath.section]
        let filterValue = filter.filterValues[indexPath.row]
        
        cell.nameLabel.text = filterValue.name
        
        cell.selectionStyle = .None
        
        let switchView = AIFlatSwitch(frame: CGRectMake(0,0,25,25))
        
        switchView.selected = filters[indexPath.section].filterValues[indexPath.row].on
        
        switchView.trailStrokeColor = UIColor(red: 196/255, green: 18/255, blue: 0/255, alpha: 1.0)
        switchView.strokeColor = UIColor(red: 196/255, green: 18/255, blue: 0/255, alpha: 1.0)
        
        switch filter.type {
            
            case "1":
                
                switchView.addTarget(self, action: "onSwitchValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
            
            case "2":
                switchView.addTarget(self, action: "onSelectChanged:", forControlEvents: UIControlEvents.ValueChanged)
            
        default:
            cell.iconView = nil
        }
        
        cell.iconView.addSubview(switchView)
        
//        let rightConstraint = NSLayoutConstraint(item: switchView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: cell.iconView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
//        cell.iconView.addConstraint(rightConstraint)
        
        return cell
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filters.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let filter = filters[section]
        
        return filter.filterValues.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let filter = filters[section]
        return filter.title
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clearColor()
    }
    
    func onSwitchValueChanged(sender: AIFlatSwitch) -> Void {
        let cell = sender.superview?.superview?.superview?.superview as! FilterCell
        
        if let indexPath = filterTableView.indexPathForCell(cell) {
            let filter = self.filters[indexPath.section] as Filter
            let filterValue = filter.filterValues[indexPath.row]
            filterValue.on = sender.selected
        }
    }
    
    func onSelectChanged(sender: AIFlatSwitch) -> Void {
        let cell = sender.superview?.superview?.superview?.superview as! FilterCell
        
        if let indexPath = filterTableView.indexPathForCell(cell) {
            let filter = self.filters[indexPath.section] as Filter
            let filterValue = filter.filterValues[indexPath.row]
            let previousIndex = NSIndexPath(forRow: filter.currentIndex, inSection: indexPath.section)
            let previousFilterValue = filter.filterValues[filter.currentIndex]
            
            if previousIndex == indexPath {
                return
            }
            
//            if filter.type == "2" {
//                sender.selected = true
//            }
            
            //filters[indexPath.section].filterValues[previousIndex.row].on = false
            //filters[indexPath.section].filterValues[indexPath.row].on = true
            //filters[indexPath.section].currentIndex = indexPath.row
            
            filterValue.on = true
            previousFilterValue.on = false
            filter.currentIndex = indexPath.row
            
            self.filterTableView.reloadRowsAtIndexPaths([previousIndex, indexPath], withRowAnimation: .Automatic)
            
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    
    @IBAction func onSearchButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        delegate?.filterViewController(self, didUpdateFilters: filters)
    }
    
    @IBAction func onCancelButtonClicked(sender: AnyObject) {
    }

}
