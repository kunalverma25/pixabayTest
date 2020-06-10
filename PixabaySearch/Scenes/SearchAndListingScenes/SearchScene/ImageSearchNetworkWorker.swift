//
//  ImageSearchNetworkWorker.swift
//  PixabaySearch
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright © 2020 Kunal Verma. All rights reserved.
//

import PixabayNetworkingKit

class ImageSearchNetworkWorker {
    func searchWithQuery(_ term: String, completion: @escaping (Result<ImageSearch.PixSearchResult?, Error>) -> Void) {
        SearchURLTask.fetchSearchResults(term, completion).urlDataTask?.resume()
    }
}

enum SearchPageRequest {
    case fetchSearchResults(term: String)
}

extension SearchPageRequest: NKURLRequestProtocol {
    var urlRequest: URLRequest? {
        switch self {
        case .fetchSearchResults(let term):
            let endPoint = "\(AppConstants.main.host)"
            return NKURLRequest(urlPath: endPoint, type: .get, header: nil, parameters: ["key" : AppConstants.main.pixabayAPIKey, "q": term, "image_type": "photo", "per_page": "25"]).requestObject
        }
    }
}

enum SearchURLTask {
    case fetchSearchResults(String, (Result<ImageSearch.PixSearchResult?, Error>) -> Void)
}

extension SearchURLTask: NKCodableDataTask {
    var urlDataTask: URLSessionDataTask? {
        switch self {
        case .fetchSearchResults(let term, let completion):
            guard let urlRequest = SearchPageRequest.fetchSearchResults(term: term).urlRequest else { return nil }
            return NKURLSession.sharedInstance.session?.resultTask(with: urlRequest, completion: completion)
        }
    }
}
