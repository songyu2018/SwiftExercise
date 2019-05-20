//
//  NetworkFacilities.swift
//  NetworkFramework
//
//  Created by Yu Song on 2019-03-05.
//  Copyright © 2019 yusong. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

public enum DataTaskState: String {
    case undefined = "Undefined"
    case active = "Active"
    case suspended = "Suspended"
    case cancelled = "Cancelled"
}

public protocol NetworkFacilities {
    var dataTaskState: DataTaskState {get set}
    func dataTask(method: HTTPMethod, sURL: String, headers dictHeaders: Dictionary<String, String>?, body dictBody: Dictionary<String, Any>?, completion: @escaping (Bool, Dictionary<String, Any>) -> ())
    init(dataTaskState: DataTaskState)
}


public extension NetworkFacilities {
    func dataTask(method: HTTPMethod, sURL: String, headers dictHeaders: Dictionary<String, String>?, body dictBody: Dictionary<String, Any>?, completion: @escaping (Bool, Dictionary<String, Any>) -> ()) {
        var dictResponse: [String:Any] = ["__REQUEST__": ["URL": sURL, "METHOD": method.rawValue], "__CARRIER__": self]
        if let url = URL(string: sURL) {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            var dictHeaders: [String:String] = dictHeaders ?? [:]
            let contentType = dictHeaders["content-type"]
            if contentType == nil {
                dictHeaders["content-type"] = "application/json"
            }
            for (httpHeaderField, value) in dictHeaders {
                request.addValue(value, forHTTPHeaderField: httpHeaderField)
            }
            if (dictBody != nil) && (dictBody!.count > 0) {
                request.httpBody = try! JSONSerialization.data(withJSONObject: dictBody!, options: [])
            }
            
            _ = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    if self.dataTaskState == .active {
                        if let _ = urlResponse,
                            let data = data,
                            let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                            dictResponse["__RESPONSE__"] = jsonData
                            completion(true, dictResponse)
                        } else {
                            dictResponse["__ABNORMAL__"] = "Abnormal in response."
                            completion(false, dictResponse)
                        }
                    }
                    else {
                        print("Response discarded due to data task state(\(self.dataTaskState.rawValue)).")
                        // suspended or cancelled, does not expect responding
                        // let dictResponse = ["__DISCARDED__":"Response discarded due to data task state(\(self.dataTaskState.rawValue))."]
                        // completion(dictResponse, urlResponse, error)
                    }
                })}.resume()
        }
        else {
            dictResponse["__RESPONSE__"] = "Invalid URL"
            completion(false, dictResponse)
        }
    }
}
