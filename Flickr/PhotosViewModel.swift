//
//  PhotosViewModel.swift
//  Flickr
//
//  Created by Brian Sunter on 7/21/16.
//  Copyright © 2016 Brian Sunter. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct PhotosViewModel {
    let photosAPI: FlickrPhotosAPI
    let queryInput: ControlProperty<String>

    func photosToDisplay() -> Driver<[FlickrPhoto]> {
        return queryInput
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<[FlickrPhoto]> in
                if query.isEmptyOrWhitespace() {
                    return self.photosAPI.getRecentPhotos()
                } else {
                    return self.photosAPI.getPhotoSearchResults(query)
                }
            }
            .retry(3)
            .asDriver(onErrorJustReturn: [])
    }
}
