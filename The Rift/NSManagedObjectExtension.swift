//
//  NSManagedObjectExtension.swift
//  The Rift
//
//  Created by Thomas.Demeo on 1/1/16.
//  Copyright © 2016 American Well. All rights reserved.
//

import CoreData

//extension NSManagedObject {
//    func safeSetValuesForKeysWithDictionary(keyedValues: NSDictionary) {
//        let attributes:NSDictionary = self.entity.attributesByName
//        
//        for (key, _) in attributes {
//            var value = keyedValues.objectForKey(key)
//            if (value == nil) {
//                // Don't attempt to set nil, or you will overwrite values in self that aren't present in key
//                continue;
//            }
//            let attributeType = attributes.objectForKey(key)?.attributeType
//            if ((attributeType == .StringAttributeType) && (value!.isKindOfClass(NSNumber))) {
//                value = value?.stringValue
//            } else if (((attributeType == .Integer16AttributeType) ||
//                            (attributeType == .Integer32AttributeType) ||
//                                (attributeType == .Integer64AttributeType) ||
//                                    (attributeType == .BooleanAttributeType)) && (value!.isKindOfClass(NSString))) {
//                value = NSNumber(integer: (value?.integerValue)!)
//            }else if ((attributeType == .FloatAttributeType) && (value!.isKindOfClass(NSString))) {
//                value = NSNumber(double: value!.doubleValue)
//            }
//            self.setValue(value, forKey: key as! String);
//        }
//    }
//}