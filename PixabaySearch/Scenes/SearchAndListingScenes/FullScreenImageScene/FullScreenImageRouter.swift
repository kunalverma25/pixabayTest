//
//  FullScreenImageRouter.swift
//  PixabaySearch
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright (c) 2020 Kunal Verma. All rights reserved.
//

import UIKit

@objc protocol FullScreenImageRoutingLogic: AnyObject {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol FullScreenImageDataPassing {
    var dataStore: FullScreenImageDataStore? { get }
}

class FullScreenImageRouter: NSObject, FullScreenImageRoutingLogic, FullScreenImageDataPassing {
    weak var viewController: FullScreenImageViewController?
    var dataStore: FullScreenImageDataStore?
}
