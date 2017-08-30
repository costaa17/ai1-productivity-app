//
//  ViewController.swift
//  My Great Productivity App
//
//  Created by Ana Vitoria do Valle Costa on 1/31/17.
//  Copyright © 2017 Ana Vitoria do Valle Costa. All rights reserved.
//

import UIKit
import CoreData

var groups: [NSManagedObject] = []
let colorsArray = ["White", "Blue", "Green", "Purple", "Orange", "Dark Blue", "Pink", "Dark Green", "Yellow", "Gray", "Red"]
var cur: NSManagedObject?
var curArr: [NSManagedObject] = []

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create initial lists on first open
        let launchedBefore = UserDefaults.standard.bool(forKey: "launched")
        if !launchedBefore {
            
            let toAddArr = ["All","Today","This Week","Overdue"]
            
            for list in toAddArr {
                self.saveList(name: list, color: "White")
            }
            
            UserDefaults.standard.set(true, forKey: "launched")
            
        } else {
            UserDefaults.standard.set(true, forKey: "launched")
        }
        
    }
    
    func saveList(name: String, color: String) {
        
        if let managedContext = getManagedContext() {
            
            let entity = NSEntityDescription.entity(forEntityName: "List",
                                                    in: managedContext)!
            
            let list = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
            
            list.setValue(name, forKeyPath: "name")
            list.setValue(color, forKey: "color")
            
            saveManagedContext(managedContext: managedContext)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //When done button clicked -> save
        
        backButtonUpdateCur()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "List")
        let predicate = NSPredicate(format: "name = %@", argumentArray: [segue.identifier!])
        fetchRequest.predicate = predicate
        
        fetchGroups(fetchRequest: fetchRequest)
        
        cur = groups[0]
        curArr.append(cur!)
        updateGroups()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

