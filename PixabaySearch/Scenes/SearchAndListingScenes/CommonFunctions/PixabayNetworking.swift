//
//  PixabayNetworking.swift
//  PixabaySearch
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright © 2020 Kunal Verma. All rights reserved.
//

import PixabayNetworkingKit
import UIKit

class ImageSearchNetworkWorker {
    func searchWithQuery(_ term: String, page: Int = 1, completion: @escaping (Result<PixSearchResult?, Error>) -> Void) {
        SearchURLTask.fetchSearchResults(term: term, page: page, completion: completion).urlDataTask?.resume()
    }
    
    // Make a download queue here to add images
    func downloadAndSaveImage(url: String) {
        SearchURLTask.downloadImage(url: url) { (result) in
            guard let data = try? result.get(), let image = UIImage(data: data) else {
                return
            }
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }.urlDataTask?.resume()
    }
}

enum SearchPageRequest {
    case fetchSearchResults(term: String, page: Int)
    case downloadImage(url: String)
}

extension SearchPageRequest: NKURLRequestProtocol {
    var urlRequest: URLRequest? {
        switch self {
        case .fetchSearchResults(let term, let page):
            let endPoint = "\(AppConstants.main.host)"
            return NKURLRequest(urlPath: endPoint, type: .get, header: nil, parameters: ["key" : AppConstants.main.pixabayAPIKey, "q": term, "image_type": "photo", "per_page": "25", "page": "\(page)"]).requestObject
        case .downloadImage(let url):
            return NKURLRequest(urlPath: url, type: .get).requestObject
        }
    }
}

enum SearchURLTask {
    case fetchSearchResults(term: String, page: Int, completion: (Result<PixSearchResult?, Error>) -> Void)
    case downloadImage(url: String, completion: (Result<Data?, Error>) -> Void)
}

extension SearchURLTask: NKCodableDataTask {
    var urlDataTask: URLSessionDataTask? {
        switch self {
        case .fetchSearchResults(let term, let page, let completion):
            guard let urlRequest = SearchPageRequest.fetchSearchResults(term: term, page: page).urlRequest else { return nil }
            return NKURLSession.sharedInstance.session?.resultTask(with: urlRequest, completion: completion)
        case .downloadImage(let url, let completion):
            guard let urlRequest = SearchPageRequest.downloadImage(url: url).urlRequest else { return nil }
            return NKURLSession.sharedInstance.session?.simpleDataTask(with: urlRequest, completion: completion)
        }
    }
}
