//
//  ImageSearchViewController.swift
//  PixabaySearch
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright (c) 2020 Kunal Verma. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

protocol ImageSearchDisplayLogic: AnyObject {
    func setSearchQueriesInView(queries: [String])
    func showResultList()
    func showLoader()
    func hideLoader()
    func showError(_ errorMessage: String)
}

class ImageSearchViewController: UIViewController, ImageSearchDisplayLogic {
    var interactor: ImageSearchBusinessLogic?
    var router: (NSObjectProtocol & ImageSearchRoutingLogic & ImageSearchDataPassing)?
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variables
    var searchController: UISearchController?
    var progressIndicator: ProgressIndicator?
    var searchQueries: [String] = []
    
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
        let interactor = ImageSearchInteractor()
        let presenter = ImageSearchPresenter()
        let router = ImageSearchRouter()
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
        self.title = "Search Pixabay"
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Type something here to search"
        searchController?.searchBar.delegate = self
        navigationItem.searchController = searchController
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if progressIndicator == nil {
            progressIndicator = ProgressIndicator(withView: self.view)
            setupStartingView()
        }
    }
    
    // MARK: View Logic
    func setupStartingView() {
        interactor?.fetchSavedQueries()
    }
    
    func setSearchQueriesInView(queries: [String]) {
        searchQueries = queries
        self.reloadTable()
    }
    
    func showLoader() {
        progressIndicator?.showProgressView()
    }
    
    func hideLoader() {
        progressIndicator?.hideProgressView()
    }
    
    func showResultList() {
        searchController?.searchBar.text = nil
        self.performSegue(withIdentifier: R.segue.imageSearchViewController.resultList, sender: nil)
    }
    
    func showError(_ errorMessage: String) {
        let alert = UIAlertController(title: errorMessage, message: nil, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
    
    func reloadTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.reloadData()
    }
}

extension ImageSearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        interactor?.searchImages(query: text)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        interactor?.fetchSavedQueries()
        reloadTable()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        reloadTable()
    }
}

extension ImageSearchViewController: UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController?.searchBar.isFirstResponder == true {
            return searchQueries.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.text = searchQueries[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let query = searchQueries[indexPath.row]
        searchController?.searchBar.text = query
        searchController?.searchBar.resignFirstResponder()
        interactor?.searchImages(query: query)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var text = "Let's Search Some Images!"
        if searchController?.searchBar.isFirstResponder == true {
            text = "No Recent Searches"
        }
        
        return NSAttributedString(string: text, attributes: [.foregroundColor : UIColor.systemRed, .font: UIFont.boldSystemFont(ofSize: 15)])
    }
}
