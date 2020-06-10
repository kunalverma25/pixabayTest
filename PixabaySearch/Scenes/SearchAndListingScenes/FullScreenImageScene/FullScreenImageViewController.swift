//
//  FullScreenImageViewController.swift
//  PixabaySearch
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright (c) 2020 Kunal Verma. All rights reserved.
//

import UIKit

protocol FullScreenImageDisplayLogic: AnyObject {
    func displaySomething()
}

class FullScreenImageViewController: UIViewController, FullScreenImageDisplayLogic {
    var interactor: FullScreenImageBusinessLogic?
    var router: (NSObjectProtocol & FullScreenImageRoutingLogic & FullScreenImageDataPassing)?
    
    // MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = FullScreenImageInteractor()
        let presenter = FullScreenImagePresenter()
        let router = FullScreenImageRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doSomething()
    }
    
    // MARK: View Logic
    
    func doSomething() {
        interactor?.doSomething()
    }
    
    func displaySomething() {
        //nameTextField.text = viewModel.name
    }
}
