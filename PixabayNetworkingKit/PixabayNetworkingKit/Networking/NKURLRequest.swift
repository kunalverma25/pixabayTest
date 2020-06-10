//
//  NKURLRequest.swift
//  PixabayNetworkingKit
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright © 2020 Kunal Verma. All rights reserved.
//

import Foundation

public enum NKURLRequestType: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case head    = "HEAD"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case options = "OPTIONS"
    case trace   = "TRACE"
}

public class NKURLRequest {
    
    public var requestObject: URLRequest?
    
    public init(urlPath: String, type: NKURLRequestType, header: [String: String]? = nil, parameters: [String: String]? = nil, body: Any? = nil) {
        var queryString = urlPath.range(of: "?") != nil ? "&" : "?"
        if let params = parameters {
            for (key, value) in params {
                queryString += key + "=" + value + "&"
            }
        }
        
        if let encodedString = queryString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            queryString = encodedString
        }
        
        if let url = URL(string: urlPath + queryString) {
            requestObject = URLRequest(url: url)
            if let body = body as? [String: Any] {
                self.requestObject?.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            } else if let body = body as? String {
                self.requestObject?.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                self.requestObject?.httpBody = body.data(using: String.Encoding.utf8)
            } else if let body = body as? [[String:Any]] {
                self.requestObject?.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            } else if let body = body as? Data {
                self.requestObject?.httpBody = body
            }
            self.requestObject?.timeoutInterval = 60
            
            #if DEBUG
                let reqString = "\n------------------------------\n\(type.rawValue) URL     :  \(url.absoluteString) \nHeader       :  \(requestObject?.allHTTPHeaderFields ?? [:]) \nParameters   : \(parameters ?? [:])  \nBody         : \(String(data: requestObject?.httpBody ?? Data(), encoding: .utf8) ?? "") \n------------------------------\n"
                print(reqString)
            #endif
        }
    }
}
