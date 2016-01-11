//
//  SettingsManager.swift
//  The Rift
//
//  Created by Thomas.Demeo on 1/2/16.
//  Copyright © 2016 American Well. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import AFNetworking

extension NSManagedObject {
    func safeSetValuesForKeysWithDictionary(keyedValues: NSDictionary, dateFormatter: NSDateFormatter?) {
        let attributes:NSDictionary = self.entity.attributesByName
        
        for (key, _) in attributes {
            var value = keyedValues.objectForKey(key)
            if (value == nil) {
                // Don't attempt to set nil, or you will overwrite values in self that aren't present in key
                continue;
            }
            let attributeType = (attributes.objectForKey(key) as! NSAttributeDescription).attributeType
            if ((attributeType == .StringAttributeType) && (value!.isKindOfClass(NSNumber))) {
                value = value?.stringValue
            } else if (((attributeType == .Integer16AttributeType) ||
                (attributeType == .Integer32AttributeType) ||
                (attributeType == .Integer64AttributeType) ||
                (attributeType == .BooleanAttributeType)) && (value!.isKindOfClass(NSString))) {
                    value = NSNumber(integer: (value?.integerValue)!)
            }else if ((attributeType == .FloatAttributeType) && (value!.isKindOfClass(NSString))) {
                value = NSNumber(double: value!.doubleValue)
            }else if  ((attributeType == .DateAttributeType)) {
                let doubleVal = Double((value as? String)!)
                if (doubleVal != nil) {
                    value = NSDate(timeIntervalSince1970: NSTimeInterval(doubleVal!))
                }
            }
            self.setValue(value, forKey: key as! String)
        }
    }
}

class SettingsManager: NSObject {
    
    class func loadChampionInformation() {
        let URL = NSURL(string: "https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion")
        let params = ["api_key": "9f3f7872-b097-41d7-9915-8401c2467b5f"]
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let manager = AFHTTPSessionManager()
        
        manager.GET((URL?.absoluteString)!,
            parameters: params,
            success: { (task:NSURLSessionDataTask, responseObject:AnyObject) -> Void in
                let response:NSDictionary = responseObject as! NSDictionary
                let gamesDict = response.valueForKey("data") as! NSMutableDictionary
                for (_, value) in gamesDict {
                    let tempValue = NSMutableDictionary(dictionary: value as! NSDictionary)
                    let champion = NSEntityDescription.insertNewObjectForEntityForName("Champion", inManagedObjectContext: managedContext)
                    let champId = tempValue.objectForKey("id")
                    tempValue.removeObjectForKey("id")

                    champion.safeSetValuesForKeysWithDictionary(value as! NSDictionary, dateFormatter: nil)
                    champion.setValue(champId, forKey: "champion_id")
                }
                
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
                
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
                
            }) { (NSURLSessionDataTask, NSError) -> Void in
                //
        }

    }
    
}