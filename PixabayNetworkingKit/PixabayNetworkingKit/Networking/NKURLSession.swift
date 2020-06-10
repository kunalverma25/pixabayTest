//
//  NKURLSession.swift
//  PixabayNetworkingKit
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright © 2020 Kunal Verma. All rights reserved.
//

import Foundation

public class NKURLSession: NSObject {

    public static let sharedInstance = NKURLSession()

    public var session: URLSession?
    weak var delegate: URLSessionDelegate!

    fileprivate override init() {
        super.init()
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 60
        sessionConfig.timeoutIntervalForResource = 60
        session = Foundation.URLSession(configuration: sessionConfig, delegate: self, delegateQueue: queue)
    }

}

extension NKURLSession: URLSessionDelegate {

    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // Handle SSL pinning etc here
        completionHandler(.performDefaultHandling, challenge.proposedCredential)
    }

}

extension URLSession {
    
    public func simpleDataTask(with request: URLRequest, completion: ((Result<Data?, Error>) -> Void)? = nil) -> URLSessionDataTask {
        return self.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    #if DEBUG
                    let reqString = "\n------------------------------\n\(request.httpMethod ?? "") URL     :  \(request.url?.absoluteString ?? "") \nHeader       :  \(request.allHTTPHeaderFields ?? [:]) \nRequestBody         : \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "") \nRecieved Error         : \(error?.localizedDescription ?? "") \n------------------------------\n"
                    print(reqString)
                    #endif
                    completion?(.failure(error ?? NKError(message: nil)))
                    return
                }
                #if DEBUG
                let reqString = "\n------------------------------\n\(request.httpMethod ?? "") URL     :  \(request.url?.absoluteString ?? "") \nHeader       :  \(request.allHTTPHeaderFields ?? [:]) \nRequestBody         : \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "") \nRecieved Data         : \(String(data: data, encoding: .utf8) ?? "") \n------------------------------\n"
                print(reqString)
                #endif
                completion?(.success(data))
            }
        }
    }
    
    public func resultTask<T: Decodable>(with request: URLRequest, decodingType: APIDecodingType = .json, completion: ((Result<T?, Error>) -> Void)? = nil) -> URLSessionDataTask {
        return self.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    #if DEBUG
                    let reqString = "\n------------------------------\n\(request.httpMethod ?? "") URL     :  \(request.url?.absoluteString ?? "") \nHeader       :  \(request.allHTTPHeaderFields ?? [:]) \nRequestBody         : \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "") \nRecieved Error         : \(error?.localizedDescription ?? "") \n------------------------------\n"
                    print(reqString)
                    #endif
                    completion?(.failure(error ?? NKError(message: nil)))
                    return
                }
                #if DEBUG
                let reqString = "\n------------------------------\n\(request.httpMethod ?? "") URL     :  \(request.url?.absoluteString ?? "") \nHeader       :  \(request.allHTTPHeaderFields ?? [:]) \nRequestBody         : \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "") \nRecieved Data         : \(String(data: data, encoding: .utf8) ?? "") \n------------------------------\n"
                print(reqString)
                #endif
                do {
                    let response = try ResponseDecoder(decodingType).decode(T.self, from: data)
                    completion?(.success(response))
                } catch {
                    completion?(.failure(error))
                }
            }
        }
    }
    
}

public protocol NKCodableDataTask {
    var urlDataTask: URLSessionDataTask? { get }
}

public protocol NKURLRequestProtocol {
    var urlRequest: URLRequest? { get }
}
