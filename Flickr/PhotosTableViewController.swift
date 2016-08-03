//
//  PhotosTableViewController.swift
//  Flickr
//
//  Created by Brian Sunter on 7/21/16.
//  Copyright © 2016 Brian Sunter. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class PhotosTableViewController: UITableViewController {
    var viewModel: PhotosViewModel!

    let disposeBag = DisposeBag()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = PhotosViewModel(photosAPI: DefaultFlickrAPI(), queryInput: searchController.searchBar.rx_text)

        tableView.dataSource = nil
        tableView.delegate = self

        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        viewModel.photosToDisplay()
            .drive(tableView.rx_itemsWithCellIdentifier("PhotoCell", cellType: PhotoCell.self)) {(row, flickrPhoto, cell) in
                cell.authorLabel.text = flickrPhoto.author
                cell.titleView.text = flickrPhoto.title
                cell.photoView.kf_setImageWithURL(flickrPhoto.url, placeholderImage: UIImage(named: "default-placeholder.png"))
            }.addDisposableTo(disposeBag)
    }

    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.None
    }

    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if let visiblePaths = tableView.indexPathsForVisibleRows {
            tableView.reloadRowsAtIndexPaths(visiblePaths, withRowAnimation: UITableViewRowAnimation.None)
        }
    }

    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if self.searchController.searchBar.isFirstResponder() && (false == self.searchController.isBeingPresented()) {
            self.searchController.searchBar.resignFirstResponder()
        }
    }
}
