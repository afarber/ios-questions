//
//  ValuesToDataTransformer.swift
//  TransApp
//
//  Created by Alexander Farber on 05.12.21.
//

import Foundation

class ValuesToDataTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let valuesArray = value as? [[Int32?]] else { return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject:valuesArray, requiringSecureCoding: true)
            return data
        }
        catch
        {
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any?
    {
        guard let data = value as? Data else { return nil }
        
        do {
            let valuesArray = try NSKeyedUnarchiver.unarchivedObject(ofClass:[[Int32?]].self, from: data)
            return valuesArray
        }
        catch
        {
            return nil
        }
    }
}
