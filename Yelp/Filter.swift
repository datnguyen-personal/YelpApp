//
//  Filter.swift
//  Yelp
//
//  Created by Dat Nguyen on 22/11/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class Filter: NSObject {
    var title: String
    var type: String
    var filterValues: [FilterValue]
    var code: String
    var value: String
    var activate: Bool
    var currentIndex: Int
    
    init(title: String, type: String, filterValues: [FilterValue],
        code: String, value: String, activate: Bool, currentIndex: Int) {
        self.title = title
        self.type = type
        self.filterValues = filterValues
        self.code = code
        self.value = value
        self.activate = activate
        self.currentIndex = currentIndex
    }
}

class FilterValue: NSObject {
    var name: String
    var value: String
    var on: Bool
    
    init(name: String, value:String, on:Bool) {
        self.name = name
        self.value = value
        self.on = on
    }
}
