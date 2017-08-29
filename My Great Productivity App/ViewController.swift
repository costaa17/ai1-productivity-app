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
        //create list "All" on first open

        let launchedBefore = UserDefaults.standard.bool(forKey: "launched")
        if !launchedBefore  {
            self.saveList(name: "All", color: "White")
            self.saveList(name: "Today", color: "White")
            self.saveList(name: "This Week", color: "White")
            self.saveList(name: "Overdue", color: "White")
            UserDefaults.standard.set(true, forKey: "launched")
        }else{
            UserDefaults.standard.set(true, forKey: "launched")
        }
        
        /*guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "List")
        let predicate = NSPredicate(format: "name = %@ || name = %@ || name = %@ || name = %@", argumentArray: ["Overdue", "This Week", "Today", "All"])
        fetchRequest.predicate = predicate
        
        do {
            groups = try managedContext.fetch(fetchRequest)
            for i in groups {
                managedContext.delete(i)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        UserDefaults.standard.set(false, forKey: "launched")*/
    }
    
    func saveList(name: String, color: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "List",
                                                in: managedContext)!
        
        let list = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        list.setValue(name, forKeyPath: "name")
        list.setValue(color, forKey: "color")
        
        do {
            try managedContext.save()
            groups.append(list)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //When done button clicked -> save
        if segue.identifier == "Today" {
            if curArr.count > 0{
                curArr.removeLast()
            }
            if curArr.count == 0{
                cur = nil
            } else {
                cur = curArr.last
            }
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "List")
            let predicate = NSPredicate(format: "name = %@", argumentArray: ["Today"])
            fetchRequest.predicate = predicate
            do {
                groups = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            cur = groups[0]
            curArr.append(cur!)
            updateGroups()
        }
        
        if segue.identifier == "Overdue" {
            if curArr.count > 0{
                curArr.removeLast()
            }
            if curArr.count == 0{
                cur = nil
            }else{
                cur = curArr.last
            }
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "List")
            let predicate = NSPredicate(format: "name = %@", argumentArray: ["Overdue"])
            fetchRequest.predicate = predicate
            do {
                groups = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            cur = groups[0]
            curArr.append(cur!)
            updateGroups()
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

