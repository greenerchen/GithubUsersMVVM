//
//  SearchUsersViewController.swift
//  github-users
//
//  Created by Greener Chen on 2020/3/13.
//  Copyright © 2020 Greener Chen. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift


protocol SearchUsersViewProtocol {
    func bind(viewModel: SearchUsersViewModel)
}

enum SearchUserCellId: String {
    case empty = "EmptyCell"
    case error = "ErrorCell"
    case ideal = "IdealCell"
}

class SearchUsersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // dependencies
    var viewModel: SearchUsersViewModel? = SearchUsersViewModelFactory.create(searchState: .none)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.placeholder = "Keyword of Github users"
        
        // Register cell classes
        self.collectionView!.register(UINib(nibName: "SearchUserEmptyCell", bundle: nil), forCellWithReuseIdentifier: SearchUserCellId.empty.rawValue)
        self.collectionView!.register(UINib(nibName: "SearchUserErrorCell", bundle: nil), forCellWithReuseIdentifier: SearchUserCellId.error.rawValue)
        self.collectionView!.register(UINib(nibName: "SearchUserIdealCell", bundle: nil), forCellWithReuseIdentifier: SearchUserCellId.ideal.rawValue)
        self.collectionView.register(UINib(nibName: "LoadingFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "SearchUserFooter")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        searchBar.delegate = self
        
        bind(viewModel: viewModel!)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if let users = viewModel?.users, !users.isEmpty {
            return users.count
        } else {
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellModel = viewModel!.cellModel(at: indexPath)
        let cellTypeId = viewModel!.cellTypeByState().rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellTypeId, for: indexPath) as! SearchUserBaseCell
        cell.set(model: cellModel)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter && (viewModel!.searchState.value == .loadingMore || viewModel!.searchState.value == .loading) {
            return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "SearchUserFooter", for: indexPath)
        }
        return UICollectionReusableView(frame: CGRect.zero)
    }
    
    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let users = viewModel?.users, users.count > 0,
            let nextPage = viewModel?.paginations?.next {
            if indexPath.item == users.count - 1 && (viewModel?.searchState.value != .loading && viewModel?.searchState.value != .loadingMore) {
                viewModel?.loadMoreUsers(query: searchBar!.text!, page: nextPage)
            }
        }
    }

    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.safeAreaLayoutGuide.layoutFrame.width, height: 80.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return (viewModel!.searchState.value == .loadingMore || viewModel!.searchState.value == .loading) ? CGSize(width: collectionView.safeAreaLayoutGuide.layoutFrame.width, height: 40.0) : CGSize.zero
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.loadUsers(query: searchText)
    }
}

extension SearchUsersViewController: SearchUsersViewProtocol {
    
    func bind(viewModel: SearchUsersViewModel) {
        
        viewModel.searchState.producer.startWithValues { [weak self] (state) in
            if state != .loading {
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                }
            }
        }
    }
}

