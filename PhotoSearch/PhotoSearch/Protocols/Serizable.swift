//
//  Serizable.swift
//  R&P
//
//  Created by Nicky on 2019-05-15.
//  Copyright © 2019 yusong. All rights reserved.
//

import Foundation



protocol Serizable {
    func save<T: MyCodable>(obj : T) -> Bool;
    func restore<T: MyCodable>(saveName : String)-> T?
}

extension Serizable {
    func save<T: MyCodable>(obj : T) -> Bool {
        
        let saveName = obj.name
        var data : Data;
        do {
            data = try JSONEncoder().encode(obj)
        } catch {
            return false
        }
        
        UserDefaults.standard.set(data, forKey: saveName)
        
        
        return true
        
    }
    
    
    func restore<T: MyCodable>(saveName : String)-> T? {
        let data = UserDefaults.standard.data(forKey: saveName)
        do {
            if let data = data {
                let model : T = try JSONDecoder().decode(T.self, from: data)
                
                return model
            } else {
                return nil
            }
        } catch {
            return nil;
        }
    }
}
