//
//  TilesToDataTransformer.swift
//  TransApp
//
//  Created by Alexander Farber on 05.12.21.
//

import Foundation

class TilesToDataTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSString.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    // [TileModel]? -> String
    override func transformedValue(_ value: Any?) -> Any? {
        guard let array = value as? [TileModel]? else { return nil }
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(array)
            let str = String(data: data, encoding: .utf8)
            return str
        }
        catch {
            return nil
        }
    }
    
    // String -> [TileModel?]
    override func reverseTransformedValue(_ value: Any?) -> Any?
    {
        guard let str = value as? String else { return nil }
        
        let decoder = JSONDecoder()

        do {
            let data = str.data(using: .utf8)!
            let array = try decoder.decode([TileModel]?.self, from: data)
            return array
        }
        catch {
            return nil
        }
    }
}

extension NSValueTransformerName {
    static let tilesToDataTransformer = NSValueTransformerName(rawValue: "TilesToDataTransformer")
}
