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
    
    var filters: [Filter]!
    
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
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        
        let filter = filters[indexPath.section]
        let filterValue = filter.filterValues[indexPath.row]
        
        cell.textLabel?.text = filterValue.name
        
        cell.selectionStyle = .None
        
        let selectView = AIFlatSwitch(frame: CGRectMake(0,0,25,25))
        
        selectView.selected = filters[indexPath.section].filterValues[indexPath.row].on
        
        selectView.trailStrokeColor = UIColor(red: 196/255, green: 18/255, blue: 0/255, alpha: 1.0)
        selectView.strokeColor = UIColor(red: 196/255, green: 18/255, blue: 0/255, alpha: 1.0)
        
        switch filter.type {
            
            case "1":
                
                selectView.addTarget(self, action: "onSwitchValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
            
            case "2":
                selectView.addTarget(self, action: "onSelectChanged:", forControlEvents: UIControlEvents.ValueChanged)
            case "3":
                selectView.addTarget(self, action: "onMultipleSelectChange:", forControlEvents: UIControlEvents.ValueChanged)
            
        default:
            print("empty")
        }
        
        cell.accessoryView = selectView
        
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
        let cell = sender.superview as! UITableViewCell
        
        if let indexPath = filterTableView.indexPathForCell(cell) {
            let filter = self.filters[indexPath.section] as Filter
            let filterValue = filter.filterValues[indexPath.row]
            filterValue.on = sender.selected
        }
    }
    
    func onSelectChanged(sender: AIFlatSwitch) -> Void {
        let cell = sender.superview as! UITableViewCell
        
        if let indexPath = filterTableView.indexPathForCell(cell) {
            let filter = self.filters[indexPath.section] as Filter
            let filterValue = filter.filterValues[indexPath.row]
            let previousIndex = NSIndexPath(forRow: filter.currentIndex, inSection: indexPath.section)
            let previousFilterValue = filter.filterValues[filter.currentIndex]
            
            if previousIndex == indexPath {
                sender.selected = true
                print("dimiss")
                return
            }
            
            
            filterValue.on = true
            previousFilterValue.on = false
            filter.currentIndex = indexPath.row
            
            filterTableView.reloadRowsAtIndexPaths([previousIndex, indexPath], withRowAnimation: .Automatic)
            
        }
    }
    
    func onMultipleSelectChange(sender: AIFlatSwitch) -> Void {
        let cell = sender.superview as! UITableViewCell
        
        if let indexPath = filterTableView.indexPathForCell(cell) {
            let filter = self.filters[indexPath.section] as Filter
            let filterValue = filter.filterValues[indexPath.row]
            
            filterValue.on = sender.selected
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
        dismissViewControllerAnimated(true, completion: nil)
    }

}
