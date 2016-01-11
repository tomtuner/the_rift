//
//  ViewController.swift
//  The Rift
//
//  Created by Thomas.Demeo on 11/9/15.
//  Copyright © 2015 American Well. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var friends = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Friends"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TRFriendsCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Summoner")
        
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            friends = results as! [NSManagedObject]
        }catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addFriend(sender: AnyObject) {
        let addFriendAlert = UIAlertController(title: "New Friend", message: "Add a new Summoner Name", preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Save", style: .Default, handler: { (action:UIAlertAction) -> Void in
            let textField = addFriendAlert.textFields!.first
            self.saveSummoner(textField!.text!)
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) {( action: UIAlertAction) -> Void in
            }
        
        addFriendAlert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        addFriendAlert.addAction(saveAction)
        addFriendAlert.addAction(cancelAction)
        
        presentViewController(addFriendAlert, animated: true, completion: nil)
    }
    
    func saveSummoner(name: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let summoner = NSEntityDescription.insertNewObjectForEntityForName("Summoner", inManagedObjectContext: managedContext) as! Summoner
        summoner.name = name
//        let summoner = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
//        summoner.setValue(name, forKey: "name")
        
        do {
            try managedContext.save()
            friends.append(summoner)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TRFriendsCell")
        
        let summoner = friends[indexPath.row]
        cell!.textLabel!.text = summoner.valueForKey("name") as? String
        return cell!
    }

}

