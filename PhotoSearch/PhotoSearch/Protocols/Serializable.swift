

import Foundation



protocol Serializable {
    func save<T: MyCodable>(obj : T) -> Bool;
    func restore<T: MyCodable>(saveName : String)-> T?
}

extension Serializable {
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
