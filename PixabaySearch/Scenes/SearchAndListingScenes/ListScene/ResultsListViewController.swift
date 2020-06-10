//
//  ResultsListViewController.swift
//  PixabaySearch
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright (c) 2020 Kunal Verma. All rights reserved.
//

import UIKit

protocol ResultsListDisplayLogic: AnyObject {
    func updateTable(for indexPaths: [IndexPath])
}

class ResultsListViewController: UIViewController, ResultsListDisplayLogic {
    var interactor: ResultsListBusinessLogic?
    var router: (NSObjectProtocol & ResultsListRoutingLogic & ResultsListDataPassing)?
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
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
        let interactor = ResultsListInteractor()
        let presenter = ResultsListPresenter()
        let router = ResultsListRouter()
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
        self.title = "Search Results"
        tableView.register(R.nib.resultListingCell)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LoadingCell")
        tableView.rowHeight = 150
        reloadTable()
    }
    
    // MARK: View Logic
    //
    
    func updateTable(for indexPaths: [IndexPath]) {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        tableView.reloadRows(at: Array(indexPathsIntersection), with: .automatic)
    }
    
    func reloadTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.reloadData()
    }
}

extension ResultsListViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return router?.dataStore?.searchResult?.totalHits ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoadingCell(for: indexPath) {
            return getLoadingCell(from: tableView)
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.resultListingCell, for: indexPath) else {
            return UITableViewCell()
        }
        guard let data = router?.dataStore?.searchResult?.imageList?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configureCell(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ResultListingCell else {
            return
        }
        cell.cancelImageDownload()
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            interactor?.fetchMoreImages()
        }
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= router?.dataStore?.searchResult?.imageList?.count ?? 0
    }
    
    func getLoadingCell(from tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell") ?? UITableViewCell()
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .systemRed
        cell.contentView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
        return cell
    }
    
}
