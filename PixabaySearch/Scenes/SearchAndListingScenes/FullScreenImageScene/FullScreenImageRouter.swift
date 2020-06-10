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
    
    // MARK: Routing
    
    //func routeToSomewhere(segue: UIStoryboardSegue?) {
    //  if let segue = segue {
    //    let destinationVC = segue.destination as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //  } else {
    //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //    navigateToSomewhere(source: viewController!, destination: destinationVC)
    //  }
    //}
    
    // MARK: Navigation
    
    //func navigateToSomewhere(source: FullScreenImageViewController, destination: SomewhereViewController) {
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: FullScreenImageDataStore, destination: inout SomewhereDataStore) {
    //  destination.name = source.name
    //}
}
