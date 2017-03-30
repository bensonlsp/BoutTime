//
//  EmperorsProvider.swift
//  BoutTime
//
//  Created by Benson Lo on 26/3/2017.
//  Copyright © 2017年 Benson Lo. All rights reserved.
//

import Foundation

// Protocol of a dynasty class
protocol Dynasty {
    var emperors: [String: Emperor] { get set }
    init(emperors: [String: Emperor])
    func loadEmperor(ofOrder order: Int) -> Emperor?
}

// Struct to store data of an emperor (i.e. compared to individual event as requested by the project)
struct Emperor {
    // The name of the emperor
    let name: String
    // The order of the emperor in the Han history from far to recent
    let order: Int
    // The year is when the emperor began to rule the country
    // For positive number of year, such as 30, it means the year of 30AD
    // For negative number of year, such as -56, it means the year of 56BC
    let year: Int
    // The brief description of the emperor
    let description: String
    // It's the link to the web site about the details of the emperor in Wikipedia
    let wikiLink: String
}

// Error enum to handle error when randing emperor data from Plist
enum PlistError: Error {
    case invalidResource
    case conversionFailure
    case invalidEntry
}

// Function to read dictionary data of emperors from Plist
class PlistConverter {
    static func dictionary(fromFile name: String, ofType type: String) throws  -> [String: AnyObject] {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            throw PlistError.invalidResource
        }
        
        guard let dictionary = NSDictionary(contentsOfFile: path) as? [String:AnyObject] else {
            throw PlistError.conversionFailure
        }

        return dictionary
    }
}

// To convert the emperor data from Plist into an dictionary array of emperor struct
// The key is the emperor name
// The value is an emperor struct
class EmperorUnarchiver {
    static func emperorInventory(fromDictionary dictionary: [String:AnyObject]) throws -> [String: Emperor] {
        var emperors: [String: Emperor] = [:]
        for (key,value) in dictionary {
                if let itemDictionary = value as? [String: Any],
                let order = itemDictionary["order"] as? Int,
                let year = itemDictionary["year"] as? Int,
                let description = itemDictionary["description"] as? String,
                let wikiLink = itemDictionary["wikiLink"] as? String {
                
                let emperor = Emperor(name: key, order: order, year: year, description: description, wikiLink: wikiLink)
                
                emperors.updateValue(emperor, forKey: key)
            } else {
                throw PlistError.invalidEntry
            }
        }
        
        return emperors
    }
}

// The class to store emperors of Han Dynasty in Ancient China
// The data will be used in the BoutTime game
// The history event will be the emperor name and his description
// Player has to put the emperor into order according to their year of ruling the country
class HanDynasty: Dynasty {
    var emperors: [String: Emperor]
    
    required init(emperors: [String: Emperor]) {
        self.emperors = emperors
    }
    
    // Return an emperor and his description by his order in the dynasty
    func loadEmperor(ofOrder order: Int) -> Emperor? {
        for (key,value) in emperors {
            if value.order == order {
                if let emperor = emperors[key] {
                    return emperor
                }
            }
        }
        
        return nil
    }
    
    // Return four emperors in an array randomly
    func returnFourRandomEmperors() -> [Emperor] {
        var fourEmperors: [Emperor] = []
        
        let randomOrder1 = randomInt(from: 1, to: emperors.count)
        if let emperor = loadEmperor(ofOrder: randomOrder1) {
            fourEmperors.append(emperor)
        }
        
        var randomOrder2 = randomInt(from: 1, to: emperors.count)
        while randomOrder2 == randomOrder1 {
            randomOrder2 = randomInt(from: 1, to: emperors.count)
        }
        if let emperor = loadEmperor(ofOrder: randomOrder2) {
            fourEmperors.append(emperor)
        }
        
        var randomOrder3 = randomInt(from: 1, to: emperors.count)
        while randomOrder3 == randomOrder1 ||
            randomOrder3 == randomOrder2 {
            randomOrder3 = randomInt(from: 1, to: emperors.count)
        }
        if let emperor = loadEmperor(ofOrder: randomOrder3) {
            fourEmperors.append(emperor)
        }
        
        var randomOrder4 = randomInt(from: 1, to: emperors.count)
        while randomOrder4 == randomOrder1 ||
            randomOrder4 == randomOrder2 ||
            randomOrder4 == randomOrder3 {
                randomOrder4 = randomInt(from: 1, to: emperors.count)
        }
        if let emperor = loadEmperor(ofOrder: randomOrder4) {
            fourEmperors.append(emperor)
        }
        
        return fourEmperors
    }
}
