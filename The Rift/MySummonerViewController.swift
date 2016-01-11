//
//  MySummonerViewController.swift
//  The Rift
//
//  Created by Thomas.Demeo on 11/9/15.
//  Copyright © 2015 American Well. All rights reserved.
//

import UIKit
import CoreData
import AFNetworking

class MySummonerViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var champions = [Int: NSManagedObject]()
    var matches = [NSManagedObject]()
    var summoner = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Me"
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Summoner")
        fetchRequest.predicate = NSPredicate(format: "isMe == %@", true)
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            summoner = results as! [NSManagedObject]
        }catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        if (summoner.count >= 1) {
            if let myId = summoner[0].valueForKey("summoner_id") as? NSInteger {
                title = summoner[0].valueForKey("name") as? String
                let fetchRequest = NSFetchRequest(entityName: "Champion")
                do {
                    let results =
                        try managedContext.executeFetchRequest(fetchRequest)
                    
                    let tempChampions = results as! [NSManagedObject]
                    for champion in tempChampions {
                        champions[champion.valueForKey("champion_id")! as! Int] = champion
                    }
                }catch let error as NSError {
                    print("Could not fetch \(error), \(error.userInfo)")
                }
                self.getMatchesForSummoner(myId)
            }else if let myName = summoner[0].valueForKey("name") as? String {
                title = myName
                self.getIdForSummoner(myName, summoner: summoner[0])
            }
        }else {
            let addMeAlert = UIAlertController(title: "New Summoner", message: "Add your Summoner Name", preferredStyle: .Alert)
            let saveAction = UIAlertAction(title: "Save", style: .Default, handler: { (action:UIAlertAction) -> Void in
                let textField = addMeAlert.textFields!.first
                self.saveSummoner(["name":textField!.text!], shouldGetIDAfter: true)
                self.getIdForSummoner(self.summoner[0].valueForKey("name") as! String, summoner: self.summoner[0])

                self.title = textField!.text
                self.tableView.reloadData()
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default) {( action: UIAlertAction) -> Void in
            }
            
            addMeAlert.addTextFieldWithConfigurationHandler {
                (textField: UITextField) -> Void in
            }
            
            addMeAlert.addAction(saveAction)
            addMeAlert.addAction(cancelAction)
            
            presentViewController(addMeAlert, animated: true, completion: nil)
        }
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TRMatchCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func getMatchesForSummoner(summoner_id: NSInteger) {
        // TODO: Need to add API key to this request (and all requests)
        let URL = NSURL(string: String(format: "https://na.api.pvp.net/api/lol/na/v1.3/game/by-summoner/%@/recent", String(summoner_id)))
        let params = ["api_key": "9f3f7872-b097-41d7-9915-8401c2467b5f"]
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let manager = AFHTTPSessionManager()
        
        manager.GET((URL?.absoluteString)!,
            parameters: params,
            success: { (task:NSURLSessionDataTask, responseObject:AnyObject) -> Void in
                let response:NSDictionary = responseObject as! NSDictionary
                let gamesArray = response.valueForKey("games") as! NSArray
                
                let sum = self.summoner[0] as? Summoner

                for game in gamesArray {
                    let match = NSEntityDescription.insertNewObjectForEntityForName("Match", inManagedObjectContext: managedContext) as? Match
                    match!.safeSetValuesForKeysWithDictionary(game as! NSDictionary, dateFormatter: nil)
                    match?.matchSummoner = sum
                    self.matches.append(match!)
                }
                
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
                self.tableView.reloadData()
                
//                let attributes = match.entity.attributesByName
//                for (key, _) in attributes {
//                    let value = response.objectForKey(key)
//                    if (value != nil) {
//                        match.setValue(value, forKey: key)
//                    }
//                    
//                }
               /* NSDictionary *attributes = [[myObj entity] attributesByName];
                for (NSString *attribute in attributes) {
                    id value = [jsonDict objectForKey:attribute];
                    if (value == nil) {
                        continue;
                    }
                    [myObj setValue:value forKey:attribute];
                }*/
                
            }) { (urlSession:NSURLSessionDataTask, error:NSError) -> Void in
                //
                let tom = error
        }
    }
    
    func getIdForSummoner(name: String, summoner: NSManagedObject) {
        // TODO: Need to add API key to this request (and all requests)
        let URL = NSURL(string: "https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/\(name)")
        let params = ["api_key": "9f3f7872-b097-41d7-9915-8401c2467b5f"]
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let manager = AFHTTPSessionManager()
        manager.GET((URL?.absoluteString)!,
            parameters: params,
            success: { (task:NSURLSessionDataTask, responseObject:AnyObject) -> Void in
                let response:NSDictionary = responseObject as! NSDictionary
                let summonerID = response.objectForKey(self.summoner[0].valueForKey("name") as! String)!.objectForKey("id")
                summoner.setValue(summonerID!, forKey: "summoner_id")
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
                NSLog("JSON: %@", responseObject.description);
            },
            failure: { (task:NSURLSessionDataTask, error:NSError) -> Void in
                NSLog("Error: %@", error);
        })
    }
    
    func saveSummoner(attributes: NSDictionary, shouldGetIDAfter: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let summoner = NSEntityDescription.insertNewObjectForEntityForName("Summoner", inManagedObjectContext: managedContext) as! Summoner
//        let summoner = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        for (key, value) in attributes {
            summoner.setValue(value, forKey: key as! String)
        }
        summoner.setValue(true, forKey: "isMe")
        
        do {
            try managedContext.save()
            self.summoner.append(summoner)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    

    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TRMatchCell")
        
        let match = matches[indexPath.row]
        let champ = champions[(match.valueForKey("championId") as! Int)]

        cell!.textLabel!.text = champ?.valueForKey("name") as? String
        return cell!
    }

}
